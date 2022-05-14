<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xsl:result-document href="newsletter_table.xml">
            <newsletters>
                <xsl:for-each select="//tr[@class='' or not(@class)]">
                    <newsletter>
                        <title><xsl:value-of select="td[1]"/></title>
                        <author><xsl:value-of select="td[2]"/></author>
                        <volume><xsl:value-of select="td[3]"/></volume>
                        <link><xsl:value-of select="td[3]/a/@href"/></link>
                        <date><xsl:value-of select="td[4]"/></date>
                    </newsletter>
                </xsl:for-each>
            </newsletters>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>