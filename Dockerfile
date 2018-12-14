# Use an official Python runtime as a parent image
FROM ubuntu:16.04

# Set the working directory to /app
WORKDIR /source

# install dependencies
RUN apt-get update && apt-get install -y \
software-properties-common \
python-software-properties \
apt-utils \
git \
libpng-dev \
libjpeg-dev \
libtiff-dev \
libxxf86vm1 \
libxxf86vm-dev \
libxi-dev \
libxrandr-dev \
cmake \
build-essential \
wget \
tmux \
python-pip \
nano \
libpng-dev

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y \
python3.6 \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install plyfile

ADD ./scripts /scripts

# Clone the repos
RUN git clone --recursive https://github.com/openMVG/openMVG.git
RUN git clone https://github.com/pmoulon/CMVS-PMVS
RUN git clone https://github.com/mkazhdan/PoissonRecon.git

# Build openMVG
WORKDIR /source/openMVG/openMVG_Build
RUN cmake -DCMAKE_BUILD_TYPE=RELEASE . ../src/
RUN make -j$(cat /proc/cpuinfo | grep processor | wc -l)
RUN make install

# Build CMVS-PMVS
WORKDIR /source/CMVS-PMVS/OutputLinux
RUN cmake . ../program
RUN make -j$(cat /proc/cpuinfo | grep processor | wc -l)
RUN make install

# Build PoissonRecon
WORKDIR /source/PoissonRecon
RUN make -j$(cat /proc/cpuinfo | grep processor | wc -l)

WORKDIR /scripts
