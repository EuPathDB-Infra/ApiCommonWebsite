package ApiCommonWebsite::View::GraphPackage::Templates::RNASeq;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );
use ApiCommonWebsite::View::GraphPackage::Templates::Expression;
use Data::Dumper;

# @Override
sub getKey{
  my ($self, $profileSetName, $profileType) = @_;

  my ($groupName) = $self->getGroupNameFromProfileSetName($profileSetName);
  my ($strand) = $profileSetName =~ /\[.+ \- (.+) \- /;
  $groupName = '' if (!$groupName);
  $profileType = 'percentile' if ($profileType eq 'channel1_percentiles');

  die if (!$strand);
  $strand = $strand eq 'unstranded'? ''  :  '_' . $self->getStrandDictionary()->{$strand};
  return "${groupName}_${profileType}${strand}";
}

sub switchStrands {
  return 0;
}

# @Override
sub getGroupRegex {
  return qr/\- (.+) \[/;
}

# @Override
sub getRemainderRegex {
  return qr/\[(\S+) /;
}


sub getStrandDictionary {
  my $self = shift;
  my $firststrand = 'sense';
  my $secondstrand = 'antisense';

  if ($self->switchStrands()) {
    $firststrand = 'antisense';
    $secondstrand = 'sense';
  }
  return { 'unstranded' => '',
	   'firststrand' => $firststrand,
	   'secondstrand' => $secondstrand
	 };
}

# @Override
sub sortKeys {
  my ($self, $a_tmp, $b_tmp) = @_;

  my ($a_suffix, $a_type, $a_strand) = split(/\_/, $a_tmp);
  my ($b_suffix, $b_type, $b_strand) = split(/\_/, $b_tmp);

  $a_suffix ="" if !($a_suffix);
  $b_suffix ="" if !($b_suffix);

  return ($b_type cmp $a_type)  || ($a_suffix cmp $b_suffix) || ($b_strand cmp $a_strand);

}

# @Override
sub isExcludedProfileSet {
  my ($self, $psName) = @_;
  my ($strand) = $psName =~ /\[.+ \- (.+) \- /;
  $strand = $self->getStrandDictionary()->{$strand};

  my ($isCufflinks) = ($psName =~/\[cuff \-/)? 1: 0;

  my $val =   $self->SUPER::isExcludedProfileSet($self, $psName);
  if ($val) {
#print STDERR "exclude by super - return 1\n";
    return 1;
  } elsif ($psName =~ /htseq-intersection/){
#print STDERR "exclude intersection: $psName - return 1\n";
    return 1;
  } elsif ($isCufflinks){
    return 1;
  } else {
#print STDERR "$psName - return 0\n";
    return 0;
  }

}

1;


package ApiCommonWebsite::View::GraphPackage::Templates::RNASeq::DS_3f5188c7a8;
use base qw( ApiCommonWebsite::View::GraphPackage::Templates::RNASeq );
use strict;
sub getGraphType { 'bar' }
sub excludedProfileSetsString { '' }
sub getSampleLabelsString { '' }
sub getColorsString { '#800080;#008000'  } 
sub getForceXLabelsHorizontalString { 'true' } 
sub getBottomMarginSize { 0 }
sub getExprPlotPartModuleString { 'RNASeq' }
sub getXAxisLabel { '' }
sub switchStrands {
   return 0;
}

sub getRemainderRegex {
  return qr/Horn(.*) \[/;
}

sub finalProfileAdjustments {
  my ($self, $profile) = @_;

  my @labels = map {"fpkm" . $_} @{$profile->getLegendLabels()};
  $profile->setLegendLabels(\@labels);
}




1;



#--------------------------------------------------------------------------------
# TEMPLATE_ANCHOR rnaSeqGraph

# package ApiCommonWebsite::View::GraphPackage::Templates::RNASeq::DS_66f9e70b8a;
# use base qw( ApiCommonWebsite::View::GraphPackage::Templates::RNASeq );
# use strict;
# sub getGraphType { 'bar' }
# sub excludedProfileSetsString { '' }
# sub getSampleLabelsString {''}
# sub getColorsString {}
# sub getForceXLabelsHorizontalString { '1' } 
# sub getBottomMarginSize {  }
# sub getExprPlotPartModuleString { 'RNASeq' }
# sub getXAxisLabel { '' }

1;
