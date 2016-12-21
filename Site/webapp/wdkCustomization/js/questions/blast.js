
$(function() {
    setUpBlastPage();
});

function setUpBlastPage() {
  disableTargetTypeOnRevise();

  // alert user if their sequence input will cause an error
  validateInputsOnSubmit();

  // add warning span to sequence field
  var sequenceValue = $('#BlastQuerySequence').val();
    var sequenceHtml = $('#BlastQuerySequence').parent().html();
    //'<textarea id="sequence" onchange="checkSequenceLength()" rows="4" cols="50" name="value(BlastQuerySequence)"></textarea>
    $('#BlastQuerySequence').parent().html(sequenceHtml +
        '<br/><i>Note: only one input sequence allowed.<br>maximum allowed sequence length is 31K bases.</i><br/><div class="usererror"><span id="short_sequence_warning"></span></div>');    
  $('#BlastQuerySequence').val(sequenceValue);

    // set onchange for sequence field to display appropriate warning message
  $('#BlastQuerySequence').attr("onchange","checkSequenceLength();");

  // set onchange for database type to set blast type-specific fields (i.e. all radio buttons)
  $('input[name="array(BlastDatabaseType)"]').attr("onchange","changeQuestion(); changeAlgorithms();");

  // set onchange for algorithm type to change sequence type (i.e. all radio buttons)
  $('input[name="array(BlastAlgorithm)"]').attr("onchange","changeSequenceLabel(); checkSequenceLength();");

  // set these based on whatever defaults come out of the question page
  changeQuestion();
  changeAlgorithms();
}

function disableTargetTypeOnRevise() {
  $('#BlastQuerySequence').closest('form').filter('.is-revise')
    .find('input[name="array(BlastDatabaseType)"]')
    .prop('disabled', true)
    .parent()
    .css({ color: 'gray' })
    .attr('title', 'Target Data Type cannot be changed when revising a search.');
}

// error messages for sequence validation
var emptyValueMessage = "Sequence value cannot be empty.  Please enter an Input Sequence and try again.";
var onlyDefLineMessage = "Current sequence value contains only a def line.  Please add a sequence and try again.";
var onlyOneSequenceMessage = "Only one sequence is allowed.  Please remove secondary sequences and try again.";

function validateInputsOnSubmit() {
    // only input to check for now is sequence; ensure no whitespace
    $('#BlastQuerySequence').parents('form').submit(function(event) {
        var sequence = $('#BlastQuerySequence').val().trim();
        $('#BlastQuerySequence').val(sequence);
        if (sequence == "") {
            return handleValidationFailure(emptyValueMessage, event);
        }
        // handle newline variations
        sequence = sequence.replace(/\r\n/g, "\n"); // convert any \r\n to just \n
        sequence = sequence.replace(/\r/g, "\n"); // convert any remaining \r to \n
        if (sequence.slice(0,1) == ">") {
            // sequence has a def line; remove it before checking sequence
            var firstNewlineIndex = sequence.indexOf("\n");
            if (firstNewlineIndex == -1 || sequence.length == firstNewlineIndex + 1) {
                return handleValidationFailure(onlyDefLineMessage, event);
            }
            sequence = sequence.substring(firstNewlineIndex).trim();
            if (sequence == "") {
                return handleValidationFailure(onlyDefLineMessage, event);
            }
        }
        // check for other def lines
        if (sequence.indexOf(">") != -1) {
            return handleValidationFailure(onlyOneSequenceMessage, event);
        }

        // allow value to be passed to server
        $('#BlastQuerySequence').closest('form')
          .find('input[name="array(BlastDatabaseType)"]')
          .prop('disabled', false);

        // passed all our tests; appears to be a single valid BLAST sequence
        return true;
    });
}

function handleValidationFailure(message, event) {
  event.stopImmediatePropagation();
  alert(message);
  return false;
}

function changeQuestion() {
    var recordClass = $("input[name='value(BlastRecordClass)']");
  // stores mapping from blast databases to questions  
  var blastDb = getSelectedDatabaseName().toLowerCase();
console.log(blastDb);

  var questionName;
  if (blastDb.indexOf("est") >= 0) {
    questionName = "EstQuestions.EstsBySimilarity";
                recordClass.val("EstRecordClasses.EstRecordClass");
  } else   if (blastDb.indexOf("assem") >= 0) {
    questionName = "AssemblyQuestions.AssembliesBySimilarity";
                recordClass.val("AssemblyRecordClasses.AssemblyRecordClass");
  } else   if (blastDb.indexOf("orf") >= 0) {
    questionName = "OrfQuestions.OrfsBySimilarity";
                recordClass.val("OrfRecordClasses.OrfRecordClass");
  } else   if (blastDb.indexOf("survey") >= 0) {
    questionName = "GenomicSequenceQuestions.GSSBySimilarity";
                recordClass.val("SequenceRecordClasses.SequenceRecordClass");
  } else   if (blastDb.indexOf("genom") >= 0) {
    questionName = "GenomicSequenceQuestions.SequencesBySimilarity";
                recordClass.val("SequenceRecordClasses.SequenceRecordClass");
  } else   if (blastDb.indexOf("popset") >= 0) {
    questionName = "PopsetQuestions.PopsetsBySimilarity";
                recordClass.val("PopsetRecordClasses.PopsetRecordClass");
  } else {
    questionName = "GeneQuestions.GenesBySimilarity";
                recordClass.val("TranscriptRecordClasses.TranscriptRecordClass");
  }
  $('#questionFullName').val(questionName);
}

function changeAlgorithms() {
  // get valid program list (based on data type) and grey inapplicable options
  var tgeUrl = "showRecord.do?name=AjaxRecordClasses.Blast_Transcripts_Genome_Est_TermClass&primary_key=fill";
  var poUrl = "showRecord.do?name=AjaxRecordClasses.Blast_Protein_Orf_TermClass&primary_key=fill";
  var type = getSelectedDatabaseName();
  var sendReqUrl;

  // determine appropriate URL to get list of valid algorithms for this database
  if (type == 'EST' || type == 'Transcripts' || type == 'Genome' ||
    type == 'Genome Survey Sequences' || type == 'PopSet' || type == 'Assemblies'  || type == 'Reference Isolates') {
    sendReqUrl = tgeUrl;
  }
  else if (type == 'ORF' || type == 'Proteins'){
    sendReqUrl = poUrl;
  }
  else {
    alert("Oops! illegal BLAST database type: " + type + ". Please contact the administrator about this error.");
    return;
  }

  // make ajax call to get xml-formatted list; parse and populate
  $.ajax({
    url: sendReqUrl,
    dataType: "xml",
    success: function(xml) {
      // first get currently selected button
      var current = getSelectedAlgorithmName();
      var mustSelectFirst = true;
      var firstValidAlgorithm = "";

      // then deactivate all (will turn back on if appropriate)
      $('input[name="array(BlastAlgorithm)"]').attr("disabled", true).attr("checked", false).parent().children().filter("span").attr("style","color:gray");

      // then reactivate all valid algorithms for this type
      $(xml).find("term").each(function() {
        var algName = $(this).attr("id");
        $('input[value="'+algName+'"]').attr("disabled", false).parent().children().filter("span").attr("style","color:black");
        if (firstValidAlgorithm == "") firstValidAlgorithm = algName;
        if (algName == current) mustSelectFirst = false;
      });

      // reselect current, or select the first activated option if
      //   the previously selected option has been deactivated
      current = (mustSelectFirst ? firstValidAlgorithm : current);
      $('input[value="'+current+'"]').attr("checked", true);

      // update sequence label to reflect new algorithm
      changeSequenceLabel();
    },
    error: function(data, msg, e) {
      alert("ERROR \n "+ msg + "\n" + e +
                  ". \nReloading this page might solve the problem. \nOtherwise, please contact site support.");
    }
  });
}

function changeSequenceLabel() {
  var algorithm = getSelectedAlgorithmName();
  $('#blastAlgo').val(algorithm);
  var label = ((algorithm == "blastp" || algorithm == "tblastn") ? "Protein Sequence" : "Nucleotide Sequence");
  $('#help_BlastQuerySequence').parent().children().filter("span").html(label);
}

function checkSequenceLength() {
  var sequence = $('#BlastQuerySequence').val();
  if (sequence.length != 0){
    var algorithm = getSelectedAlgorithmName();
    var expectationElem = $('#-e')[0];
    var filteredSeq = sequence.replace(/^>.*/,"").replace(/[^a-zA-Z]/g,"");
    if (filteredSeq.length <= 25 && algorithm == "blastn") {
      $('#short_sequence_warning').html("Note: The expect value has been set from " + expectationElem.value + " to 1000 because<br/>your query sequence is less than 25 nucleotides. You may want<br/>to adjust the expect value further to refine the specificity of your<br/>query.");
      expectationElem.value = 1000;
    } else if (filteredSeq.length > 31000) {
      $('#short_sequence_warning').html("Note: The maximum allowed size for your sequence is 31000 base pairs.");
    } else {
      $('#short_sequence_warning').html("");
    }
  } else {
    $('#short_sequence_warning').html("");
  }
}

function getSelectedDatabaseName() { return getSelectedRadioButton("array(BlastDatabaseType)"); }
function getSelectedAlgorithmName() { return getSelectedRadioButton("array(BlastAlgorithm)"); }

function getSelectedRadioButton(radioName) {
  var inputs = $('input[name="' + radioName + '"]');
  for (var y = 0; y < inputs.size(); y++) {
    if (inputs[y].checked) {
      return inputs[y].value;
    }
  }
  if (inputs.size() > 0) {
    // none are selected; return first element
      return inputs[0].value;
  }
  // element not loaded
  return "";
}
