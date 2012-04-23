def initialize(*args)
  super
  @action = :create
end

root_group = value_for_platform( ["openbsd", "freebsd", "gentoo"] => { "default" => "wheel" }, "default" => "root" )

actions :create, :delete

attribute :size, :kind_of => FixNum, :required => true
attribute :path, :kind_of => String
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => root_group
attribute :mode, :kind_of => [FixNum, String], :default => 0600
