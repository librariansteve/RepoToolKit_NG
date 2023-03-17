# Gets users directory and makes a copy in TempRepo
module SetDirectories
  def initialize
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    require 'fileutils'
    puts 'What is the directory you are working with?'
    print $prompt
    @user_directory = gets.chomp.strip

    @copy_of_directory = @user_directory + '_Processed'
	if Dir.exist?(@copy_of_directory) then FileUtils.remove_dir(@copy_of_directory) end
    FileUtils.mkdir_p @copy_of_directory
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end

    FileUtils.copy_entry @user_directory, @copy_of_directory
    Dir.chdir(@copy_of_directory)
	puts
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end
end
