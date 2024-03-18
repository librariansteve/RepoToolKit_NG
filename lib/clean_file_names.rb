# User submitted filenames rarely follow best practices
module CleanFileNames
  def clean
    $ui.debug()
    Dir.entries('.').each do |entry|
      next if entry == '.' || entry == '..'
      File.rename(entry, entry.gsub(/[^0-9A-Z]/i, '_'))
    end

    $ui.debug()
    Dir.entries('.').each do |entry|
      next if entry == '.' || entry == '..'
      File.rename(entry, entry.gsub(/\_(?=[^\_]+?$)/, '.'))
    end
    $ui.debug()
    self
  end
  self
end
