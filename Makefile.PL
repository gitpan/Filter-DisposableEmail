use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Filter::DisposableEmail',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/Filter/DisposableEmail.pm',
    ABSTRACT_FROM => 'lib/Filter/DisposableEmail.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'Filter-DisposableEmail-*' },
    PREREQ_PM     => {
        'Test::More' => 0,
        'Readonly'   => 0,
        'Mouse'      => '0.93',
        'JSON'       => '2.15',
        'Data::Validate::Email'    => '0.04',
        'HTTP::Request::Common'    => '1.26',
        'LWP::UserAgent'           => '2.33',
        'MouseX::Params::Validate' => '0.01',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);