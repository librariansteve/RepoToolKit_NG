# Change Excel to xml
module ToRoo
  def roo_to_xml
    $ui.debug()
    filex = Dir.glob('*.xlsx').to_s.gsub(/\[\"|\"\]/, '')
    require 'roo'
    work = Roo::Spreadsheet.open(filex)
    $ui.debug()
    sheet = File.open('firstTransform.xml', 'w+')
    sheet.puts work.to_xml
    sheet.close
    self
  end

  def add_process(process_name)
    $ui.debug()
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    $ui.debug()
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = process_name
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    $ui.debug()
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end
end
