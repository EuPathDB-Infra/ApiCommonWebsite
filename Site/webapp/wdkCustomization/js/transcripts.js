wdk.namespace('eupathdb.transcripts', function(ns, $) {

  // was used for leaf step, still available in Add Step
  function openTransform(stepId) {
    var currentStrategyFrontId = wdk.addStepPopup.current_Front_Strategy_Id;
    var strategy = wdk.strategy.model.getStrategy(currentStrategyFrontId);
    var strategyId = strategy.backId;

    wdk.step.isInsert = stepId;

    if(wdk.step.openDetail != null) wdk.step.hideDetails(); 

    var url = "wizard.do?stage=transform&action=add";
    url += "&strategy=" + strategyId + "&step=" + stepId;
    url += "&questionFullName=InternalQuestions.GenesByMissingTranscriptsTransform";

    // display the stage
    wdk.addStepPopup.callWizard(url,null,null,null,'next'); 
  }

  // BOOLEAN STEP FILTER
  function loadGeneBooleanFilter(event) {

    // using $ in a var name is convention to indicate it is a jquery object and we can apply jquery methods without using parenthesis
    var $filter = $(event.target).find('.gene-boolean-filter');

    // when user clicks on "Explore"
    $filter.on('click', '.gene-boolean-filter-controls-toggle', function(e) {
        e.preventDefault();
        $filter.find('.gene-boolean-filter-controls').toggle(400);
        if ( $('a.gene-boolean-filter-controls-toggle').text() === 'Collapse' ) {
          $('a.gene-boolean-filter-controls-toggle').text('Explore');
        }
        else {
          $('a.gene-boolean-filter-controls-toggle').text('Collapse');
        };
      });

    // load filter table even if user did not click on "explore", cause we need to show icon
    reallyLoadGeneBooleanFilter($filter);
  }

  function reallyLoadGeneBooleanFilter($filter, count) {
    count = count || 0;
    // example of data:  { step=103340140,  filter="gene_boolean_filter_array"}
    var data = $filter.data();
    $filter
      .find('.gene-boolean-filter-summary')
      .load('getFilterSummary.do', data, function(response, status) {

        // FIXME Remove before release
        // retry once, for some fault tolerance
        if (status == 'error' && count < 1) {
          reallyLoadGeneBooleanFilter($filter, ++count);
        }
        // if either one YN/NY/NN is > 0 we show table
        if ($filter.find('table').data('display')) {
          // this shows the warning sentence only; the table has display none, controlled by toggle via class name association
          $filter.css('display', 'block');
          // icon in transcript tab
          if ( $('i#tr-warning').length == 0 ){
            $( 'li#transcript-view a span' ).append( $( "<i id='tr-warning'><img src='/a/images/warningIcon2.png' style='width:16px;vertical-align:top' title='Some Genes in your result have Transcripts that do not meet the search criteria.' ></i>") );
          }
          // store initial checked values as eg: "1101"
          var initialCheckboxesState = checkBoxesState($filter).trim();

          // when a boolean filter input box is clicked
          $filter.on('click', '#booleanFilter input[type=checkbox]', function(e) {
            // check new state for checkboxes (one has been added or removed) 
            var currChBxState = checkBoxesState($filter);
            //console.log("initial is: ",initialCheckboxesState," and now it is:", currChBxState);
            // show user its current selection
            $('p#trSelection span').text(currChBxState);

            // if different from initialCheckboxesState, enable Apply button, otherwise disable; set consistent popup message
            if( initialCheckboxesState !=  currChBxState ) {
              $('button.gene-boolean-filter-apply-button').removeProp('disabled');
              $('button.gene-boolean-filter-apply-button').prop('title','If selection is applied, it will change the step results and therefore have an effect on the rest of your strategy.');
            }
            else {
              $('button.gene-boolean-filter-apply-button').prop('disabled', true);
              $('button.gene-boolean-filter-apply-button').prop('title','To enable this button, select/unselect transcript sets.');
            }
          });

          // do not show warning sentence in genes view
          if ( $("div#genes").parent().css('display') != 'none'){
            $("div#genes div.gene-boolean-filter").remove();
          }
        }
      });
  }

  // parameter: filter jquery object
  // returns string representing state; eg: if values == [YY,YN,NY,NN] and only NN is unchecked, we return '1110'
  function checkBoxesState ($filter) {
    var state = '';
    // read table.BooleanFilter checkboxes
    var valuesStr = $filter.find('.gene-boolean-filter-values').html().trim();
    //console.log(valuesStr); //{"values":["YY","YN"]}
    if (valuesStr) {
      var values = JSON.parse(valuesStr);
      //console.log(values);  //["YY", "YN"]
      $filter.find('[name=values]').each(function(index, checkbox) {
        if( checkbox.checked ) state = state + '1';
        else state = state + '0';
        });
      }
    return state;
  }



  function applyGeneBooleanFilter(event) {
    event.preventDefault();
    var ctrl = wdk.strategy.controller;
    var form = event.target;
    var $form = $(form);
    var $filter = $form.parent('.gene-boolean-filter');
    // what for?
    var data = $filter.data();
    // values contains: [["Y", "N"], ["N", "Y"]]
    var values = [].slice.call(form.values)
      .filter(function(el) {
        return el.checked;
      })
      .map(function(el) {
        return el.value.replace(/1/g, 'Y').replace(/0/g, 'N').split('');
      });
    // is there any checked checkbox?  (includes disabled checked checkboxes)
    if(!$.isEmptyObject(values)) {
      console.log(values); // the new selection is: eg: [["Y", "N"], ["N", "N"]]

      // check that we have, among user selections, at least one input > 0
      var trSelected = 0;
      $('#booleanFilter input[type=checkbox]:checked').each(function() {
        trSelected = parseInt(trSelected) + parseInt($(this).attr('amount'));
        //console.log("found one: ", trSelected);
      });
      if(trSelected > 0) {
        //enable inputs, so checked ones are sent in post even if the result was 0
        $("#booleanFilter input[type=checkbox]:checked").each(function() {
              $(this).prop('disabled', false);
        });
        //console.log(values); // the new selection is: eg: [["Y", "N"], ["N", "N"]]
        $.post('applyFilter.do', $form.serialize(), function() {
          ctrl.fetchStrategies(ctrl.updateStrategies);
        });
      }
      else {
        alert("Oops! please select at least one option with a count > 0");
      } 
    }
    else {
      alert("Oops! please select at least one option");
    }
  }

  // check if we have a boolean filter
  $(document).on('wdk-results-loaded', loadGeneBooleanFilter);
  // when boolean filter form submitted
  $(document).on('submit', '[name=apply-gene-boolean-filter]', applyGeneBooleanFilter);

  /*
  $(document).on('wdk-results-loaded', loadGeneLeafFilter);
  $(document).on('submit', '[name=apply-gene-leaf-filter]', applyGeneLeafFilter);
  */
  ns.openTransform = openTransform;
});
