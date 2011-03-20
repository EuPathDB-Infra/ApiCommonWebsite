package ApiCommonWebsite::View::CgiApp::MailProcessor;


use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser set_message);
use Mail::Send;
use Mail::Sendmail;
use ApiCommonWebsite::View::CgiApp::SpamCan;

BEGIN {
   sub handle_errors {
      my $msg = shift;
      print "<h1>Error</h1>";
      print "<p>$msg</p>";
  }
  set_message(\&handle_errors);
}
    
my $MAIL_PROCESSOR_EMAIL = 'redmine@apidb.org';

sub go {
    my $Self = shift;
    my $cgi = CGI->new();

    my $to1 = join("", @{ $cgi->{'to1'} });
    my $to2 = join("", @{ $cgi->{'to2'} });
    my $to = "$to1$to2";
    my $cc1 = join("", @{ $cgi->{'cc1'} });
    my $cc2 = join("", @{ $cgi->{'cc2'} });
    my $cc = "$cc1$cc2";
    my $subject = join("", @{ $cgi->{'subject'} });
    my $replyTo = join("", @{ $cgi->{'replyTo'} or ['anonymous']}) || 'anonymous';
    my $privacy = join("", @{ $cgi->{'privacy'} or [] });
    my $uid     = join("", @{ $cgi->{'uid'} or [] });
    my $website = join("", @{ $cgi->{'website'} or [$ENV{SERVER_NAME}] });
    my $version = join("", @{ $cgi->{'version'} or [] });
    my $browser = join("", @{ $cgi->{'browser'} or [$ENV{HTTP_USER_AGENT}] });
    my $referer = join("", @{ $cgi->{'referer'} or [$ENV{HTTP_REFERER}] });
    my $ipaddr  = join("", @{ $cgi->{'ipaddr'} or [$ENV{REMOTE_ADDR}] });
    my $reporterEmail = join("", @{ $cgi->{'reporterEmail'} or 'websitesupportform@apidb.org' });

    my $automaticMsg = "****THIS IS NOT A REPLY**** \nThis is an automatic response, that includes your message for your records, to let you know that we have received your email and will get back to you as soon as possible. Thanks so much for contacting us!\n\nThis was your message:\n\n---------------------\n";

    my @addCcField = split(/,/, join("", @{ $cgi->{'addCc'} }));
    if (scalar (@addCcField > 4)) { @addCcField = @addCcField[0..9]; } # max 10 addresses
    
    my $message = join("", @{ $cgi->{'message'} or [] });

    # quick patch to avoid email header injection. Needs review.
    my $disallowed = '[\]\[\(\)|;\^,\/\n\r]';
    $to =~ m/$disallowed/ &&
        die("disallowed character '$&' in To line: '$to'\n");
    $cc =~ m/$disallowed/ &&
        die("disallowed character '$&' in Cc line: '$cc'\n");
    $replyTo =~ m/$disallowed/ &&
        die("disallowed character '$&' in ReplyTo line: '$replyTo'\n");
    $subject =~ m/[\n\r]/ &&
        die("disallowed character '$&' in Subject line: '$subject'\n");
    for my $addCc (@addCcField) {
        $addCc =~ m/$disallowed/ &&
            die("disallowed character '$&' in Cc line: '$addCc'\n");
    }

    my $addCc = join ',', @addCcField; # cleaned, approved list
    
    # testing mode ($cc instead of help@ email, $to instead of redmine's email)
    #$cc = 'mheiges@gmail.com';
    #$to = 'mheiges@uga.edu';
    
    # flag messages having known spam formats
    my $spamcan = ApiCommonWebsite::View::CgiApp::SpamCan->new();
    my $isSpam = $spamcan->tastesLikeSpam($replyTo, $subject, $message, $ipaddr, $browser);
    my $spamWarning;
    if ($isSpam) {
        $subject = "[spam?] $subject";
        $spamWarning = "THIS MESSAGE HAS BEEN FLAGGED AS POSSIBLE SPAM BY THE APIDB MAILPROCESSOR AND NOT ENTERED IN THE TRACKER\n\n";
    }

    my $metaInfo = ""
        . "ReplyTo: $replyTo" . "\n"
        . "Cc: $addCc" . "\n"
        . "Privacy preference: $privacy" . "\n"
        . "Uid: $uid" . "\n"
        . "Browser information: $browser" . "\n"
        . "Referer page: $referer";

    my $cfmMsg;
#    my $message = $automaticMsg . $message . "---------------------";

# sending email to the user so he/she has a record
    if($cc) {
      $cfmMsg = sendMail($cc, $replyTo, $subject, $cc, $metaInfo, $automaticMsg . $message . "\n---------------------", $addCc);
    } else {
      $cfmMsg = "warning: did not cc user because no email was provided\n";
    }

# sending email to help@site
 if($cc) {
      my $internalMetaInfo = "${spamWarning}${metaInfo}";
     $cfmMsg .= "\n\n" . sendMail($replyTo, $cc, $subject, $replyTo, $internalMetaInfo, $message);
    } else {
      $cfmMsg = "warning: did not cc support because no support email is provided\n";
    }

#sending email to redmine
    my $short_desc = $subject;
    if ($to && $subject && ! $isSpam) {
      # for auto submission to redmine
      $metaInfo = ""
        . 'Project: ' . "usersupportrequests" . "\n"
        . 'Category: ' . "$website" . "\n"
        . "\n" . $metaInfo . "\n"
        . "Client IP Address: $ipaddr\n";
     $cfmMsg .= "\n\n" . sendMail($reporterEmail, $to, $subject, $replyTo, $metaInfo, $message);
    } elsif  ($subject) {
      $cfmMsg .= ": no recipient is specified."
               . "\n\nThis indicate a problem with the mail form."
               . " Please contact the webmaster to report the problem.";
    } else {
      $cfmMsg .= " Please provide a subject line for your support request."
    }

    $cfmMsg .= "\n\nPlease use you browser's back button to go back to the website.";


#    print $cgi->header('text/html');
#    print "<pre>$cfmMsg</pre>";

    # apache understands /a/ as current webapp
    print $cgi->redirect("http://" . $ENV{'SERVER_NAME'} . "/a/helpback.jsp");
}

sub sendMail { return &_cpanMailSendmail(@_); }

sub _cpanMailSendmail {
    my ($from, $to, $subject, $replyTo, $metaInfo, $message, $addCc) = @_;

    my $fromName = ($from eq 'anonymous') ? 
        $MAIL_PROCESSOR_EMAIL : $from;

    my %mail = (From    => "$from <$fromName>",
		To      => $to,
		Subject => $subject,
		Cc => $addCc,
		'Reply-To'    => $replyTo,
		Message => "$metaInfo\n\n$message");

    my $success = sendmail(%mail);


    if (!$success) {
      return "Sorry your message was not sent: " . $Mail::Sendmail::error
	. "\n\nPlease use your browser's back button to go back and try again.";
    } else {
      return "Thank you! Your message has been sent  to $to."
    }
}

sub _cpanMailSend {
    my ($from, $to, $subject, $replyTo, $metaInfo, $message) = @_;

    my $msg = new Mail::Send (Subject=>$subject,
			      To=>$to);
    # my $fh = $msg->open;               # some default mailer
    my $fh = $msg->open('sendmail'); # explicit
    print $fh "replyTo: $replyTo\n" . $metaInfo . "\n\n" . $message;
    $fh->close;         # complete the message and send it

    if ($?) {
      return "Sorry your message was not sent: $!"
	. "\n\nPlease use your browser's back button to go back and try again.";
    } else {
      return "Thank you! Your message has been sent."
	. "\n\nPlease use you browser's back button to go back to the website.";
    }
}

sub _unixMail {
    my ($from, $to, $subject, $replyTo, $metaInfo, $message) = @_;
    my $body = "Reply-To: $replyTo" . "\n"
      . $metaInfo . "\n\n" . "$message" . "\n";

    system("echo '$body' | mail -s '$subject' $to");

    if ($?) {
      return "Sorry your message was not sent: $!"
	. "\n\nPlease use your browser's back button to go back and try again.";
    } else {
      return "Thank you! Your message has been sent."
	. "\n\nPlease use you browser's back button to go back to the website.";
    }
}

1;
