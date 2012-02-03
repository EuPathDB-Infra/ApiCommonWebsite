<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>

<!-- get wdkModel saved in application scope -->
<c:set var="wdkModel" value="${applicationScope.wdkModel}"/>

<!-- get wdkModel name to display as page header -->
<imp:header title="PlasmoDB : correlated gene expression"
                 banner="Mapping Time Points between Time Courses"
                 parentDivision="PlasmoDB"
                 parentUrl="/home.jsp"
                 divisionName="Queries & Tools"
                 division="queries"/>

<table border=0 width=100% cellpadding=3 cellspacing=0 bgcolor=white class=thinTopBottomBorders> 

  <tr>
    <td>
      <div class="small">
        <!-- content-->
        Several features of PlasmoDB rely upon determining which time point
        in one intraerythrocytic gene expression time course is most similar to that in
        another.  For example, we might expect the "early rings" data from the Winzeler
        Lab sorbitol-synchronized time course to be most similar to hour 7 or so in the
        DeRisi Lab strain HB3 time course.  Such a mapping was determined using rank
        correlation coefficients correlating gene expression levels from one array
        (i.e., one time point) to those from another array in another study.  For
        example, the graph below shows correlations levels between DeRisi strain HB3
        time points and Winzeler sorbitol-synchronized time points.  Indeed, the Affy
        "early rings" data (the red curve) is most similar to glass slide hour 7 (the
        maximum correlation).
      </div>
    </td>
  </tr>

  <tr align="center">
    <td>
      <img src="images/winz_sorb_ratios_derisi_ratios_correlation.png" border=1>
    </td>
  </tr>

  <tr>
    <td>
      <div class="small">
        The graph below shows the correspondence between time points as provided
        by the maximal correlations in the above graph.  The dot in the lower
        left corner, for instance, indicates the correspondence between the
        "early rings" data and hour 7 data.
      </div>
    </td>
  </tr>

  <tr align="center">
    <td>
      <img src="images/w.s.d.hb3.rankCorr.tpMap.png" border=1>
    </td>
  </tr>

  <tr>
    <td>
      <div class="small">
        The graph below provides a similar view when comparing the DeRisi
        strains 3D7 and HB3 time courses.  Note that the first few time points
        of the 3D7 time course correspond most closely with time points at the
        end of the HB3 erythrocytic cycle.  Whereas this is indeed the case,
        these time points were projected down to the beginning of the HB3 cycle
        by means of the best fit line through time points four through
        fifty-three of the 3D7 study (this line given in red).  Time points
        four through fifty-three were also projected onto this line so as to
        avoid multiple 3D7 time points mapping to the same HB3 time point.
        Finally, time points thus mapped to the red line where shifted up
        slightly (to the line shown in purple) so that the first 3D7 time point
        does not map below HB3 hour 1.
      </div>
    </td>
  </tr>

  <tr align="center">
    <td>
      <img src="images/d.3d7.d.hb3.rankCorr.tpMap.png" border=1>
    </td>
  </tr>

  <tr>
    <td>
      <div class="small">
        Finally, time points from the five major intraerythrocytic time courses
        (GS_HB3, GS_3D7, and GS_Dd2 generated by the DeRisi Lab and exploring
        several strains; and Affy_S and Affy_T generated by the Winzeler Lab and
        exploring sorbitol- and temperature-synchronizations) were mapped to the
        glass slide strain HB3 time course to facilitate queries across all five
        time courses and display of multiple gene expression profiles at the
        same time.  The display below summarizes all such time point mappings.
        Note that the glass slide strain HB3 time course is missing time points
        at hours 23 and 29 and also that the strain 3D7 erythrocytic cycle is
        somewhat shorter than that in strain HB3 (as also shown in the graph
        above).
      </div>
    </td>
  </tr>

  <tr align="center">
    <td>
      <img src="images/tpMapLabeled.png" border=1>
    </td>
  </tr>
</table>

<imp:footer/>
