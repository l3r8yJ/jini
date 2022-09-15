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

  def initialize(head = '')
    @head = head
  end

  # Convert it to a string.
  def to_s
    @head.to_s
  end

  # Additional node for xpath.
  def add_path(node)
    Jini.new("#{@head}/#{node}")
  end

  # Additional attribute for xpath.
  def add_attr(key, value)
    Jini.new("#{@head}[@#{key}=\"#{value}\"]")
  end

  def all_attr(value)
    Jini.new("#{@head}@#{value}")
  end

  # Xpath with all elements.
  def all
    Jini.new(add_path('*').to_s)
  end

  # Xpath with all named elements.
  def add_all(node)
    Jini.new("#{@head}//#{node}")
  end

  # Access by index.
  def at(position)
    Jini.new("#{@head}[#{position}]")
  end
end
