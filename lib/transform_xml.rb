# Passes the transforms as command lines
module Transforms
  def excel
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:./firstTransform.xml -xsl:../../RepoToolKit_NG/xslt/extract_excel.xslt -o:./workWithThis.xml`
    self
  end

  def transform
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:collection.xml -xsl:../../RepoToolKit_NG/xslt/excel_to_dc.xslt -o:./ingestThis.xml`
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:../../RepoToolKit_NG/xslt/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_springer
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:./collection.xml -xsl:../../../RepoToolKit_NG/xslt/Springer.xslt -o:../xml/ingestThis.xml`
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:./ingestThis.xml -xsl:../../../RepoToolKit_NG/xslt/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_proquest
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:collection.xml -xsl:../../RepoToolKit_NG/xslt/Proquest.xslt -o:./ingestThis.xml`
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:../../RepoToolKit_NG/xslt/subject.xslt -o:./subjects.txt`
    self
  end

  def transform_it_inhouse
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:inHouse.xml -xsl:../../RepoToolKit_NG/xslt/inhouse.xslt -o:./ingestThis.xml`
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform -t -s:ingestThis.xml -xsl:../../RepoToolKit_NG/xslt/subject.xslt -o:./subjects.txt`
    self
  end

  def subject_only
    `java -cp //Applications/SaxonHE9-7-0-15J/saxon9he.jar net.sf.saxon.Transform xml/*.xml -t -xsl:../../RepoToolKit_NG/xslt/subject.xslt -o:xml/subject_update.txt`
    self
  end
end
