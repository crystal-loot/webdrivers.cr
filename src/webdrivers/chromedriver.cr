require "./chrome/**"

class Webdrivers::Chromedriver
  def browser_version : SemanticVersion?
    Chrome::BrowserVersionFinder.find
  end
end
