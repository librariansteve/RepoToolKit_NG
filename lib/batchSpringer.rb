# = batchSpringer.rb
#
# == class BatchSpringer
#
# The BatchSpringer class represents a transformation procedure
# for Springer Open Access materials. Springer delivers a Zip file
# containing articles in PDF format and metadata in a custom XML format
# with an .xml.meta extension. Each article and its metadata is in a
# separate subfolder within the Zip file, organized by journal ID and
# article ID.
class BatchSpringer < Batch
  def batch_it
    copy_directory
    preprocess_springer_xml
    collection

    $ui.debug()
    $ui.message('Running Saxon transform')
    transform_xslt = $xslt_path + "/Springer.xslt"
    subjects_xslt = $xslt_path + "/subject.xslt"
    output_xml = Time.now.strftime('%F-%H%M%S') + '_Springer_Ingest.xml'
    xsl_transform("collection.xml", output_xml, transform_xslt)
    xsl_transform(output_xml, "subjects.txt", subjects_xslt)

    package
    postprocess_springer_xml
    qa_it(output_xml)
  end

  def preprocess_springer_xml
    $ui.debug()
    $ui.message('Preprocessing')
    FileUtils.mv Dir.glob('**/*.Meta'), '.'
    Dir.entries('.').each do |entry|
      if entry.match('\d.*\.xml\.Meta')
        File.rename(entry, entry.gsub('.Meta', ''))
      end
    end
    $ui.debug()
  end

  def postprocess_springer_xml
    $ui.debug()
    $ui.message('Postprocessing')
    Dir.mkdir('springer')
    FileUtils.mv Dir.glob('**/JOU=*'), 'springer'
    FileUtils.remove_entry 'springer'

    $ui.debug()
    Dir.chdir('xml')
    FileUtils.rm('collection.xml')
    Dir.mkdir('springer_original_xml')
    FileUtils.mv Dir.glob('*_Article_*.xml'), 'springer_original_xml'
    $ui.debug()
  end
end
