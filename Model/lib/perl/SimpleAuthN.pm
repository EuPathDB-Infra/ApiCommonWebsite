package ApiCommonWebsite::Model::SimpleAuthN;

use strict;
use HTTP::Request::Common;
use LWP::UserAgent; 


sub new {
    my ($class, $email, $password) = @_;
    my $self = {
      authUrl  => 'http://apidb.org/apidb/wdkAuth.jsp',
      email    => $email,
      password => $password,
    };
    bless $self, $class;
    return $self;
}                                                                            



sub authenticate {
    my ($self) = @_;

    my $ua = new LWP::UserAgent; 
    my $res = $ua->request(POST $self->{authUrl}, [
          email => $self->{email}, 
          password => $self->{password},
       ]);  

     return $res->content if $res->is_success;
}

1;