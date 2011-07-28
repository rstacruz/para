title: Para
--
Super-simple parallel testing

#### Parallel testing
Para is a simple test framework with one killer feature: your tests will be 
ran in parallel. This example below will have all tests take place 
simultaneously.

    $ gem install para

#### Creating tests
Create tests by subclassing `Para::Test`.

    [mytest.rb (rb)]
    require 'para'

    class MyTest < Para::Test
      enable_parallel

      setup do
        @nothing = nil
      end

      test "assertions" do
        3.should == 3
        100.should >= 3
        @nothing.should.be.nil
        sleep 1          # <-- stop for 1 second!
      end

      test "arrays" do
        %w[2 3 4].should.be.kind_of(Array)
        sleep 1          # <-- stop for 1 second!
      end

      test "failure" do
        3.should == 4    # <-- this will fail
      end

      test "error" do
        100 / 0          # <-- this will produce an error
      end
    end

#### Run
Notice how this takes **1** second to run. It should otherwise take **2** 
seconds in another testing framework (notice the two `sleep`s in the code).

    $ ruby mytest.rb

    ..FE

    Failed: 3 is not equal to 4.
      mytest.rb:6:in `test_failure'

    Error: ZeroDivisionError: divided by 0
      mytest.rb:24:in `/'
      mytest.rb:24:in `test_failure'

    Finished in 1.00204 seconds.
    5 assertions, 4 passed, 1 failures, 1 errors

Threads
-------

#### Thread management
Use `enable_parallel` to make your tests run in different threads.
different thread. To find out which thread you're on, use `#thread`.

    class MyTest < Para::Test
      enable_parallel

      setup do
        # `thread` will return an integer between 0 and 2.
        port = 6379 + thread
        @redis = Redis.connect("redis://127.0.0.1:#{port}")
      end
    end

#### Adding more threads
To run with a maximum of 3 threads, set the `THREAD` environment
variable.

    $ THREADS=3 ruby mytest.rb

Setup/teardown
--------------

#### Setup and teardown
Define a `setup` and/or `teardown` block to define what will be ran before and 
after each test.

    class MyTest < Para::Test
      setup do
        @book = Book.find_or_create(:name => "Darkly Dreaming Dexter")
      end

      teardown do
        @book.destroy
      end

      test "name" do
        @book.name.should == "Darkly Dreaming Dexter"
      end
    end


Should
------

#### RSpec-style assertions
More RSpec-like assertions are supported.

    test "asserting equality" do
      3.should == 3
    end

    .should.equal (or should ==)
    .should.be (or should ===)
    .should.be.nil
    .should.be.close(number, delta)
    .should.match(regex), (or .should =~)
    .should.be.an.instance_of(klass)
    .should.be.a.kind_of(klass)
    .should.respond_to(method)
    .should.raise(exception)
    .should.throw(symbol)
    .should.satisfy { ... }

#### be, a, an
You can add `.be`, `.a`, and `.an` -- they do nothing. These two work the same 
way.

    3.should.be == 3
    3.should == 3

#### Negating tests
You can negate a test by adding `.not`. (eg: `.should.not.be.nil`)

    3.should.not == 3
    object.should.respond_to(:call)

Test::Unit
----------

#### Test::Unit backward compatibility
Migrate your current tests to Para by changing `require 'test/unit'` to
`require 'para/test/unit'`. This will give you `Test::Unit::TestCase`.

    require 'para/test/unit'

    class Test::Unit::TestCase
      def test_something
        assert "It works!".size > 0
      end
    end

#### Test::Unit-style assertions
Minitest/Test::Unit assertions are also supported.

    test "assertions" do
      assert true
      assert_equal 3, 3
      assert_equal @something, 3, "The variable @something was set wrong."
    end

    assert STATEMENT
    assert_equal X, Y
    assert_not_equal X, Y
    assert_same X, Y
    assert_not_same X, Y
    assert_nil X
    assert_not_nil X
    assert_include HAYSTACK, NEEDLE
    assert_in_delta X, Y[, DELTA]
    assert_match REGEX, STRING
    assert_no_match REGEX, STRING
    assert_instance_of TYPE, OBJECT
    assert_kind_of TYPE, OBJECT
    assert_respond_to OBJECT, METHOD
    assert_raises EXCEPTION { ... }
    assert_nothing_raised { ... }
    assert_throws SYMBOL { ... }
    assert_nothing_thrown { ... }
    assert_block { ... }

#### Refute
If you replace `assert` with `refute` (eg, `refute_nil`), it will work in 
reverse.

    # These two are the name
    refute_equal 2, 3
    assert_not_equal 2, 3

#### Test::Unit-style tests
You can also define tests by making a method that starts with `test_`.
The `setup` and `teardown` methods are also supported.

    class MyTest < Para::Test
      def setup
        @three = 3
      end

      def test_equality
        @three.should == 3
        assert_equal @three, 3
      end
    end

## Nested tests

#### Nested tests
You can nest tests using `describe` or `context` (both are synonyms).

    class MyTest < ParaTest
      setup do
        @number = 100
      end

      test "number" do
        @number.should == 100
      end

      context "Subcontext" do
        setup do
          # This will be ran after the first `setup` block above.
          @number += 10
        end

        test "number, again" do
          @number.should == 110
        end
      end
    end

## Acknowledgements

*Note: this is a proof-of-concept project and was never envisioned to be used 
in production.*

* Assertion API modeled after Test::Unit
* RSpec-like assertions taken from [REnvy](http://github.com/rstacruz/renvy)
* Nested tests taken from [Contest](http://github.com/citrusbyte/contest)

MIT license.

[GitHub](http://github.com/rstacruz/para "Source code")
