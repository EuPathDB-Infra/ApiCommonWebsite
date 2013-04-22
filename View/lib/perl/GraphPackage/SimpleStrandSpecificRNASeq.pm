package ApiCommonWebsite::View::GraphPackage::SimpleStrandSpecificRNASeq;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;

use ApiCommonWebsite::View::GraphPackage::SimpleRNASeq;
use ApiCommonWebsite::View::GraphPackage::Util;

use Data::Dumper;

sub getMinSenseRpkmProfileSet { $_[0]->{_min_sense_rpkm_profile_set} }
sub setMinSenseRpkmProfileSet { $_[0]->{_min_sense_rpkm_profile_set} = $_[1] }

sub getMinAntisenseRpkmProfileSet { $_[0]->{_min_antisense_rpkm_profile_set} }
sub setMinAntisenseRpkmProfileSet { $_[0]->{_min_antisense_rpkm_profile_set} = $_[1] }

sub getDiffSenseRpkmProfileSet { $_[0]->{_diff_sense_rpkm_profile_set} }
sub setDiffSenseRpkmProfileSet { $_[0]->{_diff_sense_rpkm_profile_set} = $_[1] }

sub getDiffAntisenseRpkmProfileSet { $_[0]->{_diff_antisense_rpkm_profile_set} }
sub setDiffAntisenseRpkmProfileSet { $_[0]->{_diff_antisense_rpkm_profile_set} = $_[1] }

sub getPctSenseProfileSet { $_[0]->{_pct_sense_profile_set} }
sub setPctSenseProfileSet { $_[0]->{_pct_sense_profile_set} = $_[1] }

sub getPctAntisenseProfileSet { $_[0]->{_pct_antisense_profile_set} }
sub setPctAntisenseProfileSet { $_[0]->{_pct_antisense_profile_set} = $_[1] }

sub getAdditionalRCode { $_[0]->{_additional_r_code} }
sub setAdditionalRCode { $_[0]->{_additional_r_code} = $_[1] }

sub getColor { $_[0]->{_color} }
sub setColor { $_[0]->{_color} = $_[1] }

sub getSampleNames { $_[0]->{_sample_names} }
sub setSampleNames { $_[0]->{_sample_names} = $_[1] }

sub getIsPairedEnd { $_[0]->{_is_paired_end} }
sub setIsPairedEnd { $_[0]->{_is_paired_end} = $_[1] }

sub setBottomMarginSize { $_[0]->{_bottom_margin_size} = $_[1] }
sub getBottomMarginSize { $_[0]->{_bottom_margin_size} }

sub setForceXLabelsHorizontalString {$_[0]->{_force_x_labels_horizontal} = $_[1]}
sub getForceXLabelsHorizontalString {$_[0]->{_force_x_labels_horizontal}}


sub init {
  my $self = shift;
    
  $self->SUPER::init(@_);
  $self->setBottomMarginSize(8);
}

sub makeGraphs {
  my $self = shift;

  my $color = $self->getColor();
  my $bottomMarginSize = $self->getBottomMarginSize();

  my $isPairedEnd = $self->getIsPairedEnd();

  my $lighterColor = ApiCommonWebsite::View::GraphPackage::Util::getLighterColorFromHex($color);

  my @colors = ($color, '#DDDDDD', $lighterColor, '#DDDDDD');
  my @legend = ("Unique Sense", "Non Unique Sense", "Unique Antisense", "Non Unique Antisense");
  $self->setMainLegend({colors => \@colors, short_names => \@legend, cols => 2});

  my $sense = ApiCommonWebsite::View::GraphPackage::SimpleRNASeq->new(@_);
  $sense->setMinRpkmProfileSet($self->getMinSenseRpkmProfileSet());
  $sense->setDiffRpkmProfileSet($self->getDiffSenseRpkmProfileSet());
  $sense->setPctProfileSet($self->getPctSenseProfileSet());
  $sense->setColor($color);
  $sense->setIsPairedEnd($isPairedEnd);
  $sense->makeGraphs(@_);
  $sense->setBottomMarginSize($bottomMarginSize);
  $sense->setAdditionalRCode($self->getAdditionalRCode());
  $sense->setSampleNames($self->getSampleNames);
  $sense->setForceXLabelsHorizontalString($self->getForceXLabelsHorizontalString());


  my ($senseStacked, $sensePct) = @{$sense->getGraphObjects()};
  $senseStacked->setPartName($senseStacked->getPartName . "_sense");
  $sensePct->setPartName($sensePct->getPartName . "_sense");
  $senseStacked->setPlotTitle($senseStacked->getPlotTitle() . " - sense");
  $sensePct->setPlotTitle($sensePct->getPlotTitle() . " - sense");

  my $antisense = ApiCommonWebsite::View::GraphPackage::SimpleRNASeq->new(@_);
  $antisense->setMinRpkmProfileSet($self->getMinAntisenseRpkmProfileSet());
  $antisense->setDiffRpkmProfileSet($self->getDiffAntisenseRpkmProfileSet());
  $antisense->setPctProfileSet($self->getPctAntisenseProfileSet());
  $antisense->setColor($lighterColor);
  $antisense->setIsPairedEnd($isPairedEnd);
  $antisense->makeGraphs(@_);
  $antisense->setBottomMarginSize($bottomMarginSize);
  $antisense->setAdditionalRCode($self->getAdditionalRCode());
  $antisense->setSampleNames($self->getSampleNames);
  $antisense->setForceXLabelsHorizontalString($self->getForceXLabelsHorizontalString());

  my ($antisenseStacked, $antisensePct) = @{$antisense->getGraphObjects()};
  $antisenseStacked->setPartName($antisenseStacked->getPartName . "_antisense");
  $antisensePct->setPartName($antisensePct->getPartName . "_antisense");
  $antisenseStacked->setPlotTitle($antisenseStacked->getPlotTitle() . " - antisense");
  $antisensePct->setPlotTitle($antisensePct->getPlotTitle() . " - antisense");

  $self->setGraphObjects($senseStacked, $sensePct, $antisenseStacked, $antisensePct);

  return $self;
}
