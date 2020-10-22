require "../spec_helper"

module Webdrivers
  describe Geckodriver do
    describe ".remove" do
      it "deletes driver" do
        Geckodriver.install

        File.exists?(Geckodriver.driver_path).should be_true
        Geckodriver.remove
        File.exists?(Geckodriver.driver_path).should be_false
      end
    end

    describe ".install" do
      it "installs the driver in the expected place" do
        Geckodriver.remove
        driver_path = Geckodriver.driver_path

        File.exists?(driver_path).should be_false
        Geckodriver.install
        File.exists?(driver_path).should be_true
      end

      it "returns the filepath to the installed driver" do
        expected_path = Geckodriver.driver_path

        Geckodriver.install.should eq(expected_path)
      end

      it "installs the latest driver" do
        Geckodriver.install

        Geckodriver.driver_version.should eq(Geckodriver.latest_driver_version)
      end
    end
  end
end
