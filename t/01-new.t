#!perl

use strict; use warnings;
use Filter::DisposableEmail;
use Test::More tests => 1;

eval { Filter::DisposableEmail->new(); };
like($@, qr/Attribute \(key\) is required/);