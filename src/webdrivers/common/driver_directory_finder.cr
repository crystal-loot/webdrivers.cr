class Webdrivers::Common::DriverDirectoryFinder
  DEFAULT_INSTALL_DIR = "~/.webdrivers"

  def find
    File.expand_path(DEFAULT_INSTALL_DIR, home: Path.home)
  end
end
