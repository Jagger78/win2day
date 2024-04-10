use strict;
use warnings;
use LWP::UserAgent;
use Database::DumpTruck;

# URL der Webseite und Suchbegriff
my $url = 'https://www.win2day.at/gewinner-des-tages';
# Use my secret value
my $search_term = $ENV{'MORPH_STRING'};

# HTTP-Anfrage an die Webseite senden
my $ua = LWP::UserAgent->new;
my $response = $ua->get($url);

if ($response->is_success) {
	my $content = $response->decoded_content;

	# Suchbegriff in der Webseite finden
	if ($content =~ /$search_term/) {
		 #print "String gefunden: $search_term\n";
	} 
	else {
		die "Fehler beim Abrufen der Webseite: " . $response->status_line;
	}
}

# Open a database handle
my $dt = Database::DumpTruck->new({dbname => 'data.sqlite', table => 'data'});

# Insert some records into the database
$dt->insert([{
    Name => $search_term,
}]);
