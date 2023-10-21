class Webdrivers::Chrome::InstallDriverExecutor
  getter install_version : SemanticVersion
  getter current_version : SemanticVersion?
  getter driver_directory : String
  getter driver_name : String
  getter cache_path : String

  def initialize(@install_version, @driver_directory, @driver_name, @current_version)
    @cache_path = File.join(Common.driver_directory, "chromedriver.download_url")
  end

  def execute
    return if current_version == install_version

    Dir.mkdir_p(driver_directory) unless File.exists?(driver_directory)

    if install_version.major < 115
      normalized_driver_name = driver_name
    else
      normalized_driver_name = "chromedriver-#{download_url_platform}/#{driver_name}"
    end

    FileUtils.cd(driver_directory) do
      zip = download_file(from: download_url, to: download_url_filename)
      Common::ZipExtractor.new(zip, normalized_driver_name, driver_directory).extract
      zip.delete
      File.chmod(driver_name, Common::EXECUTABLE_PERMISSIONS)
    end
  end

  private def download_file(from, to) : File
    HTTP::Client.get(from) do |response|
      File.write(to, response.body_io, mode: "wb")
    end

    File.new(to, mode: "rb")
  end

  private def download_url : String
    if install_version.major < 115
      "https://chromedriver.storage.googleapis.com/#{converted_version}/#{download_url_filename}"
    else
      fetch_download_url_for_version
    end
  end

  private def fetch_download_url_for_version : String
    Cache.fetch(cache_path, Webdrivers.settings.cache_duration) do
      response = HTTP::Client.get("#{chrome_for_testing_base_url}/known-good-versions-with-downloads.json")
      google = JSON.parse(response.body.to_s)
      downloads = google["versions"].as_a
      version_found = downloads.find! { |version| version["version"].as_s == converted_version }
      platforms = version_found.dig("downloads", "chromedriver").as_a
      platform_found = platforms.find! { |platform| platform["platform"].as_s == download_url_platform }
      platform_found["url"].as_s
    end
  end

  private def converted_version : String
    SemverConverter.convert(install_version)
  end

  private def chrome_for_testing_base_url : String
    "https://googlechromelabs.github.io/chrome-for-testing"
  end

  # TODO: Support Win64, and Mac Intel
  private def download_url_platform : String
    case Common.os
    when Common::OS::Linux
      "linux64"
    when Common::OS::Mac
      "mac-x64"
    when Common::OS::Windows
      "win32"
    else
      raise "Unknown os"
    end
  end

  private def download_url_filename : String
    case Common.os
    when Common::OS::Linux
      "chromedriver_linux64.zip"
    when Common::OS::Mac
      "chromedriver_mac64.zip"
    when Common::OS::Windows
      "chromedriver_win32.zip"
    else
      raise "Unknown os"
    end
  end
end
