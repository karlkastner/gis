# 2014-04-13 23:45:35.482670797 +0700
# Karl Kastner, Berlin

print '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>'."\n".'<gpx xmlns="http://www.topografix.com/GPX/1/1" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" xmlns:wptx1="http://www.garmin.com/xmlschemas/WaypointExtension/v1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" creator="eTrex 10" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www8.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www8.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd">'."\n".'<metadata>'."\n".'<link href="http://www.garmin.com">'."\n".'<text>Garmin International</text>'."\n".'</link>'."\n".'<time>0000-01-01T00:00:00Z</time>'."\n".'</metadata>'."\n";
#print '<?xml version="1.0" encoding="UTF-8" standalone="no" ?><gpx xmlns="http://www.topografix.com/GPX/1/1" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" xmlns:wptx1="http://www.garmin.com/xmlschemas/WaypointExtension/v1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" creator="eTrex 10" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www8.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www8.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd"><metadata><link href="http://www.garmin.com"><text>Garmin International</text></link><time>0000-01-01T00:00:00Z</time></metadata>'."\n";
#print '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\nl<gpx xmlns="http://www.topografix.com/GPX/1/1" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" xmlns:wptx1="http://www.garmin.com/xmlschemas/WaypointExtension/v1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" creator="eTrex 10" version="1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www8.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www8.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd">\nl<metadata>\nl<link href="http://www.garmin.com">\nl<text>Garmin International</text>\nl</link>\nl<time>0000-01-01T00:00:00Z</time>\nl</metadata>'."\n";

while (<STDIN>)
{
	my $line = $_;
	chomp $line;
	my @token = split(/\s\s*/,$_);
	my $lat = $token[0];
	my $lon = $token[1];
	my $ele = $token[2];
	my $name = $token[3];
	#printf("<wpt lat=\"%f\" lon=\"%f\"><ele>%f</ele><time>0000-01-01T00:00:00Z</time><name>%s</name><sym>Circle, Blue</sym></wpt>\n",
	#	$lat,$lon,$ele,$name);
	printf(  "<wpt lat=\"%f\" lon=\"%f\">\n"
	       . " <ele>%f</ele>\n"
               . " <time>0000-01-01T00:00:00Z</time>\n"
	       . " <name>%s</name>\n"
	       . " <sym>Circle, Blue</sym>\n"
	       . "</wpt>\n",
		$lat,$lon,$ele,$name);
}
print '</gpx>'."\n";

