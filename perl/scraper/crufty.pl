#use autodie;

use 5.012; # implies "use strict;" use warnings; use strict; use Data::Dumper;
#use autodie;
use WWW::Mechanize;
use HTML::Parser;
use HTML::LinkExtor;
use URI::URL;

my @iids = qw (11632 22917 16500 );
for (@iids) {
  do_iid($_);
}

my $agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1284.0 Safari/537.13',
my $mech = WWW::Mechanize->new(
			       agent   => $agent,
			       noproxy => 1,
			      );


sub start {
  my ($tagname,$self) = @_;
  return if $tagname ne 'title';
  $self->handler('text' => sub {print shift} , "dtext");
  $self->handler('end' => sub {shift->handler('start' => sub { shift->eof },"self") if shift eq 'title'; },"tagname,self");
}


# Set up a callback that collect image links
  my @imgs = ();
  my @links = ();
  sub callback {
     my($tag, %attr) = @_;
     push(@imgs, values %attr) if $tag eq 'img';
     push(@links, values %attr) if $tag eq 'a';
  }


sub do_iid {
my $iid = shift;
my $url =
  "http://actionjav.com/title.cfm?iid=$iid&console=cover"; #'http://www.actionjav.com/title.cfm?iid=11632';

if (not -s "$iid.html" ) {
  $mech->get( $url, ':content_file' => "$iid.html" );
}

  @imgs = ();
  @links = ();
my $key_flag = 0;
my $value_flag = 0;
	# <!-- video details start -->							
	# 												<table border="0" cellpadding="1" cellspacing="1" width="372" bgcolor="C0C0C0">


# Create parser object
my $p = HTML::Parser->new( api_version => 3 );
$p->handler('start' => \&start, "tagname, self");
$p->parse_file("$iid.html");
#$p->handler('end'   => \&end,"tagname, self");
#die "GET [$url] failed status[",$result->status(),"]" unless
#$result->is_success; say $result->as_string();

#sub video_details_comment {
#  my ($tagname,$self) = @_;
#  $self->handler('text' => "");
#  $self->handler('img' => \&check_img, "

#http://images2.tsunami-ent.com/web_img/covers_hires_full/
#  print $tagname, "\n" if $tagname eq 'comment';
#}

# Make the parser.  Unfortunately, we don't know the base yet
  # (it might be different from $url)
  $p = HTML::LinkExtor->new(\&callback);
  $p->parse_file("$iid.html");

  my %seen = ();
  #get just the high res cover image link
  @imgs = grep { m{web_img/covers_hires_full/}i and not $seen{$_}++ } @imgs;
  @links = grep { ( m{\.wmv$}i or m{\.avi$}i ) and not $seen{$_}++ } @links;
  



  # Print them out
  print join("\n", @imgs), "\n";
  print join("\n", @links), "\n";
}
exit 0;
