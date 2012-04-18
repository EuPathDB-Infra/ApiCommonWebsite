package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Kappe::ReplicatesAveraged;

use strict;
use vars qw( @ISA );


@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;
use ApiCommonWebsite::View::GraphPackage::BarPlot;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $colors = [ '#D87093', 'darkblue'];
  my $avgColors = [ '#A0522D'];

#kappe_profiles_averaged_over_all_channels
#percentile - kappe_profiles_averaged_over_all_channels
#standard error - kappe_profiles_averaged_over_all_channels

  my @profileSetsArray = (['kappe_all_comparisons_profiles', 'standard error - kappe_all_comparisons_profiles', '']);
  my @percentileSetsArray = (['red percentile - kappe_all_comparisons_profiles'],
                             ['green percentile - kappe_all_comparisons_profiles'],
                             );



  my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileSetsArray);
  my $percentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@percentileSetsArray);
  my $avgPercentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([['percentile - kappe_profiles_averaged_over_all_channels']]);

  my $ratio = ApiCommonWebsite::View::GraphPackage::BarPlot::LogRatio->new(@_);
  $ratio->setProfileSets($profileSets);
  $ratio->setColors([$colors->[0]]);
  $ratio->setElementNameMarginSize(7);

  my $percentile = ApiCommonWebsite::View::GraphPackage::BarPlot::Percentile->new(@_);
  $percentile->setProfileSets($percentileSets);
  $percentile->setColors($colors);
  $percentile->setSpaceBetweenBars(0.5);
  $percentile->setElementNameMarginSize(7);

  my $avgPercentile = ApiCommonWebsite::View::GraphPackage::BarPlot::Percentile->new(@_);
  $avgPercentile->setProfileSets($avgPercentileSets);
  $avgPercentile->setColors($avgColors);
  $avgPercentile->setPartName("percentile_combined");
  $avgPercentile->setForceHorizontalXAxis(1);

  $self->setGraphObjects($ratio, $percentile, $avgPercentile);

  return $self;


}

1;



