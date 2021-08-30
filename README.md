# ImHelpers

Misc immatériel.fr shared helpers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'im_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install im_helpers

## Usage

### Forex
Use European Central Bank data to get money exchange rate.
To get current rate between USD and EUR:

    > ImHelpers::Forex.rate("USD","EUR")
    => 0.942

To get rate between CAD and EUR at 2014-04-01 :

    > ImHelpers::Forex.rate("CAD","EUR",Date.new(2014,4,1))
    => 0.6561

### IpToCountry
Get country from IP using https://lite.ip2location.com/database/ip-country database.

First usage, to download data file and generate .dat file

    > ImHelpers::IpToCountry.get("101.198.199.255")
    => "US"

Then for any further usage you can keep using `.get` or directly call `.search` as such

    > ImHelpers::IpToCountry.search("101.198.199.255")
    => "US"

### NameExtractor
Extract semantic from person name string.

    > ImHelpers::NameExtractor.new("John Smith")
    => John Smith<firstname:John,lastname:Smith>
    > ImHelpers::NameExtractor.new("Smith, John")
    => John Smith,<firstname:John,lastname:Smith]>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/julbouln/im_helpers.

