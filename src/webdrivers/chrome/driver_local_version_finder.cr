class Webdrivers::Chrome::DriverLocalVersionFinder
  getter driver_path : String

  def initialize(@driver_path)
  end

  def find
    return unless File.exists?(driver_path)

    binary_version = binary_version(driver_path)
    return if binary_version.nil?

    SemverConverter.convert(binary_version)
  end

  private def binary_version(driver_path : String) : String?
    output = Process.run(driver_path, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end
end
