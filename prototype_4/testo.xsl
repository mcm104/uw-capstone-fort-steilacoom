<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="xs madsrdf rdf"
    version="2.0">
    <xsl:template match="/">
        <xsl:for-each-group
            select="//demographicTerm[@uri]"
            group-by="@uri">
            <xsl:variable name="lcdgt_uri" select="@uri"/>
            <xsl:variable name="lcdgt"
                select="document(concat($lcdgt_uri, '.rdf'))"/>
            <xsl:variable name="lcdgt_label"
                select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about = $lcdgt_uri]/madsrdf:authoritativeLabel"/>
            <xsl:result-document href="{$lcdgt_label}.rdf">
                <xsl:copy-of select="$lcdgt"/>
            </xsl:result-document>
        </xsl:for-each-group>
        <xsl:result-document href="collection.rdf">
            <xsl:variable name="collection" select="document('http://id.loc.gov/authorities/demographicTerms/collection_LCDGT_Nationality.rdf')"/>
            <xsl:copy-of select="$collection"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>