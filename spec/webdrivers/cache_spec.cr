require "../spec_helper"

describe Webdrivers::Cache do
  describe ".fetch" do
    it "returns cached file content if found" do
      with_tempfile do |path|
        result = Webdrivers::Cache.fetch(path, 10.hours) { "goodbye!" }

        result.should eq "hello!"
      end
    end

    it "returns block result if cache file not found" do
      with_missing_file do |path|
        result = Webdrivers::Cache.fetch(path, 10.hours) { "goodbye!" }

        result.should eq "goodbye!"
      end
    end

    it "writes block result to cache file path if cache file not found" do
      with_missing_file do |path|
        Webdrivers::Cache.fetch(path, 10.hours) { "goodbye!" }

        File.exists?(path).should be_true
      end
    end

    it "overwrites existing cache file path with block result if modification time too old" do
      with_tempfile do |path|
        File.utime(1.day.ago, 1.day.ago, path)
        result = Webdrivers::Cache.fetch(path, 10.hours) { "goodbye!" }

        result.should eq "goodbye!"
        File.read(path).should eq "goodbye!"
      end
    end
  end
end

private def with_tempfile
  tempfile = File.tempfile(suffix: ".txt") do |file|
    file.print("hello!")
  end
  yield tempfile.path
ensure
  tempfile.try(&.delete)
end

private def with_missing_file
  tempname = File.tempname(suffix: ".txt")
  yield tempname
ensure
  tempname.try do |temp_path|
    FileUtils.rm(temp_path) if File.exists?(temp_path)
  end
end
