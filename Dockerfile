FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

# Tools
RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# apt packages
RUN apt-get update \
 && apt-get install -y libceres-dev \
 && rm -rf /var/lib/apt/lists/*

# ROS packages
RUN  mkdir -p /catkin_ws/src
RUN git clone --recurse-submodules \
      https://github.com/Livox-SDK/livox_ros_driver \
      /catkin_ws/src/livox_ros_driver
 
# Code repository
RUN git clone --recurse-submodules \
      https://github.com/RobotResearchRepos/hku-mars_VoxelMap \
      /catkin_ws/src/VoxelMap

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make -j1
 
RUN sed --in-place --expression \
      '$isource "/catkin_ws/devel/setup.bash"' \
      /ros_entrypoint.sh
