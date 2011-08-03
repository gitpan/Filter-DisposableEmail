package Filter::DisposableEmail;

use Mouse;
use MouseX::Params::Validate;
use Mouse::Util::TypeConstraints;

use Carp;
use Readonly;
use Data::Dumper;

use JSON;
use LWP::UserAgent;
use HTTP::Request::Common;
use Data::Validate::Email qw(is_email is_email_rfc822);

=head1 NAME

Filter::DisposableEmail - Interface to the DEAfilter RESTful API.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
Readonly my $BASE_URL => 'http://www.deafilter.com/classes/DeaFilter.php';

=head1 DESCRIPTION

This module helps you filter Disposable Email Addresses.  It uses DEAfilter RESTful API and no
guarantee is provided by any means.

=head1 CONSTRUCTOR

The only parameter that is required is the API key. You can get one here:

http://www.deafilter.com/register.php

    use strict; use warnings;
    use Filter::DisposableEmail;

    my ($key, $filter);
    $key    = 'Your_API_Key';
    $filter = Filter::DisposableEmail->new($key);
    
    #or
    $filter = Filter::DisposableEmail->new(key => $key);

=cut

type 'Email'   => where { is_email($_) && is_email_rfc822($_) };
has  'key'     => (is => 'ro', isa => 'Str', required => 1);
has  'browser' => (is => 'rw', isa => 'LWP::UserAgent', default => sub { return LWP::UserAgent->new(agent => 'Mozilla/5.0'); });

around BUILDARGS => sub
{
    my $orig  = shift;
    my $class = shift;

    if (@_ == 1 && !ref $_[0])
    {
        return $class->$orig(key => $_[0]);
    }
    else
    {
        return $class->$orig(@_);
    }
};

=head1 METHOD

=head2 isDisposable()

Return 1/0 depending whether the given email address is disposable or not. This simply rely on
DEAfilter API functionality. Because of it's nature, you may sometimes get false alarm.

    use strict; use warnings;
    use Filter::DisposableEmail;

    my $key    = 'Your_API_Key';
    my $filter = Filter::DisposableEmail->new($key);
    print "Yes it is.\n" if $filter->isDisposable(email => 'bill@microsoft.com');

=cut

sub isDisposable
{
    my $self  = shift;
    my %param = validated_hash(\@_,
                'email' => { isa => 'Email' },
                MX_PARAMS_VALIDATE_NO_CACHE => 1);

    my ($browser, $request, $response, $content);
    $browser = $self->browser;
    $browser->env_proxy;
    $response = $browser->request(POST $BASE_URL, [mail => $param{email}, key => $self->key]);
    croak("ERROR: Couldn't fetch data [$BASE_URL]:[".$response->status_line."]\n")
        unless $response->is_success;
    $content  = $response->content;
    croak("ERROR: No data found.\n") unless defined $content;
    
    $content  = from_json($content);
    return (defined($content) && exists($content->{status}) && ($content->{status} =~ /^ok$/i))
           ?
           (1):(0);
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-filter-disposableemail at rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Filter-DisposableEmail>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Filter::DisposableEmail

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Filter-DisposableEmail>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Filter-DisposableEmail>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Filter-DisposableEmail>

=item * Search CPAN

L<http://search.cpan.org/dist/Filter-DisposableEmail/>

=back

=head1 LICENSE AND COPYRIGHT

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

DEAFilter API itself is distributed under the terms of the Gnu GPLv3 licence.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Mouse; # Keywords are removed from the Filter::DisposableEmail package
no Mouse::Util::TypeConstraints;

1; # End of Filter::DisposableEmail
