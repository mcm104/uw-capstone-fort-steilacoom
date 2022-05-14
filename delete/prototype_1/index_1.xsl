<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xsl:call-template name="sidebar"/>
        <xsl:call-template name="create_index_pages"/>
    </xsl:template>
    <xsl:template name="sidebar">
        <xsl:result-document href="index_sidebar.html">
            <div class="naf-sidebar"
                style="height: 480px; float: right; background-color: #F8F6F2; border-style: solid; border-color: #D5552B; border-width: 1px; width: 15%; padding: 20px; margin: 5px">
                <h2>Index</h2>
                <ul id="index">
                    <xsl:for-each select="//term[not(parentTerm)]">
                        <xsl:sort select="preferredTerm"/>
                        <link href="sidebar.css" rel="stylesheet"/>
                        <xsl:variable name="term_id" select="@id"/>
                        <xsl:call-template name="list_child_terms">
                            <xsl:with-param name="parent_term" select="preferredTerm"/>
                            <xsl:with-param name="parent_id" select="$term_id"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </ul>
            </div>
            <script type="text/javascript" src="sidebar.js">
&amp;#160;</script>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="list_child_terms">
        <xsl:param name="parent_term"/>
        <xsl:param name="parent_id"/>
        <xsl:choose>
            <xsl:when test="//term/parentTerm/@term_id = $parent_id">
                <li>
                    <span class="caret">
                        <a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a>
                    </span>
                    <ul class="nested">
                        <xsl:for-each select="//term[parentTerm/@term_id = $parent_id]">
                            <xsl:variable name="child_term" select="preferredTerm"/>
                            <xsl:variable name="child_id" select="@id"/>
                            <xsl:call-template name="list_child_terms">
                                <xsl:with-param name="parent_term" select="$child_term"/>
                                <xsl:with-param name="parent_id" select="$child_id"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </ul>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <li>
                    <a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create_index_pages">
        <xsl:for-each select="//term">
            <xsl:variable name="term_id" select="@id"/>
            <xsl:result-document href="{$term_id}.html">
                <html>
                    <head>
                        <title><xsl:value-of select="preferredTerm"/></title>
                    </head>
                    <body>
                        <a href="index_sidebar.html">Return to index</a>
                        <xsl:call-template name="breadcrumbs">
                            <xsl:with-param name="current_id" select="@id"/>
                            <xsl:with-param name="current_term" select="preferredTerm"/>
                        </xsl:call-template>
                        <h1><xsl:value-of select="preferredTerm"/></h1>
                        <xsl:if test="alternateTerm">
                            <h2>Alternate term(s)</h2>
                            <ul>
                                <xsl:for-each select="alternateTerm">
                                    <xsl:sort select="."/>
                                    <li><xsl:value-of select="."/></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="relatedTerm">
                            <h2>Related term(s)</h2>
                            <ul>
                                <xsl:for-each select="relatedTerm">
                                    <xsl:sort select="."/>
                                    <xsl:variable name="related_id" select="@term_id"/>
                                    <li><a href="{$related_id}.html"><xsl:value-of select="."/></a></li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="definition">
                            <h2>Definition</h2>
                            <p><xsl:value-of select="definition"/></p>
                        </xsl:if>
                        <xsl:variable name="newsletter_xml" select="document('../newsletter_table.xml')"/>
                        <xsl:variable name="current_term" select="preferredTerm"/>
                        <xsl:if test="$newsletter_xml/newsletters/newsletter/keywords/keyword=$current_term">
                            <h2>Newsletters on this topic</h2>
                            <ul>
                                <xsl:for-each select="$newsletter_xml/newsletters/newsletter[keywords/keyword=$current_term]">
                                    <xsl:variable name="newsletter_url" select="link"/>
                                    <li><a href="{$newsletter_url}"><xsl:value-of select="title"/></a> (<xsl:value-of select="date"/>)</li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                        <xsl:if test="sources">
                            <h2>Source(s)</h2>
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
    <xsl:template name="breadcrumbs">
        <xsl:param name="current_id"/>
        <xsl:param name="current_term"/>
        <xsl:choose>
            <!-- Tiers 2-6 -->
            <xsl:when test="//term[@id=$current_id and parentTerm]">
                <xsl:variable name="parent_id" select="//term[@id=$current_id]/parentTerm/@term_id"/>
                <xsl:variable name="parent_term" select="//term[@id=$parent_id]/preferredTerm"/>
                <xsl:choose>
                    <!-- Tiers 3-6 -->
                    <xsl:when test="//term[@id=$parent_id and parentTerm]">
                        <xsl:variable name="parent_id_1" select="//term[@id=$parent_id]/parentTerm/@term_id"/>
                        <xsl:variable name="parent_term_1" select="//term[@id=$parent_id_1]/preferredTerm"/>
                        <xsl:choose>
                            <!-- Tiers 4-6 -->
                            <xsl:when test="//term[@id=$parent_id_1 and parentTerm]">
                                <xsl:variable name="parent_id_2" select="//term[@id=$parent_id_1]/parentTerm/@term_id"/>
                                <xsl:variable name="parent_term_2" select="//term[@id=$parent_id_2]/preferredTerm"/>
                                <xsl:choose>
                                    <!-- Tiers 5-6 -->
                                    <xsl:when test="//term[@id=$parent_id_2 and parentTerm]">
                                        <xsl:variable name="parent_id_3" select="//term[@id=$parent_id_2]/parentTerm/@term_id"/>
                                        <xsl:variable name="parent_term_3" select="//term[@id=$parent_id_3]/preferredTerm"/>
                                        <xsl:choose>
                                            <!-- Tier 6 -->
                                            <xsl:when test="//term[@id=$parent_id_3 and parentTerm]">
                                                <xsl:variable name="parent_id_4" select="//term[@id=$parent_id_3]/parentTerm/@term_id"/>
                                                <xsl:variable name="parent_term_4" select="//term[@id=$parent_id_4]/preferredTerm"/>
                                                <div class="breadcrumbs">
                                                    <p><a href="{$parent_id_4}.html"><xsl:value-of select="$parent_term_4"/></a> > <a href="{$parent_id_3}.html"><xsl:value-of select="$parent_term_3"/></a> > <a href="{$parent_id_2}.html"><xsl:value-of select="$parent_term_2"/></a> > <a href="{$parent_id_1}.html"><xsl:value-of select="$parent_term_1"/></a> > <a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a> > <b><xsl:value-of select="$current_term"/></b></p>
                                                </div>
                                            </xsl:when>
                                            <!-- Tier 5 -->
                                            <xsl:otherwise>
                                                <div class="breadcrumbs">
                                                    <p><a href="{$parent_id_3}.html"><xsl:value-of select="$parent_term_3"/></a> > <a href="{$parent_id_2}.html"><xsl:value-of select="$parent_term_2"/></a> > <a href="{$parent_id_1}.html"><xsl:value-of select="$parent_term_1"/></a> > <a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a> > <b><xsl:value-of select="$current_term"/></b></p>
                                                </div>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <!-- Tier 4 -->
                                    <xsl:otherwise>
                                        <div class="breadcrumbs">
                                            <p><a href="{$parent_id_2}.html"><xsl:value-of select="$parent_term_2"/></a> > <a href="{$parent_id_1}.html"><xsl:value-of select="$parent_term_1"/></a> > <a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a> > <b><xsl:value-of select="$current_term"/></b></p>
                                        </div>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- Tier 3 -->
                            <xsl:otherwise>
                                <div class="breadcrumbs">
                                    <p><a href="{$parent_id_1}.html"><xsl:value-of select="$parent_term_1"/></a> > <a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a> > <b><xsl:value-of select="$current_term"/></b></p>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Tier 2 -->
                    <xsl:otherwise>
                        <div class="breadcrumbs">
                            <p><a href="{$parent_id}.html"><xsl:value-of select="$parent_term"/></a> > <b><xsl:value-of select="$current_term"/></b></p>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- Tier 1 -->
            <xsl:otherwise>
                <div class="breadcrumbs">
                    <p><b><xsl:value-of select="$current_term"/></b></p>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
