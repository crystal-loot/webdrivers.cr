module Webdrivers::Cache
  def self.fetch(cache_path : String, expires_in : Time::Span, &)
    value = read(cache_path, expires_in)
    return value if value

    value = yield

    write(value, expires_in, cache_path)
    value
  end

  def self.delete(cache_path) : Nil
    if File.exists?(cache_path)
      File.delete(cache_path)
    end
  end

  private def self.write(value, expires_in, cache_path)
    ensure_cache_path(File.dirname(cache_path))

    File.write(cache_path, value)
  end

  private def self.read(cache_path, expires_in) : String?
    return unless File.exists?(cache_path)

    actual_duration = Time.utc - File.info(cache_path).modification_time
    return if actual_duration >= expires_in

    File.read(cache_path)
  end

  private def self.ensure_cache_path(path)
    FileUtils.mkdir_p(path) unless File.exists?(path)
  end
end
