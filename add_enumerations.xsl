<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:vc="http://www.w3.org/2007/XMLSchema-versioning" elementFormDefault="qualified"
            vc:minVersion="1.0" vc:maxVersion="1.1">
            
            <xs:element name="newsletters">
                <xs:complexType>
                    <xs:sequence>
                        <xs:element maxOccurs="unbounded" name="newsletter">
                            <xs:complexType>
                                <xs:sequence>
                                    <xs:element name="title"/>
                                    <xs:element maxOccurs="unbounded" name="author"/>
                                    <xs:element name="volume"/>
                                    <xs:element name="link" type="xs:anyURI"/>
                                    <xs:element name="date"/>
                                    <xs:element minOccurs="0" name="keywords">
                                        <xs:complexType>
                                            <xs:sequence>
                                                <xs:element maxOccurs="unbounded" name="keyword">
                                                    <xs:simpleType>
                                                        <xs:restriction base="xs:string">
                                                            <xsl:variable name="index_xml" select="document('index_xmlWORKING.xml')"/>
                                                            <xsl:variable name="naf_xml" select="document('naf_xmlWORKING.xml')"/>
                                                            <xsl:for-each select="$index_xml/newsletterIndex/terms/term">
                                                                <xsl:variable name="pref_term" select="preferredTerm"/>
                                                                <xs:enumeration value="{$pref_term}"/>
                                                            </xsl:for-each>
                                                            <xsl:for-each select="$naf_xml/nameAuthorityFile/agents/agent">
                                                                <xsl:variable name="pref_term" select="preferredName"/>
                                                                <xs:enumeration value="{$pref_term}"/>
                                                            </xsl:for-each>
                                                        </xs:restriction>
                                                    </xs:simpleType>
                                                </xs:element>
                                            </xs:sequence>
                                        </xs:complexType>
                                    </xs:element>
                                </xs:sequence>
                            </xs:complexType>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
        </xs:schema>
    </xsl:template>
</xsl:stylesheet>