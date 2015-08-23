# CharlotteBudget

This gem processes City of Charlotte budget data, and produces a JSON file suitable for into budget display applications such as [Government Budget Explorer](https://github.com/DemocracyApps/GBE) or [Visual-Town-Budget](https://github.com/goinvo/Visual-Town-Budget).

We've observed from practice that knowledge, analysis, and processing of the dataset is independent enough from display that we'd like to create institutional knowledge about how to process this information.  Our own inputs may vary from year to year (as they did from 2015 to 2016), so we create this gem to start with the benefits of antiquity each time.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'charlotte_budget'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install charlotte_budget

## Usage

Processing is exposed in the default rake task.

Run `bin/console` for an interactive prompt that allows you to manually execute intermediate analysis and processing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/charlotte_budget. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

