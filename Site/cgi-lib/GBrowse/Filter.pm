package GBrowse::Filter;

use strict;


sub filterByTaxon {
  my ($f, $value,$IncludeContig) = @_;
  my ($taxon) = $f->get_tag_values("Taxon");
  if ($IncludeContig) {
  my $contig = $f->get_tag_values("Contig");
  $taxon eq qq /$value/ && $contig !~ /-S$/;
  } else {
  $taxon eq qq /$value/;
  }
}

sub filterByExtDbName {
  my ($f, $nm) = @_;
  my ($extdbname) = $f->get_tag_values('ExtDbName');
  $extdbname =~ /$nm/i;
}

sub filterByExtDbNameAndFeatureType {
  my ($f, $nm, $tp) = @_;
  my ($extdbname) = $f->get_tag_values('ExtDbName');
  my ($featuretype) = $f ->get_tag_values('FeatureType');
  (($extdbname =~ /$nm/i) && ($featuretype =~ /$tp/i));
}


sub filterByExtDbNameAndDescription { 
  my ($f, $nm, $desc) = @_;
  my ($extdbname) = $f->get_tag_values('ExtDbName');
  my ($description) = $f->get_tag_values('Description');
  (($extdbname =~ /$nm/i) && ($description =~ /$desc/i));
}


sub filterByDescription { 
  my ($f, $desc)  = @_;
  my $description = $f->get_tag_values('Description');
  ($description !~ /$desc/i);
}


1;
