module Webdrivers::Common
  def self.os : OS
    {% if flag?(:darwin) %}
      OS::Mac
    {% elsif flag?(:win32) %}
      OS::Windows
    {% else %}
      OS::Linux
    {% end %}
  end

  enum OS
    Mac
    Linux
    Windows
  end
end
