# frozen_string_literal: true

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
    Jini.new(add_path('*').to_s)
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
end
