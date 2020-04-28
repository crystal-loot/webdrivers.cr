require "./chrome/**"

class Webdrivers::Chromedriver
  def browser_version : SemanticVersion?
    Chrome::BrowserVersionFinder.find
  end

  def driver_version : SemanticVersion?
    Chrome::DriverVersionFinder.find_current
  end

  def latest_driver_version : SemanticVersion?
    Chrome::DriverVersionFinder.find_latest
  end
end
