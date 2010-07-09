package ApiCommonWebsite::View::GraphPackage::BarPlot;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::AbstractPlot );
use ApiCommonWebsite::View::GraphPackage::AbstractPlot;

use Data::Dumper;

#--------------------------------------------------------------------------------

sub init {
  my $self = shift;
  my $args = ref $_[0] ? shift : {@_};

  $self->SUPER::init($args);

  # Defaults
  $self->setScreenSize(200);
  $self->setBottomMarginSize(5);

  return $self;
}

#--------------------------------------------------------------------------------

sub setMainLegend {
  my ($self, $hash) = @_;

  $hash->{fill} = 1;
  $hash->{points_pch} = [];
  $self->SUPER::setMainLegend($hash);
}

#--------------------------------------------------------------------------------

sub makeRPlotStrings {
  my ($self) = @_;

  my @rv;

  my $profileSetsHash = $self->getProfileSetsHash();

  my $ms = $self->getMultiScreen();

  my %isVis_b = $ms->partIsVisible();

  foreach my $part (keys %$profileSetsHash) {
    next unless ($isVis_b{$part});

    my (@profileFiles, @elementNamesFiles);

    my $i = 0;

    # each part can have several profile sets
    foreach my $profileSetName (@{$profileSetsHash->{$part}->{profiles}}) {
      my $suffix = $part . $i;

      my ($profileFile, $elementNamesFile) = @{$self->writeProfileFiles($profileSetName, $suffix)};

      if($profileFile && $elementNamesFile) {
        push(@profileFiles, $profileFile);
        push(@elementNamesFiles, $elementNamesFile);
      }

      $i++;
    }

    next unless(scalar @profileFiles > 0);

    my $profileFilesString = $self->rStringVectorFromArray(\@profileFiles, 'profile.files');
    my $elementNamesString = $self->rStringVectorFromArray(\@elementNamesFiles, 'element.names.files');

    my $colors = $profileSetsHash->{$part}->{colors};
    my $rColorsString = $self->rStringVectorFromArray($colors, 'the.colors');

    my $rXAxisLabelsString;
    if(my $xAxisLabels = $profileSetsHash->{$part}->{x_axis_labels}) {
      $rXAxisLabelsString = $self->rStringVectorFromArray($xAxisLabels, 'element.names');
    }

    my $legend = $profileSetsHash->{$part}->{legend};
    my $rLegendString = $self->rStringVectorFromArray($legend, 'the.legend');

    my $rAdjustProfile = $profileSetsHash->{$part}->{r_adjust_profile};
    my $yAxisLabel = $profileSetsHash->{$part}->{y_axis_label};
    my $plotTitle = $profileSetsHash->{$part}->{plot_title};

    my $yMax = $profileSetsHash->{$part}->{default_y_max};
    my $yMin = $profileSetsHash->{$part}->{default_y_min};

    my $horizontalXAxis = $profileSetsHash->{$part}->{force_x_axis_label_horizontal};
    my $yAxisFoldInductionFromM = $profileSetsHash->{$part}->{make_y_axis_fold_incuction};

    my $rCode = $self->rString($plotTitle, $profileFilesString, $elementNamesString, $rColorsString, $rLegendString, $yAxisLabel, $rXAxisLabelsString, $rAdjustProfile, $yMax, $yMin, $horizontalXAxis, $yAxisFoldInductionFromM);

    unshift @rv, $rCode;
  }

  return \@rv;
}

#--------------------------------------------------------------------------------

sub rString {
  my ($self, $plotTitle, $profileFiles, $elementNamesFiles, $colorsString, $legend, $yAxisLabel, $rAdjustNames, $rAdjustProfile, $yMax, $yMin, $horizontalXAxisLabels,  $yAxisFoldInductionFromM) = @_;

  $yAxisLabel = $yAxisLabel ? $yAxisLabel : "Whoops! no y_axis_label";
  $rAdjustProfile = $rAdjustProfile ? $rAdjustProfile : "";
  $rAdjustNames = $rAdjustNames ? $rAdjustNames : "";

  $yMax = defined($yMax) ? $yMax : 10;
  $yMin = defined($yMin) ? $yMin : 0;

  $horizontalXAxisLabels = defined($horizontalXAxisLabels) ? 'TRUE' : 'FALSE';

  $yAxisFoldInductionFromM = defined($yAxisFoldInductionFromM) ? 'TRUE' : 'FALSE';

  my $bottomMargin = $self->getBottomMarginSize();

  my $rv = "
# ---------------------------- BAR PLOT ----------------------------

$profileFiles
$elementNamesFiles
$colorsString
$legend

y.min = $yMin;
y.max = $yMax;

screen(screens[screen.i]);
screen.i <- screen.i + 1;

profile = vector();
for(i in 1:length(profile.files)) {
  tmp = read.table(profile.files[i], header=T, sep=\"\\t\");
  tmp = aggregate(tmp, list(tmp\$ELEMENT_ORDER), mean, na.rm=T)

  profile = rbind(profile, tmp\$VALUE);
}

element.names = vector(\"character\");
for(i in 1:length(element.names.files)) {
  tmp = read.table(element.names.files[i], header=T, sep=\"\\t\");
  element.names = rbind(element.names, as.vector(tmp\$NAME));
}


par(mar       = c($bottomMargin,4,1,4), xpd=FALSE, oma=c(1,1,1,1));

# Allow Subclass to fiddle with the data structure and x axis names
$rAdjustProfile
$rAdjustNames

d.max = max(1.1 * profile, y.max);
d.min = min(1.1 * profile, y.min);

my.las = 2;
if(max(nchar(element.names)) < 6 || $horizontalXAxisLabels) {
  my.las = 0;
}

barplot(profile,
        col       = the.colors,
        ylim      = c(d.min, d.max),
        beside    = TRUE,
        names.arg = element.names,
        space=c(0,.5),
        las = my.las,
        axes = FALSE
       );


mtext('$yAxisLabel', side=2, line=3.5, cex.lab=1, las=0)

if(length(the.legend) > 0) {
  legend(11, d.max, legend=the.legend, cex=0.9, fill=the.colors, inset=0.2) ;
}


yAxis = axis(4,tick=F,labels=F);
if($yAxisFoldInductionFromM) {
  yaxis.labels = vector();

  for(i in 1:length(yAxis)) {
    value = yAxis[i];
    if(value > 0) {
      yaxis.labels[i] = round(2^value, digits=1)
    }
    if(value < 0) {
      yaxis.labels[i] = round(-1 * (1 / (2^value)), digits=1);
    }
    if(value == 0) {
      yaxis.labels[i] = 0;
    }
  }


  axis(4,at=yAxis,labels=yaxis.labels,tick=T);  
  axis(2,tick=T,labels=T);
   mtext('Fold Change', side=4, line=2, cex.lab=1, las=0)
} else {
  axis(2);  
}

lines (c(0,length(profile) * 2), c(0,0), col=\"gray25\");

box();


";

  return $rv;
}





1;
