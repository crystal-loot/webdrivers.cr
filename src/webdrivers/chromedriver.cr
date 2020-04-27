require "./chrome/**"

class Webdrivers::Chromedriver
  def browser_version : SemanticVersion?
    Chrome::BrowserVersionFinder.find
  end

  def driver_version : SemanticVersion?
    binary_version = binary_version(driver_path)
    extract_semver(binary_version)
  end

  private def driver_path : String
    File.expand_path(File.join(install_dir, driver_name), home: Path.home)
  end

  private def install_dir : String
    default_install_dir = "~/.webdrivers"
  end

  private def driver_name : String
    {% if flag?(:win32) %}
      "chromedriver.exe"
    {% else %}
      "chromedriver"
    {% end %}
  end

  private def binary_version(driver_path) : String?
    output = Process.run(driver_path, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end

  def extract_semver(binary_version) : SemanticVersion?
    return if binary_version.nil?

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
