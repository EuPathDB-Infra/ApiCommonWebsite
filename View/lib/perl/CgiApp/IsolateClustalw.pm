package ApiCommonWebsite::View::CgiApp::IsolateClustalw;

@ISA = qw( ApiCommonWebsite::View::CgiApp );

use strict;
use ApiCommonWebsite::View::CgiApp;

use SOAP::Lite;
use CGI::Session;
use XML::XPath;
use XML::XPath::XMLParser;
use Bio::Graphics::Browser2::PadAlignment;

sub run {
  my ($self, $cgi) = @_;

  my $dbh = $self->getQueryHandle($cgi);

  print $cgi->header('text/html');

  $self->processParams($cgi, $dbh);
  $self->handleIsolates($dbh, $cgi);

  exit();
}

sub processParams {
  my ($self, $cgi, $dbh) = @_;
  my $p = $cgi->param('isolate_ids');
  $p =~ s/,$//;
  my @ids = split /,/, $p;
  my $list;
  foreach my $id (@ids){

    $list = $list.  "'" . $id. "',";
  }
  $list =~ s/\,$//;

  $self->{ids} = $list;

}

sub handleIsolates {
  my ($self, $dbh, $cgi) = @_;

  my $ids = $self->{ids};

  my $type  = $cgi->param('type');
  my $start = $cgi->param('start');
  my $end   = $cgi->param('end');
  my $sid   = $cgi->param('sid');

  $start =~ s/,//g;
  $end =~ s/,//g;

  if($end !~  /\d/) {
    $end   = $start + 50;
    $start = $start - 50;
  }
  my $sql = "";

  if($type =~ /htsSNP/i) {
    $ids =~ s/'(\w)/'$sid\.$1/g;
    $sql = <<EOSQL;
select source_id, substr(nas.sequence, $start,$end) as sequence from dots.nasequence nas
where nas.source_id in ($ids) 
EOSQL
    warn "sql: $sql";
  } else {  # regular isolates
    $sql = <<EOSQL;
SELECT etn.source_id, etn.sequence
FROM   ApidbTuning.IsolateSequence etn
WHERE etn.source_id in ($ids)
EOSQL
  }

  my $sequence;
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  while(my ($id, $seq) = $sth->fetchrow_array()) {
    $sequence .= ">$id\n$seq\n";
  }

  # previouse url.
  # ->service('http://ppdev.bioinformatics.vt.edu:6565/axis/services/msa?wsdl');
  my $result = SOAP::Lite
     ->service('http://pathport.bioinformatics.vt.edu:6565/axis/services/msagit?wsdl');

  my $alignment = $result->nucleotide_Alignment("$sequence", "ALIGNED", "", "15.00", "6.66", "15.00", "6.66", "30", "0.50", "iub", "iub");

  my $xml = XML::XPath->new(xml => $alignment);

  my $nodes = $xml->find('/MSAML/alignment/sequence/seqname');
  my (@names, @aligns);

  foreach my $node($nodes->get_nodelist) {
    push @names, $node->string_value();
  }

  $nodes = $xml->find('/MSAML/alignment/sequence/seq');

  foreach my $node($nodes->get_nodelist) {
    my @arr = split /\s+/, $node->string_value();
    push @aligns, \@arr,
  }

  $nodes = $xml->find('/MSAML/alignment/scoring/param');

  my @ws_params;
  foreach my $node($nodes->get_nodelist) {
    push @ws_params, $node;
  }

  my $size = @{$aligns[0]};

  my @sequences;
  my @segments;

  $nodes = $xml->find('/MSAML/alignment/sequence/seqname');

  my (@n, @s);

  foreach my $node($nodes->get_nodelist) {
    push @n, $node->string_value();
  }

  $nodes = $xml->find('/MSAML/alignment/sequence/seq');

  my $length;

  foreach my $node($nodes->get_nodelist) {
    my $seq = $node->string_value();
    $seq =~ s/\s+//g;
    $length = length $seq;
    push @s, $seq;
  }

  $size = @n;
  my $ct = 0;

  for(my $i = 0; $i < $size; $i++) {
    $ct += 1;
    push @sequences, $n[$i];
    push @sequences, $s[$i];
    push @segments, [$n[$i], 0, $length, 0, $length] unless ($ct == 1);
    #push @segments, [$n[$i], 0, $length, 0, $length];
  }

  my $align = Bio::Graphics::Browser2::PadAlignment->new(\@sequences,\@segments);

  print "<table align=center width=800><tr><td>";
  print "<a href='#tree'><h3>To view a guide tree, click here or scroll to the bottom of the page</h3></a>";
  print "</td></tr>";
  print "<tr><td>";
  print $cgi->pre($align->alignment( {}, { show_mismatches   => 1,
                                           show_similarities => 1, 
                                           show_matches      => 1})); 

  print "</td></tr>";

  print "<tr><td><pre><a name='tree'>Guide Tree</a></pre></td></tr>";
  my @parts = $result->packager->parts;
  foreach my $p (@parts) {
    foreach(@$p) {
      my $id = $_->head->get('Content-Id');
      if($id =~ /tree/i) {
        my $tree = $_->bodyhandle->as_string;
        my $link = $self->writetree($tree);
        $self->printApplet($link);
        $tree =~ s/\n/ /g;
        print "<tr><td>$tree</td></tr>";
      }
    }
  }

  print "<tr><td><hr><pre>";

  foreach(@ws_params) { 
    print $_->string_value, "\n"; 
  } 
  
  print "</pre></td></tr>";
  print "</table>";
}

sub printApplet {
  my ($self, $link) = @_;

  my $host = $ENV{'SERVER_NAME'};

print <<EOF;
<tr><td>
<applet archive="forester.jar"
        code="org.forester.atv.ATVe.class"
        codebase="/"
        width="600"
        height="500"
        alt="ATVe is not working on your system (requires at least Sun Java 1.5)!">
        <param name="url_of_tree_to_load" value="http://$host/$link">
        <param name="config_file" value="/_atv_configuration_ncbi_tax">
</applet>
</td></tr>
EOF

}

sub writetree {

  my ($self, $tree) = @_;

  my $ROOT = $ENV{'DOCUMENT_ROOT'};

  my $dir = "$ROOT/gbrowse/tmp/clustalw";

  mkdir("$dir", 0755);
  $self->cleanup($dir);

  my $range = 10000000;
  my $random = int(rand($range));
  my $tree_file = "$dir/$random.tree";
  
  open(TREE, ">$tree_file");
  print TREE $tree;
  close(TREE); 
  chmod 0666, $tree_file;
  
  return "/gbrowse/tmp/clustalw/$random.tree";

}

sub cleanup {
  my ($self, $dir) = @_;
  my $cmd = "find $dir -mtime +10 -exec rm -f {} \\;";
  system($cmd);
}

sub error {
  my ($msg) = @_;

  print "ERROR: $msg\n\n";
  exit(1);
}

1;
