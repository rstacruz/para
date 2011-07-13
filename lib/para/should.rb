# Rspec-like matching for Test::Unit.
#
# == Usage
#
#   obj.should == 2
#   obj.should ~= /regex/
#   obj.should != 3
#   obj.should.be.true!
#   obj.should.be.false!
#
#   # Anything else will just pass thru:
#   obj.should.nil?     # same as: assert obj.nil?
#   obj.should.be.nil?  # same as: assert obj.nil?
#   obj.should.respond_to?(:freeze)
#
#   # You can also use should_not:
#   obj.should_not == 3
#   obj.should_not.be.nil?
#
#   should.raise(Error) { lol }
#   should_not.raise { puts "hi" }
#
module Para
  class Should
    attr_reader :left
    attr_reader :msg

    def self.init(test) # :nodoc:
      @@test = test
    end

    # Includes a module to extend .should with more matchers.
    def self.add(extension)
      self.send :include, extension
    end

    def initialize(left, neg=false)
      @left = left
      @neg  = neg
    end

    def be(right=nil) self.same(right)  if right; self; end
    def a()  self; end
    def an() self; end

    def negative?() @neg; end
    def positive?() !@neg; end
    def test()      @@test; end
    def not()       @neg = true; self; end

    def blaming(msg);   @msg = msg; self; end
    def messaging(msg); @msg = msg; self; end

    def ==(right)             assert_or_refute :equal, right, left; end
    def !=(right)             assert_or_refute_not :equal, right, left; end
    def =~(right)             assert_or_refute :match, right, left; end
    def >(right)              assert_or_refute :operator, left, :>,  right; end
    def <(right)              assert_or_refute :operator, left, :<,  right; end
    def >=(right)             assert_or_refute :operator, left, :>=, right; end
    def <=(right)             assert_or_refute :operator, left, :<=, right; end
    def include(right)        assert_or_refute :includes, left, right; end
    def instance_of(right)    assert_or_refute :instance_of, right, left; end
    def kind_of(right)        assert_or_refute :kind_of, right, left; end
    def nil()                 assert_or_refute :nil, left; end
    def same(right)           assert_or_refute :same, right, left; end
    def respond_to(right)     assert_or_refute :respond_to, left, right; end
    def empty()               assert_or_refute :empty, left; end
    def satisfy(&blk)         assert_or_refute :block, &blk; end

    def match(right)          self =~ right; end
    def equal(right)          self == right; end

    def close(right, d=0.001)       assert_or_refute :in_delta, right, left, d; end
    def in_epsilon(right, d=0.001)  assert_or_refute :in_epsilon, right, left, d; end

    def assert_or_refute(what, *args, &blk)
      test.send (positive? ? :"assert_#{what}" : :"refute_#{what}"), *args, msg, &blk
    end

    def assert_or_refute_not(what, *args)
      test.send (negative? ? :"assert_#{what}" : :"refute_#{what}"), *args, msg
    end

    def throw(what=nil, &blk)
      if positive?
        test.send :assert_throws, what, msg, &blk
      else
        test.send :assert_nothing_thrown, msg, &blk
      end
    end

    def raise(ex=StandardError, &blk)
      if positive?
        test.send :assert_raises, ex, msg, &blk
      else
        test.send :assert_nothing_raised, msg, &blk
      end
    end

    def method_missing(meth, *args, &blk)
      result = left.send(:"#{meth}?", *args, &blk)
      method = positive? ? :assert : :refute

      args = [result]
      args << msg  if msg

      test.send method, *args
    end
  end
end

class Object
  def should
    Para::Should.new(self)
  end

  def should_not
    Para::Should.new(self, true)
  end
end

class Para::Test
  alias old_setup setup
  def setup(&blk)
    old_setup &blk
    Para::Should.init self
  end
end
