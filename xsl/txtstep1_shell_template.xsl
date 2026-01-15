<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs">

  <xsl:import href="plugin:org.dita.troff:xsl/step1.xsl"/>
  <xsl:import href="plugin:org.dita.text:xsl/step1-titlenum.xsl"/>
  <!-- Toolkit does not support tables. Use this override to make use of the cals2ascii program. -->
  <xsl:import href="plugin:org.dita.troff:xsl/step1-task.xsl"/>
  <!-- Override in step1-task prevents optional/required from coming out bold -->
  <xsl:import href="plugin:org.dita.text:xsl/step1-task.xsl"/>
  <xsl:import href="plugin:org.dita.troff:xsl/step1-hi-d.xsl"/>
  <xsl:import href="plugin:org.dita.troff:xsl/step1-pr-d.xsl"/>
  <!-- Toolkit does not syntax diagrams Use this override to make use of idsyngen. -->
  <xsl:import href="plugin:org.dita.text:xsl/step1-pr-d.xsl"/>
  <xsl:import href="plugin:org.dita.troff:xsl/step1-sw-d.xsl"/>
  <xsl:import href="plugin:org.dita.troff:xsl/step1-ui-d.xsl"/>
  <xsl:import href="plugin:org.dita.text:xsl/step1-ui-d.xsl"/>
  <xsl:import href="plugin:org.dita.troff:xsl/step1-ut-d.xsl"/>
  <xsl:import href="plugin:org.dita.troff:xsl/step1-xml-d.xsl"/>

  <dita:extension id="dita.xsl.text.ast" behavior="org.dita.dost.platform.ImportXSLAction" xmlns:dita="http://dita-ot.sourceforge.net"/>

  <xsl:param name="WORKDIR">
    <xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
  </xsl:param>
  <xsl:param name="FILEREF" select="'file:/'"/>
  <xsl:param name="PATH2PROJ"/>
  <xsl:param name="DEFAULTLANG" select="'en-us'"/>
  <xsl:param name="DITAEXT" select="'.dita'"/>
  <xsl:param name="override-linelength" select="'65'"/>
  <xsl:param name="LINELENGTH" select="xs:integer($override-linelength)" as="xs:integer"/>

<xsl:variable name="msgprefix">IDXS</xsl:variable>

  <xsl:output method="xml" encoding="utf-8"/>

  <!-- Overrule common rule for TM processing to ensure <text> wrapper -->
  <xsl:template match="*[contains(@class,' topic/tm ')]">
    <text><xsl:apply-templates select="." mode="process-trademark"/></text>
  </xsl:template>

</xsl:stylesheet>
