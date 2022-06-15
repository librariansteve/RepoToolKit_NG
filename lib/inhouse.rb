# renames marcxml file for xslt to process
module Rename
  def rename_mrc_xml
    files = Dir.glob('*.xml')
    if files.count() > 1
      puts 'Directory contains more than 1 XML file:'
      puts files.to_s
      puts
      puts 'Which is the XML file containing the metadata for ingest?'
      print $prompt
      @filex = gets.chomp.strip
	  while files.include?(@filex) == false
        puts
        puts @filex + ' is not one of the choices'
        puts 'Which is the XML file containing the metadata for ingest?'
        print $prompt
        @filex = gets.chomp.strip
      end
    else
      @filex = files.to_s.gsub(/\[\"|\"\]/, '')
    end
    
    File.rename @filex, 'inHouse.xml'
    self
  end

  def rename_xml_to_original
    File.rename 'inHouse.xml', @filex
    self
  end
end
