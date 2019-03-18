# Gets users directory and makes a copy in TempRepo
module SetDirectories
  def initialize
    require 'fileutils'
    @path_to_copy = File.expand_path('~/Desktop/RepoToolKit_NG')
    FileUtils.mkdir_p @path_to_copy + '/TempRepo'
    @prompt = '> '
    puts 'What is the directory you are working with?'
    print @prompt
    @user_directory = gets.chomp.strip
    @copy_of_directory = File.expand_path('~/Desktop/RepoToolKit_NG/TempRepo')
    FileUtils.copy_entry @user_directory, @copy_of_directory
    Dir.chdir(@copy_of_directory)
    self
  end

  def close_directories
    FileUtils.remove_entry @user_directory
    FileUtils.copy_entry @copy_of_directory, @user_directory
    FileUtils.remove_dir @copy_of_directory
    self
  end
end
