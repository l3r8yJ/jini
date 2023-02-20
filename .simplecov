if Gem.win_platform?
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter
  ]
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/features/'
  end
else
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter]
  )
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/features/'
    minimum_coverage 30
  end
end
