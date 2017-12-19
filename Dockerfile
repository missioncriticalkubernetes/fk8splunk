FROM ruby:2.2

RUN apt-get update \
 && apt-get install gettext-base --yes \
 && apt-get clean all \
 && rm -rf /var/lib/apt/lists/* \
 && gem install fluentd \
 && fluent-gem install  \
  fluent-mixin-config-placeholders \
  fluent-mixin-plaintextformatter \
  fluent-plugin-splunkhec \
  fluent-plugin-kubernetes_metadata_filter \
  fluent-plugin-rewrite-tag-filter

COPY docker-entrypoint /docker-entrypoint
COPY td-agent.conf.template /etc/td-agent/

# Run the Fluentd service.
ENTRYPOINT ["/docker-entrypoint"]
