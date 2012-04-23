action :create do

  root_group = value_for_platform("default" => "root",
                                  ["openbsd", "freebsd", "gentoo"] => { "default" => "wheel" })

  bash 'create swapfile ' + new_resource.name do
    code <<-EOH
    dd if=/dev/zero of=#{new_resource.name} bs=1048576 count=#{new_resource.size}
    EOH
    action :run
    not_if { load_current_resource == new_resource.size }
  end

  file new_resource.name do
    mode 0600
    owner 'root'
    group root_group
    action :nothing
    subscribes :create, resources(:bash => "create swapfile #{new_resource.name}"), :immediately
  end

  bash 'swapon ' + new_resource.name do
    code 'swapon ' + new_resource.name
    action :nothing
  end

  bash 'mkswap ' + new_resource.name do
    code 'mkswap -f ' + new_resource.name
    action :nothing
    subscribes :run, resources(:bash => "create swapfile #{new_resource.name}"), :immediately
    notifies :run, resources(:bash => "swapon #{new_resource.name}"), :immediately
  end

  mount '/dev/null' do  # Can't say 'none' here like we normally would: http://tickets.opscode.com/browse/CHEF-1967
    action :enable # swap partitions aren't mounted, so only add to fstab
    device new_resource.name
    fstype 'swap'
  end

end

action :delete do
  
  file new_resource.name do
    action :nothing
  end

  bash 'swapoff '+ new_resource.name do
    code 'swapoff ' + new_resource.name
    notifies :delete, "file[#{new_resource.name}]", :immediately
  end
    
end

def load_current_resource
  current_resource = ::File.size?(new_resource.name).to_i/1048576
end
