require "compress/gzip"
require "compress/zip"
require "crystar"
require "file_utils"
require "habitat"
require "http"
require "json"
require "semantic_version"
require "./webdrivers/**"

module Webdrivers
  VERSION                  = "0.3.2"
  DEFAULT_DRIVER_DIRECTORY = "~/.webdrivers"

  Habitat.create do
    setting driver_directory : String = DEFAULT_DRIVER_DIRECTORY
    setting cache_duration : Time::Span = 24.hours
  end
end
