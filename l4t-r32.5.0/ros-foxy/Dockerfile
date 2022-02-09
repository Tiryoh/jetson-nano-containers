ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r32.5.0

###############################################################################################################################################
# ros foxy ros-base 
#
# build
# $ docker build -t ros:foxy-ros-base-l4t-r32.5.0 .
#
# run
# $ docker run --network host -v /tmp/argus_socket:/tmp/argus_socket --runtime nvidia --rm -it ros:foxy-ros-base-l4t-r32.5.0
#
# This Dockerfile is released under the MIT license
# Copyright (c) 2020-2022 Daisuke Sato
# https://github.com/Tiryoh/jetson-nano-containers/blob/main/LICENSE
# This Dockerfile is adapted from 
# https://github.com/dusty-nv/jetson-containers/blob/L4T-R32.6.1/Dockerfile.ros.foxy
# which is released under the MIT License
# Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
# https://github.com/dusty-nv/jetson-containers/blob/L4T-R32.6.1/LICENSE.md
###############################################################################################################################################

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace

# change the locale from POSIX to UTF-8
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# install the essential packages
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

# add the ROS deb repo to the apt sources list
ARG ROS_PKG=ros_base
ENV ROS_DISTRO=foxy

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# install development packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libbullet-dev \
    libpython3-dev \
    python3-colcon-common-extensions \
    python3-flake8 \
    python3-pip \
    python3-pytest-cov \
    python3-rosdep \
    python3-setuptools \
    python3-vcstool \
    python3-rosinstall-generator \
    libasio-dev \
    libtinyxml2-dev \
    libcunit1-dev \
    && rm -rf /var/lib/apt/lists/*

# install some pip packages needed for testing
RUN python3 -m pip install -U \
    argcomplete \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures \
    pytest

# install OpenCV (with CUDA)
ARG OPENCV_URL=https://nvidia.box.com/shared/static/5v89u6g5rb62fpz4lh0rz531ajo2t5ef.gz
ARG OPENCV_DEB=OpenCV-4.5.0-aarch64.tar.gz

RUN apt-get purge -y '*opencv*' || echo "previous OpenCV installation not found" && \
    mkdir opencv && \
    cd opencv && \
    wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${OPENCV_URL} -O ${OPENCV_DEB} && \
    tar -xzvf ${OPENCV_DEB} && \
    dpkg -i --force-depends *.deb && \
    apt-get update && \
    apt-get install -y -f --no-install-recommends && \
    dpkg -i *.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    cd ../ && \
    rm -rf opencv && \
    cp -r /usr/include/opencv4 /usr/local/include/opencv4 && \
    cp -r /usr/lib/python3.6/dist-packages/cv2 /usr/local/lib/python3.6/dist-packages/cv2

# download/build ROS from source
# https://answers.ros.org/question/325245/minimal-ros2-installation/?answer=325249#post-id-325249
RUN mkdir -p /opt/ros/${ROS_DISTRO}/src && \
    cd /opt/ros/${ROS_DISTRO} && \
    rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ${ROS_PKG} \
		launch_xml \
		launch_yaml \
		launch_testing \
		launch_testing_ament_cmake \
		demo_nodes_cpp \
		demo_nodes_py \
		example_interfaces \
		camera_calibration_parsers \
		camera_info_manager \
		cv_bridge \
		v4l2_camera \
		vision_opencv \
		vision_msgs \
		image_geometry \
		image_pipeline \
		image_transport \
		compressed_image_transport \
		compressed_depth_image_transport \
		> ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
    cat ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
    vcs import src < ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
    # patch libyaml - https://github.com/dusty-nv/jetson-containers/issues/41#issuecomment-774767272
    rm /opt/ros/${ROS_DISTRO}/src/libyaml_vendor/CMakeLists.txt && \
    wget --no-check-certificate https://raw.githubusercontent.com/ros2/libyaml_vendor/master/CMakeLists.txt -P /opt/ros/${ROS_DISTRO}/src/libyaml_vendor/ && \
    # install dependencies using rosdep
    apt-get update && \
    cd /opt/ros/${ROS_DISTRO} && \
    rosdep init && \
    rosdep update && \
    rosdep install -y \
    	  --ignore-src \
       --from-paths src \
	  --rosdistro ${ROS_DISTRO} \
	  --skip-keys "libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
    rm -rf /var/lib/apt/lists/* && \
    # build it!
    cd /opt/ros/${ROS_DISTRO} && \
    colcon build --merge-install && \
    # remove build files
    rm -rf /opt/ros/${ROS_DISTRO}/src && \
    rm -rf /opt/ros/${ROS_DISTRO}/logs && \
    rm -rf /opt/ros/${ROS_DISTRO}/build && \
    rm /opt/ros/${ROS_DISTRO}/*.rosinstall

# Set the default DDS middleware to cyclonedds
# https://github.com/ros2/rclcpp/issues/1335
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# setup entrypoint
WORKDIR /root/ros_workspace
COPY ./ros_entrypoint.sh /ros_entrypoint.sh
RUN echo 'source /opt/ros/'${ROS_DISTRO}'/install/setup.bash' >> /root/.bashrc 
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
