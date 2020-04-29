require "../spec_helper"

describe Webdrivers::Chromedriver do
  describe ".remove" do
    it "deletes chromedriver" do
      Webdrivers::Chromedriver.install

      File.exists?(Webdrivers::Chromedriver.driver_path).should be_true
      Webdrivers::Chromedriver.remove
      File.exists?(Webdrivers::Chromedriver.driver_path).should be_false
    end
  end

  describe ".install" do
    it "installs the chromedriver in the expected place" do
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

    it "installs the latest chromedriver" do
      Webdrivers::Chromedriver.install

      Webdrivers::Chromedriver.driver_version.should eq(Webdrivers::Chromedriver.latest_driver_version)
    end
  end
end
