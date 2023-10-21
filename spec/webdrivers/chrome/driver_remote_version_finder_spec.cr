require "../../spec_helper"

module Webdrivers::Chrome
  describe DriverRemoteVersionFinder do
    Spec.around_each do |example|
      example.run
    ensure
      finder = DriverRemoteVersionFinder.new(Common.driver_directory, cache_file: "chromedriver.version.test")
      Webdrivers::Cache.delete(finder.cache_path)
    end

    it "will limit return version to matching major version when version is provided" do
      version = SemanticVersion.new(
        major: 71,
        minor: 22,
        patch: 1111
      )
      finder = DriverRemoteVersionFinder.new(Common.driver_directory, version, "chromedriver.version.test")

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
