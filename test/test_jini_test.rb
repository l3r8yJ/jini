# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/jini'

class TestJiniTest < Minitest::Test
  def test
    xpath = Jini.new('head')
                .add_path('body')
                .add_path('child')
                .all
                .add_attr('id', 'pudge')
    assert_equal 'head/body/child/*[@id="pudge"]', xpath.to_s
  end
end
