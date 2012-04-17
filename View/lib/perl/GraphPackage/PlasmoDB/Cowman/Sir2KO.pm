package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Cowman::Sir2KO;

use strict;
use vars qw( @ISA );


@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;
use ApiCommonWebsite::View::GraphPackage::BarPlot;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $colors = ['#6495ED', '#E9967A', '#2F4F4F' ];
  my $legend = ['Wild Type', 'sir2A', 'sir2B'];

  $self->setMainLegend({colors => $colors, short_names => $legend, cols => 3});

  my $wildTypeSamples = ['ring','trophozoite','schizont','','','','','',''];
  my $sir2ASamples = ['','','','ring','trophozoite','schizont','','',''];
  my $sir2BSamples = ['','','', '','','', 'ring','trophozoite','schizont'];

  my @profileArray = (['Profiles of E-TABM-438 from Cowman', 'standard error - Profiles of E-TABM-438 from Cowman', $wildTypeSamples ],
                      ['Profiles of E-TABM-438 from Cowman', 'standard error - Profiles of E-TABM-438 from Cowman', $sir2ASamples ],
                      ['Profiles of E-TABM-438 from Cowman', 'standard error - Profiles of E-TABM-438 from Cowman', $sir2BSamples ],
                     );

  my @percentileArray = (['percentile - Profiles of E-TABM-438 from Cowman', '', $wildTypeSamples],
                         ['percentile - Profiles of E-TABM-438 from Cowman', '', $sir2ASamples],
                         ['percentile - Profiles of E-TABM-438 from Cowman', '', $sir2BSamples],
                        );

  my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileArray);
  my $percentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@percentileArray);

  my $rma = ApiCommonWebsite::View::GraphPackage::BarPlot::RMA->new(@_);
  $rma->setProfileSets($profileSets);
  $rma->setColors($colors);
  $rma->setForceHorizontalXAxis(1);

  my $percentile = ApiCommonWebsite::View::GraphPackage::BarPlot::Percentile->new(@_);
  $percentile->setProfileSets($percentileSets);
  $percentile->setColors($colors);
  $percentile->setForceHorizontalXAxis(1);

  $self->setGraphObjects($rma, $percentile);

  return $self;


}

1;










