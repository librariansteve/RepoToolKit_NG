# Passes the transforms as command lines
module Transforms
  def excel
    $ui.debug()
    $ui.message('Running Saxon transform')
   `java -cp #{$saxon_path} net.sf.saxon.Transform -s:./firstTransform.xml -xsl:#{$xslt_path}/extract_excel.xslt -o:./workWithThis.xml`
    self
  end

  def transform
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:collection.xml -xsl:#{$xslt_path}/excel_to_dc.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_springer
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:collection.xml -xsl:#{$xslt_path}/Springer.xslt -o:ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:subjects.txt`
    self
  end

  def transform_it_acm
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:mets.xml -xsl:#{$xslt_path}/ACM.xslt -o:ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:subjects.txt`
    self
  end

  def transform_it_proquest
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:collection.xml -xsl:#{$xslt_path}/Proquest.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_inhouse
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:inHouse.xml -xsl:#{$xslt_path}/inhouse.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def subject_only
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform xml/*.xml -xsl:#{$xslt_path}/subject.xslt -o:xml/subject_update.txt`
    self
  end

  def transform_it_licensed_video
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:inHouse.xml -xsl:#{$xslt_path}/licensed_video.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_licensed_pdf
    $ui.debug()
    $ui.message('Running Saxon transform')
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:inHouse.xml -xsl:#{$xslt_path}/licensed_pdf.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end
end
