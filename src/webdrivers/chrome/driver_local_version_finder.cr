class Webdrivers::Chrome::DriverLocalVersionFinder
  getter driver_path : String
  def initialize(@driver_path)
  end

  def find
    binary_version = binary_version(driver_path)
    return if binary_version.nil?

    DriverSemverConverter.convert(binary_version)
  end

  private def binary_version(driver_path : String) : String?
    output = Process.run(driver_path, ["--version"]) do |proc|
      proc.output.gets_to_end
    end
    output.strip
  end
end
