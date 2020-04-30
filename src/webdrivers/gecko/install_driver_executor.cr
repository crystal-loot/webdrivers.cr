class Webdrivers::Gecko::InstallDriverExecutor
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
      downloaded_file = download_file(from: download_url, to: download_url_filename)
      extract_file(downloaded_file)
      downloaded_file.delete
      File.chmod(driver_name, 0o0111)
    end
  end

  private def download_file(from, to) : File
    Halite.get(from) do |response|
      File.open(to, "w") do |file|
        IO.copy(response.body_io, file)
      end
    end

    File.new(to)
  end

  private def extract_file(file)
    if tar_file?
      Common::TarGzExtractor.new(file, driver_name, driver_directory).extract
    else
      Common::ZipExtractor.new(file, driver_name, driver_directory).extract
    end
  end

  private def download_url
    "https://github.com/mozilla/geckodriver/releases/download/#{version_tag}/#{download_url_filename}"
  end

  private def version_tag : String
    "v#{install_version}"
  end

  private def tar_file?
    download_url_filename.ends_with?(".tar.gz")
  end

  private def download_url_filename : String
    case Common.os
    when Common::OS::Linux
      "geckodriver-#{version_tag}-linux64.tar.gz"
    when Common::OS::Mac
      "geckodriver-#{version_tag}-macos.tar.gz"
    when Common::OS::Windows
      "geckodriver-#{version_tag}-win64.zip"
    else
      raise "Unknown os"
    end
  end
end
