class Webdrivers::Chrome::DriverPathFinder
  DEFAULT_INSTALL_DIR = "~/.webdrivers"

  def find
    File.expand_path(File.join(install_dir, driver_name), home: Path.home)
  end

  private def install_dir : String
    DEFAULT_INSTALL_DIR
  end

  private def driver_name : String
    {% if flag?(:win32) %}
      "chromedriver.exe"
    {% else %}
      "chromedriver"
    {% end %}
  end
end
