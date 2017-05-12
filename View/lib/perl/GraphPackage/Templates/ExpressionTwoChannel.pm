package ApiCommonWebsite::View::GraphPackage::Templates::ExpressionTwoChannel;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );
use ApiCommonWebsite::View::GraphPackage::Templates::Expression;

sub finalProfileAdjustments {
  my ($self, $profile) = @_;
  my $plotPart = $profile->getPartName();
  if ($plotPart =~/percentile/) {
    my $profileSets = $profile->getProfileSets();

    if(scalar @$profileSets > 2) {
      $profile->setFacets(["PROFILE_TYPE"]);
    }
    else {
      $profile->setHasExtraLegend(1); 
      $profile->setLegendLabels(['channel 1', 'channel 2']);
      $profile->setColors(['LightSlateGray', 'DarkSlateGray']);
    }
    
  }
}
1;

package ApiCommonWebsite::View::GraphPackage::Templates::ExpressionTwoChannel::DS_88b717761e;


1;


package ApiCommonWebsite::View::GraphPackage::Templates::ExpressionTwoChannel::DS_84d52f99c7;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $profileBase = 'Profiles of transcriptional variation in Plasmodium falciparum';

  my @colorSet = ('#FF0000','#FF6600','#FFFF00','#009900','#0000CC','#660033',);
  my $_3d7strains = ['3D7A','10G','1_2B','3D7B','W41'];
  my $_7g8strains = ['KG7','7G8','LD10', 'WE5', 'ZF8'];
  my $hb3strains = ['HB3B','AB10','HB3A','AB6','BB8','BC4'];
  my $d10strains = ['E3','F1','G2','D10','G4'];
  my $parent_strains = ['3D7','7G8','HB3A','D10'];
  my @parental_strains = @$parent_strains[1..3];

  my @colors = (@colorSet[0..4],@colorSet[0..4],@colorSet[0..5],@colorSet[0..4],@colorSet[0..3],);
  my @legend = ("3D7 derived strains","7G8 derived strains", "HB3 derived strains", "D10 derived strains");

  my @legendColors;
  push @legendColors, 'black' for 1 .. 4;
  my @pointsPCH = (19, 24, 15, 23);
  $self->setLegendSize(80);
  $self->setMainLegend({colors => \@legendColors, short_names => \@legend, points_pch => \@pointsPCH, cols => 2, fill=> 0},);

  $self->setPlotWidth(450);
  my @_3d7Colors = @colorSet[0..4];
  my @_7g8Colors = @colorSet[0..4];
  my @hb3Colors = @colorSet[0..5];
  my @d10Colors =  @colorSet[0..4];
  my @parentalColors = @colorSet[1..3];

  my @_3d7Pch;
  my @_7g8Pch;
  my @hb3Pch;
  my @d10Pch;

  push @_3d7Pch, $pointsPCH[0] for 1 .. 5;
  push @_7g8Pch, $pointsPCH[1] for 1 .. 5;
  push @hb3Pch, $pointsPCH[2] for 1 .. 6;
  push @d10Pch, $pointsPCH[3] for 1 .. 5;

  my @parentalPch =@pointsPCH[1..3];

  my @parentalGraphs = $self->defineGraphs('Parental',\@parental_strains, \@parentalColors, $profileBase, \@parentalPch); 
  my @_3d7Graphs = $self->defineGraphs('3D7_derived',$_3d7strains, \@_3d7Colors, $profileBase,  \@_3d7Pch );
  my @_7g8Graphs = $self->defineGraphs('7G8_derived',$_7g8strains, \@_7g8Colors, $profileBase,  \@_7g8Pch );
  my @hb3Graphs = $self->defineGraphs('HB3_derived',$hb3strains, \@hb3Colors, $profileBase,  \@hb3Pch);
  my @d10Graphs = $self->defineGraphs('D10_derived',$d10strains, \@d10Colors, $profileBase, \@d10Pch);

  my $cgh_shortNames = ['3D7 derived strains', '7G8 derived strains', 'D10 derived strains', 'HB3 derived strains'];

  my $cgh_strainNames=['P.f. 10G','P.f. 1,2B','P.f. 3D7-B','P.f. 7G8','P.f. AB10','P.f. AB6',
                    'P.f. BB8','P.f. BC4','P.f. D10','P.f. E3','P.f. F1','P.f. G2',
                    'P.f. G4','P.f. HB3A','P.f. HB3B','P.f. KG7','P.f. LD10','P.f. W41',
                    'P.f. WE5','P.f. ZF8',];

  my $cgh_colorSet = [ '#FF0000', '#FF0000', '#FF0000','#FFFF00', '#009900','#009900','#009900','#009900', '#0000CC','#0000CC','#0000CC','#0000CC','#0000CC', '#009900','#009900','#FFFF00','#FFFF00', '#FF0000', '#FFFF00','#FFFF00',];
  my @cgh_colors = @$cgh_colorSet;

  my @cgh_profileSetNames = (['Cortes CGH Profiles', 'values', '', '', $cgh_strainNames]);

  my $cgh_profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@cgh_profileSetNames);


  my $ratio = ApiCommonWebsite::View::GraphPackage::GGBarPlot::LogRatio->new(@_);
  $ratio->setProfileSets($cgh_profileSets);
  $ratio->setColors(\@cgh_colors);
  $ratio->setElementNameMarginSize (6);
  $ratio->setYaxisLabel('Copy Number Variations (log 2)');
  $ratio->setMakeYAxisFoldInduction(0);
  $ratio->setPartName("CGH");

  $self->setGraphObjects( @_3d7Graphs,  @_7g8Graphs, @hb3Graphs, @d10Graphs, @parentalGraphs, $ratio, );

  return $self;
}

sub defineGraphs {
  my ($self, $tag, $names, $color,  $profile_base, $pointsPch,) = @_;
  my @profileSetNames;
  my $bottomMargin = 6;

  foreach my $name (@$names) {
    $name = lc($name);
    $name =~s/,/_/;
    my @profileSetName = ("$profile_base $name", 'values');
    push(@profileSetNames, [@profileSetName]);
    $name = uc($name);
    $name =~s/_/,/;
    $name =~s/3D7A/3D7-A/;
    $name =~s/3D7B/3D7-B/;
  }


   my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileSetNames);
   my $line = ApiCommonWebsite::View::GraphPackage::GGLinePlot::LogRatio->new(@_);
   $line->setProfileSets($profileSets);
   $line->setColors($color);
   $line->setPointsPch($pointsPch);
   $line->setPartName("exprn_val_$tag");
   $line->setScreenSize(250);
   $line->setElementNameMarginSize($bottomMargin);
   $line->setSmoothLines(1);
   $line->setSplineApproxN(200);
   $line->setSplineDF(5);
   $line->setHasExtraLegend(1);
   $line->setExtraLegendSize(7);
   $line->setLegendLabels($names);
   my $lineTitle = $line->getPlotTitle();
   $line->setPlotTitle("$tag - $lineTitle");
   $line->setXaxisLabel("Hours");


   return( $line );



}
1;


#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::Templates::ExpressionTwoChannel::DS_a8800cfd76;

use Data::Dumper;

# @Override
sub useLegacy {return 1; }


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my @colors = ('blue', 'red', 'orange');
  my @legend = ('HB3', '3D7', 'DD2');

  # TODO: Why isn't the scaling working??
  my $_3D7Scaling = 52/48;

  my @hb3Graphs = $self->defineGraphs('HB3', $colors[0], 'DeRisi HB3 Smoothed', 'DeRisi HB3 non-smoothed', 'Timepoint Mapping And Life Stage Fractions - HB3', undef);
  my @_3D7Graphs = $self->defineGraphs('3D7', $colors[1], 'DeRisi 3D7 Smoothed', 'DeRisi 3D7 non-smoothed', 'Timepoint Mapping And Life Stage Fractions - 3D7', $_3D7Scaling);
  my @dd2Graphs = $self->defineGraphs('Dd2', $colors[2], 'DeRisi Dd2 Smoothed', 'DeRisi Dd2 non-smoothed', 'Timepoint Mapping And Life Stage Fractions - Dd2', undef);


  my $combined = $self->makeCombinedGraph();


  $self->setGraphObjects($combined, @hb3Graphs, @_3D7Graphs, @dd2Graphs);

  return $self;
}

sub getTimePointMapping {
  my ($self, $timePointProfileSetName) = @_;


  my $sql = "select profile_as_string 
from apidbtuning.profile
where source_id = 'timepoint'
and profile_set_name = ?";

  my $qh = $self->getQueryHandle();

  my $sh = $qh->prepare($sql);

  $sh->execute($timePointProfileSetName);

  my ($profileAsString) = $sh->fetchrow_array();
  $sh->finish();
  my @rv = split(/\t/, $profileAsString);


  return \@rv;
}


sub makeCombinedGraph {
  my ($self) = @_;

  my $_3d7ProfileSet = 'DeRisi 3D7 Smoothed';
  my $hb3ProfileSet = 'DeRisi HB3 Smoothed';
  my $dd2ProfileSet = 'DeRisi Dd2 Smoothed';

  my $times_3d7 = $self->getTimePointMapping('Timepoint Mapping And Life Stage Fractions - 3D7');
  my $times_hb3 = $self->getTimePointMapping('Timepoint Mapping And Life Stage Fractions - HB3');
  my $times_dd2 = $self->getTimePointMapping('Timepoint Mapping And Life Stage Fractions - Dd2');


  my @derisiProfileArray = ([$hb3ProfileSet, 'values', '', '', $times_hb3],
                            [$_3d7ProfileSet, 'values', '', '', $times_3d7],
                            [$dd2ProfileSet, 'values', '', '', $times_dd2],
                           );

  my $derisiProfileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@derisiProfileArray);

  my @colors = ('blue', 'red', 'orange', 'cyan', 'purple' );

  my $derisi = ApiCommonWebsite::View::GraphPackage::LinePlot::LogRatio->new(@_);
  $derisi->setProfileSets($derisiProfileSets);
  $derisi->setColors([@colors[0..2]]);
  $derisi->setPointsPch([15,15,15]);
  $derisi->setPartName('exprn_val_overlay');


  $derisi->setHasExtraLegend(1);
  $derisi->setLegendLabels(['HB3', '3D7', 'DD2']);


  return $derisi;
}


sub defineGraphs {
  my ($self, $name, $color, $smoothed, $nonSmoothed, $fraction, $scale) = @_;

  my @pch = (15, 15);  
  my @profileSetNames = ([$smoothed, 'values'],
                         [$nonSmoothed, 'values']
                        );

  my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileSetNames);

  my $line = ApiCommonWebsite::View::GraphPackage::LinePlot::LogRatio->new(@_);
  $line->setProfileSets($profileSets);
  $line->setColors([$color, 'gray']);
  $line->setPointsPch(\@pch);
  $line->setPartName("expr_val_" . $name);
  my $lineTitle = $line->getPlotTitle();
  $line->setPlotTitle("$name - $lineTitle");

   my $percentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([[$smoothed, 'channel1_percentiles']]);
   my $percentile = ApiCommonWebsite::View::GraphPackage::LinePlot::Percentile->new(@_);
   $percentile->setProfileSets($percentileSets);
   $percentile->setPointsPch(['NA']);
   $percentile->setIsFilled(1);
   $percentile->setColors([$color]);
   $percentile->setPartName("percentile_" . $name);
   my $pctTitle = $percentile->getPlotTitle();
   $percentile->setPlotTitle("$name - $pctTitle");

   my @fractions = ([$fraction, 'value', '', '', '', 'erythrocytic ring trophozoite stage', $scale],
                    [$fraction, 'value', '', '', '', 'schizont stage', $scale],
                    [$fraction, 'value', '', '', '', 'trophozoite stage', $scale],
                   );

   my $fractionSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@fractions);

   my $postscript = "
 text(8,  50, col=\"white\", labels=c(\"Ring\"));
 text(23, 50, col=\"white\", labels=c(\"Trophozoite\"));
 text(40, 50, col=\"white\", labels=c(\"Schizont\"));
 ";

   my @colors = ('#E9967A', '#4169E1', '#FF69B4');
   my $lifeStages = ApiCommonWebsite::View::GraphPackage::LinePlot::Filled->new(@_);
   $lifeStages->setProfileSets($fractionSets);
   $lifeStages->setPlotTitle("$name - Life Stage Population Percentages");
   $lifeStages->setYaxisLabel("%");
   $lifeStages->setColors(\@colors);
   $lifeStages->setRPostscript($postscript);
   $lifeStages->setPointsPch(['NA', 'NA', 'NA']);
   $lifeStages->setPartName("lifeStages_" . $name);

  return($line, $percentile, $lifeStages);
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::Templates::ExpressionTwoChannel::DS_b7cf547d33;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);
 my $colors = ['blue', '#4682B4', '#6B8E23', '#00FF00', '#2E8B57'];
  my $pch = [15,24,20,23,25];

  my $legend = ['Cln/Clb', 'pheromone', 'elutriation', 'cdc15', 'Cho et al'];

  $self->setMainLegend({colors => $colors, short_names => $legend, points_pch=> $pch, , cols => 3});


  my $clnClbProfileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([['Cln/Clb experiments','values']]);

  my $clnClbPlot = ApiCommonWebsite::View::GraphPackage::BarPlot::LogRatio->new(@_);
  $clnClbPlot->setProfileSets($clnClbProfileSets);
  $clnClbPlot->setPartName('Cln_Clb');
  $clnClbPlot->setForceHorizontalXAxis(1);


  my $pheromoneProfileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([['pheromone experiments','values']]);
  my $pheromonePlot = ApiCommonWebsite::View::GraphPackage::GGLinePlot::LogRatio->new(@_);
  $pheromonePlot->setProfileSets($pheromoneProfileSets);
  $pheromonePlot->setPartName('pheromone');

  my $elutriationProfileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([['elutriation experiments','values']]);
  my $elutriationPlot = ApiCommonWebsite::View::GraphPackage::GGLinePlot::LogRatio->new(@_);
  $elutriationPlot->setProfileSets($elutriationProfileSets);
  $elutriationPlot->setPartName('elutriation');
  
  my $cdc15ProfileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([['cdc15 experiments','values']]);
  my $cdc15Plot = ApiCommonWebsite::View::GraphPackage::GGLinePlot::LogRatio->new(@_);
  $cdc15Plot->setProfileSets($cdc15ProfileSets);
  $cdc15Plot->setPartName('cdc15');

  my $cdc28ProfileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets([['Cho et al','values']]);
  my $cdc28Plot = ApiCommonWebsite::View::GraphPackage::GGLinePlot::LogRatio->new(@_);
  $cdc28Plot->setProfileSets($cdc28ProfileSets);
  $cdc28Plot->setPartName('cdc28');

  $self->setGraphObjects($clnClbPlot, $pheromonePlot, $elutriationPlot, $cdc15Plot, $cdc28Plot);

  return $self;
}

#--------------------------------------------------------------------------------
# TEMPLATE_ANCHOR microarraySimpleTwoChannelGraph




