/**
 * 
 */
package org.apidb.apicommon.model.view.genome;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.gusdb.wdk.model.WdkModel;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.WdkUserException;
import org.gusdb.wdk.model.answer.AnswerValue;
import org.gusdb.wdk.model.answer.SummaryViewHandler;
import org.gusdb.wdk.model.dbms.SqlUtils;
import org.gusdb.wdk.model.user.Step;

/**
 * @author jerric
 * 
 */
public abstract class GenomeViewHandler implements SummaryViewHandler {

  protected static final String COLUMN_START = "start_min";
  protected static final String COLUMN_END = "end_max";
  protected static final String COLUMN_SOURCE_ID = "source_id";
  protected static final String COLUMN_SEQUENCE_ID = "sequence_id";
  protected static final String COLUMN_CHROMOSOME = "chromosome";
  protected static final String COLUMN_ORGANISM = "organism";
  protected static final String COLUMN_SEQUENCE_LENGTH = "sequence_length";
  protected static final String COLUMN_CONTEXT = "context";
  protected static final String COLUMN_STRAND = "strand";
  protected static final String COLUMN_DESCRIPTION = "description";

  private static final String PROP_SEQUENCES = "sequences";
  private static final String PROP_MAX_LENGTH = "maxLength";
  private static final String PROP_SEGMENT_SIZE = "segmentSize";
  private static final String PROP_IS_DETAIL = "isDetail";
  
  private static final String PROP_IS_TRUNCATE = "isTruncate";

  private static final long MIN_SEGMENT_SIZE = 10000;
  private static final double MAX_SEGMENTS = 100;

  private static final long MAX_FEATURES = 2000;

  private static final Logger logger = Logger.getLogger(GenomeViewHandler.class);

  public abstract String prepareSql(String idSql) throws WdkModelException,
      WdkUserException;

  /*
   * (non-Javadoc)
   * 
   * @see org.gusdb.wdk.view.SummaryViewHandler#process(org.gusdb.wdk.model.user
   * .Step)
   */
  public Map<String, Object> process(Step step) throws WdkModelException,
      WdkUserException {
    logger.debug("Entering SpanGenomeViewHandler...");
    Map<String, Object> results = new HashMap<String, Object>();

    // don't render 
    if (step.getResultSize() > MAX_FEATURES) {
        results.put(PROP_IS_TRUNCATE, "true");
        return results;
    }

    // load sequences
    Sequence[] sequences;
    ResultSet resultSet = null;
    try {
      WdkModel wdkModel = step.getQuestion().getWdkModel();
      DataSource dataSource = wdkModel.getQueryPlatform().getDataSource();

      // compose an sql to get all sequences from the feature id query.
      AnswerValue answerValue = step.getAnswerValue();
      String sql = prepareSql(answerValue.getIdSql());
      resultSet = SqlUtils.executeQuery(wdkModel, dataSource, sql,
          "genome-view", 2000);

      sequences = loadSequences(resultSet);
    } catch (SQLException ex) {
      logger.error(ex);
      ex.printStackTrace();
      throw new WdkModelException(ex);
    } finally {
      SqlUtils.closeResultSet(resultSet);
    }
    
    // check if want to display the detail view, or density view
    int maxFeatures = 0;
    for (Sequence sequence : sequences) {
      int featureCount = sequence.getFeatureCount();
      if (maxFeatures < featureCount) maxFeatures = featureCount;
    }
    
    // get the max length, then format sequences
    long maxLength = getMaxLength(sequences);
    long segmentSize = getSegmentSize(maxLength);
    logger.debug("Segment size: " + segmentSize + ", maxLength=" + maxLength);
    for (Sequence sequence : sequences) {
      // compute the percent length of a sequence.
      double pctLength = round(sequence.getLength() * 100D / maxLength);
      sequence.setPercentLength(pctLength);

      formatRegions(sequence, maxLength, segmentSize);
    }

    // only use detail view for now
    results.put(PROP_IS_DETAIL, "true");

    results.put(PROP_SEQUENCES, sequences);
    results.put(PROP_MAX_LENGTH, maxLength);
    results.put(PROP_SEGMENT_SIZE, segmentSize);
    logger.debug("Leaving SpanGenomeViewHandler...");
    return results;
  }

  private Sequence[] loadSequences(ResultSet resultSet) throws SQLException {
    Map<String, Sequence> sequences = new HashMap<String, Sequence>();
    while (resultSet.next()) {
      String sequenceId = resultSet.getString(COLUMN_SEQUENCE_ID);
      Sequence sequence = sequences.get(sequenceId);
      if (sequence == null) {
        sequence = createSequence(sequenceId, resultSet);
        sequences.put(sequenceId, sequence);
      }

      Feature feature = createFeature(sequenceId, resultSet);
      sequence.addFeature(feature);
    }
    Sequence[] array = sequences.values().toArray(new Sequence[0]);
    Arrays.sort(array);

    return array;
  }

  private Sequence createSequence(String sequenceId, ResultSet resultSet)
      throws SQLException {
    Sequence sequence = new Sequence(sequenceId);

    sequence.setLength(resultSet.getInt(COLUMN_SEQUENCE_LENGTH));
    sequence.setChromosome(resultSet.getString(COLUMN_CHROMOSOME));
    sequence.setOrganism(resultSet.getString(COLUMN_ORGANISM));

    return sequence;
  }

  private Feature createFeature(String sequenceId, ResultSet resultSet)
      throws SQLException {
    String featureId = resultSet.getString(COLUMN_SOURCE_ID);
    Feature feature = new Feature(featureId);

    feature.setSequenceId(sequenceId);
    feature.setStart(resultSet.getInt(COLUMN_START));
    feature.setEnd(resultSet.getInt(COLUMN_END));
    feature.setForward(resultSet.getBoolean(COLUMN_STRAND));
    feature.setContext(resultSet.getString(COLUMN_CONTEXT));
    feature.setDescription(resultSet.getString(COLUMN_DESCRIPTION));

    return feature;
  }

  private long getMaxLength(Sequence[] sequences) {
    long maxLength = 0;
    for (Sequence sequence : sequences) {
      if (sequence.getLength() > maxLength)
        maxLength = sequence.getLength();
    }
    return maxLength;
  }

  public void formatRegions(Sequence sequence, long maxLength, long segmentSize) {
    long sequenceLength = sequence.getLength();
    long start = 1;
    while (start <= sequenceLength) {
      // determine the start & stop of the current region.
      long stop = start + segmentSize - 1;
      if (stop > sequenceLength)
        stop = sequenceLength;

      // create two regions at the same section.
      Region region = new Region(sequence.getSourceId(), start, stop);

      double pctStart = round(start * 100D / maxLength);
      double pctLength = round((stop - start + 1) * 100D / maxLength);
      if (pctLength >= 1) pctLength -= 0.1;
      region.setPercentStart(pctStart);
      region.setPercentLength(pctLength);
      sequence.addRegion(region);

      start = stop + 1;
    }

    // assign features to regions
    for (Feature feature : sequence.getFeatures()) {
      // compute the percent location of the feature on sequence
      double pctStart = round(feature.getStart() * 100D / maxLength);
      double pctLength = round((feature.getEnd() - feature.getStart() + 1) * 100D / maxLength);
      feature.setPercentStart(pctStart);
      feature.setPercentLength(pctLength);

      List<Region> regions = sequence.getRegions(feature.getStart(),
          feature.getEnd(), feature.isForward());
      for (Region region : regions) {
        // each region should have its own copy of feature
        Feature clone = new Feature(feature);

        // format feature within the region
        long visualStart = Math.max(feature.getStart(), region.getStart());
        long visualEnd = Math.min(feature.getEnd(), region.getEnd());
        pctStart = round((visualStart - region.getStart()) * 100D / segmentSize);
        pctLength = round((visualEnd - visualStart + 1) * 100D / segmentSize);
        clone.setPercentStart(pctStart);
        clone.setPercentLength(pctLength);

        region.addFeature(clone);
      }
    }
  }

  private double round(double value) {
    return Math.round(value * 1000) / 1000D;
  }

  private long getSegmentSize(long maxLength) {
    if (maxLength <= MIN_SEGMENT_SIZE)
      return maxLength;

    if (maxLength / MAX_SEGMENTS < MIN_SEGMENT_SIZE) {
      // segments too small, each one will have min size
      return MIN_SEGMENT_SIZE;
    } else { // segments too big, will get the ceiling of the
      String strSize = Long.toString(Math.round(1.0 * maxLength / MAX_SEGMENTS));
      long lead = Math.round(Math.ceil(Long.valueOf(strSize.substring(0, 3)) / 50D) * 5);
      long size = lead * Math.round(Math.pow(10, strSize.length() - 2));
      return size;
    }
  }
}
