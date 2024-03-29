# Copyright (c) 2022 Ivanchuk Ivan
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

require_relative 'test_helper'
require_relative '../lib/jini'
require 'minitest/autorun'

# Test for Jini class.
# Author:: Ivanchuk Ivan (clicker.heroes.acg@gmail.com)
# Copyright:: Copyright (c) 2022 Ivanchuck Ivan
# License:: MIT
# rubocop:disable Metrics/ClassLength
class JiniTest < Minitest::Test
  PARENT = 'parent'.freeze
  CHILD = 'child'.freeze

  def test_add_path_and_at_success
    assert_equal(
      '/parent/child[1]',
      Jini.new
        .add_node(PARENT)
        .add_node(CHILD)
        .at(1)
        .to_s
    )
  end

  def test_at_raise_invalid_path
    assert_raises(Jini::InvalidPath) do
      Jini.new(PARENT)
          .add_node(CHILD)
          .selection
          .at(3)
          .to_s
    end
  end

  def test_remove_path
    assert_equal(
      'parent/toy',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_node('toy')
          .remove_node(CHILD)
          .to_s
    )
  end

  def test_add_attr_success
    assert_equal(
      '/node[@key="value"]',
      Jini.new
        .add_node('node')
        .add_attr('key', 'value')
        .to_s
    )
  end

  def test_add_attrs_success
    assert_equal(
      'parent/child@toy',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_attrs('toy')
          .to_s
    )
  end

  def test_all_success
    assert_equal(
      '/parent/child/*',
      Jini.new
          .add_node(PARENT)
          .add_node(CHILD)
          .all
          .to_s
    )
  end

  def test_all_fail
    assert_raises(Jini::InvalidPath) do
      Jini.new
          .add_node(PARENT)
          .add_attr('key', 'value')
          .all
    end
  end

  def test_remove_attr_success
    assert_equal(
      '/home/batya',
      Jini.new
          .add_node('home')
          .add_node('batya')
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
        .add_node(PARENT)
        .add_node(CHILD)
        .add_attr('age', 'teen')
        .add_node('toy')
        .add_attr('age', 'old')
        .remove_attr('age')
        .to_s
    )
  end

  def test_add_nodes
    assert_equal(
      'parent//children',
      Jini.new(PARENT).add_nodes('children').to_s
    )
  end

  def test_selection_success
    assert_equal(
      'parent::child',
      Jini.new(PARENT)
          .add_node(CHILD)
          .selection
          .to_s
    )
  end

  def test_selection_fail
    assert_raises(Jini::InvalidPath) do
      Jini.new
          .add_node(PARENT)
          .add_node(CHILD)
          .add_attr('k', 'v')
          .selection
          .to_s
    end
  end

  def test_or
    assert_equal(
      'parent/child[animal | toy]',
      Jini.new(PARENT)
          .add_node(CHILD)
          .or('animal', 'toy')
          .to_s
    )
  end

  def test_lt
    assert_equal(
      'parent/child[toys < 10]',
      Jini.new(PARENT)
          .add_node(CHILD)
          .lt('toys', 10)
          .to_s
    )
  end

  def test_gt
    assert_equal(
      'parent/child[toys > 10]',
      Jini.new(PARENT)
          .add_node(CHILD)
          .gt('toys', 10)
          .to_s
    )
  end

  def test_add_property
    assert_equal(
      'parent/child/property()',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_property('property')
          .to_s
    )
  end

  def test_to_s_not_raised
    Jini.new(PARENT)
           .add_node(CHILD)
           .add_node(PARENT)
           .add_node(CHILD)
           .add_node(PARENT)
           .add_node(CHILD)
           .add_attr('key', 'value')
           .add_node(PARENT)
           .or('a', 'b')
           .add_node(CHILD)
           .to_s
  end

  def test_to_s_raised_invalid_path
    assert_raises(Jini::InvalidPath) do
      Jini.new(PARENT)
          .add_node(CHILD)
          .or('toy', 'animal')
          .add_node('p arent')
          .to_s
    end
  end

  def test_replace_node_single
    assert_equal(
      'parent/child/toy/child/kek',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_node('toy')
          .add_node(CHILD)
          .add_node('nonkek')
          .replace_node('nonkek', 'kek')
          .to_s
    )
  end

  def test_replace_node_multi
    assert_equal(
      'parent/wife/toy/wife',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_node('toy')
          .add_node(CHILD)
          .replace_node(CHILD, 'wife')
          .to_s
    )
  end

  def test_replace_node_with_attr
    assert_equal(
      'parent/wife/toy[@material="plastic"]/wife',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_node('toy')
          .add_attr('material', 'plastic')
          .add_node(CHILD)
          .replace_node(CHILD, 'wife')
          .to_s
    )
  end

  def test_replace_attr_value
    assert_equal(
      'parent/child[@toy="car"]',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_attr('toy', 'plane')
          .replace_attr_value('toy', 'car')
          .to_s
    )
  end

  def test_remove_property
    assert_equal(
      'parent/child/',
      Jini.new(PARENT)
          .add_node(CHILD)
          .add_property('p')
          .remove_property('p')
          .to_s
    )
  end

  def test_nodes
    nodes = Jini.new(PARENT)
          .add_node(CHILD)
          .add_attr('key', 'value')
          .add_node('under_attr')
          .add_nodes('many')
          .at(3)
          .nodes
    assert_includes(nodes, 'under_attr')
    assert_equal(
      [].append(
        'parent',
        'child[@key="value"]',
        'under_attr',
        'many[3]'
      ),
      nodes
    )
  end

  def test_nodes_ctor
    assert_equal(
      [].append(
        'parent',
        'child[@key="value"]',
        'under_attr',
        'many[3]'
      ),
      Jini.new('parent/child[@key="value"]/under_attr//many[3]').nodes
    )
  end

  def test_nodes_raises_invalid_path
    assert_raises(Jini::InvalidPath) do
      Jini.new("#{PARENT}//")
          .add_nodes(CHILD)
          .nodes
    end
  end

  def test_count_success
    assert_equal(
      'count(parent/child)',
      Jini.new(PARENT)
          .add_node(CHILD)
          .count
          .to_s
    )
  end

  def test_from_xpath_success
    x = '/parent/child[@toy="plane"]'
    jini = Jini.new('/parent').add_node(CHILD).add_attr('toy', 'plane')
    assert_nothing_raised do
      Jini.from x
      Jini.from jini.to_s
    end
    assert_equal Jini.from(x), Jini.from(jini.to_s)
  end

  def test_from_xpath_fails
    assert_raises(Jini::InvalidPath) { Jini.from '/parent/chld[' }
    assert_raises(Jini::InvalidPath) { Jini.from '' }
  end

  def test_method_missing_fails
    assert_raises(Jini::UnsupportedOperation) do
      Jini.new.bark
    end
  end
end
# rubocop:enable Metrics/ClassLength
