class Webdrivers::Chrome::DriverRemoteVersionFinder
  getter driver_directory : String

  def initialize(@driver_directory)
  end

  def find : SemanticVersion?
    find_raw_version.try { |raw_version| SemverConverter.convert(raw_version) }
  end

  private def find_raw_version
    Cache.fetch(cache_path, Webdrivers.settings.cache_duration) do
      response = HTTP::Client.get("https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
      response.body
    end
  end

  private def cache_path
    File.join(driver_directory, "chromedriver.version")
  end
end
