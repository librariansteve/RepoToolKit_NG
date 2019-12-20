# Creates a progress bar for zipped directories
module UnzipIt
  def unzip
    print 'Unzipping...please be patient as this may take a while.'
#    require 'progress_bar'
#    bar = ProgressBar.new

    if $is_windows then
      system ("powershell Expand-Archive '*.zip'")
    else
      system ("unzip '*.zip'")
    end

#    100.times do
#      sleep 0.1
#      bar.increment!
#    end
    self
  end
end
