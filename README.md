# Webdrivers

![GitHub release (latest by date)](https://img.shields.io/github/v/release/matthewmcgarvey/webdrivers.cr)
![Build status](https://github.com/matthewmcgarvey/webdrivers.cr/workflows/Crystal%20CI/badge.svg)

A Crystal port of the Ruby [webdrivers](https://github.com/titusfortner/webdrivers) gem.
It automatically installs and updates supported webdrivers.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     webdrivers:
       github: matthewmcgarvey/webdrivers.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "webdrivers"
```

On whichever driver you use, calling `.install` will install, update the local driver if needed and then return the path to it.

### Chrome

```crystal
webdriver_path = Webdrivers::Chromedriver.install
```

### Firefox (Gecko)

```crystal
webdriver_path = Webdrivers::Geckodriver.install
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/matthewmcgarvey/webdrivers.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Matthew McGarvey](https://github.com/matthewmcgarvey) - creator and maintainer
