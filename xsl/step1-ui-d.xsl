<?xml version="1.0"?>
<!-- Fixes the xml:space declaration for screen output -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"/>

<xsl:template match="*[contains(@class, ' ui-d/screen ')]">
  <block>
    <xsl:attribute name="xml:space" select="'preserve'"/>
    <xsl:call-template name="commonatts"/>
    <xsl:apply-templates/>
  </block>
</xsl:template>

</xsl:stylesheet>
