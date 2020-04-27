require "../spec_helper"

describe Webdrivers::Chromedriver do
  describe "#browser_version" do
    it "returns semver of installed browser version" do
      chromedriver = Webdrivers::Chromedriver.new

      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 122,
        build: "4044"
      )
      chromedriver.browser_version.should eq(expected_semver)
    end
  end

  describe "#driver_version" do

  end
  
  describe "#update" do
    pending "does nothing when latest and current version match"
    pending "does nothing when offline"
    pending "does nothing when unable to find latest release"
    pending "downloads latest binary if current is older"
    pending "downloads latest binary if current is missing"
  end
end
