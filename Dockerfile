FROM ubuntu:18.04

LABEL maintainer="Nishanth Menon <nm@ti.com>"

#Install all packages needed
# https://software-dl.ti.com/ccs/esd/documents/ccsv10_linux_host_support.html
RUN export DEBIAN_FRONTEND=noninteractive; dpkg --add-architecture i386 \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
  libc6:i386                    \
  libasound2                    \
  libusb-0.1-4                  \
  libstdc++6			\
  libxt6			\
  libcanberra-gtk-module        \
  unzip         		\
  wget                          \
  software-properties-common    \
  build-essential               \
  ca-certificates               \
  curl                          \
  libgconf-2-4                  \
  libdbus-glib-1-2              \
  libpython2.7                  \
  python2.7                     \
  libxtst6                      \
  at-spi2-core                  \
  binutils                      \
  python3-pip			\
  libc6:i386			\
  libusb-0.1-4			\
  libgconf-2-4			\
  libncurses5			\
  libpython2.7			\
  build-essential		\
  libgtk-3-dev			\
  libnss3			\
  libxss1			\
  libnspr4			\
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install missing library
WORKDIR /ccs_install

RUN export JAVA_TOOL_OPTIONS=-Xss1280k

# Install ccs in unattended mode
# https://e2e.ti.com/support/development_tools/code_composer_studio/f/81/t/374161
# Install SDK
RUN wget -q -O /ccs_install/simplelink.run http://software-dl.ti.com/simplelink/esd/simplelink_msp432_sdk/1.40.01.00/simplelink_msp432_sdk_1_40_01_00.run \
    && chmod 777 /ccs_install/simplelink.run \
    && /ccs_install/simplelink.run --mode unattended \
    && rm -rf /ccs_install/

# Install CCS
RUN curl -L https://software-dl.ti.com/ccs/esd/CCSv10/CCS_10_1_1/exports/CCS10.1.1.00004_linux-x64.tar.gz | tar xvz --strip-components=1 -C /ccs_install \
    && /ccs_install/ccs_setup_10.1.1.00004.run --mode unattended --prefix /opt/ti --enable-components PF_MSP432,PF_MSP430 \
    && rm -rf /ccs_install/

# workspace folder for CCS
RUN mkdir -p /workspace /workdir /automation_iface && groupadd -r user -g 1000 && \
useradd -u 1000 -r -g user -d /workdir -s /bin/bash -c "Docker user" user && \
chown -R user:user /workspace /workdir /automation_iface

USER user

ENV PATH="/opt/ti/ccs/eclipse:${PATH}"
# Pre compile libraries needed for the msp to avoid 6min compile during each build
ENV PATH="${PATH}:/opt/ti/ccs/tools/compiler/ti-cgt-arm_20.2.1.LTS/bin:/opt/ti/ccs/tools/compiler/ti-cgt-msp430_20.2.1.LTS/bin"
#RUN /opt/ti/ccs/tools/compiler/ti-cgt-arm_20.2.0.LTS/lib/mklib --pattern=rts430x_sc_sd_eabi.lib
# directory for the ccs workspace
VOLUME /workspace

# directory for the automation interface source.
VOLUME /workspace

# directory for the ccs project
VOLUME /workdir
WORKDIR /workdir

# if needed
#ENTRYPOINT []
