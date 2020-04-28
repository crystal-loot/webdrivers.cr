class Webdrivers::Chrome::BrowserVersionFinder
  def self.find : SemanticVersion?
    location = mac_location
    return if location.nil?

    extract_semver(mac_version(location))
  end

  private def self.mac_location : String?
    directories = ["", File.expand_path("~", home: Path.home)]
    files = [
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      "/Applications/Chromium.app/Contents/MacOS/Chromium"
    ]

    directories.each do |dir|
      files.each do |file|
        option = "#{dir}/#{file}"
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
    return if version.nil?

    match = version.match(/(?<major>\d+)\.(?<minor>\d+)\.(?<build>\d+)\.(?<patch>\d+)/)
    return if match.nil?

    SemanticVersion.new(
      major: match["major"].to_i,
      minor: match["minor"].to_i,
      patch: match["patch"].to_i,
      build: match["build"],
    )
  end

  private def self.os : String
    {% if flag?(:linux) %}
      "linux"
    {% elsif flag?(:darwin) %}
      "mac"
    {% else %}
      raise "This OS is not supported yet."
    {% end %}
  end
end
