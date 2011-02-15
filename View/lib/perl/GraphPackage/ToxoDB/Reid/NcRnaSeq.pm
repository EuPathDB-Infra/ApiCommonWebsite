package ApiCommonWebsite::View::GraphPackage::ToxoDB::Reid::NcRnaSeq;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::BarPlot );
use ApiCommonWebsite::View::GraphPackage::BarPlot;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $colors =['#6A5ACD', '#CD853F'];

  my $legend = ["Uniquely Mapped", "Non-Uniquely Mapped"];
  my $xAxisLabels = ["day 3", "day 4"];

  $self->setMainLegend({colors => $colors, short_names => $legend});

  $self->setProfileSetsHash
    ({coverage => {profiles => ['N. caninum Day 3-4 Tachyzoite-profiles', 
                                'N. caninum Day 3-4 Tachyzoite-diff profiles'],
                   y_axis_label => 'log 2 (RPKM)',
                   force_x_axis_label_horizontal => 1,
                   colors => $colors,
                   default_y_max => 4,
                   x_axis_labels =>  $xAxisLabels,
                   stack_bars => 1,
                   r_adjust_profile => 'profile=profile + 1; profile = log2(profile);',
                  },
      pct => {profiles => ['N. caninum Day 3-4 Tachyzoite-percentiles'],
              y_axis_label => 'Percentile',
              force_x_axis_label_horizontal => 1,
              default_y_max => 50,
              colors => [$colors->[0]],
              x_axis_labels =>  $xAxisLabels,
             },
     });

  return $self;
}

1;
