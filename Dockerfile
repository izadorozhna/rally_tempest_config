FROM rallyforge/rally:0.9.1
MAINTAINER Ievgeniia Zadorozhna <izadorozhna@mirantis.com>

WORKDIR /var/lib
USER root
RUN git clone https://github.com/openstack/tempest.git -b 15.0.0 && \
    pip install tempest==15.0.0

WORKDIR /home/rally

COPY keystonercv3 /var/lib/keystonercv3
COPY cleanup.sh /var/lib/cleanup.sh
COPY tempest/skip.list.yaml /var/lib/skip_lists/mcp_skip.list
COPY tempest/tempest.conf /var/lib/tempest_conf/mcp.conf
COPY tempest/run_tempest.sh /usr/bin/run-tempest

COPY rally/run_rally.sh /usr/bin/run-rally
COPY rally/*.json /var/lib/rally_scenarios/

RUN ["chmod", "+x", "/usr/bin/run-rally"]
RUN ["chmod", "+x", "/usr/bin/run-tempest"]

ENTRYPOINT ["run-tempest"]