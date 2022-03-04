package org.apidb.apicommon.model.report;

import org.apidb.apicommon.model.TranscriptUtil;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.answer.AnswerValue;
import org.gusdb.wdk.model.columntool.byvalue.reporter.AbstractByValueReporter;
import org.gusdb.wdk.model.columntool.byvalue.reporter.ByValueNumberReporter;

public class GeneByValueNumberReporter extends ByValueNumberReporter {

  @Override
  public AbstractByValueReporter setAnswerValue(AnswerValue answerValue) throws WdkModelException {
    return super.setAnswerValue(TranscriptUtil.applyRepresentativeTranscriptFilter(answerValue));
  }

}
