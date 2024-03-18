# Re-analyze subjects
module AnalyzeIt
  require_relative './set_directories.rb'
  include SetDirectories
  def re_qa_subject
    $ui.debug()
    if $ui.yesno('Would you like to open the new analysis?')
      $ui.debug()
      Dir.chdir(@user_directory + '/xml')
      file_to_open = 'subject_update.txt'
      system %(open '#{file_to_open}')
      $ui.splash('Launching applications')
      $ui.debug()
    end
  end
end
