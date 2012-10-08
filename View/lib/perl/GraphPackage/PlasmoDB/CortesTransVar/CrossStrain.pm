package ApiCommonWebsite::View::GraphPackage::PlasmoDB::CortesTransVar::CrossStrain;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;
use ApiCommonWebsite::View::GraphPackage::BarPlot;

use Data::Dumper;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $legendColors = ['#FF0000','#FFFF00','#0000CC','#009900',];
  my $shortNames = ['3D7 derived strains', '7G8 derived strains', 'D10 derived strains', 'HB3 derived strains'];
  $self->setMainLegend({colors => $legendColors, short_names => $shortNames, cols => 2});


  my $strainNames=['P.f. 10G','P.f. 1,2B','P.f. 3D7-B','P.f. 7G8','P.f. AB10','P.f. AB6',
                    'P.f. BB8','P.f. BC4','P.f. D10','P.f. E3','P.f. F1','P.f. G2',
                    'P.f. G4','P.f. HB3A','P.f. HB3B','P.f. KG7','P.f. LD10','P.f. W41',
                    'P.f. WE5','P.f. ZF8',];

  my $colorSet = [ '#FF0000', '#FF0000', '#FF0000','#FFFF00', '#009900','#009900','#009900','#009900', '#0000CC','#0000CC','#0000CC','#0000CC','#0000CC', '#009900','#009900','#FFFF00','#FFFF00', '#FF0000', '#FFFF00','#FFFF00',];
  my @colors = @$colorSet;

  my @profileSetNames = (['Cortes CGH Profiles', '' ,$strainNames]);
  my @percentileSetNames = (['red percentile - Cortes CGH Profiles','',$strainNames]);

  my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileSetNames);
  my $percentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@percentileSetNames);

  my $ratio = ApiCommonWebsite::View::GraphPackage::BarPlot::LogRatio->new(@_);
  $ratio->setProfileSets($profileSets);
  $ratio->setColors(\@colors);
  $ratio->setElementNameMarginSize (6);


  my $percentile = ApiCommonWebsite::View::GraphPackage::BarPlot::Percentile->new(@_);
  $percentile->setProfileSets($percentileSets);
  $percentile->setColors(\@colors);
  $percentile->setElementNameMarginSize (6);

  $self->setGraphObjects($ratio, $percentile);

  return $self;
}



1;
