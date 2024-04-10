use LWP::Simple;
use HTML::TreeBuilder;
use Database::DumpTruck;

use strict;
use warnings;

# Turn off output buffering
$| = 1;

my $stringToFind = "XXXXXXXX";

# Read out and parse a web page
my $tb = HTML::TreeBuilder->new_from_content(get('https://www.win2day.at/gewinner-des-tages/'));

# Look for <tr>s of <table id="hello">
my @rows = $tb->look_down(
    _tag => 'tr',
    sub { shift->parent->attr('id') eq 'hello' }
); 

# Check if our string was found
foreach my $row (@rows) {
    if($row->as_text =~ m/\Q$stringToFind\E/) {
        # print "String gefunden: $stringToFind\n";
        last;
    }
}

# Open a database handle
my $dt = Database::DumpTruck->new({dbname => 'data.sqlite', table => 'data'});

# Insert some records into the database
$dt->insert([{
    Name => 'Susan',
    Occupation => 'Software Developer'
}]);
