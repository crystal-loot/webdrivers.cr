class Webdrivers::Gecko::DriverRemoteVersionFinder
  getter cache_path : String

  def initialize(driver_directory)
    @cache_path = File.join(driver_directory, "geckodriver.version")
  end

  def find : SemanticVersion?
    find_raw_version.try { |raw_version| SemanticVersion.parse(raw_version) }
  end

  private def find_raw_version
    Cache.fetch(cache_path, Webdrivers.settings.cache_duration) do
      response = Halite.get(
        "https://github.com/mozilla/geckodriver/releases/latest",
        headers: { "Accept" => "application/json" }
      )
      raise response.body if response.status_code >= 300
      tag = response.parse["tag_name"]?.try &.as_s
      tag.try &.lchop('v') # the tags are always like v1.0.0
    end
  end
end
