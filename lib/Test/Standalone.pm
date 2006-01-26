###########################################
package Test::Standalone;
###########################################
use strict;
use warnings;
use Filter::Util::Call;
use Sysadm::Install;
use Getopt::Std;

my $CODE       = "";
my $IN_TEST    = 0;
my $TEST_START = qr(^=begin test);
my $TEST_END   = qr(^=end test);

our $VERSION = "0.01";

###########################################
sub import {
###########################################
    my($type, @arguments) = @_ ;
    filter_add([]) ;

    if(@ARGV and $ARGV[0] eq "-t") {
#print "Test Mode\n";
        $IN_TEST = 1;
    }
}

###########################################
sub filter {
###########################################
    my $status = filter_read();
    if(/$TEST_START/ .. /$TEST_END/) {
        if(!/$TEST_START/ and !/$TEST_END/) {
            $CODE .= $_;
        }
    }
    if($IN_TEST) {
        if( s/^main\s*\(\)/Test::Standalone::test_run()/ ) {
#print "Replaced $&\n";
            $IN_TEST = 0;
        }
    }
    $status;
}

###########################################
sub test_run {
###########################################
    my $code = "package main; " .
               Test::Standalone::test_code();

#print "Running test code: [$code]\n";

    eval $code or die "eval failed: $!";
    exit 0;
}

###########################################
sub test_code {
###########################################
    return $CODE;
}

1;

__END__

=head1 NAME

Test::Standalone - Embed regression test suites in standalone scripts

=head1 SYNOPSIS

    use Test::Standalone;

        # script code

    =begin test

        # test code

    =end test

=head1 DESCRIPTION

C<Test::Standalone> helps embedding regression test suites into standalone
scripts.

=head1 EXAMPLES

    use Test::Standalone;

    main();

    sub main {
        for my $file (@ARGV) {
            print "$file has ", -s $file, " bytes\n";
        }
    }

    =begin test
    
    use Test::More tests => 1;

    use File::Temp qw(tempfile); 
    my($fh, $file) = tempfile();
    print $fh "123";
    close $fh;

    @ARGV = ($file);
    is(-s $file, ...

    =end test

=head1 LEGALESE

Copyright 2005 by Mike Schilli, all rights reserved.
This program is free software, you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

2005, Mike Schilli <cpan@perlmeister.com>
