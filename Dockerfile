FROM debian:buster-slim

LABEL maintainer = "izotecarlitos"

# Build arguments
ARG PYCHARM_BUILD=2020.3.3
ARG PYCHARM_SOURCE=https://download.jetbrains.com/python/pycharm-professional-${PYCHARM_BUILD}.tar.gz
ARG DEVELOPER_HOME=/home/developer
ARG PYCHARM_PROJECTS=$DEVELOPER_HOME/PycharmProjects
ARG PYCHARM_SETTINGS=$DEVELOPER_HOME/PycharmSettings
ARG PYCHARM_CONFIG=$PYCHARM_SETTINGS/config
ARG PYCHARM_SYSTEM=$PYCHARM_SETTINGS/system
ARG PYCHARM_PLUGINS=$PYCHARM_SETTINGS/plugins
ARG PYCHARM_LOG=$PYCHARM_SETTINGS/log
ARG PYCHARM_DEBUGEGGS=$PYCHARM_SETTINGS/debugeggs

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8
# Set Environment Variables
ENV PYCHARM_HOME=/opt/pycharm
ENV PYCHARM_PROPERTIES=$PYCHARM_HOME/bin/idea.properties

# Install libraries and tools
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        curl \
        dirmngr \
        fakeroot \
        fonts-noto-cjk \
        git \
        gnupg \
        less \
        libcanberra-gtk3-module \
        libffi-dev \
        libgtk-3-0 \
        libgtk-3-bin \
        libssl-dev \
        libxtst6 \
        libxxf86vm1 \
        nano \
        net-tools \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-venv \
        python3-wheel \
        openssh-client \
        tree \
        unzip \
        xz-utils \
        wget \
        x11-xserver-utils \
        zip \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install latest postgresql-client
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
    && gpg --batch --armor --export "${repokey}" > /etc/apt/trusted.gpg.d/pgdg.gpg.asc \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && apt-get update  \
    && apt-get install --no-install-recommends -y postgresql-client \
    && rm -f /etc/apt/sources.list.d/pgdg.list \
    && rm -rf /var/lib/apt/lists/*

# Create developer user
RUN useradd --create-home --shell /bin/bash --uid 1000 --user-group developer
WORKDIR $DEVELOPER_HOME

# Download pycharm, create folders, unpackage and remove the installer and expose volumes
RUN wget -cq $PYCHARM_SOURCE -O installer.tgz \
    && mkdir -p \
        $PYCHARM_HOME \
        $PYCHARM_PROJECTS \
        $PYCHARM_CONFIG \
        $PYCHARM_SYSTEM  \
        $PYCHARM_PLUGINS \
        $PYCHARM_LOG \
        $PYCHARM_DEBUGEGGS \
    && tar --strip-components=1 -xzf installer.tgz -C $PYCHARM_HOME \
    && rm installer.tgz

VOLUME [ \
    "/home/developer/PycharmProjects", \
    "/home/developer/PycharmSettings/config", \
    "/home/developer/PycharmSettings/system", \
    "/home/developer/PycharmSettings/plugins", \
    "/home/developer/PycharmSettings/log", \
    "/home/developer/PycharmSettings/debugeggs"]

# Copy and expose default idea.properties
COPY idea.properties $PYCHARM_HOME/bin/idea.properties

# Setup startup scripts
COPY startup.sh $DEVELOPER_HOME/startup.sh

# Set ownership and execution permission to startup script
RUN chmod a+x $DEVELOPER_HOME/startup.sh \
    && chown developer $DEVELOPER_HOME/startup.sh

# Set the default user and home
USER developer

CMD [ "/home/developer/startup.sh" ]
