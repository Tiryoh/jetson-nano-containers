#!/bin/bash
set -e

source "/opt/ros/$ROS_DISTRO/install/setup.bash"
exec "$@"
