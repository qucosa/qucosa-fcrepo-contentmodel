<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output encoding="UTF-8" indent="no" media-type="application/json" method="text" omit-xml-declaration="yes"></xsl:output>
    <xsl:strip-space elements="*"></xsl:strip-space>
    <xsl:template match="/Opus[version='2.0']">
        <xsl:apply-templates select="Opus_Document[1]"/>
    </xsl:template>
    <xsl:template match="Opus_Document">
        <xsl:text>{</xsl:text>
        <!-- single value fields -->
        <xsl:apply-templates select="CompletedDate"/>
        <xsl:apply-templates select="ServerDatePublished"/>
        <xsl:apply-templates select="Type"/>
        <!-- multiple value fields -->
        <xsl:call-template name="TitleMain"/>
        <xsl:call-template name="TitleAbstract"/>
        <xsl:call-template name="IdentifierUrn"/>
        <xsl:call-template name="Note"/>
        <xsl:call-template name="PersonAuthor"/>
        <xsl:call-template name="PersonSubmitter"/>
        <xsl:call-template name="SubjectDdc"/>
        <xsl:call-template name="SubjectUncontrolled"/>
        <xsl:call-template name="File"/>
        <xsl:call-template name="FirstLevelName"/>
        <xsl:call-template name="SecondLevelName"/>
        <!-- closing, after last comma -->
        <xsl:text>"":""</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="Opus_Document/CompletedDate">
        <xsl:call-template name="emit-field">
            <xsl:with-param name="key">PUB_DATE</xsl:with-param>
            <xsl:with-param name="value" select="concat(Year, '-', Month, '-', Day)"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Opus_Document/ServerDatePublished">
        <xsl:if test="not(/Opus/Opus_Document/CompletedDate/Year)">
            <xsl:call-template name="emit-field">
                <xsl:with-param name="key">PUB_DATE</xsl:with-param>
                <xsl:with-param name="value" select="concat(Year, '-', Month, '-', Day)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="Opus_Document/Type">
        <xsl:call-template name="emit-field">
            <xsl:with-param name="key">PUB_TYPE</xsl:with-param>
            <xsl:with-param name="value" select="."/>
        </xsl:call-template>
    </xsl:template>
    <!-- Named templates -->
    <xsl:template name="TitleMain">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_TITLE</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/TitleMain/Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="TitleAbstract">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_ABSTRACT</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/TitleAbstract/Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="IdentifierUrn">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_URN</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/IdentifierUrn/Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="Note">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_ADM_NOTE</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/Note/Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="SubjectDdc">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_TAG_DDC</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/SubjectDdc/Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="SubjectUncontrolled">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_TAG</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/SubjectUncontrolled/Value"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="File">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_FILENAME</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/File/PathName"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="FirstLevelName">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_ORIGINATOR</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/Organisation/FirstLevelName"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="SecondLevelName">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_ORIGINATOR_SUB</xsl:with-param>
            <xsl:with-param name="selectValues" select="Opus_Document/Organisation/SecondLevelName"/>
        </xsl:call-template>
    </xsl:template>
    <!-- Special handling for Authors -->
    <xsl:template name="PersonAuthor">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_AUTHOR</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/PersonAuthor"/>
            <xsl:with-param name="call">concat-firstname-lastname</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="PersonSubmitter">
        <xsl:call-template name="emit-array-field">
            <xsl:with-param name="key">PUB_SUBMITTER</xsl:with-param>
            <xsl:with-param name="selectValues" select="//Opus_Document/PersonSubmitter"/>
            <xsl:with-param name="call">concat-firstname-lastname</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <!-- utility templates -->
    <xsl:template name="emit-field">
        <xsl:param name="key"/>
        <xsl:param name="value"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>":</xsl:text>
        <xsl:call-template name="encode">
            <xsl:with-param name="s" select="$value"/>
        </xsl:call-template>
        <xsl:text>,</xsl:text>
    </xsl:template>
    <xsl:template name="emit-array-field">
        <xsl:param name="key"/>
        <xsl:param name="selectValues"/>
        <xsl:param name="call"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>":[</xsl:text>
        <xsl:for-each select="$selectValues">
            <xsl:choose>
                <xsl:when test="$call='concat-firstname-lastname'">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="s">
                            <xsl:value-of select="concat(FirstName,' ', LastName)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="encode">
                        <xsl:with-param name="s" select="."/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position()!=last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
    </xsl:template>
    <xsl:template name="encode">
        <xsl:param name="s"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="translate(normalize-space($s), '&quot;', '\&quot;')"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
