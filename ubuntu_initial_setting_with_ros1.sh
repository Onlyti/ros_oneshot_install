#!/bin/bash

# 버전 검사
result_18=$(cat /etc/os-release | grep -i 18.04)
result_20=$(cat /etc/os-release | grep -i 20.04)
ubuntu_version=""
ubuntu_version_name=""
if [ ! -z "$result_18" ]; then
    ubuntu_version="18.04"
    ubuntu_version_name="melodic"
fi
if [ ! -z "$result_20" ]; then
    ubuntu_version="20.04"
    ubuntu_version_name="noetic"
fi
if [ -z "$ubuntu_version" ]; then
    echo "본 프로그램은 Ubuntu 18.04, 20.04에서 작동합니다."
    exit 55
fi

# 안내
./readme.sh

# Input arg check
reinstall_ros="none"
xwindow_configration="none"
shortcuts_configuration="none"
utility_install="none"
help_command="no"
while [ ! -z "$1" ]
do
    if [ "$1" = "-fr" ]; then
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
# Setup sources.list
echo
echo "## Setup sources.list ##"
(sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list')
if [ "$?" != "0" ] ; then
    echo "Setup sources.list 실패"
    exit 1
fi

# Setup key
echo
echo "## Setup key ##"
(sudo apt install curl -y) # if you haven't already installed curl
if [ "$?" != "0" ] ; then
    echo "Setup key 실패"
    exit 1
fi

# Installing
echo
echo "## Installing ##"
(curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -)
if [ "$?" != "0" ] ; then
    echo "apt-key add 실패"
    exit 1
fi

(sudo apt update)
if [ "$?" != "0" ] ; then
    echo "apt update 실패"
    exit 1
fi

# Clearing prev intalled ros
if [ reinstall_ros = "yes" ]; then
    (sudo apt purge ros-* -y)
    if [ "$?" != "0" ] ; then
        echo "ROS 제거 실패"
    fi
fi
echo
echo "### Install ROS desktop"
(eval "sudo apt install ros-$ubuntu_version_name-desktop-full -y")
if [ "$?" != "0" ] ; then
    echo "ROS install 실패"
    exit 1
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
result_bashrc_already_update=$(cat ~/.bashrc | grep "# ROS")
if [ ! -z "$result_bashrc_already_update" ]; then
    echo ".bashrc는 이미 업데이트 되어있음"
else
    echo "## .bashrc update ##"
    if [ xwindow_configration = "yes" ]; then
        echo "" >> ~/.bashrc
        echo "# For wsl display (xwindow)" >> ~/.bashrc
        echo "export DISPLAY_NUMBER=\"0.0\"" >> ~/.bashrc
        echo "export LIBGL_ALWAYS_INDIRECT=0" >> ~/.bashrc
        echo "export DISPLAY=172.22.80.1:0" >> ~/.bashrc
        echo "export DISPLAY=\"`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0\"" >> ~/.bashrc
    fi

    echo "" >> ~/.bashrc
    echo "# ROS" >> ~/.bashrc
    echo "export ROS_WS=\"~/catkin_ws\"" >> ~/.bashrc
    echo "source /opt/ros/$ubuntu_version_name/setup.bash" >> ~/.bashrc
    echo "source \$ROS_WS/devel/setup.bash" >> ~/.bashrc
    
    echo "" >> ~/.bashrc
    echo "export ROS_IP=localhost" >> ~/.bashrc
    echo "export ROS_MASTER_URI=http://\$ROS_IP:11311/" >> ~/.bashrc
    echo "export ROS_HOSTNAME=\$ROS_IP" >> ~/.bashrc

    if [ shortcuts_configuration = "yes" ]; then
        echo "" >> ~/.bashrc
        echo "# Short cuts" >> ~/.bashrc
        echo "## short cut for ros" >> ~/.bashrc

        echo "" >> ~/.bashrc
        echo "alias cw=\"cd \$ROS_WS\"" >> ~/.bashrc
        echo "alias cs=\"cw && cd src\"" >> ~/.bashrc
        echo "alias cm=\"cw && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release\"" >> ~/.bashrc
        echo "alias cmdg=\"cw && catkin_make --cmake-args  -DCMAKE_BUILD_TYPE=Debug\"" >> ~/.bashrc
        echo "alias rmdb=\"cw && rm -rf devel build\"" >> ~/.bashrc
        echo "alias sd=\"source \$ROS_WS/devel/setup.bash\"" >> ~/.bashrc

        echo "" >> ~/.bashrc
        echo "## .bashrc" >> ~/.bashrc
        echo "alias sb=\"source ~/.bashrc\"" >> ~/.bashrc
        echo "alias eb=\"gedit ~/.bashrc\"" >> ~/.bashrc

        echo "" >> ~/.bashrc
        echo "## git" >> ~/.bashrc
        echo "alias gs=\"git status\"" >> ~/.bashrc
        echo "alias gp=\"git pull\"" >> ~/.bashrc
    fi
fi

# Dependencies for building packages
echo
echo "## Dependencies for building packages ##"
if [ "$ubuntu_version" = "18.04" ] ; then
    (sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y)
else
    (sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y)
fi
if [ "$?" != "0" ] ; then
    echo "dependency 설치 실패"
    exit 1
fi
echo
echo "### rosdep inititialization"
(sudo rosdep init)
echo "rosdep : $?"
if [ "$?" != "0" ] ; then
    echo "rosdep init 실패"
fi
echo
echo "### rosdep update"
(rosdep update)
if [ "$?" != "0" ] ; then
    echo "rosdep update 실패"
    exit 1
fi

# Workspace initialization
echo
echo "## Workspace initialization ##"
(
    cd ~
    mkdir catkin_ws
    cd catkin_ws
    mkdir src
    catkin_make
    exit 0
)

# Install utility
echo
echo "## Install utilities"
if [ "$utility_install" = "yes" ] ; then
    echo "### Install ROS utilities"
    (eval "sudo apt install ros-$ubuntu_version_name-novatel-oem7-driver ros-$ubuntu_version_name-can-msgs ros-$ubuntu_version_name-jsk-rviz-plugins ros-$ubuntu_version_name-plotjuggler* -y")
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