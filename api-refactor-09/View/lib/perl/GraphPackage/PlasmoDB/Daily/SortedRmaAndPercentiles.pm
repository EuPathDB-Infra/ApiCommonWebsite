package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Daily::SortedRmaAndPercentiles;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::PlasmoDB::Daily );

use ApiCommonWebsite::View::GraphPackage::PlasmoDB::Daily;

use ApiCommonWebsite::Model::CannedQuery::Profile;
use ApiCommonWebsite::Model::CannedQuery::ProfileSet;
use ApiCommonWebsite::Model::CannedQuery::ElementNames;

my %profileSets = (TGFa =>             ['daily_TGFa_percents', 
                                        'daily_RMA_sorted_by_TGFa'],
                   IL12p70 =>          ['daily_IL12p70_percents', 
                                        'daily_RMA_sorted_by_IL12p70'],
                   TNFa =>             ['daily_TNFa_percents', 
                                        'daily_RMA_sorted_by_TNFa'], 
                   age =>              ['daily_age_percents', 
                                        'daily_RMA_sorted_by_age'],
                   parasitemia =>      ['daily_parasitemia_percents', 
                                        'daily_RMA_sorted_by_parasitemia'],
                   VCAM1 =>            ['daily_VCAM1_percents', 
                                        'daily_RMA_sorted_by_VCAM1'],
                   IL10 =>             ['daily_IL10_percents', 
                                        'daily_RMA_sorted_by_IL10'],
                   Lymphotactin =>     ['daily_Lymphotactin_percents', 
                                        'daily_RMA_sorted_by_Lymphotactin'],
                   'Tissue-Factor' =>  ['daily_Tissue-Factor_percents', 
                                        'daily_RMA_sorted_by_Tissue-Factor'],
                   'P-selectin' =>     ['daily_P-selectin_percents', 
                                        'daily_RMA_sorted_by_P-selectin'],
                   hct =>              ['daily_hct_percents', 
                                        'daily_RMA_sorted_by_hct'],
                   'patient-number' => ['daily_patient-number_percents', 
                                        'daily_RMA_sorted_by_patient-number'],
                   IL15 =>             ['daily_IL15_percents', 
                                        'daily_RMA_sorted_by_IL15'],
                   IL6 =>              ['daily_IL6_percents', 
                                        'daily_RMA_sorted_by_IL6'],
                   temperature =>      ['daily_temp_percents', 
                                        'daily_RMA_sorted_by_temp'],
                   weight =>           ['daily_kg_percents', 
                                        'daily_RMA_sorted_by_kg'],
                   'days-ill' =>       ['daily_days-ill_percents', 
                                        'daily_RMA_sorted_by_days-ill'],
                  );


my %clusters = (167 => 1,
                104 => 1,
                67 =>      1,
                46 =>      1,
                40 =>      1,
                19  =>     1,
                10   =>    1,
                16 => 1,
                188  =>    2,
                159   =>   2,
                158   =>   2,
                155  =>    2,
                145 =>      2,
                122  =>    2,
                109  =>    2,
                106  =>    2,
                105 =>     2,
                102  =>    2,
                51  =>     2,
                42  =>     2,
                39   =>    2,
                24  =>     2,
                20 =>      2,
                14 =>      2,
                28 =>      2,
                147  =>    3,
                96   =>    3,
                81   =>    3,
                72  =>     3,
                68  =>     3,
                57  =>     3,
                '1.04' =>   3,
                '2.04' =>  3,
                '3.04' =>  3,
                '4.04' =>  3,
                '5.04' =>  3,
                '6.04' =>  3,
                '7.04' =>  3,
                '8.04' =>  3,
                '9.04' =>  3,
                '10.04' =>  3,
                '11.04' => 3,
                '12.04' =>  3,
               );


my %colors = (1 => '#6495ED',  # blue
              2 => '#9370D8',  # purple
              3 => '#FFDAB9',  # peach
             );

sub init {
  my $Self = shift;

  $Self->SUPER::init(@_);

  $Self->setDataColors(['#008080']);
  $Self->setPercentileColors(['#DC143C']);
  $Self->setCorrelationColors(['#000080']);

  my $type = $Self->getTypeArg();

  my $_ttl = $profileSets{$type}->[0];

  $Self->setPercentileQuery
    ( ApiCommonWebsite::Model::CannedQuery::Profile->new
      ( Name         => '_data',
        ProfileSet   => $_ttl,
      )
    );

  $Self->setPercentileNamesQuery
    ( ApiCommonWebsite::Model::CannedQuery::ElementNames->new
      ( Name         => '_names',
        ProfileSet   => $_ttl,
      )
	);

  $Self->setPercentileYaxisLabel('percentile');

  $Self->setPctIsDecimal(1);

  $Self->setClusterColors(\%colors);
  $Self->setClusterSampleMap(\%clusters);

  return $Self;
}

1;



