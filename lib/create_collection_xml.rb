# XSLTs use the collection function
module CollectionXML
  def collection
    require 'fileutils'
    collection = File.open('collection.xml', 'w+')
    collection.puts('<?xml version=\'1.0\' encoding = \'UTF-8\'?>')
    collection.puts('<collection>')
    Dir.glob('*.xml').reject { |f| f['collection.xml'] }.each do |entry2|
      collection.puts entry2.gsub(/(\w.+\.xml)/, '<doc href=\'\\0\'/>')
    end
    collection.puts('</collection>')
    collection.close
    self
  end
end
