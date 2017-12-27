# Latest version of ubuntu
FROM ubuntu:16.04

# Default git repository
ENV GIT_REPOSITORY https://github.com/tvdias/xmr-stak.git
ENV GIT_BRANCH master
ENV XMRSTAK_CMAKE_FLAGS -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF
	
# Innstall packages
RUN apt-get update \
    && set -x \
    && apt-get install -qq --no-install-recommends -y build-essential ca-certificates cmake git libhwloc-dev libmicrohttpd-dev libssl-dev \
    && git clone -b ${GIT_BRANCH} --single-branch $GIT_REPOSITORY \
    && cd /xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd - \
    && mv /xmr-stak/bin/* /usr/local/bin/ \
    && rm -rf /xmr-stak \
    && apt-get purge -y -qq build-essential cmake git libhwloc-dev libmicrohttpd-dev libssl-dev \
    && apt-get clean -qq

VOLUME /mnt

WORKDIR /mnt

COPY config.txt /mnt

ENTRYPOINT ["/usr/local/bin/xmr-stak"]
