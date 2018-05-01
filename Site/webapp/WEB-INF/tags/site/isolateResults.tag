<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="pg" uri="http://jsptags.com/tags/navigation/pager" %>
<%@ taglib prefix="imp" tagdir="/WEB-INF/tags/imp" %>

<%@ attribute name="step"
              type="org.gusdb.wdk.model.jspwrap.StepBean"
              required="true"
              description="Step bean we are looking at" %>

<c:set var="wdkStep" value="${requestScope.wdkStep}"/>

<c:set var="modelName" value="${applicationScope.wdkModel.name}" />

<c:set var="dispModelName" value="${applicationScope.wdkModel.displayName}" />
<c:set var="wdkAnswer" value="${wdkStep.answerValue}"/>
<c:set var="wdkViewAnswer" value="${step.viewAnswerValue}"/>
<c:set var="qName" value="${wdkAnswer.question.fullName}" />
<c:set var="recordClass" value="${wdkAnswer.question.recordClass}" />
<c:set var="recordName" value="${recordClass.fullName}" />

<c:set var="displayName" value="${step.recordClass.displayName}"/>
<c:set var="displayNamePlural" value="${wdkAnswer.question.recordClass.displayNamePlural}" />
<c:set var="nativeDisplayNamePlural" value="${wdkAnswer.question.recordClass.nativeDisplayNamePlural}" />

<c:set var="recHasBasket" value="${recordClass.useBasket}" />
<c:set var="wdkView" value="${requestScope.wdkView}" />
<c:set var="isBasket" value="${fn:contains(step.questionName, 'ByRealtimeBasket')}"/>

<c:set var="clustalwIsolatesCount" value="0" />
<c:set var="eupathIsolatesQuestion">${fn:containsIgnoreCase(recordName, 'PopsetRecordClasses.PopsetRecordClass') }</c:set> 
<c:set var="type" value="${wdkStep.recordClass.displayNamePlural}"/>

<%-- catch raised exception so we can show the user a nice message --%>
<c:catch var="answerValueRecords_exception">
  <%-- FIXME This should probably be logged to wdk logger --%>
  <c:set var="answerRecords" value="${wdkViewAnswer.records}" />
</c:catch>

<c:choose>

<%-- Handle exception raised when accessing answerValue, when we're viewing a basket --%>
<c:when test='${answerValueRecords_exception ne null and isBasket}'>
  <div class="ui-widget">
    <div class="ui-state-error ui-corner-all" style="padding:8px;">
      <p>
        <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
        <div><imp:verbiage key="answer-value-records-error-msg.basket.content"/></div>
      </p>
    </div>
  </div>
</c:when>
<%-- Handle exception raised when accessing answerValue, when we're viewing a step result --%>
<c:when test='${answerValueRecords_exception ne null}'>
  <div class="ui-widget">
    <div class="ui-state-error ui-corner-all" style="padding:8px;">
      <p>
        <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
          <div><imp:verbiage key="answer-value-records-error-msg.default.content"/></div>
      </p>
    </div>
  </div>
</c:when>
    
<c:when test='${wdkviewAnswer.resultSize == 0}'>
     No results are retrieved
</c:when>

<c:otherwise>

  <!-- pager -->
  <pg:pager isOffset="true"
                  scope="request"
                  items="${wdk_paging_total}"
                  maxItems="${wdk_paging_total}"
                  url="${requestUri}"
                  maxPageItems="${wdk_paging_pageSize}"
                  export="offset,currentPageNumber=pageNumber">
    <c:forEach var="paramName" items="${wdk_paging_params}">
            <pg:param name="${paramName}" id="pager" />
    </c:forEach>
    <c:if test="${wdk_summary_checksum != null}">
            <pg:param name="summary" id="pager" />
    </c:if>
    <c:if test="${wdk_sorting_checksum != null}">
            <pg:param name="sort" id="pager" />
    </c:if>


    <%--------- PAGING TOP BAR ----------%>
    <c:url var="commandUrl" value="/processSummaryView.do?step=${wdkStep.stepId}&view=${wdkView.name}&pager.offset=${offset}" />
    <table id="paging-top-bar" width="100%">
      <tr class="subheaderrow">
        <th style="text-align: left;white-space:nowrap;"> 
                 <imp:pager wdkAnswer="${wdkAnswer}" pager_id="top"/> 
        </th>

        <th style="text-align: right; white-space: nowrap; width: 33px;">
          <c:if test="${wdkViewAnswer.resultSize > 0}">

                        <imp:additionalResultTableLinks step="${step}"/>

                        <c:choose>
                          <c:when test="${wdkUser.guest}">
                            <c:set var="basketClick" value="wdk.user.login('use baskets');" />
                          </c:when>
                          <c:otherwise>
                            <c:set var="basketClick" value="wdk.basket.updateBasket(this, '${step.stepId}', '0', '0', '${recordName}');" /> <!-- fourth param is unused (basket.js) -->
                          </c:otherwise>
                        </c:choose>

                        <c:set var="summaryViewName" value="${empty requestScope.wdkView.name ? '_default' : requestScope.wdkView.name}"/>
                        <c:url var="downloadLink" value="app/step/${step.stepId}/download?summaryView=${summaryViewName}"/>
                        <a class="step-download-link" style="padding-right: 1em;" href="${downloadLink}"><b>Download</b></a>

                        <c:if test="${recHasBasket}">
                          <a style="padding-right: 1em;" id="basketStep" href="javascript:void(0)" onClick="${basketClick}">
                            <b>Add to Basket</b>
                          </a>
                        </c:if>
                      </c:if>
                      <imp:addAttributes wdkAnswer="${wdkViewAnswer}" commandUrl="${commandUrl}"/>
        </th>

        <%--
          <th style="text-align: right;white-space:nowrap;">
                 <imp:addAttributes wdkAnswer="${wdkAnswer}" commandUrl="${commandUrl}"/>
          </th>
        --%>
      </tr>
    </table>
    <%--------- END OF PAGING TOP BAR ----------%>
          

    <c:if test = "${eupathIsolatesQuestion}">
          <form name="checkHandleForm" method="post" action="/dosomething.jsp" onsubmit="return false;"> 
    </c:if>

    <!-- content of current page -->
    <c:set var="sortingAttrNames" value="${wdkAnswer.sortingAttributeNames}" />
    <c:set var="sortingAttrOrders" value="${wdkAnswer.sortingAttributeOrders}" />

    <%--------- RESULTS  ----------%>

    <!-- these 3? divs are needed for the basket to work (click on basket icon to select all IDs), not for css really  -->
    <div class="Results_Div flexigrid">
      <div class="bDiv">
        <div class="bDivBox">

        <table class="Results_Table" width="100%" step="${wdkStep.stepId}">
        <thead>
        <tr class="headerrow">

          <c:if test="${recHasBasket}">
            <th>
              <c:choose>
                <c:when test="${wdkUser.guest}">
                  <c:set var="basketClick" value="wdk.user.login('use baskets')" />
                </c:when>
                <c:otherwise>
                  <c:set var="basketClick" value="wdk.basket.updateBasket(this,'page', '0', '${modelName}', '${wdkAnswer.recordClass.fullName}')" />
                </c:otherwise>
              </c:choose>
              <a href="javascript:void(0)" onclick="${basketClick}">
                <imp:image class="head basket" src="wdk/images/basket_gray.png" height="16" width="16" value="0"/>
              </a>
            </th>
          </c:if>

          <c:set var="j" value="0"/>
          <c:forEach items="${wdkAnswer.summaryAttributes}" var="sumAttrib">
            <c:set var="attrName" value="${sumAttrib.name}" />
            <th id="${attrName}" align="left" valign="middle">
              <table>
                <tr>
                  <td>
                    <table>
                      <tr>
                        <td style="padding:0;">
                          <c:choose>
                            <c:when test="${!sumAttrib.sortable}">
                              <imp:image src="wdk/images/results_arrw_up_blk.png" border="0" alt="Sort up"/>
                            </c:when>
                            <c:when test="${attrName == sortingAttrNames[0] && sortingAttrOrders[0]}">
                              <imp:image src="wdk/images/results_arrw_up_gr.png"  alt="Sort up" 
                                  title="Result is sorted by ${sumAttrib}" />
                            </c:when>
                            <c:otherwise>
                              <%-- display sorting buttons --%>
                              <c:set var="resultsAction" value="javascript:wdk.resultsPage.getResultsPage('${commandUrl}&command=sort&attribute=${attrName}&sortOrder=asc', true, true)" />
                              <a href="${resultsAction}" title="Sort by ${sumAttrib}">
                                <imp:image src="wdk/images/results_arrw_up.png" alt="Sort up" border="0" />
                              </a>
                            </c:otherwise>
                          </c:choose> 
                        </td>
                      </tr>
                      <tr>  
                        <td style="padding:0;">
                  <c:choose>
                    <c:when test="${!sumAttrib.sortable}">
                       <imp:image src="wdk/images/results_arrw_dwn_blk.png" border="0" />
                    </c:when>
                    <c:when test="${attrName == sortingAttrNames[0] && !sortingAttrOrders[0]}">
                      <imp:image src="wdk/images/results_arrw_dwn_gr.png" alt="Sort down" 
                              title="Result is sorted by ${sumAttrib}" />
                    </c:when>
                    <c:otherwise>
                      <%-- display sorting buttons --%>
                      <c:set var="resultsAction" value="javascript:wdk.resultsPage.getResultsPage('${commandUrl}&command=sort&attribute=${attrName}&sortOrder=desc', true, true)" />
                      <a href="${resultsAction}" title="Sort by ${sumAttrib}">
                      <imp:image src="wdk/images/results_arrw_dwn.png" alt="Sort down" border="0" /></a>
                    </c:otherwise>
                  </c:choose>
                           </td>
                         </tr>
                       </table>
                     </td>
               <td><span title="${sumAttrib.help}">${sumAttrib.displayName}</span></td>

                <c:if test="${j != 0}">
                  <td style="width:20px;">
                    <%-- display remove attribute button --%>
                    <c:set var="resultsAction" value="javascript:wdk.resultsPage.getResultsPage('${commandUrl}&command=remove&attribute=${attrName}', true, true)" />
                    <a href="${resultsAction}"
                                title="Remove ${sumAttrib} column">
                      <imp:image src="wdk/images/results_x.png" alt="Remove" border="0" /></a>
                  </td>
                </c:if>

        <!-- NEW as in wdk:resultsTable -->
                    <td>
                      <imp:attributePlugin attribute="${sumAttrib}" />
                    </td>

                 </tr>
              </table>
            </th>
          <c:set var="j" value="${j+1}"/>
          </c:forEach>
        </tr>
        </thead>



        <tbody class="rootBody">

        <c:set var="i" value="0"/>


        <!-- FOR EACH ROW -->
        <c:forEach items="${wdkAnswer.records}" var="record">

            <c:set value="${record.primaryKey}" var="primaryKey"/>
        <c:choose>
          <c:when test="${i % 2 == 0}"><tr class="lines"></c:when>
          <c:otherwise><tr class="linesalt"></c:otherwise>
        </c:choose>

          <c:if test="${recHasBasket}">
                  <td>
                    <c:set var="basket_img" value="basket_gray.png"/>
                    <c:choose>
                      <c:when test="${!wdkUser.guest}">
                  <c:set value="${record.attributes['in_basket']}" var="is_basket"/>
                        <c:set var="basketTitle" value="Click to add this item to the basket." />
                  <c:if test="${is_basket == '1'}">
                    <c:set var="basket_img" value="basket_color.png"/>
                          <c:set var="basketTitle" value="Click to remove this item from the basket." />
                        </c:if>
                        <c:set var="basketClick" value="wdk.basket.updateBasket(this, 'single', '${record.idAttributeValue.value}', '${modelName}', '${recordName}')" />
                      </c:when>
                      <c:otherwise>
                        <c:set var="basketTitle" value="Please log in to use the basket." />
                      </c:otherwise>
                    </c:choose>
              <a href="javascript:void(0)" onclick="${basketClick}">
                <imp:image title="${basketTitle}" class="basket" value="${is_basket}" src="wdk/images/${basket_img}" width="16" height="16"/>
              </a>
                  </td>
          </c:if>

          <c:set var="j" value="0"/>


        <!-- FOR EACH COLUMN -->
          <c:forEach items="${wdkAnswer.summaryAttributeNames}" var="sumAttrName">
            <c:set value="${record.attributes[sumAttrName]}" var="recAttr"/>

        <!-- ~~~~~~~~~~~~~ IN wdkAttribute.tag for data types using wdk default view ~~~~~~~~~~~~~~~~~ -->

            <c:set var="align" value="align='${recAttr.attributeField.align}'" />
            <c:set var="nowrap">
                <c:if test="${j == 0 || recAttr.attributeField.nowrap}">white-space:nowrap;</c:if>
            </c:set>
            <c:set var="pkValues" value="${primaryKey.values}" />
            <c:set var="projectId" value="${pkValues['project_id']}" />
            <c:set var="id" value="${pkValues['source_id']}" />
            <c:set var="recNam" value="${record.recordClass.fullName}"/>
            <c:set var="fieldVal" value="${recAttr.briefDisplay}"/>
            
            <td ${align} style="${nowrap}padding:3px 2px">
            <div class="attribute-summary">    
              <c:choose>
                <c:when test="${j == 0}"> <!-- ID column -->

                  <!-- hidden div, this might be used by js -->
                  <div class="primaryKey" fvalue="${fieldVal}" style="display:none;">
                    <c:forEach items="${pkValues}" var="pkValue">
                      <span key="${pkValue.key}">${pkValue.value}</span>
                    </c:forEach>
                  </div>

                  <c:choose>
                    <c:when test = "${eupathIsolatesQuestion}">
                      <a href="showRecord.do?name=${recNam}&source_id=${id}&project_id=${projectId}">${fieldVal}</a><input type="checkbox" name="selectedFields" style="margin-top: 0px; margin-bottom: 0px;" value="${record.idAttributeValue.value}">
                      <c:set var="clustalwIsolatesCount" value="${clustalwIsolatesCount + 1}"/>
                    </c:when>
                    <c:otherwise>
                      <a class="primaryKey_||_${id}" href="showRecord.do?name=${recNam}&project_id=${projectId}&source_id=${id}">${fieldVal}</a>
                    </c:otherwise>
                  </c:choose>

                </c:when>

                <c:otherwise> <!-- OTHER COLUMNS -->
                  <!-- need to know if fieldVal should be hot linked -->
                  <c:choose>
                    <c:when test="${fieldVal == null || fn:length(fieldVal) == 0}">
                      <span style="color:gray;">N/A</span>
                    </c:when>
                    <c:when test="${recAttr.class.name eq 'org.gusdb.wdk.model.record.attribute.LinkAttributeValue'}">
                      <a href="${recAttr.url}">${recAttr.displayText}</a>
                    </c:when>
                    <c:otherwise>
                      ${fieldVal}
                    </c:otherwise>
                  </c:choose>
                </c:otherwise>

              </c:choose>
            </div>
            </td>

        <!-- ~~~~~~~~~~~~~ END OF  wdkAttribute.tag ~~~~~~~~~~~~~~~~~ -->


            <c:set var="j" value="${j+1}"/>
          </c:forEach>


        </tr>
        <c:set var="i" value="${i+1}"/>
        </c:forEach>

        </tr>

        </tbody>
        </table>

        </div>
      </div>
    </div>

    <%--------- END OF RESULTS  ----------%>

    <c:if test = "${eupathIsolatesQuestion && clustalwIsolatesCount > 1}">
      <table width="100%">
        <tr align=center>
          <td> <b><br/> 
            Please select at least two isolates to run Clustalw. Note: only isolates from a single page will be aligned. <br/>
            The result is an alignment of the locus that was used to type the isolates.<br/>
            (Increase the page size in 'Advanced Paging' to increase the number that can be aligned).  </b>
          </td>
        </tr>

        <tr>
          <td align=center> 
              <input type="button" value="Run Clustalw on Checked Strains" 
                onClick="goToIsolate(this)" />
              <input type="button" name="CheckAll" value="Check All" 
                onClick="wdk.api.checkboxAll(jQuery('input:checkbox[name=selectedFields]'))">
              <input type="button" name="UnCheckAll" value="Uncheck All" 
                onClick="wdk.api.checkboxNone(jQuery('input:checkbox[name=selectedFields]'))">
          </td>
        </tr>

      </table>
    </c:if>

    <c:if test = "${eupathIsolatesQuestion}">
          </form>
    </c:if>


    <%--------- PAGING BOTTOM BAR ----------%>
    <table width="100%" border="0" cellpadding="3" cellspacing="0">
      <tr class="subheaderrow">
        <th style="text-align:left;white-space:nowrap;"> 
                 <imp:pager wdkAnswer="${wdkAnswer}" pager_id="bottom"/> 
        </th>
      </tr>
    </table>
    <%--------- END OF PAGING BOTTOM BAR ----------%>

  </pg:pager>

</c:otherwise>
</c:choose>
