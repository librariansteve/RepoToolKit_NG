# RepoToolKit last update 2018-10-13
Dir['../lib/*.rb'].each { |f| require_relative f }

# Setting $debug to true will cause additional debug lines to print, helping localize bugs
$debug = false
if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end

@toolkit_path = File.expand_path('..', File.dirname(__FILE__))

# Superclass
class TuftsScholarship
  include SetDirectories
  include CleanFileNames
  include CreateSubdirectories
  include CollectionXML
  include Transforms
  include PackageBinaries
  include CleanUpXML
  include QA
end

# Excel ingest processes
class ExcelBasedIngest < TuftsScholarship
  include ToRoo
  def extract
    clean.excel_subfolders.roo_to_xml
  end

  def finish
    package.postprocess_excel_xml.qa_it
  end
end
# Specific ingest issues for ACM
class ACMIngest < TuftsScholarship
  include UnzipIt
  
  def extract
    acm_subfolders.unzip
  end

  def transform_it
    transform_it_acm
  end

  def finish
    package.postprocess_acm_xml.qa_it
  end
end
# Specific ingest issues for Springer
class SpringerIngest < TuftsScholarship
  include UnzipIt
  def extract
    springer_subfolders.unzip
  end

  def transform_it
    preprocess_springer_xml.collection.transform_it_springer
  end

  def finish
    package.postprocess_springer_xml.qa_it
  end
end
# Specific ingest issues for Proquest
class ProquestIngest < TuftsScholarship
  include UnzipIt

  def extract
    proquest_subfolders.unzip
  end

  def transform_it
    collection.transform_it_proquest
  end

  def finish
    package.postprocess_proquest_xml.qa_it
  end
end
# Specific ingest issues for MARC xml
class InHouseIngest < TuftsScholarship
  include Rename

  def extract
    inhouse_subfolders
  end

  def transform
    rename_mrc_xml.transform_it_inhouse.rename_xml_to_original
  end

  def finish
    package.postprocess_marc_xml.qa_it
  end
end
# Create a list of subjects used by catalogers
class SubjectAnalysis < TuftsScholarship
  include AnalyzeIt
end
# Specific ingest issues for MARC xml
class LicensedVideoIngest < TuftsScholarship
  include Rename

  def extract
    inhouse_subfolders
  end

  def transform
    rename_mrc_xml.transform_it_licensed_video.rename_xml_to_original
  end

  def finish
    package.postprocess_marc_xml.qa_it
  end
end
# Specific ingest issues for MARC xml
class LicensedPDFIngest < TuftsScholarship
  include Rename

  def extract
    inhouse_subfolders
  end

  def transform
    rename_mrc_xml.transform_it_licensed_pdf.rename_xml_to_original
  end

  def finish
    package.postprocess_marc_xml.qa_it
  end
end


$is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
$prompt = '  ? > '
$saxon_path = ENV['SAXON_PATH']
$xslt_path = File.expand_path('../xslt', File.dirname(__FILE__))

if !$saxon_path then
  puts
  puts 'The environment variable SAXON_PATH is missing or blank.'
  puts 'SAXON_PATH must contain the full pathname to the saxon jar file.'
  puts 'Goodbye.'
  sleep(3)
  exit
end

version = File.readlines("version.txt", chomp: true)[0]

if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
if $is_windows then
  system ("cls")
else
  system ("clear")
end
puts
puts
puts
puts
puts
puts
puts
puts '***************************************************'
puts
puts 'Welcome to the Repository Toolkit ' + version
puts
puts '***************************************************'
sleep(2)

choices = ['Quit',
           'Faculty Scholarship',
           'Student Scholarship',
           'Trove (History of Art and Arcitecture slides)',
           'Proquest Electronic Disertations and Theses',
           'Springer Open Access Articles',
           'ACM Open Access Articles',
           'Digitized Book (In-House)',
           'Video (Licensed)',
           'PDF (Licensed)',
           'SMFA Artist Books',
           'Nutrition School',
           'Subject Analysis',
		   'Test ToolKit',
		   'Debug Mode']


while true
  if $is_windows then
    system ("cls")
  else
    system ("clear")
  end
  Dir.chdir(@toolkit_path)

  puts "RepoToolKit " + version
  puts 'What would you like to do?'
  puts
  choices.each {|c| puts "  *  " + c.to_s}
  puts
  puts 'Enter at least the first few letters of your choice:'
  print $prompt
  input = gets.chomp.strip
  choicenum = nil

  if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
  i = 0
  while i < choices.length
    if input.length > 0 and choices[i].to_s.downcase.start_with?(input.downcase)
      choicenum = i
    break
    end
    i = i + 1
  end

  puts
  if choicenum == nil
    puts 'Choice not recognized'
    break
  else
    puts 'You chose:  ' + choices[choicenum]
	puts 'Confirm? (y or n)'
	print $prompt
	input = gets.chomp.strip
	if input != 'y' and input != 'Y'
	  next
	end
  end

  if $debug == true then puts "*** debug line: #{__FILE__}:#{__LINE__} ***" end
  puts
  case choicenum
  when 0  # Quit
    break
  
  when 1  # Faculty Scholarship
    puts 'Launching the Faculty Scholarship script.'
    a_new_faculty_ingest = ExcelBasedIngest.new
    a_new_faculty_ingest.extract.faculty.excel.collection.transform.finish

  when 2  # Student Scholarship
    puts 'Launching the Student Scholarship script.'
    a_new_student_ingest = ExcelBasedIngest.new
    a_new_student_ingest.extract.student.excel.collection.transform.finish

  when 3  # Trove
    puts 'Launching the Trove script.'
    a_new_trove_ingest = ExcelBasedIngest.new
    a_new_trove_ingest.extract.trove.excel.collection.transform.finish

  when 4  # Proquest ETDs
    puts 'Launching the Proquest script.'
    a_new_proquest_ingest = ProquestIngest.new
    a_new_proquest_ingest.extract.transform_it.finish

  when 5  # Springer Articles
    puts 'Launching the Springer script.'
    a_new_springer_ingest = SpringerIngest.new
    a_new_springer_ingest.extract.transform_it.finish

  when 6  # ACM Articles
    puts 'Launching the ACM script.'
    a_new_acm_ingest = ACMIngest.new
    a_new_acm_ingest.extract.transform_it.finish

  when 7  # Digitized Book (In-House)
    puts 'Launching the in-house script.'
    a_new_inhouse_ingest = InHouseIngest.new
    a_new_inhouse_ingest.extract.transform.finish

  when 8  # Video (Licensed)
    puts 'Launching the Licensed Streaming Video script.'
    a_new_licensed_video_ingest = LicensedVideoIngest.new
    a_new_licensed_video_ingest.extract.transform.finish

  when 9  # PDF (Licensed)
    puts 'Launching the Licensed PDF script.'
    a_new_licensed_pdf_ingest = LicensedPDFIngest.new
    a_new_licensed_pdf_ingest.extract.transform.finish

  when 10 # SMFA Artist Books
    puts 'Launching the SMFA artist books script.'
    a_new_smfa_ingest = ExcelBasedIngest.new
    a_new_smfa_ingest.extract.smfa.excel.collection.transform.finish

  when 11 # Nutrition School
    puts 'Launching the Nutrtion Scholarship script.'
    a_new_nutrition_ingest = ExcelBasedIngest.new
    a_new_nutrition_ingest.extract.nutrition.excel.collection.transform.finish

  when 12 # Subject Analysis
    puts 'Launching the Subject Analysis script'
    a_new_analysis = SubjectAnalysis.new
    a_new_analysis.subject_only.re_qa_subject

  when 13 # Test Toolkit 
    puts 'Launching the Test XML script.'
    a_test_xml = TestXML.new
    a_test_xml.testit

  when 14 # Debug Mode
    puts 'Entering Debug Mode'
    $debug = true
  end
end

if $is_windows then
  system ("cls")
else
  system ("clear")
end
puts 'Goodbye'
sleep(2)
exit
