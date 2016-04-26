import { Components, ComponentUtils } from 'wdk-client';
import Footer from './components/common/Footer';
import { findComponent } from './components/records';
import * as Gbrowse from './components/common/Gbrowse';
import Sequence from './components/common/Sequence';
import { selectReporterComponent } from './util/reporterSelector';
import ApiApplicationSpecificProperties from './components/ApiApplicationSpecificProperties';
import ApiUserIdentity from './components/ApiUserIdentity';

// Remove project_id from record links
export function RecordLink(WdkRecordLink) {
  return function ApiRecordLink(props) {
    let recordId = props.recordId.filter(p => p.name !== 'project_id');
    return (
      <WdkRecordLink {...props} recordId={recordId}/>
    );
  };
}

// Project id is not needed for these record classes.
// Matches urlSegment.
const RECORD_CLASSES_WITHOUT_PROJECT_ID = [ 'dataset', 'genomic-sequence' ];


/**
 * Munge url so that we can hide pieces of primary key we don't want users to see.
 *
 * The general operation that is happening below is that we are intercepting the
 * props sent to the WDK RecordController component and adding the project id
 * when it is needed.
 *
 * Conceptually, this could also be done at the action creator level. If WDK
 * provided a way to customize a view controller's action creator, we could
 * just append the project id when needed.
 *
 * Note that we are doing a few other things here, which is to say this override
 * is a bit of a jumble at the moment.
 *
 * `splat` refers to a wildcard dynamic url segment
 * as defined by the record route. The value of splat is essentially primary key
 * values separated by a '/'.
 */
export function RecordController(WdkRecordController) {
  return function ApiRecordController(props) {
    let { splat, recordClass } = props.params;
    let projectIdUrl = '/' + wdk.MODEL_NAME;
    let hasProjectId = splat.endsWith(projectIdUrl);

    if (hasProjectId) {
      setTimeout(function() {
        props.history.replace(props.location.pathname.replace(projectIdUrl, ''));
      }, 0);
      return <Components.Loading/>;
    }

    // These record classes do not need the project id as a part of the primary key
    // so we just render with the url params as-is.
    if (RECORD_CLASSES_WITHOUT_PROJECT_ID.indexOf(recordClass) > -1) {
      return ( <WdkRecordController {...props} /> );
    }

    // Append project id to request
    let params = Object.assign({}, props.params, {
      splat: `${splat}/${wdk.MODEL_NAME}`
    });

    return (
      <WdkRecordController {...props} params={params}/>
    );
  };
}

// Add footer and beta message to Main content
export function AppController(WdkAppController) {
  return function ApiAppController(props) {
    return (
      <div>
        <WdkAppController {...props}/>
        <Footer/>
      </div>
    );
  };
}

// Customize the Record Component
export function RecordUI(DefaultComponent) {
  return function ApiRecordUI(props) {
    let ResolvedComponent =
      findComponent('RecordUI', props.recordClass.name) || DefaultComponent;
    return <ResolvedComponent {...props} DefaultComponent={DefaultComponent}/>
  };
}

// Customize the Record Component
export function RecordHeading(DefaultComponent) {
  return function ApiRecordHeading(props) {
    let ResolvedComponent =
      findComponent('RecordHeading', props.recordClass.name) || DefaultComponent;
    return <ResolvedComponent {...props} DefaultComponent={DefaultComponent}/>
  };
}

export function Record(DefaultComponent) {
  return function ApiRecord(props) {
    let ResolvedComponent =
      findComponent('Record', props.recordClass.name) || DefaultComponent;
    return (
      <div>
        <ResolvedComponent {...props} DefaultComponent={DefaultComponent}/>
        <RecordAttributionSection {...props}/>
      </div>
    );
  };
}

function RecordAttributionSection(props) {
  if ('attribution' in props.record.attributes) {
    return (
      <div>
        <h3>Record Attribution</h3>
        {ComponentUtils.renderAttributeValue(props.record.attributes.attribution)}
      </div>
    )
  }
  return <noscript/>
}

export function RecordOverview(DefaultComponent) {
  return function ApiRecordOverview(props) {
    let ResolvedComponent =
      findComponent('RecordOverview', props.recordClass.name) || DefaultComponent;
    return <ResolvedComponent {...props} DefaultComponent={DefaultComponent}/>
  };
}

// Customize StepDownloadForm to show the appropriate form based on the
//   selected reporter and record class
export function StepDownloadForm(WdkStepDownloadForm) {
  return function ApiStepDownloadForm(props) {
    let Reporter = selectReporterComponent(props.selectedReporter, props.recordClass.name);
    return ( <Reporter {...props}/> );
  }
}

export function RecordTable(DefaultComponent) {
  return function ApiRecordTable(props) {
    let ResolvedComponent =
      findComponent('RecordTable', props.recordClass.name) || DefaultComponent;
    return <ResolvedComponent {...props} DefaultComponent={DefaultComponent}/>
  };
}

export function RecordAttribute(DefaultComponent) {
  return function ApiRecordAttribute(props) {
    let context = Gbrowse.contexts.find(context => context.gbrowse_url === props.name);
    if (context != null) {
        return ( <Gbrowse.GbrowseContext {...props} context={context} /> );
    }

      let sequenceRE = /sequence$/;
      if (sequenceRE.test(props.name)) {
          return ( <Sequence sequence={props.value}/> );
      }


    let ResolvedComponent =
      findComponent('RecordAttribute', props.recordClass.name) || DefaultComponent;
    return <ResolvedComponent {...props} DefaultComponent={DefaultComponent}/>
  };
}

export function UserIdentity() {
  return ApiUserIdentity;
}

export function UserContact() {
  return function() { return <noscript /> };
}

export function ApplicationSpecificProperties() {
  return ApiApplicationSpecificProperties;
}

