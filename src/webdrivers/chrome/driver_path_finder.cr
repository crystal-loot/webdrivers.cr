class Webdrivers::Chrome::DriverPathFinder
  DEFAULT_INSTALL_DIR = "~/.webdrivers"

  getter driver_name : String

  def initialize(@driver_name)
  end

  def find
    File.join(install_dir, driver_name)
  end

  private def install_dir : String
    File.expand_path(DEFAULT_INSTALL_DIR, home: Path.home)
  end
end
