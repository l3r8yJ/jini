# (The MIT License)
#
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
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# The jini.
# Author:: Ivan Ivanchuk (clicker.heroes.acg@gmail.com)
# Copyright:: Copyright (c) 2022 Ivan Ivanchuck
# License:: MIT
#
# It's a simple XPATH builder.
# Class is thread safe.
# Example:
#   require 'jini'
#   xpath = Jini.new('parent')
#               .add_node('child')
#               .add_attr('toy', 'plane')
#               .to_s
# => 'parent/child[@toy="plane"]
class Jini
  # When path not valid
  class InvalidPath < StandardError; end

  # Makes new object.
  # By default it creates an empty path and you can ignore the head parameter.
  # @param head [String]
  # @since 0.0.1
  def initialize(head = '')
    @head = head
  end

  # Convert it to a string.
  # @return [String] xpath as string
  # @raise [InvalidPath] if contain spaces in simple nodes
  # @since 0.0.1
  def to_s
    copy = @head.split(%r{//|/})
    copy.each(&method(:space_check))
    @head.to_s
  end

  class << self
    # From.
    # Creates new Jini object from XPATH.
    #
    # @param [String] xpath
    # @raise [InvalidPath] when XPATH is invalid
    # @return [Jini] object
    def from(xpath)
      raise InvalidPath, 'XPATH isn\'t valid' unless xpath_match?(xpath)
      Jini.new(xpath)
    end

    private

    # This regex matches general case of XPATH.
    # @param xpath [String]
    # @return [Boolean] matching regex
    def xpath_match?(xpath)
      xpath.match?(xpath_regex)
    end

    def prefix_regex
      %r{^/?}
    end

    def tag_regex
      /([a-zA-Z0-9]+:)?[a-zA-Z0-9]+/
    end

    def bracket_regex
      /(\[[^\[\]]*\])/
    end

    def attr_regex
      /@\w+=[^\]]+/
    end

    def or_regex
      /(\|)/
    end

    def namespace_regex
      /([a-zA-Z0-9]+:)?[a-zA-Z0-9]+/
    end

    def sub_xpath_regex
      /#{namespace_regex}#{bracket_regex}*(#{attr_regex})*/
    end

    def or_sub_xpath_regex
      /#{or_regex}#{namespace_regex}#{bracket_regex}*(#{attr_regex})*/
    end

    def xpath_regex
      %r{\A#{prefix_regex}#{namespace_regex}(/#{sub_xpath_regex})*#{or_sub_xpath_regex}*(/#{sub_xpath_regex})*\Z}
    end
  end

  # Additional node for xpath.
  # @param node [String] the node
  # @return [Jini] object with additional node
  # @since 0.0.1
  def add_node(node)
    Jini.new("#{@head}/#{node}")
  end

  # Removes node by name.
  # @param node [String] the node for removal
  # @return [Jini] without a node
  # @since 0.0.7
  def remove_node(node)
    Jini.new(purge_head("/#{node}"))
  end

  # This method replaces *all* origins to new.
  # @param origin [String] origin node
  # @param new [String] new one
  # @since 0.1.0
  def replace_node(origin, new)
    Jini.new(
      @head
      .split('/')
      .map! { |node| node.eql?(origin) ? new : node }
      .join('/')
    )
  end

  # All nodes in xpath as array.
  # @return nodes as [Array]
  def nodes
    checked = @head
    .split(%r{(//|/)})
    .each(&method(:empty_check))
    checked.each { |node| checked.delete node if node.eql?('//') || node.eql?('/') }.to_a
  end

  # Addition property in tail.
  # Example:
  #   >> Jini.new('node/').property('prop').to_s
  #   => node/property()
  # @param property [String] to add
  # @return [Jini] with property on tail
  # @since 0.0.1
  def add_property(property)
    Jini.new(add_node("#{property}()").to_s)
  end

  # Removes property.
  # @param property [String] to remove
  # @return [Jini] without property on tail
  # @since 0.1.3
  def remove_property(property)
    Jini.new(@head.gsub("#{property}()", ''))
  end

  # Additional attribute for xpath.
  # @example'[@key="value"]'
  # @param key [String] name of attr
  # @param value [String] value of attr
  # @return [Jini] with additional attr on tail
  def add_attr(key, value)
    Jini.new("#{@head}[@#{key}=\"#{value}\"]")
  end

  # Adds '@key' to tail.
  # @param key [String] the key
  # @return [Jini]  with additional value on tail
  def add_attrs(key)
    Jini.new("#{@head}@#{key}")
  end

  # Just wrap current XPATH into count() function
  # @return [Jini] wrapped
  def count
    Jini.new("count(#{@head})")
  end

  # Removes attr by name.
  # before:
  # '/parent/child [@k="v"]'
  # after:
  # '/parent/child'
  # @param [String] name of attr
  # @return [Jini] without an attr
  def remove_attr(name)
    Jini.new(
      purge_head(/(\[@?#{name}="[^"]+"(\[\]+|\]))/)
    )
  end

  # Replaces *all* attr *values* by name.
  # Before:
  # '[@id="some value"]'
  # After:
  # '[@id="new value"]'
  # @param name [String] of attr
  # @param value [String] upd value
  # @return [Jini] with replaced attr value
  def replace_attr_value(name, value)
    n_rxp = /(\[@?#{name}="[^"]+"(\[\]+|\]))/
    attr = @head[n_rxp]
    attr[/"(.*?)"/] = "\"#{value}\""
    Jini.new(@head.gsub(n_rxp, attr)) unless attr.nil?
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
  # @param node [String] the node
  # @return [Jini] with additional nodes
  def add_nodes(node)
    Jini.new("#{@head}//#{node}")
  end

  # Access by index.
  # Addition '[index]' to xpath
  # @param position [Integer] number
  # @return [Jini] with selected index
  # @raise [InvalidPath] when method used after selection
  def at(position)
    raise InvalidPath, 'Cant use at after selection' if @head.include? '::'
    Jini.new("#{@head}[#{position}]")
  end

  # Replace all '/' to '::'.
  #
  # If path doesn't contain invalid symbols for selection
  # @return [Jini] with selection
  # @raise [InvalidPath] when path can't present with select
  def selection
    raise InvalidPath, 'Cannot select, path contains bad symbols' if bad_symbols? @head
    Jini.new(@head.gsub('/', '::').to_s)
  end

  # Adds '[alpha | beta]' in tail.
  # @param alpha [String] the alpha statement
  # @param beta [String] the beta statement
  # @return [Jini] with condition on tail
  def or(alpha, beta)
    action_between('|', alpha, beta)
  end

  # Less than.
  # Addition '[alpha < beta]' to tail
  # @param alpha [String] the alpha statement
  # @param beta [Object] the beta statement
  # @return [Jini] with condition on tail
  def lt(alpha, beta)
    action_between('<', alpha, beta)
  end

  # Greater than.
  # Addition '[alpha > beta]' to tail
  # @param alpha [String] the alpha statement
  # @param beta [Object] the beta statement
  # @return [Jini] with condition on tail
  def gt(alpha, beta)
    action_between('>', alpha, beta)
  end

  private

  # @param node [String] node for check
  def empty_check(node)
    raise InvalidPath, 'Invalid path, empty node' if node.length.eql? 0
  end

  # @param node [String] node for check
  def space_check(node)
    raise InvalidPath, "Nodes can't contain spaces: #{node} – contain space." if valid_node? node
  end

  # Regex: '[' or ']' or '@' or '//'.
  # @param node [String]
  # @return [Boolean] matching regex
  def bad_symbols?(node)
    !!node.match(%r{[|]|@|//}) unless node.nil?
  end

  # Regex: '[' or ']' or '@' or '=' or '<' or '>'.
  # @param node [String] node for check
  # @return [Boolean] matching regex
  def valid_node?(node)
    !node.match(/[|]|@|=|>|</) && node.include?(' ')
  end

  # Some action between two statements.
  def action_between(action, alpha, beta)
    Jini.new("#{@head}[#{alpha} #{action} #{beta}]")
  end

  # Purging head from token.
  # @param [Regexp | String] token to be purged from the head
  def purge_head(token)
    @head.gsub(token, '')
  end
end
