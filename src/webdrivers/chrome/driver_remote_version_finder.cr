class Webdrivers::Chrome::DriverRemoteVersionFinder
  def find
    response = HTTP::Client.get("https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
    raw_version = response.body
    return if raw_version.nil?

    DriverSemverConverter.convert(raw_version)
  end
end
