# renames marcxml file for xslt to process
module Rename
  def rename_mrc_xml
    $ui.debug()
    files = Dir.glob('*.xml')
    if files.count() > 1
      $ui.debug()
      $ui.message("\nDirectory contains more than 1 XML file")
      @filex = $ui.multiple_choice('Which is the XML file containing the metadata for ingest?', files)
    else
      $ui.debug()
      @filex = files.to_s
    end

    $ui.debug()
	@filex = @file.gsub(/\[\"|\"\]/, '')
    File.rename @filex, 'inHouse.xml'
    self
  end

  def rename_xml_to_original
    $ui.debug()
    File.rename 'inHouse.xml', @filex
    self
  end
end
