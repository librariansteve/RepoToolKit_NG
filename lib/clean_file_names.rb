# User submitted filenames rarely follow best practices
module CleanFileNames
  def clean
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.entries('.').each do |entry|
      next if entry == '.' || entry == '..'
      File.rename(entry, entry.gsub(/[^0-9A-Z]/i, '_'))
    end

    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.entries('.').each do |entry|
      next if entry == '.' || entry == '..'
      File.rename(entry, entry.gsub(/\_(?=[^\_]+?$)/, '.'))
    end
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end
  self
end
