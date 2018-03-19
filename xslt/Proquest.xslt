<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    xmlns:terms="http://dl.tufts.edu/terms#" xmlns:model="info:fedora/fedora-system:def/model#"
    xmlns:dc="http://purl.org/dc/terms/" xmlns:dc11="http://purl.org/dc/elements/1.1/"
    xmlns:tufts="http://dl.tufts.edu/terms#" xmlns:bibframe="http://bibframe.org/vocab/"
    xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
    xmlns:premis="http://www.loc.gov/premis/rdf/v1#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:marcrelators="http://id.loc.gov/vocabulary/relators/"
    xmlns:scholarsphere="http://scholarsphere.psu.edu/ns#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
    <!--This calls the named templates found in the following xslt(s) for parsing specific fields into approprite data for ingest  -->
    <xsl:import href="SplitField_helper.xslt"/>
    <xsl:import href="Filename_helper.xslt"/>
    <!--This changes the output to xml -->
    <xsl:output method="xml" indent="yes" use-character-maps="killSmartPunctuation" encoding="UTF-8"/>
    <xsl:character-map name="killSmartPunctuation">
        <xsl:output-character character="“" string="&quot;"/>
        <xsl:output-character character="”" string="&quot;"/>
        <xsl:output-character character="’" string="'"/>
        <xsl:output-character character="‘" string="'"/>
        <xsl:output-character character="&#x2013;" string="-"/>
        <xsl:output-character character="{" string="("/>
        <xsl:output-character character="}" string=")"/>
    </xsl:character-map>
    <!-- this starts the crosswalk-->
    <xsl:template match="/">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/">
            <ListRecords>
                <xsl:for-each select="collection('../../RepoToolKit_NG/TempRepo/collection.xml')">
                    <record>
                        <metadata>
                            <mira_import>
                                <xsl:call-template name="file"/>
                                <model:hasModel>Pdf</model:hasModel>
                                <tufts:visibility>open</tufts:visibility>
                                <tufts:memberOf>mc87pq395</tufts:memberOf>
                                <xsl:call-template name="title"/>
                                <xsl:call-template name="creator"/>
                                <xsl:call-template name="abstract"/>
                                <xsl:call-template name="degree"/>
                                <xsl:call-template name="department"/>
                                <xsl:call-template name="advisors"/>
                                <xsl:call-template name="committee"/>
                                <xsl:call-template name="keywords"/>
                                <xsl:call-template name="institution"/>
                                <dc:isPartOf>Tufts University electronic theses and
                                    dissertations.</dc:isPartOf>
                                <dc11:publisher>Tufts University. Tisch Library.</dc11:publisher>
                                <xsl:call-template name="date"/>
                                <dc:date.created>
                                    <xsl:value-of select="current-dateTime()"/>
                                </dc:date.created>
                                <xsl:call-template name="dcaterms_department"/>
                                <dc:type>Text</dc:type>
                                <dc:format>application/pdf</dc:format>
                                <terms:steward>dca</terms:steward>
                                <tufts:qr_note>amay02</tufts:qr_note>
                                <tufts:internal_note>ProquestBatchTransform: <xsl:value-of
                                        select="current-dateTime()"/>; Tisch and DCA allowed to
                                    manage metadata and binary.</tufts:internal_note>
                                <xsl:call-template name="displays"/>
                                <xsl:call-template name="embargo"/>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="//DISS_binary" name="file">
        <tufts:filename type="representative">
            <xsl:value-of select="//DISS_binary"/>
        </tufts:filename>
    </xsl:template>
    <xsl:template match="//DISS_title" name="title">
        <dc:title>
            <xsl:value-of select="normalize-space(replace(//DISS_title, '\.+$', '.'))"/>
        </dc:title>
    </xsl:template>
    <xsl:template match="//DISS_author" name="creator">
        <dc11:creator>
            <xsl:value-of
                select="normalize-space(/DISS_submission/DISS_authorship/DISS_author/DISS_name/DISS_surname)"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="normalize-space(/DISS_submission/DISS_authorship/DISS_author/DISS_name/DISS_fname)"/>
            <xsl:text>.</xsl:text>
        </dc11:creator>
    </xsl:template>
    <xsl:template match="//DISS_abstract" name="abstract">
        <dc:abstract>
            <xsl:value-of select="normalize-space(/DISS_submission/DISS_content/DISS_abstract)"/>
        </dc:abstract>
    </xsl:template>
    <xsl:template match="//DISS_degree" name="degree">
        <dc11:description>
            <xsl:text>Thesis (</xsl:text>
            <xsl:value-of select="normalize-space(/DISS_submission/DISS_description/DISS_degree)"/>
            <xsl:text>)--Tufts University, </xsl:text>
            <xsl:value-of select="./DISS_submission/DISS_description/DISS_dates/DISS_comp_date"/>
            <xsl:text>.</xsl:text>
        </dc11:description>
    </xsl:template>
    <xsl:template match="//DISS_inst_contact[1]" name="department">
        <dc11:description>
            <xsl:text>Submitted to the Dept. of </xsl:text>
            <xsl:value-of
                select="DISS_submission/DISS_description[1]/DISS_institution[1]/DISS_inst_contact[1]"/>
            <xsl:text>.</xsl:text>
        </dc11:description>
    </xsl:template>
    <xsl:template match="//DISS_advisor" name="advisors">
        <xsl:choose>
            <xsl:when
                test="/DISS_submission/DISS_description/DISS_advisor[not(position() = last())]/DISS_name">
                <dc11:description>
                    <xsl:text>Advisors: </xsl:text>
                    <xsl:for-each
                        select="/DISS_submission/DISS_description/DISS_advisor[not(position() = last())]/DISS_name">
                        <xsl:value-of select="normalize-space(DISS_fname)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(DISS_surname)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test="/DISS_submission/DISS_description/DISS_advisor[position() > 1][last()]/DISS_name">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_advisor[position() > 1][last()]/DISS_name/DISS_fname"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_advisor[position() > 1][last()]/DISS_name/DISS_surname"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise>
                <dc11:description>
                    <xsl:text>Advisor: </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_advisor[1]/DISS_name[1]/DISS_fname[1])"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_advisor[1]/DISS_name[1]/DISS_surname[1])"/>
                    <xsl:text>.</xsl:text>
                </dc11:description>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_cmte_member" name="committee">
        <xsl:choose>
            <xsl:when
                test="/DISS_submission/DISS_description/DISS_cmte_member[not(position() = last())]/DISS_name">
                <dc11:description>
                    <xsl:text>Committee: </xsl:text>
                    <xsl:for-each
                        select="/DISS_submission/DISS_description/DISS_cmte_member[not(position() = last())]/DISS_name">
                        <xsl:value-of select="normalize-space(DISS_fname)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(DISS_surname)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test="/DISS_submission/DISS_description/DISS_cmte_member[position() > 1][last()]/DISS_name">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_cmte_member[position() > 1][last()]/DISS_name/DISS_fname"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_cmte_member[position() > 1][last()]/DISS_name/DISS_surname"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:when test="/DISS_submission/DISS_description[1]/DISS_cmte_member[1]/DISS_name[1]">
                <dc11:description>
                    <xsl:text>Committee: </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_cmte_member[1]/DISS_name[1]/DISS_fname[1])"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_cmte_member[1]/DISS_name[1]/DISS_surname[1])"/>
                    <xsl:text>.</xsl:text>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_category" name="keywords">
        <xsl:choose>
            <xsl:when
                test="/DISS_submission/DISS_description/DISS_categorization/DISS_category[not(position() = last())]/DISS_cat_desc">
                <dc11:description>
                    <xsl:text>Keywords: </xsl:text>
                    <xsl:for-each
                        select="/DISS_submission/DISS_description/DISS_categorization/DISS_category[not(position() = last())]/DISS_cat_desc">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test="/DISS_submission/DISS_description/DISS_categorization/DISS_category[position() > 1][last()]/DISS_cat_desc">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_categorization/DISS_category[position() > 1][last()]/DISS_cat_desc"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise>
                <dc11:description>
                    <xsl:text>Keyword: </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_categorization[1]/DISS_category[1]/DISS_cat_desc[1])"/>
                    <xsl:text>.</xsl:text>
                </dc11:description>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_inst_code" name="institution">
        <xsl:choose>
            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0930')]">
                <dc:isPartOf>Tufts University. Fletcher School of Law and Diplomacy. Theses and
                    Dissertations.</dc:isPartOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0234')] and //DISS_inst_contact[contains(text(), 'Engineering')]">
                <dc:isPartOf>Tufts University. School of Engineering. Theses and
                    Dissertations.</dc:isPartOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0234')] and //DISS_inst_contact[not(contains(text(), 'Engineering'))]">
                <dc:isPartOf>Tufts University. Graduate School of Arts and Sciences. Theses and
                    Dissertations.</dc:isPartOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0845')]">
                <dc:isPartOf>Tufts University. Sackler School of Graduate Biomedical Sciences.
                    Theses and Dissertations.</dc:isPartOf>
            </xsl:when>
            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '1546')]">
                <dc:isPartOf>Tufts University. Gerald J. &amp; Dorothy R. Friedman School of
                    Nutrition Science and Policy. Theses and Dissertations.</dc:isPartOf>
            </xsl:when>
            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '1547')]">
                <dc:isPartOf>Tufts University. School of Dental Medicine. Theses and
                    Dissertations.</dc:isPartOf>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_comp_date" name="date">
        <dc11:date>
            <xsl:value-of select="./DISS_submission/DISS_description/DISS_dates/DISS_comp_date"/>
        </dc11:date>
    </xsl:template>
    <xsl:template match="//DISS_inst_contact[1]" name="dcaterms_department">
        <xsl:choose>
            <xsl:when
                test="//DISS_inst_contact[1][contains(text(), 'Diplomacy, History, and Politics')]">
                <mads:CorporateName>Fletcher School of Law and Diplomacy.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Chemistry')]">
                <mads:CorporateName>Tufts University. Department of Chemistry.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Art')]">
                <mads:CorporateName>Tufts University. Department of Art and Art
                    History.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Biology')]">
                <mads:CorporateName>Tufts University. Department of Biology.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Biomedical')]">
                <mads:CorporateName>Tufts University. Department of Biomedical
                    Engineering.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Biological')]">
                <mads:CorporateName>Tufts University. Department of Chemical and Biological
                    Engineering.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Civil')]">
                <mads:CorporateName>Tufts University. Department of Civil and Environmental
                    Engineering.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Classics')]">
                <mads:CorporateName>Tufts University. Department of Classics.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Computer')]">
                <mads:CorporateName>Tufts University. Department of Computer
                    Science.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Drama')]">
                <mads:CorporateName>Tufts University. Department of Drama and
                    Dance.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Drama')]">
                <mads:CorporateName>Tufts University. Department of Drama and
                    Dance.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Economics')]">
                <mads:CorporateName>Tufts University. Department of Economics.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Education')]">
                <mads:CorporateName>Tufts University. Department of Education.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Electrical')]">
                <mads:CorporateName>Tufts University. Department of Electrical and Computer
                    Engineering.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'English')]">
                <mads:CorporateName>Tufts University. Department of English.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'History')]">
                <mads:CorporateName>Tufts University. Department of History.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Mathematics')]">
                <mads:CorporateName>Tufts University. Department of
                    Mathematics.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Mechanical')]">
                <mads:CorporateName>Tufts University. Department of Mechanical
                    Engineering.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Music')]">
                <mads:CorporateName>Tufts University. Department of Music.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Physics')]">
                <mads:CorporateName>Tufts University. Department of Physics and
                    Astronomy.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Psychology')]">
                <mads:CorporateName>Tufts University. Department of Psychology.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Urban')]">
                <mads:CorporateName>Tufts University. Department of Urban and Environmental Policy
                    and Planning.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Child')]">
                <mads:CorporateName>Tufts University. Eliot-Pearson Department of Child
                    Development.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Nutrition')]">
                <mads:CorporateName>Gerald J. &amp; Dorothy R. Friedman School of Nutrition Science
                    and Policy.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Fletcher')]">
                <mads:CorporateName>Fletcher School of Law and Diplomacy.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Dental')]">
                <mads:CorporateName>Tufts University. School of Dental
                    Medicine.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Occupational')]">
                <mads:CorporateName>Tufts University. Occupational Therapy
                    Department.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Interdisciplinary')]">
                <mads:CorporateName>Tufts University.Graduate School of Arts and
                    Sciences.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_contact[1][contains(text(), 'School of Nutrition')] | //DISS_inst_name[1][contains(text(), 'School of Nutrition')]">
                <mads:CorporateName>Gerald J. &amp; Dorothy R. Friedman School of Nutrition Science
                    and Policy.</mads:CorporateName>
            </xsl:when>
            <xsl:when test="//DISS_inst_name[1][contains(text(), 'Dental')]">
                <mads:CorporateName>Tufts University. School of Dental
                    Medicine.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Biochemistry')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Biochemistry.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Cell')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences Department of
                    Cell, Molecular and Developmental Biology.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Cellular')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Cellular and Molecular Physiology.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Translational')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Clinical and Translational Science.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Clinical Research')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Clinical Research.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Immunology')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Immunology.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Genetics')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Genetics.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Microbiology')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Molecular Microbiology.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Neuroscience')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Neuroscience.</mads:CorporateName>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Therapeutics')]">
                <mads:CorporateName>Sackler School of Graduate Biomedical Sciences. Department of
                    Pharmacology and Experimental Therapeutics.</mads:CorporateName>
            </xsl:when>
            <xsl:otherwise>
                <mads:CorporateName>NONEFOUND</mads:CorporateName>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_comp_date" name="displays">
        <xsl:choose>
            <xsl:when test="(//DISS_comp_date &lt; 2011)">
                <terms:displays_in>nowhere</terms:displays_in>
            </xsl:when>
            <xsl:otherwise>
                <terms:displays_in>dl</terms:displays_in>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_submission" name="embargo">
        <xsl:choose>
            <xsl:when test="/DISS_submission[@embargo_code = '1']">
                <terms:embargo>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$3-')"/>
                    <xsl:value-of
                        select="(number(replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$1')) + 6)"/>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '-$2')"
                    />
                </terms:embargo>
            </xsl:when>
            <xsl:when test="/DISS_submission[@embargo_code = '2']">
                <terms:embargo>
                    <xsl:value-of
                        select="number(replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$3')) + 1"/>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '-$1-$2')"
                    />
                </terms:embargo>
            </xsl:when>
            <xsl:when test="/DISS_submission[@embargo_code = '3']">
                <terms:embargo>
                    <xsl:value-of
                        select="number(replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$3')) + 2"/>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '-$1-$2')"
                    />
                </terms:embargo>
            </xsl:when>
            <xsl:when
                test="/DISS_submission[@embargo_code = '4'] and /DISS_submission/DISS_restriction/DISS_sales_restriction[@remove = '']">
                <terms:embargo> 2999 </terms:embargo>
            </xsl:when>
            <xsl:when test="/DISS_submission[@embargo_code = '4']">
                <terms:embargo>
                    <xsl:value-of
                        select="normalize-space(replace(/DISS_submission/DISS_restriction/DISS_sales_restriction/@remove, '(\d{2})/(\d{2})/((\d{4}))', '$3-$1-$2'))"
                    />
                </terms:embargo>
            </xsl:when>
            <xsl:otherwise>
                <terms:embargo/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
