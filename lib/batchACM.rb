# = batchACM.rb
#
# == batchACM
#
# The BatchACM class represents a transformation procedure
# for open access articles from the Association for Computing
# Machinery. ACM delivers a Zip file containing an article in
# PDF format and metadata in METS XML format.
class BatchACM < Batch
  def batch_it
    copy_directory

    $ui.debug()
    $ui.message('Running Saxon transform')
    transform_xslt = $xslt_path + "/ACM.xslt"
    subjects_xslt = $xslt_path + "/subject.xslt"
    output_xml = Time.now.strftime('%F-%H%M%S') + '_ACM_Ingest.xml'
    $ui.debug()
    xsl_transform("mets.xml", output_xml, transform_xslt)
    $ui.debug()
    xsl_transform(output_xml, "subjects.txt", subjects_xslt)

    package
    qa_it(output_xml)
  end
end
