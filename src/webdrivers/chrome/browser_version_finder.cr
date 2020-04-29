class Webdrivers::Chrome::BrowserVersionFinder
  def self.find : SemanticVersion?
    location = mac_location
    return if location.nil?

    version = mac_version(location)
    return if version.nil?

    BrowserSemverConverter.convert(version)
  end

  def win_location : String?
    envs = ["LOCALAPPDATA", "PROGRAMFILES", "PROGRAMFILES(X86)"]
    directories = ["\\Google\\Chrome\\Application", "\\Chromium\\Application"]
    file = "chrome.exe"

    directories.each do |dir|
      envs.each do |root|
        option = File.join(ENV[root], dir, file)
        return option if File.exist?(option)
      end
    end

    nil
  end

  private def linux_location : String?
    directories = ["/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin", "/snap/bin", "/opt/google/chrome"]
    files = ["google-chrome", "chrome", "chromium", "chromium-browser"]

    directories.each do |dir|
      files.each do |file|
        option = File.join(dir, file)
        return option if File.exist?(option)
      end
    end

    nil
  end

  private def self.mac_location : String?
    directories = ["", File.expand_path("~", home: Path.home)]
    files = [
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      "/Applications/Chromium.app/Contents/MacOS/Chromium",
    ]

    directories.each do |dir|
      files.each do |file|
        option = File.join(dir, file)
        return option if File.exists?(option)
      end
    end

    nil
  end

  private def self.mac_version(location) : String
    output = Process.run(location, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end

  private def self.extract_semver(version) : SemanticVersion?
  end
end
