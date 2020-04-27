class Webdrivers::Chrome::DriverVersionFinder
  DEFAULT_INSTALL_DIR = "~/.webdrivers"

  def self.find
    binary_version = binary_version(driver_path)
    return if binary_version.nil?

    extract_semver(binary_version)
  end

  private def self.driver_path : String
    File.expand_path(File.join(install_dir, driver_name), home: Path.home)
  end

  private def self.install_dir : String
    DEFAULT_INSTALL_DIR
  end

  private def self.driver_name : String
    {% if flag?(:win32) %}
      "chromedriver.exe"
    {% else %}
      "chromedriver"
    {% end %}
  end

  private def self.binary_version(driver_path : String) : String?
    output = Process.run(driver_path, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end

  private def self.extract_semver(binary_version : String) : SemanticVersion?
    match = binary_version.match(/(?<major>\d+)\.(?<minor>\d+)(\.(?<build>\d+))?(\.(?<patch>\d+))?/)
    return if match.nil?

    patch = match["patch"]?.try(&.to_i) || 0
    SemanticVersion.new(
      major: match["major"].to_i,
      minor: match["minor"].to_i,
      patch: patch,
      build: match["build"]?
    )
  end
end
