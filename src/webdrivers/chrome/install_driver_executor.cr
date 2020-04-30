class Webdrivers::Chrome::InstallDriverExecutor
  getter install_version : SemanticVersion
  getter current_version : SemanticVersion?
  getter driver_directory : String
  getter driver_name : String

  def initialize(@install_version, @driver_directory, @driver_name, @current_version)
  end

  def execute
    return if current_version == install_version

    Dir.mkdir_p(driver_directory) unless File.exists?(driver_directory)

    FileUtils.cd(driver_directory) do
      zip = download_file(from: download_url, to: download_url_filename)
      Common::ZipExtractor.new(zip, driver_name, driver_directory).extract
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

  private def download_url
    "https://chromedriver.storage.googleapis.com/#{converted_version}/#{download_url_filename}"
  end

  private def converted_version : String
    SemverConverter.convert(install_version)
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
