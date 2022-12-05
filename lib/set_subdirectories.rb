# Create subdirectories specific for each ingest process
module CreateSubdirectories
  def excel_subfolders
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.mkdir('xml')
    unless Dir.glob('*.pdf').empty?
      Dir.mkdir('pdf')
    end
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    unless Dir.glob('*.tif').empty?
      Dir.mkdir('tif')
    end
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def springer_subfolders
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.mkdir('xml')
    Dir.mkdir('xml/springer_original_xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    Dir.mkdir('springer')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def proquest_subfolders
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.mkdir('xml')
    Dir.mkdir('xml/proquest_original_xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def inhouse_subfolders
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.mkdir('xml')
    Dir.mkdir('pdf')
    Dir.mkdir('mrc')
    Dir.mkdir('zip')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end
end
