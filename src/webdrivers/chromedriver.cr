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
    Chrome::DriverPathFinder.new.find
  end

  def remove
    Chrome::DeleteDriverExecutor.new(driver_path).execute
  end

  def install
    latest_version = latest_driver_version
    return if driver_version == latest_version

    Chrome::InstallDriverExecutor.new(latest_version.not_nil!, File.dirname(driver_path)).execute
  end
end
