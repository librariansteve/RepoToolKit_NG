<?xml version="1.0" encoding="UTF-8"?>
<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2017-03-31
UPDATED ON: 2017-11-22
This stylesheet converts Springer metadata to qualified Dublin Core based on the mappings found in the MIRA data dictionary.-->
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
    </xsl:character-map>
    <!-- this starts the crosswalk-->
    <xsl:template match="/">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/">
            <ListRecords>
                <xsl:for-each select="collection('../../RepoToolKit_NG/TempRepo/xml/collection.xml')">
                    <record>
                        <metadata>
                            <mira_import>
                                <xsl:call-template name="file"/>
                                <model:hasModel>Pdf</model:hasModel>
                                <tufts:visibility>open</tufts:visibility>
                                <tufts:memberOf>hm50tr73g</tufts:memberOf>
                                <xsl:call-template name="title"/>
                                <xsl:call-template name="creator"/>
                                <xsl:call-template name="abstract"/>
                                <xsl:call-template name="keywords"/>
                                <dc11:description>Springer Open.</dc11:description>
                                <dc:isPartOf>Tufts University faculty
                                    scholarship.</dc:isPartOf>
                                <dc11:publisher>Tufts University. Tisch Library.</dc11:publisher>
                                <xsl:call-template name="rights"/>
                                <xsl:call-template name="date"/>
                                <dc:created>
                                    <xsl:value-of select="current-dateTime()"/>
                                </dc:created>
                                <dc:type>Text</dc:type>
                                <dc:format>application/pdf</dc:format>
                                <tufts:steward>tisch</tufts:steward>
                                <tufts:qr_note>amay02</tufts:qr_note>
                                <tufts:internal_note>SpringerBatchTransform: <xsl:value-of
                                    select="current-dateTime()"/>; Tisch manages metadata and
                                    binary.</tufts:internal_note>
                                <tufts:displays_in>dl</tufts:displays_in>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="//JournalInfo" name="file">
        <tufts:filename type="representative"><xsl:value-of select="//JournalInfo/JournalID"/>_<xsl:value-of
                select="//RegistrationDate/Year"/>_Article_<xsl:value-of select="//ArticleID"
            />.pdf</tufts:filename>
    </xsl:template>
    <xsl:template match="//ArticleTitle" name="title">
        <dc:title>
            <xsl:value-of select="replace(//ArticleTitle, '\.+$', '')"/>
            <xsl:text>.</xsl:text>
        </dc:title>
    </xsl:template>
    <xsl:template match="//Author" name="creator">
        <xsl:for-each select=".//Author">
            <xsl:choose>
                <xsl:when test=".//GivenName[2]">
                    <dc11:creator><xsl:value-of select="normalize-space(.//FamilyName)"/>, <xsl:value-of select="normalize-space(.//GivenName[1])"/><xsl:text> </xsl:text><xsl:value-of select="normalize-space(replace(.//GivenName[2], '\.+$', ''))"/><xsl:text>.</xsl:text></dc11:creator>
                </xsl:when>
                <xsl:otherwise>
                    <dc11:creator><xsl:value-of select="normalize-space(.//FamilyName)"/>, <xsl:value-of select="normalize-space(.//GivenName[1])"/><xsl:text>.</xsl:text></dc11:creator>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="abstract">
        <xsl:choose>
            <xsl:when test="//AbstractSection[@ID]/Heading">
                <dc:abstract>
                    <xsl:value-of select=".//AbstractSection[@ID][1]/Heading"/>: <xsl:value-of
                        select=".//AbstractSection[@ID][1]/Para[1]"/>
                </dc:abstract>
            </xsl:when>
            <xsl:when test="//Abstract/Heading">
                <dc11:abstract>
                    <xsl:value-of select=".//Abstract/Heading"/>: <xsl:value-of
                        select="normalize-space(.//Abstract[1]/Para[1])"/></dc11:abstract>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="keywords">
        <xsl:choose>
            <xsl:when test=".//KeywordGroup/Heading">
                <dc11:description>
                    <xsl:value-of select=".//KeywordGroup/Heading"/>: <xsl:for-each
                        select=".//Keyword[not(position() = last())]"><xsl:value-of
                            select="normalize-space(.)"/><xsl:text>, </xsl:text></xsl:for-each>
                    <xsl:if test=".//Keyword[last()]">
                        <xsl:value-of select="normalize-space(.//Keyword[last()])"
                        /><xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:when test=".//KeywordGroup">
                <dc11:description>
                    <xsl:text>Keywords: </xsl:text>
                    <xsl:for-each select=".//Keyword[not(position() = last())]">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if test=".//Keyword[last()]">
                        <xsl:value-of select="normalize-space(.//Keyword[last()])"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:when test=".//AbbreviationGroup">
                <dc11:description>
                    <xsl:text>Keywords: </xsl:text>
                    <xsl:for-each
                        select=".//AbbreviationGroup/DefinitionList/DefinitionListEntry[not(position() = last())]">
                        <xsl:value-of select="normalize-space(.//Para)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test=".//AbbreviationGroup/DefinitionList/DefinitionListEntry[position() = last()]">
                        <xsl:value-of
                            select="normalize-space(replace(.//AbbreviationGroup/DefinitionList/DefinitionListEntry[last()]/Description/Para, '\.+$', ''))"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="rights">
        <xsl:choose>
            <xsl:when
                test=".//ArticleCopyright/CopyrightComment/SimplePara/ExternalRef[1]/RefTarget[1]/@Address">
                <dc:license>
                    <xsl:value-of
                        select=".//ArticleCopyright/CopyrightComment/SimplePara/ExternalRef[1]/RefTarget[1]/@Address"
                    />
                </dc:license>
            </xsl:when>
            <xsl:otherwise>
                <dc:license>
                    <xsl:value-of
                        select=".//License/SimplePara/ExternalRef[1]/RefTarget[1]/@Address"/>
                </dc:license>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//OnlineDate/Year" name="date">
        <dc11:date>
            <xsl:value-of select=".//OnlineDate/Year"/>
        </dc11:date>
    </xsl:template>
</xsl:stylesheet>
