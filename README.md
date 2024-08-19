A toolkit for proto-SIP processing at Tisch Library using a Ruby front-end to launch a set of xslt's,
and repackage the content consistently for ingest into MIRA 2.0.  You can find the toolkit
on Github: https://github.com/Alexandermay/RepoToolKit_NG

Before using please review Best Practices for Using the RepoToolKit

Requirements

    Java
    Saxon
    Ruby 2.0.0+
    Roo
    Nokogiri
	Marc
	Exifr

The Toolkit Runs on both Mac and Windows
For Mac Environment

    Enter the command line editor
    Mac :  ?
    Windows :  click or open Command Prompt or Powershell
    In the following steps, command line actions will be designated with a preceding $

    Test whether you have Ruby (at least version 2.0.0)
    Mac & Windows :  $ ruby -v

    Test whether you have Java
    Mac & Windows :  $ java --version

    If you don't have Ruby, install it
    Mac :  $ brew install ruby
    Windows :  use a browser to install from rubyinstaller.org

    If you don't have Java, install it
    Mac :  $ brew cask install java
    Windows :  use a browser to install from www.java.com

    Download and install the latest version of Saxon-HE for Java from Saxonica
    Mac & Windows :  use a browser to install from http://www.saxonica.com
    Make note of the full path of the Saxon-HE jar file
	
    Create a new personal environment variable, named SAXON_PATH, with a value equal to the full path of the Saxon-HE jar file
	
    Install ruby gems
    Mac & Windows :  $ gem install roo
    Mac & Windows :  $ gem install nokogiri
	Mac & Windows :  $ gem install exifr
	Mac & Windows :  $ gem install marc
	Mac & Windows :  $ gem install exifr

    Open a browser and go to https://github.com/librariansteve/RepoToolKit_NG
	On the right-hand side of the page, click on the *Latest Release*
	Review the ChangeLog
	Click either the *Source Code (zip)* link to download the software
	Unzip the software folder wherever you want to keep it

    Change directory to RepoToolKit_NG/bin
    Mac & Windows :  $ cd RepoToolKit_NG/bin

    Run the launcher.rb
    Mac & Windows :  $ ruby launcher.rb
    OR click the icon for launcher.rb
	
    You should now see a welcome screen with a list of options:

    >RepoToolKit <version number>
    >What would you like to do?
    >
    >Faculty Scholarship.
    >Student Scholarship.
    >...
	>Test ToolKit
	>Debug Mode
	>Quit
	>
	>Enter at least the first few letters of your choice:
    >  ? > |  



    Test the install by typing "fac" at the prompt. This will launch the Faculty script.
    Launching the Faculty Scholarship script.
    What is the directory you are working with?

    At the prompt (>) enter the absolute path to the sample_set directory[^1]

    If you drag and drop the directory, make sure to delete any trailing whitespace.[^2]

    Hit return

    You should then see that the files are being moved into their respective directories, and Saxon is launched to transform the .xslx into the XML Tisch needs to despoit items into the repository.

    When it finishes, you will be given an option to review the xml. It is best if you have oXygen, otherwise it will open in a generic text editor.

So, did it work?

If ingestThis.xml is produced, and the content is packaged into excel, pdf and xml directories respectively, then you are set to process content for ingest into MIRA. Remember the following:

    The Proquest and Springer processes require zip files in their own directory.

    The Trove, Faculty and Student processes require .xlsx files and their respective binaries.

    The inHouse Digitization process needs a MARC xml file and binaries.

    The Cataloger Subject Analysis should be run against Trove, Faculty, or Student processes, simply drag and drop the entire directory to get an updated analysis.