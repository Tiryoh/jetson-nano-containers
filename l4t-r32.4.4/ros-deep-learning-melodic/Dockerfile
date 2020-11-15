ARG BASE_IMAGE=ros:melodic-ros-base-l4t-r32.4.4

###############################################################################################################################################
#
# build
# $ docker build -t ros-deep-learning:melodic-l4t-r32.4.4
#
# run
# $ docker run --network host -v /tmp/argus_socket:/tmp/argus_socket --runtime nvidia --rm -it ros-deep-learning:melodic-l4t-r32.4.4
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

# build packages
WORKDIR /root/ros_workspace
RUN apt-get update -qq && \
    rosdep update -q && \
    rosdep install -r -y -i --from-paths src && \
    . /opt/ros/melodic/setup.sh && \
    catkin init && \
    catkin build && \
    rm -rf /var/lib/apt/lists/*

# install ROS env settings
RUN apt-get update -qq && \
    apt-get install -y -qq iproute2 && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e "s/^exec/#exec/g" /ros_entrypoint.sh && \
    echo "" >> /ros_entrypoint.sh && \
    echo "source /ros_env.sh" >> /ros_entrypoint.sh && \
    echo "exec \"\$@\"" >> /ros_entrypoint.sh && \
    echo "source /root/ros_workspace/devel/setup.bash" >> /ros_env.sh && \
    echo "export MYWLAN0IP=\$(ip a show \$(ip a | grep -o -e \"wl.*\:\" | sed -e \"s/://g\") | grep -o -E \"([0-9]+\.){3}[0-9]+\" | head -n1)" >> /ros_env.sh && \
    echo "export MYETH0IP=\$(ip a show \$(ip a | grep -o -e \"en.*\:\" -e \"eth[0-9]*\:\" | sed -e \"s/://g\") | grep -o -E \"([0-9]+\.){3}[0-9]+\" | head -n1)" >> /ros_env.sh && \
    echo "export ROS_IP=\$(echo \$MYETH0IP \$MYWLAN0IP \$(hostname -i) | cut -d' ' -f1)" >> /ros_env.sh && \
    echo "export ROS_MASTER_URI=http://\$ROS_IP:11311" >> /ros_env.sh && \
    echo "source \`catkin locate --shell-verbs\`" >> /root/.bashrc
