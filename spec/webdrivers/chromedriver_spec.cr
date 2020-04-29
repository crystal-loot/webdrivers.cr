require "../spec_helper"

describe Webdrivers::Chromedriver do
  before_each { Webdrivers::Chromedriver.install }

  describe ".browser_version" do
    it "returns semver of installed browser version" do
      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 129,
        build: "4044"
      )

      Webdrivers::Chromedriver.browser_version.should eq(expected_semver)
    end
  end

  describe ".driver_version" do
    it "returns semver of installed chromedriver" do
      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 69,
        build: "4044"
      )

      Webdrivers::Chromedriver.driver_version.should eq(expected_semver)
    end
  end

  describe ".latest_driver_version" do
    it "returns semver of latest available driver version for download" do
      expected_semver = SemanticVersion.new(
        major: 81,
        minor: 0,
        patch: 69,
        build: "4044"
      )

      Webdrivers::Chromedriver.latest_driver_version.should eq(expected_semver)
    end
  end

  describe ".driver_path" do
    it "returns path to installed chromedriver" do
      expected_path = File.expand_path("~/.webdrivers/chromedriver", home: Path.home)

      Webdrivers::Chromedriver.driver_path.should eq(expected_path)
    end
  end

  describe ".remove" do
    it "deletes chromedriver" do
      File.exists?(Webdrivers::Chromedriver.driver_path).should be_true
      Webdrivers::Chromedriver.remove
      File.exists?(Webdrivers::Chromedriver.driver_path).should be_false
    end
  end

  describe ".install" do
    it "installs the latest chromedriver" do
      Webdrivers::Chromedriver.remove
      driver_path = Webdrivers::Chromedriver.driver_path

      File.exists?(driver_path).should be_false
      Webdrivers::Chromedriver.install
      File.exists?(driver_path).should be_true
    end

    it "returns the filepath to the installed chromedriver" do
      expected_path = Webdrivers::Chromedriver.driver_path

      Webdrivers::Chromedriver.install.should eq(expected_path)
    end
  end
end
