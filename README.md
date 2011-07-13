# Para
#### Super-simple parallel testing

*Note: this is a proof-of-concept project and was never envisioned to be used in production.*

Para is a simple test framework with one killer feature: your tests will be 
ran in parallel. This example below will have all tests take place 
simultaneously.

``` ruby
# mytest.rb
require 'para'

class MyTest < Para::Test
  setup do
    @nothing = nil
  end

  test "assertions" do
    3.should == 3
    100.should >= 3
    @nothing.should.be.nil
  end

  test "arrays" do
    %w[2 3 4].should.be.kind_of(Array)
  end

  test "failure" do
    3.should == 4    # this will fail
  end

  test "error" do
    100 / 0          # this will produce an error
  end
end
```

Run:

    $ ruby mytest.rb

    ..FE

    Failed: 3 is not equal to 4.
      mytest.rb:6:in `test_failure'

    Error: ZeroDivisionError: divided by 0
      mytest.rb:24:in `/'
      mytest.rb:24:in `test_failure'

    Finished in 0.00204 seconds.
    5 assertions, 4 passed, 1 failures, 1 errors

To run with a maximum of 3 threads:

    $ THREADS=3 ruby mytest.rb

Each test will be ran in a different thread. To find out which thread you're 
on, use `#thread`.

``` ruby
class MyTest < Para::Test
  setup do
    # `thread` will return an integer between 0 and 2.
    port = 6379 + thread
    @redis = Redis.connect("redis://127.0.0.1:#{port}")
  end
end
```

## RSpec-style assertions

More RSpec-like assertions are supported.

``` ruby
test "asserting equality" do
  3.should == 3
end
```

 * `.should.equal` (or `should ==`)
 * `.should.be` (or `should ===`)
 * `.should.be.nil`
 * `.should.be.close(number, delta)`
 * `.should.match(regex)`, (or `.should =~`)
 * `.should.be.an.instance_of(klass)`
 * `.should.be.a.kind_of(klass)`
 * `.should.respond_to(method)`
 * `.should.raise(exception)`
 * `.should.throw(symbol)`
 * `.should.satisfy { ... }`

## Test::Unit-style assertions

Minitest/Test::Unit assertions are also supported.

``` ruby
test "assertions" do
  assert true
  assert_equal 3, 3
  assert_equal @something, 3, "The variable @something was set wrong."
end
```

* `assert`
* `assert_equal`
* `assert_not_equal`
* `assert_same`
* `assert_not_same`
* `assert_nil`
* `assert_not_nil`
* `assert_in_delta`
* `assert_match`
* `assert_no_match`
* `assert_instance_of`
* `assert_kind_of`
* `assert_respond_to`
* `assert_raise`
* `assert_nothing_raised`
* `assert_throws`
* `assert_nothing_thrown`
* `assert_block`

## Test::Unit-style tests

You can also define tests by making a method that starts with `test_`.
The `setup` and `teardown` methods are also supported.

``` ruby
class MyTest < Para::Test
  def setup
    @three = 3
  end

  def test_equality
    @three.should == 3
    assert_equal @three, 3
  end
end
```

## Nested tests

You can nest tests using `describe` or `context` (both are synonyms).

``` ruby
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

* Assertion API modeled after Test::Unit
* RSpec-like assertions taken from [REnvy](http://github.com/rstacruz/renvy)
* Nested tests taken from [Contest](http://github.com/citrusbyte/contest)

MIT license.
