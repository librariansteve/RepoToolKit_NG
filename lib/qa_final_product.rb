# Open proceesed xml and run subject analysis
module QA
  require_relative './set_directories.rb'
  include SetDirectories

  def qa_it
    puts 'Would you like to open the tranformed xml?'
    print @prompt
    while input = gets.chomp
      case input
      when 'Y', 'y', 'Yes'
        puts
        puts 'Launching applications.'
        puts
        Dir.chdir(@user_directory + '/xml')
        
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

        sleep(3)
        break
      when 'N', 'No', 'n', 'Exit'
        puts 'Goodbye.'
        sleep(3)
        break
      else
        puts 'Please select Yes or No.'
        print @prompt
      end
    end
  end
end
