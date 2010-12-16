
package ApiCommonWebsite::View::GraphPackage::PlasmoDB::DeRisi::Dd2;

=pod

=head1 Description

=cut

# ========================================================================
# ----------------------------- Declarations -----------------------------
# ========================================================================

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::PlasmoDB::DeRisi );

use ApiCommonWebsite::View::GraphPackage::PlasmoDB::DeRisi;

use ApiCommonWebsite::Model::CannedQuery::Profile;
use ApiCommonWebsite::Model::CannedQuery::ProfileSet;

# ========================================================================
# --------------------------- Required Methods ---------------------------
# ========================================================================

sub init {
	my $Self = shift;

	$Self->SUPER::init(@_);

	$Self->setSmoothQuery
	( ApiCommonWebsite::Model::CannedQuery::Profile->new
		( Name      => 'smooth',
			ProfileSet => 'DeRisi Dd2 Smoothed',
		)
	);

	$Self->setRoughQuery
	( ApiCommonWebsite::Model::CannedQuery::Profile->new
		( Name       => 'rough',
			ProfileSet => 'DeRisi Dd2 non-smoothed',
		)
	);

	$Self->setPercentQuery
	( ApiCommonWebsite::Model::CannedQuery::Profile->new
		( Name       => 'percent',
			ProfileSet => 'Percentiles of DeRisi Dd2 Red',
		)
	);

  $Self->setLifeStageQuery
  ( ApiCommonWebsite::Model::CannedQuery::ProfileSet->new
    ( Name       => 'lifestage',
      ProfileSet => 'DeRisi Dd2 Life Stage Fractions',
    )
  );

	return $Self;
}

# ========================================================================
# ---------------------------- End of Package ----------------------------
# ========================================================================

1;
