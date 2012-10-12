package ApiCommonWebsite::View::GraphPackage::ToxoDB::Gregory::TgME49RnaSeqTS;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::SimpleStrandSpecificRNASeq );
use ApiCommonWebsite::View::GraphPackage::SimpleStrandSpecificRNASeq;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setMinSenseRpkmProfileSet("T. gondii ME49 time series mRNA Illumina sequences aligned to the ME49 Genome. - sense strand");
  $self->setMinAntisenseRpkmProfileSet("T. gondii ME49 time series mRNA Illumina sequences aligned to the ME49 Genome. - antisense strand");

  $self->setDiffSenseRpkmProfileSet("T. gondii ME49 time series mRNA Illumina sequences aligned to the ME49 Genome. - sense strand - diff");
  $self->setDiffAntisenseRpkmProfileSet("T. gondii ME49 time series mRNA Illumina sequences aligned to the ME49 Genome. - antisense strand - diff");

  $self->setPctSenseProfileSet("percentile - T. gondii ME49 time series mRNA Illumina sequences aligned to the ME49 Genome. - sense strand");
  $self->setPctAntisenseProfileSet("percentile - T. gondii ME49 time series mRNA Illumina sequences aligned to the ME49 Genome. - antisense strand");

  $self->setColor("#6600CC");

  $self->makeGraphs(@_);

  return $self;


}
