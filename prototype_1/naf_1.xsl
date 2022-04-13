<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xsl:result-document href="sidebar.html">
            <div class="naf-sidebar" style="height: 480px; float: right; background-color: #F8F6F2; border-style: solid; border-color: #D5552B; border-width: 1px; width: 15%; padding: 20px; margin: 5px">
                <h2>People, Families, and Corporate Bodies</h2>
                <ul>
                    <xsl:for-each select="/nameAuthorityFile/agents/agent">
                        <xsl:variable name="agent_id" select="@id"/>
                        <li><a href="{$agent_id}.html"><xsl:value-of select="preferredName"/></a></li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:result-document>
        <xsl:for-each select="/nameAuthorityFile/agents/agent">
            <xsl:variable name="agent_id" select="@id"/>
            <xsl:result-document href="{$agent_id}.html">
                <html>
                    <head>
                        <title><xsl:value-of select="preferredName"/></title>
                    </head>
                    <xsl:if test="tribalAffiliation">
                        Member of <xsl:value-of select="tribalAffiliation"/>
                    </xsl:if>
                    <body>
                        <h1><xsl:value-of select="preferredName"/></h1>
                        <xsl:if test="alternateName">
                            <h2>Alternate names</h2>
                            <ul>
                                <xsl:for-each select="alternateName">
                                    <li><xsl:value-of select="."/></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="dateOfBirth">
                            <h2>Date of birth</h2>
                            <xsl:value-of select="dateOfBirth/*"/>
                        </xsl:if>
                        <xsl:if test="dateOfDeath">
                            <h2>Date of death</h2>
                            <xsl:value-of select="dateOfDeath/*"/>
                        </xsl:if>
                        <xsl:if test="dateOfMarriage">
                            <h2>Date of marriage</h2>
                            <xsl:for-each select="dateOfMarriage">
                                <xsl:choose>
                                    <xsl:when test="@relatedAgent">
                                        <xsl:variable name="spouse_id" select="@relatedAgent"/>
                                        <xsl:variable name="spouse" select="//agent[@id=$spouse_id]"/>
                                        <xsl:choose>
                                            <xsl:when test="year">
                                                Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> in <xsl:value-of select="year"/>
                                            </xsl:when>
                                            <xsl:when test="yearMonth">
                                                Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> in <xsl:value-of select="yearMonth"/>
                                            </xsl:when>
                                            <xsl:when test="date">
                                                Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> on <xsl:value-of select="date"/>
                                            </xsl:when>
                                            <xsl:when test="approximateDate">
                                                Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> c. <xsl:value-of select="approximateDate"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="hasParent">
                            <h2>Parent(s)</h2>
                            <ul>
                                <xsl:for-each select="hasParent">
                                    <xsl:variable name="parent_id" select="@relatedAgent"/>
                                    <xsl:variable name="parent" select="//agent[@id=$parent_id]"/>
                                    <li><a href="{$parent_id}.html"><xsl:value-of select="$parent/preferredName"/></a></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="hasSpouse">
                            <h2>Spouse(s)</h2>
                            <ul>
                                <xsl:for-each select="hasSpouse">
                                    <xsl:variable name="spouse_id" select="@relatedAgent"/>
                                    <xsl:variable name="spouse" select="//agent[@id=$spouse_id]"/>
                                    <li><a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <!-- Figure out how to get LCDGT labels from linked data service -->
                        <xsl:if test="demographicTerm">
                            <h2>Demographic(s)</h2>
                            <ul>
                                <xsl:for-each select="demographicTerm">
                                    <xsl:variable name="lcdgt_uri" select="@uri"/>
                                    <xsl:variable name="lcdgt" select="document(concat($lcdgt_uri, '.rdf'))"/>
                                    <xsl:variable name="lcdgt_id" select="substring-after($lcdgt_uri, 'http://id.loc.gov/authorities/demographicTerms/')"/>
                                    <li><a href="{$lcdgt_id}.html"><xsl:value-of select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about=$lcdgt_uri]/madsrdf:authoritativeLabel"/></a></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="sources">
                            <h2>Sources</h2>
                            <ul>
                                <xsl:for-each select="sources/source">
                                    <xsl:variable name="source_uri" select="@uri"/>
                                    <li><a href="{$source_uri}"><xsl:value-of select="$source_uri"/></a></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="@agentType='family'">
                            <xsl:variable name="family_name" select="@id"/>
                            <ul>
                                <xsl:for-each select="//agent[family/@relatedAgent=$family_name]">
                                    <xsl:variable name="agent_id" select="@id"/>
                                    <li><a href="{$agent_id}.html"><xsl:value-of select="preferredName"/></a></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
        <xsl:for-each-group
            select="//demographicTerm[@uri]"
            group-by="@uri">
            <xsl:variable name="lcdgt_uri" select="@uri"/>
            <xsl:variable name="lcdgt" select="document(concat($lcdgt_uri, '.rdf'))"/>
            <xsl:variable name="lcdgt_label" select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about=$lcdgt_uri]/madsrdf:authoritativeLabel"/>
            <xsl:variable name="lcdgt_id" select="substring-after($lcdgt_uri, 'http://id.loc.gov/authorities/demographicTerms/')"/>
            <xsl:result-document href="{$lcdgt_id}.html">
                <head>
                    <title><xsl:value-of select="$lcdgt_label"/></title>
                </head>
                <body>
                    <h1><xsl:value-of select="$lcdgt_label"/></h1>
                    <ul>
                        <xsl:for-each select="//agent[demographicTerm/@uri=$lcdgt_uri]">
                            <li><a href="{@id}.html"><xsl:value-of select="preferredName"/></a></li>
                        </xsl:for-each> 
                    </ul>
                </body>
            </xsl:result-document>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>