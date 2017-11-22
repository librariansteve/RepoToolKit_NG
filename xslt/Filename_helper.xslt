<?xml version="1.0" encoding="UTF-8"?>

<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2014-07-07
UPDATED ON: 2017-04-02

This stylesheet creates a template which is called in another stylsheet, and creates a unique filename.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcadesc="http://nils.lib.tufts.edu/dcadesc/">
    <xsl:template match="pid"/>
    <xsl:template name="pidname">
        <xsl:param name="pid"/>
        <xsl:value-of
            select="substring-after(pid,'tufts:')"/>
        <xsl:choose>
            <xsl:when test="format='application/mp4'">.mp4</xsl:when>
            <xsl:when test="format='image/tiff'">.tif</xsl:when>
            <xsl:when test="format='Image/tiff'">.tif</xsl:when>
            <xsl:otherwise>.archival.pdf</xsl:otherwise>
        </xsl:choose>
    </xsl:template>  
    <xsl:template match="Accession"/>
    <xsl:template name="filename">
        <xsl:param name="file"/>
        <xsl:value-of
            select="replace(replace(Accession,'.pdf',''),'[^0-9A-Za-z]','_')"/>
            <xsl:choose>
            <xsl:when test="Format|format='application/mp4'">.mp4</xsl:when>
            <xsl:when test="Format|format='image/tiff'">.tif</xsl:when>
            <xsl:when test="Format|format='Image/tiff'">.tif</xsl:when>
            <xsl:otherwise>.pdf</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
