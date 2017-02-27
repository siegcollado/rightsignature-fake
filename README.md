# Rightsignature-Fake

A fake server for rightsignature api for testing

**This is very much WIP at the moment.**


## TODO
1. Write tests
2. Refactor

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'rightsignature-fake'
end
```

In your `spec_helper.rb` file, add:

```ruby
require "rightsignature-fake/support/rspec"
```

You can configure the template directory using:

```ruby
RightSignatureFake.configure do |config|
  config.template_path = #{PATH/TO/TEMPLATE/FILE}
end
```

## Usage

TODO: Write usage instructions here


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sieg Collado/rightsignature-fake.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

