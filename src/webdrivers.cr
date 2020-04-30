require "crystar"
require "file_utils"
require "gzip"
require "habitat"
require "halite"
require "http"
require "json"
require "semantic_version"
require "zip"
require "./webdrivers/**"

module Webdrivers
  VERSION = "0.1.0"
  DEFAULT_DRIVER_DIRECTORY = "~/.webdrivers"

  Habitat.create do
    setting driver_directory : String = DEFAULT_DRIVER_DIRECTORY
    setting cache_duration : Time::Span = 24.hours
  end
end
