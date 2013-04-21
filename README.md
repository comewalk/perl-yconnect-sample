perl-yconnect-sample
====================

YConnect Sample
-------------------------

Try to run this sample like this. 

1. Install. You need to install [Carton](http://search.cpan.org/dist/carton/) before.
    $ git clone https://github.com/comewalk/perl-yconnect-sample.git
    $ cd perl-yconnect-sample
    $ carton install
2. Edit. Add your Application ID, Secret, Callback URL. If you need to use state and nonce, you can change them.
    $ git diff --no-prefix lib/Yconnect/Example.pm
    diff --git lib/Yconnect/Example.pm lib/Yconnect/Example.pm
    index e37daf8..9a0f842 100644
    --- lib/Yconnect/Example.pm
    +++ lib/Yconnect/Example.pm
    @@ -7,14 +7,14 @@ use JSON;
     use LWP::UserAgent;
     use MIME::Base64;
    
    -my $app_id = 'YOUR APP ID';
    -my $secret = 'YOUR SECRET';
    +my $app_id = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
    +my $secret = 'yyyyyyyyyyyyyyyyyyyyyyyyyyy';
     my $state  = 'YOUR STATE';
     my $nonce  = 'YOUR NONCE';
     my $auth_url     = 'https://auth.login.yahoo.co.jp/yconnect/v1/authorization';
     my $token_url    = 'https://auth.login.yahoo.co.jp/yconnect/v1/token';
     my $userinfo_url = 'https://userinfo.yahooapis.jp/yconnect/v1/attribute';
    -my $redirect_url = 'CALLBACK URL';
    +my $redirect_url = 'http://example.com:5000/callback';
    
     sub welcome {
       my $self = shift;
3. Run.
    $ plackup -I local/lib/perl5 script/yconnect
4. Access to http://example.com:5000/

See Also
-------------------------
[Yahoo! JAPAN Developer Network YConnect](http://developer.yahoo.co.jp/yconnect/)
