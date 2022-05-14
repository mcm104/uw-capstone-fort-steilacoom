<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs madsrdf rdf"
    version="2.0">
    <xsl:template match="/">
        <xsl:call-template name="naf_nav"/>
        <xsl:call-template name="person_list"/>
        <xsl:call-template name="family_list"/>
        <xsl:call-template name="corporate_body_list"/>
        <xsl:call-template name="demographic_list"/>
    </xsl:template>
    <xsl:template name="naf_nav">
        <xsl:result-document href="naf_nav.html">
            <!-- Trigger/Open The Modal -->
            <button id="myBtn">Index</button>
            
            <!-- The Modal -->
            <div id="myModal" class="modal">
                <link href="stylesheet.css" rel="stylesheet"/>
                <!-- Modal content -->
                <div class="modal-content">
                    <span class="close">&#215;</span>
                    <div class="naf-sidebar" style="background-color: #F8F6F2; border-style: solid; border-color: #D5552B; border-width: 1px; padding: 20px; margin: 5px">
                        <h2>People, Families, and Corporate Bodies</h2>
                        <h3>People</h3>
                        <ul>
                            <xsl:for-each select="/nameAuthorityFile/agents/agent[@agentType='person']">
                                <xsl:sort select="preferredName"/>
                                <xsl:variable name="agent_id" select="@id"/>
                                <li><a href="{$agent_id}.html"><xsl:value-of select="preferredName"/></a></li>
                            </xsl:for-each>
                        </ul>
                        <h3>Families</h3>
                        <ul>
                            <xsl:for-each select="/nameAuthorityFile/agents/agent[@agentType='family']">
                                <xsl:sort select="preferredName"/>
                                <xsl:variable name="agent_id" select="@id"/>
                                <li><a href="{$agent_id}.html"><xsl:value-of select="preferredName"/></a></li>
                            </xsl:for-each>
                        </ul>
                        <h3>Corporate Bodies</h3>
                        <ul>
                            <xsl:for-each select="/nameAuthorityFile/agents/agent[@agentType='corporate body']">
                                <xsl:sort select="preferredName"/>
                                <xsl:variable name="agent_id" select="@id"/>
                                <li><a href="{$agent_id}.html"><xsl:value-of select="preferredName"/></a></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript" src="modal.js">&amp;#160;</script>
            </div>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="person_list">
        <xsl:for-each select="/nameAuthorityFile/agents/agent[@agentType='person']">
            <xsl:variable name="agent_id" select="@id"/>
            <xsl:result-document href="{$agent_id}.html">
                <html>
                    <head>
                        <title><xsl:value-of select="preferredName"/></title>
                    </head>
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
                        <xsl:if test="family">
                            <xsl:variable name="family_id" select="family/@relatedAgent"/>
                            <p>Member of <a href="{$family_id}.html"><xsl:value-of select="//agent[@id=$family_id]/preferredName"/></a> family</p>
                        </xsl:if>
                        <xsl:if test="tribalAffiliation">
                            <xsl:variable name="tribe_label" select="tribalAffiliation"/>
                            <xsl:choose>
                                <xsl:when test="//agent[preferredName=$tribe_label or alternateName=$tribe_label]">
                                    <xsl:variable name="tribe_id" select="//agent[preferredName=$tribe_label or alternateName=$tribe_label]/@id"/>
                                    <p>Member of <a href="{$tribe_id}.html"><xsl:value-of select="$tribe_label"/></a></p>
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>Member of <xsl:value-of select="$tribe_label"/></p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="biographicalInfo">
                            <h2>Biography</h2>
                            <p><xsl:value-of select="biographicalInfo"/></p>
                        </xsl:if>
                        <xsl:if test="dateOfBirth">
                            <h2>Date of birth</h2>
                            <p><xsl:value-of select="dateOfBirth/*"/></p>
                        </xsl:if>
                        <xsl:if test="dateOfDeath">
                            <h2>Date of death</h2>
                            <p><xsl:value-of select="dateOfDeath/*"/></p>
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
                                                <p>Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> in <xsl:value-of select="year"/></p>
                                            </xsl:when>
                                            <xsl:when test="yearMonth">
                                                <p>Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> in <xsl:value-of select="yearMonth"/></p>
                                            </xsl:when>
                                            <xsl:when test="date">
                                                <p>Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> on <xsl:value-of select="date"/></p>
                                            </xsl:when>
                                            <xsl:when test="approximateDate">
                                                <p>Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a> c. <xsl:value-of select="approximateDate"/></p>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <p>Married to <a href="{$spouse_id}.html"><xsl:value-of select="$spouse/preferredName"/></a></p>
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
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="family_list">
        <xsl:for-each select="/nameAuthorityFile/agents/agent[@agentType='family']">
            <xsl:variable name="agent_id" select="@id"/>
            <xsl:result-document href="{$agent_id}.html">
                <html>
                    <head>
                        <title><xsl:value-of select="preferredName"/></title>
                    </head>
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
                        <h2>Family member(s)</h2>
                        <xsl:variable name="family_name" select="@id"/>
                        <ul>
                            <xsl:for-each select="//agent[family/@relatedAgent=$family_name]">
                                <xsl:variable name="agent_id" select="@id"/>
                                <li><a href="{$agent_id}.html"><xsl:value-of select="preferredName"/></a></li>
                            </xsl:for-each>
                        </ul>
                        <xsl:if test="biographicalInfo">
                            <h2>Biography</h2>
                            <p><xsl:value-of select="biographicalInfo"/></p>
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
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="corporate_body_list">
        <xsl:for-each select="/nameAuthorityFile/agents/agent[@agentType='corporate family']">
            <xsl:variable name="agent_id" select="@id"/>
            <xsl:result-document href="{$agent_id}.html">
                <html>
                    <head>
                        <title><xsl:value-of select="preferredName"/></title>
                    </head>
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
                        <xsl:if test="biographicalInfo">
                            <h2>Biography</h2>
                            <p><xsl:value-of select="biographicalInfo"/></p>
                        </xsl:if>
                        <xsl:if test="startDate">
                            <h2>Start date</h2>
                            <xsl:value-of select="startDate/*"/>
                        </xsl:if>
                        <xsl:if test="endDate">
                            <h2>End date</h2>
                            <xsl:value-of select="endDate/*"/>
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
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="demographic_list">
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