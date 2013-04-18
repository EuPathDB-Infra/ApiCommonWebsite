
package ApiCommonWebsite::View::CgiApp::DataPlotter;

=pod

=head1 Purpose

Plot (expression) data in GUS using R.

=head1 Remember!

This is intended as a CGI script.  When testing via the command line
set parameters using this format, 'type=mytype', rather than '--type
mytype'.

=head1 Details

Program takes these parameters:

=over 4

=item type  : string : type of plot to draw; tail of package name

=item id    : string : plots data for object with this ID

=item sid   : string : secondary id for plotting

=item fmt   : string : graphics format to output; [pdf,jpeg,png,gif] defaults to png

=item quiet : int : when non-zero the MIME header and file contents are not output

=item save  : int : when non-zero the temporary files are saved

=back

=cut

# ========================================================================
# ----------------------------- Declarations -----------------------------
# ========================================================================

use strict;

use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::CgiApp );

use ApiCommonWebsite::View::CgiApp;

# ========================================================================
# --------------------------- Required Methods ---------------------------
# ========================================================================

# --------------------------------- run ----------------------------------

sub run {
	 my $Self = shift;
	 my $Cgi  = shift;

	 my $_qh         = $Self->getQueryHandle($Cgi);

	 my $pkg          = $Cgi->param('project_id');
	 my $type           = $Cgi->param('type');
	 my $id             = $Cgi->param('id');
	 my $sid            = $Cgi->param('sid');
	 my $wantLogged     = $Cgi->param('wl');
	 my $format         = $Cgi->param('fmt')    || 'png';
	 my $quiet_b        = $Cgi->param('quiet');
	 my $save_b         = $Cgi->param('save');
	 my $typeArg        = $Cgi->param('typeArg');
         my $template     = $Cgi->param('template');
         my $dataset     = $Cgi->param('dataset');


   my $thumbnail_b    = $Cgi->param('thumb');
   my @visibleParts   = split(',', $Cgi->param('vp') || '');

	 my @errors;

	 push(@errors, 'model must be supplied') if not defined $pkg;
	 push(@errors, $pkg . ' is an unallowed value for Project_id arg') if ($pkg ne 'PlasmoDB' and $pkg ne 'ToxoDB' and $pkg ne 'GiardiaDB' and $pkg ne 'AmoebaDB' and $pkg ne 'TriTrypDB' and $pkg ne 'FungiDB' and $pkg ne 'CryptoDB' and $pkg ne 'PiroplasmaDB' and $pkg ne 'MicrosporidiaDB' and $pkg ne 'HostDB');
	 push(@errors, 'type must be supplied' ) if not defined $type;
	 push(@errors, 'id must be supplied'   ) if not defined $id;

	 if (@errors) {
			die join("\n", @errors);
	 }

	 # will declare this content type
	 my %contentType = ( png  => 'image/png',
                             pdf  => 'application/pdf',
                             jpeg => 'image/jpeg',
                             jpg  => 'image/jpeg',
                             gif  => 'image/gif',
                             table => 'text/html',
										 );

   # some GDD formats may be different from their formats
   my %gddFormat = ( 'jpg' => 'jpeg' );
   my $gddFormat = $gddFormat{$format} || $format;

	 # some extensions may be different from their format
	 my %extension = ( 'jpeg' => 'jpg', table => 'txt' );
	 my $ext = $extension{$format} || $format;

	 # write to these files.
	 my $fmt_f = "/tmp/dataPlotter-$$.$ext";

	 my @filesToDelete = ( $fmt_f );

	 $pkg = "Templates" if($template);

         my $class = "ApiCommonWebsite::View::GraphPackage::$pkg" . "::$type";

         # dataset Need to strip the dashes from package name
         $dataset =~ s/-//g if ($dataset);

         eval "require $class";
         eval "import $class";

	 $class = $class . "::$dataset" if($template);
         my $_gp = eval {
           $class->new({dataPlotterArg => $typeArg,
                        QueryHandle => $_qh,
                        Id => $id,
                        SecondaryId => $sid,
                        Dataset => $dataset,
                        WantLogged => $wantLogged,
                        Format => $gddFormat,
                        OutputFile => $fmt_f,
                        Thumbnail => $thumbnail_b,
                        VisibleParts => \@visibleParts,
                       });
         };

	 if ($@) {
           die "Unable to load driver for '$type': $@";
	 }

	 my @files = $_gp->run();

	 push(@filesToDelete, @files);

	 # output the result; expiration date set to disable caching for
	 # now.

	 if (!$quiet_b) {
			print $Cgi->header(-Content_type => $contentType{$format},
                         -Expires      => 'Sun, 01 Jan 2006 12:00:01 GMT',
                        );
			system "cat $fmt_f";
	 }

	 # report or delete temporary files.
	 if ($save_b) {
      print STDERR join("\t", 'Files', @filesToDelete), "\n";
	 }
   else {
	  map {unlink $_ if $_} @filesToDelete;
   }
}

# ========================================================================
# ---------------------------- End of Package ----------------------------
# ========================================================================

1;
