# RepoToolKit last update 2018-10-13
Dir['../lib/*.rb'].each { |f| require_relative f }

# Setting $debug to true will cause additional debug lines to print, helping localize bugs.
# An option in the main menu can toggle $debug to true.
$debug = false

@toolkit_path = File.expand_path('..', File.dirname(__FILE__))

$version = File.readlines("version.txt", chomp: true)[0]
$saxon_path = ENV['SAXON_PATH']
$xslt_path = File.expand_path('../xslt', File.dirname(__FILE__))
$ui = Interface.new_ui

if !$saxon_path then
  $ui.message('The environment variable SAXON_PATH is missing or blank.')
  $ui.message('SAXON_PATH must contain the full pathname to the saxon jar file.')
  $ui.message('Goodbye.')
  sleep(3)
  exit
end

$ui.debug()
choices = ['Excel Metadata',
           'Proquest ETDs',
           'Springer Open Access Articles',
           'ACM Open Access Articles',
           'Digitized Book (In-House)',
           'Video (Licensed)',
           'PDF (Licensed)',
           'HathiTrust Package',
    	   'Debug Mode',
    	   'Quit']


while true
  Dir.chdir(@toolkit_path)

  $ui.clearscreen
  $ui.debug()
  choicename = $ui.multiple_choice('What would you like to do?', choices)
  $ui.debug()

  case choicename
  when 'Excel Metadata'
    $ui.message('Launching the Excel Metadata script.')
    BatchExcel.new.batch_it

  when 'Proquest ETDs'
    $ui.message('Launching the Proquest script.')
    BatchProQuest.new.batch_it

  when 'Springer Open Access Articles'
    $ui.message('Launching the Springer script.')
	BatchSpringer.new.batch_it

  when 'ACM Open Access Articles'
    $ui.message('Launching the ACM script.')
	BatchACM.new.batch_it

  when 'Digitized Book (In-House)'
    $ui.message('Launching the in-house script.')
	BatchInHouse.new.batch_it

  when 'Video (Licensed)'
    $ui.message('Launching the Licensed Streaming Video script.')
	BatchLicensedVideo.new.batch_it

  when 'PDF (Licensed)'
    $ui.message('Launching the Licensed PDF script.')
	BatchLicensedPDF.new.batch_it

  when 'HathiTrust Package'
    $ui.message('Launching the HathiTrust Package script.')
	BatchHathiTrust.new.batch_it

  when 'Debug Mode'
    $ui.message('Entering Debug Mode')
    $debug = true

  when 'Quit'
    break
  end
end

$ui.close
exit
