package Yconnect::Example;
use Mojo::Base 'Mojolicious::Controller';

use HTTP::Request;
use HTTP::Request::Common;
use JSON;
use LWP::UserAgent;
use MIME::Base64;

my $app_id = 'YOUR APP ID';
my $secret = 'YOUR SECRET';
my $state  = 'YOUR STATE';
my $nonce  = 'YOUR NONCE';
my $auth_url     = 'https://auth.login.yahoo.co.jp/yconnect/v1/authorization';
my $token_url    = 'https://auth.login.yahoo.co.jp/yconnect/v1/token';
my $userinfo_url = 'https://userinfo.yahooapis.jp/yconnect/v1/attribute';
my $redirect_url = 'CALLBACK URL';

sub welcome {
  my $self = shift;

  # Create authorization URL
  my $uri = URI->new($auth_url);
  $uri->query_form(
    response_type => 'code id_token',
    client_id => $app_id,
    scope => 'openid profile email address',
    redirect_uri => $redirect_url,
    state => $state,
    nonce => $nonce,
  );

  $self->render(
    auth_url => $uri,
  );
}

sub callback {
  my $self = shift;

  # Handling authorization error 
  if (my $error_code = $self->param('error_code')) {
    $self->render('example/error',
      error_code => $error_code,
      error => $self->param('error'),
      error_description => $self->param('error_description'),
    );
    return;
  }

  # Request access token
  my $code = $self->param('code');
  my $ua = LWP::UserAgent->new;
  my $res = $ua->request(POST $token_url,
    Authorization => sprintf("Basic %s", MIME::Base64::encode("$app_id:$secret", '')),
    Content => [
      grant_type => 'authorization_code',
      code => $code,
      redirect_uri => $redirect_url,
    ]
  ); 

  # Rendering
  if ($res->is_success) {
    $self->session(content => $res->content);
    $self->redirect_to('/hello');
  } else {
    $self->render('example/error',
      error_code => $res->code,
      error => $res->status_line,
      error_description => $res->content,
    );
  }
}

sub hello {
  my $self = shift;
  my $session = $self->session;
  my $info = JSON->new->allow_nonref->decode($session->{content});

  # Request userinfo API
  my $userinfo_uri = URI->new($userinfo_url);
  $userinfo_uri->query_form({schema => 'openid'});
  my $req = HTTP::Request->new('GET' => $userinfo_uri);
  $req->header('Authorization', sprintf("%s %s", $info->{token_type}, $info->{access_token})); 
  my $ua = LWP::UserAgent->new;
  my $res = $ua->request($req);

  # Rendering
  if ($res->is_success) {
    my $userinfo = JSON->new->allow_nonref->decode($res->content);
    my %info;
    for my $key (qw/user_id name
      given_name given_name#ja-Kana-JP given_name#ja-Hani-JP
      family_name family_name#ja-Kana-JP family_name#ja-Hani-JP
      gender birthday locale email email_verified/) {
      $info{userinfo}{$key} = $userinfo->{$key};
    }
    for my $key (qw/country postal_code region locality/) {
      $info{address}{$key} = $userinfo->{address}{$key};
    }
    $self->render(\%info);
  } else {
    $self->render('example/error',
      error_code => $res->code,
      error => $res->status_line,
      error_description => $res->content,
    );
  }
}

1;
__END__
