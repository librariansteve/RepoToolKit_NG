# Creates a progress bar for zipped directories
module UnzipIt
  def unzip
    if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    print 'Unzipping...please be patient as this may take a while.'
#    require 'progress_bar'
#    bar = ProgressBar.new

    if $is_windows then
      if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
      files = Dir.glob("*.zip")
      files.each {|f| system ("powershell Expand-Archive #{f}")}
    else
      if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
      system ("unzip '*.zip'")
    end

#    100.times do
#      sleep 0.1
#      bar.increment!
#    end
    if $debug == TRUE then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
    self
  end
end
