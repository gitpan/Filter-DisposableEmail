#!perl

use strict; use warnings;
use Filter::DisposableEmail;
use Test::More tests => 1;

my $key    = 'Your_API_Key';
my $filter = Filter::DisposableEmail->new($key);

eval { $filter->isDisposable() };
like($@, qr/Mandatory parameter \'email\' missing/);