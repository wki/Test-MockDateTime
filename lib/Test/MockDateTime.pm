package Test::MockDateTime;
use strict;
use warnings;
use DateTime;
use DateTime::Format::DateParse;

use base 'Exporter';

our @EXPORT = 'on';

=head1 NAME

Test::MockDateTime - mock DateTime->now calls during tests

=head1 SYNOPSIS

    use Test::More;
    use Test::MockDateTime;
    use DateTime;
    
    on '2013-01-02 03:04:05' => sub {
        # inside this block all calls to DateTime::now 
        # will report a mocked date.
        
        my $now = DateTime->now;
        is $now->ymd, '2013-01-02', 'occured now';
    };
    
    done_testing;

=head1 DESCRIPTION

Getting the current time sometimes is not very helpful for testing scenarios.
Instead, if you could obtain a known value during the runtime of a testcase
will make your results predictable.

This simple module allows faking a given date and time for the runtime of
a subsequent code block. By default the C<on> keyword is exported into the
namespace of the test file. The date to get mocked must be in a format that
is recognized by L<DateTime::Format::DateParse|DateTime::Format::DateParse>.

    on '2013-01-02 03:04:05', sub { ... };

is basically the same as

    {
        my $now = DateTime::Format::DateParse->parse_datetime(
            '2013-01-02 03:04:05'
        );
        
        local *DateTime::now = sub { $now->clone };
        
        ... everything from code block above
    }

A drawback when relying on this module is that you must know that the module
you are testing uses C<<< DateTime->now >>> to obtain the current time.
=cut

=head1 FUNCTIONS

=cut

=head2 on $date_and_time, \&code

mocks date and time and then executes code

=cut

sub on {
    my ($date, $code) = @_;

    my $now = DateTime::Format::DateParse->parse_datetime($date);

    no warnings 'redefine';
    local *DateTime::now = sub { $now->clone };

    $code->();
}

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
