# = batchInHouse.rb
#
# == class BatchInHouse
#
# The BatchInHouse class represents a transformation procedure
# for books digitized in-house. The batch starts from a directory
# containing the digitized book in PDF format and a MARCXML file
# with the metadata, derived from an OCLC WorldCat bibliographic
# record.
class BatchInHouse < Batch
  def batch_it
    copy_directory
    files = Dir.glob('*.xml')
    if files.count() > 1
      $ui.debug()
      $ui.message("\nDirectory contains more than 1 XML file")
      input_xml = $ui.multiple_choice('Which is the XML file containing the metadata for ingest?', files)
    else
      $ui.debug()
      input_xml = files[0]
    end
	puts "input file = " + input_xml

    $ui.debug()
    $ui.message('Running Saxon transform')
    transform_xslt = $xslt_path + "/inhouse.xslt"
    subjects_xslt = $xslt_path + "/subject.xslt"
    output_xml = Time.now.strftime('%F-%H%M%S') + '_MARC_Ingest.xml'
    xsl_transform(input_xml, output_xml, transform_xslt)
    xsl_transform(output_xml, "subjects.txt", subjects_xslt)

    package
    qa_it(output_xml)
  end
end
