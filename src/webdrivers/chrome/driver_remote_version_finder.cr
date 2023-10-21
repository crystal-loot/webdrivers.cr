class Webdrivers::Chrome::DriverRemoteVersionFinder
  getter cache_path : String
  getter version : SemanticVersion?

  def initialize(driver_directory, @version = nil, cache_file = "chromedriver.version")
    @cache_path = File.join(driver_directory, cache_file)
  end

  def find : SemanticVersion?
    find_raw_version.try { |raw_version| SemverConverter.convert(raw_version) }
  end

  private def find_raw_version
    Cache.fetch(cache_path, Webdrivers.settings.cache_duration) do
      if v = version
        if v.major < 113
          fetch_legacy_version(v)
        else
          fetch_latest_version(v)
        end
      else
        fetch_latest_stable
      end
    end
  end

  private def fetch_legacy_version(version : SemanticVersion)
    response = HTTP::Client.get("https://chromedriver.storage.googleapis.com/LATEST_RELEASE_#{version.major}")
    response.body
  end

  private def fetch_latest_version(version : SemanticVersion)
    response = HTTP::Client.get("#{chrome_for_testing_base_url}/LATEST_RELEASE_#{version.major}")
    response.body
  end

  private def fetch_latest_stable
    response = HTTP::Client.get("#{chrome_for_testing_base_url}/last-known-good-versions-with-downloads.json")
    google = JSON.parse(response.body)
    google.dig("channels", "Stable", "version").as_s
  end

  private def chrome_for_testing_base_url : String
    "https://googlechromelabs.github.io/chrome-for-testing"
  end
end
