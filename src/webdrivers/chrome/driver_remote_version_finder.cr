class Webdrivers::Chrome::DriverRemoteVersionFinder
  def find
    response = HTTP::Client.get("https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
    raw_version = response.body
    return if raw_version.nil?

    DriverSemverConverter.convert(raw_version)
  end

  private def binary_version(driver_path : String) : String?
    output = Process.run(driver_path, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end
end
