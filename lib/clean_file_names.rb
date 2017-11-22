# User submitted filenames rarely follow best practices
module CleanFileNames
  def clean
    Dir.entries('.').each do |entry|
      next if entry == '.' || entry == '..'
      File.rename(entry, entry.gsub(/[^0-9A-Z]/i, '_'))
    end

    Dir.entries('.').each do |entry|
      next if entry == '.' || entry == '..'
      File.rename(entry, entry.gsub(/\_(?=[^\_]+?$)/, '.'))
    end
    self
  end
  self
end
