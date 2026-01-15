<?xml version="1.0" encoding="UTF-8" ?>
<!--gcw replace corrupt filee-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

    <xsl:param name="titleformat" select="'default'" as="xs:string"/>
    <xsl:param name="contents" select="'none'" as="xs:string"/>
    <xsl:param name="coverinfo" select="'none'" as="xs:string"/>
    <xsl:param name="inputfile" select="''" as="xs:string"/>

    <xsl:key name="titlegroup" match="*[contains(@class,' topic/topic ')]" use="@id"/>
    <xsl:template match="*[contains(@class,' topic/xref ')]">
        <xsl:if
            test="$titleformat='number' and
            (empty(@scope) or @scope='local') and (empty(@format) or @format='dita') and
            starts-with(@href,'#') and
            processing-instruction()[name()='ditaot'][.='gentext']">
            <xsl:variable name="searchid" select="substring-after(@href,'#')"/>
            <xsl:if test="exists(key('titlegroup',$searchid))">
                <text>
                    <xsl:apply-templates
                        select="key('titlegroup',$searchid)[1]/*[contains(@class,' topic/title ')]"
                        mode="add-title-number"/>
                    <xsl:text> </xsl:text>
                </text>
            </xsl:if>
        </xsl:if>
        <xsl:next-match/>
    </xsl:template>

    <xsl:template match="linktext">
        <xsl:if
            test="$titleformat='number' and ../processing-instruction()[name()='ditaot'][.='gentext'] and
            (empty(../@scope) or ../@scope='local') and (empty(../@format) or ../@format='dita') and
            starts-with(../@href,'#')">
            <xsl:variable name="searchid" select="substring-after(../@href,'#')"/>
            <xsl:if test="exists(key('titlegroup',$searchid))">
                <text>
                    <xsl:apply-templates
                        select="key('titlegroup',$searchid)[1]/*[contains(@class,' topic/title ')]"
                        mode="add-title-number"/>
                    <xsl:text> </xsl:text>
                </text>
            </xsl:if>
        </xsl:if>
        <xsl:next-match/>
    </xsl:template>

    <!-- Add title number to topic titles -->
    <xsl:template match="*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
        <xsl:variable name="firsttopic"
            select="not(parent::*/parent::*[contains(@class,' topic/topic ')]) and 
            not(parent::*/preceding-sibling::*[contains(@class,' topic/topic ')])"
            as="xs:boolean"/>

        <xsl:if test="$coverinfo='add' and $firsttopic and not(empty(document($inputfile)))">
            <xsl:apply-templates select="document($inputfile)/*" mode="cover"/>
        </xsl:if>

        <xsl:if test="$contents='toc' and $firsttopic">
            <xsl:call-template name="generate-text-toc"/>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$titleformat='number'">
                <block position="center">
                    <xsl:call-template name="commonatts"/>
                    <text style="bold">
                        <xsl:call-template name="commonatts"/>
                        <xsl:apply-templates select="." mode="add-title-number"/>
                        <xsl:apply-templates/>
                    </text>
                </block>
                <xsl:apply-templates select="." mode="check-for-prereq"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/title ')]" mode="add-title-number">
        <xsl:apply-templates select="parent::*" mode="add-title-number"/>
        <xsl:if test="not(parent::*/parent::*[contains(@class,' topic/topic ')])">
            <xsl:text>.0</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="add-title-number">
        <xsl:if test="parent::*[contains(@class,' topic/topic ')]">
            <xsl:apply-templates select="parent::*" mode="add-title-number"/>
            <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:value-of select="count(preceding-sibling::*[contains(@class,' topic/topic ')]|.)"/>
    </xsl:template>

    <xsl:template name="generate-text-toc">
        <block>
            <block position="center" compact="yes">
                <text style="bold">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Table of Contents'"/>
                    </xsl:call-template>
                </text>
            </block>
            <xsl:for-each
                select="//*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
                <block>
                    <xsl:if test="position()!=1">
                        <xsl:attribute name="compact" select="'yes'"/>
                    </xsl:if>
                    <xsl:if test="ancestor::*[contains(@class,' topic/topic ')][2]">
                        <xsl:attribute name="indent">
                            <xsl:value-of
                                select="2 * count(parent::*/ancestor::*[contains(@class,' topic/topic ')])"
                            />
                        </xsl:attribute>
                    </xsl:if>
                    <text>
                        <xsl:if test="$titleformat='number'">
                            <xsl:apply-templates select="." mode="add-title-number"/>
                        </xsl:if>
                        <xsl:apply-templates/>
                    </text>
                </block>
            </xsl:for-each>
        </block>
    </xsl:template>

    <!-- Needed until this shows up in OT: https://github.com/dita-ot/org.dita.troff/pull/3 -->
    <xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]">
        <xsl:variable name="fignum"
            select="count(preceding::*[contains(@class,' topic/fig ')][*[contains(@class,' topic/title ')]]) + 1"
            as="xs:integer"/>
        <block>
            <xsl:call-template name="commonatts"/>
            <text style="bold">
                <xsl:call-template name="getVariable"><xsl:with-param name="id" select="'Figure'"
                    /></xsl:call-template>
                <xsl:text> </xsl:text><xsl:value-of select="$fignum"/>. <xsl:text/>
                <xsl:apply-templates/>
            </text>
        </block>
    </xsl:template>

    <xsl:template match="/*" mode="cover">
        <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="cover"/>
        <xsl:apply-templates
            select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/prodinfo ')][1]/
            *[contains(@class,' topic/vrmlist ')][1]"
            mode="cover"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/title ')]" mode="cover">
        <block position="center">
            <xsl:apply-templates/>
        </block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/vrmlist ')]" mode="cover">
        <xsl:apply-templates select="*[contains(@class,' topic/vrm ')][1]" mode="book-vrm-as-text"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/vrm ')]" mode="book-vrm-as-text">
        <block>
            <text>
                <xsl:choose>
                    <!-- Anything other than a space, digit, period, comma, or hyphen means
                   the attribute already has some sort of "Version" text -->
                    <xsl:when test="matches(@version,'^(\s|\d|\.|,|-)+$')">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Version'"/>
                        </xsl:call-template>
                        <xsl:sequence select="concat(' ',@version)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@version"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@release">
                    <xsl:text> </xsl:text>
                    <xsl:choose>
                        <xsl:when test="matches(@release,'^(\s|\d|\.|,|-)+$')">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Release'"/>
                            </xsl:call-template>
                            <xsl:sequence select="concat(' ',@release)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@release"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </text>
        </block>
    </xsl:template>

</xsl:stylesheet>
