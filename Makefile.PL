######################################################################
# Makefile.PL for Test::Standalone
# 2005, Mike Schilli <cpan@perlmeister.com>
######################################################################
use ExtUtils::MakeMaker;

my $meta_merge = {
    META_MERGE => {
        resources => {
            repository  => 'http://github.com/mschilli/test-standalone-perl',
        },
    }
};

WriteMakefile(
    'NAME'         => 'Test::Standalone',
    'VERSION_FROM' => 'lib/Test/Standalone.pm', # finds $VERSION
    'PREREQ_PM'    => { Filter::Util::Call => 0
                      }, # e.g., Module::Name => 1.1
    $ExtUtils::MakeMaker::VERSION >= 6.50 ? (%$meta_merge) : (),
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Test/Standalone.pm',
       AUTHOR     => 'Mike Schilli <cpan@perlmeister.com>') : ()),
);
