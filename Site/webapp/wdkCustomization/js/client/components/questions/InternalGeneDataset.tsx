import React, { useMemo, useState, useEffect } from 'react';
import { connect } from 'react-redux';

import { SubmissionMetadata } from 'wdk-client/Actions/QuestionActions';
import { Loading, Link, Tooltip, HelpIcon, Tabs } from 'wdk-client/Components';
import { StepAnalysisEnrichmentResultTable as InternalGeneDatasetTable } from 'wdk-client/Core/MoveAfterRefactor/Components/StepAnalysis/StepAnalysisEnrichmentResultTable';
import { useSetSearchDocumentTitle } from 'wdk-client/Controllers/QuestionController';
import { RootState } from 'wdk-client/Core/State/Types';
import { useWdkService } from 'wdk-client/Hooks/WdkServiceHook';
import { CategoryTreeNode } from 'wdk-client/Utils/CategoryUtils';
import { makeClassNameHelper, safeHtml } from 'wdk-client/Utils/ComponentUtils';
import { getPropertyValue, getPropertyValues } from 'wdk-client/Utils/OntologyUtils';
import { Question, AttributeValue, LinkAttributeValue, Answer, RecordClass } from 'wdk-client/Utils/WdkModel';
import { Plugin } from 'wdk-client/Utils/ClientPlugin';
import NotFound from 'wdk-client/Views/NotFound/NotFound';
import { QuestionHeader } from 'wdk-client/Views/Question/DefaultQuestionForm';

import { formatLink } from 'ebrc-client/components/records/DatasetRecordClasses.DatasetRecordClass'

import './InternalGeneDataset.scss';

const cx = makeClassNameHelper('wdk-InternalGeneDatasetForm');

type StateProps = {
  buildNumber?: string,
  questions?: Question[],
  ontology?: CategoryTreeNode,
  recordClasses?: RecordClass[]
};

type OwnProps = {
  recordClass: string,
  question: string,
  hash: string,
  submissionMetadata: SubmissionMetadata,
  submitButtonText?: string,
  shouldChangeDocumentTitle?: boolean
};

type Props = OwnProps & StateProps;

type InternalQuestionRecord = { 
  target_name: string, 
  dataset_id: string,
  target_type: string,
  dataset_name: string,
  record_type: string
};

type DatasetRecord = {
  dataset_name: string,
  display_name: string,
  organism_prefix: string,
  dataset_id: string,
  summary: string,
  build_number_introduced: string,
  publications: LinkAttributeValue[],
  searches: string
};

type DisplayCategory = { 
  description: string, 
  displayName: string, 
  shortDisplayName: string 
};

const InternalGeneDatasetView: React.FunctionComponent<Props> = ({
  buildNumber,
  questions,
  ontology,
  recordClasses,
  question: internalSearchName,
  recordClass,
  hash: searchNameAnchorTag,
  submissionMetadata,
  submitButtonText,
  shouldChangeDocumentTitle
}) => {
  const [ selectedSearch, setSelectedSearch ] = useState<string | undefined>(searchNameAnchorTag);

  const [ searchName, showingRecordToggle ] = selectedSearch
    ? [ selectedSearch, true ]
    : [ internalSearchName, false ];

  const [ internalQuestion, outputRecordClass, datasetCategory, datasetSubtype ] = useMemo(
    () => getTableQuestionMetadata(questions, recordClasses, internalSearchName),
    [ questions, recordClasses, internalSearchName ]
  );

  const serviceResult = useWdkService(async wdkService => {
    if (
      !questions || 
      !ontology ||
      !outputRecordClass || 
      !datasetCategory || 
      !datasetSubtype
    ) {
      return undefined;
    }

    const answer = await wdkService.getAnswerJson(
      getAnswerSpec(datasetCategory, datasetSubtype),
      REPORT_CONFIG
    );

    const internalQuestions = getInternalQuestions(answer, outputRecordClass.fullName);
    const displayCategoryMetadata = getDisplayCategoryMetadata(ontology, internalQuestions);
    const datasetRecords = getDatasetRecords(answer, displayCategoryMetadata);

    return {
      questionNamesByDatasetAndCategory: displayCategoryMetadata.questionNamesByDatasetAndCategory,
      displayCategoriesByName: displayCategoryMetadata.displayCategoriesByName,
      displayCategoryOrder: displayCategoryMetadata.displayCategoryOrder,
      datasetRecords
    };
  }, [ questions, ontology, internalSearchName, outputRecordClass, datasetCategory, datasetSubtype ]);

  const {
    questionNamesByDatasetAndCategory,
    displayCategoriesByName,
    displayCategoryOrder,
    datasetRecords
  } = serviceResult || {};

  const [ showingOneRecord, updateShowingOneRecord ] = useState(showingRecordToggle);

  const selectedDataSetRecord = useMemo(
    () => getSelectedDataSetRecord(datasetRecords, questionNamesByDatasetAndCategory, searchName),
    [ datasetRecords, questionNamesByDatasetAndCategory, searchName ]
  );

  const filteredDatasetRecords = useMemo(
    () => getFilteredDatasetRecords(datasetRecords, displayCategoriesByName, showingOneRecord, selectedDataSetRecord),
    [ datasetRecords, displayCategoriesByName, showingOneRecord, selectedDataSetRecord ]
  );

  useEffect(() => {
    updateShowingOneRecord(searchName !== internalSearchName);
  }, [ searchName, internalSearchName ]);

  useSetSearchDocumentTitle(
    internalQuestion, 
    internalQuestion ? 'complete' : 'loading', 
    recordClasses, 
    outputRecordClass, 
    shouldChangeDocumentTitle
  );

  return (
    (
      !questions ||
      !ontology ||
      !questionNamesByDatasetAndCategory ||
      !displayCategoriesByName ||
      !displayCategoryOrder ||
      !datasetRecords ||
      !filteredDatasetRecords
    )
      ? <Loading />
      : (
        !internalQuestion ||
        !outputRecordClass ||
        !datasetCategory ||
        !datasetSubtype
      )
      ? <NotFound />
      : (
        <div className={cx()}>
          <QuestionHeader
            showDescriptionLink={submissionMetadata.type === 'create-strategy'}
            showHeader={submissionMetadata.type === 'create-strategy' || submissionMetadata.type === 'edit-step'}
            headerText={`Identify ${outputRecordClass.displayNamePlural} based on ${internalQuestion.displayName}`}
          />
          <InternalGeneDatasetTable
            searchBoxHeader="Filter Data Sets:"
            emptyResultMessage=""
            showCount={false}
            rows={
              showingOneRecord
                ? filteredDatasetRecords
                : datasetRecords
            }
            columns={
              [
                {
                  key: 'organism_prefix',
                  name: 'Organism',
                  type: 'html',
                  sortable: true,
                  sortType: 'htmlText',
                  helpText: 'Organism data is aligned to'
                },
                {
                  key: 'display_name',
                  name: 'Data Set',
                  type: 'html',
                  sortable: true,
                  sortType: 'htmlText',
                  renderCell: (cellProps: any) => {
                    const { 
                      display_name, 
                      summary, 
                      publications,
                      build_number_introduced
                    }: DatasetRecord 
                      = cellProps.row;

                    return (
                      <div>
                        <HelpIcon>
                          <div>
                            <h4>Summary</h4>
                            {safeHtml(summary)}
                            {
                              publications.length > 0 && (
                                <>
                                  <h4>Publications</h4>
                                  <ul>
                                    {
                                      publications.map(
                                        link =>
                                          <li key={link.url}>
                                            {formatLink(link, { newWindow: true })}
                                          </li>
                                      )
                                    }
                                  </ul>
                                </>
                              )
                            }
                          </div>
                        </HelpIcon>
                        {' '}
                        {safeHtml(display_name)}
                        {
                          build_number_introduced === buildNumber &&
                          <span className={cx('NewDataset')}></span>
                        }
                      </div>
                    );
                  }
                },
                {
                  key: 'Searches',
                  name: 'Choose a Search',
                  sortable: false,
                  renderCell: (cellProps: any) =>
                    <>
                      {
                        displayCategoryOrder.map(
                          categoryName => {
                            const datasetName = cellProps.row.dataset_name;
                            const categorySearchName = questionNamesByDatasetAndCategory[datasetName][categoryName];

                            return (
                                <div key={categoryName}>
                                  {
                                    categorySearchName && (
                                      <Link 
                                        className={
                                          categorySearchName === searchName
                                            ? "bttn bttn-cyan bttn-active"
                                            : "bttn bttn-cyan"
                                        } 
                                        key={categoryName} 
                                        to={`${internalSearchName}#${categorySearchName}`}
                                        onClick={(e: React.MouseEvent) => {
                                          if (submissionMetadata.type !== 'create-strategy') {
                                            e.preventDefault();
                                          }

                                          setSelectedSearch(categorySearchName);
                                        }}
                                      >
                                        {displayCategoriesByName[categoryName].shortDisplayName}
                                      </Link>
                                    )
                                  }
                                </div>
                              );
                          }
                        )
                      }
                    </>
                }
              ]
            }
            initialSortColumnKey="organism_prefix"
            fixedTableHeader
          >
            <div className={cx('Legend')}>
              <span>
                Legend:
              </span>
              {
                displayCategoryOrder.map(
                  categoryName =>
                      <Tooltip
                        key={categoryName}
                        content={
                          <div>
                            <h4>
                              {displayCategoriesByName[categoryName].displayName}
                            </h4>
                            {displayCategoriesByName[categoryName].description}
                          </div>
                        }
                      >
                        <span key={categoryName}>
                          <span className="bttn bttn-cyan bttn-active">
                            {displayCategoriesByName[categoryName].shortDisplayName}
                          </span>
                          <span>
                            {displayCategoriesByName[categoryName].displayName}
                          </span>
                        </span>
                      </Tooltip>
                )
              }
            </div>
          </InternalGeneDatasetTable>
          {
            showingRecordToggle && (
              <div 
                className={cx('RecordToggle')}
                onClick={() => {
                  updateShowingOneRecord(!showingOneRecord);
                }}
              >
                {
                  showingOneRecord
                    ? (
                      <>
                        <i className="fa fa-arrow-down" />
                        {' '}
                        Show All Data Sets
                        {' '}
                        <i className="fa fa-arrow-down" />
                      </>
                    )
                    : (
                      <>
                        <i className="fa fa-arrow-up" />
                        {' '}
                        Hide All Data Sets
                        {' '}
                        <i className="fa fa-arrow-up" />
                      </>
                    )
                }
              </div>            
            )
          }
          {
            selectedDataSetRecord && (
              <Tabs
                tabs={
                  displayCategoryOrder
                    .filter(
                      categoryName => questionNamesByDatasetAndCategory[selectedDataSetRecord.dataset_name][categoryName]
                    )
                    .map(
                      categoryName => ({
                        key: questionNamesByDatasetAndCategory[selectedDataSetRecord.dataset_name][categoryName],
                        display: (
                          <Link 
                            to={`${internalSearchName}#${questionNamesByDatasetAndCategory[selectedDataSetRecord.dataset_name][categoryName]}`}
                            onClick={(e: React.MouseEvent) => {
                              if (submissionMetadata.type) {
                                e.preventDefault();
                              }

                              setSelectedSearch(questionNamesByDatasetAndCategory[selectedDataSetRecord.dataset_name][categoryName]);
                            }}
                          >
                            {displayCategoriesByName[categoryName].displayName}
                          </Link>
                        ),
                        content: (
                          <Plugin
                            context={{
                              type: 'questionController',
                              searchName,
                              recordClassName: recordClass
                            }}
                            pluginProps={{
                              question: searchName,
                              recordClass,
                              submissionMetadata,
                              submitButtonText
                            }}
                          />
                        )
                      })
                    )
                }
                activeTab={searchName}
                onTabSelected={(tab) => {
                  setSelectedSearch(tab);
                }}
              />
            )
          }
        </div>
      )
  );
};

function getTableQuestionMetadata(
  questions: Question[] | undefined, 
  recordClasses: RecordClass[] | undefined,
  internalSearchName: string
): [ Question | undefined, RecordClass | undefined, string | undefined, string | undefined ] {
  if (!questions || !recordClasses) {
    return [ undefined, undefined, undefined, undefined ];
  }

  const internalQuestion = questions.find(question => question.urlSegment === internalSearchName);

  if (!internalQuestion || !internalQuestion.properties) {
    return [ undefined, undefined, undefined, undefined ];
  }

  const {
    datasetCategory = [],
    datasetSubtype = []
  } = internalQuestion.properties;

  const outputRecordClass = recordClasses.find(({ urlSegment }) => urlSegment === internalQuestion.outputRecordClassName);

  return [
    internalQuestion,
    outputRecordClass,
    datasetCategory.join(''),
    datasetSubtype.join('')
  ];
}

function getSelectedDataSetRecord(
  datasetRecords: DatasetRecord[] | undefined,
  questionNamesByDatasetAndCategory: ReturnType<typeof getDisplayCategoryMetadata>['questionNamesByDatasetAndCategory'] | undefined,
  searchName: string
) {
  return !datasetRecords || !questionNamesByDatasetAndCategory
    ? undefined
    : datasetRecords.find(
      ({ dataset_name }) => Object.values(questionNamesByDatasetAndCategory[dataset_name]).includes(searchName)
    );
}

function getFilteredDatasetRecords(
  datasetRecords: DatasetRecord[] | undefined,
  questionNamesByDatasetAndCategory: ReturnType<typeof getDisplayCategoryMetadata>['questionNamesByDatasetAndCategory'] | undefined,
  showingOneRecord: boolean,
  selectedDataSetRecord: DatasetRecord | undefined
) {
  return !datasetRecords || !questionNamesByDatasetAndCategory
    ? undefined
    : !showingOneRecord
    ? datasetRecords
    : datasetRecords.filter(record => record === selectedDataSetRecord)
}

function getAnswerSpec(datasetCategory: string, datasetSubtype: string) {
  return {
    searchName: 'DatasetsByCategoryAndSubtype',
    searchConfig: {
      parameters: {
        dataset_category: datasetCategory,
        dataset_subtype: datasetSubtype
      }
    }
  };
}

const REPORT_CONFIG = {
  attributes: [
    "dataset_name",
    "display_name",
    "organism_prefix",
    "short_attribution",
    "dataset_id", 
    "summary",
    "description",
    "build_number_introduced"
  ],
  tables: [
    "References",
    "Publications"
  ],
  pagination: {
    "offset": 0,
    "numRecords": -1
  }
};

function getInternalQuestions(answer: Answer, outputRecordClassName: string) {
  return answer.records
    .flatMap(
      record => {
        if (record.tableErrors.includes('References')) {
          throw new Error(`Failed to resolve References table for record ${JSON.stringify(record)}`);
        }

        return record.tables.References;
      }
    )
    .filter(
      (reference): reference is Record<string, AttributeValue> => (
        reference !== null && 
        reference.target_type === 'question' && 
        reference.record_type === outputRecordClassName
      )
    ).map(
      reference => {
        if (
          typeof reference.target_name !== 'string' ||
          typeof reference.dataset_id !== 'string' ||
          typeof reference.target_type !== 'string' ||
          typeof reference.dataset_name !== 'string' ||
          typeof reference.record_type !== 'string'
        ) {
          throw new Error(`Question reference ${JSON.stringify(reference)} is missing required attribute fields`);
        }

        return {
          target_name: reference.target_name, 
          dataset_id: reference.dataset_id, 
          target_type: reference.target_type, 
          dataset_name: reference.dataset_name, 
          record_type: reference.record_type
        };
      }
    );
}

function getDatasetRecords(
  answer: Answer, 
  {
    displayCategoriesByName,
    displayCategoryOrder,
    questionNamesByDatasetAndCategory
  }: ReturnType<typeof getDisplayCategoryMetadata>
) {
  return answer.records
  .filter(
    ({ attributes: { dataset_name } }) => 
      Object.keys(questionNamesByDatasetAndCategory[`${dataset_name}`] || {}).length > 0
    )
  .map(
    datasetRecord => {
      if (
        typeof datasetRecord.attributes.dataset_name !== 'string' ||
        typeof datasetRecord.attributes.display_name !== 'string' ||
        typeof datasetRecord.attributes.organism_prefix !== 'string' ||
        typeof datasetRecord.attributes.short_attribution !== 'string' ||
        typeof datasetRecord.attributes.dataset_id !== 'string' ||
        typeof datasetRecord.attributes.summary !== 'string' ||
        typeof datasetRecord.attributes.build_number_introduced !== 'string'
      ) {
        throw new Error(`Dataset record ${JSON.stringify(datasetRecord)} is missing required attribute fields`);
      }

      if (datasetRecord.tableErrors.includes('Publications')) {
        throw new Error(`Failed to resolve Publications table for record ${JSON.stringify(datasetRecord)}`);
      }

      return {
        dataset_name: datasetRecord.attributes.dataset_name,
        display_name: `${datasetRecord.attributes.display_name} (${datasetRecord.attributes.short_attribution})`,
        organism_prefix: datasetRecord.attributes.organism_prefix,
        dataset_id: datasetRecord.attributes.dataset_id,
        summary: datasetRecord.attributes.summary,
        build_number_introduced: datasetRecord.attributes.build_number_introduced,
        publications: datasetRecord.tables.Publications.map(
          ({ pubmed_link }) => { 
            if (pubmed_link === null || typeof pubmed_link === 'string') {
              throw new Error(`Pubmed link ${JSON.stringify(pubmed_link)} is invalid - expected a LinkAttributeValue`);
            }

            return pubmed_link;
          }
        ),
        searches: displayCategoryOrder
          .filter(categoryName => questionNamesByDatasetAndCategory[`${datasetRecord.attributes.dataset_name}`][categoryName])
          .map(categoryName => displayCategoriesByName[categoryName].shortDisplayName)
          .join(' ')
      };
    },
  );
}

function getDisplayCategoryMetadata(root: CategoryTreeNode, internalQuestions: InternalQuestionRecord[]) {
  const datasetNamesByQuestion = internalQuestions.reduce(
    (memo, { target_name, dataset_name }) => {
      memo[target_name] = dataset_name;
      return memo;
    },
    {} as Record<string, string>
  );

  // Dataset Name => Category Name => Search URL Segment
  const questionNamesByDatasetAndCategory: Record<string, Record<string, string>> = {};

  const displayCategoriesByName: Record<string, DisplayCategory> = {};

  function traverse(node: CategoryTreeNode, searchCategoryNode?: CategoryTreeNode) {  
    const label = getPropertyValue('label', node) || '';
    const scope = getPropertyValues('scope', node) || [];
    const questionName = getPropertyValue('name', node) || '';
    const targetType = getPropertyValue('targetType', node) || '';

    if (
      scope.includes('webservice') && 
      targetType === 'search' && 
      datasetNamesByQuestion[questionName] &&
      searchCategoryNode
    ) {
      const datasetName = datasetNamesByQuestion[questionName];
      const categoryName = getPropertyValue('name', searchCategoryNode) || '';

      questionNamesByDatasetAndCategory[datasetName] = {
        ...questionNamesByDatasetAndCategory[datasetName],
        [categoryName]: questionName.replace(/[^.]*\./, '')
      };

      displayCategoriesByName[categoryName] = displayCategoriesByName[categoryName] || {
        description: getPropertyValue('description', searchCategoryNode) || '',
        displayName: getPropertyValue('EuPathDB alternative term', searchCategoryNode) || '',
        shortDisplayName: getPropertyValue('shortDisplayName', searchCategoryNode) || ''
      };
    }

    const nextSearchCategoryNode = searchCategoryNode
      ? searchCategoryNode
      : label.startsWith('searchCategory')
      ? node
      : undefined;

    node.children.forEach(
      childNode => traverse(childNode, nextSearchCategoryNode)
    );
  }

  traverse(root);

  const displayCategoryOrder = Object.keys(displayCategoriesByName).sort();

  return {
    questionNamesByDatasetAndCategory, 
    displayCategoriesByName, 
    displayCategoryOrder
  };
}

export const InternalGeneDataset = connect<StateProps, {}, OwnProps, RootState>(
  (state, ownProps) => ({ 
    ...ownProps, 
    buildNumber: state.globalData.config && state.globalData.config.buildNumber,
    questions: state.globalData.questions, 
    ontology: state.globalData.ontology
      ? state.globalData.ontology.tree
      : undefined,
    recordClasses: state.globalData.recordClasses
  })
)(InternalGeneDatasetView);
