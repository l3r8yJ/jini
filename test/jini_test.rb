# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2022-2022 Ivanchuk Ivan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require_relative '../lib/jini'
require 'minitest/autorun'
require_relative 'test_helper'

# Jini test.
# Author:: Ivan Ivanchuk (clicker.heroes.acg@gmail.com)
# Copyright:: Copyright (c) 2022-2022 Ivan Ivanchuck
# License:: MIT
class JiniTest < Minitest::Test
  def test_add_path_and_at_success
    assert_equal(
      '/parent/child[1]',
      Jini.new
        .add_path('parent')
        .add_path('child')
        .at(1)
        .to_s
    )
  end

  def test_remove_path
    assert_equal(
      'parent/toy',
      Jini.new('parent')
          .add_path('child')
          .add_path('toy')
          .remove_path('child')
          .to_s
    )
  end

  def test_add_attr_success
    assert_equal(
      '/node[@key="value"]',
      Jini.new
        .add_path('node')
        .add_attr('key', 'value')
        .to_s
    )
  end

  def test_all_success
    assert_equal(
      '/parent/child/*',
      Jini.new
          .add_path('parent')
          .add_path('child')
          .all
          .to_s
    )
  end

  def test_all_fail
    assert_raises do
      Jini.new
          .add_path('parent')
          .add_attr('key', 'value')
          .all
    end
  end

  def test_remove_attr_success
    assert_equal(
      '/home/batya',
      Jini.new
          .add_path('home')
          .add_path('batya')
          .add_attr('drunk', 'very')
          .remove_attr('drunk')
          .to_s
    )
  end

  def test_remove_attr_many
    assert_equal(
      '/parent/child/toy',
      Jini
        .new
        .add_path('parent')
        .add_path('child')
        .add_attr('age', 'teen')
        .add_path('toy')
        .add_attr('age', 'old')
        .remove_attr('age')
        .to_s
    )
  end

  def test_add_all
    assert_equal(
      'parent//children',
      Jini.new('parent').add_all('children').to_s
    )
  end

  def test_selection_success
    assert_equal(
      'parent::child',
      Jini.new('parent')
          .add_path('child')
          .selection
          .to_s
    )
  end

  def test_selection_fail
    assert_raises do
      Jini.new
          .add_path('parent')
          .add_path('children')
          .add_attr('k', 'v')
          .selection
          .to_s
    end
  end
end
