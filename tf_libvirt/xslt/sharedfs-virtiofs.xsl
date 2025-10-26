<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="yes"/>

  <!-- copy the whole xml doc to start with -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- add <memoryBacking> element to <domain> element  -->
  <xsl:template match="/domain">
    <xsl:copy>
      <!-- apply other templates on the copy -->
      <xsl:apply-templates select="@*|*"/>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>destroy</on_crash>
      <pm>
        <suspend-to-mem enabled="no"/>
        <suspend-to-disk enabled="no"/>
      </pm>

    <!-- Needed for FS Sharing with Host/Guest 
        <memoryBacking>
        <source type="memfd"/>
        <access mode="shared"/>
      </memoryBacking> -->
    </xsl:copy>
  </xsl:template>


  <!-- Needed for FS Sharing with Host/Guest -->
  <!-- <xsl:template match="/domain/devices/filesystem[@accessmode='passthrough']">
    <xsl:copy>
      <xsl:apply-templates select="@*|*"/>
      <driver type="virtiofs" />
    </xsl:copy>
  </xsl:template> -->
  
  <xsl:template match="/domain/cpu">
    <cpu mode="host-passthrough" check="none" migratable="on"/>
  </xsl:template>

  <xsl:template match="/domain/os">
    <os>
      <type arch="x86_64" machine="pc-q35-rhel9.6.0">hvm</type>
    </os>
  </xsl:template>

  <xsl:template match="/domain/features">
    <features>
      <acpi/>
      <apic/>
    </features>
  </xsl:template>

   <xsl:template match="/domain/devices/disk[@device='cdrom']/target">
      <target dev="sda" bus="sata"/>
  </xsl:template>

 <xsl:template match="/domain/clock">
    <clock offset="utc">
        <timer name="rtc" tickpolicy="catchup"/>
        <timer name="pit" tickpolicy="delay"/>
        <timer name="hpet" present="no"/>
      </clock>
  </xsl:template>
  
 </xsl:stylesheet>
