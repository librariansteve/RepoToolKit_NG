# Create and remove directories for each ingest method
module CleanUpXML
  def postprocess_excel_xml
    Dir.chdir('xml')
    @f = Time.now.strftime('%F-%H%M%S') + '_ExcelBased'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    FileUtils.rm('firstTransform.xml')
    FileUtils.rm('workWithThis.xml')
    FileUtils.rm('collection.xml')
    self
  end
  
    def postprocess_alma_xml
      Dir.chdir('xml')
      @f = Time.now.strftime('%F-%H%M%S') + '_Alma'
      File.rename('ingestThis.xml', @f + '_Ingest.xml')
      self
    end

  def preprocess_springer_xml
    FileUtils.mv Dir.glob('**/*.Meta'), 'xml'
    Dir.chdir('xml')
    Dir.entries('.').each do |entry|
      puts entry
      if entry.match('\d.*\.xml\.Meta')
        File.rename(entry, entry.gsub('.Meta', ''))
        puts 'changed!'
      end
    end
    self
  end

  def postprocess_springer_xml
    FileUtils.mv Dir.glob('JOU*'), 'springer'
    Dir.chdir('springer')
    Dir.entries('.').each do |entry|
      puts entry
    end
    Dir.chdir('..')
    FileUtils.remove_entry 'springer'
    Dir.chdir('xml')
    FileUtils.rm('collection.xml')
    FileUtils.mv Dir.glob('[1-9]*.xml'), 'springer_original_xml'
    Dir.chdir('springer_original_xml')
    Dir.entries('.').each do |entry|
      puts entry
    end
    Dir.chdir('..')
    @f = Time.now.strftime('%F-%H%M%S') + '_Springer'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    self
  end

  def postprocess_proquest_xml
    Dir.chdir('xml')
    @f = Time.now.strftime('%F-%H%M%S') + '_Proquest'
    File.rename('ingestThis.xml', @f + '_Ingest.xml')
    FileUtils.rm('collection.xml')
    FileUtils.mv Dir.glob('*_DATA.xml'), 'proquest_original_xml'
    Dir.chdir('proquest_original_xml')
    Dir.entries('.').each do |entry|
      puts entry
    end
    self
  end
end
