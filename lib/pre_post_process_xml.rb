# Create and remove directories for each ingest method
module CleanUpXML
  def postprocess_excel_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Postprocessing'
    Dir.chdir('xml')
    @f = Time.now.strftime('%F-%H%M%S') + '_ExcelBased'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    FileUtils.rm('firstTransform.xml')
    FileUtils.rm('workWithThis.xml')
    FileUtils.rm('collection.xml')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def postprocess_marc_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Postprocessing'
    Dir.chdir('xml')
    @f = Time.now.strftime('%F-%H%M%S') + '_MARC'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def preprocess_springer_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Postprocessing'
    FileUtils.mv Dir.glob('**/*.Meta'), 'xml'
    Dir.chdir('xml')
    Dir.entries('.').each do |entry|
      if entry.match('\d.*\.xml\.Meta')
        File.rename(entry, entry.gsub('.Meta', ''))
      end
    end
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def postprocess_springer_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Postprocessing'
    FileUtils.mv Dir.glob('**/JOU=*'), 'springer'
	if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.chdir('springer')

    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.chdir('..')
    FileUtils.remove_entry 'springer'
    Dir.chdir('xml')
    FileUtils.rm('collection.xml')
    FileUtils.mv Dir.glob('[1-9]*.xml'), 'springer_original_xml'
    Dir.chdir('springer_original_xml')

    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.chdir('..')
    @f = Time.now.strftime('%F-%H%M%S') + '_Springer'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def postprocess_acm_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Postprocessing'
    Dir.chdir('xml')
    @f = Time.now.strftime('%F-%H%M%S') + '_ACM'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def postprocess_proquest_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Postprocessing'
    Dir.chdir('xml')
    @f = Time.now.strftime('%F-%H%M%S') + '_Proquest'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    FileUtils.rm('collection.xml')
    FileUtils.mv Dir.glob('*_DATA.xml'), 'proquest_original_xml'
    Dir.chdir('proquest_original_xml')
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end
end
