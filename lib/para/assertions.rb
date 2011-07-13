class Para::Test
  def q(str)
    "\033[47;40m#{str.inspect}\033[0m"
  end

  def refute(what, msg=nil, &blk)
    assert !what, msg, &blk
  end

  def assert_equal(left, right, msg=nil)
    assert left == right, msg || "#{q left} is not equal to #{q right}."
  end

  def refute_equal(left, right, msg=nil)
    refute left == right, msg || "#{q left} is equal to #{q right}."
  end

  def assert_match(regex, str, msg=nil)
    assert str =~ regex, msg || "#{q str} does not match #{q regex}."
  end

  def refute_match(regex, str, msg=nil)
    refute str =~ regex, msg || "#{q str} matches #{q regex}."
  end

  def assert_includes(haystack, needle, msg=nil)
    assert haystack.include?(needle), msg || "#{q haystack} does not include #{q needle}."
  end

  def refute_includes(haystack, needle, msg=nil)
    refute haystack.include?(needle), msg || "#{q haystack} includes #{q needle}."
  end

  def assert_instance_of(type, what, msg=nil)
    assert what.instance_of?(type), msg || "#{q what} is not a #{q type}."
  end

  def refute_instance_of(type, what, msg=nil)
    refute what.instance_of?(type), msg || "#{q what} is a #{q type}."
  end

  def assert_kind_of(type, what, msg=nil)
    assert what.kind_of?(type), msg || "#{q what} is not a #{q type}."
  end

  def refute_kind_of(type, what, msg=nil)
    refute what.kind_of?(type), msg || "#{q what} is a #{q type}."
  end

  def assert_nil(what, msg=nil)
    assert what.nil?, msg || "#{q what} is not nil."
  end

  def refute_nil(what, msg=nil)
    refute what.nil?, msg || "#{q what} is nil."
  end

  def assert_same(left, right, msg=nil)
    assert left === right, msg || "#{q left} is not the same as #{q right}."
  end

  def refute_same(left, right, msg=nil)
    refute left === right, msg || "#{q left} is the same as #{q right}."
  end

  def assert_respond_to(what, method, msg=nil)
    assert what.respond_to?(method), msg || "#{q what} does not respond to #{q method}."
  end

  def refute_respond_to(what, method, msg=nil)
    refute what.respond_to?(method), msg || "#{q what} responds to #{q method}."
  end

  def assert_empty(what, msg=nil)
    assert what.empty?, msg || "#{q what} is not empty."
  end

  def refute_empty(what, msg=nil)
    refute what.empty?, msg || "#{q what} is empty."
  end

  def assert_block(msg=nil, &blk)
    assert yield, msg || "The block did not return true."
  end

  def refute_block(msg=nil, &blk)
    refute yield, msg || "The block returned true."
  end

  def assert_in_delta(left, right, d=0.001, msg=nil)
    assert (left - right).abs <= d, msg || "#{q left} is not equal to #{q right}. (+/- #{q d})"
  end

  def refute_in_delta(left, right, d=0.001, msg=nil)
    refute (left - right).abs <= d, msg || "#{q left} is equal to #{q right}. (+/- #{q d})"
  end

  def assert_in_epsilon(left, right, d=0.001, msg=nil)
    assert_in_delta left, right, [left.abs, right.abs].min*d, msg
  end

  def refute_in_epsilon(left, right, d=0.001, msg=nil)
    refute_in_delta left, right, [left.abs, right.abs].min*d, msg
  end

  def assert_operator(left, operator, right, msg=nil)
    assert left.send(operator, right), msg || "#{q left} is not #{operator} #{q right}."
  end

  def refute_operator(left, operator, right, msg=nil)
    refute left.send(operator, right), msg || "#{q left} is not #{operator} #{q right}."
  end

  def assert_raises(ex, msg=nil, &blk)
    begin
      yield
      assert false, msg || "Exception #{ex} was not raised."
    rescue ex => e
    end
  end

  def assert_nothing_raised(msg=nil, &blk)
    begin
      yield
    rescue => e
      assert false, msg || "Exception #{e} was raised."
    end
  end

  def assert_throws(what, msg=nil, &blk)
    catch(what) do
      yield
      assert false, msg || "#{what} was not thrown."
    end
  end

  def assert_nothing_thrown(msg=nil, &blk)
    begin
      yield
    rescue ArgumentError => error
      raise error if /\Auncaught throw (.+)\z/ !~ error.message
      assert false, msg || "#{q $1} was thrown when nothing was expected."
    end
    assert true, msg || "Expected nothing to be thrown"
  end
end
