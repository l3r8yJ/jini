
# Jini

[![Gem Version](https://badge.fury.io/rb/jini.svg)](https://badge.fury.io/rb/jini)

The class [`Jini`](https://www.rubydoc.info/gems/jini/0.1.5/Jini) helps you build a XPATH.

```ruby
require 'jini'
xpath = Jini
  .new
  .add_node('parent') # addition a path node
  .add_node('child') # addition a path node 
  .add_attr('key', 'value') # addition an attribute
  .remove_node('child') # removes node
  .to_s # convert it to a string
puts(xpath) # -> xpath: /parent[@key="value"]
```

The full list of methods is [here](https://www.rubydoc.info/gems/jini/0.1.5).

Install it:

```bash
$ gem install jini
```

Or add this to your `Gemfile`:

```bash
gem 'jini'
```

Pay attention, it is not a parser. The only functionality this gem provides
is _building_ XPATHs.

## New features requests
If you find an error, or you want to add new functionality, simply create a new `Issue`
and describe what happened, also try to add/fix something and send pull request.
