# Copyright 2017 Schuberg Philis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
