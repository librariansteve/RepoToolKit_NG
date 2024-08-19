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
# The job expects TIFF filenames which contain a unique number
# ranging from 1 to however many images are contained in the scan.
# The number can contain leading zeroes and must be followed by
# filename extension, or by '_L' or '_R' and then the filename
# extension. The filename extension can be .tif or .tiff. The job
# ignores everything in the filename preceeding the page numeric
# value. Note that the numbers represent scans, not page numbers,
# and should include front and back covers, endpapers, blank pages,
# and front and back matter. Scans can be left-to-right or
# right-to-left.
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
                "\n\nIn particular, a Digital Asset Submission Inventory form and a" +
                "\n  an Administrative Coversheet form must be delivered to HathiTrust" +
                "\n  before any submission." +
                "\n\nPlease provide a directory containing the TIFF files and a MARC record" +
                "\n  for submission. The MARC record must be for the PRINT version of the item" +
                "\n  and should contain the local record identifier in 001 and the OCLC number" +
                "\n  in 035. Each volume of a multi-part title must be submitted to HathiTrust" +
                "\n  separately. Please have the barcode for the item ready.")

    @user_directory = $ui.question("\nWhat is the directory you are working with?")
    while !Dir.exist?(@user_directory)
      $ui.message("\nThat directory does not exist")
      @user_directory = $ui.question('What is the directory you are working with?')
    end

    Dir.chdir(@user_directory)
    files = Dir.glob('**/*.mrc')
    if files.none?
      $ui.splash('No MARC files in directory')
      return
    end
    reader = MARC::Reader.new(files[0])
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
      $ui.splash('Use a MARC record for the print version rather than the online version; exiting')
      return
    elsif recform != 'd' and recform != 'r' and recform != '|' and recform != ' '
      $ui.splash('MARC record is not for a print resource; exiting')
      return
    end
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

    uri = URI('https://catalog.hathitrust.org/api/volumes/full/oclc/' + oclc + '.json')
    response = Net::HTTP.get(uri)
    if JSON[response]["records"].count != 0
      $ui.splash('This OCLC number is already in HathiTrust; exiting')
    else
      $ui.splash('This is NOT in HathiTrust -- creating package directory')
    end

    @copy_of_directory = @user_directory + '_Packaged'
    if Dir.exist?(@copy_of_directory) then FileUtils.remove_dir(@copy_of_directory) end
    FileUtils.mkdir_p @copy_of_directory
    $ui.debug()

    id = $ui.question("\nWhat is the barcode or ARK ID of this submission?")
    if id.start_with? "ark" then
      id = id.gsub("+", ":").gsub("=", "/")
    end

    if !record['003']
      field = MARC::ControlField.new('003', 'MMeT')
      record << field
    end
    field = MARC::DataField.new('955', '0', '0',
      MARC::Subfield.new('b', id))
    if $ui.yesno('Is this a multi-volume MARC record?', 'n')
      volume = $ui.question('What volume is this submission?')
      field.append(MARC::Subfield.new('v', volume))
    end
    record << field
    xmlname = File.join(@copy_of_directory, id.gsub(":", "+").gsub("/", "=") + '.xml')
    MARC::XMLWriter.new(xmlname) { |w| w.write(record) }

    $ui.message('Copying images')
    Dir.glob('**/*.tif').each { |f|
	  imagenum = f[/(\d+)(_[LR])?\.tiff?/,1]
      newfile = File.join(@copy_of_directory, sprintf("%08d.tif", imagenum.to_i))
      FileUtils.cp(f, newfile)
    }
    Dir.chdir(@copy_of_directory)

    # Create OCR files for each page
    languages = Array.new
    if $ui.yesno("\nDoes the text include languages other than English?", 'n')
      $ui.message("\nEnter the 3-letter ISO code for each language in the text, including 'eng' if appropriate")
      $ui.message("Enter one language code at a time; enter blank when finished")
      l = $ui.question('', 'Next language: ')
      while l != ''
        languages << l
        l = $ui.question('', 'Next language: ')
      end
    else
      languages << "eng"
    end
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
    $ui.message('Creating YAML file')
    exif = EXIFR::TIFF.new('00000001.tif')
    yml = File.open("meta.yml", "w+")
    yml.puts "scanner_user: Tufts University, Tisch Library Digital Initiatives Dept."
    if exif.date_time
      yml.puts "capture_date: " + exif.date_time.strftime("%Y-%m-%dT%H:%M:%S%z")
    elsif
      digidate = $ui.question("What day was this item digitized (mm/dd/yyyy)?")
      datetime = Time.strptime(digidate, "%m/%d/%Y")
	  yml.puts "capture_date: " + datetime.strftime("%Y-%m-%dT%H:%M:%S%z")
    end
    if exif.make
      yml.puts "scanner_make: " + exif.make
    end
    if exif.model
      yml.puts "scanner_model: " + exif.model
    end
    if $ui.yesno("\nWas the resource scanned left-to-right?", 'y')
      yml.puts "scanning_order: left-to-right"
    else
      yml.puts "scanning_order: right-to-left"
    end
    if $ui.yesno("\nIs the page reading order scanned left-to-right?", 'y')
      yml.puts "reading_order: left-to-right"
    else
      yml.puts "reading_order: right-to-left"
    end
    yml.close

    # Create MD5 checksum file
    $ui.message("\nGenerating MD5 checksums")
    File.open("checksum.md5", "w+") { |c|
      Dir.glob(['*.tif', '*.txt', '*.xml', 'meta.yml']).each { |f|
        hex = Digest::MD5.file(f).hexdigest
        c.puts(sprintf("%s %s\n", hex, f))
      }
    }

    zipname = id.gsub(":", "+").gsub("/", "=") + '.zip'
    $ui.message('Creating zipfile')
    Zip::File.open(zipname, create: true) { |z|
      Dir.glob(['*.tif', '*.txt', '*.html', 'meta.yml', 'checksum.md5']).each { |f|
        z.add(f, f)
      }
    }
    $ui.message('Deleting temp files')
    Dir.glob(['*.tif', '*.txt', '*.html', 'meta.yml', 'checksum.md5']).each { |f|
      File.delete(f)
    }

    include_forms = $ui.yesno("\nWould you like to fill out a DASI and/or Coversheet for this submission?", 'y')
    if include_forms
      f = File.join($xslt_path, 'HathiTrust_DASI.docx')
      newfile = File.join(@copy_of_directory, "DASI_" + id + ".docx")
      FileUtils.cp(f, newfile)
      f = File.join($xslt_path, 'HathiTrust_Coversheet.docx')
      newfile = File.join(@copy_of_directory, "Coversheet_" + id + ".docx")
      FileUtils.cp(f, newfile)
    end

    $ui.message("\nThe submission package is in\n  " + @copy_of_directory)
    if include_forms
      $ui.message("\nFill out and submit the DASI and Coversheet before submitting the MARC file and Zip file.\n")
    end
    $ui.message("The MARC file and Zip file must be submitted by separate processes as described in the HathiTrust documentation.\n")
    $ui.question('', 'Click ENTER to finish.')
  end
end