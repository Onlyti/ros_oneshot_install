#!/bin/bash

# https://docs.ros.org/en/foxy/Installation/Alternatives/Ubuntu-Install-Binary.html

# 버전 검사
result_20=$(cat /etc/os-release | grep -i 20.04)
result_22=$(cat /etc/os-release | grep -i 22.04)
ubuntu_version=""
ubuntu_version_name=""
if [ ! -z "$result_20" ]; then
    ubuntu_version="20.04"
    ubuntu_version_name="foxy"
fi
if [ ! -z "$result_22" ]; then
    ubuntu_version="22.04"
    ubuntu_version_name="humble"
fi
if [ -z "$ubuntu_version" ]; then
    echo "본 프로그램은 Ubuntu 20.04, 22.04에서 작동합니다."
    exit 55
fi

# 안내
./readme.sh

# Input arg check
set_local_timezone="none"
reinstall_ros="none"
xwindow_configration="none"
shortcuts_configuration="none"
utility_install="none"
help_command="no"
while [ ! -z "$1" ]
do
    if [ "$1" = "-lt" ]; then
        if [ ! -z "$2" ]; then
            set_local_timezone="$2"
        fi
    elif [ "$1" = "-fr" ]; then
        if [ ! -z "$2" ]; then
            reinstall_ros="$2"
        fi
    elif [ "$1" = "-xw" ]; then
        if [ ! -z "$2" ]; then
            xwindow_configration="$2"
        fi
    elif [ "$1" = "-sc" ]; then
        if [ ! -z "$2" ]; then
            shortcuts_configuration="$2"
        fi
    elif [ "$1" = "-ut" ]; then
        if [ ! -z "$2" ]; then
            utility_install="$2"
        fi
    fi
    if [ "$1" = "-h" ]; then
        exit 55
    fi
    shift 1
done

# if [ "$reinstall_ros" = "none" ];then
#     echo
#     echo "사전설치된 ROS가 있는경우 재 설치 하시겠습니까?"
#     echo "예:[yes|y] 아니오:[no|n|<Othor>]"
#     read reinstall_ros
#     echo
# fi

# Argument validation
## Set Local Timezone
if [ "$set_local_timezone" = "yes" ] |\
    [ "$set_local_timezone" = "y" ];then
    set_local_timezone="yes"
else
    set_local_timezone="no"
fi
## ros reinstall. default: no
if [ $reinstall_ros = "yes" ] |\
    [ $reinstall_ros = "y" ];then
    reinstall_ros="yes"
else
    reinstall_ros="no"
fi
## Xwindow configuration. default: no
if [ "$xwindow_configration" = "yes" ] |\
    [ "$xwindow_configration" = "y" ];then
    xwindow_configration="yes"
else
    xwindow_configration="no"
fi
## Shortcuts configuration. default: yes
if [ "$shortcuts_configuration" = "no" ] |\
    [ "$shortcuts_configuration" = "n" ];then
    shortcuts_configuration="no"
else
    shortcuts_configuration="yes"
fi
## Utility install. default: yes
if [ "$utility_install" = "no" ] |\
    [ "$utility_install" = "n" ];then
    utility_install="no"
else
    utility_install="yes"
fi

# Configuration check
echo
echo "Set Local Timezone:      $set_local_timezone"
echo "Force Reinstall ROS:     $reinstall_ros"
echo "Xwindow Configuration:   $xwindow_configration"
echo "Shortcuts Configuration: $shortcuts_configuration"
echo "Utility Installation:    $utility_install"
echo

sleep 3

# update
(sudo apt update)
if [ "$?" != "0" ] ; then
    echo "apt update 실패"
    echo "예상되는 에러 원인"
    echo "1. 등록된 키가 업데이트 등의 이유로 더이상 제공안됨 -> 문제가 되는 키 찾아 업데이트"
    echo "2. 시스템 상의 시간이 서버와 많은 차이가 남 -> 시스템 시간 서버와 동기화"
    exit 1
fi
# upgrade
(sudo apt upgrade -y)
if [ "$?" != "0" ] ; then
    echo "apt upgrade 실패"
    exit 1
fi

###########################
# ROS Installation        #
###########################

# Set Local Timezone

if [ "$set_local_timezone" = "yes" ]; then
    echo
    echo "## Set Local Timezone to en_US.UTF-8 ##"

    locale  # check for UTF-8

    sudo apt update && sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8

    locale  # verify settings
fi

# Add ROS 2 apt repository
echo
echo "## Add ROS 2 apt repository ##"
echo "## First ensure that the Ubuntu Universe repository is enabled. ##"
(sudo apt install software-properties-common -y | sudo add-apt-repository universe -y)
if [ "$?" != "0" ] ; then
    echo "Add ROS 2 apt repository 실패"
    exit 1
fi

# Setup key
echo
echo "## Now add the ROS 2 GPG key with apt. ##"
(sudo apt update && sudo apt install curl -y | sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg)
if [ "$?" != "0" ] ; then
    echo "Add ROS 2 apt repository 실패"
    exit 1
fi

echo "## Then add the repository to your sources list. ##"
(echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null)
if [ "$?" != "0" ] ; then
    echo "Add ROS 2 apt repository 실패"
    exit 1
fi


# Install ROS 2 packages
# Installing development tools and ROS tools
echo
echo "## Installing development tools and ROS tools ##"
(sudo apt update && sudo apt upgrade -y)
if [ "$?" != "0" ] ; then
    echo "apt install 실패"
    exit 1
fi

# Clearing prev intalled ros
if [ "$reinstall_ros" = "yes" ]; then
    (sudo apt remove ~nros-$ubuntu_version_name-* -y && sudo apt autoremove -y)
    if [ "$?" != "0" ] ; then
        echo "ROS 제거 실패"
    fi
fi
echo
echo "### Install ROS desktop"
(eval "sudo apt install ros-$ubuntu_version_name-desktop -y")
if [ "$?" != "0" ] ; then
    echo "ROS install 실패"
    exit 1
fi
if [ "$ubuntu_version" = "20.04" ]; then
    (eval "sudo apt install python3-argcomplete -y")
    if [ "$?" != "0" ] ; then
        echo "python3-argcomplete install 실패"
        exit 1
    fi
fi


# Environment setup
## Source opt ROS
echo
echo "### Source ROS setup.bash"
(eval "source /opt/ros/$ubuntu_version_name/setup.bash")
if [ "$?" != "0" ] ; then 
    echo "Source opt ROS 실패"
    # exit 1
fi
## .bashrc update

# 이전에 .bashrc가 업데이트 되었는지 확인
result_bashrc_already_update=$(cat ~/.bashrc | grep "# ROS2")
if [ ! -z "$result_bashrc_already_update" ]; then
    echo ".bashrc는 이미 업데이트 되어있음"
else
    echo "## .bashrc update ##"
    if [ "$xwindow_configration" = "yes" ]; then
        echo "" >> ~/.bashrc
        echo "# For wsl display (xwindow)" >> ~/.bashrc
        echo "export DISPLAY_NUMBER=\"0.0\"" >> ~/.bashrc
        echo "export LIBGL_ALWAYS_INDIRECT=0" >> ~/.bashrc
        echo "export DISPLAY=172.22.80.1:0" >> ~/.bashrc
        echo "export DISPLAY=\"`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0\"" >> ~/.bashrc
    fi

    echo "" >> ~/.bashrc
    echo "# ROS2" >> ~/.bashrc
    echo "export ROS_WS2=\"~/ros2_ws\"" >> ~/.bashrc
    echo "source /opt/ros/$ubuntu_version_name/setup.bash" >> ~/.bashrc
    echo "source \$ROS_WS2/install/setup.bash" >> ~/.bashrc

    if [ shortcuts_configuration = "yes" ]; then
        echo "" >> ~/.bashrc
        echo "# Short cuts" >> ~/.bashrc
        echo "## short cut for ros" >> ~/.bashrc

        echo "" >> ~/.bashrc
        echo "alias cb=\"colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release\"" >> ~/.bashrc
        echo "alias cbdg=\"colcon build --cmake-args  -DCMAKE_BUILD_TYPE=Debug\"" >> ~/.bashrc
        echo "alias rmbi=\"rm -rf build install\"" >> ~/.bashrc
        echo "alias si=\"source \$ROS_WS2/install/setup.bash\"" >> ~/.bashrc
    fi
fi

# Workspace initialization
echo
echo "## Workspace initialization ##"
(
    cd ~
    mkdir ros2_ws
    cd ros2_ws
    mkdir src
    colcon build
    exit 0
)

# Install utility
echo
echo "## Install utilities"
if [ "$utility_install" = "yes" ] ; then
    echo "### Install ROS utilities"
    # ros-$ubuntu_version_name-novatel-oem7-driver, ros-$ubuntu_version_name-jsk-rviz-plugins are not support for ros2 now.
    (eval "sudo apt install ros-$ubuntu_version_name-can-msgs ros-$ubuntu_version_name-plotjuggler* -y")
    if [ "$?" != "0" ] ; then
        echo "Ros utility 설치 실패"
        exit 1
    fi

    echo "### Install ubuntu utilities"
    (sudo apt install gedit terminator -y)
    if [ "$?" != "0" ] ; then
        echo "utility 설치 실패"
        exit 1
    fi
fi

## source .bashrc
echo
echo "## source .bashrc ##"
(source ~/.bashrc)
if [ "$?" != "0" ] ; then 
    echo "source .bashrc 실패"
fi