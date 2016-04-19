def whyrun_supported?
  true
end

use_inline_resources

action :create do
  create_geoip_auto_update
end

def create_geoip_auto_update
  directory new_resource.name do
    owner new_resource.owner
    group new_resource.group
    recursive true
    notifies :run, 'execute[geoipupdate]', :delayed
  end

  directory "#{new_resource.name}/callback.d" do
    owner new_resource.owner
    group new_resource.group
    recursive true
  end

  file "#{new_resource.name}/callback.d/example.sh" do
    content '# add callback scripts to this directory to be run when GeoIP database products are updated'
    owner new_resource.owner
    group new_resource.group
  end

  current_distribution = `lsb_release -a 2> /dev/null | grep 'Codename' | awk '{print $2}'`.chomp
  apt_repository 'maxmind' do
    uri 'ppa:maxmind'
    distribution current_distribution
  end

  package 'geoipupdate'
  package 'geoip-bin' if new_resource.install_utilities
  package 'libgeoip-dev' if new_resource.install_dev_files

  template "#{new_resource.name}/geoipupdate.conf" do
    cookbook 'geoip_auto_update'
    owner new_resource.owner
    group new_resource.group
    mode 0660
    variables({
      user_id: new_resource.maxmind_user_id,
      license_key: new_resource.maxmind_license_key,
      product_ids: new_resource.maxmind_product_ids.map(&:to_s).sort.join(' ')
    })
    notifies :run, 'execute[geoipupdate]', :delayed
  end

  cookbook_file "#{new_resource.name}/check_geoip_updates.sh" do
    cookbook 'geoip_auto_update'
    owner new_resource.owner
    group new_resource.group
    mode 0755
    notifies :run, 'execute[geoipupdate]', :delayed
  end

  cron 'geoipupdate' do
    user new_resource.cron_user
    mailto new_resource.cron_mailto
    day new_resource.cron_day
    hour new_resource.cron_hour
    minute new_resource.cron_minute
    month new_resource.cron_month
    weekday new_resource.cron_weekday
    command "#{new_resource.name}/check_geoip_updates.sh"
    environment({
      'WORKING_DIR' => new_resource.name,
    })
  end

  execute 'geoipupdate' do
    command "#{new_resource.name}/check_geoip_updates.sh"
    user new_resource.owner
    group new_resource.group
    environment({
      'WORKING_DIR' => new_resource.name,
    })
    action :nothing
  end
end
