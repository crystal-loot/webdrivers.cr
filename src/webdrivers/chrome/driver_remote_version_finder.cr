class Webdrivers::Chrome::DriverRemoteVersionFinder
  def find
    response = HTTP::Client.get("https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
    raw_version = response.body
    return if raw_version.nil?

    extract_semver(raw_version)
  end

  private def binary_version(driver_path : String) : String?
    output = Process.run(driver_path, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end

  private def extract_semver(binary_version : String) : SemanticVersion?
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
