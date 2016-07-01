/* global wdk */
import $ from 'jquery';
import { difference } from 'lodash';
import {PureComponent} from 'wdk-client/ComponentUtils';
import { FilterParam } from './FilterParam';

export class SnpsAlignmentTable extends PureComponent {
  componentDidMount() {
    $(this.node)
    .on('click', '.select-all', event => {
      event.preventDefault();
      this.getCheckboxes().prop('checked', true);
      this.udpateSubmitDisabled();
      this.updateIsolateIds();
    })
    .on('click', '.clear-all', event => {
      event.preventDefault();
      this.getCheckboxes().prop('checked', false);
      this.udpateSubmitDisabled();
      this.updateIsolateIds();
    })
    .on('change', ':checkbox', () => {
      this.udpateSubmitDisabled();
      this.updateIsolateIds();
    })

  }

  getCheckboxes() {
    return $(this.node).find(':checkbox');
  }

  udpateSubmitDisabled() {
    let isDisabled = this.getCheckboxes().filter(':checked').length === 0;
    $(this.node).find(':submit').prop('disabled', isDisabled);
  }

  updateIsolateIds() {
    let isolateIds = this.getCheckboxes().filter(':checked').toArray().map(el => el.value);
    $(this.node).find('[name="isolate_ids"]').val(isolateIds.join(','));
  }

  renderFormButtons() {
    return (
      <p>
        <input type="submit" value="Show Alignment" disabled={true} />{' '}
        <a className="select-all" href="#">Select all</a>{' | '}
        <a className="clear-all" href="#">Clear all</a>
      </p>
    )
  }

  render() {
    let { strainAttributeName, startAttributeName, endAttributeName, seqIdAttributeName, record } = this.props;
    let start = record.attributes[startAttributeName];
    let end = record.attributes[endAttributeName];
    let sid = record.attributes[seqIdAttributeName];
    let value = this.props.value.map((row) => {
      let strain = row[strainAttributeName];
      return Object.assign({}, row, {
        [strainAttributeName]: `<label><input value="${strain}" type="checkbox"/> ${strain}</label>`
      })
    });
    return (
      <div ref={node => this.node = node}>
        <form action="/cgi-bin/isolateClustalw" method="post" target="_blank">
          <input name="project_id" value={wdk.MODEL_NAME} type="hidden"/>
          <input name="type" value="htsSnp" type="hidden"/>
          <input name="sid" value={sid} type="hidden"/>
          <input name="end" value={end} type="hidden"/>
          <input name="start" value={start} type="hidden"/>
          <input name="isolate_ids" type="hidden"/>

          {this.renderFormButtons()}
          <this.props.DefaultComponent {...this.props} value={value}/>
          {this.renderFormButtons()}
        </form>
      </div>
    )
  }
}

export class SnpsAlignmentForm extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { isolateIds: [] };
    this.handleChange = (filterParamState) => {
      let { filteredData, ignoredData } = filterParamState;
      let isolateIds = difference(filteredData, ignoredData).map(d => d.term);
      this.setState({ isolateIds });
    };
  }
  render() {
    let { isolateIds } = this.state;
    let { startAttributeName, endAttributeName, seqIdAttributeName, record } = this.props;
    let start = record.attributes[startAttributeName];
    let end = record.attributes[endAttributeName];
    let sid = record.attributes[seqIdAttributeName];

    return (
      <div>
        <p>Select strains using the panel below. Then click "Show Alignment" to view a multiple
          sequence alignment.</p>
        <form action="/cgi-bin/isolateClustalw" method="post" target="_blank">
          <input name="project_id" value={wdk.MODEL_NAME} type="hidden"/>
          <input name="type" value="htsSnp" type="hidden"/>
          <input name="sid" value={sid} type="hidden"/>
          <input name="end" value={end} type="hidden"/>
          <input name="start" value={start} type="hidden"/>
          <input name="isolate_ids" type="hidden" value={isolateIds.join(',')}/>
          <FilterParam
            displayName="Strains"
            questionName="GeneQuestions.GenesByNgsSnps"
            dependedValue={{ organismSinglePick: [ record.attributes.organism_full ] }}
            onChange={this.handleChange} />
          <p style={{ textAlign: 'center' }}>
            <button type="submit" disabled={isolateIds.length === 0}>Show Alignment</button>
          </p>
        </form>
      </div>
    )
  }
}
