class Webdrivers::Chrome::DriverSemverConverter
  def self.convert(raw_semver : String) : SemanticVersion?
    match = raw_semver.match(/(?<major>\d+)\.(?<minor>\d+)(\.(?<build>\d+))?(\.(?<patch>\d+))?/)
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
