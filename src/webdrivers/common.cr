module Webdrivers::Common
  EXECUTABLE_PERMISSIONS = 0x7777

  def self.os : OS
    {% if flag?(:darwin) %}
      OS::Mac
    {% elsif flag?(:win32) %}
      OS::Windows
    {% elsif flag?(:linux) %}
      OS::Linux
    {% else %}
      OS::Other
    {% end %}
  end

  def self.driver_directory
    File.expand_path(Webdrivers.settings.driver_directory, home: Path.home)
  end

  def self.remove(driver_path)
    return unless File.exists?(driver_path)

    if os.windows?
      File.delete(driver_path, 0o666)
    else
      File.delete(driver_path)
    end
  end

  enum OS
    Mac
    Linux
    Windows
    Other
  end
end
