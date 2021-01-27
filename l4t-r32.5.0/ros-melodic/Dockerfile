ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r32.5.0

###############################################################################################################################################
# ros melodic ros-base 
#
# build
# $ docker build -t ros:melodic-ros-base-l4t-r32.4.4 .
#
# run
# $ docker run --network host -v /tmp/argus_socket:/tmp/argus_socket --runtime nvidia --rm -it ros:melodic-ros-base-l4t-r32.4.4
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

ARG ROS_PKG=ros-base
ENV ROS_DISTRO=melodic

RUN curl -Ls https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# install ROS packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-melodic-${ROS_PKG} \
    ros-melodic-image-transport \
    ros-melodic-vision-msgs \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    python-catkin-tools \
    python-vcstool \
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