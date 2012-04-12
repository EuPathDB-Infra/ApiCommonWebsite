package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Cowman::Ver2;

use strict;
use vars qw( @ISA );


@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;
use ApiCommonWebsite::View::GraphPackage::BarPlot;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $legendColors = ['red', 'green', 'blue' ];
  my $legend = ['merozoite invasion', 'SIR2 KO', 'sialic acid-dependent vs. -independent red cell receptor invasion'];

  my $colors = ['red', 'red', 'red', 'green', 'green', 'red','red', 'green', 'green', 'blue', 'blue', 'blue'];

  $self->setMainLegend({colors => $legendColors, short_names => $legend, cols => 1});

  my $rma = ApiCommonWebsite::View::GraphPackage::BarPlot::RMA->new();
  $rma->setProfileSetNames(['Profiles of Cowman Invasion KO-averaged']);
  $rma->setStErrProfileSetNames(['standard error - Profiles of Cowman Invasion KO-averaged']);
  $rma->setColors($colors);
  $rma->setIsHorizontal(1);
  $rma->setElementNameMarginSize(9);
  $rma->setScreenSize(500);

  my $percentile = ApiCommonWebsite::View::GraphPackage::BarPlot::Percentile->new();
  $percentile->setProfileSetNames(['percentile - Profiles of Cowman Invasion KO-averaged']);
  $percentile->setColors($colors);
  $percentile->setIsHorizontal(1);
  $percentile->setElementNameMarginSize(9);
  $percentile->setScreenSize(500);
  
  $self->setGraphObjects($rma, $percentile);

  return $self;






}

1;

