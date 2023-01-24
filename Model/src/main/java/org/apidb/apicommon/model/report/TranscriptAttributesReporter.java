package org.apidb.apicommon.model.report;

import java.util.Map;

import org.apache.log4j.Logger;
import org.apidb.apicommon.model.TranscriptUtil;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.report.ReporterConfigException;
import org.gusdb.wdk.model.report.reporter.AttributesTabularReporter;
import org.json.JSONObject;

public class TranscriptAttributesReporter extends AttributesTabularReporter {

  @SuppressWarnings("unused")
  private static final Logger logger = Logger.getLogger(TranscriptAttributesReporter.class);

  private Boolean _applyFilter;

  @Override
  public TranscriptAttributesReporter configure(Map<String, String> config) {
    throw new UnsupportedOperationException();
  }

  @Override
  public TranscriptAttributesReporter configure(JSONObject config) throws ReporterConfigException {
    super.configure(config);
    _applyFilter = TranscriptUtil.getApplyOneGeneFilterProp(config);
    return this;
  }
  
  /**
   * Create a new AnswerValue, and apply filter, if user has asked for the filter
   */
  @Override
  public void initialize() throws WdkModelException {
    if (_applyFilter) _baseAnswer = TranscriptUtil.getOneGenePerTranscriptAnswerValue(_baseAnswer);
  }
}
