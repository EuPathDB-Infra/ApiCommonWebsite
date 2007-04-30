<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="modelName" value="${wdkModel.displayName}"/>

<table width="100%" border="0" cellspacing="2" cellpadding="2">

    <tr>
        <td width="33%" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Genomic Position</td>
                
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByLocation" linktext="Chromosomal Location" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByCentromereProximity" linktext="Proximity to Centromeres" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByTelomereProximity" linktext="Proximity to Telomeres" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByNonnuclearLocation" linktext="Non-nuclear Genomes" existsOn="A P T"/>
                </tr>
            </table>
        </td>

        <td width="34%" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Gene Attributes</td>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByGeneType" linktext="Type (e.g. rRNA, tRNA)"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByExonCount" linktext="Exon/Intron Structure" existsOn="A C P T"/>
                </tr>
            </table>
        </td>

       <td  valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Other Attributes
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByTextSearch" linktext="Keyword"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GeneByLocusTag" linktext="ID"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByTaxon" linktext="Species" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByMr4Reagents" linktext="Available Reagents" existsOn="A P"/>
                </tr>

              
            </table>
        </td>

    </tr>

    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Transcript Expression
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByESTOverlap" linktext="EST Evidence" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="NA" linktext="SAGE Tag Evidence" existsOn=""/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="InternalQuestions" qname="GenesByMicroarrayEvidence" linktext="Microarray Evidence" existsOn="A P T"/>
                </tr>
            </table>
        </td>

        

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Protein Expression

                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="InternalQuestions" qname="GenesByMassSpecEvidence" linktext="Mass Spec. Evidence" existsOn="A C P T"/>
                </tr>
            </table>
        </td>
<td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Similarity/Pattern

                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByMotifSearch" linktext="Protein Motif" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByInterproDomain" linktext="Interpro/Pfam Domain" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesBySimilarity" linktext="BLAST similarity" existsOn="A C P T"/>
                </tr>
            </table>
        </td>
    </tr>


    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Predicted Proteins

                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByMolecularWeight" linktext="Molecular Weight" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByIsoelectricPoint" linktext="Isoelectric Point" existsOn="A P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="InternalQuestions" qname="GenesByProteinStructure" linktext="Protein Structure" existsOn="A P"/>
                </tr>
                <tr>
            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Putative Function
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByGoTerm" linktext="GO Term" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByEcNumber" linktext="EC Number" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByMetabolicPathway" linktext="Metabolic Pathway" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByProteinProteinInteraction" linktext="Y2H Interaction" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByFunctionalInteraction" linktext="Predicted Interaction" existsOn="A P"/>
                </tr>
            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Cellular Location
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesWithSignalPeptide" linktext="Signal Peptide"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByTransmembraneDomains" linktext="Transmembrane Domain" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesBySubcellularLocalization" linktext="Organellar Compartment" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByExportPrediction" linktext="Exported to Host" existsOn="A P"/>
                </tr>
            </table>
        </td>
    </tr>


    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Evolution
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesOrthologousToAGivenGene" linktext="Orthologs/Paralogs" existsOn="A P"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByOrthologPattern" linktext="Orthology Profile" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesByPhyleticProfile" linktext="Homology Profile" existsOn="A P"/>
                </tr>
            </table>
        </td>

 <td width="33%"  valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="queryCategory"><td colspan="3">Population Biology
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="GenesBySnps" linktext="SNPs" existsOn="A P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GeneQuestions" qname="NA" linktext="Microsatellites" existsOn=""/>
                </tr>
            </table>
        </td>

 
    </tr>




<%-- 
<tr><td colspan="3"><hr style="color:#003366; ></td></tr>
--%>

<%--

<tr><td colspan="3"><hr></td></tr>

    <tr>
        <td valign="top" colspan="3">
		<b>Identify Genomic Sequences Based On:</b>
         </td>
    </tr>



    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="GenomicSequenceQuestions" qname="SequencesBySimilarity" linktext="BLAST Similarity" existsOn="A C P T"  />
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GenomicSequenceQuestions" qname="NA" linktext="DNA Sequence Motif" existsOn=""/>
                </tr>
            </table>
        </td>


        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="GenomicSequenceQuestions" qname="SequenceBySourceId" linktext="ID"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="GenomicSequenceQuestions" qname="SequencesByTaxon" linktext="Species" existsOn="A P"/>
                </tr>
            </table>
        </td>
     </tr>

<tr><td colspan="3"><hr></td></tr>

     <tr>   
        <td valign="top" colspan="3">
		<b>Identify ESTs Based On:</b>
        </td>
    </tr>



    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="EstQuestions" qname="EstsByLocation" linktext="Chromosomal Location" existsOn="P T"/>
                </tr>
                <tr>
                   <site:queryGridMakeUrl qset="EstQuestions" qname="EstsWithGeneOverlap" linktext="Extent of Gene Overlap" existsOn="C P T"/> 
                </tr>
            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                
                <tr>
                    <site:queryGridMakeUrl qset="EstQuestions" qname="EstsBySimilarity" linktext="BLAST Similarity" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="EstQuestions" qname="NA" linktext="EST Sequence Motif" existsOn=""/>
                </tr>
            </table>
        </td>

        <td colspan="2" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                <tr>
                    <site:queryGridMakeUrl qset="EstQuestions" qname="EstsByLibrary" linktext="Library" existsOn="C P T"/>
                </tr>
                <tr>
                    <site:queryGridMakeUrl qset="EstQuestions" qname="EstsByTaxon" linktext="Species" existsOn=""/>
                </tr>
            </table>
        </td>
      </tr>

<tr><td colspan="3"><hr></td></tr>

     <tr>   
        <td valign="top" colspan="3">
		<b>Identify ORFs Based On:</b>
        </td>
    </tr>

<tr><td></td></tr>

    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="OrfQuestions" qname="OrfsByLocation" linktext="Chromosomal Location" existsOn="P T"/>
                </tr>

            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="OrfQuestions" qname="OrfsByMotifSearch" linktext="ORF Sequence Motif" existsOn="A C"/>
                </tr>
            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="OrfQuestions" qname="OrfsByTaxon" linktext="Species" existsOn=""/>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="OrfQuestions" qname="OrfsBySimilarity" linktext="BLAST Similarity" existsOn="A C P T"/>
                </tr>

            </table>
        </td>
        <td valign="top">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <site:queryGridMakeUrl qset="OrfQuestions" qname="OrfsByMassSpec" linktext="Mass Spec. Evidence" existsOn="C"/>
            </tr>
        </table>
    </td>
    </tr>



<tr><td colspan="3"><hr></td></tr>

     <tr>   
        <td valign="top" colspan="3">
		<b>Identify SNPs Based On:</b>
        </td>
    </tr>

    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByLocation" linktext="Chromosomal Location" existsOn="P T"/>
                </tr>
            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByGeneId" linktext="Gene ID" existsOn="P T"/>
                </tr>
            </table>
        </td>

        <td colspan="2" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <site:queryGridMakeUrl qset="SnpQuestions" qname="SnpsByAlleleFrequency" linktext="AlleleFrequency" existsOn="P"/>
                </tr>
            </table>
        </td>
      </tr>
--%>


</table>
