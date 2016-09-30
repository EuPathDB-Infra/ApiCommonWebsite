<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>
<c:set var="project" value="${applicationScope.wdkModel.name}" />
<c:set var="baseUrl" value="${pageContext.request.contextPath}"/>

<c:set var="props" value="${applicationScope.wdkModel.properties}" />
<c:set var="project" value="${props['PROJECT_ID']}" />

<imp:pageFrame title="${wdkModel.displayName} :: MaHPIC">

  <%--
  The following style and script tags are used for the "Read More" functionality.
  The expected structure is:

    .item
      .read_more
      .more_text

  --%>

  <style>
    .item .more_text {
      display: none;
    }
  </style>

  <script>
    jQuery(function($) {
      $('.item').on('click', '.read_more', function(event) {
        event.preventDefault();
        $(event.delegateTarget).find('.more_text').toggle();
      });
    });
  </script>


<center><h2>Access Data from MaHPIC -<br>The Malaria Host-Pathogen Interaction Center</h2><br>
        <div style="font-size:14px">NIAID Contract: # HHSN272201200031C<br>
        <a href="http://www.systemsbiology.emory.edu/index.html">MaHPIC Info at Emory</a> &nbsp; &nbsp; &ndash; &nbsp; &nbsp; <a href="https://www.niaid.nih.gov/research/malaria-host-pathogen-interaction-center-mahpic">MaHPIC Info at NIH</a>&nbsp; &nbsp; &ndash; &nbsp; &nbsp;<a href="#DataLinks">Take me to the data links</a></div>
        <img align="middle" src="images/MaHPIC_TopCenter_2.png" height="150px" width="500px"></center><br>

<div class="item">

  <h3>An Introduction to MaHPIC</h3>

  <div style="margin-left: 1em;">
    <a href="http://www.systemsbiology.emory.edu/index.html">MaHPIC</a> is an 
    <a href="https://www.niaid.nih.gov/">NIAID</a>-funded initiative to characterize host-pathogen interactions during malaria 
    infections of non-human primates. 
    <a href="http://www.systemsbiology.emory.edu/research/cores/index.html">MaHPIC's 8 teams</a> of 
    <a href="http://www.systemsbiology.emory.edu/people/investigators/index.html">outstanding scientists</a> 
    use a "systems biology" approach to study the molecular details of how malaria parasites 
	  interact with their human and other animal hosts to cause disease.
    <a href="#" class="read_more">Read More...</a><br><br>
  
  
  
     <span class="more_text">
      MaHPIC's experimental infections are carefully planned and monitored, producing results data sets (clinical 
      and a wide range of omics) that will be made available to the public. Results datasets will offer unprecedented 
      detail on disease progression, recrudescence, relapse, and host susceptibility and will be instrumental in 
      the development of new diagnostics, drugs, and vaccines to reduce the global suffering caused by this disease."<br><br>


	  The Malaria Host-Pathogen Interaction Center was established in September 2012 by the 
	  National Institute of Allergy and Infectious Diseases, 
	  part of the US National Institutes of Health. The MaHPIC team uses a "systems biology" strategy to study how malaria parasites 
	  interact with their human and other animal hosts to cause disease in molecular detail. The central hypothesis is that 
	  "Non-Human Primate host interactions with Plasmodium pathogens as model systems will provide insights into mechanisms, 
	  as well as indicators for, human malarial disease conditions".
	  <p>
	  The MaHPIC effort includes many teams working together to produce and analyze data and metadata.  These teams are briefly described below 
	  but more detailed information can be found at 
	  <a href="http://www.systemsbiology.emory.edu/research/cores/index.html">Emory's MaHPIC site</a>. 
	
	   <ul>
	    <li>Clinical Malaria - designs and implements experimental plans involving infection of non-human primates</li>
	    <li>Functional Genomics - develops gene expression profiles from blood and bone marrow </li>
	    <li>Proteomics - develops detailed proteomics profiles from blood and bone marrow</li>
	    <li>Lipidomics - investigates lipids and biochemical responses associated with lipids from blood and bone marrow</li> 
	    <li>Immunology - determines immune profiles of peripheral blood and bone marrow in the course of malaria infections of non-human primates. </li>
	    <li>Metabolomics - provides detailed metabolomics data for plasma and associated cellular fractions</li>
	    <li>Bioinformatics - standardizes, warehouses, maps and integrates the data generated by the experimental cores</li>
	    <li>Computational Modeling - integrates the data sets generated by the experimental cores into static and dynamic models.</li>
	   </ul>
      	
        <img src="images/MaHPIC_Malaria_Core.jpg" height="12px" width="12px">
        Clinical Malaria - designs and implements experimental plans involving infection of non-human primates<br>
        <img src="images/MaHPIC_Functional_Genomics_Core.jpg" height="12px" width="12px">
        Functional Genomics - develops gene expression profiles from blood and bone marrow 
        </span>
   </div>
</div>



   
<div class="item">  
   <h3>Systems Biology and Experimental Strategy</h3>
   
   <div style="margin-left: 1em;">
     For the study of malaria in the context of MaHPIC project, �systems biology� means collecting and analyzing comprehensive data on 
     how a <i>Plasmodium</i> parasite infection produces changes in host and parasite genes, proteins, lipids, the immune response and metabolism.
     MaHPIC experiments are longitudinal studies of <i>Plasmodium</i> infections (or uninfected controls) in non-human primates. 
     <a href="#" class="read_more">Read More...</a><br>
   
     <span class="more_text">
       <img align="middle" src="images/MaHPIC_Generic_Timeline.png" height="260px" width="520px"><br><br>
   
       The MaHPIC strategy is to collect physical specimens from non-human primates (NHPs) over the course of an experiment.  The clinical parameters 
       of infected animals and uninfected controls are monitored daily for about 100 days. During the experiment, animals receive blood-stage 
       treatments that clear parasites from the blood but not the liver, which is the source of relapse.  Animals receive a curative treatment 
       at the end of the experiment. At specific milestones during disease progression, blood and bone marrow samples are collected and 
       analyzed by the MaHPIC teams and a diverse set of data and metadata are produced.
 
	 </span>
   </div>	
</div>

<div class="item">

   <h3>The PlasmoDB-MaHPIC Interface Makes MaHPIC Data Available</h3>
   
   <div style="margin-left: 1em;">
     PlasmoDB serves as a gateway for the scientific community to access MaHPIC data. The <a href="#access">Access MaHPIC Data</a> 
     section of this page provides information about and links to all available MaHPIC data.
     <a href="#" class="read_more">Read More...</a><br><br>
   
      <span class="more_text">
   
        The MaHPIC project produces large amounts 
       of data, both clinical and omics, that is stored in public repositories whenever possible. When an appropriate public 
       repository does not exist (e.g. clinical data and metadata), PlasmoDB stores the data in our Downloads Section. Results 
       include a rich collection of data and metadata collected over the course of 
       individual MaHPIC experiments. Each Clinical Malaria data set consists of a set of files, including a descriptive README, that contain clinical, 
       veterinary, and animal husbandry results from a MaHPIC Experiment.  The results produced by the MaHPIC Clinical Malaria Team are the 
       backbone of MaHPIC experiments.<br><br>
     </span>
  </div>
</div>

  <a name=�DataLinks�></a>
  <h3>MaHPIC Experiment Information and Data Links</h3>
  <div style="margin-left: 1em;">	
   
   <div class="wdk-toggle" data-show="false">
      <h4 class="wdk-toggle-name"><a href="#">Experiment 4</a></h4> - Five <i>Macaca mulatta</i> individuals infected with <i>Plasmodium cynomolgi</i> and 
      treated with artemether over a 100-day study to observe multiple disease relapses. 
   <div class="wdk-toggle-content">
   
    <img align="middle" src="images/MaHPIC_Ex04_Timeline.png" height="300px" width="500px">
    
     <h4>Experiment Information</h4>
	 <ul>
	  <li>Description of experiment goals</li>
	  <li>Experiment start and end dates</li>
	  <li>Detailed Experimental Information: <a href="http://eupath/data/apiSiteFiles/downloadSite/PlasmoDB/MaHPIC/EX04_Sub_Template.xlsx">Experimnetal Metadata (Excel file)</a></li>
	  <li>Publication:  <a href="https://www.ncbi.nlm.nih.gov/pubmed/27590312">Joyner et al. Malar J. 2016 Sep 2;15(1):451.</a></li>
	 </ul> 
	 <h4>Data Links</h4> 
	 <ul>
	    <li>Clinical Malaria - <a href="http://plasmodb.org/common/downloads/">PlasmoDB Downloads (Expt 4)</a></li>
	    <li>Functional Genomics - <a href="https://www.ncbi.nlm.nih.gov/sra" target="_blank" >Sequence data at SRA</a>  OR  <a href=" https://www.ncbi.nlm.nih.gov/geo/" target="_blank">Expression data at GEO</a> </li>
	    <li>Proteomics - <a href="https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp" target="_blank">Expt 4 Proteomics data at MassIVE</a>  OR  <a href=" https://www.ebi.ac.uk/pride/archive/" target="_blank">Expt 4 data at PRIDE</a></li>
	    <li>Lipidomics - <a href="https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp" target="_blank">Expt 4 Lipidomics data at MassIVE</a></li> 
	    <li>Immunology - <a href="https://immport.niaid.nih.gov/immportWeb/home/home.do?loginType=full" target="blank">Expt 4 Immunomics at ImmPort</a></li>
	    <li>Metabolomics - <a href="https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp" target="_blank">Expt 4 Metabolomics data at MassIVE</a></li>
	    <li>Computational Modeling - no site chosen yet </li>
	   </ul>
  </div>
  </div>	
  
     <div class="wdk-toggle" data-show="false">
     <h4 class="wdk-toggle-name"><a href="#">Experiment 13</a></h4>
     <div class="wdk-toggle-content">
  </div>
  </div>
  
       <div class="wdk-toggle" data-show="false">
     <h4 class="wdk-toggle-name"><a href="#">Experiment 23</a></h4>
     <div class="wdk-toggle-content">
  </div>
  </div>
  </div>

</imp:pageFrame>
