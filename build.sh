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

for GEM in ../hiera-eyaml/vendor/cache/*.gem; do
  BUNDLE_GEMFILE=../Gemfile.buildtools bundle exec fpm -s gem -t deb \
    --prefix /opt/puppetlabs/puppet/lib/ruby/gems/2.4.0 \
    --gem-package-name-prefix puppet5-rubygem \
    --iteration "${REVISION}~trusty1" \
    --architecture all \
    --maintainer "ida-operations@digital.cabinet-office.gov.uk" \
    "$GEM"
done

mkdir -p trusty
mv ./*trusty*.deb trusty/
popd
