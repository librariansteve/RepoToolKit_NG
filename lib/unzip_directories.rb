# Creates a progress bar for ziped directories
module UnzipIt
  def unzip
    print 'Unziping...please be patient as this may take a while.'
    require 'progress_bar'
    bar = ProgressBar.new
    `unzip '*.zip'`
    100.times do
      sleep 0.1
      bar.increment!
    end
    self
  end
end
