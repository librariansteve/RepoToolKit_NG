# = batchHathiTrust.rb
#
# == class BatchHathiTrust
#
# The BatchHathiTrust represents a packaging procedure to prepare
# a submission of digitized material to HathiTrust. The batch
# starts from a directory containing the digitized book in TIFF
# format and a MARC or MARCXML file with the metadata, derived
# from an OCLC WorldCat bibliographic record. The job will change
# the name of each .tif file to numeric names, e.g. 00000001.tif;
# generate an OCR file for each page; convert the MARC to MARCXML
# if necessary; add 003 to the MARC record if necessary; add 955
# to the MARC record; generate a YAML file; and generate an md5
# fixity file listing each file in the package. Finally, the job
# will zip the package into a ZIP file with a filename meeting
# HathiTrust requirements.
#
# The job expects TIFF files with a filename extension of .tif,
# .tiff, .TIF, or .TIFF. The job sorts the files alphanumerically
# then renames them 00000001.tif, etc. The scans should include
# front and back covers, endpapers, blank  pages, and front and
# back matter. Scans can be left-to-right or right-to-left.
class BatchHathiTrust < Batch
  require 'fileutils'
  require 'digest'
  require 'exifr/tiff'
  require 'zip'
  require 'marc'
  require 'nokogiri'
  require 'uri'
  require 'net/http'
  require 'json'
  require 'time'

  def batch_it
    $ui.debug()
    $ui.clearscreen
    $ui.message("\nYou are about to package material for submission to HathiTrust." +
                "\n  See https://www.hathitrust.org/member-libraries/contribute-content/" +
                "\n  for details on submission requirements." +
                "\n\nIn particular, a Digital Asset Submission Inventory form and an" +
                "\n  Administrative Coversheet form must be delivered to HathiTrust" +
                "\n  before any submission." +
                "\n\nPlease provide a directory containing the TIFF files and a MARC" +
                "\n  record for submission. The MARC record must be for the PRINT version" +
                "\n  of the item and should contain the local record identifier in 001 and" +
                "\n  the OCLC number in 035. Each volume of a multi-part title must be" +
                "\n  submitted to HathiTrust separately. Please have the barcode or Internet" +
                "\n  Archive ARK number for the item ready.")

    @user_directory = $ui.question("\nWhat is the directory you are working with?")
    while !Dir.exist?(@user_directory)
      $ui.message("\nThat directory does not exist")
      @user_directory = $ui.question('What is the directory you are working with?')
    end

    Dir.chdir(@user_directory)
    files = Dir.glob('**/*.{mrc,marc}')
    if files.none?
      $ui.splash('No MARC files found in directory; exiting')
      return
    end
    if files.length > 0
      $ui.splash("More than one MARC file found--using first file:\n  " + files[0])
    end
    f = File.open(files[0])
    reader = MARC::Reader.new(f)
    oclc = ''
    record = reader.first
    rectype = record.leader[6,1]
    if rectype != 'a' and rectype != 'c' and rectype != 'd' and rectype != 'e' and rectype != 'f' and rectype != 't'
      $ui.splash('MARC record is not for a language, notated music, or cartographic resource; exiting')
      return
    end
    recform = record['008'].value[29]
    if rectype == 'e' or rectype == 'f'
      recform = record['008'].value[29]
    else
      recform = record['008'].value[23]
    end
    if recform == 'o'
      $ui.splash("Record is for an online version\nPlease use a MARC record for the print version; exiting")
      return
    elsif recform != 'd' and recform != 'r' and recform != '|' and recform != ' '
      $ui.splash('MARC record is not for a print resource; exiting')
      return
    end
    title_field = record['245']
    msg = title_field['a']
	if title_field['b']
      msg << " " + title_field['b']
    end
	if title_field['n']
      msg << " " + title_field['n']
    end
	if title_field['p']
      msg << " " + title_field['p']
    end
	if title_field['c']
      msg << " " + title_field['c']
    end
    $ui.message("Title is: " + msg)

    # find first OCLC number
    oclc = ''
    record.each_by_tag('035') { |field|
      value = field['a'].to_s
      if value[0,7] == "(OCoLC)" and oclc == ''
        oclc = value[7..20]
      end
    }
    if oclc == ''
      $ui.splash('MARC record does not contain an OCLC number in 035; exiting')
      return
    end
    $ui.message("OCLC number is: " + oclc.to_s)
    if !record['003']
      field = MARC::ControlField.new('003', 'MMeT')
      record << field
    end
    # Check OCLC number in HathiTrust
    uri = URI('https://catalog.hathitrust.org/api/volumes/full/oclc/' + oclc + '.json')
    response = Net::HTTP.get(uri)
    if JSON[response]["records"].length != 0
      $ui.splash('This OCLC number is already in HathiTrust; exiting')
      return
    else
      $ui.splash('This is NOT in HathiTrust--continuing')
    end

    id = $ui.question("\nWhat is the barcode or ARK ID of this submission?")
    if id.start_with? "ark" then
      id = id.gsub("+", ":").gsub("=", "/")
    end
    field = MARC::DataField.new('955', '0', '0', MARC::Subfield.new('b', id))
    volume = 0
    if $ui.yesno("\nIs this a multi-volume MARC record?", 'n')
      volume = $ui.question('What volume is this submission?')
      field.append(MARC::Subfield.new('v', volume))
    end
    record << field
    f.close()

    batch = $ui.yesno("\nWill this submission be part of a batch submission (multiple objects)?", 'y')
    if batch
      $ui.message("\nEnter the name of the batch submission directory.")
      $ui.message("\nIf the directory does not already exist, it will be created.")
      d = $ui.question('', 'Batch directory: ')
      while d == ""
        $ui.message("\nEntry was blank; please enter the name of the batch submission directory.")
        d = $ui.question('', 'Batch directory: ').strip
      end
      batch_directory = File.expand_path(d, File.dirname(@user_directory))
      batch_xml = File.join(batch_directory, File.basename(batch_directory) + ".xml")
      if File.exist?(batch_xml)
        $ui.message("Checking for duplicate submission.")
	    f = File.open(batch_xml)
        reader = MARC::XMLReader.new(f, parser: "nokogiri")
        reader.each do |batchrecord|
          htfield = batchrecord['955']
          htid = htfield['b']
          if htid == id
            $ui.splash('This volume (id: ' + id + ') already exists in the batch package; exiting')
            return
          end
        end
        f.close()
      end
    end

    # generating YAML data
    imagefiles = Dir.glob('**/*.{tif,tiff,TIF,TIFF}')
    if imagefiles.none?
      $ui.splash('No TIFF image files found; exiting')
      return
    end
    $ui.message(imagefiles.length.to_s + " images in package\n")
    exif = EXIFR::TIFF.new(imagefiles[0])
    ymltext = "scanner_user: Tufts University, Tisch Library Digital Initiatives Dept.\n"
    if exif.date_time and exif.date_time != ""
	  $ui.message "EXIF date_time: " + exif.date_time.to_s
      ymltext << 'capture_date: ' + exif.date_time.strftime("%Y-%m-%dT%H:%M:%S%:z") + "\n"
    elsif
      digidate = $ui.question("What day was this item digitized (mm/dd/yyyy)?")
      datetime = Time.strptime(digidate, "%m/%d/%Y")
	  ymltext << 'capture_date: ' + datetime.strftime("%Y-%m-%dT%H:%M:%S%:z") + "\n"
    end
    if exif.make and exif.make != ""
      ymltext << 'scanner_make: ' + exif.make + "\n"
    end
    if exif.model and exif.model != ""
      ymltext << 'scanner_model: ' + exif.model + "\n"
    end
    if $ui.yesno("\nWas the resource scanned left-to-right?", 'y')
      ymltext << "scanning_order: left-to-right\n"
    else
      ymltext << "scanning_order: right-to-left\n"
    end
    if $ui.yesno("\nIs the page reading order scanned left-to-right?", 'y')
      ymltext << "reading_order: left-to-right\n"
    else
      ymltext << "reading_order: right-to-left\n"
    end

    languages = Array.new
    if $ui.yesno("\nDoes the text include languages other than English?", 'n')
      $ui.message("\nEnter the 3-letter ISO code for each language in the text, including 'eng' if appropriate")
      $ui.message("Enter one language code at a time; enter blank when finished")
      l = $ui.question('', 'First language: ')
      while l != ''
        languages << l
        l = $ui.question('', 'Next language: ')
      end
    else
      languages << "eng"
    end
    if $ui.yesno("\nDoes the text include any script besides Latin script?", 'n')
      $ui.message("\nEnter the name of each script starting with a capital letter, e.g. 'Fraktur', 'Cyrillic', 'Greek'")
      $ui.message("Include 'Latin' if Latin script is also present")
      $ui.message("Enter one language code at a time; enter blank when finished")
      script = $ui.question('', 'First script: ')
      while script != ''
        languages << 'script/' + script
        script = $ui.question('', 'Next script: ')
      end
    end

    include_forms = $ui.yesno("\nWould you like to fill out a DASI and/or Coversheet for this submission?", 'y')

    $ui.message('Creating package directory')
    @copy_of_directory = @user_directory + '_Packaged'
    if Dir.exist?(@copy_of_directory) then FileUtils.remove_dir(@copy_of_directory) end
    FileUtils.mkdir_p @copy_of_directory
    $ui.debug()

    $ui.message("\nCopying images:")
    n = 0
    imagefiles.sort.each { |f|
      n = n+1
      newfile = File.join(@copy_of_directory, sprintf("%08d.tif", n))
      FileUtils.cp(f, newfile)
      $ui.message File.basename(f) + " --> " + File.basename(newfile)
    }
    Dir.chdir(@copy_of_directory)

    # Create OCR files for each page
    $ui.message("\nRunning OCR on images:")
    Dir.glob('*.tif').each { |f|
      filebase = File.basename(f, '.tif')
      command = "tesseract " + f + " " + filebase + " -l " + languages.join("+") + " hocr"
      $ui.message "Running: " + command
	  `#{command}`
	  File.rename(filebase + '.hocr', filebase + '.html')
      command = "tesseract " + f + " " + filebase + " -l " + languages.join("+")
      $ui.message "Running: " + command
	  `#{command}`
    }

    # Create YAML meta file
    $ui.message("\nCreating YAML file")
    yml = File.open("meta.yml", "w+")
	yml.puts ymltext
    yml.close

    # Create MD5 checksum file
    $ui.message('Generating MD5 checksums')
    File.open("checksum.md5", "w+") { |c|
      Dir.glob(['*.tif', '*.txt', '*.html', 'meta.yml']).each { |f|
        hex = Digest::MD5.file(f).hexdigest
        c.puts(sprintf("%s %s\n", hex, f))
      }
    }

    zipname = id.gsub(":", "+").gsub("/", "=") + '.zip'
    $ui.message('Creating zipfile')
    Zip.write_zip64_support = true
    Zip::File.open(zipname, create: true) { |z|
      Dir.glob(['*.tif', '*.txt', '*.html', 'meta.yml', 'checksum.md5']).each { |f|
        z.add(f, f)
      }
    }
    $ui.message('Deleting temp files')
    Dir.glob(['*.tif', '*.txt', '*.html', 'meta.yml', 'checksum.md5']).each { |f|
      File.delete(f)
    }

    if batch
      $ui.message("\nMoving submission to batch submission directory")
      if !File.exist?(batch_directory)
        Dir.mkdir(batch_directory)
      end
      if include_forms
        f = File.join($xslt_path, 'HathiTrust_DASI.docx')
        newfile = File.join(batch_directory, "DASI_" + File.basename(batch_directory) + ".docx")
        if !File.exist?(newfile)
          $ui.message('Copying blank DASI')
          FileUtils.cp(f, newfile)
        end
        f = File.join($xslt_path, 'HathiTrust_Coversheet.docx')
        newfile = File.join(batch_directory, "Coversheet_" + File.basename(batch_directory) + ".docx")
        if !File.exist?(newfile)
          $ui.message('Copying blank Coversheet')
          FileUtils.cp(f, newfile)
        end
      end
      File.rename(zipname, File.join(batch_directory, zipname))
      Dir.chdir(batch_directory)
      if File.exist?(batch_xml)
        $ui.message("Merging new MARC record with existing records in batch.")
        tempfile = File.join(batch_directory, "temp.xml")
        File.rename(batch_xml, tempfile)
        f = File.open(tempfile)
        batchwriter = MARC::XMLWriter.new(batch_xml)
        reader = MARC::XMLReader.new(f, parser: "nokogiri")
        reader.each do |batchrecord|
   	      batchwriter.write(batchrecord)
        end
        f.close()
        File.delete(tempfile)
      else
        batchwriter = MARC::XMLWriter.new(batch_xml)
      end
      batchwriter.write(record)
      batchwriter.close
      Dir.rmdir(@copy_of_directory)
      $ui.message("\nThe submission package is in\n  " + batch_directory)
    else
      $ui.message('Copying MARC file in MARCXML format')
      xmlname = File.join(@copy_of_directory, id.gsub(":", "+").gsub("/", "=") + '.xml')
      MARC::XMLWriter.new(xmlname) { |w| w.write(record) }
      if include_forms
        $ui.message('Copying blank DASI and Coversheet')
        f = File.join($xslt_path, 'HathiTrust_DASI.docx')
        newfile = File.join(@copy_of_directory, "DASI_" + id + ".docx")
        FileUtils.cp(f, newfile)
        f = File.join($xslt_path, 'HathiTrust_Coversheet.docx')
        newfile = File.join(@copy_of_directory, "Coversheet_" + id + ".docx")
        FileUtils.cp(f, newfile)
      end
      $ui.message("\nThe submission package is in\n  " + @copy_of_directory)
    end

    if include_forms
      $ui.message("\nFill out and submit the DASI and Coversheet before submitting the MARC file and Zip file.\n")
    end
    $ui.message("The MARC file and Zip file must be submitted by separate processes as described in the HathiTrust documentation.\n")
    $ui.question('', 'Click ENTER to finish.')
  end
end