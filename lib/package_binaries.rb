# Moves binaries into appropriate files
module PackageBinaries
  require_relative './set_directories.rb'
  include SetDirectories

  def package
    $ui.debug()
    $ui.message('Packaging results')
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('*.xml').empty?
      FileUtils.mv Dir.glob('**/*.xml'), 'xml'
      Dir.chdir('xml')
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('*.txt').empty?
      FileUtils.mv Dir.glob('subjects.txt'), 'xml'
      Dir.chdir('xml')
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('**/*.xlsx').empty?
	  Dir.mkdir('excel')
      FileUtils.mv Dir.glob('**/*.xlsx'), 'excel'
      Dir.chdir('excel')
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('**/*.pdf').empty?
      FileUtils.mv Dir.glob('**/*.pdf'), 'pdf'
      Dir.chdir('pdf')
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('**/*.tif').empty?
      FileUtils.mv Dir.glob('**/*.tif'), 'tif'
      Dir.chdir('tif')
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('**/*.mrc').empty?
      FileUtils.mv Dir.glob('**/*.mrc'), 'mrc'
      Dir.chdir('mrc')
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('**/*.Meta').empty?
      FileUtils.mv Dir.glob('**/*.Meta'), 'xml'
      Dir.chdir('xml')
      Dir.entries('.').each do |entry|
        if entry.match('\d.*\.xml\.Meta')
          File.rename(entry, entry.gsub('.Meta', ''))
        end
      end
    end
    $ui.debug()
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('**/*.zip').empty?
      FileUtils.mv Dir.glob('**/*.zip'), 'zip'
      Dir.chdir('zip')
      Dir.chdir(@copy_of_directory)
    end
    $ui.debug()
    self
  end
end
