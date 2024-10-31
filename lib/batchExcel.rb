# = batchExcel.rb
#
# == class BatchExcel
#
# The BatchExcel class represents a transformation procedure
# for local resources with metadata in Excel format.
class BatchExcel < Batch
  def batch_it
    choices = Hash.new
	choices['Faculty Scholarship'] = 'Faculty'
    choices['Student Scholarship'] = 'Student'
    choices['Trove'] = 'Trove'
    choices['Music Concert Programs'] = 'Concert'
    choices['SMFA Artist Books'] = 'SMFA'
    choices['Jordan Nutrition Innovation Lab'] = 'Jordan'
    choices['Food Systems Innovation Lab'] = 'FoodSystems'
    choices['Nutrition Innovation Lab (Original)'] = 'Nutrition'
    $ui.debug()
    choicename = $ui.multiple_choice('What type of Excel submission?', choices.keys)

    copy_directory
    clean
    roo_to_xml

    add_process(choices[choicename])

    extractIn_xml = 'firstTransform.xml'
    extract_xslt = $xslt_path + "/extract_excel.xslt"
    extractOut_xml = './workWithThis.xml'
    xsl_transform(extractIn_xml, extractOut_xml, extract_xslt)

    collection

    $ui.debug()
    $ui.message('Running Saxon transform')
    transform_xslt = $xslt_path + "/excel_to_dc.xslt"
    subjects_xslt = $xslt_path + "/subject.xslt"
    output_xml = Time.now.strftime('%F-%H%M%S') + '_ExcelBased_Ingest.xml'
    xsl_transform("collection.xml", output_xml, transform_xslt)
    xsl_transform(output_xml, "subjects.txt", subjects_xslt)

    package
    postprocess_excel_xml
    qa_it(output_xml)
  end

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
  end

  def roo_to_xml
    $ui.debug()
    filex = Dir.glob('*.xlsx').to_s.gsub(/\[\"|\"\]/, '')
    require 'roo'
    work = Roo::Spreadsheet.open(filex)
    $ui.debug()
    sheet = File.open('firstTransform.xml', 'w+')
    sheet.puts work.to_xml
    sheet.close
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
  end

  def postprocess_excel_xml
    $ui.debug()
    $ui.message('Postprocessing')
    Dir.chdir('xml')
    FileUtils.rm('firstTransform.xml')
    FileUtils.rm('workWithThis.xml')
    FileUtils.rm('collection.xml')
    $ui.debug()
  end
end