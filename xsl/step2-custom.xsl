<?xml version="1.0"?>
<!-- Fixes the xml:space declaration for screen output -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"/>
  
  <xsl:template match="block[@custom='msgtext']">
    <xsl:variable name="msgid-length" select="string-length(preceding-sibling::text[@custom='msgid'])"/>
    <xsl:variable name="indent" select="if (@indent) then @indent else 0"/>
    <!-- Known to have a single <text> child; we don't want any newlines or lead in here, but
      use the block to wrap with 6 char indent -->

    <xsl:apply-templates select="." mode="find-indent"/>
    
    <xsl:for-each select="text">
      <xsl:variable name="upToBlock">
        <xsl:call-template name="format-text"/>
      </xsl:variable>
    
      <!-- Process the message text, with the msgtxt leadin, but count the message length and indent in the first line. -->
      <xsl:call-template name="wrap">
        <xsl:with-param name="curLength" select="$msgid-length + $indent"/>
        <xsl:with-param name="string" select="normalize-space($upToBlock)"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
