# Open proceesed xml and run subject analysis
module QA
  require_relative './set_directories.rb'
  include SetDirectories

  def qa_it
    $ui.debug()
    if $ui.yesno("\nWould you like to open the transformed xml?")
      $ui.debug()
      Dir.chdir(@copy_of_directory + '/xml')
        
      if $is_windows then
        file_to_open = @f+'_Ingest.xml'
        system %(cmd /c "start #{file_to_open}")
        file_to_open = 'subjects.txt'
        system %(cmd /c "start #{file_to_open}")
      else
        file_to_open = @f+'_Ingest.xml'
        system %(open '#{file_to_open}')
        file_to_open = 'subjects.txt'
        system %(open '#{file_to_open}')
      end

      $ui.debug()
      $ui.splash('Launching applications')
	end
  end
end
