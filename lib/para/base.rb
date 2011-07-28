# Multi-threaded tester.

module Para
  class Runner
    def thread_count()    (ENV['THREADS'] || 1).to_i; end
    def printer()         @printer ||= Printer.new; end

    # Worker
    def worker!(q, i)
      if i == 0
        # For the first thread, just take the next test.
        while q.any?
          run_test i, *q.shift
        end
      else
        # For other threads, only work on the ones that are enabled for parallel.
        while true
          test = q.detect { |(testcase, _)| testcase.parallel? } or break
          q.delete test
          run_test i, *test
        end
      end
    end

    # Spawn multiple threads, each doing #work!
    def start!
      Signal.trap("INT") { printer.done; exit }

      queue = Test.all_tests
      threads = (thread_count-1).times.map { |i| Thread.new { worker!(queue, i+1) } }

      worker!(queue, 0)
      threads.join

      printer.done
    end

    def run_test(i, testcase, test)
      s = testcase.new(self, i)
      s.setup
      s.send test
      s.teardown
    rescue => e
      printer.error e
    end
  end

  class Test
    # Register new cases as they are subclassed
    def self.inherited(b)   cases << b; end
    def self.cases()        @@cases ||= Array.new; end

    # Find tests
    def self.all_tests()    cases.inject([]) { |arr, s| arr += s.tests }; end
    def self.tests()        (public_instance_methods - Test.public_instance_methods).select { |i| i =~ /^test_/ }.map { |i| [self, i] }; end

    def initialize(r, i)    @runner = r; @thread = i; end
    def failures()          @failures ||= Array.new; end

    attr_reader :thread

    # Stubs for teardown/setup
    def teardown(); end
    def setup(); end

    def self.enable_parallel()  @parallel = true; end
    def self.disable_parallel() @parallel = false; end
    def self.parallel?()        !! @parallel; end

    def assert(what, msg=nil)
      if what
        @runner.printer.success
      else
        msg ||= yield  if block_given?
        failures << [msg, Para.clean_trace(caller)]
        @runner.printer.failure *failures.last
      end
    end
  end

  class Printer
    def color(str, c)       "\033[0;#{c}m#{str}\033[0m" end
    def color(str, c)       "\033[0;#{c}m#{str}\033[0m" end
    def failure(*a)         print color('F', '1;37;41'); @total += 1; @failures << a; end
    def success()           print color('.', '1;37;42'); @total += 1; @successes += 1; end
    def error(e)            print color('E', '1;37;40'); @total += 1; @errors << e; end

    def done()
      puts "\n\n";
      print_failures
      puts "Finished in #{Time.now-@start} seconds."
      puts "#{@total} assertions, #{@successes} passed, #{@failures.count} failures, #{@errors.count} errors"
    end

    def initialize
      @start     = Time.now
      @successes = 0
      @total     = 0
      @errors    = Array.new
      @failures  = Array.new
    end

    def print_failures
      @failures.each { |(msg, trace)|
        puts "#{color('Failed:', 31)} #{msg}"
        puts trace.map { |s| "  #{s}" }.join("\n")
        puts
      }
      @errors.each { |e|
        puts "#{color('Error:', 31)} #{e.class}: #{e.message}"
        puts Para.clean_trace(e.backtrace).map { |s| "  #{s}" }.join("\n")
        puts
      }
    end
  end
end

at_exit { Para::Runner.new.start! }
