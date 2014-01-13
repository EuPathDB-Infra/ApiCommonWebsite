package ApiCommonWebsite::View::GraphPackage::ProfileSet;

use strict;

use Data::Dumper;

use ApiCommonWebsite::Model::CannedQuery::ElementNamesWithMetaData;
# Main Profile Set Name
sub getName                      { $_[0]->{'_name'             }}
sub setName                      { $_[0]->{'_name'             } = $_[1]}

sub getElementNames              { $_[0]->{'_element_names'                  }}
sub setElementNames              { $_[0]->{'_element_names'                  } = $_[1]}

sub getRelatedProfileSet         { $_[0]->{'_related_profile_set'             }}
sub setRelatedProfileSet         { $_[0]->{'_related_profile_set'             } = $_[1]}

sub getDisplayName    {
  my ($self) = @_;
  if ($self->{'_display_name'}) {
    return $self->{'_display_name'};
  }
  return $self->getName();
}
sub setDisplayName    { $_[0]->{'_display_name'         } = $_[1]}

sub getProfileFile              { $_[0]->{'_profile_file'               }}
sub setProfileFile              { $_[0]->{'_profile_file'               } = $_[1]}

sub getElementNamesFile         { $_[0]->{'_element_names_file'           }}
sub setElementNamesFile         { $_[0]->{'_element_names_file'           } = $_[1]}

sub getAlternateSourceId              { $_[0]->{'_alternate_source_id'               }}
sub setAlternateSourceId              { $_[0]->{'_alternate_source_id'               } = $_[1]}

sub getScale              { $_[0]->{'_scale'               }}
sub setScale              { $_[0]->{'_scale'               } = $_[1]}

sub getMetaDataCategory         { $_[0]->{'_meta_data_category'               }}
sub setMetaDataCategory         { $_[0]->{'_meta_data_category'               }  = $_[1]}


sub logError              { push @{$_[0]->{'_errors'}}, $_[1] }
sub errors                { $_[0]->{'_errors'               }}

sub new {
  my ($class, $name, $elementNames, $alternateSourceId, $scale, $metaDataCategory, $displayName) = @_;

  unless($name) {
    die "ProfileSet Name missing: $!";
  }

  my $self = bless {}, $class;

  $self->setName($name);
  $self->setDisplayName($displayName);

  unless(ref($elementNames) eq 'ARRAY') {
    $elementNames = [];
  }
  $self->setElementNames($elementNames);
  $self->setAlternateSourceId($alternateSourceId);
  $self->setScale($scale);
  if (defined $metaDataCategory) {
    $self->setMetaDataCategory($metaDataCategory);
  }

  # initialize errors array;
  $self->{_errors} = [];

  return $self;
}

sub writeFiles {
  my ($self, $id, $qh, $suffix, $idType) = @_;

  $id = $self->getAlternateSourceId() ? $self->getAlternateSourceId() : $id;

  $self->writeProfileFile($id, $qh, $suffix, $idType);
  $self->writeElementNamesFile($id, $qh, $suffix);

  # don't need to write the element names file for the related set
  if(my $relatedProfileSet = $self->getRelatedProfileSet()) {
    $suffix = "related" . $suffix;
    $relatedProfileSet->writeProfileFile($id, $qh, $suffix, $idType);

    # track the error for a related profile set (can assume only 1)
    if(my $relatedError = $relatedProfileSet->errors()->[0]) {
      $self->logError($relatedError);
    }

  }
}

sub writeProfileFile{
  my ($self, $id, $qh, $suffix, $idType) = @_;

  my $_dict = {};

  my $profileSetName = $self->getName();
  my $elementNames = $self->getElementNames();

  my $scale = $self->getScale();


  my $profile;
  if(lc($idType) eq 'ec') {
    # TODO: Add CannedQUery here
  }

  else {
    $profile = ApiCommonWebsite::Model::CannedQuery::Profile->new
        ( Name         => "_data_$suffix",
          Id           => $id,
          ProfileSet   => $profileSetName,
          Scale        => $scale,
        );
  }

  $profile->prepareDictionary($_dict);
  $profile->setElementOrder($elementNames) if(scalar @$elementNames > 0);

  my $profile_fn = eval { $profile->makeTabFile($qh, $_dict) }; $@ && $self->logError($@);

  $self->setProfileFile($profile_fn);

}

sub writeElementNamesFile {
  my ($self, $id, $qh, $suffix) = @_;

  my $_dict = {};
 
  my $elementNames = $self->getElementNames();
  my $profileSetName = $self->getName();
  
  my $metaDataCategory = $self->getMetaDataCategory();

   if($metaDataCategory) {
     my $elementNamesProfile = ApiCommonWebsite::Model::CannedQuery::ElementNamesWithMetaData->new
       ( Name         => "_names_$suffix",
         Id           => $id,
         ProfileSet   => $profileSetName,
         MetaDataCategory => $metaDataCategory,
       );
    
     $elementNamesProfile->setElementOrder($elementNames) if(scalar @$elementNames > 0);

     my $elementNames_fn = eval { $elementNamesProfile->makeTabFile($qh, $_dict)  }; $@ && $self->logError($@);

     $self->setElementNamesFile($elementNames_fn);

   }
   else {
    my $elementNamesProfile = ApiCommonWebsite::Model::CannedQuery::ElementNames->new
      ( Name         => "_names_$suffix",
        Id           => $id,
        ProfileSet   => $profileSetName,
      );
    $elementNamesProfile->setElementOrder($elementNames) if(scalar @$elementNames > 0);
    
    my $elementNames_fn = eval { $elementNamesProfile->makeTabFile($qh, $_dict)  }; $@ && $self->logError($@);
    
    $self->setElementNamesFile($elementNames_fn);
  }
}






1;
