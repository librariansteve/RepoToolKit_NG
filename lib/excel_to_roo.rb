# Change Excel to xml
module ToRoo
  def roo_to_xml
    filex = Dir.glob('*.xlsx').to_s.gsub(/\[\"|\"\]/, '')
    require 'roo'
    work = Roo::Spreadsheet.open(filex)
    sheet = File.open('firstTransform.xml', 'w+')
    sheet.puts work.to_xml
    sheet.close
    self
  end

  def trove
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = 'Trove'
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end

  def faculty
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = 'Faculty'
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end

  def student
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = 'Student'
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end
  
  def smfa
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = 'SMFA'
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end

  def nutrition
    require 'nokogiri'
    f = File.open('firstTransform.xml')
    @spreadsheet = Nokogiri::XML(f)
    f.close
    process = Nokogiri::XML::Node.new 'Process', @spreadsheet
    process.content = 'Nutrition'
    @spreadsheet.xpath('//spreadsheet//sheet/cell').each do |node|
      node.add_next_sibling(process)
    end
    file = File.open('firstTransform.xml', 'w')
    file.puts @spreadsheet.to_xml
    file.close
    self
  end
end
