use strict; 

my @A= ( 3,2,-6,3,1);

print solution(@A);

sub solution {
    my (@A)=@_;
    # write your code in Perl 5.14
    my $max_ending_here = 0;
    my $max_so_far = 0;
    my $start = 0;
    my $end = 0;

    my $q = 0;
    while ($q < @A) {
        if ($q == 0) {
            $max_ending_here = $max_so_far = $A[$q];
	    print "q[$q] A[q] [$A[$q]] max_so_far[$max_so_far] max_ending_here[$max_ending_here]\n";
            $q++;
            next;
        }
	if ($q == @A) {
	    #next;
	}

        $max_ending_here = bigger_of($A[$q],$max_ending_here + $A[$q]);
        $max_so_far = bigger_of($max_so_far,$max_ending_here);
	print "q[$q] A[q] [$A[$q]] max_so_far[$max_so_far] max_ending_here[$max_ending_here]\n";
        $q++;
    }
    
    return $max_so_far;
}

sub with_swap {
    my ($max_ending_here,$global_max_value,$local_min_value) = @_;
    
    return $global_max_value - $local_min_value + $max_ending_here;  
}

sub bigger_of {
    my $a = shift;
    my $b = shift;
    if ($a > $b) {
        return $a;
    }
    return $b;
}

sub smaller_of {
    my $a = shift;
    my $b = shift;
    if ($a < $b) {
        return $a;
    }
    return $b;
}
