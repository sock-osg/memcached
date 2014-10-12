#!/usr/bin/perl
package Services::Meta_Cache;

use MooseX::Singleton;

use Data::Dumper;
use Cache::Handler;

has Handler => (
	is => 'rw',
	handles => [qw/get set remove expire/],
);

sub BUILD {
	my ($self) = @_;
	return $self->Handler(Cache::Handler->new(
		namespace => 'MetaCache',
	));
}

1;
