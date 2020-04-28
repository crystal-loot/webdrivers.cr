require "../spec_helper"

describe Webdrivers::Chromedriver do
  before_each { Webdrivers::Chromedriver.new.install }

  describe "#browser_version" do
    it "returns semver of installed browser version" do
      chromedriver = Webdrivers::Chromedriver.new

      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 129,
        build: "4044"
      )
      chromedriver.browser_version.should eq(expected_semver)
    end
  end

  describe "#driver_version" do
    it "returns semver of installed chromedriver" do
      chromedriver = Webdrivers::Chromedriver.new

      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 69,
        build: "4044"
      )
      chromedriver.driver_version.should eq(expected_semver)
    end
  end

  describe "#latest_driver_version" do
    it "returns semver of latest available driver version for download" do
      chromedriver = Webdrivers::Chromedriver.new

      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 69,
        build: "4044"
      )
      chromedriver.latest_driver_version.should eq(expected_semver)
    end
  end

  describe "#driver_path" do
    it "returns path to installed chromedriver" do
      chromedriver = Webdrivers::Chromedriver.new

      expected_path = File.expand_path("~/.webdrivers/chromedriver", home: Path.home)
      chromedriver.driver_path.should eq(expected_path)
    end
  end

  describe "#remove" do
    it "deletes chromedriver" do
      chromedriver = Webdrivers::Chromedriver.new

      File.exists?(chromedriver.driver_path).should be_true
      chromedriver.remove
      File.exists?(chromedriver.driver_path).should be_false
    end
  end

  describe "#install" do
    it "installs the latest chromedriver" do
      chromedriver = Webdrivers::Chromedriver.new
      chromedriver.remove

      File.exists?(chromedriver.driver_path).should be_false
      chromedriver.install
      File.exists?(chromedriver.driver_path).should be_true
    end
  end
end
