class Webdrivers::Chrome::DriverPathFinder
  DEFAULT_INSTALL_DIR = "~/.webdrivers"

  getter driver_name : String

  def initialize(@driver_name)
  end

  def find
    File.expand_path(File.join(install_dir, driver_name), home: Path.home)
  end

  private def install_dir : String
    DEFAULT_INSTALL_DIR
  end
end
