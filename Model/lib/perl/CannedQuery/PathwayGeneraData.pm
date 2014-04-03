package ApiCommonWebsite::Model::CannedQuery::PathwayGeneraData;
@ISA = qw( ApiCommonWebsite::Model::CannedQuery );

use strict;

use Data::Dumper;

use ApiCommonWebsite::Model::CannedQuery;

sub init {
  my $Self = shift;
  my $Args = ref $_[0] ? shift : {@_};

  $Self->SUPER::init($Args);

  $Self->setId                   ( $Args->{Id                  } );
  $Self->setGenera($Args->{Genera});



  

  $Self->setSql(<<Sql);
select case when ec.genus is null then 0 else 1 end as value
from (select * 
      from apidb.ecnumbergenus
      where ec_number = '<<Id>>'
        ) ec,
  (
   <<Genera>>
   ) orgs
where orgs.genus = ec.genus (+)
order by orgs.o asc
Sql

  return $Self;
}


sub getId                   { $_[0]->{'Id'                } }
sub setId                   { $_[0]->{'Id'                } = $_[1]; $_[0] }

sub setGenera { $_[0]->{_genera} = $_[1] }
sub getGenera { $_[0]->{_genera} }


sub prepareDictionary {
	 my $Self = shift;
	 my $Dict = shift || {};

	 my $Rv = $Dict;

	 $Dict->{Id}         =  $Self->getId();

         my $i = 1;

         $Dict->{Genera} = join ("\nunion\n", map { "select '$_' as genus, " . $i++ . " as o from dual"  } @{$Self->getGenera()});

	 return $Rv;
}


sub getValues {
   my $Self = shift;
   my $Qh   = shift;
   my $Dict = shift;

   my @Rv;

   # prepare dictionary
   $Dict = $Self->prepareDictionary($Dict);

   # execute SQL and get result
   my $_sql = $Self->getExpandedSql($Dict);

   my $_sh  = $Qh->prepare($_sql);
   $_sh->execute();

     while (my $_row = $_sh->fetchrow_hashref()) {
       push(@Rv, $_row);

       print STDERR Dumper $_row;
     }
   $_sh->finish();

   return wantarray ? @Rv : \@Rv;
}


1;
