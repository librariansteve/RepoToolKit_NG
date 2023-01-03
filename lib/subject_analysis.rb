# Re-analyze subjects
module AnalyzeIt
  require_relative './set_directories.rb'
  include SetDirectories
  def re_qa_subject
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'Would you like to open the new analysis?'
    print $prompt
    while input = gets.chomp
      if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
      case input
      when 'Y', 'y', 'Yes'
        if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
        puts
        puts 'Launching applications.'
        puts
        Dir.chdir(@user_directory + '/xml')
        file_to_open = 'subject_update.txt'
        system %(open '#{file_to_open}')
        if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
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
