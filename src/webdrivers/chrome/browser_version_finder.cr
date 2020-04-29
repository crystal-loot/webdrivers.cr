class Webdrivers::Chrome::BrowserVersionFinder
  def self.find : SemanticVersion?
    os_specific_version.try { |version| BrowserSemverConverter.convert(version) }
  end

  private def self.os_specific_version : String?
    case Common.os
    when Common::OS::Windows
      windows_location.try { |location| windows_version(location) }
    when Common::OS::Linux
      linux_location.try { |location| linux_version(location) }
    when Common::OS::Mac
      mac_location.try { |location| mac_version(location) }
    else
      nil
    end
  end

  private def self.windows_location : String?
    envs = ["LOCALAPPDATA", "PROGRAMFILES", "PROGRAMFILES(X86)"]
    directories = ["\\Google\\Chrome\\Application", "\\Chromium\\Application"]
    file = "chrome.exe"

    directories.each do |dir|
      envs.each do |root|
        option = File.join(ENV[root], dir, file)
        return option if File.exists?(option)
      end
    end

    nil
  end

  private def self.linux_location : String?
    directories = ["/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin", "/snap/bin", "/opt/google/chrome"]
    files = ["google-chrome", "chrome", "chromium", "chromium-browser"]

    directories.each do |dir|
      files.each do |file|
        option = File.join(dir, file)
        return option if File.exists?(option)
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

  private def self.windows_version(location)
    output = Process.run("powershell (Get-ItemProperty '#{location}').VersionInfo.ProductVersion") do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end

  private def self.linux_version(location)
    output = Process.run(location, ["--product-version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end

  private def self.mac_version(location) : String
    output = Process.run(location, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end
end
