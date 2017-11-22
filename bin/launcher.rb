# RepoToolKit last update 2017-06-02
Dir['../lib/*.rb'].each { |f| require_relative f }
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
    package.postprocess_excel_xml.close_directories.qa_it
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
    package.postprocess_springer_xml.close_directories.qa_it
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
    package.postprocess_proquest_xml.close_directories.qa_it
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
    package.close_directories.qa_it
  end
end
# Create a list of subjects used by catalogers
class SubjectAnalysis < TuftsScholarship
  include AnalyzeIt
end

puts `clear`
puts '***************************************************'
puts
puts 'Welcome to the Repository Toolkit!'
puts
puts 'What would you like to process?'
puts
puts '1. Faculty Scholarship.'
puts '2. Student Scholarship.'
puts '3. Nutrition School.'
puts '4. Art and Art History (Trove).'
puts '5. Springer Open Access Articles.'
puts '6. Proquest Electronic Disertations and Theses.'
puts '7. In-House digitized books.'
puts '8. Subject Analysis.'
puts '9. SMFA Artist Books.'
puts '10. Exit.'
puts
prompt = '> '
print prompt
# Loop
while input = gets.chomp
  case input
  when '1', '1.', 'Faculty'
    puts
    puts 'Launching the Faculty Scholarship script.'
    a_new_faculty_ingest = ExcelBasedIngest.new
    a_new_faculty_ingest.extract.faculty.excel.collection.transform.finish
    break

  when '2', '2.', 'Student'
    puts
    puts 'Launching the Student Scholarship script.'
    a_new_student_ingest = ExcelBasedIngest.new
    a_new_student_ingest.extract.student.excel.collection.transform.finish
    break

  when '3', '3.', 'Nutrition'
    puts
    puts 'Launching the Nutrtion Scholarship script.'
    a_new_nutrition_ingest = ExcelBasedIngest.new
    a_new_nutrition_ingest.extract.nutrition.excel.collection.transform.finish
    break

  when '4', '4.', 'Trove'
    puts
    puts 'Launching the Trove script.'
    a_new_trove_ingest = ExcelBasedIngest.new
    a_new_trove_ingest.extract.trove.excel.collection.transform.finish
    break

  when '5', '5.', 'Springer'
    puts
    puts 'Launching the Springer script.'
    a_new_springer_ingest = SpringerIngest.new
    a_new_springer_ingest.extract.transform_it.finish
    break

  when '6', '6.', 'Proquest'
    puts
    puts 'Launching the Proquest script.'
    a_new_proquest_ingest = ProquestIngest.new
    a_new_proquest_ingest.extract.transform_it.finish
    break

  when '7', '7.', 'inHouse'
    puts
    puts 'Launching the in-house script.'
    a_new_inhouse_ingest = InHouseIngest.new
    a_new_inhouse_ingest.extract.transform.finish
    break

  when '8', '8.', 'Subject'
    puts
    puts 'Launching the Subject Analysis script'
    a_new_analysis = SubjectAnalysis.new
    a_new_analysis.subject_only.close_directories.re_qa_subject
    break
    
  when '9', '9.', 'SMFA'
    puts
    puts 'Launching the SMFA artist books script.'
    a_new_smfa_ingest = ExcelBasedIngest.new
    a_new_smfa_ingest.extract.smfa.excel.collection.transform.finish
    break

  when '10', '10.', '10. Exit', 'Exit'
    puts
    puts 'Goodbye.'
    break

  else
    puts 'Please select from the above options.'
    print prompt
  end
end
