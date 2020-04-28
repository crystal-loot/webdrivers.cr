class Webdrivers::Chrome::DeleteDriverExecutor
  getter driver_path : String
  def initialize(@driver_path)
  end

  def execute
    return unless File.exists?(driver_path)

    File.delete(driver_path)
  end
end
