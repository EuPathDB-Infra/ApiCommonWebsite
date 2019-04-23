import { get } from 'lodash';
import React from 'react';
import { connect } from 'react-redux';

import {
  isTranscripFilterEnabled,
  requestTranscriptFilterUpdate
} from '../../util/transcriptFilters';

// --------------
// GeneRecordLink
// --------------

function GeneRecordLink(props) {
  const { recordId, geneRecordClass, children } = props;
  const geneId = recordId
    .filter(part => part.name !== 'source_id')
    .map(part => part.name === 'gene_source_id' ? { ...part, name: 'source_id' } : part);
  return <props.DefaultComponent
    recordClass={geneRecordClass}
    recordId={geneId}
  >{children}</props.DefaultComponent>
}

const mapStateToGeneRecordLinkProps = state => ({
  geneRecordClass: state.globalData.recordClasses
    .find(recordClass => recordClass.fullName === 'GeneRecordClasses.GeneRecordClass')
});

export const RecordLink = connect(mapStateToGeneRecordLinkProps)(GeneRecordLink);


// -----------
// ResultTable
// -----------

function TranscriptViewFilter({
  answer: { meta: { totalCount, displayTotalCount, viewTotalCount } },
  recordClass: { name, displayName, displayNamePlural, nativeDisplayName, nativeDisplayNamePlural },
  globalViewFilters,
  isEnabled,
  isLoading,
  requestTranscriptFilterUpdate
}) {
  if (totalCount === displayTotalCount) return null;

  const display = displayTotalCount === 1 ? displayName : displayNamePlural;
  const nativeDisplay = totalCount === 1 ? nativeDisplayName : nativeDisplayNamePlural;
  const hiddenCount = isEnabled ? `(hiding ${(totalCount - viewTotalCount).toLocaleString()})` : null;
  const toggleId = "TranscriptViewFilter--Toggle";
  return (
    <div className="TranscriptViewFilter">
      <div>
        <div className="TranscriptViewFilter--Label">{display}:</div> {displayTotalCount.toLocaleString()}
      </div>
      <div>
        <div className="TranscriptViewFilter--Label">{nativeDisplay}:</div> {totalCount.toLocaleString()} {hiddenCount}
      </div>
      <div>
        <input
          id={toggleId}
          type="checkbox"
          checked={isEnabled}
          disabled={isLoading}
          onChange={() => requestTranscriptFilterUpdate(globalViewFilters[name], !isEnabled)}
        />
        <label htmlFor={toggleId}>Show Only One {nativeDisplayName} Per Gene</label>
        {isLoading && <div style={{ color: 'gray', padding: '0 1em', fontWeight: 'normal' }}>...updating results</div>}
      </div>
    </div>
  )
}

// FIXME Need to access viewId from Controller...
const viewId = 'strategy';
const ConnectedTranscriptViewFilter = connect(
  (state, props) => ({
    isEnabled: isTranscripFilterEnabled(state, { viewId }),
    globalViewFilters: get(state, ['resultTableSummaryView', viewId, 'globalViewFilters'], {})
  }),
  (dispatch, props) => ({
    requestTranscriptFilterUpdate: (...args) => dispatch(requestTranscriptFilterUpdate(viewId, ...args))
  })
)(TranscriptViewFilter);

export function ResultTable(props) {
  return <React.Fragment>
    <ConnectedTranscriptViewFilter {...props}/>
    <props.DefaultComponent {...props}/>
  </React.Fragment>
}
