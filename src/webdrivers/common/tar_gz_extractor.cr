class Webdrivers::Common::TarGzExtractor
  getter file : File
  getter driver_name : String
  getter install_path : String

  def initialize(@file, @driver_name, @install_path)
  end

  def extract
    Compress::Gzip::Reader.open(file) do |gzip|
      Crystar::Reader.open(gzip) do |tar|
        entry = tar.next_entry.not_nil!
        destination_path = File.join(install_path, entry.name)
        File.delete(destination_path) if File.exists?(destination_path)
        File.write(destination_path, entry.io)
      end
    end
  end
end
