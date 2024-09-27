# ROS Auto Installation Script

This project provides scripts for automatic installation and initial setup of ROS (Robot Operating System) in Ubuntu environments.

## Features

- Automatic detection of Ubuntu version and installation of corresponding ROS version
- Support for ROS 1 (Melodic, Noetic) and ROS 2 (Foxy, Humble)
- Option to remove existing ROS installation
- Installation of useful utilities
- Automatic configuration of `.bashrc` file (Xwindow, ROS, shortcuts)

## Utility Installation List

1. ROS-related:
   - novatel_msgs (ROS 1 only)
   - can_msgs
   - jsk_rviz_plugin (ROS 1 only)
   - plotjuggler

2. Ubuntu utilities:
   - gedit
   - terminator

## Usage

1. Clone the repository:
   ```
   git clone https://github.com/your-username/ros-auto-install.git
   cd ros-auto-install
   ```

2. Run the script:
   - For ROS 1:
     ```
     ./ubuntu_initial_setting_with_ros1.sh [options]
     ```
   - For ROS 2:
     ```
     ./ubuntu_initial_setting_with_ros2.sh [options]
     ```

## Options

- `-lt`: Set local timezone to US [yes|y|no|n] (default: no)
- `-fr`: Force reinstall ROS [yes|y|no|n] (default: no)
- `-xw`: Xwindow .bashrc configuration [yes|y|no|n] (default: no)
- `-sc`: Shortcuts .bashrc configuration [yes|y|no|n] (default: yes)
- `-ut`: Utility installation [yes|y|no|n] (default: yes)

## Example

```bash
./ubuntu_initial_setting_with_ros1.sh -fr y -xw y -sc yes -ut yes
```
This command will force reinstall ROS 1, add Xwindow configuration, set up shortcuts, and install utilities.

## Precautions

- This script has been tested on Ubuntu 18.04, 20.04 (ROS 1) and 20.04, 22.04 (ROS 2).
- It is recommended to backup your system before running the script.
- Administrator privileges (sudo) are required.

## Contributing

Bug reports, feature requests, and pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is distributed under the [MIT License](LICENSE).

## Author

Jiwon Seok - Initial work - [GitHub Profile Link](https://github.com/Onlyti)