require "./chrome/**"

class Webdrivers::Chromedriver
  def browser_version : SemanticVersion?
    Chrome::BrowserVersionFinder.find
  end

  def driver_version : SemanticVersion?
    Chrome::DriverLocalVersionFinder.new(driver_path).find
  end

  def latest_driver_version : SemanticVersion?
    Chrome::DriverRemoteVersionFinder.new.find
  end

  def driver_path : String
    Chrome::DriverPathFinder.new(driver_name).find
  end

  def remove
    Chrome::DeleteDriverExecutor.new(driver_path).execute
  end

  def install
    Chrome::InstallDriverExecutor.new(
      install_version: latest_driver_version.not_nil!,
      current_version: driver_version,
      download_directory: File.dirname(driver_path),
      driver_name: driver_name
    ).execute
  end

  def driver_name : String
    {% if flag?(:win32) %}
      "chromedriver.exe"
    {% else %}
      "chromedriver"
    {% end %}
  end
end
