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
       github: crystal-loot/webdrivers.cr
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

### Locating the Chrome browser

On Linux, Webdrivers searches a list of common install paths (including Snap and
Flatpak exports) for a Chrome/Chromium binary in order to detect the installed
version. Two environment variables let you override that search when your
install lives somewhere unusual:

- `WEBDRIVERS_CHROME_BINARY` — absolute path to the Chrome binary. When set,
  the search is skipped and this path is used directly.
- `WEBDRIVERS_CHROME_BINARY_NAME` — a binary name to look for in the standard
  directories, in addition to the built-in names (`google-chrome`, `chrome`,
  `chromium`, `chromium-browser`, `com.google.Chrome`). Useful if your
  distribution ships Chrome under a different name.

## Development

- Fork
- Code
- `crystal tool format spec/ src/`
- `./bin/ameba`
- `crystal spec`
- Commit
- Open PR

## Contributing

1. Fork it (<https://github.com/crystal-loot/webdrivers.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Matthew McGarvey](https://github.com/matthewmcgarvey) - creator and maintainer
