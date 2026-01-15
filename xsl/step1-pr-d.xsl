<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                >

<xsl:template match="*[contains(@class,' pr-d/codeph ')]">
  <text style="tt"><xsl:call-template name="debug"/><xsl:apply-templates/></text>
</xsl:template>

<xsl:template match="*[contains(@class,' pr-d/parmname ')]">
  <xsl:choose>
    <xsl:when test="@importance='default'">
      <text style="bold"><text style="underlined"><xsl:call-template name="debug"/><xsl:apply-templates/></text></text>
    </xsl:when>
    <xsl:otherwise>
      <text style="bold"><xsl:call-template name="debug"/><xsl:apply-templates/></text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class,' pr-d/var ')]">
  <text style="italic"><xsl:call-template name="debug"/><xsl:apply-templates/></text>
</xsl:template>

<xsl:template match="*[contains(@class,' pr-d/kwd ')]">
  <xsl:choose>
    <xsl:when test="@importance='default'">
      <text style="bold"><text style="underlined"><xsl:call-template name="debug"/><xsl:apply-templates/></text></text>
    </xsl:when>
    <xsl:otherwise>
      <text style="bold"><xsl:call-template name="debug"/><xsl:apply-templates/></text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
