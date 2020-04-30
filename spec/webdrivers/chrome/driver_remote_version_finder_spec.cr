require "../../spec_helper"

module Webdrivers::Chrome
  describe DriverRemoteVersionFinder do
    before_each do
      finder = DriverRemoteVersionFinder.new(Common.driver_directory)
      File.delete(finder.cache_path) if File.exists?(finder.cache_path)
    end

    it "will limit return version to matching major version if version" do
      version = SemanticVersion.new(
        major: 71,
        minor: 22,
        patch: 1111
      )
      finder = DriverRemoteVersionFinder.new(Common.driver_directory, version)

      result = finder.find

      expected_version = SemanticVersion.new(
        major: 71,
        minor: 0,
        patch: 137,
        build: "3578"
      )
      result.should eq(expected_version)
    end
  end
end
