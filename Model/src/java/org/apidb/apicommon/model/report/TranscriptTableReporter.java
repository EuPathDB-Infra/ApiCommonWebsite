package org.apidb.apicommon.model.report;

import java.util.HashMap;
import java.util.Map;

import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.answer.AnswerValue;
import org.gusdb.wdk.model.question.Question;
import org.gusdb.wdk.model.report.AttributesColumnarReporter;
import org.gusdb.wdk.model.user.UserFactory;
import org.json.JSONObject;

public class TranscriptTableReporter extends AttributesColumnarReporter {
  
  public static final String PROP_USER_ID = "userId";
  private Integer userId = null;
  
  public static final String PROP_STEP_ID = "stepId";
  private String stepId = null;

  public TranscriptTableReporter(AnswerValue answerValue, int startIndex, int endIndex) {
    super(answerValue, startIndex, endIndex);
  } 
  
  @Override
  public void configure(Map<String, String> config) {
    throw new UnsupportedOperationException();
  }

  @Override
  public void configure(JSONObject config) {
    super.configure(config);
    userId = config.getInt(PROP_USER_ID);
    stepId = config.getString(PROP_STEP_ID);
  }
  
  @Override
  public void initialize() throws WdkModelException {
    if (userId == null) throw new WdkModelException("Missing required reporter property: " + PROP_USER_ID);
    if (stepId == null) throw new WdkModelException("Missing required reporter property: " + PROP_STEP_ID); 
    WdkModel model = baseAnswer.getQuestion().getWdkModel();
    String xformQuestionName = "GeneRecordQuestions.GenesFromTranscripts";
    Question question = model.getQuestion(xformQuestionName);
    if (question == null) throw new WdkModelException("Can't find xform with name: " + xformQuestionName);
    UserFactory userFactory = new UserFactory(model);
    Map<String, String> params = new HashMap<String, String>();
    String paramName = "gene_result";
    if (question.getParamMap().size() != 1
          || !question.getParamMap().containsKey(paramName))
      throw new WdkModelException("Expected question " + xformQuestionName + " to have exactly one parameter named " + paramName);
    params.put(paramName, stepId);
    try {
      baseAnswer = question.makeAnswerValue(userFactory.getUser(userId), params, true, 10);
    } catch (WdkUserException e) {
      throw new WdkModelException(e);
    }
  }

}
