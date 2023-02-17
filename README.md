
# Jini
[<img src="https://user-images.githubusercontent.com/46355873/219519979-7c9dcce3-ceb9-4b09-932c-f68b98841f54.svg" width="150"/>](219519979-7c9dcce3-ceb9-4b09-932c-f68b98841f54.svg)

[![Gem Version](https://badge.fury.io/rb/jini.svg)](https://badge.fury.io/rb/jini)

The class [`Jini`](https://www.rubydoc.info/gems/jini/1.2.5/Jini) helps you build a XPATH.

```ruby
require 'jini'
xpath = Jini
  .new![jini](https://user-images.githubusercontent.com/46355873/219519836-1cc268c6-ef55-4014-8aa0-323d4d5856f8.svg)

  .add_node('parent') # addition a path node
  .add_node('child') # addition a path node 
  .add_attr('key', 'value') # addition an attribute
  .remove_node('child') # removes node
  .to_s # convert it to a string
puts(xpath) # -> xpath: /parent[@key="value"]
```

The full list of methods is [here](https://www.rubydoc.info/gems/jini/1.2.5).

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
If you find an error, or you want to add new functionality, just create a new `Issue`
and describe what happened, also try to add/fix something and send pull request.
