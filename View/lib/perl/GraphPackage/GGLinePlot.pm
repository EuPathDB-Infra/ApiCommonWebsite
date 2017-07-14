package ApiCommonWebsite::View::GraphPackage::GGLinePlot;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::PlotPart );
use ApiCommonWebsite::View::GraphPackage::PlotPart;
use ApiCommonWebsite::View::GraphPackage::Util;
use ApiCommonWebsite::View::GraphPackage;

use Data::Dumper;
#--------------------------------------------------------------------------------

sub getIsFilled                  { $_[0]->{'_is_filled'                     }}
sub setIsFilled                  { $_[0]->{'_is_filled'                     } = $_[1]}

sub getForceNoLines              { $_[0]->{'_force_no_lines'                }}
sub setForceNoLines              { $_[0]->{'_force_no_lines'                } = $_[1]}

sub getVaryGlyphByXAxis          { $_[0]->{'_vary_glyph_by_x_axis'          }}
sub setVaryGlyphByXAxis          { $_[0]->{'_vary_glyph_by_x_axis'          } = $_[1]}

sub getPointsPch                 { $_[0]->{'_points_pch'                    }}
sub setPointsPch                 { $_[0]->{'_points_pch'                    } = $_[1]}

sub getDefaultXMax               { $_[0]->{'_default_x_max'                 }}
sub setDefaultXMax               { $_[0]->{'_default_x_max'                 } = $_[1]}

sub getDefaultXMin               { $_[0]->{'_default_x_min'                 }}
sub setDefaultXMin               { $_[0]->{'_default_x_min'                 } = $_[1]}

sub getXaxisLabel                { $_[0]->{'_x_axis_label'                  }}
sub setXaxisLabel                { $_[0]->{'_x_axis_label'                  } = $_[1]}

sub getArePointsLast             { $_[0]->{'_are_points_last'               }}
sub setArePointsLast             { $_[0]->{'_are_points_last'               } = $_[1]}

sub getSmoothLines               { $_[0]->{'_smooth_lines'                  }}
sub setSmoothLines               { $_[0]->{'_smooth_lines'                  } = $_[1]}


sub getSmoothWithLoess           { $_[0]->{'_smooth_with_loess'                  }}
sub setSmoothWithLoess           { $_[0]->{'_smooth_with_loess'                  } = $_[1]}


sub getSplineApproxN             { $_[0]->{'_spline_approx_n'               }}
sub setSplineApproxN             { $_[0]->{'_spline_approx_n'               } = $_[1]}

sub getSplineDF                  { $_[0]->{'_spline_degrees_of_freedom'     }}
sub setSplineDF                  { $_[0]->{'_spline_degrees_of_freedom'     } = $_[1]}

sub getHasMetaData              { $_[0]->{'_has_meta_data'                 }}
sub setHasMetaData              { $_[0]->{'_has_meta_data'                 } = $_[1]}

sub getForceConnectPoints              { $_[0]->{'_force_connect_points'                 }}
sub setForceConnectPoints              { $_[0]->{'_force_connect_points'                 } = $_[1]}

sub blankPlotPart {
  my ($self) = @_;
  $self->blankGGPlotPart(@_);
}

#--------------------------------------------------------------------------------

sub new {
  my $class = shift;

   my $self = $class->SUPER::new(@_);

   $self->setXaxisLabel("Whoops! Object forgot to call setXaxisLabel");
   $self->setDefaultYMax(1);
   $self->setDefaultYMin(-1);
   return $self;
}

#--------------------------------------------------------------------------------

sub makeRPlotString {
  my ($self, $idType) = @_;

  my $sampleLabels = $self->getSampleLabels();

  my $sampleLabelsString = ApiCommonWebsite::View::GraphPackage::Util::rStringVectorFromArray($sampleLabels, 'x.axis.label');

  my $overrideXAxisLabels = scalar @$sampleLabels > 0 ? "TRUE" : "FALSE";

  my $isSVG = lc($self->getFormat()) eq 'svg' ? 'TRUE' : 'FALSE';

  my $colors = $self->getColors();

  my $defaultPch = [ '15', '16', '17', '18', '7:10', '0:6'];

  my $pointsPch = $self->getPointsPch();
  $pointsPch = $defaultPch unless $pointsPch;

  my ($profileFiles, $elementNamesFiles, $stderrFiles);

  my $blankGraph = $self->blankPlotPart();

  eval{
   ($profileFiles, $elementNamesFiles, $stderrFiles) = $self->makeFilesForR($idType);
  };
  if($@) {
    return $blankGraph;

  }

  my $profileSets = $self->getProfileSets();
  my @skipProfileSets;
  my $skipped = 0;

  for(my $i = 0; $i < scalar @$profileSets; $i++) {
    my $profileSet = $profileSets->[$i];

    if(scalar @{$profileSet->errors()} > 0) {
      $skipProfileSets[$i] = "TRUE";
      $skipped++;
      next;
    }

    $skipProfileSets[$i] = "FALSE";
  }

  if(scalar @$profileSets == $skipped) {
    return $blankGraph;
  }

  my $skipProfilesString = ApiCommonWebsite::View::GraphPackage::Util::rBooleanVectorFromArray(\@skipProfileSets, 'skip.profiles');
  my $colorsString = ApiCommonWebsite::View::GraphPackage::Util::rStringVectorFromArray($colors, 'the.colors');
  my $colorsStringNotNamed = ApiCommonWebsite::View::GraphPackage::Util::rStringVectorFromArrayNotNamed($colors);

  my $pointsPchString = ApiCommonWebsite::View::GraphPackage::Util::rNumericVectorFromArray($pointsPch, 'points.pch');

  
  my $rAdjustProfile = $self->getAdjustProfile();
  my $yAxisLabel = $self->getYaxisLabel();
  my $xAxisLabel = $self->getXaxisLabel();
  my $plotTitle = $self->getPlotTitle();

  my $yMax = $self->getDefaultYMax();
  my $yMin = $self->getDefaultYMin();
  my $hideXAxisLabels = $self->getHideXAxisLabels() ? 'TRUE' : 'FALSE';

  my $xMax = $self->getDefaultXMax();
  my $xMin = $self->getDefaultXMin();

  my $yAxisFoldInductionFromM = $self->getMakeYAxisFoldInduction();
  
  my $df = $self->getSplineDF;
  my $pointsLast = $self->getArePointsLast();
  my $rPostscript = $self->getRPostscript();

  my $smoothLines = $self->getSmoothLines();
  my $smoothWithLoess = $self->getSmoothWithLoess();

  my $splineApproxN = $self->getSplineApproxN();

  $yMax = $yMax ? $yMax : "-Inf";
  $yMin = defined($yMin) ? $yMin : "Inf";

  my $isThumbnail = "FALSE";

  if($self->getThumbnail()) {
    $isThumbnail = "TRUE";
  }

  my $isCompactString = "FALSE";

  if($self->isCompact()) {
    $yMax= "-Inf";
    $yMin = "Inf";

    $isCompactString = "TRUE";
  }

  my $coordCartesian = 'FALSE';
  if(defined($xMax) || defined($xMin)) {
    $coordCartesian = 'TRUE';
    if(!defined($xMax)) {
      $xMax = "-Inf";
    }
    if(!defined($xMin)){
      $xMin = "Inf";
    }
  } else {
    $xMax = "-Inf";
    $xMin = "Inf";
  }

  $pointsLast = $pointsLast ? 'TRUE' : 'FALSE';

  $smoothLines = $smoothLines ? 'TRUE' : 'FALSE'; 
  $smoothWithLoess = $smoothWithLoess ? 'TRUE' : 'FALSE'; 

  my $dfString;
  if($df) {
    $dfString = ", df=$df";
  }
  $df = defined($df) ? $dfString : "";

  $yAxisFoldInductionFromM = $yAxisFoldInductionFromM ? 'TRUE' : 'FALSE';

  my $forceNoLines = $self->getForceNoLines() ? 'TRUE' : 'FALSE';
  my $forceConnectPoints = $self->getForceConnectPoints() ? 'TRUE' : 'FALSE';
  my $varyGlyphByXAxis = $self->getVaryGlyphByXAxis() ? 'TRUE' : 'FALSE';
  my $isFilled = $self->getIsFilled() ? 'TRUE' : 'FALSE';

  $rAdjustProfile = $rAdjustProfile ? $rAdjustProfile : "";

  $rPostscript = $rPostscript ? $rPostscript : "";

  $splineApproxN = defined($splineApproxN) ? $splineApproxN : 60;

  my $bottomMargin = $self->getElementNameMarginSize();

  my $profileTypes = $self->getProfileTypes();
  my $profileTypesString = ApiCommonWebsite::View::GraphPackage::Util::rStringVectorFromArray($profileTypes, 'profile.types');

  my $facets = $self->getFacets();
  my $facetString = "DUMMY";
  my $hasFacets = "FALSE";

  if ($facets && scalar @$facets != 0) {
    if(scalar @$facets == 1 && $facets->[0] ne 'none') {
      $facetString = ". ~ " . $facets->[0];
      $hasFacets = "TRUE";
    }elsif(scalar @$facets == 2) {
      if($facets->[1] ne 'none' && $facets->[0] ne 'none') {
        $facetString = $facets->[0] . " ~  " . $facets->[1];
	$hasFacets = "TRUE";
      }elsif($facets->[0] eq 'none' && $facets->[1] ne 'none') {
        $facetString = ". ~ " . $facets->[1];
	$hasFacets = "TRUE";
      }elsif($facets->[0] ne 'none' && $facets->[1] eq 'none') {
	$facetString = ". ~ " . $facets->[0];
        $hasFacets = "TRUE";
      }
    }
  }

  my $fillBelowLine = $self->getFillBelowLine() ? 'TRUE' : 'FALSE';
  my $removeNaN = $self->getRemoveNaN() ? 'TRUE' : 'FALSE';

  my $hasExtraLegend = $self->getHasExtraLegend() ? 'TRUE' : 'FALSE';
  my $extraLegendSize = $self->getExtraLegendSize();

  my $hasMetaData = $self->getHasMetaData() ? 'TRUE' : 'FALSE';

  my $titleLine = $self->getTitleLine();

  my $scale = $self->getScalingFactor;

  my $legendLabels = $self->getLegendLabels;

  my $legendLabelsString = ApiCommonWebsite::View::GraphPackage::Util::rStringVectorFromArray($legendLabels, 'legend.label');


  my $hasLegendLabels = $legendLabelsString ? 'TRUE' : 'FALSE';
  my $rcode = "
# ---------------------------- LINE PLOT ----------------------------


$profileFiles
$elementNamesFiles
$colorsString
$pointsPchString
$sampleLabelsString
$stderrFiles
$legendLabelsString
$skipProfilesString
$profileTypesString

is.compact=$isCompactString;
is.thumbnail=$isThumbnail;

#-------------------------------------------------

if(length(profile.files) != length(element.names.files)) {
  stop(\"profile.files length not equal to element.names.files length\");
}


x.min = $xMin;
x.max = $xMax;

y.min = $yMin;
y.max = $yMax;  


profile.df.full = data.frame();

for(ii in 1:length(profile.files)) {
  skip.stderr = FALSE;

  if(skip.profiles[ii]) {
    next;
  };

  profile.df = read.table(profile.files[ii], header=T, sep=\"\\t\");
  profile.df\$Group.1=NULL

  if(!is.null(profile.df\$ELEMENT_ORDER)) {
    eo.count = length(profile.df\$ELEMENT_ORDER);
    if(!is.numeric(profile.df\$ELEMENT_ORDER)) {
      stop(\"Element order must be numeric for aggregation\");
    }

    profile.df = aggregate(profile.df, list(profile.df\$ELEMENT_ORDER), mean, na.rm=T)
    if(length(profile.df\$ELEMENT_ORDER) != eo.count) {
      skip.stderr = TRUE;
    }

    profile.df\$LEGEND = legend.label[ii];
    profile.df\$PROFILE_FILE = profile.files[ii];
    profile.df\$PROFILE_TYPE = profile.types[ii];
  }

  element.names.df = read.table(element.names.files[ii], header=T, sep=\"\\t\");

  if(length(profile.df\$ELEMENT_ORDER) > length(element.names.df\$ELEMENT_ORDER)) {
    message(paste(\"Warning: profile file \", profile.files[ii], \" contains more rows than element names file\", element.names.files[ii], \". Additional entries will be ignored.\"));
  } else if(length(element.names.df\$ELEMENT_ORDER) > length(profile.df\$ELEMENT_ORDER)) {
    message(paste(\"Warning: element names file \", element.names.files[ii], \" contains more rows than profile file\", profile.files[ii], \". Additional entries will be ignored.\"));
  }

  #if($removeNaN) {
  #  profile.df = completeDF(profile.df, \"VALUE\"); 
  #  element.names.df = element.names.df[which(element.names.df\$ELEMENT_ORDER %in% profile.df\$ELEMENT_ORDER),];
  #}
  profile.df =  merge(profile.df, element.names.df, by = \"ELEMENT_ORDER\");

  #profile.df\$ELEMENT_NAMES = as.character(element.names.df\$NAME);
  profile.df\$ELEMENT_NAMES = as.character(profile.df\$NAME);

  #element.names.numeric = as.numeric(gsub(\" *[a-z-A-Z()+-]+ *\", \"\", element.names.df\$NAME, perl=T));
  element.names.numeric = as.numeric(gsub(\" *[a-z-A-Z()+-]+ *\", \"\", profile.df\$NAME, perl=T));
  profile.df\$ELEMENT_NAMES_NUMERIC = element.names.numeric;

  if (ncol(element.names.df) > 2 ){
  #  profile.df\$CONTXAXIS = element.names.df\$CONTXAXIS;
  #  profile.df\$FACET = as.factor(element.names.df\$FACET);
     profile.df\$FACET = as.factor(profile.df\$FACET)
  }

  if(!skip.stderr && !is.na(stderr.files[ii]) && stderr.files[ii] != '') {
    stderr.tmp = read.table(stderr.files[ii], header=T, sep=\"\\t\");
    profile.df\$STDERR = stderr.tmp\$VALUE;
  }
  else {
    profile.df\$STDERR = NA;
  }

  profile.df = profile.df[, !(names(profile.df) %in% \"NAME\")];

  profile.df.full = rbind(profile.df.full, profile.df);
}

#allow adjustments
$rAdjustProfile

if(\"FACET\" %in% colnames(profile.df.full)) {
  profile.df.full\$FACET_ns=factor(profile.df.full\$FACET,levels=mixedsort(levels(profile.df.full\$FACET)));
}
profile.is.numeric = sum(!is.na(profile.df.full\$ELEMENT_NAMES_NUMERIC)) == nrow(profile.df.full);

coord.cartesian = $coordCartesian
if($removeNaN){
  if(profile.is.numeric) {
    x.max = max(profile.df.full\$ELEMENT_NAMES_NUMERIC);
    x.min = min(profile.df.full\$ELEMENT_NAMES_NUMERIC);
    profile.df.full = completeDF(profile.df.full, \"VALUE\");
    coord.cartesian = TRUE;
  } else {
    profile.df.full = completeDF(profile.df.full, \"VALUE\");
  }
}

if(\"CONTXAXIS\" %in% colnames(profile.df.full) && !all(is.na(profile.df.full\$CONTXAXIS))){
  gp = ggplot(profile.df.full, aes(x=CONTXAXIS, y=VALUE, group=PROFILE_FILE, colour=PROFILE_FILE));
}else if(profile.is.numeric && !$forceNoLines) {
  gp = ggplot(profile.df.full, aes(x=ELEMENT_NAMES_NUMERIC, y=VALUE, group=PROFILE_FILE, colour=PROFILE_FILE));
} else {
  gp = ggplot(profile.df.full, aes(x=ELEMENT_NAMES, y=VALUE, group=PROFILE_FILE, colour=PROFILE_FILE));
}

y.max = max(y.max, max(profile.df.full\$VALUE, na.rm=T), na.rm=TRUE);
y.min = min(y.min, min(profile.df.full\$VALUE, na.rm=T), na.rm=TRUE);

if($isSVG) {
  useTooltips=TRUE;
}else{
  useTooltips=FALSE;
}

if(useTooltips){
#  if(\"CONTXAXIS\" %in% colnames(profile.df.full) && !all(is.na(profile.df.full\$CONTXAXIS))){
#  gp = gp + geom_tooltip(aes(tooltip=paste(\"sample:\",ELEMENT_NAMES,\", x:\",CONTXAXIS)), real.geom=geom_point);
#  } else {
    gp = gp + geom_tooltip(aes(tooltip=ELEMENT_NAMES), real.geom=geom_point);  
#  }
}else{
  gp = gp + geom_point();
}

if(!$forceNoLines) {
  #override earlier group setting if group column exists
  if (\"GROUP\" %in% colnames(profile.df.full)) {
    gp = gp + geom_line(aes(group=GROUP));
  } else {
    gp = gp + geom_line();
  }
  if($fillBelowLine) {
    if(length(unique(profile.df.full\$PROFILE_FILE)) > 1) {
      gp = gp + geom_tooltip(aes(fill=PROFILE_FILE, tooltip=LEGEND, group=PROFILE_FILE), position=\"identity\", real.geom=geom_area) + scale_fill_manual(values=$colorsStringNotNamed);
    } else {
      gp = gp + geom_area(aes(fill=PROFILE_FILE, group=PROFILE_FILE), position=\"identity\") + scale_fill_manual(values=$colorsStringNotNamed);
    }
  }

  if($smoothLines) {
    if(profile.is.numeric && nrow(profile.df.full) > 10) {
      if(length(levels(factor(profile.df.full\$PROFILE_FILE))) == 1) {
        gp = gp + geom_smooth(method=\"loess\");
      }
      if(length(levels(factor(profile.df.full\$PROFILE_FILE))) > 1) {
        gp = gp + geom_smooth(method=\"loess\", se=F);
      }
    }
  }
}

if(coord.cartesian) {
  gp = gp + coord_cartesian(xlim=c(x.min,x.max))
}

gp = gp + scale_colour_manual(values=$colorsStringNotNamed, breaks=profile.df.full\$PROFILE_FILE, labels=profile.df.full\$LEGEND, name=\"Legend\");

hideLegend=FALSE;
if(is.null(profile.df.full\$LEGEND) || $fillBelowLine) {
  hideLegend=TRUE;
}

xAxisCount = length(profile.df.full\$ELEMENT_NAMES);

if(is.compact) {
  gp = gp + theme_void() + theme(legend.position=\"none\");
} else if(is.thumbnail) {
  gp = gp + theme_bw();
  gp = gp + labs(title=\"$plotTitle\", y=\"$yAxisLabel\", x=NULL);
  gp = gp + ylim(y.min, y.max);

  if(!profile.is.numeric) {
    gp = gp + scale_x_discrete(label=function(x) customAbbreviate(x));
    if(xAxisCount > 3) {
      gp = gp + theme(axis.text.x  = element_text(angle=45, vjust=1, hjust=1, size=12), plot.title = element_text(colour=\"#b30000\"));
    }
    gp = gp + theme(axis.text.x  = element_text(angle=90,vjust=0.5, size=12), plot.title = element_text(colour=\"#b30000\"));
  } else {
    gp = gp + theme(axis.text.x  = element_text(angle=90,vjust=0.5, size=12), plot.title = element_text(colour=\"#b30000\"));
  }

  gp = gp + theme(legend.position=\"none\");
} else {
  gp = gp + theme_bw();
  gp = gp + labs(title=\"$plotTitle\", y=\"$yAxisLabel\", x=\"$xAxisLabel\");
  gp = gp + ylim(y.min, y.max);
  gp = gp + theme(plot.title = element_text(colour=\"#b30000\"));

  if(!profile.is.numeric) {
    gp = gp + scale_x_discrete(label=function(x) customAbbreviate(x));
    if(xAxisCount > 3) {
      gp = gp + theme(axis.text.x  = element_text(angle=45, vjust=1, hjust=1, size=12), plot.title = element_text(colour=\"#b30000\"));
    }
    gp = gp + theme(axis.text.x  = element_text(angle=90,vjust=0.5, size=12), plot.title = element_text(colour=\"#b30000\"));
  }

  if(hideLegend) {
    gp = gp + theme(legend.position=\"none\");
  }
}

if(\"FACET\" %in% colnames(profile.df.full)) {
  if(!all(is.na(profile.df.full\$FACET_ns))){
    numLevels=nlevels(profile.df.full\$FACET_ns);
    numCols=ceiling(numLevels / 2);
    if (numLevels > 3) {
      gp = gp + facet_wrap( ~ FACET_ns, ncol=numCols);
    } else {
      gp = gp + facet_grid(. ~ FACET_ns);
    }
  }
}else if($hasFacets) {
  gp = gp + facet_grid($facetString);
}

if($hideXAxisLabels) {                                                                                                                                                                                      
    gp = gp + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank());
}


plotlist[[plotlist.i]] = gp;
plotlist.i = plotlist.i + 1;


";
  return $rcode;
}

1;

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::Percentile;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $id = $self->getId();

   $self->setPartName('percentile');
   $self->setDefaultYMax(100);
   $self->setDefaultYMin(0);
   $self->setYaxisLabel('Percentile');
   $self->setPlotTitle("Percentile - $id");

   $self->setIsLogged(0);

   return $self;
}
1;

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::LogRatio;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $id = $self->getId();

   $self->setDefaultYMax(2);
   $self->setDefaultYMin(-2);

   $self->setPartName('exprn_val');
   $self->setYaxisLabel("Expression Value (log2 ratio)");

   $self->setPlotTitle("Log(ratio) - $id");

   $self->setMakeYAxisFoldInduction(1);
   $self->setIsLogged(1);

   return $self;
}

1;

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::RMA;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $id = $self->getId();

  my $wantLogged = $self->getWantLogged();

  $self->setYaxisLabel("RMA Value (log2)");
  $self->setPlotTitle("RMA Expression Value - $id");
  $self->setIsLogged(1);

  # RMAExpress is log2
  if(defined($wantLogged) && $wantLogged eq '0') {
    $self->setAdjustProfile('lines.df = 2^(lines.df);points.df = 2^(points.df);stderr.df = 2^(stderr.df);');
    $self->setYaxisLabel("RMA Value");
  }

  $self->setDefaultYMax(4);
  $self->setDefaultYMin(0);

  $self->setPartName('rma');

  return $self;
}

1;

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::Filled;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $id = $self->getId();

  $self->setDefaultYMin(0);
  $self->setPartName('filled');

  $self->setIsFilled(1);
  
  return $self;
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::RNASeq;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $id = $self->getId();

  $self->setPartName('fpkm');
  $self->setYaxisLabel('FPKM');
  $self->setPlotTitle("FPKM - $id");
  $self->setDefaultYMin(0);
  $self->setDefaultYMax(20);


  $self->setPointsPch(['NA']);

  $self->setSmoothLines(1);
  $self->setIsFilled(1);
  
  return $self;
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::PairedEndRNASeq;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot::RNASeq );
use strict;

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $id = $self->getId();

  $self->setPartName('fpkm');
  $self->setYaxisLabel('FPKM');
  $self->setPlotTitle("FPKM - $id");

  return $self;
}


#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::QuantileNormalized;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift; 
   my $self = $class->SUPER::new(@_);

   my $id = $self->getId();

   $self->setDefaultYMax(4);
   $self->setDefaultYMin(0);
   $self->setYaxisLabel('Expression Value (log2)');

   $self->setPartName('exprn_val');
   $self->setPlotTitle("Expression Values (log2) - $id");

   $self->setMakeYAxisFoldInduction(0);
   $self->setIsLogged(1);

   return $self;
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::MRNADecay;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift; 
   my $self = $class->SUPER::new(@_);

   my $id = $self->getId();

   $self->setDefaultYMax(4);
   $self->setDefaultYMin(0);
   $self->setYaxisLabel('Expression Values');

   $self->setPartName('exprn_val');
   $self->setPlotTitle("Expression Values - $id");

   $self->setMakeYAxisFoldInduction(0);
   $self->setIsLogged(0);

   return $self;
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::QuantMassSpec;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift; 
   my $self = $class->SUPER::new(@_);

   my $id = $self->getId();

   $self->setIsLogged(1);

   $self->setDefaultYMax(1);
   $self->setDefaultYMin(-1);
   $self->setYaxisLabel('Relative Abundance (log2 ratio)');

   $self->setPartName('exprn_val');
   $self->setPlotTitle("Quant Mass Spec Profile - $id");

   $self->setMakeYAxisFoldInduction(1);


   return $self;
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::QuantMassSpecNonRatio;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift; 
   my $self = $class->SUPER::new(@_);

   my $id = $self->getId();

   $self->setDefaultYMax(10);
   $self->setDefaultYMin(0);
   $self->setYaxisLabel('Abundance (log2)');

   $self->setPartName('exprn_val');
   $self->setPlotTitle("Quant Mass Spec Profile - $id");

   return $self;
}

#--------------------------------------------------------------------------------

package ApiCommonWebsite::View::GraphPackage::GGLinePlot::QuantMassSpecNonRatioUnlogged;
use base qw( ApiCommonWebsite::View::GraphPackage::GGLinePlot );
use strict;

sub new {
  my $class = shift; 
   my $self = $class->SUPER::new(@_);

   my $id = $self->getId();

   $self->setDefaultYMax(10);
   $self->setDefaultYMin(0);
   $self->setYaxisLabel('Abundance');

   $self->setPartName('exprn_val');
   $self->setPlotTitle("Quant Mass Spec Profile - $id");

   return $self;
}

1;
