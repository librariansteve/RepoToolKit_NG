# XSLTs use the collection function
module CollectionXML
  def collection
    $ui.debug()
    require 'fileutils'
    collection = File.open('collection.xml', 'w')
    collection.puts('<?xml version=\'1.0\' encoding = \'UTF-8\'?>')
    collection.puts('<collection>')
    $ui.debug()
    Dir.glob('**/*.xml').reject { |f| f['collection.xml'] }.each do |entry2|
	  collection.puts '    <doc href=\'' + entry2 + '\'/>'
    end
    collection.puts('</collection>')
    collection.close
    $ui.debug()
    self
  end
end
