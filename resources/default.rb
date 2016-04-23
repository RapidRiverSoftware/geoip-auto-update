actions :create
default_action :create

attribute :target_dir, kind_of: String, required: true, name_attribute: true

attribute :user, kind_of: String
attribute :group, kind_of: String

attribute :maxmind_user_id, kind_of: [Integer, String], required: true
attribute :maxmind_license_key, kind_of: String, required: true
attribute :maxmind_product_ids, kind_of: Array, required: true

attribute :install_utilities, kind_of: [TrueClass, FalseClass], default: false
attribute :install_dev_files, kind_of: [TrueClass, FalseClass], default: false

attribute :cron_mailto, kind_of: String

attribute :cron_day, kind_of: [Integer, String]
attribute :cron_hour, kind_of: [Integer, String]
attribute :cron_minute, kind_of: [Integer, String]
attribute :cron_month, kind_of: [Integer, String]
attribute :cron_weekday, kind_of: [Integer, String]
