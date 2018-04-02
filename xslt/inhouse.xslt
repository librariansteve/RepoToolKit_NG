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
    <xsl:import href="MARC_helper.xslt"/>
    <xsl:import href="Filename_helper.xslt"/>
    <!--This changes the output to xml -->
    <xsl:output method="xml" indent="yes" use-character-maps="killSmartPunctuation" encoding="UTF-8"/>
    <xsl:character-map name="killSmartPunctuation">
        <xsl:output-character character="“" string="&quot;"/>
        <xsl:output-character character="”" string="&quot;"/>
        <xsl:output-character character="’" string="'"/>
        <xsl:output-character character="‘" string="'"/>
        <xsl:output-character character="&#x2013;" string="-"/>
    </xsl:character-map>
    <!-- this starts the crosswalk-->
    <xsl:template match="/">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/">
            <ListRecords>
                <xsl:for-each select="collection/record">
                    <record>
                        <metadata>
                            <mira_import>
                                <xsl:call-template name="file"/>
                                <model:hasModel>Pdf</model:hasModel>
                                <xsl:call-template name="title"/>
                                <xsl:call-template name="alternative"/>
                                <xsl:call-template name="creator"/>
                                <xsl:call-template name="contributor"/>
                                <xsl:call-template name="edition"/>
                                <xsl:call-template name="phyical_item_description"/>
                                <xsl:call-template name="notes"/>
                                <xsl:call-template name="toc"/>
                                <xsl:call-template name="boundwith"/>
                                <xsl:call-template name="repoduction_note"/>
                                <xsl:call-template name="provenance"/>
                                <xsl:call-template name="binding"/>
                                <xsl:call-template name="indexed_in"/>
                                <xsl:call-template name="language"/>
                                <xsl:call-template name="internet_archive"/>
                                <dc11:publisher>Tufts University. Tisch Library.</dc11:publisher>
                                <xsl:call-template name="phys_source"/>
                                <xsl:call-template name="date"/>
                                <dc:created>
                                    <xsl:value-of select="current-dateTime()"/>
                                </dc:created>
                                <dc:type>Text</dc:type>
                                <dc:format>application/pdf</dc:format>
                                <xsl:call-template name="persname_subject"/>
                                <xsl:call-template name="corpname_subject"/>
                                <xsl:call-template name="geo_subject"/>
                                <xsl:call-template name="topic_subject"/>
                                <xsl:call-template name="genre"/>
                                <dc:license>https://creativecommons.org/licenses/by-nc-nd/4.0/</dc:license>
                                <terms:steward>tisch</terms:steward>
                                <tufts:qr_note>Metadata reviewed by:amay02</tufts:qr_note>
                                <tufts:internal_note><xsl:value-of select="datafield[@tag='910'][1]/subfield[@code = 'a']"/>. Original MARC record creator info: <xsl:value-of select="datafield[@tag='910'][2]/subfield[@code = 'a']"/>.</tufts:internal_note>
                                <!-- this portion inserts the boilerplate batch displays information -->
                                <terms:displays_in>dl</terms:displays_in>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="@tag" name="file">
        <tufts:filename type="representative">
                <xsl:call-template name="archive_name">
                    <xsl:with-param name="file"/>
                </xsl:call-template>
        </tufts:filename>
        </xsl:template>
    <xsl:template match="@tag" name="title">
        <dc:title>
            <xsl:value-of
                select="normalize-space(replace(replace(datafield[@tag = '245'], '\[electronic resource\]', ''), '(/|:|;|,)', '$1 '))"
            />
        </dc:title>
    </xsl:template>
    <xsl:template match="@tag" name="alternative">
        <xsl:for-each
            select="datafield[@tag = '246']/subfield[@code = 'a'] | datafield[@tag = '240']">
            <dc:alternative>
                <xsl:value-of select="normalize-space(.)"/>.
            </dc:alternative>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="creator">
        <xsl:for-each
            select="datafield[@tag = '100'] | datafield[@tag = '110'] | datafield[@tag = '111'] | datafield[@tag = '130']">
            <dc11:creator>
                <xsl:call-template name="nameSelect">
                    <xsl:with-param name="delimeter">
                        <xsl:text> </xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </dc11:creator>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="contributor">
        <xsl:for-each
            select="datafield[@tag = '700'] | datafield[@tag = '710'] | datafield[@tag = '711'] | datafield[@tag = '720']">
            <dc11:contributor>
                <xsl:call-template name="nameSelect">
                    <xsl:with-param name="delimeter">
                        <xsl:text> </xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </dc11:contributor>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="edition">
        <xsl:for-each select="datafield[@tag = '250']/subfield[@code = 'a']">
                    <dc11:description>
                        <xsl:value-of select="normalize-space(.)"/>
                    </dc11:description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="phyical_item_description">
        <dc11:description>
            <xsl:value-of
                select="normalize-space(replace(replace(datafield[@tag = '300']/replace(., '(\w )$', '$1.'), '(/|:|;|,)', '$1 '), '(\w)$', '$1.'))"
            />
        </dc11:description>
    </xsl:template>
    <xsl:template match="@tag" name="notes">
        <xsl:for-each select="datafield[@tag = '500']">
            <dc11:description>
                <xsl:value-of select="normalize-space(.)"/>
            </dc11:description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="boundwith">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '501'][text()]">
                <dc11:description>Bound with: <xsl:value-of
                        select="normalize-space(datafield[@tag = '501']/replace(., '(MMeT.)|(MMeT)|(MMet)', ''))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="toc">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '505'][text()]">
                <xsl:for-each select="datafield[@tag = '505']">
                    <dc:tableOfContents>Table of Contents: <xsl:value-of
                            select="normalize-space(.)"/>
                    </dc:tableOfContents>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="indexed_in">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '510'][text()]">
                <xsl:for-each select="datafield[@tag = '510']">
                    <dc11:description>Indexed in: <xsl:value-of select="normalize-space(.)"/>
                    </dc11:description>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="repoduction_note">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '533'][text()]">
                <dc11:description>
                    <xsl:value-of
                        select="normalize-space(replace(datafield[@tag = '533']/replace(., '(MMeT.)|(MMeT)|(MMet)', ''), '(:|;|,|\.)', '$1 '))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="provenance">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '561'][text()]">
                <xsl:for-each select="datafield[@tag = '561']">
                    <dc11:description>Provenance: <xsl:value-of
                            select="normalize-space(./replace(., '(MMeT.)|(MMeT)|(MMet)', ''))"/>
                    </dc11:description>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="binding">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '563'][text()]">
                <dc11:description>
                    <xsl:value-of
                        select="normalize-space(replace(./replace(datafield[@tag = '563'], '(MMeT.)|(MMeT)|(MMet)', ''), '(:|;|,|\.)', '$1 '))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="language">
        <dc11:language>
            <xsl:value-of
                select="normalize-space(controlfield[@tag = '008']/replace(., '.*?\s\d\s|.{2}$', ''))"
            />
        </dc11:language>
    </xsl:template>
    <xsl:template match="@tag" name="internet_archive">
        <xsl:choose>
            <xsl:when
                test="datafield[@tag = '910']/subfield[@code = 'a'][contains(text(), 'Tisch')]">
                <dc11:description>
                    <xsl:value-of
                        select="normalize-space(./replace(datafield[@tag = '910']/subfield[@code = 'a'][contains(text(), 'Tisch')], '.*/', ''))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="phys_source">
        <xsl:choose>
            <xsl:when test="datafield[@tag = '776'][@ind2 = '8']">
                
                <dc:source>
                    <xsl:value-of select="normalize-space(datafield[@tag = '776'][1])"/>
                </dc:source>
                
            </xsl:when>
            <xsl:otherwise>
                <dc:source>Original print publication: <xsl:value-of
                    select="normalize-space(datafield[@tag = '260'])"
                /></dc:source>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="date">
        <xsl:choose>
            <xsl:when test=".//datafield[@tag = '264'][@ind2='1']/subfield[@code='c']">
                <dc11:date>
                    <xsl:for-each select=".//datafield[@tag = '264'][@ind2='1']/subfield[@code='c']">
                        <xsl:value-of select="normalize-space(replace(.,'\?|\[|\]|\.',''))"
                        />
                    </xsl:for-each>
                </dc11:date>
            </xsl:when>
            <xsl:when test=".//datafield[@tag = '260']/subfield[@code='c']">
                <dc:date>
                    <xsl:for-each select=".//datafield[@tag = '260']/subfield[@code='c']">
                        <xsl:value-of select="normalize-space(replace(.,'\?|\[|\]|\.',''))"/>
                    </xsl:for-each> 
                </dc:date>
            </xsl:when>     
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="persname_subject">
        <xsl:choose>
            <xsl:when test="datafield[@tag = 600][text()]">
                <xsl:for-each select="datafield[@tag = 600]">
                    <mads:PersonalName>
                        <xsl:call-template name="nameSelect">
                            <xsl:with-param name="delimeter">
                                <xsl:text> </xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </mads:PersonalName>
                </xsl:for-each>
            </xsl:when>

        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="corpname_subject">
        <xsl:choose>
            <xsl:when test="datafield[@tag = 610][text()] | datafield[@tag = 611][text()]">
                <xsl:for-each select="datafield[@tag = 610] | datafield[@tag = 611]">
                    <mads:CorporateName>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimeter">--</xsl:with-param>
                        </xsl:call-template>
                    </mads:CorporateName>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="geo_subject">
        <xsl:choose>
            <xsl:when test="datafield[@tag = 651][text()]">
                <xsl:for-each select="datafield[@tag = 651]">
                    <dc:spatial>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimeter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc:spatial>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="topic_subject">
        <xsl:choose>
            <xsl:when test="datafield[@tag = 650][text()]">
                <xsl:for-each select="datafield[@tag = 650]">
                    <dc11:subject>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimeter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc11:subject>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="genre">
        <xsl:choose>
            <xsl:when test="datafield[@tag = 655][text()]">
                <xsl:for-each select="datafield[@tag = '655']">
                    <mads:GenreForm>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimeter">--</xsl:with-param>
                        </xsl:call-template>
                    </mads:GenreForm>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
