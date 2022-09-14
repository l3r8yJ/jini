# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/jini'

class TestJiniTest < Minitest::Test
  def test
    xpath = Jini.new('parent')
                .add('child')
    assert_equal('/parent/child/', xpath.to_s)
  end
end
