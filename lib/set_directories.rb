# Gets users directory and makes a copy in TempRepo
module SetDirectories
  def initialize
    $ui.debug()
    require 'fileutils'
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
    self
  end
end
