# Gets users directory and makes a copy in TempRepo
module SetDirectories
  def initialize
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    require 'fileutils'
    @toolkit_path = File.expand_path('..', File.dirname(__FILE__))
    @copy_of_directory = @toolkit_path + '/TempRepo'
	if Dir.exist?(@copy_of_directory) then FileUtils.remove_dir(@copy_of_directory) end
    FileUtils.mkdir_p @copy_of_directory
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    puts 'What is the directory you are working with?'
    print $prompt
    @user_directory = gets.chomp.strip
    FileUtils.copy_entry @user_directory, @copy_of_directory
    Dir.chdir(@copy_of_directory)
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end

  def close_directories
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    Dir.chdir(@toolkit_path)
    FileUtils.remove_dir @user_directory
    FileUtils.copy_entry @copy_of_directory, @user_directory
    FileUtils.remove_dir @copy_of_directory
    if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end
end
