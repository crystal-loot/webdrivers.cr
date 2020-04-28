class Webdrivers::Chrome::InstallDriverExecutor
  getter install_version : SemanticVersion
  getter current_version : SemanticVersion?
  getter download_directory : String
  getter driver_name : String

  def initialize(@install_version, @download_directory, @driver_name, @current_version)
  end

  def execute
    return if current_version == install_version

    Dir.mkdir_p(download_directory) unless File.exists?(download_directory)

    file_name = File.basename(download_url)
    FileUtils.cd(download_directory) do
      HTTP::Client.get(download_url) do |response|
        File.write(file_name, response.body_io, mode: "wb")
      end

      tempfile = File.new(file_name, mode: "rb")

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

  private def converted_version : String
    DriverSemverConverter.convert(install_version)
  end
end
