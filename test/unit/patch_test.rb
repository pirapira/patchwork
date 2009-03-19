require 'test_helper'

class PatchTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "summary" do
    p = Patch.new
    p.content = "hogehoge"
    assert_equal "hogehoge".scan(/./u), p.summary
  end

  test "long_summary" do
    p = Patch.new
    p.content = "hogehogehogehogehogehogehoge"
    assert_equal "hogehogehogehogehogehog...".scan(/./u), p.summary
  end
end
