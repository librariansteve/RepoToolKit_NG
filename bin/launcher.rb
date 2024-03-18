# RepoToolKit last update 2018-10-13
Dir['../lib/*.rb'].each { |f| require_relative f }

# Setting $debug to true will cause additional debug lines to print, helping localize bugs
$debug = false

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

choices = ['Faculty Scholarship',
           'Student Scholarship',
           'Trove',
           'Proquest ETDs',
           'Springer Open Access Articles',
           'ACM Open Access Articles',
           'Digitized Book (In-House)',
           'Video (Licensed)',
           'PDF (Licensed)',
           'SMFA Artist Books',
           'Jordan Nutrition Innovation Lab',
           'Food Systems Innovation Lab',
           'Nutrition Innovation Lab (Original)',
           'Subject Analysis',
		   'Debug Mode',
		   'Quit']


while true
  Dir.chdir(@toolkit_path)

  $ui.clearscreen
  $ui.debug()
  choicename = $ui.multiple_choice('What would you like to do?', choices)

  $ui.debug()

  case choicename
  when 'Faculty Scholarship'
    $ui.message('Launching the Faculty Scholarship script.')
    a_new_faculty_ingest = ExcelBasedIngest.new
    a_new_faculty_ingest.extract.add_process('Faculty').excel.collection.transform.finish

  when 'Student Scholarship'
    $ui.message('Launching the Student Scholarship script.')
    a_new_student_ingest = ExcelBasedIngest.new
    a_new_student_ingest.extract.add_process('Student').excel.collection.transform.finish

  when 'Trove'
    $ui.message('Launching the Trove script.')
    a_new_trove_ingest = ExcelBasedIngest.new
    a_new_trove_ingest.extract.add_process('Trove').excel.collection.transform.finish

  when 'Proquest ETDs'
    $ui.message('Launching the Proquest script.')
    a_new_proquest_ingest = ProquestIngest.new
    a_new_proquest_ingest.extract.transform_it.finish

  when 'Springer Open Access Articles'
    $ui.message('Launching the Springer script.')
    a_new_springer_ingest = SpringerIngest.new
    a_new_springer_ingest.extract.transform_it.finish

  when 'ACM Open Access Articles'
    $ui.message('Launching the ACM script.')
    a_new_acm_ingest = ACMIngest.new
    a_new_acm_ingest.extract.transform_it.finish

  when 'Digitized Book (In-House)'
    $ui.message('Launching the in-house script.')
    a_new_inhouse_ingest = InHouseIngest.new
    a_new_inhouse_ingest.extract.transform.finish

  when 'Video (Licensed)'
    $ui.message('Launching the Licensed Streaming Video script.')
    a_new_licensed_video_ingest = LicensedVideoIngest.new
    a_new_licensed_video_ingest.extract.transform.finish

  when 'PDF (Licensed)'
    $ui.message('Launching the Licensed PDF script.')
    a_new_licensed_pdf_ingest = LicensedPDFIngest.new
    a_new_licensed_pdf_ingest.extract.transform.finish

  when 'SMFA Artist Books'
    $ui.message('Launching the SMFA artist books script.')
    a_new_smfa_ingest = ExcelBasedIngest.new
    a_new_smfa_ingest.extract.add_process('SMFA').excel.collection.transform.finish

  when 'Jordan Nutrition Innovation Lab'
    $ui.message('Launching the Jordan Nutrition Innovation Lab script.')
    a_new_nutrition_ingest = ExcelBasedIngest.new
    a_new_nutrition_ingest.extract.add_process('Jordan').excel.collection.transform.finish

  when 'Food Systems Innovation Lab'
    $ui.message('Launching the Food Systems Innovation Lab script.')
    a_new_nutrition_ingest = ExcelBasedIngest.new
    a_new_nutrition_ingest.extract.add_process('FoodSystems').excel.collection.transform.finish

  when 'Nutrition Innovation Lab (Original)'
    $ui.message('Launching the original Nutrition Innovation Lab script.')
    a_new_nutrition_ingest = ExcelBasedIngest.new
    a_new_nutrition_ingest.extract.add_process('Nutrition').excel.collection.transform.finish

  when 'Subject Analysis'
    $ui.message('Launching the Subject Analysis script')
    a_new_analysis = SubjectAnalysis.new
    a_new_analysis.subject_only.re_qa_subject

  when 'Debug Mode'
    $ui.message('Entering Debug Mode')
    $debug = true

  when 'Quit'
    break
  end
end

$ui.close
exit
