package org.apidb.apicommon.model;

import java.util.Set;

import org.apidb.apicommon.model.filter.GeneBooleanFilter;
import org.apidb.apicommon.model.filter.MatchedTranscriptFilter;
import org.gusdb.fgputil.validation.ValidObjectFactory.RunnableObj;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.query.BooleanQuery;
import org.gusdb.wdk.model.query.Column;
import org.gusdb.wdk.model.query.spec.QueryInstanceSpec;
import org.gusdb.wdk.model.question.DynamicAttributeSet;
import org.gusdb.wdk.model.question.Question;
import org.gusdb.wdk.model.record.RecordClass;
import org.gusdb.wdk.model.record.attribute.ColumnAttributeField;
import org.gusdb.wdk.model.record.attribute.QueryColumnAttributeField;


public class TranscriptBooleanQuery extends BooleanQuery {

  public static final String LEFT_MATCH_COLUMN_TITLE = "Transcript Returned by Previous Search";
  public static final String RIGHT_MATCH_COLUMN_TITLE = "Transcript Returned by Latest Search";
  public static final String LEFT_MATCH_COLUMN_TITLE_DESC = "Transcript returned by your previous step (yes or no)";
  public static final String RIGHT_MATCH_COLUMN_TITLE_DESC = "Transcript returned by your latest search (yes or no)";
  public static final String LEFT_MATCH_COLUMN = "left_match";
  public static final String RIGHT_MATCH_COLUMN = "right_match";
  public static final String TR_COUNT = "gene_transcript_count";
  public static final String TR_FOUND_COUNT = "transcripts_found_per_gene";

  public TranscriptBooleanQuery() throws WdkModelException {
    super();
  }

  protected TranscriptBooleanQuery(TranscriptBooleanQuery tbq) {
    super(tbq);
  }

  private void addDynamicAttributeSetToQuestion(WdkModel wdkModel) throws WdkModelException {
    DynamicAttributeSet das = getContextQuestion().getDynamicAttributeSet();
  
    ColumnAttributeField left_af = new QueryColumnAttributeField();
    left_af.excludeResources(wdkModel.getProjectId());
    left_af.setName(LEFT_MATCH_COLUMN);
    left_af.setDisplayName(LEFT_MATCH_COLUMN_TITLE);
    das.addAttributeField(left_af);

    ColumnAttributeField right_af = new QueryColumnAttributeField();
    right_af.excludeResources(wdkModel.getProjectId());
    right_af.setName(RIGHT_MATCH_COLUMN);
    right_af.setDisplayName(RIGHT_MATCH_COLUMN_TITLE);
    das.addAttributeField(right_af);
  }

  @Override
  protected TranscriptBooleanQueryInstance makeInstance(RunnableObj<QueryInstanceSpec> spec) {
    return new TranscriptBooleanQueryInstance(spec);
  } 

  @Override
  public void setContextQuestion(Question contextQuestion) throws WdkModelException {
    super.setContextQuestion(contextQuestion);
    addDynamicAttributeSetToQuestion(_wdkModel);
    Set<String> summaryAttrsSet = contextQuestion.getRecordClass().getSummaryAttributeFieldMap().keySet();

    // we do not want to show the Y/N dynamic columns by default
    //String[] summaryAttrNames = summaryAttrsSet.toArray(new String[summaryAttrsSet.size()+2]);
    //summaryAttrNames[summaryAttrsSet.size()] = LEFT_MATCH_COLUMN;
    //summaryAttrNames[summaryAttrsSet.size()+1] = RIGHT_MATCH_COLUMN;

    // we want to show the Transcript count by default
    String[] defaultSummaryAttrNames = summaryAttrsSet.toArray(new String[summaryAttrsSet.size()+1]);
    defaultSummaryAttrNames[summaryAttrsSet.size()] = TR_COUNT;

    contextQuestion.setDefaultSummaryAttributeNames(defaultSummaryAttrNames);

    // Add GeneBooleanFilter to this specific question.  Must do so explicitly since we don't
    // want this filter to appear on all transcript steps.
    GeneBooleanFilter gbf = (GeneBooleanFilter)RecordClass.resolveStepFilterReferenceByName(
        "transcriptFilters.geneBooleanFilter", _wdkModel, "TranscriptBooleanQuery");
    contextQuestion.addFilter(gbf);

    // Ignore matched_transcript_filter_array filter since it is not applicable to this question type
    contextQuestion.addIgnoredFilterFromRecordClass(MatchedTranscriptFilter.MATCHED_TRANSCRIPT_FILTER_ARRAY_KEY);
  }

  @Override
  protected void prepareColumns(RecordClass recordClass) {
    super.prepareColumns(recordClass);
    Column column = new Column();
    column.setName(LEFT_MATCH_COLUMN);
    column.setQuery(this);
    _columnMap.put(LEFT_MATCH_COLUMN, column);
    column = new Column();
    column.setName(RIGHT_MATCH_COLUMN);
    column.setQuery(this);
    _columnMap.put(RIGHT_MATCH_COLUMN, column);
  }

  @Override
  public TranscriptBooleanQuery clone() {
    return new TranscriptBooleanQuery(this);
  }

}
