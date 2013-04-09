<?xml version="1.0" encoding="UTF-8"?>
<!--
	
    check_uk_trust.xsl
    
    Checking ruleset for the UK federation trust fabric, as documented in the
    Federation Technical Specifications.  Checks are labelled with a section
    number and FTS version, as the section number may change between editions.
    
    Author: Ian A. Young <ian@iay.org.uk>
    
-->
<xsl:stylesheet version="1.0"
	xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
	xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="urn:oasis:names:tc:SAML:2.0:metadata">
	
	<!--
        Common support functions.
    -->
	<xsl:import href="check_framework.xsl"/>
	
	
	<!--
		FTS 1.4 second draft, section 3.10
		
		Each <IDPSSODescriptor>, <SPSSODescriptor> and <AttributeAuthorityDescriptor>
		role descriptor appearing in metadata published by the UK federation SHALL
		contain at least one <KeyDescriptor> element.
	-->
	
	<xsl:template match="md:IDPSSODescriptor[not(md:KeyDescriptor)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">IdP SSO Descriptor lacking KeyDescriptor</xsl:with-param>
		</xsl:call-template>    
	</xsl:template>
	
	<xsl:template match="md:SPSSODescriptor[not(md:KeyDescriptor)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">SP SSO Descriptor lacking KeyDescriptor</xsl:with-param>
		</xsl:call-template>    
	</xsl:template>
	
	<xsl:template match="md:AttributeAuthorityDescriptor[not(md:KeyDescriptor)]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">IdP AA Descriptor lacking KeyDescriptor</xsl:with-param>
		</xsl:call-template>    
	</xsl:template>
	
	
	<!--
        FTS 1.4 second draft, section 3.10
        
        In roles supporting SAML 2.0 profiles (roles whose protocolSupportEnumeration contains
        urn:oasis:names:tc:SAML:2.0:protocol) each <KeyDescriptor> MUST support the direct
        key verification scheme as described in section 2.1.1 above.
    -->
	<xsl:template match="md:IDPSSODescriptor
		[contains(@protocolSupportEnumeration, 'urn:oasis:names:tc:SAML:2.0:protocol')]
		[md:KeyDescriptor[not(descendant::ds:X509Data)]]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">SAML 2.0 IdP has KeyDescriptor without embedded key</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="md:AttributeAuthorityDescriptor
		[contains(@protocolSupportEnumeration, 'urn:oasis:names:tc:SAML:2.0:protocol')]
		[md:KeyDescriptor[not(descendant::ds:X509Data)]]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">SAML 2.0 AttributeAuthority has KeyDescriptor without embedded key</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="md:SPSSODescriptor
		[contains(@protocolSupportEnumeration, 'urn:oasis:names:tc:SAML:2.0:protocol')]
		[md:KeyDescriptor[not(descendant::ds:X509Data)]]">
		<xsl:call-template name="error">
			<xsl:with-param name="m">SAML 2.0 SP has KeyDescriptor without embedded key</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>