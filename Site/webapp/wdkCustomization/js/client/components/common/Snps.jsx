import { PropTypes } from 'react';
import { difference } from 'lodash';
import {PureComponent} from 'wdk-client/ComponentUtils';
import { FilterParam } from './FilterParam';

export class SnpsAlignmentForm extends PureComponent {
  constructor(props, context) {
    super(props, context);
    this.state = { isolateIds: [] };
    this.handleChange = (filterParamState) => {
      let { filteredData, ignoredData } = filterParamState;
      let isolateIds = difference(filteredData, ignoredData).map(d => d.term);
      this.setState({ isolateIds });
    };
  }
  render() {
    let { isolateIds } = this.state;
    let { start, end, sequenceId, organism } = this.props;
    let { projectId } = this.context.store.getState().globalData.config;

    return (
      <div>
        <p>Select strains using the panel below. Then click "Show Alignment" to view a multiple
          sequence alignment.</p>
        <form action="/cgi-bin/isolateClustalw" method="post" target="_blank">
          <input name="project_id" value={projectId} type="hidden"/>
          <input name="type" value="htsSnp" type="hidden"/>
          <input name="sid" value={sequenceId} type="hidden"/>
          <input name="end" value={end} type="hidden"/>
          <input name="start" value={start} type="hidden"/>
          <input name="isolate_ids" type="hidden" value={isolateIds.join(',')}/>
          <FilterParam
            displayName="Strains"
            questionName="GeneQuestions.GenesByNgsSnps"
            dependedValue={{ organismSinglePick: [ organism ] }}
            onChange={this.handleChange} />
          <p style={{ textAlign: 'center' }}>
            <button type="submit" disabled={isolateIds.length === 0}>Show Alignment</button>
          </p>
        </form>
      </div>
    )
  }
}

SnpsAlignmentForm.contextTypes = {
  store: PropTypes.object.isRequired
};
