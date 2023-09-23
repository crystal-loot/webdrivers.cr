class Webdrivers::Common::TarGzExtractor
  getter file : File
  getter driver_name : String
  getter install_path : String

  def initialize(@file, @driver_name, @install_path)
  end

  def extract
    Compress::Gzip::Reader.open(file) do |gzip|
      Crystar::Reader.open(gzip) do |tar|
        if next_entry = tar.next_entry
          entry = next_entry
          destination_path = File.join(install_path, entry.name)
          File.delete(destination_path) if File.exists?(destination_path)
          File.write(destination_path, entry.io)
        end
      end
    end
  end
end
