use 5.016;
use warnings;
use autodie;
use Cwd;
use File::Spec;
use File::Copy qw(mv cp);
use File::Basename;
use XML::Entities;
use HTML::Entities;

#
# image manipulation functionality requires having
# the Image Magick free command like tool to be installed
# and on your path
#

%HTML::Entities::char2entity = %{
  XML::Entities::Data::char2entity('all');
};


sub say_tvshow_nfo {
my $fh = shift;
my $title = shift;
my $showtitle = shift;

$title = encode_entities($title);
$showtitle = encode_entities($showtitle);

say $fh '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
say $fh '<tvshow>';
say $fh "    <title>$title</title>";
say $fh "    <showtitle>$showtitle</showtitle>";
say $fh '    <plot>Some specifics about these particular zaps and booms</plot>';
say $fh '</tvshow>';

}

sub say_episode_nfo {
  my $fh = shift;
  my $title = shift;
  my $showtitle = shift;
  my $episode = shift;
  my $year = shift;
  my $season = shift;
  $title = encode_entities($title);
  $showtitle = encode_entities($showtitle);


  say $fh '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
  say $fh '<episodedetails>';
  say $fh "    <title>$title</title>";
  say $fh "    <showtitle>$showtitle</showtitle>";
  say $fh "    <year>$year</year>";
  say $fh "    <season>$season</season>";
  say $fh "    <episode>$episode</episode>";
  say $fh '    <plot>Some specifics about these particular zaps and booms</plot>';
  say $fh '</episodedetails>';
}

sub say_movie_nfo {
  my $fh = shift;
  my $title = shift;
  $title = encode_entities($title);
  say $fh '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>';
  say $fh '<movie>';
  say $fh "    <title>$title</title>";
  say $fh '</movie>';
}

sub image_hook {
#
# use system commands to do imagemagick stuff
# as the work to install the perl interface 
# on a current activestate community perl in
# windows is prohibitive
#

  my $fanart_jpg = (grep { /-fanart\.(jpg|jpeg)$/i } get_jpg_files())[0];
  unless (defined $fanart_jpg) {
    my $cwd =  getcwd;
    warn  "couldn't find a fanart.jpg in directory [$cwd]";
    return;
  }
  my $cover_jpg = $fanart_jpg;
  $cover_jpg =~ s/-fanart\.(jpg|jpeg)$/-cover\.$1/i;


  mv $fanart_jpg, $cover_jpg unless -s $cover_jpg;
  cp $cover_jpg, "tmp.jpg";
  system "convert -crop 52.75x100% tmp.jpg poster.jpg";
  mv "poster-0.jpg", $fanart_jpg;
  unlink "poster-1.jpg","tmp.jpg";

#  if (-s "donotdelete.jpg") {
#    cp "donotdelete.jpg","banner.jpg";
#    system "mogrify -scale 130% poster.jpg"
#  }
#  if (-s "nocrop-donotdelete.jpg") {
#    cp "nocrop-donotdelete.jpg","banner.jpg";
#    cp "nocrop-donotdelete.jpg","poster.jpg";
#    system "mogrify -scale 130% poster.jpg"
#  }

}

sub get_video_files {
  opendir (my $dh, ".");
  my @files = grep { /\.(mkv|mp4|avi|iso|wmv)$/i && ! -d && !/^\./ } readdir $dh;
  closedir $dh;
  return @files;
}

sub get_jpg_files {
  opendir (my $dh, ".");
  my @files = grep { /\.(jpg|jpeg)$/i && ! -d && !/^\./ } readdir $dh;
  closedir $dh;
  return @files;
}


sub regex_clean_basename {
  my $oldname = shift;
  my ($name,$path,$suffix) = fileparse($oldname, qr/\.\w{3}$/);
  $name =~ s/[._\-\[]+H265\]*//i;
  $name =~ s/[._\-\[]+720p\]*//i;
  $name =~ s/[._\-\[]+1080p\]*//i;
  $name =~ s/^dioguitar23.net_//i;
  $name =~ s/[._\-\[]+FHD\]*//i;
  $name =~ s/[._\-\[]+HD\]*//i;
  $suffix ? "$name$suffix" : $name;
}

sub unlink_dat_files {
  opendir (my $dh, ".");
  my @dat_files = grep { /\.dat$/i && -f } readdir $dh;
  unlink @dat_files;
}

sub clean_up_file_names {
  opendir (my $dh, ".");
  my @files = grep { !/^\./ && !/\.dat$/i } readdir $dh;
  for my $file (@files) {
    my $newfilename = regex_clean_basename($file);
    next if $file eq $newfilename;
    next if -s $newfilename;
    next if -d $newfilename;
    mv $file, $newfilename;
 }
  closedir $dh;
  return @files;
}


sub do_tv_directory {

  my $cwd = getcwd;
  my $showtitle = (File::Spec->splitdir($cwd))[-1];

  open my $fh, ">", 'tvshow.nfo';
  say_tvshow_nfo($fh,$showtitle,$showtitle);
  close $fh;

  my @files = get_video_files();
  for my $file (@files) {
    #my $year = 1971;
    $file =~ /(.*?) - S0([0-9]{1})E([0-9]+)\.[0-9a-z]{3}$/i;
    my ($title,$season,$episode) = ($1,$2,$3);
    my $year = 1984;

    my $nfofile = $file;
    $nfofile =~ s/[a-z0-9]{3}$/nfo/i;
    say "nfofile $nfofile";
    say "title $title";
    say "showtitle $showtitle";
    say "year $year";
    say "episode $episode";
    #  mv $file, $newfilename;
    open my $fh, ">", $nfofile;
    say_episode_nfo($fh,$title,$showtitle,$episode,$year,$season);
    close $fh;
  }
}


sub do_movie_based_on_filename {
  my $cwd = shift;
  say "doing $cwd...";
  open my $fh, ">$cwd.nfo";
  say_movie_nfo($fh,$cwd);
  close $fh;
  if (-e "$cwd.jpg") {
    cp "$cwd.jpg", "$cwd-fanart.jpg";
    cp "$cwd.jpg", "tmp.jpg";
    system "convert", "-crop", "52.75x100%", "tmp.jpg","$cwd-poster.jpg";
    mv "$cwd-poster-1.jpg", "$cwd-poster.jpg";
    unlink "$cwd-poster-0.jpg","tmp.jpg";
  }
}



unlink_dat_files();
clean_up_file_names();

opendir (my $topdh, ".");
my @dirs = grep { !/^\./ && -d } readdir $topdh;
closedir $topdh;

for my $dir (@dirs) {
  chdir $dir;
  unlink_dat_files();
  clean_up_file_names();
  chdir '..';
}


#  open my $fh, ">", 'tvshow.nfo';
#  say_tvshow_nfo($fh,$showtitle,$showtitle);
#  close $fh;


#rewinddir $dh;
#my $jpgfile = (grep { /\.jpg$/i &&  !/^\.\_/  } readdir $dh)[0];
#cp 'poster.jpg', 'banner.jpg';
#cp 'poster.jpg', 'fanart.jpg';
#mv $jpgfile , 'poster.jpg';
#say "jpg: $jpgfile";
#closedir $dh;

