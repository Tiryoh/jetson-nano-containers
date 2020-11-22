ARG BASE_IMAGE=ros:eloquent-ros-base-l4t-r32.4.4

###############################################################################################################################################
#
# build
# $ docker build -t ros-deep-learning:eloquent-l4t-r32.4.4
#
# run
# $ docker run --network host -v /tmp/argus_socket:/tmp/argus_socket --runtime nvidia --rm -it ros-deep-learning:eloquent-l4t-r32.4.4
#
###############################################################################################################################################

FROM ${BASE_IMAGE}

# install dusty-nv/jetson-inference
WORKDIR /root/workspace
RUN git clone --recursive https://github.com/dusty-nv/jetson-inference && \
    cd jetson-inference && \
    sed -i 's/nvcaffe_parser/nvparsers/g' CMakeLists.txt && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    /bin/bash -O extglob -c "cd /jetson-inference/build; rm -rf -v !(aarch64|download-models.*)" && \
    ldconfig && \
    rm -rf /var/lib/apt/lists/*

# prepare dusty-nv/ros_deep_learning
WORKDIR /root/ros_workspace/src
RUN git clone https://github.com/dusty-nv/ros_deep_learning.git

# install ROS packages
# build twice to suppress cmake warning
WORKDIR /root/ros_workspace
RUN apt-get update -qq && \
    rosdep update -q && \
    rosdep install -r -y -i --from-paths src && \
    rm -rf /var/lib/apt/lists/* && \
    . /opt/ros/eloquent/setup.sh && \
    colcon build --symlink-install && \
    colcon build --symlink-install

# install ROS settings
RUN apt-get update -qq && \
    apt-get install -y -qq iproute2 && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e "s/^exec/#exec/g" /ros_entrypoint.sh && \
    echo "" >> /ros_entrypoint.sh && \
    echo "source /root/ros_workspace/install/local_setup.bash" >> /ros_entrypoint.sh && \
    echo "exec \"\$@\"" >> /ros_entrypoint.sh
