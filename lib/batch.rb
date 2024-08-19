# = batch.rb
#
# == class Batch
#
# The Batch class represents an abstract transformation procedure.
#
# The Batch takes an input directory structure containing metadata
# and content described by the metadata, transforms the metadata, and
# creates an output directory structure suitable for injest into
# a repository.
#
# Subclasses of Batch implement the transformations of particular
# archive sources.
class Batch
  require 'fileutils'

  def copy_directory
    $ui.debug()
    @user_directory = $ui.question('What is the directory you are working with?')
    while !Dir.exist?(@user_directory)
      $ui.message("\nThat directory does not exist")
      @user_directory = $ui.question('What is the directory you are working with?')
    end

    @copy_of_directory = @user_directory + '_Processed'
	if Dir.exist?(@copy_of_directory) then FileUtils.remove_dir(@copy_of_directory) end
    FileUtils.mkdir_p @copy_of_directory
    $ui.debug()

    FileUtils.copy_entry @user_directory, @copy_of_directory
    Dir.chdir(@copy_of_directory)
	puts
    $ui.debug()
  end

  def collection
    $ui.debug()
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
  end

  def package
    $ui.debug()
    $ui.message('Packaging results')
    Dir.chdir(@copy_of_directory)
    unless Dir.glob('*.xml').empty?
      Dir.mkdir('xml')
      FileUtils.mv Dir.glob('**/*.xml'), 'xml'
    end
    $ui.debug()
    unless Dir.glob('subjects.txt').empty?
      FileUtils.mv Dir.glob('subjects.txt'), 'xml'
    end

    $ui.debug()
    unless Dir.glob('**/*.xlsx').empty?
	  Dir.mkdir('excel')
      FileUtils.mv Dir.glob('**/*.xlsx'), 'excel'
    end

    $ui.debug()
    unless Dir.glob('**/*.pdf').empty?
  	  Dir.mkdir('pdf')
      FileUtils.mv Dir.glob('**/*.pdf'), 'pdf'
    end

    $ui.debug()
    unless Dir.glob('**/*.tif').empty?
  	  Dir.mkdir('tif')
      FileUtils.mv Dir.glob('**/*.tif'), 'tif'
    end

    $ui.debug()
    unless Dir.glob('**/*.mrc').empty?
  	  Dir.mkdir('mrc')
      FileUtils.mv Dir.glob('**/*.mrc'), 'mrc'
    end

    $ui.debug()
    unless Dir.glob('**/*.zip').empty?
  	  Dir.mkdir('zip')
      FileUtils.mv Dir.glob('**/*.zip'), 'zip'
    end
  end

  def qa_it(xml_file)
    $ui.debug
    if $ui.yesno("\nWould you like to open the transformed xml?", 'y')
      $ui.debug()
      Dir.chdir(@copy_of_directory + '/xml')

      subjects_file = 'subjects.txt'

      if Gem.win_platform? then
        system %(cmd /c "start #{xml_file}")
        system %(cmd /c "start #{subjects_file}")
      else
        system %(open '#{xml_file}')
        system %(open '#{subjects_file}')
      end

      $ui.debug()
      $ui.splash('Launching applications')
	end
  end

  def xsl_transform(input, output, xslt)
    command = "java -cp " + $saxon_path + " net.sf.saxon.Transform -s:" + input + " -xsl:" + xslt + " -o:" + output
	`#{command}`
  end
end
