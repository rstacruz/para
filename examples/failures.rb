require File.expand_path('../../lib/para', __FILE__)

class Foo < Para::Test
  def test_yes
    assert true
    assert 2 == 3, 'The cake is a lie'
  end

  def test_another_test
    assert true
    sleep 1
    assert true
    assert(false) { "Haha" }
  end

  def test_another_test_again
    assert true
    sleep 1
    assert true
    assert_match /hex/, "hello"
  end

  def test_lol
    2/0
  end

  def test_another_test_yes
    assert true
    sleep 1
    assert true
  end

  def test_inc_test
    assert_include %w[a b c], 'd'
  end

  def test_equal
    100.should == 3
  end
end

class ContestTest < Para::Test
  setup do
    @lol = 100
  end

  context "foo" do
    setup do
      @lol += 1
    end

    should "boogie all night" do
      101.should == @lol
    end
  end
end
