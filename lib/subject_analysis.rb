# Re-analyze subjects
module AnalyzeIt
  require_relative './set_directories.rb'
  include SetDirectories
  def re_qa_subject
    puts 'Would you like to open the new analysis?'
    print @prompt
    while input = gets.chomp
      case input
      when 'Y', 'y', 'Yes'
        puts
        puts 'Launching applications.'
        puts
        Dir.chdir(@user_directory + '/xml')
        file_to_open = 'subject_update.txt'
        system %(open '#{file_to_open}')
        break
      when 'N', 'No', 'n', 'Exit'
        puts 'Goodbye.'
        break
      else
        puts 'Please select Yes or No.'
        print @prompt
      end
    end
  end
end
