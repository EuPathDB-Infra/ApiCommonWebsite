package org.apidb.apicommon.model.view;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apidb.apicommon.model.filter.RepresentativeTranscriptFilter;
import org.gusdb.fgputil.FormatUtil;
import org.gusdb.wdk.controller.summary.ResultTablePaging;
import org.gusdb.wdk.controller.summary.SummaryTableUpdateProcessor;
import org.gusdb.wdk.model.TreeNode;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.answer.AnswerValueAttributes;
import org.gusdb.wdk.model.answer.SummaryViewHandler;
import org.gusdb.wdk.model.jspwrap.AnswerValueBean;
import org.gusdb.wdk.model.jspwrap.StepBean;
import org.gusdb.wdk.model.jspwrap.UserBean;
import org.gusdb.wdk.model.record.attribute.AttributeField;
import org.gusdb.wdk.model.user.Step;
import org.gusdb.wdk.model.user.User;
import org.json.JSONObject;

public class GeneViewHandler implements SummaryViewHandler {

  private static final Logger LOG = Logger.getLogger(GeneViewHandler.class);

  private static final String GENE_FILTERED_STEP = "geneFilteredStep";
  private static final String USER_PREFERENCE_SUFFIX = "_geneview";
  private static final String PRIMARY_KEY_FIELD = "primary_key";
  private static final String TRANSCRIPT_CATEGORY_NAME = "trans_parent";

  @Override
  public Map<String, Object> process(Step step, Map<String, String[]> parameters,
      User user, WdkModel wdkModel) throws WdkModelException, WdkUserException {

    // check to see if this request is asking to write summary attributes, sorting, or paging?
    LOG.info(FormatUtil.paramsToString(parameters));

    boolean filterOn = (step.getViewFilterOptions()
        .getFilterOption(RepresentativeTranscriptFilter.FILTER_NAME) != null);

    // if filter is not already applied (i.e. by checkbox in transcript view), then add it to in-memory step
    if (!filterOn) {
      step = new Step(step);
      step.addViewFilterOption(RepresentativeTranscriptFilter.FILTER_NAME, new JSONObject());
    }

    UserBean userBean = new UserBean(user);
    StepBean stepBean = new StepBean(userBean, step);
    AnswerValueBean answer = stepBean.getViewAnswerValue();
    answer.getRecords();
    Map<String, Object> model = ResultTablePaging.processPaging(
        parameters, stepBean.getQuestion(), userBean, answer);

    // override available attributes
    AnswerValueAttributes attributes = answer.getAnswerValue().getAttributes();
    TreeNode root = attributes.getDisplayableAttributeTree();
    root.remove(TRANSCRIPT_CATEGORY_NAME);
    attributes.overrideDisplayableAttributeTree(root);

    // override summary attributes
    AttributeField pkField = stepBean.getQuestion().getRecordClass()
        .getPrimaryKeyAttribute().getPrimaryKeyAttributeField();
    Map<String, AttributeField> summaryFields = AnswerValueAttributes
        .buildSummaryAttributeFieldMap(user, step.getQuestion(), USER_PREFERENCE_SUFFIX, pkField);
    LOG.debug("Summary Attribs BEFORE: " + FormatUtil.arrayToString(summaryFields.keySet().toArray()));
    trimAttribsNotInTree(summaryFields, root);
    LOG.debug("Summary Attribs AFTER: " + FormatUtil.arrayToString(summaryFields.keySet().toArray()));
    attributes.overrideSummaryAttributeFieldMap(summaryFields);

    // pass the new step to the JSP to be rendered instead of the normal step
    model.put(GENE_FILTERED_STEP, stepBean);
    return model;
  }

  private static void trimAttribsNotInTree(Map<String, AttributeField> attributes, TreeNode attributeTree) {
    List<String> origNames = new ArrayList<>(attributes.keySet());
    for (String name : origNames) {
      // remove if not in tree, but skip primary key (i.e. don't remove)
      if (name.equals(PRIMARY_KEY_FIELD)) continue;
      if (attributeTree.find(name) == null) {
        attributes.remove(name);
      }
    }
  }

  @Override
  public String processUpdate(Step step, Map<String, String[]> parameters, User user, WdkModel wdkModel)
      throws WdkModelException, WdkUserException {
    return SummaryTableUpdateProcessor.processUpdates(step, parameters, user, wdkModel, USER_PREFERENCE_SUFFIX);
  }
}
