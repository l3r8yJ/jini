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

# It's a simple XPATH builder.
# require 'jini'
# xpath = Jini.new('body')
#   .add_path(node: 'child')
#   .add_path(node: 'child')
#   .to_s // /body/child/child
class Jini
  # When path not valid
  class InvalidPath < StandardError; end

  # @param head [String] with head of your xpath
  def initialize(head = '')
    @head = head
  end

  # Convert it to a string.
  # @return [String] xpath as string
  def to_s
    @head.to_s
  end

  # Additional node for xpath.
  # @param node [String] node
  # @return [Jini] object
  def add_path(node)
    Jini.new("#{@head}/#{node}")
  end

  # Additional attribute for xpath.
  # [@key="value"]
  # @param key [String] name of attr
  # @param value [String] value of attr
  # @return [Jini] object
  def add_attr(key, value)
    Jini.new("#{@head}[@#{key}=\"#{value}\"]")
  end

  # Adds an @value to xpath
  # @param value [String] with value attr
  # @return [Jini] object
  def all_attr(value)
    Jini.new("#{@head}@#{value}")
  end

  # Xpath with all elements.
  # Addition a *** to xpath
  # @return [Jini] object
  def all
    raise InvalidPath, 'You cannot add all tag after attr!' if @head[-1].eql?(']')
    Jini.new(add_path('*').to_s) unless @head[-1].eql?(']')
  end

  # Xpath with all named elements.
  # Addition _//node_ to xpath
  # @param node [String] name of node
  # @return [Jini] object
  def add_all(node)
    Jini.new("#{@head}//#{node}")
  end

  # Access by index.
  # Addition _[index]_ to xpath
  # @param position [Integer] number
  # @return [Jini] object
  def at(position)
    Jini.new("#{@head}[#{position}]")
  end

  # Replace all _/_ to _::_ symbols
  # if path doesn't contain invalid symbols for selection
  # @return [Jini] selection
  def selection
    if @head.include?('[') || @head.include?(']') || @head.include?('@')
      raise InvalidPath, 'Cannot select, path contains bad symbols'
    end
    Jini.new(@head.gsub('/', '::').to_s)
  end

  # Removes node by name
  # @param node [String] name of node for removal
  # @return [Jini] without a node
  def remove_path(node)
    copy = @head
    Jini.new(copy.gsub("/#{node}", ''))
  end

  # Removes attr by name
  # before:
  # /parent/child[@k="v"]
  # .remove_attr('k')
  # after:
  # /parent/child
  # @param [String] name of attr
  # @return [Jini] without an attr
  def remove_attr(name)
    Jini.new(
      @head
        .gsub(
          /(\[@|#{name}="[^"]+"|[]+|])/,
          ''
        )
    )
  end
end
