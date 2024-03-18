# Create subdirectories specific for each ingest process
module CreateSubdirectories
  def excel_subfolders
    $ui.debug()
    Dir.mkdir('xml')
    unless Dir.glob('*.pdf').empty?
      Dir.mkdir('pdf')
    end
    $ui.debug()
    unless Dir.glob('*.tif').empty?
      Dir.mkdir('tif')
    end
    $ui.debug()
    self
  end

  def springer_subfolders
    $ui.debug()
    Dir.mkdir('xml')
    Dir.mkdir('xml/springer_original_xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    Dir.mkdir('springer')
    $ui.debug()
    self
  end

  def acm_subfolders
    $ui.debug()
    Dir.mkdir('xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    $ui.debug()
    self
  end

  def proquest_subfolders
    $ui.debug()
    Dir.mkdir('xml')
    Dir.mkdir('xml/proquest_original_xml')
    Dir.mkdir('pdf')
    Dir.mkdir('zip')
    $ui.debug()
    self
  end

  def inhouse_subfolders
    $ui.debug()
    Dir.mkdir('xml')
    Dir.mkdir('pdf')
    Dir.mkdir('mrc')
    Dir.mkdir('zip')
    $ui.debug()
    self
  end
end
