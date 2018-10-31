#!/bin/bash

set -eux

cd "$(dirname "$0")"

REVISION=${1:-1}

rm -rf output
mkdir -p output

command -v bundle > /dev/null || gem install bundler

# Download & build hiera-eyaml gems
bundle package --gemfile Gemfile.hiera-eyaml --path hiera-eyaml

# Install tools needed to perform the packaging
bundle install --gemfile Gemfile.buildtools --path buildtools

pushd output

# We only actually want to package hiera-eyaml-gpg and ruby_gpg - everything
# else is bundled with puppet-agent as of v6.0.3
for GEM in ../hiera-eyaml/vendor/cache/hiera-eyaml-gpg-*.gem ../hiera-eyaml/vendor/cache/ruby_gpg-*.gem; do
  BUNDLE_GEMFILE=../Gemfile.buildtools bundle exec fpm -s gem -t deb \
    --prefix /opt/puppetlabs/puppet/lib/ruby/gems/2.5.0 \
    --gem-bin-path /opt/puppetlabs/puppet/bin \
    --gem-package-name-prefix puppet6-rubygem \
    --gem-disable-dependency hiera-eyaml \
    --gem-disable-dependency highline \
    --gem-disable-dependency trollop \
    --iteration "${REVISION}~trusty1" \
    --architecture all \
    --maintainer "ida-operations@digital.cabinet-office.gov.uk" \
    "$GEM"
done

mkdir -p trusty
mv ./*trusty*.deb trusty/
popd
