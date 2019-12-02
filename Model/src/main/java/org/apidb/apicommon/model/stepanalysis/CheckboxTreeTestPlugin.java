package org.apidb.apicommon.model.stepanalysis;

import org.gusdb.fgputil.functional.TreeNode;
import org.gusdb.wdk.model.FieldTree;
import org.gusdb.wdk.model.SelectableItem;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.analysis.AbstractStepAnalyzer;
import org.gusdb.wdk.model.answer.AnswerValue;
import org.gusdb.wdk.model.user.analysis.ExecutionStatus;
import org.gusdb.wdk.model.user.analysis.StatusLogger;
import org.json.JSONArray;
import org.json.JSONObject;

public class CheckboxTreeTestPlugin extends AbstractStepAnalyzer {

  private static final String CHECKBOX_TREE_KEY = "myTree";
  
  private FieldTree createFormViewModel() {
    FieldTree tree = buildTreeParam();
    tree.addDefaultLeaves("value2", "value3", "value6");
    return tree;
  }
  
  @Override
  public JSONObject getFormViewModelJson() throws WdkModelException {
    return createFormViewModel().toJson();
  }

  private FieldTree buildTreeParam() {
    FieldTree tree = new FieldTree(new SelectableItem("root", "Root", "This is the root value."));
    TreeNode<SelectableItem> root = tree.getRoot();

    TreeNode<SelectableItem> branch1 = new TreeNode<>(new SelectableItem("branch1", "Branch 1"));
    branch1.addChild(new SelectableItem("value1", "Value 1"));
    branch1.addChild(new SelectableItem("value2", "Value 2"));
    root.addChildNode(branch1);

    TreeNode<SelectableItem> branch2 = new TreeNode<>(new SelectableItem("branch2", "Branch 2"));
    branch2.addChild(new SelectableItem("value3", "Value 3"));
    branch2.addChild(new SelectableItem("value4", "Value 4"));
    root.addChildNode(branch2);

    root.addChild(new SelectableItem("value5", "Value 5"));
    root.addChild(new SelectableItem("value6", "Value 6"));
    return tree;
  }
  
  @Override
  public JSONObject getResultViewModelJson() throws WdkModelException {
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    for (String option : getFormParams().get(CHECKBOX_TREE_KEY)) jsonArray.put(option);
    json.put(CHECKBOX_TREE_KEY, jsonArray);
    return json;
  }

  @Override
  public ExecutionStatus runAnalysis(AnswerValue answerValue, StatusLogger log) throws WdkModelException {
    // nothing to do; just testing retention of checkbox tree values
    return ExecutionStatus.COMPLETE;
  }
}
