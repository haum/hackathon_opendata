#! /usr/bin/env perl -w
#
# moulinette2.pl
#
# Copyright © 2014 Mathieu Gaborit (matael) <mathieu@matael.org>
#
#
# Distributed under WTFPL terms
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#


use Geo::Proj4;
use IO::File;
use File::Slurp;
use JSON;

my $osm = Geo::Proj4->new('+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs');
my $pegase = Geo::Proj4->new('+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs');


$fh_out = IO::File->new('tis2014_mercator.json', '>');

undef $\;
my $json_data = from_json(read_file('tis2014.json'));

my $out_dict = {features => []};

foreach my $feature (@{$json_data->{features}}){

	my $point = $feature->{geometry}->{coordinates};

	my $proj = $pegase->transform($osm, $point);
	my ($lon2, $lat2) = $osm->inverse(@{$proj}[0], @{$proj}[1]);
	$feature->{geometry}->{coordinates} = [$lat2, $lon2];
	$out_dict->{features}[scalar(@{$out_dict->{features}})] = $feature;
}

$fh_out->print(to_json($out_dict));
$fh_out->close();

