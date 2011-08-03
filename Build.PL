use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'Filter::DisposableEmail',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/Filter/DisposableEmail.pm',
    add_to_cleanup    => [ 'Filter-DisposableEmail-*' ],    
    build_requires    => {
        'Test::More'  => 0,
        'Readonly'    => 0,
        'Mouse'       => '0.93',
        'JSON'        => '2.15',
        'Data::Validate::Email'    => '0.04',
        'HTTP::Request::Common'    => '1.26',
        'LWP::UserAgent'           => '2.33',
        'MouseX::Params::Validate' => '0.01',
    },
);

$builder->create_build_script();