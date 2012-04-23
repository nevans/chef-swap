def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :size, :kind_of => Fixnum, :required => true
attribute :mode, :kind_of => [Fixnum, String], :default => 0600
