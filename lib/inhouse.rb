# renames marcxml file for xslt to process
module Rename
  def rename_mrc_xml
    if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    files = Dir.glob('*.xml')
    if files.count() > 1
      if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
      puts 'Directory contains more than 1 XML file:'
      puts files.to_s
      puts
      puts 'Which is the XML file containing the metadata for ingest?'
      print $prompt
      @filex = gets.chomp.strip
      if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
	  while files.include?(@filex) == false
        puts
        puts @filex + ' is not one of the choices'
        puts 'Which is the XML file containing the metadata for ingest?'
        print $prompt
        @filex = gets.chomp.strip
      end
    else
      if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
      @filex = files.to_s.gsub(/\[\"|\"\]/, '')
    end

    if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    File.rename @filex, 'inHouse.xml'
    self
  end

  def rename_xml_to_original
    if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    File.rename 'inHouse.xml', @filex
    self
  end
end
