FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

# Tools
RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# Binary package dependencies

RUN apt-get update \
 && apt-get install -y libceres-dev \
 && rm -rf /var/lib/apt/lists/*

# Software package dependencies
 
RUN  mkdir -p /catkin_ws/src

RUN git clone https://github.com/Livox-SDK/livox_ros_driver /catkin_ws/src/livox_ros_driver

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && cd /catkin_ws \
 && catkin_make -j1
 
# Code repository
 
RUN  mkdir -p /catkin_ws/src/VoxelMap

COPY . /catkin_ws/src/VoxelMap

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && . /catkin_ws/devel/setup.bash \
 && cd /catkin_ws \
 && catkin_make -j1
 
