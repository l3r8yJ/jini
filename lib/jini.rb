# frozen_string_literal: true


# It's a simple XPATH builder.
# require 'jini'
# xpath = Jini.new('body')
#   .addPath(node: 'child')
#   .addPath(node: 'child')
#   .to_s // /body/child/child
class Jini
  # When path not valid
  class InvalidPath < StandardError; end

  def initialize(head = '')
    @head = "/#{head}/"
  end

  # Convert it to a string.
  def to_s
    @head.to_s
  end

  def add(element)
    clone = "#{@head}/#{element}"
    yield clone
    Jini.new(clone)
  end
end
