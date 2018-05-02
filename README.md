# verify-pkg-hiera-eyaml

This repository allows packaging for Ubuntu of hiera-eyaml for Puppet versions
which include their own bundled Ruby in /opt/puppetlabs/puppet

Usage: `./build.sh <version suffix>`

Generated Debian packages will be placed in output/trusty/

## How this works

See `build.sh` for the details, but in summary:

`Gemfile.hiera-eyaml` specifies the gems we want to package into .deb packages

`Gemfile.buildtools` specifies gems we need in order to do that (at the time of
writing, this is just `fpm`)

`hiera-eyaml` and its dependencies are bundled into `hiera-eyaml` and the build
tools are bundled into `buildtools`. We then use fpm to package all the
`hiera-eyaml` gems into Debian packages with a custom gempath that matches the
one for Puppetlabs' `puppet-agent` package and its bundled ruby.

We also prefix the names of the generated .deb packages with `puppet5-rubygem-`
so that they do not conflict with system packages (since they're installed into
a different gempath, they cannot conflict or be used by the system ruby). This
prefix applies to packages pulled in as dependencies as well.
