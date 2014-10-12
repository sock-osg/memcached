{
	defaults => {
		expires_in => '300',
		expires_variance => 0.20,
	},

	Memory => {
		global => 1,
	},

	RawMemory => {
		global => 1,
	},

	FastMmap => {
		root_dir => '/cache/metaCache',
		dir_create_mode => 0777,
		cache_size => '10m',
	},

	DBI => { 
		database => 'lan',
		table_prefix => '',

		# We must use the cache namespace and it cannot be changed
		# unless we first create the table in the lan database
		namespace => 'cache',
	},

	Memory => {
		global => 1,
	},

	Memcached => {
		servers => {
			test => ['10.0.0.100:11211'],
		},
		nowait => 1, # defaults disabled
		connect_timeout => 0.2, # defaults 0.25
		io_timeout => 0.5, # defaults 1.0
		l1_cache => {
			driver => 'Memory',
			max_size => 30000, # items max in cache
			global => 1,
		},
	},
}
