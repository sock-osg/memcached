#!/usr/bin/perl
package Cache::Handler;

use Moose;

use CHI;
use Data::Dumper;
use Config::Any;
use List::MoreUtils qw(any);

has 'namespace' => (is       => 'rw',
					isa      => 'Maybe[Str]',
					lazy     => 1,
					required => 0,
					default  => 'Default',);

has CHI => (is      => 'rw',
			handles => [qw/get set remove expire/],);

has driver => (is      => 'rw',
			   isa     => 'Str',
			   builder => '_build_driver',);

has drivers => (is      => 'ro',
				isa     => 'ArrayRef',
				lazy    => 1,
				default => sub {[qw/Memcached/]},);

sub BUILD {
	my ($self, $params) = @_;

	my $previous_umask = umask();
	umask(0);

	my $config = $self->get_config($self->driver);

	$self->CHI(CHI->new(%$config));

	umask($previous_umask);
	return $self;
}

sub get_config {
	my ($self, $driver) = @_;

	my %config;
	my $file_path = $ENV{"HOME"} . '/workspace-perl/test-memcached/config/' . lc($self->namespace) . '.pl';
	print("Cache config path : " . $file_path . " with driver " . $driver . "\n");

	if (-e $file_path) {
		#print("File exist\n");
		my $config_ar = Config::Any->load_files({files => [$file_path], use_ext => 1});
		#print("Config ar : " . Dumper($config_ar) . "\n");
		if (ref $config_ar eq 'ARRAY' and scalar(@$config_ar)) {
			my ($filename, $config_file_hr) = %{$config_ar->[0]};

			#print(Dumper($filename));
			#print(Dumper($config_file_hr));

			my $defaults = defined($config_file_hr->{defaults}) ? $config_file_hr->{defaults} : {};
			#print(Dumper($defaults));

			$self->$driver($config_file_hr) if ($self->can($driver));
			my $driver_config = defined $config_file_hr->{$driver} ? $config_file_hr->{$driver} : {};

			#print(Dumper($driver_config));

			%config = (%$defaults, %$driver_config);
		}
	}

	$config{driver}    = $driver          unless $config{driver};
	$config{namespace} = $self->namespace unless defined $config{namespace};

	#print("Cache [$driver + defaults] Configuration: " . Dumper(\%config));

	return \%config;
}

sub Memcached {
	my ($self, $config) = @_;

	if ($config->{Memcached}) {
		my $servers_config = $config->{Memcached}{servers}{test};
		my @servers        = map {{address => $_}} @$servers_config;
		$config->{Memcached}{servers} = \@servers;
	}
	else {
		$config->{Memcached}{servers} = [{address => 'localhost:11211'}];
	}
	$config->{Memcached}{driver} = 'Memcached::Fast';
}

sub _build_driver {
	my ($self) = @_;

	return "Memcached";
}

1;
