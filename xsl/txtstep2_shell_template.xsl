<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >

  <xsl:import href="plugin:org.dita.troff:xsl/step2-base.xsl"/>
  <xsl:import href="plugin:org.dita.text:xsl/step2-custom.xsl"/>

  <dita:extension id="dita.xsl.text" behavior="org.dita.dost.platform.ImportXSLAction" xmlns:dita="http://dita-ot.sourceforge.net"/>

  <xsl:param name="override-linelength" select="'65'"/>
  <xsl:param name="LINELENGTH" select="number($override-linelength)"/>

  <xsl:output method="text"
              encoding="UTF-8"
              indent="no"
              omit-xml-declaration = "yes"
              />

</xsl:stylesheet>
