module Webdrivers::Common
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

  enum OS
    Mac
    Linux
    Windows
    Other
  end
end
