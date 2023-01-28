FROM alpine:3.5

COPY files/tmp/* /tmp/
COPY files/opt/* /opt/

RUN apk add --no-cache bash ca-certificates file iptables libc6-compat libgcc libstdc++ && \
    mkdir /lib64 /tmp/f5fpc && \
    ln -s /lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 && \
    tar xfz /tmp/linux_sslvpn.tgz -C /tmp/f5fpc/ && \
    yes "yes" | /tmp/f5fpc/Install.sh && \
    rm -rf /tmp/f5fpc

CMD /opt/run.sh
