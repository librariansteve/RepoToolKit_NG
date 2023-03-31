# Change Excel to xml
module ToRoo
  def roo_to_xml
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    filex = Dir.glob('*.xlsx').to_s.gsub(/\[\"|\"\]/, '')
    require 'roo'
    work = Roo::Spreadsheet.open(filex)
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    sheet = File.open('firstTransform.xml', 'w+')
    sheet.puts work.to_xml
    sheet.close
    self
  end

  def add_process(process_name)
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = process_name
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end
end
