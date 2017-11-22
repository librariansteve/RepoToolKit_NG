# Create subdirectories specific for each ingest process
module CreateSubdirectories
  def excel_subfolders
    Dir.mkdir('xml')
    Dir.mkdir('excel')
    unless Dir.glob('*.pdf').empty?
      Dir.mkdir('pdf')
    end
    unless Dir.glob('*.tif').empty?
      Dir.mkdir('tif')
    end
    self
  end

  def springer_subfolders
    Dir.mkdir('xml')
    Dir.mkdir('xml/springer_original_xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    Dir.mkdir('springer')
    self
  end

  def proquest_subfolders
    Dir.mkdir('xml')
    Dir.mkdir('xml/proquest_original_xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    self
  end

  def inhouse_subfolders
    Dir.mkdir('xml')
    Dir.mkdir('pdf')
    self
  end
end
