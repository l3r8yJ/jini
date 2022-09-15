The class [`Jini`](https://www.rubydoc.info/github/l3r8yJ/jini/master/Jini)
helps you build a XPATH.

```ruby
require 'jini'
xpath = Jini
  .new
  .add_path('parent') # addition a path node
  .add_path('child') # addition a path node 
  .add_attr('key', 'value') # addition an attribute
  .to_s # convert it to a string
# -> xpath: parent/child[@key="value"]
```

The full list of methods is [here](https://www.rubydoc.info/github/l3r8y/jini/master/Jini).

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
