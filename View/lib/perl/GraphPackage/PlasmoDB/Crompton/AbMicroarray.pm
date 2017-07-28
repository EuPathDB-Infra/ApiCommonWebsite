package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Crompton::AbMicroarray;

use strict;
use vars qw( @ISA);

use Data::Dumper;

@ISA = qw( EbrcWebsiteCommon::View::GraphPackage::MixedPlotSet);
use EbrcWebsiteCommon::View::GraphPackage::MixedPlotSet;
use EbrcWebsiteCommon::View::GraphPackage::GGScatterPlot;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setPlotWidth(600);
  $self->setScreenSize(300);

  my $colors = ['blue','white'];

  my $facet = $self->getFacets();
  my $contXAxis = $self->getContXAxis();
  
  my @profileSetArray = (['Crompton Ab Microarray Profiles','values', '', '', '', '', '', $facet, '', '', $contXAxis]);
  my $profileSets = EbrcWebsiteCommon::View::GraphPackage::Util::makeProfileSets(\@profileSetArray);

  my $scatter = EbrcWebsiteCommon::View::GraphPackage::GGScatterPlot::LogRatio->new(@_);
#  my $scatter = EbrcWebsiteCommon::View::GraphPackage::ScatterPlot::ClinicalMetaData->new(@_);
  $scatter->setProfileSets($profileSets);
  $scatter->setColors($colors);


  $self->setGraphObjects($scatter);

  return $self;

}
