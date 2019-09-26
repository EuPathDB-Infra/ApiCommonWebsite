package ApiCommonWebsite::View::GraphPackage::Templates::RNASeqTranscriptionSummary;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );
use ApiCommonWebsite::View::GraphPackage::Templates::Expression;
use Data::Dumper;

# @Override
sub getAllProfileSetNames {
  my ($self) = @_;

  my @unionStr = ( 
			#TEMPLATE_ANCHOR transcriptionSummaryGraph
		);
  my $unionStr = join "\n", @unionStr;

  my $id = $self->getId();
  my $sql = "select distinct profile_set_name,
                    dsp.display_name || decode(p.profile_set_suffix, null, '', ' - ' || p.profile_set_suffix) || ', ' || dsp.short_attribution as display_name,
                    dsp.dataset_presenter_id as presenter_id, 
		    ds.order_num
                from apidbtuning.profile p, 
                     apidbtuning.profilesamples ps, 
                     apidbtuning.expressiongraphsdata d,
                     apidbtuning.datasetpresenter dsp,
                    (select '' as dataset_name, 1 as order_num from dual
	$unionStr
                    ) ds
                where p.dataset_type = 'transcript_expression' 
                and p.dataset_subtype = 'rnaseq' 
                and p.profile_type = 'values' 
                and p.source_id = '$id'
                and d.sample_name not like '%antisense%'
                and d.sample_name like '%unique%'
                and p.profile_set_name = ps.study_name
                and ps.protocol_app_node_id = d.protocol_app_node_id
                and p.dataset_name = dsp.name
                and dsp.name = ds.dataset_name
                order by ds.order_num";

  my $dbh = $self->getQueryHandle();
  my $sh = $dbh->prepare($sql);
  $sh->execute();

  my @rv = ();
  while(my ($profileName, $displayName) = $sh->fetchrow_array()) {
    next if($self->isExcludedProfileSet($profileName));
    my $p = {profileName=>$profileName, profileType=>'values', displayName=>$displayName};
    push @rv, $p;
  }
  $sh->finish();

  return \@rv;
}


# @Override
# so as not to sort plotprofiles
sub orderPlotProfiles {
  my ($self, $plotProfiles) = @_;
  return $plotProfiles;
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
