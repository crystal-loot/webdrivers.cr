class Webdrivers::Chrome::InstallDriverExecutor
  getter version : SemanticVersion
  getter download_directory : String

  def initialize(@version, @download_directory)
  end

  def execute
    Dir.mkdir_p(download_directory) unless File.exists?(download_directory)

    file_name = File.basename(download_url)
    FileUtils.cd(download_directory) do
      HTTP::Client.get(download_url) do |response|
        File.write("chromedriver_mac64.zip", response.body_io, mode: "wb")
      end

      tempfile = File.new("chromedriver_mac64.zip", mode: "rb")

      Zip::File.open(tempfile) do |zip_file|
        driver = zip_file[driver_name]
        dest_path = File.join(FileUtils.pwd, driver.filename)
        File.delete(dest_path) if File.exists?(dest_path)
        Dir.mkdir_p(File.dirname(dest_path)) unless File.exists?(File.dirname(dest_path))
        driver.open { |io| File.write(dest_path, io) }
      end

      tempfile.delete
      File.chmod(driver_name, 0o0111)
    end
  end

  private def download_url
    "https://chromedriver.storage.googleapis.com/#{converted_version}/chromedriver_mac64.zip"
  end

  private def driver_name : String
    {% if flag?(:win32) %}
      "chromedriver.exe"
    {% else %}
      "chromedriver"
    {% end %}
  end

  private def converted_version : String
    DriverSemverConverter.convert(version)
  end
end
