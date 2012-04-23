
unless new_resource[:path]
  new_resource[:path] = new_resource[:name]
end

action :create do

  bash 'create swapfile at #{new_resource[:path]}' do
    not_if { File.exists?('#{new_resource[:path]}') }
    code <<-EOH
    dd if=/dev/zero of=#{new_resource[:path]} bs=1M count=#{new_resource[:size]} &&
    chmod 0600 #{new_resource[:path]} &&
    mkswap #{new_resource[:path]}
    EOH
    action :run
    not_if { File.size(new_resource[:path])/1048577 == new_resource[:size] }
  end

  file new_resource[:path] do
    mode new_resource[:mode]
    owner new_resource[:owner]
    group new_resource[:group]
  end

  bash 'activate swap file ' + new_resource[:path] do
    code 'swapon -a'
    action :nothing
  end

  mount '/dev/null' do  # Can't say 'none' here like we normally would: http://tickets.opscode.com/browse/CHEF-1967
    action :enable  # swap partitions aren't mounted, so only add to fstab
    device new_resource[:path]
    fstype 'swap'
    notifies :run, 'bash[activate swap file #{new_resource[:path]}]', :immediately
  end

end

action :delete do

  file new_resource[:path] do
    action :nothing
  end

  bash "swapoff #{new_resource[:path]}" do
    code "swapoff #{new_resource[:path]}"
    notifies :delete, 'file[#{new_resource[:path]}]', :immediately
  end
    
end
