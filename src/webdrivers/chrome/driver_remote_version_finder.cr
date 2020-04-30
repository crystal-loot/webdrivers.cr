class Webdrivers::Chrome::DriverRemoteVersionFinder
  getter cache_path : String
  getter version : SemanticVersion?

  def initialize(driver_directory, @version = nil)
    @cache_path = File.join(driver_directory, "chromedriver.version")
  end

  def find : SemanticVersion?
    find_raw_version.try { |raw_version| SemverConverter.convert(raw_version) }
  end

  private def find_raw_version
    Cache.fetch(cache_path, Webdrivers.settings.cache_duration) do
      response = HTTP::Client.get("https://chromedriver.storage.googleapis.com/#{latest_release}")
      response.body
    end
  end

  private def latest_release
    limitting_version = version
    return "LATEST_RELEASE" if limitting_version.nil?

    "LATEST_RELEASE_#{limitting_version.major}"
  end
end
