<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/PLRM">
		<html>
			<head>
			<script language="javascript" src="plrm.js"></script>
			<title>Recommended Range Report</title> 
			<link href="style.css" rel="stylesheet" type="text/css" />
			<!-- <link href="style2.css" rel="stylesheet" type="text/css" /> -->
		</head>
		<body>
			<div class="headerDiv">
				<h1 class="mainHeading"> Recommended Range Report </h1><br />
			</div>
			<br /><br /><br />
			<div align="center"> 
				<table class="introTable" border="1">
				<caption>Project Summary</caption>
				<thead>
					<tr>
						<th WIDTH="200" scope="col" align="left">Item</th>
						<th width="300" scope="col" align="left">Value</th>
					</tr>
					<tr><td>Project Name</td><td><xsl:value-of select = "./Project/@name" /></td></tr>
					<tr><td>Scenario Name</td> <td><xsl:value-of select = "./ScenName" /></td></tr>
					<tr><td>Working Directory</td> <td><xsl:value-of select = "./WorkingDir" /></td></tr>
					<tr><td>Date Created</td> <td><xsl:value-of select = "./Project/@dateCreated" /></td></tr>
					<tr><td>Last Modified</td> <td><xsl:value-of select = "./Project/@dateModified" /></td></tr>
					<tr><td>Metgrid Number</td><td><xsl:value-of select = "./Metgrid" /></td></tr>
					<tr><td>Number of user catchments</td><td><xsl:value-of select="count(//Catchment)"/></td></tr>
					<tr><td>Number of user nodes</td><td><xsl:value-of select="count(//Node)"/></td></tr>
					<tr><td>Run By</td><td><xsl:value-of select = "./CreatedBy" /></td></tr>
				</thead>
				<xsl:apply-templates select="." mode="HSCksatStorArea"/>
				<xsl:apply-templates select="." mode="nodeKsat"/>		
				</table>
			</div> 
			<br /><br /><br />

			<xsl:apply-templates select="Nodes"/>
			<div class="footNoteDiv">
				<div class="footNoteDivInner">				
				<p><b><u>SWT Notes and Warning Descriptions</u></b></p>
				<p><xsl:apply-templates select="/PLRM/nodeValidation/rule[position() &lt; 6]" mode="footNotes"/></p>
				</div>
			</div>	
			<br /><br />
			<xsl:apply-templates select="Catchments" mode="start"/>	
			<div class="footNoteDiv">
				<div class="footNoteDivInner">				
				<p><b><u>Catchment Notes and Warning Descriptions</u></b></p>
				<p><xsl:apply-templates select="/PLRM/catchmentValidation/rule" mode="footNotes"/></p>
				</div>
			</div>			
		</body>
		</html>
	</xsl:template>
<!--BEGIN Subcatchments -->	
 	<xsl:template match="Catchments">
		<p><xsl:apply-templates select="Catchment"/></p>
	</xsl:template> 
	
 	<xsl:template match="Catchment" mode="start">
		<!-- <xsl:param name="myName" select ="@name"/> -->
		<div class="contentDiv">
			<a class="anchor" href="javascript:;" onmousedown="toggleDiv('{(@name)}');"><xsl:value-of select = "concat('Catchment: ',@name, '(click to expand/collapse this section)')" /></a>
			<div id="{(@name)}" style="display:all">
				<table border="1">
					<caption>Catchment Validation for <xsl:value-of select = " @name" /></caption>
					<thead>
					<tr>
						<th WIDTH="250" scope="col" align="left">Object Name</th>
						<th WIDTH="150" scope="col" align="left">Parameter</th>
						<th WIDTH="20" scope="col" align="left">Min</th>
						<th WIDTH="20" scope="col" align="left">Max</th>
						<th WIDTH="20" scope="col" align="left">Units</th>
						<th WIDTH="20" scope="col" align="left">Your Value</th>
						<th WIDTH="20" scope="col" align="left">Flag</th>
						<th WIDTH="200" scope="col" align="left">Status Description</th>
					</tr>
					</thead>
					<xsl:apply-templates select="." mode="pollutantDeliveryFactors"/>
					<xsl:apply-templates select="." mode="slope"/>
					<xsl:apply-templates select="ParcelAndRdMethXMLTags/child::*/child::*" mode="dcia"/>
					<xsl:apply-templates select="ParcelAndRdMethXMLTags/child::*/child::*" mode="ksatDepStor"/>	
					<xsl:apply-templates select="ParcelAndRdMethXMLTags/child::*" mode="HSCksatStorArea"/>					
				</table>
				<p class="pSmallTxt">*Note: An empty table implies all variables passed the validation test</p>
			</div>
		</div>
		<br />
		<!-- <xsl:value-of select = "'&lt;div/&gt;'" /> -->
	</xsl:template> 

	<!-- 2. BEGIN Slope -->	
	<xsl:template match = "*" mode="slope">
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="@slope" />
			<xsl:with-param name="luseName" select="'Entire Catchment'" />
			<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[2]/@parameter" />
			<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[2]/@min"/>
			<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[2]/@max"/>
			<xsl:with-param name="anchorName" select="'catchment2'" />
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[2]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #2)'" />
		</xsl:call-template>
	</xsl:template> 
	<!-- END Slope -->
	
	<!-- 1. BEGIN Pollutant delivery factors -->
	<xsl:template match = "Catchment" mode="pollutantDeliveryFactors">
 		<xsl:param name="primSchmID" select ="./RoadRiskCategories/@primSchmID"/>
		<xsl:param name="secSchmID" select ="./RoadRiskCategories/@secSchmID"/>
		<xsl:param name="myName" select ="@name"/>
		<xsl:param name="myParameter" select="/PLRM/catchmentValidation/rule[1]/@parameter" />

		<xsl:param name="highDsvd1" select ="/PLRM/Schemes/Scheme[(@stype = '3') and (@catchName = $myName)]/PollutantDeliveryFactors/High/@finesDisvd"/>		
		<xsl:param name="modDsvd1"  select ="/PLRM/Schemes/Scheme[(@stype = '3') and (@catchName = $myName)]/PollutantDeliveryFactors/Moderate/@finesDisvd"/>
		<xsl:param name="lowDsvd1"  select ="/PLRM/Schemes/Scheme[(@stype = '3') and (@catchName = $myName)]/PollutantDeliveryFactors/Low/@finesDisvd"/>
		
		<xsl:param name="highPart1" select ="/PLRM/Schemes/Scheme[(@stype = '3') and (@catchName = $myName)]/PollutantDeliveryFactors/High/@particulates"/>
		<xsl:param name="modPart1"  select ="/PLRM/Schemes/Scheme[(@stype = '3') and (@catchName = $myName)]/PollutantDeliveryFactors/Moderate/@particulates"/>
		<xsl:param name="lowPart1"  select ="/PLRM/Schemes/Scheme[(@stype = '3') and (@catchName = $myName)]/PollutantDeliveryFactors/Low/@particulates"/>
		
		<xsl:param name="highDsvd2" select ="/PLRM/Schemes/Scheme[(@stype = '4') and (@catchName = $myName)]/PollutantDeliveryFactors/High/@finesDisvd"/>
		<xsl:param name="modDsvd2"  select ="/PLRM/Schemes/Scheme[(@stype = '4') and (@catchName = $myName)]/PollutantDeliveryFactors/Moderate/@finesDisvd"/>
		<xsl:param name="lowDsvd2"  select ="/PLRM/Schemes/Scheme[(@stype = '4') and (@catchName = $myName)]/PollutantDeliveryFactors/Low/@finesDisvd"/>
		
		<xsl:param name="highPart2" select ="/PLRM/Schemes/Scheme[(@stype = '4') and (@catchName = $myName)]/PollutantDeliveryFactors/High/@particulates"/>
		<xsl:param name="modPart2"  select ="/PLRM/Schemes/Scheme[(@stype = '4') and (@catchName = $myName)]/PollutantDeliveryFactors/Moderate/@particulates"/>
		<xsl:param name="lowPart2"  select ="/PLRM/Schemes/Scheme[(@stype = '4') and (@catchName = $myName)]/PollutantDeliveryFactors/Low/@particulates"/>		

		<!-- write primary road dissolved pollutant delivery factors -->
		<xsl:if test= "(./LandUses/LandUse[@name = 'Primary Road (ROW)'])">
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$highDsvd1"/>
			<xsl:with-param name="luseName" select="('Primary Roads - High Risk')"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Dissolved)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />
		</xsl:call-template>
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$modDsvd1"/>
			<xsl:with-param name="luseName" select="'Primary Roads - Moderate Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Dissolved)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$lowDsvd1"/>
			<xsl:with-param name="luseName" select="'Primary Roads -Low Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Dissolved)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 

		<!-- write primary road particulate pollutant delivery factors -->
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$highPart1"/>
			<xsl:with-param name="luseName" select="'Primary Roads - High Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Particulate)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$modPart1"/>
			<xsl:with-param name="luseName" select="'Primary Roads - Moderate Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Particulate)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$lowPart1"/>
			<xsl:with-param name="luseName" select="'Primary Roads - Low Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Particulate)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		</xsl:if>
		
		<!-- write secondary road dissolved pollutant delivery factors -->
		<!-- <xsl:if test= "(/LandUses/LandUse[1]/@area != 0)"> -->
		<xsl:if test= "(./LandUses/LandUse[@name = 'Secondary Road (ROW)'])">
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$highDsvd2"/>
			<xsl:with-param name="luseName" select="'Secondary Roads - High Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Dissolved)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$modDsvd2"/>
			<xsl:with-param name="luseName" select="'Secondary Roads - Moderate Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Dissolved)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$lowDsvd2"/>
			<xsl:with-param name="luseName" select="'Secondary Roads - Low Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Dissolved)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 

		<!-- write secondary road particulate pollutant delivery factors -->
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$highPart2"/>
			<xsl:with-param name="luseName" select="'Secondary Roads - High Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Particulate)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$modPart2"/>
			<xsl:with-param name="luseName" select="'Secondary Roads - Moderate Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Particulate)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="$lowPart2"/>
			<xsl:with-param name="luseName" select="'Secondary Roads - Low Risk'"/>
			<xsl:with-param name="parameter" select="concat($myParameter, ' (Particulate)')"/>
			<xsl:with-param name="anchorName" select="'catchment1'" />
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[1]/@units"/>
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[1]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #1)'" />			
		</xsl:call-template> 
		</xsl:if>
	</xsl:template>
	<!-- END Pollutant delivery factors -->	

	<!--3. BEGIN DCIA -->
	<xsl:template match = "*" mode="dcia">
		<xsl:param name="myName" select ="../../../@name"/>
		<xsl:param name="myLuse" select="local-name(parent::*)"/> 		
		<xsl:param name="myUsrValue" select ="@dcia"/>
		<xsl:param name="myHSCType" select ="."/>
		<xsl:param name="myAnchorName" select="'catchment3'" />
		<xsl:param name="myWarning" select="'See (footnote #3)'" />
		
		
		<xsl:if test= "(@areaAc != '0')">
			<!-- validate hsc catchments -->
			<xsl:if test= "(name() != 'Out')">
				<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select="$myUsrValue"/>
				<xsl:with-param name="luseName" select="concat($myLuse, ' - ',$myHSCType)"/>
				<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[9]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[9]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[9]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[9]/@units"/>
				<xsl:with-param name="anchorName" select ="$myAnchorName"/>
				<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[9]/@flag"/>
				<xsl:with-param name="warning" select ="$myWarning"/>
				</xsl:call-template>
			</xsl:if>
			<!-- validate non-hsc catchments -->
			<xsl:if test= "(name() = 'Out')">
				<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select="$myUsrValue"/>
				<xsl:with-param name="luseName" select="concat($myLuse, ' - ',$myHSCType)"/>
				<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[3]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[3]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[3]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[3]/@units"/>
				<xsl:with-param name="anchorName" select ="$myAnchorName"/>
				<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[3]/@flag"/>
				<xsl:with-param name="warning" select ="$myWarning"/>
				</xsl:call-template>
			</xsl:if>		
		</xsl:if>
	</xsl:template>
	<!-- END DCIA -->	

	<!--4,7,8 BEGIN Catchment KSAT / Dep stor perv/imperv -->
	<xsl:template match = "*" mode="ksatDepStor">
		<xsl:param name="myName" select ="../../../@name"/>
		<xsl:param name="myLuse" select="local-name(parent::*)"/> 
		<xsl:param name="myHSCType" select ="."/>
		
		<!-- write KSAT -->
		<xsl:if test= "(@areaAc != 0)">
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select ="@ksat"/>
			<xsl:with-param name="luseName" select="concat($myLuse, ' - Drains To: (',$myHSCType, ')')"/>
			<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[4]/@parameter" />
			<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[4]/@min"/>
			<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[4]/@max"/>
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[4]/@units"/>
			<xsl:with-param name="anchorName" select="'catchment4'" />
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[4]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #4)'" />
		</xsl:call-template>
		
		<!-- write Perv Dep Stor -->
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="@pervDepStor"/>
			<xsl:with-param name="luseName" select="concat($myLuse, ' - Drains To: (',$myHSCType, ')')"/>
			<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[7]/@parameter" />
			<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[7]/@min"/>
			<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[7]/@max"/>
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[7]/@units"/>
			<xsl:with-param name="anchorName" select="'catchment7'" />
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[7]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #7)'" />
		</xsl:call-template>
	
		<!-- write Imperv Dep Stor -->
		<xsl:call-template name="generic">
			<xsl:with-param name="usrValue" select="@imprvDepStor"/>
			<xsl:with-param name="luseName" select="concat($myLuse, ' - Drains To: (',$myHSCType, ')')"/>
			<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[8]/@parameter" />
			<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[8]/@min"/>
			<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[8]/@max"/>
			<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[8]/@units"/>
			<xsl:with-param name="anchorName" select="'catchment8'" />
			<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[8]/@flag"/>
			<xsl:with-param name="warning" select="'See (footnote #8)'" />			
		</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- END DCIA -->	
	
	<!-- 5,6. BEGIN HSC Ksat and Storage Area -->
	<xsl:template match = "*" mode="HSCksatStorArea">
 		<xsl:param name="myInfSchmID" select ="./@infSchmID"/>
		<xsl:param name="myDspSchmID" select ="./@dspSchmID"/>
		<xsl:param name="myName" select ="../../@name"/>
		<xsl:param name="myLuse" select="local-name(.)"/> 
		
		<xsl:param name="infKsat" select ="/PLRM/Schemes/Scheme[(@id = $myInfSchmID) and (@stype = '1') and (@catchName = $myName)]/Ksat"/>	
		<xsl:param name="infStor" select ="/PLRM/Schemes/Scheme[(@id = $myInfSchmID) and (@stype = '1') and (@catchName = $myName)]/UnitStorArea "/>			
		<xsl:param name="dspKsat" select ="/PLRM/Schemes/Scheme[(@id = $myDspSchmID) and (@stype = '2') and (@catchName = $myName)]/Ksat"/>
		<xsl:param name="dspStor" select ="/PLRM/Schemes/Scheme[(@id = $myDspSchmID) and (@stype = '2') and (@catchName = $myName)]/PDAdepStor "/>

		
		<xsl:if test= "($myInfSchmID != '-1')">
			<xsl:if test= "(./Inf/@areaAc != 0)">
			<xsl:call-template name="generic">
				<!-- write inf HSC ksat-->
				<xsl:with-param name="usrValue" select="$infKsat"/>
				<xsl:with-param name="luseName" select="concat($myLuse, ' - Inf')"/>
				<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[5]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[5]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[5]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[5]/@units"/>
				<xsl:with-param name="anchorName" select="'catchment5'" />
				<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[5]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #5)'" />
			</xsl:call-template>
			<!-- write inf HSC storage-->
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select="$infStor"/>
				<xsl:with-param name="luseName" select="concat($myLuse, ' - Inf')"/>
				<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[6]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[6]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[6]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[6]/@units"/>
				<xsl:with-param name="anchorName" select="'catchment6'" />
				<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[6]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #6)'" />				
			</xsl:call-template>
			</xsl:if>
		</xsl:if>		
		
		<xsl:if test= "($myDspSchmID != '-1')">
			<xsl:if test= "(./Dsp/@areaAc != 0)">
			<!-- write dsp HSC ksat-->
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select="$dspKsat"/>
				<xsl:with-param name="luseName" select="concat($myLuse, ' - Dsp')"/>
				<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[5]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[5]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[5]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[5]/@units"/>
				<xsl:with-param name="anchorName" select="'catchment5'" />
				<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[5]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #5)'" />				
			</xsl:call-template>
			<!-- write dsp HSC storage-->
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select="$dspStor"/>
				<xsl:with-param name="luseName" select="concat($myLuse, ' - Dsp')"/>
				<xsl:with-param name="parameter" select="/PLRM/catchmentValidation/rule[7]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/catchmentValidation/rule[7]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/catchmentValidation/rule[7]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/catchmentValidation/rule[7]/@units"/>
				<xsl:with-param name="anchorName" select="'catchment7'" />
				<xsl:with-param name="flag" select ="/PLRM/catchmentValidation/rule[7]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #7)'" />				
			</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- END HSC Ksat and Storage Area -->	


	
<!-- END Subcatchments -->
	
<!-- BEGIN Nodes -->
 	<xsl:template match="Nodes">
		<xsl:apply-templates select="Node[(@NodeType != '7') and (@ObjType != '5')]" mode="nodeStart"/>
	</xsl:template> 

 	<xsl:template match="Node" mode="nodeStart">
		<xsl:param name="myName" select ="@name"/>
		<div class="contentDiv"><a class="anchor" href="javascript:;" onmousedown="toggleDiv('{(@name)}');"><xsl:value-of select = "concat('SWT: ',@name, '(click to expand/collapse this section)')"  /></a>
		<div id="{(@name)}" style="display:all">
			<table border="1">
				<caption>Node Validation for <xsl:value-of select = " @name" /></caption>
				<thead>
					<tr onclick="ExpandCollapseTable(this);" style="cursor:pointer;">
						<th scope="col" align="left">Object Name</th>
						<th scope="col" align="left">Parameter</th>
						<th scope="col" align="left">Minimum</th>
						<th scope="col" align="left">Maximum</th>
						<th scope="col" align="left">Units</th>
						<th scope="col" align="left">Your value</th>
						<th scope="col" align="left">Flag</th>
						<th scope="col" align="left">Status Description</th>
					</tr>
				</thead>
				<!-- <xsl:apply-templates select="." mode="HSCksatStorArea"/> -->
				<xsl:apply-templates select="." mode="nodeKsat"/>	
				<xsl:apply-templates select="./EfflQuals/efflQual" mode="cecs"/>				
			</table>
			<p class="pSmallTxt">*Note: An empty table implies all variables passed the validation test</p>
		</div>
		</div><br />
		<!-- <xsl:value-of select = "'&lt;div/&gt;'" /> -->
	</xsl:template> 
	
		<!--BEGIN Node KSAT / InfiltRate / Wetpool DDT -->
	<xsl:template match = "*" mode="nodeKsat">
		<xsl:param name="myInfltRate" select ="./DesignParamters/dngParam/@infltRate"/>
		<xsl:param name="myDDTime" select ="./DesignParamters/dngParam/@drawDownT"/>
		<!-- 2014 change to fix wetpool validation bug <xsl:param name="myWetPoolDDT" select ="./DesignParamters/dngParam/@maxTrtFlow"/>--> <!-- misnomer actually referes to minHRT -->
		<!-- 2014--><xsl:param name="myWetPoolDDT" select ="./DesignParamters/dngParam/@minHrt"/>
		<!-- 2014--><xsl:param name="myWetBasinBrimDDT" select ="./DesignParamters/dngParam/@maxTrtFlow"/> <!-- wet basin brimfull draw down time -->
		<xsl:param name="myMFDDT" select ="./DesignParamters/dngParam/@minHrt"/>
		<xsl:param name="NodeType" select ="./@NodeType"/>
		
		<!-- write Node KSAT -->
		<xsl:if test= "($myInfltRate > 0)">
			<!-- for infiltration basins -->
			<xsl:if test= "$NodeType = 2">	
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$myInfltRate"/>
				<xsl:with-param name="luseName" select="@name"/>					
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[35]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[35]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[35]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[35]/@units"/>				
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[35]/@flag"/>			
				<xsl:with-param name="anchorName" select="'node1'" />
				<xsl:with-param name="warning" select="'See (footnote #1)'" />
			</xsl:call-template>
			</xsl:if>
			<!-- for all other swts -->
			<xsl:if test= "(($NodeType != 2) and ($NodeType != 4))">	
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$myInfltRate"/>
				<xsl:with-param name="luseName" select="@name"/>			
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[1]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[1]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[1]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[1]/@units"/>				
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[1]/@flag"/>	
				<xsl:with-param name="anchorName" select="'node1'" />
				<xsl:with-param name="warning" select="'See (footnote #1)'" />
			</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- check bedfilter filtration rate -->
		<xsl:if test= "(($NodeType = 4))">	
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$myInfltRate"/>
				<xsl:with-param name="luseName" select="@name"/>			
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[4]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[4]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[4]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[4]/@units"/>				
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[4]/@flag"/>	
				<xsl:with-param name="anchorName" select="'node1'" />
				<xsl:with-param name="warning" select="'See (footnote #4)'" />
			</xsl:call-template>
		</xsl:if>
		<!-- write Node DrawDownTime -->
		<xsl:if test= "($myDDTime > 0)">
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$myDDTime"/>
				<xsl:with-param name="luseName" select="@name"/>
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[2]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[2]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[2]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[2]/@units"/>
				<xsl:with-param name="anchorName" select="'node2'" />
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[2]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #2)'" />				
			</xsl:call-template>
		</xsl:if>
		<!-- write Node Wetpool DDT -->
		<xsl:if test= "(($myWetPoolDDT > 0) and ($NodeType = 3))"> <!-- 10/18 made so its for wetponds only -->
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$myWetPoolDDT"/>
				<xsl:with-param name="luseName" select="@name"/>
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[3]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[3]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[3]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[3]/@units"/>
				<xsl:with-param name="anchorName" select="'node2'" />
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[3]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #2)'" />				
			</xsl:call-template>
		</xsl:if>
		<!-- 2014 write wetbasin brim full DDT -->
		<xsl:if test= "(($myWetBasinBrimDDT > 0) and ($NodeType = 3))"> 
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$myWetBasinBrimDDT"/>
				<xsl:with-param name="luseName" select="@name"/>
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[2]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[2]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[2]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[2]/@units"/>
				<xsl:with-param name="anchorName" select="'node2'" />
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[2]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #2)'" />				
			</xsl:call-template>
		</xsl:if>
	</xsl:template>	
<!-- END Nodes -->

<!--BEGIN Node CECs -->
	<xsl:template match = "*" mode="cecs">
		<xsl:param name="CECVal" select ="@*[1]"/>
		<!-- <xsl:param name="ParamName" select ="concat(../../@name, ' CEC')"/> -->
		<xsl:param name="ParamName" select ="'SWT CEC'"/>
		<xsl:param name="NodeType" select ="../../@NodeType"/>
		<xsl:param name="Postn" select ="4 + 6*($NodeType - 2)  + position()"/> <!-- extra term to account for infiltration not having cecs hence needing to skip for all > 2 -->
		
			<xsl:if test= "$NodeType != 1">
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$CECVal"/>
				<xsl:with-param name="luseName" select="$ParamName"/>
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[$Postn]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[$Postn]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[$Postn]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[$Postn]/@units"/>
				<xsl:with-param name="anchorName" select="'node1'" />
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[$Postn]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #5)'" />
			</xsl:call-template>
			</xsl:if>
			
			<!-- for dryBasins only cause of gap left by infiltration not having cecs -->
			<xsl:if test= "$NodeType = 1">
			<xsl:call-template name="generic">
				<xsl:with-param name="usrValue" select ="$CECVal"/>
				<xsl:with-param name="luseName" select="$ParamName"/>
				<xsl:with-param name="parameter" select="/PLRM/nodeValidation/rule[$Postn+6]/@parameter" />
				<xsl:with-param name="minVal" select ="/PLRM/nodeValidation/rule[$Postn+6]/@min"/>
				<xsl:with-param name="maxVal" select ="/PLRM/nodeValidation/rule[$Postn+6]/@max"/>
				<xsl:with-param name="units" select ="/PLRM/nodeValidation/rule[$Postn+6]/@units"/>
				<xsl:with-param name="anchorName" select="'node1'" />
				<xsl:with-param name="flag" select ="/PLRM/nodeValidation/rule[$Postn+6]/@flag"/>
				<xsl:with-param name="warning" select="'See (footnote #5)'" />
			</xsl:call-template>
			</xsl:if>
			
	</xsl:template>	
<!-- END Nodes -->
	
<!-- BEGIN generic section for printing rows in table -->
 	<xsl:template name = "generic">
 		<xsl:param name="usrValue" select ="0"/>
		<xsl:param name="luseName" select ="@name"/>
		<xsl:param name="minVal" select ="/PLRM/catchmentValidation/rule[1]/@min"/>
		<xsl:param name="maxVal" select ="/PLRM/catchmentValidation/rule[1]/@max"/>
		<xsl:param name="units" select="/PLRM/catchmentValidation/rule[1]/@units" />
		<xsl:param name="flag" select ="test"/>
		<xsl:param name="parameter" select="/PLRM/catchmentValidation/rule[1]/@parameter" />
		<xsl:param name="anchorName" select="'test'" />
		<xsl:param name="warning" select="'test'" />
		
		<xsl:if test= "($usrValue &lt; $minVal) or ($usrValue &gt; $maxVal)">
			<xsl:if test= "($usrValue &lt; $minVal) or ($usrValue &gt; $maxVal)">
			<tr>
				<td><xsl:value-of select="$luseName" /></td>
				<td><xsl:value-of select="$parameter"/></td>
				<td class="centered"><xsl:value-of select="$minVal" /></td>
				<td class="centered"><xsl:value-of select="$maxVal" /></td>
				<td><xsl:value-of select="$units" /></td>
				<td class="centered"><xsl:value-of select="$usrValue" /></td>		
				<td><xsl:value-of select="$flag"/></td>
				<td><a href="#{$anchorName}"><xsl:value-of select="$warning" /></a></td>
			</tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>	
<!-- END generic section for printing rows in table -->	
<!-- BEGIN generic sections for printing rows in table and footnotes -->
 	<xsl:template match = "/PLRM/catchmentValidation/rule" mode="footNotes">
		<xsl:param name="anchorName" select="concat('catchment',position())" />
		<a name="{($anchorName)}"><xsl:value-of select="concat('(', position(),') ',.)" /><br /></a>
	</xsl:template>	
	
	<xsl:template match = "/PLRM/nodeValidation/rule" mode="footNotes">
		<xsl:param name="anchorName" select="concat('node',position())" />
		<a name="{($anchorName)}"><xsl:value-of select="concat('(', position(),') ',.)" /><br /></a>
	</xsl:template>	
<!-- END generic section for printing rows in table -->	
	</xsl:stylesheet>