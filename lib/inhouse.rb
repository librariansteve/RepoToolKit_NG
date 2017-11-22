# renames marcxml file for xslt to process
module Rename
  def rename_mrc_xml
    @filex = Dir.glob('*.xml').to_s.gsub(/\[\"|\"\]/, '')
    File.rename @filex, 'inHouse.xml'
    self
  end

  def rename_xml_to_original
    File.rename 'inHouse.xml', @filex
    self
  end
end
