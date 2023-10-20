class Webdrivers::Chrome::DriverRemoteVersionFinder
  getter cache_path : String
  getter version : SemanticVersion?

  # Since Chrome v115+ the download locations have changed.
  # We can use https://github.com/GoogleChromeLabs/chrome-for-testing#json-api-endpoints
  # to find specific API endpoints
  MANIFEST_API_ENDPOINT = "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json"

  def initialize(driver_directory, @version = nil)
    @cache_path = File.join(driver_directory, "chromedriver.version")
  end

  def find : SemanticVersion?
    find_raw_version.try { |raw_version| SemverConverter.convert(raw_version) }
  end

  private def find_raw_version
    Cache.fetch(cache_path, Webdrivers.settings.cache_duration) do
      response = HTTP::Client.get(MANIFEST_API_ENDPOINT)
      google = JSON.parse(response.body)
      google.dig("channels", "Stable", "version").as_s
    end
  end
end
