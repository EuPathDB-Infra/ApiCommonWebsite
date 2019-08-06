import React, { useMemo } from 'react';

import { makeClassNameHelper } from 'wdk-client/Utils/ComponentUtils';
import { AddStepOperationMenuProps } from 'wdk-client/Views/Strategy/AddStepPanel';
import { PrimaryInputLabel } from 'wdk-client/Views/Strategy/PrimaryInputLabel';

import { selectSearchPage } from './ColocateStepForm';

import './ColocateStepMenu.scss';

const cx = makeClassNameHelper('ColocateStepMenu');

const colocationQuestionSuffix = 'BySpanLogic';

export const ColocateStepMenu = ({
  developmentMode,
  inputRecordClass,
  operandStep,
  recordClasses,
  startOperationForm
}: AddStepOperationMenuProps) => {
  const colocationRecordClasses = useMemo(
    () => recordClasses.filter(
      ({ searches }) => 
        searches.some(
          ({ urlSegment, allowedPrimaryInputRecordClassNames }) => (
            urlSegment.endsWith(colocationQuestionSuffix) &&
            !!allowedPrimaryInputRecordClassNames &&
            allowedPrimaryInputRecordClassNames.includes(inputRecordClass.urlSegment) &&
            inputRecordClass.searches.some(({ urlSegment }) => urlSegment.endsWith(colocationQuestionSuffix))
          )
        )
      ), 
    [ recordClasses, colocationQuestionSuffix ]
  );

  return (
    <div className={cx()}>
      <div className={cx('--Header')}>
        <h3>
          Use Genomic Colocation
        </h3>
          to combine it with:
      </div>
      <div className={cx('--Body')}>
        <PrimaryInputLabel
          className={cx('--PrimaryInputLabel')}
          resultSetSize={operandStep.estimatedSize}
          recordClass={inputRecordClass}
        />
        <div className={cx('--ColocationIcon')}>
          X
        </div>
        <div className={cx('--RecordClassSelector')}>
          {
            colocationRecordClasses.length === 0
              ? 'No colocation operations available'
              : colocationRecordClasses.map(
                  ({ displayNamePlural, urlSegment }) =>
                    <button key={urlSegment} type="button" onClick={() => {
                      developmentMode
                        ? startOperationForm('colocate', selectSearchPage(urlSegment))
                        : alert('Under construction');
                    }}>
                      {displayNamePlural}
                    </button>
                )
          }
        </div>
      </div>
    </div>
  );
};
