

use warnings;
use strict;

my @lines;
while (<>) {
    chomp;
    push @lines, $_;
}

my $num_lines = @lines; #use of array in scalar context give length of array
# don't do last line (there is no next one)

$num_lines -= 1;

foreach (my $i = 0; $i < $num_lines; $i++) {
    my $next_line = $i+1;
    print "line $i plus $next_line:",$lines[$i],$lines[$i+1],"\n";
}


