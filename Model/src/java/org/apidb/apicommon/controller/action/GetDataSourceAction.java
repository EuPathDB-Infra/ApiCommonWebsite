package org.apidb.apicommon.controller.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.gusdb.wdk.controller.action.ActionUtility;
import org.gusdb.wdk.model.AttributeValue;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.jspwrap.AnswerValueBean;
import org.gusdb.wdk.model.jspwrap.QuestionBean;
import org.gusdb.wdk.model.jspwrap.RecordBean;
import org.gusdb.wdk.model.jspwrap.UserBean;
import org.gusdb.wdk.model.jspwrap.WdkModelBean;
import org.gusdb.wdk.model.jspwrap.XmlQuestionSetBean;

public class GetDataSourceAction extends Action {

    private static final String DATA_SOURCE_ALL = "DataSourceQuestions.AllDataSources";
    public static final String DATA_SOURCE_BY_QUESTION = "DataSourceQuestions.DataSourcesByQuestionName";
    public static final String DATA_SOURCE_BY_RECORD_CLASS = "DataSourceQuestions.DataSourcesByRecordClass";

    private static final String PARAM_QUESTION = "question";
    private static final String PARAM_RECORD_CLASS = "recordClass";
    private static final String PARAM_DISPLAY_TYPE = "display";

    private static final String VALUE_DISPLAY_LIST = "list";
    private static final String VALUE_DISPLAY_DETAIL = "detail";

    private static final String ATTR_DATA_SOURCES = "dataSources";

    private static final String FORWARD_XML_LIST = "show_xml_list";
    private static final String FORWARD_XML_DETAIL = "show_xml_detail";
    private static final String FORWARD_LIST = "show_list";
    private static final String FORWARD_DETAIL = "show_detail";

    public static boolean hasXmlDataSource(WdkModelBean wdkModel) {
        XmlQuestionSetBean questionSet = wdkModel.getXmlQuestionSetsMap().get(
                "XmlQuestions");
        if (questionSet == null)
            return false;
        return questionSet.getQuestionsMap().containsKey("DataSources");
    }

    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        WdkModelBean wdkModel = ActionUtility.getWdkModel(servlet);
        UserBean user = ActionUtility.getUser(servlet, request);

        String questionName = request.getParameter(PARAM_QUESTION);
        String rcName = request.getParameter(PARAM_RECORD_CLASS);
        String displayType = request.getParameter(PARAM_DISPLAY_TYPE);

        String forwardList, forwardDetail;

        // check if xml data source exists, if so, redirect to it
        if (hasXmlDataSource(wdkModel)) {
            forwardList = FORWARD_XML_LIST;
            forwardDetail = FORWARD_XML_DETAIL;
        } else {
            // xml data source doesn't exist, query from database
            forwardList = FORWARD_LIST;
            forwardDetail = FORWARD_DETAIL;

            QuestionBean question;
            Map<String, String> params = new LinkedHashMap<String, String>();
            if (questionName != null) {
                question = wdkModel.getQuestion(DATA_SOURCE_BY_QUESTION);
                params.put("question_name", questionName);
            } else if (rcName != null) {
                question = wdkModel.getQuestion(DATA_SOURCE_BY_RECORD_CLASS);
                params.put("record_class", rcName);
            } else {
                question = wdkModel.getQuestion(DATA_SOURCE_ALL);
            }
            AnswerValueBean answerValue = question.makeAnswerValue(user,
                    params, 0);

            Map<String, List<RecordBean>> categories = formatAnswer(answerValue);
            request.setAttribute(ATTR_DATA_SOURCES, categories);
        }

        if (displayType == null || displayType.length() == 0)
            displayType = VALUE_DISPLAY_DETAIL;

        if (displayType.equals(VALUE_DISPLAY_LIST))
            return mapping.findForward(forwardList);
        else if (displayType.equals(VALUE_DISPLAY_DETAIL))
            return mapping.findForward(forwardDetail);
        else
            throw new WdkUserException("Unknown display type: " + displayType);
    }

    /**
     * Group data sources by category
     * 
     * @param request
     * @param answerValue
     * @throws Exception
     */
    private Map<String, List<RecordBean>> formatAnswer(
            AnswerValueBean answerValue)
            throws Exception {
        Map<String, List<RecordBean>> categories = new LinkedHashMap<String, List<RecordBean>>();
        Iterator<RecordBean> records = answerValue.getRecords();
        while (records.hasNext()) {
            RecordBean record = records.next();
            Map<String, AttributeValue> attributeValues = record
                    .getAttributes();
            String category = attributeValues.get("categories").toString();
            List<RecordBean> list = categories.get(category);
            if (list == null) {
                list = new ArrayList<RecordBean>();
                categories.put(category, list);
            }
            list.add(record);
        }
        return categories;
    }
}
