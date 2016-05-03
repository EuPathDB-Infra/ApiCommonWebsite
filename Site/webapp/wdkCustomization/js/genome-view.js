
var escapeSelectorComponent = wdk.util.escapeSelectorComponent;

function initializeGenomeView() {
    var tooltip = window.wdk.tooltips;
    $(".genome-view").each(function() {
        var genomeView = $(this);
        if (genomeView.attr("initialized") == "true") return;

        // register events onto sequences
        genomeView.find(".datatables .sequence").each(function() {
            var sequence = $(this);
            var sequenceId = escapeSelectorComponent(sequence.find(".sequence-id").text());
            var canvas = sequence.find(".canvas");
            var sequenceData = genomeView.find("#sequences #" + sequenceId + ".sequence");

            // click on ruler to goto the sequence record page.
            canvas.find(".ruler").click(function() {
                window.location.href = $(this).parents(".sequence").find(".sequence-id a").attr("href");
            });

            // register events on region
            canvas.find(".region").click(function() {
                var regionId = escapeSelectorComponent( $(this).attr("data-id") );
                var content = sequenceData.find(".regions #" + regionId).clone();
                if (content.length === 0) { 
                  console.error("the element with id: " + regionId + " cannot be found"); 
                }
                var flag = content.data("registered");
                if (flag != "true") {
                    content.data("registered", "true");
                    // register tooltips on sequences
                    content.find(".canvas .feature").each(function() {
                        var featureId = $(this).data("id");
                        //var feature = sequenceData.find(".features #" + featureId);
                        var feature = $(document.getElementById(featureId));
                        tooltip.setUpStickyTooltip(this, feature);
                    });

                    // register the datatable
                    content.find(".feature-list").dataTable({
                      "bJQueryUI": true,
                      "sDom":'<"H"iplfr>t<"F"ip>',
                      "aaSorting": [[1,'asc']],
                      "aoColumns": [ null, 
                                     null,
                                     null,
                                     { "bSortable": false } ]
                    });
                }
                content.dialog({width:800});
            });

            // register events on feature if it's detail view
            canvas.find(".feature").each(function() {
                var featureId = $(this).data("id");
                //var feature = sequenceData.find(".features #" + featureId);
                var feature = $(document.getElementById(featureId));
                tooltip.setUpStickyTooltip(this, feature);
            });
        });

        // register datatables. it has to be the last step, otherwise the rest of 
        // the registration will be applied to the current page only.
        var sequenceTable = genomeView.find(".datatables").dataTable({
            "bJQueryUI": true,
            "aLengthMenu": [[10, 25, -1], [10, 25, "All"]],
            "iDisplayLength": 25,
            "sDom":'<"H"iplfr>t<"F"ip>',
            "aaSorting": [[3,'desc']],
            "aoColumns": [ null,
                           null,
                           null,
                           null,
                           null,
                           { "bSortable": false } ],
            "aoSearchCols": [null,
                             null,
                             null,
                             { "sSearch": "[^0]", "bEscapeRegex": false },
                             null,
                             null ]
        });

        // set up the option to show/hide empty chromosomes
        genomeView.find("#emptyChromosomes input").change(function() {
          var search = $(this).is(":checked") ? "" : "[^0]";
          sequenceTable.fnFilter(search, 3, true, true, false, false);
        });

        // set initialized flag, make sure only initialize once
        genomeView.attr("initialized", "true");
    });
}
