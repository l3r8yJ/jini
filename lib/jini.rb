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

  # @param head String with head of your xpath
  def initialize(head = '')
    @head = head
  end

  # Convert it to a string.
  def to_s
    @head.to_s
  end

  # Additional node for xpath.
  # @param node String node
  def add_path(node)
    Jini.new("#{@head}/#{node}")
  end

  # Additional attribute for xpath.
  # @param key String name of attr
  # @param value String value of attr
  def add_attr(key, value)
    Jini.new("#{@head}[@#{key}=\"#{value}\"]")
  end

  # Adds an @value to xpath
  # @param value String with value attr
  def all_attr(value)
    Jini.new("#{@head}@#{value}")
  end

  # Xpath with all elements.
  # Addition a *** to xpath
  def all
    Jini.new(add_path('*').to_s)
  end

  # Xpath with all named elements.
  # Addition _//node_ to xpath
  # @param node String name of node
  def add_all(node)
    Jini.new("#{@head}//#{node}")
  end

  # Access by index.
  # Addition _[index]_ to xpath
  # @param position int number
  def at(position)
    Jini.new("#{@head}[#{position}]")
  end
end
