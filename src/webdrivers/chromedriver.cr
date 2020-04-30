require "./chrome/**"

class Webdrivers::Chromedriver
  def self.browser_version : SemanticVersion?
    Chrome::BrowserVersionFinder.new.find
  end

  def self.driver_version : SemanticVersion?
    Chrome::DriverLocalVersionFinder.new(driver_path).find
  end

  def self.latest_driver_version : SemanticVersion?
    Chrome::DriverRemoteVersionFinder.new(Common.driver_directory, browser_version).find
  end

  def self.driver_path : String
    File.join(Common.driver_directory, driver_name)
  end

  def self.remove
    Common.remove(driver_path)
  end

  def self.install : String
    Chrome::InstallDriverExecutor.new(
      install_version: latest_driver_version.not_nil!,
      current_version: driver_version,
      driver_directory: Common.driver_directory,
      driver_name: driver_name
    ).execute
    driver_path
  end

  def self.driver_name : String
    if Common.os == Common::OS::Windows
      "chromedriver.exe"
    else
      "chromedriver"
    end
  end
end
