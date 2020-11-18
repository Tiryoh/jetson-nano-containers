ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r32.4.3

###############################################################################################################################################
# ros eloquent ros-base 
#
# build
# $ docker build -t ros:eloquent-ros-base-l4t-r32.4.3 .
#
# run
# $ docker run --network host -v /tmp/argus_socket:/tmp/argus_socket --runtime nvidia --rm -it ros:eloquent-ros-base-l4t-r32.4.3
#
###############################################################################################################################################

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

# change the locale from POSIX to UTF-8
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# add the ROS deb repo to the apt sources list
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    cmake \
    build-essential \
    curl \
    wget \ 
    ca-certificates \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# compile and install yaml-cpp-0.6, which some ROS packages may use (but is not in the 18.04 apt repo)
RUN git clone --branch yaml-cpp-0.6.0 https://github.com/jbeder/yaml-cpp yaml-cpp-0.6 && \
    cd yaml-cpp-0.6 && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_SHARED_LIBS=ON .. && \
    make -j$(nproc) && \
    make install && \
    cd /workspace && \
    rm -rf yaml-cpp-0.6

ARG ROS_PKG=ros-base
ENV ROS_DISTRO=eloquent

RUN curl -Ls https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# install ROS packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-eloquent-${ROS_PKG} \
    ros-eloquent-launch-xml \
    ros-eloquent-launch-yaml \
    ros-eloquent-vision-msgs \
    libpython3-dev \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# init/update rosdep
RUN rosdep init && \
    rosdep update

# setup entrypoint
WORKDIR /root/ros_workspace
COPY ./ros_entrypoint.sh /ros_entrypoint.sh
RUN echo 'source /opt/ros/'${ROS_DISTRO}'/setup.bash' >> /root/.bashrc 
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]