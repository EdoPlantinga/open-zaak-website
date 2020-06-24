#!/usr/bin/env bash
set -e # halt script on error

# Lint markdown using the Markdownlint gem with the default ruleset except for:
# MD013 Line length: we allow long lines
# MD029 Ordered list item prefix: we allow lists to be sequentially numbered
bundle exec mdl -r ~MD013,~MD029 -i -g '.'

# Build the site
bundle exec jekyll build

# Check for broken links and missing alt tags, ignore edit links to GitHub as they might not exist yet,
# SSL connections or host certificates are not verified in order not to break a build when sites use outdated certs or the Travis build server does not contain the correct CA certificates.
# Use this line in to enable default SSL connections and certificate verification: bundle exec htmlproofer --url-ignore "/github.com/(.*)/edit/" ./_site
bundle exec htmlproofer --url-ignore "/github.com/(.*)/edit/" ./_site --typhoeus-config '{"followlocation": false, "ssl_verifypeer": false, "ssl_verifyhost":0}'
