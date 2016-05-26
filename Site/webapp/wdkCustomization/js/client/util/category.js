/* global wdk */
import {indexBy, propertyOf} from 'lodash';
import {preorderSeq, pruneDescendantNodes} from 'wdk-client/TreeUtils';
import {getTree} from 'wdk-client/OntologyUtils';
import {getRecordClassName, isQualifying} from 'wdk-client/CategoryUtils';

let isSearchMenuScope = isQualifying({ targetType: 'search', scope: 'menu' });

/**
 * Gets Category ontology and returns an array of trees, where each root node
 * is a recordClass. Optionally, indicate record classes to include or exclude
 * via the `options` object. If `options.include` is defined, `options.exclude`
 * will be ignored.
 *
 * This is used by bubbles and query grid (and soon menus).
 *
 * @param {WdkService} wdkService
 * @param {Object} options
 * @param {string[]} options.include Record classes to include
 * @param {string[]} options.exclude Record classes to exclude
 * @returns Promise<RecordClassTree[]>
 */
export function getSearchMenuCategoryTree(wdkService, options) {
  let ontology$ = wdk.client.runtime.wdkService.getOntology();
  let recordClasses$ = wdk.client.runtime.wdkService.getRecordClasses();
  return Promise.all([ ontology$, recordClasses$ ]).then(([ ontology, recordClasses ]) => {
    let recordClassMap = indexBy(recordClasses, 'name');
    // get searches scoped for menu
    let categoryTree = getTree(ontology, isSearchMenuScope);
    return groupByRecordClass(categoryTree, recordClassMap, options);
  });
}

function groupByRecordClass(categoryTree, recordClassMap, options) {
  let recordClassCategories = preorderSeq(categoryTree)
  .filter(isLeafNode)
  .map(getRecordClassName)
  .uniq()
  .filter(isDefined)
  .filter(includeExclude(options))
  .map(propertyOf(recordClassMap))
  .map(getRecordClassTree(categoryTree))
  .toArray();
  return { children: recordClassCategories };
}

function isLeafNode(node) {
  return node.children.length === 0;
}

function isDefined(maybe) {
  return maybe !== undefined;
}

function includeExclude({ include, exclude }) {
  return function(item) {
    return include != null ? include.indexOf(item) > -1
         : exclude != null ? exclude.indexOf(item) === -1
         : true;
  }
}

function getRecordClassTree(categoryTree) {
  return function(recordClass) {
    let tree = pruneDescendantNodes(isRecordClassTreeNode(recordClass), categoryTree);
    return {
      properties: {
        label: [recordClass.name],
        'EuPathDB alternative term': [recordClass.displayNamePlural]
      },
      // Flatten non-transcript searches. This can be removed if we decide to show
      // those categories
      children: recordClass.name === 'TranscriptRecordClasses.TranscriptRecordClass'
        ? tree.children
        : preorderSeq(tree).filter(n => n.children.length === 0).toArray()
    };
  }
}

function isRecordClassTreeNode(recordClass) {
  return function(node) {
    return node.children.length !== 0 || getRecordClassName(node) === recordClass.name;
  }
}
