`swap`
==========

Let's automatically create and manage the size of swap files with Chef!

Platform
========

Won't work on Mac OS X nor Windows. Should work everywhere else, tested on Ubuntu.

Requirements
============

Can't think of any.

Attributes
==========

* `path` - the resource name will be used if no path is specified
* `size` - in megabytes, integer required
* `delete` - defaults to false 

Usage examples
==============
```ruby
# I am a mad man who wants nine swap files!
include_recipe 'swap'

9.times do |n|
  swap_file '/mnt/swapfile' + n do
    size 2048
  end
end
```

License and Author
==================

Author:: Cameron Johnston <cameron@rootdown.net>

Copyright:: 2012, Cameron Johnston

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
