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
      HTTP::Client.get("https://github.com/mozilla/geckodriver/releases/latest") do |redirect_response|
        redirect_location = redirect_response.headers["location"]
        headers = HTTP::Headers{"Accept" => "application/json"}
        HTTP::Client.get(redirect_location, headers: headers) do |response|
          raise response.body if response.status_code >= 300
          tag = JSON.parse(response.body_io)["tag_name"]?.try &.as_s
          tag.try &.lchop('v') # the tags are always like v1.0.0
        end
      end
    end
  end
end
