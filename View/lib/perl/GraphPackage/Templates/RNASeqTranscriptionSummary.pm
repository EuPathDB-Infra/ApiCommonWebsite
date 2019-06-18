package ApiCommonWebsite::View::GraphPackage::Templates::RNASeqTranscriptionSummary;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );
use ApiCommonWebsite::View::GraphPackage::Templates::Expression;
use Data::Dumper;

# @Override
sub getAllProfileSetNames {
  my ($self) = @_;

  my $id = $self->getId();
  my $sql = "select distinct profile_set_name
		from apidbtuning.profile p, 
		     apidbtuning.profilesamples ps, 
		     apidbtuning.expressiongraphsdata d
                where p.dataset_type = 'transcript_expression' 
                and p.dataset_subtype = 'rnaseq' 
                and p.profile_type = 'values' 
                and p.source_id = '$id'
                and d.sample_name not like '%antisense%'
                and d.sample_name like '%unique%'
                and p.profile_set_name = ps.study_name
                and ps.protocol_app_node_id = d.protocol_app_node_id";

  my $dbh = $self->getQueryHandle();
  my $sh = $dbh->prepare($sql);
  $sh->execute();

  my @rv = ();
  while(my ($profileName) = $sh->fetchrow_array()) {
    next if($self->isExcludedProfileSet($profileName));
    my $p = {profileName=>$profileName, profileType=>'values'};
    push @rv, $p;
  }
  $sh->finish();

  return \@rv;
}

1;


package ApiCommonWebsite::View::GraphPackage::Templates::RNASeqTranscriptionSummary::All;
use base qw( ApiCommonWebsite::View::GraphPackage::Templates::RNASeqTranscriptionSummary );

use strict;

  sub getGraphType { 'line' }
  sub excludedProfileSetsString { '' }
  sub getSampleLabelsString { '' }
  sub getColorsString { 'black' }
  sub getForceXLabelsHorizontalString { 'true' }
  sub getBottomMarginSize { 0 }
  sub getExprPlotPartModuleString { 'RNASeqTranscriptionSummary' }
  sub getXAxisLabel { 'FPKM - Sample 1' }

1;
