package ApiCommonWebsite::View::GraphPackage::ToxoDB::Boothroyd::TzBz;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::LinePlotSet );
use ApiCommonWebsite::View::GraphPackage::LinePlotSet;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $colors = ['#8FBC8F'];

  $self->setProfileSetsHash
    ({rma => {profiles => ['expression profiles of T. gondii Matt_Tz-Bz time series'],
              y_axis_label => 'RMA Value (log2)',
              x_axis_label => 'Days',
              colors => $colors,
              plot_title => 'Tachyzoite to Bradyzoite Differentiation Time Series',
              default_y_max => 10,
              default_y_min => 4,
             },

      pct => {profiles => ['expression profile percentiles of T. gondii Matt_Tz-Bz time series'],
              y_axis_label => 'percentile',
              x_axis_label => 'Days',
              colors => $colors,
              plot_title => 'Tachyzoite to Bradyzoite Differentiation Time Series - Percentiles',
              default_y_max => 50,
              default_y_min => 0,
             }
     });

  return $self;
}


1;
