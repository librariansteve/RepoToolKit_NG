# Passes the transforms as command lines
module Transforms
  def excel
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:./firstTransform.xml -xsl:#{$xslt_path}/extract_excel.xslt -o:./workWithThis.xml`
    self
  end

  def transform
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:collection.xml -xsl:#{$xslt_path}/excel_to_dc.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_springer
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:collection.xml -xsl:#{$xslt_path}/Springer.xslt -o:ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:subjects.txt`
    self
  end

  def transform_it_proquest
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:collection.xml -xsl:#{$xslt_path}/Proquest.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_inhouse
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:inHouse.xml -xsl:#{$xslt_path}/inhouse.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def subject_only
    `java -cp #{$saxon_path} net.sf.saxon.Transform xml/*.xml -t -xsl:#{$xslt_path}/subject.xslt -o:xml/subject_update.txt`
    self
  end

  def transform_it_licensed_video
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:inHouse.xml -xsl:#{$xslt_path}/licensed_video.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_licensed_pdf
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:inHouse.xml -xsl:#{$xslt_path}/licensed_pdf.xslt -o:./ingestThis.xml`
    `java -cp #{$saxon_path} net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:#{$xslt_path}/subject.xslt -o:./subjects.txt`
    self
  end
end
