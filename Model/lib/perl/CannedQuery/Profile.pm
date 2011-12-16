
package ApiCommonWebsite::Model::CannedQuery::Profile;
@ISA = qw( ApiCommonWebsite::Model::CannedQuery );

=pod

=head1 Purpose

This canned query selects a profile with a given ID from a profile of
interest.

It assumes that the values of the profile are in a tab-delimited
string.

=head1 Macros

The following macros must be available to execute this query.

=over

=item ID - oligo or gene id.

=item Profile - source id of the profile set.

=back

=cut

# ========================================================================
# ----------------------------- Declarations -----------------------------
# ========================================================================

use strict;

use ApiCommonWebsite::Model::CannedQuery;

# ========================================================================
# ----------------------- Create, Init, and Access -----------------------
# ========================================================================

# --------------------------------- init ---------------------------------

sub init {
  my $Self = shift;
  my $Args = ref $_[0] ? shift : {@_};

  $Self->SUPER::init($Args);

	$Self->setId                   ( $Args->{Id                  } );
        $Self->setSecondaryId          ( $Args->{SecondaryId         } );
        $Self->setUseSecondary         ( $Args->{UseSecondary        } );
	$Self->setProfileSet           ( $Args->{ProfileSet          } );
        $Self->setElementOrder         ( $Args->{ElementOrder        } ); 

  $Self->setSql(<<Sql);
SELECT profile_AS_STRING
FROM   apidb.Profile    p
,      apidb.ProfileSet ps
WHERE  p.source_id      = '<<Id>>'
AND    p.profile_set_id = ps.profile_set_id
AND    ps.name          = '<<ProfileSet>>'
Sql

  return $Self;
}

# -------------------------------- access --------------------------------

sub getId                   { $_[0]->{'Id'                } }
sub setId                   { $_[0]->{'Id'                } = $_[1]; $_[0] }

sub getSecondaryId          { $_[0]->{'SecondaryId'       } }
sub setSecondaryId          { $_[0]->{'SecondaryId'       } = $_[1]; $_[0] }

sub getUseSecondary         { $_[0]->{'UseSecondary'      } }
sub setUseSecondary         { $_[0]->{'UseSecondary'      } = $_[1]; $_[0] }

sub getProfileSet           { $_[0]->{'ProfileSet'        } }
sub setProfileSet           { $_[0]->{'ProfileSet'        } = $_[1]; $_[0] }

sub getElementOrder         { $_[0]->{'ElementOrder'      } }
sub setElementOrder         { $_[0]->{'ElementOrder'      } = $_[1]; $_[0] }

# ========================================================================
# --------------------------- Support Methods ----------------------------
# ========================================================================

sub prepareDictionary {
	 my $Self = shift;
	 my $Dict = shift || {};

	 my $Rv = $Dict;

	 $Dict->{Id}         = $Self->getUseSecondary() ? $Self->getSecondaryId() : $Self->getId();
	 $Dict->{ProfileSet} = $Self->getProfileSet();

	 return $Rv;
}

# ========================================================================
# ---------------------------- End of Package ----------------------------
# ========================================================================

1;




