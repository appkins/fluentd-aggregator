FROM fluent/fluentd:v1.11

# Use root account to use apk
USER root

# Add custom plugins
RUN set -eu; \
  apk add --no-cache --update --virtual .build-deps sudo build-base ruby-dev; \
  sudo gem install \
  fluent-plugin-concat \
  fluent-plugin-elasticsearch \
  fluent-plugin-grafana-loki \
  fluent-plugin-prometheus \
  fluent-plugin-s3 \
  fluent-plugin-sqs; \
  sudo gem sources --clear-all; \
  apk del .build-deps; \
  rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem;

# Overwrite conf
COPY fluent.conf /fluentd/etc/

# Set back to non-root user
USER fluent
