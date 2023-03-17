# Open proceesed xml and run subject analysis
module QA
  require_relative './set_directories.rb'
  include SetDirectories

  def qa_it
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts
	puts 'Would you like to open the transformed xml?'
    print $prompt
    while input = gets.chomp
      if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
      case input
      when 'Y', 'y', 'Yes'
        if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
        puts
        puts 'Launching applications.'
        puts
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

        if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
        sleep(3)
        break
      when 'N', 'No', 'n', 'Exit'
        if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
        break
      else
        if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
        puts 'Please select Yes or No.'
        print @prompt
      end
    end
  end
end
