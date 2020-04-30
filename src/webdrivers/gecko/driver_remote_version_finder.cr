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
      response = HTTP::Client.get("https://github.com/mozilla/geckodriver/releases/latest")
      raise response.body if response.status_code != 302 # expect a redirect
      response = HTTP::Client.get(response.headers["location"], headers: HTTP::Headers{"Accept" => "application/json"})
      raise response.body if response.status_code >= 300
      tag = JSON.parse(response.body)["tag_name"]?.try &.as_s
      tag.try &.lchop('v') # the tags are always like v1.0.0
    end
  end
end
