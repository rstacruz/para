require File.expand_path('../helper', __FILE__)
require 'mocha'

class Foo
  def get_true?
    true
  end

  def get_false?
    false
  end
end

class REnvyTest < Para::Test
  def test_should
    2.should     == 2
    2.should_not == 3
    2.should.not == 3

    2.should     != 3
    2.should_not != 2
    2.should.not != 2

    "hi".should =~ /hi/
    "hi".should.match /hi/
    "hi".should_not =~ /HI/
    "hi".should.not.match /HI/

    @foo.should.be.nil?
    1000.should_not.be.nil?

    "".should.respond_to(:empty?)
    "".should_not.respond_to(:lolwhat)

    should_not.raise { 2 + 2 }
    should.raise(ZeroDivisionError) { 2 / 0 }

    [].should.be.empty
    [].should.empty

    [1].should_not.be.empty
    [1].should.include(1)

    2.should < 3
    1.should < 2
    2.should <= 2
    2.should <= 4
    4.should >= 4
    4.should >= 3

    Object.new.should.respond_to(:freeze)
    Object.new.should.be.kind_of(Object)
    Object.new.should.be.an.instance_of(Object)

    a = Object.new
    b = a
    a.should.be.equal(b)
    a.should.be(b)
    a.should_not.be.equal(Object.new)

    Math::PI.should.be.close(22.0/7, 0.1)

    should.throw(:x) { throw :x }
    should.not.throw { 2 + 2 }

    Foo.new.should.not.get_false
    Foo.new.should.get_true
  end

  def test_should_be
    a = Object.new
    b = a

    expects(:assert_same).with(a, b, nil)
    a.should.be(b)
  end

  def test_include
    expects(:assert_includes).with([], 2, nil)
    [].should.include 2
  end

  def test_include_not
    expects(:refute_includes).with([], 2, nil)
    [].should.not.include 2
  end

  def test_message
    expects(:assert_equal).with(4, 3, 'lol')
    3.should.blaming('lol') == 4
  end

  def test_message_2
    object = Object.new

    expects(:assert).with('grape', 'lol')
    object.expects(:boo?).returns('grape')

    object.should.blaming('lol').boo
  end

  def test_assert_block
    expects :assert_block
    should.satisfy { false }
  end
end
