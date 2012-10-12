package ApiCommonWebsite::View::GraphPackage::ToxoDB::Reid::TgVEGRnaSeq;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::SimpleRNASeq );
use ApiCommonWebsite::View::GraphPackage::SimpleRNASeq;

sub init {
  my $self = shift;
  $self->SUPER::init(@_);

  $self->setMinRpkmProfileSet("T. gondii VEG Day 3-4 Tachyzoite aligned to the TgME49 Genome");
  $self->setDiffRpkmProfileSet("T. gondii VEG Day 3-4 Tachyzoite aligned to the TgME49 Genome - diff");
  $self->setPctProfileSet("percentile - T. gondii VEG Day 3-4 Tachyzoite aligned to the TgME49 Genome");
  $self->setColor("#E6CC80");
  $self->makeGraphs(@_);
  $self->setBottomMarginSize(4.5);

  return $self;
}

1;


