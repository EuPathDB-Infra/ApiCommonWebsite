
package ApiCommonWebsite::View::GraphPackage::GiardiaDB::Sage::McArthurAntisense;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::BarPlot );
use ApiCommonWebsite::View::GraphPackage::BarPlot;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setScreenSize(300);
  $self->setBottomMarginSize(10);

  $self->setGraphDefaultValue(0);

  my $colors = ['#DEB887'];

  my $xAxisLabels = ['Troph1',
                     '4 hour Encystation',
                     '12 hour Encystation',
                     '21 hour Encystation',
                     '42 hour Encystation',
                     'Cyst',
                     'S1 Excystation',
                     'S2 Excystation',
                     '30 min Excystation',
                     '60 min Excystation'];

  my $legend = ["antisense"];

  $self->setMainLegend({colors => $colors, short_names => $legend});

  $self->setProfileSetsHash
    ({'sage' => {profiles => ['giar sage tag frequencies antisense'],
                 y_axis_label => 'percent',
                 colors => $colors,
                 default_y_max => 0.01,
                 default_y_min => 0,
                 x_axis_labels => $xAxisLabels,
                },
     });

  return $self;
}



1;
