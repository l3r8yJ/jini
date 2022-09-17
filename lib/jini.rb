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
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# It's a simple XPATH builder.
#
# require 'jini'
# xpath = Jini.new('parent')
#   .add_node('child')
#   .add_attr('toy', 'plane')
#   .to_s // parent/child[@toy="plane"]
class Jini
  # When path not valid
  class InvalidPath < StandardError; end

  # Makes new object.
  # By default it creates an empty path and you can ignore the head parameter.
  # @param head [String]
  def initialize(head = '')
    @head = head
  end

  # Convert it to a string.
  # @return [String] xpath as string
  # @raise [InvalidPath] if contain spaces in simple nodes
  def to_s
    copy = @head.split(%r{//|/})
    copy.each(&method(:space_check))
    @head.to_s
  end

  # Additional node for xpath.
  # @param node [String] node
  # @return [Jini] object
  def add_node(node)
    Jini.new("#{@head}/#{node}")
  end

  # Removes node by name
  # @param node [String] name of node for removal
  # @return [Jini] without a node
  def remove_node(node)
    Jini.new(
      purge("/#{node}")
    )
  end

  # This method replaces *all* origins to new
  # @param [String] origin node
  # @param [String] new node
  def replace_node(origin, new)
    Jini.new(
      @head
          .split('/')
          .map! { |node| node.eql?(origin) ? new : node }
          .join('/')
    )
  end

  # Addition property in tail
  # Before: '../child'
  # After: '../child/property()'
  # @param property [String]
  # @return [Jini] object
  def add_property(property)
    Jini.new(add_node("#{property}()").to_s)
  end

  # Additional attribute for xpath.
  # '[@key="value"]'
  # @param key [String] name of attr
  # @param value [String] value of attr
  # @return [Jini] object
  def add_attr(key, value)
    Jini.new("#{@head}[@#{key}=\"#{value}\"]")
  end

  # Adds '@value' to tail
  # @param value [String] with value attr
  # @return [Jini] object
  def add_attrs(value)
    Jini.new("#{@head}@#{value}")
  end

  # Xpath with all elements.
  # Addition an '*' to tail of xpath
  # @return [Jini] object
  # @raise [InvalidPath] when method called after attr
  def all
    raise InvalidPath, 'You cannot add all tag after attr!' if @head[-1].eql?(']')
    Jini.new(add_node('*').to_s)
  end

  # Xpath with all named elements.
  # Addition '//node' to xpath
  # @param node [String] name of node
  # @return [Jini] object
  def add_nodes(node)
    Jini.new("#{@head}//#{node}")
  end

  # Access by index.
  # Addition '[index]' to xpath
  # @param position [Integer] number
  # @return [Jini] object
  # @raise [InvalidPath] when method used after selection
  def at(position)
    raise InvalidPath, 'Cant use at after selection' if @head.include? '::'
    Jini.new("#{@head}[#{position}]")
  end

  # Replace all '/' to '::' symbols
  # if path doesn't contain invalid symbols for selection
  # @return [Jini] selection
  # @raise [InvalidPath] when path can't present with select
  def selection
    if @head.include?('[') || @head.include?(']') || @head.include?('@') || @head.include?('//')
      raise InvalidPath, 'Cannot select, path contains bad symbols'
    end
    Jini.new(@head.gsub('/', '::').to_s)
  end

  # Removes attr by name
  # before:
  # '/parent/child[@k="v"]'
  # after:
  # '/parent/child'
  # @param [String] name of attr
  # @return [Jini] without an attr
  def remove_attr(name)
    Jini.new(
      purge(/(\[@?#{name}="[^"]+"(\[\]+|\]))/)
    )
  end

  # Adds '[alpha | beta]' in tail.
  # @param [String] alpha statement
  # @param [String] beta statement
  # @return [Jini] with '[first|second]' on tail
  def or(alpha, beta)
    action_between('|', alpha, beta)
  end

  # Less than.
  # Addition '[node < value]' to tail
  # @param [String] key name
  # @param [Object] value
  # @return [Jini]
  def lt(key, value)
    action_between('<', key, value)
  end

  # Greater than.
  # Addition '[node > value]' to tail
  # @param [String] key name
  # @param [Object] value
  # @return [Jini]
  def gt(key, value)
    action_between('>', key, value)
  end

  private

  # @param node [String] node for check
  def space_check(node)
    raise InvalidPath, "Nodes can't contain spaces: #{node} – contain space." if valid? node
  end

  # @param node [String] node for check
  def valid?(node)
    !node.match(/[|]|@|=|>|</) && node.include?(' ')
  end

  # Some action between two statements.
  def action_between(action, alpha, beta)
    Jini.new("#{@head}[#{alpha} #{action} #{beta}]")
  end

  # @param [Regexp | String] token to be purged from the head
  def purge(token)
    @head.gsub(token, '')
  end
end
