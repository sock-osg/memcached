#!/usr/bin/perl -w
use Services::Meta_Cache;

use Data::Dumper;

my $cache = Services::Meta_Cache->instance();
my $base_key = "key_";
my $base_value = "value_hduisdcbdsunds_";
my $map = {
	'key' => undef,
	'value' => undef,
};
my $duration = "20 minute";

save_cache($cache);
read_cache($cache);

#print(Dumper($cache));

sub save_cache {
	my ($cache) = @_;
	my $tmp_key;

	for (my $var = 0; $var < 100; $var++) {
		$tmp_key = $base_key . $var;
		$map->{key} = $tmp_key;
		$map->{value} = $base_value . $var;

		if ($cache->set($tmp_key, $map, $duration)) {
			print("Saved key : $tmp_key\n");
		}
	}
}

sub read_cache {
	my ($cache) = @_;
	my $tmp_key;

	for (my $var = 0; $var < 100; $var++) {
		$tmp_key = $base_key . $var;

		my $value_map = $cache->get($tmp_key);

		if ($value_map) {
			print("Loaded key $tmp_key = " . Dumper($value_map) . "\n");
		} else {
			print("Value for key $tmp_key not found.....\n");
		}
	}
}

1;
