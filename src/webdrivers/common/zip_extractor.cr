class Webdrivers::Common::ZipExtractor
  getter zip_file : File
  getter driver_name : String
  getter install_path : String

  def initialize(@zip_file, @driver_name, @install_path)
  end

  def extract
    Compress::Zip::File.open(zip_file) do |zip_contents|
      begin
        driver = zip_contents[driver_name]
      rescue
        pp! zip_contents.entries
        raise "Entry #{driver_name} not found in zip"
      end
      filepath = driver.filename.split(File::SEPARATOR).last
      destination_path = File.join(install_path, filepath)
      File.delete(destination_path) if File.exists?(destination_path)
      driver.open { |io| File.write(destination_path, io) }
    end
  end
end
