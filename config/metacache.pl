{
	defaults => {
		expires_in => '300',
		expires_variance => 0.20,
	},

	Memcached => {
		servers => {
			test => ['10.0.0.100:11211'],
		},
		nowait => 1,
		connect_timeout => 0.2,
		io_timeout => 0.5,
		l1_cache => {
			driver => 'Memory',
			max_size => 30000,
			global => 1,
		},
	},
}
