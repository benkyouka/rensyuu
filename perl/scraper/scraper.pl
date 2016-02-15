
#use autodie;

use 5.012; # implies "use strict;" use warnings; use strict; use Data::Dumper;
#use autodie;
use WWW::Mechanize;
use HTML::Parser;
use HTML::LinkExtor;
use URI::URL;




my $agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1284.0 Safari/537.13';
  my $mech = WWW::Mechanize->new(
				 agent   => $agent,
				 noproxy => 1,
				);


my @iids = qw (11632 22917 16500 );
  say "-" x 80;
for (@iids) {
  do_iid($_,$mech);
}


# callback to get the title
my $title = '';
sub get_title {
  my ($tagname,$self) = @_;
  return if $tagname ne 'title';
  $self->handler('text' => sub {$title .= shift} , "dtext");
  $self->handler('end' => sub {shift->handler('start' => sub { shift->eof },"self") if shift eq 'title'; },"tagname,self");
}

# Set up a callback that collect image links
my @imgs = ();
my @links = ();
sub get_links {
  my($tag, %attr) = @_;
  push(@imgs, values %attr) if $tag eq 'img';
  push(@links, values %attr) if $tag eq 'a';
}


sub do_iid {
  my $iid = shift;
  my $mech = shift;
  my $url =
    "http://actionjav.com/title.cfm?iid=$iid&console=cover"; #'http://www.actionjav.com/title.cfm?iid=11632';

  chdir "input";
  if (not -s "$iid.html" ) {
      sleep(int(rand(30)));
      $mech->get( $url, ':content_file' => "$iid.html" );
  }

  my $key_flag = 0;
  my $value_flag = 0;

  #get the <title>
  $title = '';
  my $p = HTML::Parser->new( api_version => 3 );
  $p->handler('start' => \&get_title, "tagname, self");
  $p->parse_file("$iid.html");

  #get the <a>, <img>

  @imgs = ();
  @links = ();
  $p = HTML::LinkExtor->new(\&get_links);
  $p->parse_file("$iid.html");

  my %seen = ();
  #get just the high res cover image link
  @imgs = grep { m{web_img/covers_hires_full/}i and not $seen{$_}++ } @imgs;
  @links = grep { ( m{\.wmv$}i or m{\.avi$}i ) and not $seen{$_}++ } @links;

  # Print them out
  chomp $title;
  say $title;
  my ($starring,$video) = $title =~ /(.*?) in (.*?) at/;
  my @actresses = split ' & ', $starring;
  push @actresses,$starring if (@actresses == 0 );
  say "iid is $iid";
  say "starring is [$starring]";
  for (@actresses) {
    say "actress is [$_]";
  }
  say "video is [$video]";
  print join("\n", @imgs), "\n";
  print join("\n", @links), "\n";
  say "-" x 80;

  use XML::MinWriter;

  chdir "..";
  chdir "output";
  open my $fh, ">$iid.xml" or die $!;
  my $wrt = XML::MinWriter->new(OUTPUT => $fh, DATA_MODE => 1, DATA_INDENT => 2);

  $wrt->xmlDecl('iso-8859-1');
  $wrt->startTag('video');

  $wrt->startTag('id');
  $wrt->characters($iid);
  $wrt->endTag();

  $wrt->startTag('title');
  $wrt->characters($video);
  $wrt->endTag();

  $wrt->startTag('starring');
  $wrt->characters($starring);
  $wrt->endTag();

  $wrt->startTag('coverImage');
  $wrt->characters($imgs[0]);
  $wrt->endTag();

  $wrt->startTag('actresses');
  for (@actresses) {
    $wrt->startTag('actress');
    $wrt->characters($_);
    $wrt->endTag();
  }
  $wrt->endTag();

  $wrt->endTag('video');
  $wrt->end;
  close $fh;
  chdir "..";

}
exit 0;
