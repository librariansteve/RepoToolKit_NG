# = batchProQuest.rb
#
# == class BatchProQuest
#
# The BatchProquest class represents a transformation procedure
# for ProQuest Electronic Theses and Dissertations. ProQuest delivers
# a Zip file for each ETD, containing the thesis in PDF format,
# metadata in a custom XML format, sometimes auxiiliary files
# supplied by the graduate.
class BatchProQuest < Batch
  def batch_it
    copy_directory
    collection

    $ui.debug()
    $ui.message('Running Saxon transform')
    transform_xslt = $xslt_path + "/Proquest.xslt"
    subjects_xslt = $xslt_path + "/subject.xslt"
    output_xml = Time.now.strftime('%F-%H%M%S') + '_Proquest_Ingest.xml'
    xsl_transform("collection.xml", output_xml, transform_xslt)
    xsl_transform(output_xml, "subjects.txt", subjects_xslt)

    package
    postprocess_proquest_xml
    qa_it(output_xml)
  end

  def postprocess_proquest_xml
    $ui.debug()
    $ui.message('Postprocessing')
    Dir.chdir('xml')
    FileUtils.rm('collection.xml')
    Dir.mkdir('proquest_original_xml')
    FileUtils.mv Dir.glob('*_DATA.xml'), 'proquest_original_xml'
    $ui.debug()
  end
end
