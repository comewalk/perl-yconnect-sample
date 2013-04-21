package Yconnect;
use Mojo::Base 'Mojolicious';

sub startup {
  my $self = shift;
  my $r = $self->routes;
  $r->get('/callback')->to('example#callback');
  $r->get('/hello')->to('example#hello');
  $r->get('/')->to('example#welcome');
}

1;
__END__
