<?xml version="1.0" encoding="UTF-8"?>
<!--

	check_mdui.xsl
	
	Checking ruleset containing rules associated with the SAML V2.0 Metadata
	Extensions for Login and Discovery User Interface Version 1.0, see:

		http://wiki.oasis-open.org/security/SAML2MetadataUI
		
	This ruleset reflects WD08, 17-Jul-2011.
	
	Author: Ian A. Young <ian@iay.org.uk>

-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
	xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
	xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui"
	xmlns:set="http://exslt.org/sets"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="urn:oasis:names:tc:SAML:2.0:metadata">

	<!--
		Common support functions.
	-->
	<xsl:import href="check_framework.xsl"/>
	
	<!--
		Section 2.1
		
		<mdui:UIInfo> MUST NOT appear more than once within a given <md:Extensions> element.
	-->
	<xsl:template match="md:Extensions/mdui:UIInfo[position()>1]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">more than one UIInfo element in one Extensions element</xsl:with-param>
		</xsl:call-template>		
	</xsl:template>
	
	<!--
		Section 2.1, 2.2
		
		Restrict the elements in this namespace which can appear directly within md:Extensions
		to the two defined container elements.  This will catch mis-spelled containers.
	-->
	<xsl:template match="md:Extensions/mdui:*
		[not(local-name()='UIInfo')][not(local-name()='DiscoHints')]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">
				<xsl:text>misspelled or misplaced mdui element within md:Extensions: </xsl:text>
				<xsl:value-of select="local-name()"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!--
		Section 2.1.1
		
		The <mdui:UIInfo> container element [...] MUST appear within the
		<md:Extensions> element of a role element (one whose type is based on
		md:RoleDescriptorType).
		
		[The rule here further restricts the location to within either IDPSSODescriptor or
		SPSSODescriptor elements, which are the ones we'll actually make use of.]
	-->
	<xsl:template match="mdui:UIInfo[not(parent::md:Extensions)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">UIInfo appearing outside Extensions element</xsl:with-param>
		</xsl:call-template>        
	</xsl:template>
	<xsl:template match="md:Extensions[mdui:UIInfo]
		[not(parent::md:IDPSSODescriptor)][not(parent::md:SPSSODescriptor)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">UIInfo appearing outside role descriptor element</xsl:with-param>
		</xsl:call-template>        
	</xsl:template>

	<!--
		Constraints across multiple elements within the container.
		
		DisplayName, Description, InformationURL and PrivacyStatementURL elements
		are all required to have unique xml:lang values within their element type.
	-->
	<xsl:template match="mdui:UIInfo">
		<!-- unique xml:lang over DisplayName elements -->
		<xsl:call-template name="uniqueLang">
			<xsl:with-param name="e" select="mdui:DisplayName"/>
		</xsl:call-template>
		
		<!-- unique xml:lang over Description elements -->
		<xsl:call-template name="uniqueLang">
			<xsl:with-param name="e" select="mdui:Description"/>
		</xsl:call-template>
		
		<!-- unique xml:lang over Keywords elements -->
		<xsl:call-template name="uniqueLang">
			<xsl:with-param name="e" select="mdui:Keywords"/>
		</xsl:call-template>
		
		<!-- unique xml:lang over InformationURL elements -->
		<xsl:call-template name="uniqueLang">
			<xsl:with-param name="e" select="mdui:InformationURL"/>
		</xsl:call-template>
		
		<!-- unique xml:lang over PrivacyStatementURL elements -->
		<xsl:call-template name="uniqueLang">
			<xsl:with-param name="e" select="mdui:PrivacyStatementURL"/>
		</xsl:call-template>
		
		<!-- handle individual elements -->
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template name="uniqueLang">
		<xsl:param name="e"/>
		<xsl:variable name="l" select="$e/@xml:lang"></xsl:variable>
		<xsl:variable name="u" select="set:distinct($l)"/>
		<xsl:if test="count($l) != count($u)">
			<xsl:call-template name="error">
				<xsl:with-param name="m">
					<xsl:text>non-unique lang values on </xsl:text>
					<xsl:value-of select="name($e)"/>
					<xsl:text> elements</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<!--
		Section 2.1.5 Element <mdui:Logo>
	-->
	<xsl:template match="mdui:Logo">
		<!--
			Require that the URL starts with https://
			
			This is a SHOULD in the specification; we treat it as a MUST here.
		-->
		<xsl:if test="not(starts-with(., 'https://'))">
			<xsl:call-template name="error">
				<xsl:with-param name="m">mdui:Logo URL does not start with https://</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!--
		Section 2.2
		
		The <mdui:DiscoHints> container element [...] MUST appear within the
		<md:Extensions> element of an <md:IDPSSODescriptor> element.
	-->
	<xsl:template match="mdui:DiscoHints[not(parent::md:Extensions)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">DiscoHints appearing outside Extensions element</xsl:with-param>
		</xsl:call-template>        
	</xsl:template>
	<xsl:template match="md:Extensions[mdui:DiscoHints][not(parent::md:IDPSSODescriptor)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">DiscoHints appearing outside IDPSSODescriptor element</xsl:with-param>
		</xsl:call-template>        
	</xsl:template>
	
	<!--
		Section 2.2
		
		<mdui:DiscoHints> MUST NOT appear more than once within a given <md:Extensions> element.
	-->
	<xsl:template match="md:Extensions/mdui:DiscoHints[position()>1]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">more than one DiscoHints element in one Extensions element</xsl:with-param>
		</xsl:call-template>        
	</xsl:template>
	
</xsl:stylesheet>
