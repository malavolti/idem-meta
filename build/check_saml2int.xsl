<?xml version="1.0" encoding="UTF-8"?>
<!--

	check_saml2int.xsl
	
	Checking ruleset for the Interoperable SAML 2.0 Web Browser SSO Deployment Profile.
	
	See: http://saml2int.org/
	
	Author: Ian A. Young <ian@iay.org.uk>

-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
	xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
	xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
	xmlns:shibmd="urn:mace:shibboleth:metadata:1.0"
	xmlns:set="http://exslt.org/sets"
	xmlns:wayf="http://sdss.ac.uk/2006/06/WAYF"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:idpdisc="urn:oasis:names:tc:SAML:profiles:SSO:idp-discovery-protocol"

	xmlns:mdxURL="xalan://uk.ac.sdss.xalan.md.URLchecker"

	xmlns="urn:oasis:names:tc:SAML:2.0:metadata">

	<!--
		Common support functions.
	-->
	<xsl:import href="check_framework.xsl"/>

	
	<!--
		Section 6.
		
		Check for SAML 2.0 SPs which exclude both transient and persistent SAML 2 name identifier formats.
	-->
	<!--
	<xsl:template match="md:SPSSODescriptor
		[contains(@protocolSupportEnumeration, 'urn:oasis:names:tc:SAML:2.0:protocol')]
		[md:NameIDFormat]
		[not(md:NameIDFormat[.='urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'])]
		[not(md:NameIDFormat[.='urn:oasis:names:tc:SAML:2.0:nameid-format:transient'])]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">SP excludes both SAML 2 name identifier formats</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	-->
	
	<!--
		Section 6.
		
		Check for SAML 2.0 IdPs which exclude the transient SAML 2 name identifier format.
	-->
	<xsl:template match="md:IDPSSODescriptor
		[contains(@protocolSupportEnumeration, 'urn:oasis:names:tc:SAML:2.0:protocol')]
		[md:NameIDFormat]
		[not(md:NameIDFormat[.='urn:oasis:names:tc:SAML:2.0:nameid-format:transient'])]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">SAML 2.0 IDPSSODescriptor excludes SAML 2 transient name identifier format</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!--
		Section 7.
		
		Check for correct NameFormat on Attribute elements.
	-->
	<xsl:template match="saml:Attribute[not(@NameFormat)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">
				<xsl:text>Attribute </xsl:text>
				<xsl:value-of select="@Name"/>
				<xsl:text> lacks NameFormat attribute</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="saml:Attribute[@NameFormat][not(@NameFormat='urn:oasis:names:tc:SAML:2.0:attrname-format:uri')]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">
				<xsl:text>Attribute </xsl:text>
				<xsl:value-of select="@Name"/>
				<xsl:text> has incorrect NameFormat </xsl:text>
				<xsl:value-of select="@NameFormat"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!--
		Section 9.1
		
		Responses MUST use the HTTP-POST binding, so metadata for that MUST be present.
	-->
	<!--
	<xsl:template match="md:SPSSODescriptor
		[contains(@protocolSupportEnumeration, 'urn:oasis:names:tc:SAML:2.0:protocol')]
		[not(md:AssertionConsumerService[@Binding = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'])]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">no HTTP-POST support on SAML 2.0 SP</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	-->
	
</xsl:stylesheet>
