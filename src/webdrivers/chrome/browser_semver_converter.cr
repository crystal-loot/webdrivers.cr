class Webdrivers::Chrome::BrowserSemverConverter
  def self.convert(raw_semver : String) : SemanticVersion?
    match = raw_semver.match(/(?<major>\d+)\.(?<minor>\d+)\.(?<build>\d+)\.(?<patch>\d+)/)
    return if match.nil?

    SemanticVersion.new(
      major: match["major"].to_i,
      minor: match["minor"].to_i,
      patch: match["patch"].to_i,
      build: match["build"],
    )
  end
end
