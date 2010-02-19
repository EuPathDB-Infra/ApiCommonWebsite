package ApiCommonWebsite::View::GraphPackage::TriTrypDB::Tarleton::TcTranscriptome;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::BarPlot );
use ApiCommonWebsite::View::GraphPackage::BarPlot;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setScreenSize(180);
  $self->setBottomMarginSize(3);

  my $colors =['#E9967A', '#66CDAA', '#8B4513', '#DDA0DD'];

  my $xAxisLabels = ['AMA', 'TRP', 'EPI', 'MET'];

  my $legend = ["amastigotes", "trypomastigotes", "epimastigotes",  "metacyclics"];

  $self->setMainLegend({colors => $colors, short_names => $legend});

  $self->setProfileSetsHash
    ({'fold_induction' => {profiles => ['Profiles of T.cruzi Tarleton Rick array data'],
                           y_axis_label => 'Fold Induction',
                           colors => $colors,
                           make_y_axis_fold_incuction => 1,
                           plot_title => 'Transcriptome analysis of the Trypanosoma cruzi life-cycle',
                           default_y_max => 1.5,
                           default_y_min => -1.5,
                           x_axis_labels => $xAxisLabels,
                          },
      pct => {profiles => ['Percents of T.cruzi Tarleton Rick array data(red)',
                           'Percents of T.cruzi Tarleton Rick array data(green)'
                          ],
              y_axis_label => 'Percentile',
              default_y_max => 50,
              colors => ['#B22222', '#228B22'],
              plot_title => 'Transcriptome analysis of the Trypanosoma cruzi life-cycle - Percentile',
              x_axis_labels => $xAxisLabels,
             },
     });

  return $self;
}



1;
