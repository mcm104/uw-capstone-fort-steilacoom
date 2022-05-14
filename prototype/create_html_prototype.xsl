<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="xs madsrdf rdf"
    version="2.0">
    <xsl:template match="/">
        <xsl:variable name="index_xml" select="document('../index.xml')"/>
        <xsl:variable name="naf_xml" select="document('../naf.xml')"/>
        <xsl:call-template name="one_page_navigation">
            <xsl:with-param name="index_xml" select="$index_xml"/>
            <xsl:with-param name="naf_xml" select="$naf_xml"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="one_page_navigation">
        <xsl:param name="index_xml"/>
        <xsl:param name="naf_xml"/>
        <xsl:result-document href="prototype.html">
            <div class="page"
                style="width: 100%; max-width: 1000px; margin: 0 auto; border: 1px solid gray; overflow:hidden; background-color: white;">
                <div class="navigation"
                    style="float: left; height: 480px; background-color: #F8F6F2; border-style: solid; border-color: #D5552B; border-width: 1px; padding: 20px; margin: 2px; height: auto; width: 25%">
                    <link href="prototype.css" rel="stylesheet"/>
                    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Mate+SC"/>
                    <h1>Browse...</h1>
                    <!-- List people -->
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">People</span>
                                <ul class="nested">
                                    <xsl:for-each
                                        select="$naf_xml/nameAuthorityFile/agents/agent[@agentType = 'person']">
                                        <xsl:sort select="preferredName"/>
                                        <xsl:variable name="newsletter_xml"
                                            select="document('../newsletter_table.xml')"/>
                                        <xsl:variable name="person_preferred_name"
                                            select="preferredName"/>
                                        <xsl:variable name="person_id" select="@id"/>
                                        <li>
                                            <a href="#{$person_id}">
                                                <xsl:value-of select="$person_preferred_name"/>
                                            </a> (<xsl:value-of
                                                select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $person_preferred_name])"
                                            />) </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </ul>
                    </div>

                    <!-- List families -->
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">Families</span>
                                <ul class="nested">
                                    <xsl:for-each
                                        select="$naf_xml/nameAuthorityFile/agents/agent[@agentType = 'family']">
                                        <xsl:sort select="preferredName"/>
                                        <xsl:variable name="newsletter_xml"
                                            select="document('../newsletter_table.xml')"/>
                                        <xsl:variable name="family_preferred_name"
                                            select="preferredName"/>
                                        <xsl:variable name="family_id" select="@id"/>
                                        <li>
                                            <a href="#{$family_id}">
                                                <xsl:value-of select="$family_preferred_name"/>
                                            </a> (<xsl:value-of
                                                select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $family_preferred_name])"
                                            />) </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </ul>
                    </div>

                    <!-- List corporations -->
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">Corporations</span>
                                <ul class="nested">
                                    <xsl:for-each
                                        select="$naf_xml/nameAuthorityFile/agents/agent[@agentType = 'corporation']">
                                        <xsl:sort select="preferredName"/>
                                        <xsl:variable name="newsletter_xml"
                                            select="document('../newsletter_table.xml')"/>
                                        <xsl:variable name="corporation_preferred_name"
                                            select="preferredName"/>
                                        <xsl:variable name="corporation_id" select="@id"/>
                                        <li>
                                            <a href="#{$corporation_id}">
                                                <xsl:value-of select="$corporation_preferred_name"/>
                                            </a> (<xsl:value-of
                                                select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $corporation_preferred_name])"
                                            />) </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </ul>
                    </div>

                    <!-- List topics -->
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">Topics</span>
                                <ul class="nested">
                                    <xsl:for-each
                                        select="$index_xml/newsletterIndex/terms/term[not(parentTerm)]">
                                        <xsl:sort select="preferredTerm"/>
                                        <xsl:variable name="newsletter_xml"
                                            select="document('../newsletter_table.xml')"/>
                                        <xsl:variable name="parent_term" select="preferredTerm"/>
                                        <xsl:variable name="parent_id" select="@id"/>
                                        <xsl:call-template name="list_child_terms">
                                            <xsl:with-param name="parent_term" select="$parent_term"/>
                                            <xsl:with-param name="parent_id" select="$parent_id"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </ul>
                    </div>

                    <!-- List demographics -->
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">Demographics</span>
                                <ul class="nested">
                                    <xsl:for-each-group
                                        select="$naf_xml/nameAuthorityFile/agents/agent/demographicTerm[@uri]"
                                        group-by="@uri">
                                        <xsl:variable name="lcdgt_uri" select="@uri"/>
                                        <xsl:variable name="lcdgt"
                                            select="document(concat($lcdgt_uri, '.rdf'))"/>
                                        <xsl:variable name="lcdgt_label"
                                            select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about = $lcdgt_uri]/madsrdf:authoritativeLabel"/>
                                        <li>
                                            <span class="caret">
                                                <xsl:value-of select="$lcdgt_label"/> (<xsl:value-of
                                                  select="count($naf_xml/nameAuthorityFile/agents/agent/demographicTerm[@uri = $lcdgt_uri])"
                                                />) </span>
                                            <ul class="nested">
                                                <xsl:for-each
                                                  select="$naf_xml/nameAuthorityFile/agents/agent[demographicTerm/@uri = $lcdgt_uri]">
                                                  <xsl:sort select="preferredName"/>
                                                  <xsl:variable name="agent_name"
                                                  select="preferredName"/>
                                                  <xsl:variable name="agent_id" select="@id"/>
                                                  <xsl:variable name="newsletter_xml"
                                                  select="document('../newsletter_table.xml')"/>
                                                  <xsl:variable name="num_of_newsletters"
                                                  select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $agent_name]"/>
                                                  <li>
                                                  <a href="#{$agent_id}">
                                                  <xsl:value-of select="$agent_name"/>
                                                  </a> (<xsl:value-of
                                                  select="count($num_of_newsletters)"/>) </li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                    </xsl:for-each-group>
                                </ul>
                            </li>
                        </ul>
                        <script type="text/javascript" src="prototype.js">
&amp;#160;</script>
                    </div>
                    <script type="text/javascript" src="prototype.js">
&amp;#160;</script>
                </div>
                <div class="index_entries"
                    style="float: right; height: 480px; background-color: #F8F6F2; border-style: solid; border-color: #D5552B; border-width: 1px; padding: 20px; margin: 2px; height: auto; width: 65%">
                    <xsl:call-template name="create_index_entries"/>
                </div>
                <script type="text/javascript" src="prototype.js">
&amp;#160;</script>
            </div>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="list_child_terms">
        <xsl:param name="parent_term"/>
        <xsl:param name="parent_id"/>
        <xsl:variable name="index_xml" select="document('../index.xml')"/>
        <xsl:variable name="newsletter_xml" select="document('../newsletter_table.xml')"/>
        <xsl:choose>
            <xsl:when test="$index_xml/newsletterIndex/terms/term/parentTerm/@term_id = $parent_id">
                <li>
                    <xsl:choose>
                        <xsl:when test="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_term])!=0">
                            <span class="caret">
                                <a href="#{$parent_id}">
                                    <xsl:value-of select="$parent_term"/>
                                </a> (<xsl:value-of
                                    select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_term])"
                                />) </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="caret">
                                <a href="#{$parent_id}">
                                    <xsl:value-of select="$parent_term"/>
                                </a></span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <ul class="nested">
                        <xsl:for-each
                            select="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id = $parent_id]">
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
                    <a href="#{$parent_id}">
                        <xsl:value-of select="$parent_term"/>
                    </a> (<xsl:value-of
                        select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_term])"
                    />) </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="create_index_entries">
        <xsl:variable name="newsletter_xml" select="document('../newsletter_table.xml')"/>

        <!-- Agents -->
        <xsl:variable name="naf_xml" select="document('../naf.xml')"/>
        <!-- Persons -->
        <xsl:for-each select="$naf_xml/nameAuthorityFile/agents/agent[@agentType = 'person']">
            <xsl:sort select="preferredName"/>
            <xsl:variable name="preferred_name" select="preferredName"/>
            <xsl:variable name="agent_id" select="@id"/>
            <div class="entry">
                <br/>
                <h1 id="{$agent_id}">
                    <xsl:value-of select="preferredName"/>
                </h1>
                <!-- Dates of birth, death, and/or marriage -->
                <xsl:if
                    test="dateOfBirth[not(unknown/@value = True)] or dateOfDeath[not(unknown/@value = True)] or dateOfMarriage[not(unknown/@value = True)]">
                    <xsl:choose>
                        <!-- Birth date, no death date -->
                        <xsl:when
                            test="dateOfBirth[not(unknown/@value = True)] and not(dateOfDeath or dateOfDeath/unknown/@value = True)">
                            <xsl:choose>
                                <!-- Approximate date -->
                                <xsl:when test="dateOfBirth/approximateDate">
                                    <p>
                                        <i>Born c. <xsl:value-of
                                                select="dateOfBirth/approximateDate"/></i>
                                    </p>
                                </xsl:when>

                                <!-- year, yearMonth, or date -->
                                <xsl:otherwise>
                                    <p>
                                        <i>Born <xsl:value-of select="dateOfBirth/*"/></i>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <!-- Birth date and death date -->
                        <xsl:when
                            test="dateOfBirth[not(unknown/@value = True)] and dateOfDeath[not(unknown/@value = True)]">
                            <xsl:choose>
                                <!-- Approximate birth -->
                                <xsl:when
                                    test="dateOfBirth/approximateDate and dateOfDeath[not(approximateDate)]">
                                    <p>
                                        <i>c. <xsl:value-of select="dateOfBirth/approximateDate"/> –
                                                <xsl:value-of select="dateOfDeath/*"/></i>
                                    </p>
                                </xsl:when>

                                <!-- Approximate death -->
                                <xsl:when
                                    test="dateOfBirth[not(approximateDate)] and dateOfDeath/approximateDate">
                                    <p>
                                        <i><xsl:value-of select="dateOfBirth/*"/> – c. <xsl:value-of
                                                select="dateOfDeath/approximateDate"/></i>
                                    </p>
                                </xsl:when>

                                <!-- Both approximate -->
                                <xsl:when
                                    test="dateOfBirth/approximateDate and dateOfDeath/approximateDate">
                                    <p>
                                        <i>c. <xsl:value-of select="dateOfBirth/approximateDate"
                                            />-c. <xsl:value-of select="dateOfDeath/approximateDate"
                                            /></i>
                                    </p>
                                </xsl:when>

                                <!-- Neither approximate -->
                                <xsl:otherwise>
                                    <p>
                                        <i><xsl:value-of select="dateOfBirth/*"/> – <xsl:value-of
                                                select="dateOfDeath/*"/></i>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <!-- Death date, no birth date -->
                        <xsl:when
                            test="dateOfDeath[not(unknown/@value = True)] and not(dateOfBirth or dateOfBirth/unknown/@value = True)">
                            <xsl:choose>
                                <!-- Approximate date -->
                                <xsl:when test="dateOfDeath/approximateDate">
                                    <p>
                                        <i>Died c. <xsl:value-of
                                                select="dateOfDeath/approximateDate"/></i>
                                    </p>
                                </xsl:when>

                                <!-- year, yearMonth, or date -->
                                <xsl:otherwise>
                                    <p>
                                        <i>Died <xsl:value-of select="dateOfDeath/*"/></i>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <!-- No birth date, no death date, yes married date -->
                        <xsl:when
                            test="dateOfMarriage[not(unknown/@value = True)] and not(dateOfBirth or dateOfBirth/unknown/@value = True) and dateOfDeath or dateOfDeath/unknown/@value = True">
                            <xsl:choose>
                                <!-- Approximate marriage date -->
                                <xsl:when test="dateOfMarriage/approximateDate">
                                    <p>
                                        <i>Married c. <xsl:value-of
                                                select="dateOfMarriage/approximateDate"/></i>
                                    </p>
                                </xsl:when>

                                <!-- year, yearMonth, or date -->
                                <xsl:otherwise>
                                    <p>
                                        <i>Married <xsl:value-of select="dateOfMarriage/*"/></i>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="family">
                    <xsl:variable name="family_id" select="family/@relatedAgent"/>
                    <p>Member of <a href="#{$family_id}"><xsl:value-of
                                select="$naf_xml/nameAuthorityFile/agents/agent[@id = $family_id]/preferredName"
                            /></a> family</p>
                </xsl:if>
                <xsl:if test="tribalAffiliation">
                    <p>Member of <xsl:value-of select="tribalAffiliation"/></p>
                </xsl:if>
                <xsl:if test="alternateName">
                    <h2>Alternate name(s)</h2>
                    <ul>
                        <xsl:for-each select="alternateName">
                            <xsl:sort select="."/>
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="biographicalInfo">
                    <h2>Biographical Information</h2>
                    <p>
                        <xsl:value-of select="biographicalInfo"/>
                    </p>
                </xsl:if>
                <xsl:if test="hasParent">
                    <h2>Parent(s)</h2>
                    <ul>
                        <xsl:for-each select="hasParent">
                            <xsl:variable name="parent_id" select="@relatedAgent"/>
                            <xsl:variable name="parent_name"
                                select="$naf_xml/nameAuthorityFile/agents/agent[@id = $parent_id]/preferredName"/>
                            <li>
                                <a href="#{$parent_id}">
                                    <xsl:value-of select="$parent_name"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="hasSpouse">
                    <h2>Spouse(s)</h2>
                    <xsl:choose>
                        <!-- Agents who have more than one spouse -->
                        <xsl:when test="count(hasSpouse) > 1">
                            <ul>
                                <xsl:for-each select="hasSpouse">
                                    <xsl:variable name="spouse_id" select="@relatedAgent"/>
                                    <xsl:variable name="spouse_name"
                                        select="$naf_xml/nameAuthorityFile/agents/agent[@id = $spouse_id]/preferredName"/>
                                    <xsl:choose>
                                        <!-- Spouses with approximate marriage dates -->
                                        <xsl:when
                                            test="../dateOfMarriage[approximateDate]/@relatedAgent = $spouse_id">
                                            <li><a href="#{$spouse_id}"><xsl:value-of
                                                  select="$spouse_name"/></a> (m. c. <xsl:value-of
                                                  select="../dateOfMarriage[@relatedAgent = $spouse_id]/*"
                                                />)</li>
                                        </xsl:when>

                                        <!-- Spouses with year/yearMonth/date marriage dates -->
                                        <xsl:when
                                            test="../dateOfMarriage[not(unknown/@value = True)]/@relatedAgent = $spouse_id">
                                            <li><a href="#{$spouse_id}"><xsl:value-of
                                                  select="$spouse_name"/></a> (m. <xsl:value-of
                                                  select="../dateOfMarriage[@relatedAgent = $spouse_id]/*"
                                                />)</li>
                                        </xsl:when>

                                        <!-- Spouses with no marriage dates -->
                                        <xsl:otherwise>
                                            <li>
                                                <a href="#{$spouse_id}">
                                                  <xsl:value-of select="$spouse_name"/>
                                                </a>
                                            </li>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </ul>
                        </xsl:when>
                        <!-- Agents who only have one spouse -->
                        <xsl:otherwise>
                            <xsl:variable name="spouse_id" select="hasSpouse/@relatedAgent"/>
                            <xsl:variable name="spouse_name"
                                select="$naf_xml/nameAuthorityFile/agents/agent[@id = $spouse_id]/preferredName"/>
                            <xsl:choose>
                                <!-- Spouses with approximate marriage dates -->
                                <xsl:when
                                    test="../dateOfMarriage[approximateDate]/@relatedAgent = $spouse_id">
                                    <p><a href="#{$spouse_id}"><xsl:value-of select="$spouse_name"
                                            /></a> (m. c. <xsl:value-of
                                            select="../dateOfMarriage[@relatedAgent = $spouse_id]/*"
                                        />)</p>
                                </xsl:when>

                                <!-- Spouses with year/yearMonth/date marriage dates -->
                                <xsl:when
                                    test="../dateOfMarriage[not(unknown/@value = True)]/@relatedAgent = $spouse_id">
                                    <p><a href="#{$spouse_id}"><xsl:value-of select="$spouse_name"
                                            /></a> (m. <xsl:value-of
                                            select="../dateOfMarriage[@relatedAgent = $spouse_id]/*"
                                        />)</p>
                                </xsl:when>

                                <!-- Spouses with no marriage dates -->
                                <xsl:otherwise>
                                    <p>
                                        <a href="#{$spouse_id}">
                                            <xsl:value-of select="$spouse_name"/>
                                        </a>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <h2>Newsletters</h2>
                <div>
                    <xsl:call-template name="featured_newsletters">
                        <xsl:with-param name="current_term" select="$preferred_name"/>
                        <xsl:with-param name="term_type" select="'person'"/>
                    </xsl:call-template>
                </div>
                <xsl:if test="demographicTerm">
                    <h2>Demographic(s)</h2>
                    <ul>
                        <xsl:for-each select="demographicTerm">
                            <xsl:variable name="lcdgt_uri" select="@uri"/>
                            <xsl:variable name="lcdgt" select="document(concat($lcdgt_uri, '.rdf'))"/>
                            <xsl:variable name="lcdgt_id"
                                select="substring-after($lcdgt_uri, 'http://id.loc.gov/authorities/demographicTerms/')"/>
                            <li>
                                <xsl:value-of
                                    select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about = $lcdgt_uri]/madsrdf:authoritativeLabel"
                                />
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <a href="#top">Return to top</a>
                <br/>
                <br/>
                <br/>
                <hr/>
            </div>
        </xsl:for-each>

        <!-- Families -->
        <xsl:for-each select="$naf_xml/nameAuthorityFile/agents/agent[@agentType = 'family']">
            <xsl:sort select="preferredName"/>
            <xsl:variable name="preferred_name" select="preferredName"/>
            <xsl:variable name="agent_id" select="@id"/>
            <div class="entry">
                <br/>
                <h1 id="{$agent_id}">
                    <xsl:value-of select="preferredName"/>
                </h1>
                <xsl:if test="alternateName">
                    <h2>Alternate name(s)</h2>
                    <ul>
                        <xsl:for-each select="alternateName">
                            <xsl:sort select="."/>
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="biographicalInfo">
                    <h2>Biographical Information</h2>
                    <p>
                        <xsl:value-of select="biographicalInfo"/>
                    </p>
                </xsl:if>
                <xsl:if
                    test="$naf_xml/nameAuthorityFile/agents/agent/family/@relatedAgent = $agent_id">
                    <h2>Members of <xsl:value-of select="$preferred_name"/> Family</h2>
                    <ul>
                        <xsl:for-each
                            select="$naf_xml/nameAuthorityFile/agents/agent[family/@relatedAgent = $agent_id]">
                            <xsl:variable name="fam_member_name" select="preferredName"/>
                            <xsl:variable name="fam_member_id" select="@id"/>
                            <li>
                                <a href="#{$fam_member_id}">
                                    <xsl:value-of select="$fam_member_name"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <h2>Newsletters</h2>
                <div>
                    <xsl:call-template name="featured_newsletters">
                        <xsl:with-param name="current_term" select="$preferred_name"/>
                        <xsl:with-param name="term_type" select="'person'"/>
                    </xsl:call-template>
                </div>
                <xsl:if test="demographicTerm">
                    <h2>Demographic(s)</h2>
                    <ul>
                        <xsl:for-each select="demographicTerm">
                            <xsl:variable name="lcdgt_uri" select="@uri"/>
                            <xsl:variable name="lcdgt" select="document(concat($lcdgt_uri, '.rdf'))"/>
                            <xsl:variable name="lcdgt_id"
                                select="substring-after($lcdgt_uri, 'http://id.loc.gov/authorities/demographicTerms/')"/>
                            <li>
                                <xsl:value-of
                                    select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about = $lcdgt_uri]/madsrdf:authoritativeLabel"
                                />
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <a href="#top">Return to top</a>
                <br/>
                <br/>
                <br/>
                <hr/>
            </div>
        </xsl:for-each>

        <!-- Corporations -->
        <xsl:for-each select="$naf_xml/nameAuthorityFile/agents/agent[@agentType = 'corporation']">
            <xsl:sort select="preferredName"/>
            <xsl:variable name="preferred_name" select="preferredName"/>
            <xsl:variable name="agent_id" select="@id"/>
            <div class="entry">
                <br/>
                <h1 id="{$agent_id}">
                    <xsl:value-of select="preferredName"/>
                </h1>
                <xsl:choose>
                    <!-- Start date, no end date -->
                    <xsl:when test="startDate[not(unknown/@value = True)] and not(endDate)">
                        <xsl:choose>
                            <!-- Approximate date -->
                            <xsl:when test="startDate/approximateDate">
                                <p>Started c. <xsl:value-of select="startDate/approximateDate"/></p>
                            </xsl:when>
                            <!-- Exact date -->
                            <xsl:otherwise>
                                <p>Started <xsl:value-of select="startDate/*"/></p>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- End date, no start date -->
                    <xsl:when test="endDate[not(unknown/@value = True)] and not(startDate)">
                        <xsl:choose>
                            <!-- Approximate date -->
                            <xsl:when test="endDate/approximateDate">
                                <p>Started c. <xsl:value-of select="endDate/approximateDate"/></p>
                            </xsl:when>
                            <!-- Exact date -->
                            <xsl:otherwise>
                                <p>Started <xsl:value-of select="endDate/*"/></p>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- Both dates -->
                    <xsl:when
                        test="startDate[not(unknown/@value = True)] and endDate[not(unknown/@value = True)]">
                        <xsl:choose>
                            <!-- Both approximate -->
                            <xsl:when test="startDate/approximateDate and endDate/approximateDate">
                                <p>Started c. <xsl:value-of select="startDate/approximateDate"/>;
                                    ended c. <xsl:value-of select="endDate/approximateDate"/></p>
                            </xsl:when>
                            <!-- Start date approximate, end date exact -->
                            <xsl:when
                                test="startDate/approximateDate and not(endDate/approximateDate)">
                                <p>Started c. <xsl:value-of select="startDate/approximateDate"/>;
                                    ended <xsl:value-of select="endDate/*"/></p>
                            </xsl:when>
                            <!-- End date approximate, start date exact -->
                            <xsl:when
                                test="endDate/approximateDate and not(startDate/approximateDate)">
                                <p>Started <xsl:value-of select="startDate/*"/>; ended c.
                                        <xsl:value-of select="endDate/approximateDate"/></p>
                            </xsl:when>
                            <!-- Both exact -->
                            <xsl:otherwise>
                                <p>Started <xsl:value-of select="startDate/*"/>; ended <xsl:value-of
                                        select="endDate/*"/></p>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="alternateName">
                    <h2>Alternate name(s)</h2>
                    <ul>
                        <xsl:for-each select="alternateName">
                            <xsl:sort select="."/>
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="biographicalInfo">
                    <h2>Biographical Information</h2>
                    <p>
                        <xsl:value-of select="biographicalInfo"/>
                    </p>
                </xsl:if>
                <xsl:variable name="newsletter_xml" select="document('../newsletter_table.xml')"/>
                <h2>Newsletters</h2>
                <div>
                    <xsl:call-template name="featured_newsletters">
                        <xsl:with-param name="current_term" select="$preferred_name"/>
                        <xsl:with-param name="term_type" select="'corporation'"/>
                    </xsl:call-template>
                </div>
                <a href="#top">Return to top</a>
                <br/>
                <br/>
                <br/>
                <hr/>
            </div>
        </xsl:for-each>

        <!-- Topics -->
        <xsl:variable name="index_xml" select="document('../index.xml')"/>
        <xsl:for-each select="$index_xml/newsletterIndex/terms/term">
            <xsl:variable name="preferred_term" select="preferredTerm"/>
            <xsl:variable name="term_id" select="@id"/>
            <div class="entry">
                <br/>
                <h1 id="{$term_id}">
                    <xsl:value-of select="preferredTerm"/>
                </h1>
                <xsl:if test="alternateTerm">
                    <h2>Alternate term(s)</h2>
                    <ul>
                        <xsl:for-each select="alternateTerm">
                            <xsl:sort select="."/>
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="relatedTerm">
                    <h2>Related term(s)</h2>
                    <ul>
                        <xsl:for-each select="relatedTerm">
                            <xsl:sort select="."/>
                            <xsl:variable name="related_id" select="@term_id"/>
                            <li>
                                <a href="{$related_id}.html">
                                    <xsl:value-of select="."/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <xsl:if test="definition">
                    <h2>Definition</h2>
                    <p>
                        <xsl:value-of select="definition"/>
                    </p>
                </xsl:if>
                <xsl:variable name="newsletter_xml" select="document('../newsletter_table.xml')"/>
                <xsl:variable name="current_term" select="preferredTerm"/>
                <h2>Newsletters</h2>
                <div>
                    <xsl:call-template name="featured_newsletters">
                        <xsl:with-param name="current_term" select="$current_term"/>
                        <xsl:with-param name="term_type" select="'topic'"/>
                    </xsl:call-template>
                </div>
                <xsl:if test="sources">
                    <h2>Source(s)</h2>
                    <ul>
                        <xsl:for-each select="sources/source">
                            <xsl:variable name="source_uri" select="@uri"/>
                            <li>
                                <a href="{$source_uri}">
                                    <xsl:value-of select="$source_uri"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
                <a href="#top">Return to top</a>
                <br/>
                <br/>
                <br/>
                <hr/>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="featured_newsletters">
        <xsl:param name="current_term"/>
        <xsl:param name="term_type"/>
        <xsl:variable name="newsletter_xml" select="document('../newsletter_table.xml')"/>
        <!-- Start list -->
        <div>
            <xsl:choose>
                <xsl:when
                    test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $current_term">
                    <ul id="index">
                        <!-- Newsletters directly about subject -->
                        <li>
                            <span class="caret">Newsletters about <xsl:value-of
                                    select="$current_term"/></span>
                            <ul class="nested">
                                <xsl:for-each
                                    select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $current_term]">
                                    <xsl:variable name="newsletter_url" select="link"/>
                                    <li><a href="{$newsletter_url}"><xsl:value-of select="title"
                                            /></a> (<xsl:value-of select="date"/>)</li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </ul>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                        <i>There are currently no newsletters about <xsl:value-of
                                select="$current_term"/>.</i>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <!-- Additional options if subject is a person -->
        <xsl:if test="$term_type = 'person'">
            <!-- Additional options if subject is a member of a family -->
            <xsl:variable name="naf_xml" select="document('../naf.xml')"/>
            <xsl:if
                test="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/family">
                <xsl:variable name="family_id"
                    select="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/family/@relatedAgent"/>
                <xsl:variable name="family_name"
                    select="$naf_xml/nameAuthorityFile/agents/agent[@id = $family_id]/preferredName"/>
                <!-- Additional options if there are newsletters about other members of subject's family -->
                <xsl:if
                    test="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)]/family/@relatedAgent = $family_id">
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">Newsletters featuring other members of the
                                        <xsl:value-of select="$family_name"/> family</span>
                                <ul class="nested">
                                    <xsl:for-each
                                        select="$naf_xml/nameAuthorityFile/agents/agent[family/@relatedAgent = $family_id][not(preferredName = $current_term)]">
                                        <xsl:variable name="family_member_preferred_name"
                                            select="preferredName"/>
                                        <xsl:variable name="family_member_id" select="@id"/>
                                        <li>
                                            <span class="caret">
                                                <a href="#{$family_member_id}">
                                                  <i>
                                                  <xsl:value-of
                                                  select="$family_member_preferred_name"/>
                                                  </i>
                                                </a>
                                            </span>
                                            <ul class="nested">
                                                <xsl:for-each
                                                  select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $family_member_preferred_name]">
                                                  <xsl:variable name="newsletter_title"
                                                  select="title"/>
                                                  <xsl:variable name="newsletter_link" select="link"/>
                                                  <xsl:variable name="newsletter_date" select="date"/>
                                                  <li><a href="{$newsletter_link}"><xsl:value-of
                                                  select="$newsletter_title"/></a> (<xsl:value-of
                                                  select="$newsletter_date"/>)</li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </xsl:if>
                <!-- Additional options of there are newsletters about the subject's family -->
                <xsl:if
                    test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $family_name">
                    <div>
                        <ul id="index">
                            <li>
                                <span class="caret">Newsletters about the <xsl:value-of
                                        select="$family_name"/> family</span>
                                <ul class="nested">
                                    <xsl:for-each
                                        select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $family_name]">
                                        <xsl:variable name="newsletter_title" select="title"/>
                                        <xsl:variable name="newsletter_link" select="link"/>
                                        <xsl:variable name="newsletter_date" select="date"/>
                                        <li>
                                            <a href="{$newsletter_link}">
                                                <xsl:value-of select="$newsletter_title"/>
                                            </a> (<xsl:value-of select="$newsletter_date"/>) </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </xsl:if>
            </xsl:if>
            <!-- Additional options if subject has a demographic term -->
            <xsl:variable name="demographic_uri"
                select="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/demographicTerm/@uri"/>
            <xsl:if
                test="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)]/demographicTerm/@uri = $demographic_uri">
                <div>
                    <ul id="index">
                        <!-- Newsletters about other subjects with the same demographic term(s) -->
                        <li>
                            <span class="caret">Newsletters about subjects from similar
                                demographics</span>
                            <ul class="nested">
                                <xsl:for-each
                                    select="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/demographicTerm[@uri]">
                                    <xsl:variable name="demographic_uri" select="@uri"/>
                                    <xsl:if
                                        test="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)]/demographicTerm/@uri = $demographic_uri">
                                        <xsl:variable name="lcdgt"
                                            select="document(concat($demographic_uri, '.rdf'))"/>
                                        <li>
                                            <span class="caret">
                                                <i>
                                                  <xsl:value-of
                                                  select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about = $demographic_uri]/madsrdf:authoritativeLabel"
                                                  />
                                                </i>
                                            </span>
                                            <ul class="nested">
                                                <xsl:for-each
                                                  select="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)][demographicTerm/@uri = $demographic_uri]">
                                                  <xsl:variable name="same_demo_agent_name"
                                                  select="preferredName"/>
                                                  <xsl:variable name="same_demo_agent_id"
                                                  select="@id"/>
                                                  <li>
                                                  <a href="#{$same_demo_agent_id}">
                                                  <xsl:value-of select="$same_demo_agent_name"/>
                                                  </a>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </ul>
                </div>
            </xsl:if>
        </xsl:if>

        <!-- Additional options if subject is a family -->
        <xsl:if test="$term_type = 'family'">
            <xsl:variable name="naf_xml" select="document('../naf.xml')"/>
            <xsl:variable name="family_id"
                select="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/@id"/>
            <!-- Additional options if there are newsletters about other members of subject's family -->
            <xsl:if test="$naf_xml/nameAuthorityFile/agents/agent/family/@relatedAgent = $family_id">
                <div>
                    <ul id="index">
                        <li>
                            <span class="caret">Newsletters featuring members of the <xsl:value-of
                                    select="$current_term"/> family</span>
                            <ul class="nested">
                                <xsl:for-each
                                    select="$naf_xml/nameAuthorityFile/agents/agent[family/@relatedAgent = $family_id]">
                                    <xsl:variable name="family_member_preferred_name"
                                        select="preferredName"/>
                                    <xsl:variable name="family_member_id" select="@id"/>
                                    <li>
                                        <span class="caret">
                                            <a href="#{$family_member_id}">
                                                <i>
                                                  <xsl:value-of
                                                  select="$family_member_preferred_name"/>
                                                </i>
                                            </a>
                                        </span>
                                        <ul class="nested">
                                            <xsl:for-each
                                                select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $family_member_preferred_name]">
                                                <xsl:variable name="newsletter_title" select="title"/>
                                                <xsl:variable name="newsletter_link" select="link"/>
                                                <xsl:variable name="newsletter_date" select="date"/>
                                                <li><a href="{$newsletter_link}"><xsl:value-of
                                                  select="$newsletter_title"/></a> (<xsl:value-of
                                                  select="$newsletter_date"/>)</li>
                                            </xsl:for-each>
                                        </ul>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </ul>
                </div>
            </xsl:if>

            <!-- Additional options if subject has a demographic term -->
            <xsl:variable name="demographic_uri"
                select="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/demographicTerm/@uri"/>
            <xsl:if
                test="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)]/demographicTerm/@uri = $demographic_uri">
                <div>
                    <ul id="index">
                        <!-- Newsletters about other subjects with the same demographic term(s) -->
                        <li>
                            <span class="caret">Subjects from similar demographics</span>
                            <ul class="nested">
                                <xsl:for-each
                                    select="$naf_xml/nameAuthorityFile/agents/agent[preferredName = $current_term]/demographicTerm[@uri]">
                                    <xsl:variable name="demographic_uri" select="@uri"/>
                                    <xsl:if
                                        test="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)]/demographicTerm/@uri = $demographic_uri">
                                        <xsl:variable name="lcdgt"
                                            select="document(concat($demographic_uri, '.rdf'))"/>
                                        <li>
                                            <span class="caret">
                                                <i>
                                                  <xsl:value-of
                                                  select="$lcdgt/rdf:RDF/madsrdf:Authority[@rdf:about = $demographic_uri]/madsrdf:authoritativeLabel"
                                                  />
                                                </i>
                                            </span>
                                            <ul class="nested">
                                                <xsl:for-each
                                                  select="$naf_xml/nameAuthorityFile/agents/agent[not(preferredName = $current_term)][demographicTerm/@uri = $demographic_uri]">
                                                  <xsl:variable name="same_demo_agent_name"
                                                  select="preferredName"/>
                                                  <xsl:variable name="same_demo_agent_id"
                                                  select="@id"/>
                                                  <li>
                                                  <a href="#{$same_demo_agent_id}">
                                                  <xsl:value-of select="$same_demo_agent_name"/>
                                                  </a>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </ul>
                </div>
            </xsl:if>
        </xsl:if>

        <!-- Additional options if subject is a topic -->
        <xsl:if test="$term_type = 'topic'">
            <!-- For subjects with broader terms... -->
            <xsl:variable name="index_xml" select="document('../index.xml')"/>
            <!-- Current term is Tier 6 or higher -->
            <!-- Parent of tier 6+ (tier 5 or higher) -->
            <xsl:variable name="parent_id_1"
                select="$index_xml/newsletterIndex/terms/term[preferredTerm = $current_term]/parentTerm/@term_id"/>
            <xsl:variable name="parent_name_1"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_1]/preferredTerm"/>
            <!-- Parent of tier 5+ (tier 4 or higher) -->
            <xsl:variable name="parent_id_2"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_1]/parentTerm/@term_id"/>
            <xsl:variable name="parent_name_2"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_2]/preferredTerm"/>
            <!-- Parent of tier 4+ (tier 3 or higher) -->
            <xsl:variable name="parent_id_3"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_2]/parentTerm/@term_id"/>
            <xsl:variable name="parent_name_3"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_3]/preferredTerm"/>
            <!-- Parent of tier 3+ (tier 2 or higher) -->
            <xsl:variable name="parent_id_4"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_3]/parentTerm/@term_id"/>
            <xsl:variable name="parent_name_4"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_4]/preferredTerm"/>
            <!-- Parent of tier 2 (tier 1) -->
            <xsl:variable name="parent_id_5"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_4]/parentTerm/@term_id"/>
            <xsl:variable name="parent_name_5"
                select="$index_xml/newsletterIndex/terms/term[@id = $parent_id_5]/preferredTerm"/>

            <xsl:if
                test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_1 or $newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_2 or $newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_3 or $newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_4 or $newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_5">
                <div>
                    <ul id="index">
                        <li><span class="caret">Newsletters about broader terms</span>
                        <ul class="nested">
                            <!-- Parent of tier 6+ (tier 5 or higher) -->
                            <xsl:if
                                test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_1">
                                <li>
                                    <span class="caret">
                                        <i><a href="#{$parent_id_1}"><xsl:value-of select="$parent_name_1"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_1])"/>)</i>
                                    </span>
                                    <ul class="nested">
                                        <xsl:for-each
                                            select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_1]">
                                            <xsl:variable name="newsletter_title" select="title"/>
                                            <xsl:variable name="newsletter_link" select="link"/>
                                            <xsl:variable name="newsletter_date" select="date"/>
                                            <li><a href="{$newsletter_link}"><xsl:value-of
                                                select="$newsletter_title"/></a> (<xsl:value-of
                                                    select="$newsletter_date"/>)</li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>
                            
                            <!-- Parent of tier 5+ (tier 4 or higher) -->
                            <xsl:if
                                test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_2">
                                <li>
                                    <span class="caret">
                                        <i><a href="#{$parent_id_2}"><xsl:value-of select="$parent_name_2"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_2])"/>)</i>
                                    </span>
                                    <ul class="nested">
                                        <xsl:for-each
                                            select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_2]">
                                            <xsl:variable name="newsletter_title" select="title"/>
                                            <xsl:variable name="newsletter_link" select="link"/>
                                            <xsl:variable name="newsletter_date" select="date"/>
                                            <li><a href="{$newsletter_link}"><xsl:value-of
                                                select="$newsletter_title"/></a> (<xsl:value-of
                                                    select="$newsletter_date"/>)</li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>
                            
                            <!-- Parent of tier 4+ (tier 3 or higher) -->
                            <xsl:if
                                test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_3">
                                <li>
                                    <span class="caret">
                                        <i><a href="#{$parent_id_3}"><xsl:value-of select="$parent_name_3"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_3])"/>)</i>
                                    </span>
                                    <ul class="nested">
                                        <xsl:for-each
                                            select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_3]">
                                            <xsl:variable name="newsletter_title" select="title"/>
                                            <xsl:variable name="newsletter_link" select="link"/>
                                            <xsl:variable name="newsletter_date" select="date"/>
                                            <li><a href="{$newsletter_link}"><xsl:value-of
                                                select="$newsletter_title"/></a> (<xsl:value-of
                                                    select="$newsletter_date"/>)</li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>
                            
                            <!-- Parent of tier 3+ (tier 2 or higher) -->
                            <xsl:if
                                test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_4">
                                <li>
                                    <span class="caret">
                                        <i><a href="#{$parent_id_4}"><xsl:value-of select="$parent_name_4"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_4])"/>)</i>
                                    </span>
                                    <ul class="nested">
                                        <xsl:for-each
                                            select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_4]">
                                            <xsl:variable name="newsletter_title" select="title"/>
                                            <xsl:variable name="newsletter_link" select="link"/>
                                            <xsl:variable name="newsletter_date" select="date"/>
                                            <li><a href="{$newsletter_link}"><xsl:value-of
                                                select="$newsletter_title"/></a> (<xsl:value-of
                                                    select="$newsletter_date"/>)</li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>
                            
                            <!-- Parent of tier 2 (tier 1) -->
                            <xsl:if
                                test="$newsletter_xml/newsletters/newsletter/keywords/keyword = $parent_name_5">
                                <li>
                                    <span class="caret">
                                        <i><a href="#{$parent_id_5}"><xsl:value-of select="$parent_name_5"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_5])"/>)</i>
                                    </span>
                                    <ul class="nested">
                                        <xsl:for-each
                                            select="$newsletter_xml/newsletters/newsletter[keywords/keyword = $parent_name_5]">
                                            <xsl:variable name="newsletter_title" select="title"/>
                                            <xsl:variable name="newsletter_link" select="link"/>
                                            <xsl:variable name="newsletter_date" select="date"/>
                                            <li><a href="{$newsletter_link}"><xsl:value-of
                                                select="$newsletter_title"/></a> (<xsl:value-of
                                                    select="$newsletter_date"/>)</li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </xsl:if>
                        </ul></li>
                    </ul>
                </div>
            </xsl:if>
        
            <!-- For subjects with narrower terms... -->
            <!-- The following variables may be lists if there are multiple children -->
            <xsl:variable name="index_xml" select="document('../index.xml')"/>
            <!-- Current term is Tier 1 or lower -->
            <xsl:variable name="current_id" select="$index_xml/newsletterIndex/terms/term[preferredTerm=$current_term]/@id"/>
            <xsl:if test="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$current_id]">
                <div>
                    <ul id="index">
                        <li><span class="caret">Newsletters about narrower terms</span>
                            <ul class="nested">
                                <!-- For each child term of current term (tier 1 or lower) -->
                                <xsl:for-each select="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$current_id]">
                                    <xsl:variable name="child_name_1" select="preferredTerm"/>
                                    <xsl:variable name="child_id_1" select="@id"/>
                                    <xsl:if test="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_1]">
                                        <li><span class="caret"><i><a href="#{$child_id_1}"><xsl:value-of select="$child_name_1"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_1])"/>)</i></span>
                                            <ul class="nested">
                                                <!-- For each newsletter about child term (tier 1 or lower) -->
                                                <xsl:for-each select="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_1]">
                                                    <xsl:variable name="newsletter_title" select="title"/>
                                                    <xsl:variable name="newsletter_link" select="link"/>
                                                    <xsl:variable name="newsletter_date" select="date"/>
                                                    <li><a href="{$newsletter_link}"><xsl:value-of
                                                        select="$newsletter_title"/></a> (<xsl:value-of
                                                            select="$newsletter_date"/>)</li>
                                                </xsl:for-each>

                                                <xsl:if test="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$child_id_1]">
                                                    <!-- For each child term of tier 1- (tier 2 or lower) -->
                                                    <xsl:for-each select="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$child_id_1]">
                                                        <xsl:variable name="child_name_2" select="preferredTerm"/>
                                                        <xsl:variable name="child_id_2" select="@id"/>
                                                        <xsl:if test="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_2]">
                                                            <li><span class="caret"><i><a href="#{$child_id_2}"><xsl:value-of select="$child_name_2"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_2])"/>)</i></span>
                                                                <ul class="nested">
                                                                    <!-- For each newsletter about child term (tier 2 or lower) -->
                                                                    <xsl:for-each select="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_2]">
                                                                        <xsl:variable name="newsletter_title" select="title"/>
                                                                        <xsl:variable name="newsletter_link" select="link"/>
                                                                        <xsl:variable name="newsletter_date" select="date"/>
                                                                        <li><a href="{$newsletter_link}"><xsl:value-of
                                                                            select="$newsletter_title"/></a> (<xsl:value-of
                                                                                select="$newsletter_date"/>)</li>
                                                                    </xsl:for-each>
                                                                    
                                                                    <!-- For each child term of tier 2- (tier 3 or lower) -->
                                                                    <xsl:for-each select="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$child_id_2]">
                                                                        <xsl:variable name="child_name_3" select="preferredTerm"/>
                                                                        <xsl:variable name="child_id_3" select="@id"/>
                                                                        <li><span class="caret"><i><a href="#{$child_id_3}"><xsl:value-of select="$child_name_3"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_3])"/>)</i></span>
                                                                            <ul class="nested">
                                                                                <!-- For each newsletter about child term (tier 3 or lower) -->
                                                                                <xsl:for-each select="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_3]">
                                                                                    <xsl:variable name="newsletter_title" select="title"/>
                                                                                    <xsl:variable name="newsletter_link" select="link"/>
                                                                                    <xsl:variable name="newsletter_date" select="date"/>
                                                                                    <li><a href="{$newsletter_link}"><xsl:value-of
                                                                                        select="$newsletter_title"/></a> (<xsl:value-of
                                                                                            select="$newsletter_date"/>)</li>
                                                                                </xsl:for-each>
                                                                                
                                                                                <!-- For each child term of tier 3- (tier 4 or lower) -->
                                                                                <xsl:for-each select="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$child_id_3]">
                                                                                    <xsl:variable name="child_name_4" select="preferredTerm"/>
                                                                                    <xsl:variable name="child_id_4" select="@id"/>
                                                                                    <li><span class="caret"><i><a href="#{$child_id_4}"><xsl:value-of select="$child_name_4"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_4])"/>)</i></span>
                                                                                        <ul class="nested">
                                                                                            <!-- For each newsletter about child term (tier 4 or lower) -->
                                                                                            <xsl:for-each select="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_4]">
                                                                                                <xsl:variable name="newsletter_title" select="title"/>
                                                                                                <xsl:variable name="newsletter_link" select="link"/>
                                                                                                <xsl:variable name="newsletter_date" select="date"/>
                                                                                                <li><a href="{$newsletter_link}"><xsl:value-of
                                                                                                    select="$newsletter_title"/></a> (<xsl:value-of
                                                                                                        select="$newsletter_date"/>)</li>
                                                                                            </xsl:for-each>
                                                                                            
                                                                                            <!-- For each child term of tier 4- (tier 5 or lower) -->
                                                                                            <xsl:for-each select="$index_xml/newsletterIndex/terms/term[parentTerm/@term_id=$child_id_4]">
                                                                                                <xsl:variable name="child_name_5" select="preferredTerm"/>
                                                                                                <xsl:variable name="child_id_5" select="@id"/>
                                                                                                <li><span class="caret"><i><a href="#{$child_id_5}"><xsl:value-of select="$child_name_5"/></a> (<xsl:value-of select="count($newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_5])"/>)</i></span>
                                                                                                    <ul class="nested">
                                                                                                        <!-- For each newsletter about child term (tier 5 or lower) -->
                                                                                                        <xsl:for-each select="$newsletter_xml/newsletters/newsletter[keywords/keyword=$child_name_5]">
                                                                                                            <xsl:variable name="newsletter_title" select="title"/>
                                                                                                            <xsl:variable name="newsletter_link" select="link"/>
                                                                                                            <xsl:variable name="newsletter_date" select="date"/>
                                                                                                            <li><a href="{$newsletter_link}"><xsl:value-of
                                                                                                                select="$newsletter_title"/></a> (<xsl:value-of
                                                                                                                    select="$newsletter_date"/>)</li>
                                                                                                        </xsl:for-each>
                                                                                                    </ul>
                                                                                                </li>
                                                                                            </xsl:for-each>
                                                                                        </ul>
                                                                                    </li>
                                                                                </xsl:for-each>
                                                                            </ul>
                                                                        </li>
                                                                    </xsl:for-each>
                                                                </ul>
                                                            </li>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </xsl:if>                                              
                                            </ul>
                                        </li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </ul>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
