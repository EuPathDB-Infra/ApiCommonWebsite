package org.apidb.apicommon.model.stepanalysis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.gusdb.fgputil.ListBuilder;
import org.gusdb.fgputil.xml.NamedValue;
import org.apache.log4j.Logger;
import org.gusdb.fgputil.FormatUtil;
import org.gusdb.fgputil.FormatUtil.Style;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.analysis.AbstractStepAnalyzer;
import org.gusdb.wdk.model.answer.AnswerValue;
import org.gusdb.wdk.model.user.analysis.ExecutionStatus;
import org.gusdb.wdk.model.user.analysis.StatusLogger;
import org.json.JSONArray;
import org.json.JSONObject;

public class FormTestPlugin extends AbstractStepAnalyzer {

  private static final Logger LOG = Logger.getLogger(FormTestPlugin.class);

  public static class FormViewModel {
    private List<NamedValue> _selectOptions;
    public List<NamedValue> getSelectOptions() {
      return _selectOptions;
    }
    public void setSelectOptions(List<NamedValue> selectOptions) {
      _selectOptions = selectOptions;
    }

   public JSONObject toJson() {
     JSONObject json = new JSONObject();
     JSONArray jsonarray = new JSONArray();
     for (NamedValue nv : getSelectOptions()) jsonarray.put(nv.toJson());
     json.put("selectOptions", jsonarray);
     return json;
   }
  }

  @Override
  public ExecutionStatus runAnalysis(AnswerValue answerValue, StatusLogger log) throws WdkModelException {
    Map<String,String[]> params = getFormParams();
    Map<String,String> prettyParams = new HashMap<>();
    for (String key : params.keySet()) {
      prettyParams.put(key, FormatUtil.arrayToString(params.get(key)));
    }
    String result = FormatUtil.prettyPrint(prettyParams, Style.MULTI_LINE);
    LOG.info("Form test plugin setting following result:\n" + result);
    setPersistentCharData(result);
    return ExecutionStatus.COMPLETE;
  }

  @Override
  public JSONObject getResultViewModelJson() {
    JSONObject json = new JSONObject();
    json.put("persistentCharData", getPersistentCharData());
    return json;
  }

  @Override
  public JSONObject getFormViewModelJson() {
    return createFormViewModel().toJson();
  }

  private FormViewModel createFormViewModel() {
    FormViewModel model = new FormViewModel();
    model.setSelectOptions(new ListBuilder<NamedValue>()
        .add(new NamedValue("Value 1", "val1"))
        .add(new NamedValue("Value 2", "val2"))
        .add(new NamedValue("Value 3", "val3"))
        .toList());
    return model;
  }

}
