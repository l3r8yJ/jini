require_relative '../lib/jini'
require 'minitest/autorun'
require 'minitest/reporters'

class JiniTest < Minitest::Unit
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test
    xpath = Jini
      .new
      .add_path('parent')
      .add_path('child')
      .at(1)
    assert_equal('/parent/child[1]', xpath.to_s)
  end
end
