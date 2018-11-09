# verify-pkg-hiera-eyaml-gpg

This repository allows packaging for Ubuntu of hiera-eyaml-gpg for Puppet
versions which include their own bundled Ruby in `/opt/puppetlabs/puppet`

Usage: `./build.sh <version suffix>`

Generated Debian packages will be placed in `output/trusty/`

## How this works

See `build.sh` for the details, but in summary:

`Gemfile.hiera-eyaml-gpg` specifies the gems we want to package into .deb
packages

`Gemfile.buildtools` specifies gems we need in order to do that (at the time of
writing, this is just `fpm`)

`hiera-eyaml-gpg` and `ruby-gpg` are bundled into `hiera-eyaml-gpg` and the
build tools are bundled into `buildtools`. We then use fpm to package the
`hiera-eyaml-gpg` and `ruby-gpg` gems into Debian packages with a custom
gempath that matches the one for Puppetlabs' `puppet-agent` package and its
bundled ruby.

We exclude dependencies such as `hiera-eyaml` which are already bundled as part
of `puppet-agent`

We also prefix the names of the generated .deb packages with `puppet6-rubygem-`
so that they do not conflict with system packages (since they're installed into
a different gempath, they cannot conflict or be used by the system ruby).
