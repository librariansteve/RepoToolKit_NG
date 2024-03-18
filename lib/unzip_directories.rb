# Creates a progress bar for zipped directories
module UnzipIt
  def unzip
    $ui.debug()
    $ui.message('Unzipping...please be patient as this may take a while.')
#    require 'progress_bar'
#    bar = ProgressBar.new

    if $is_windows then
      $ui.debug()
      files = Dir.glob("*.zip")
      files.each {|f| system ("powershell Expand-Archive #{f}")}
    else
      $ui.debug()
      system ("unzip '*.zip'")
    end

#    100.times do
#      sleep 0.1
#      bar.increment!
#    end
    $ui.debug()
    self
  end
end
