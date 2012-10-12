package ApiCommonWebsite::View::GraphPackage::ToxoDB::Gregory::TgVegRnaSeqTS;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::SimpleStrandSpecificRNASeq );
use ApiCommonWebsite::View::GraphPackage::SimpleStrandSpecificRNASeq;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setMinSenseRpkmProfileSet("T. gondii VEG time series mRNA Illumina sequences aligned to the ME49 Genome. - sense strand");
  $self->setMinAntisenseRpkmProfileSet("T. gondii VEG time series mRNA Illumina sequences aligned to the ME49 Genome. - antisense strand");

  $self->setDiffSenseRpkmProfileSet("T. gondii VEG time series mRNA Illumina sequences aligned to the ME49 Genome. - sense strand - diff");
  $self->setDiffAntisenseRpkmProfileSet("T. gondii VEG time series mRNA Illumina sequences aligned to the ME49 Genome. - antisense strand - diff");

  $self->setPctSenseProfileSet("percentile - T. gondii VEG time series mRNA Illumina sequences aligned to the ME49 Genome. - sense strand");
  $self->setPctAntisenseProfileSet("percentile - T. gondii VEG time series mRNA Illumina sequences aligned to the ME49 Genome. - antisense strand");

  $self->setColor("#CC7A00");

  $self->makeGraphs(@_);

  return $self;


}



