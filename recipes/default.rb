if node[:swap_file] && node[:swap_size]
  swap_file node[:swap_file] do
    size node[:swap_size]
  end
end
