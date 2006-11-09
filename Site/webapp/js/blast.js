function changeQuestion(){

        // stores mapping from blast databases to questions
	var blastDb =  document.getElementById( 'BlastDatabaseType' ).value;

	var questionName;

	if (blastDb == "ESTs"){
		questionName = "EstQuestions.EstsBySimilarity";
	} else if (blastDb == "Genes: Proteins"){
		questionName = "GeneQuestions.GenesBySimilarity";
	} else if (blastDb == "Genes: Six frame translated CDSs"){
		questionName = "GeneQuestions.GenesBySimilarity";
	} else if (blastDb == "Genes: Transcripts"){
		questionName = "GeneQuestions.GenesBySimilarity";
	} else if (blastDb == "ORFs"){
		questionName = "OrfQuestions.OrfsBySimilarity";
	} else if (blastDb == "Sequences: Genome"){
		questionName = "GenomicSequenceQuestions.SequencesBySimilarity";
	} else if (blastDb == "ESTs (Pf Pv Py Pb only)"){
		questionName = "EstQuestions.EstsBySimilarity";
	} else if (blastDb == "Genes: Proteins (Pf Pv Py Pb Pc only)"){
		questionName = "GeneQuestions.GenesBySimilarity";
	} else if (blastDb == "Genes: Six frame translated CDSs (Pf Pv Py Pb Pc only)"){
		questionName = "GeneQuestions.GenesBySimilarity";
	} else if (blastDb == "Genes: Transcripts (Pf Pv Py Pb Pc only)"){
		questionName = "GeneQuestions.GenesBySimilarity";
	} else if (blastDb == "ORFs (all species)"){
		questionName = "OrfQuestions.OrfsBySimilarity";
	} else if (blastDb == "Genomic Sequences (all species)"){
		questionName = "GenomicSequenceQuestions.SequencesBySimilarity";
	} else {		
		alert("unknown blast database: " + blastDb);
	}

	document.getElementById( 'questionFullName' ).value = questionName;
}
