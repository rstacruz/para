require File.expand_path('../../lib/para', __FILE__)

class Foo < Para::Test
  enable_parallel

  test "foo" do
    assert true
    sleep 1
  end

  test "foo again" do
    assert true
    sleep 1
  end
end
