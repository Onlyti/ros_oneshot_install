 ros_initial_setting_with_ros


# Ubuntu 초기 자동 설치기             
## 지원 기능
 *Ubuntu 버전 자동인지하여 ROS 설치 지원*      
                        
  1. ROS 설치 (기존 ROS 제거 - 옵션)               
  2. Utility 설치 (ros msgs, driver, tool 설치     
    2.1 설치 Utility 목록                          
        2.1.1 novatel_msgs                         
        2.1.2 can_msgs                             
        2.1.3 jsk_rviz_plugin                      
        2.1.4 plotjuggler                          
        2.1.5 gedit                                
        2.1.6 terminator                           
  3. .bashrc 설정 추가 (Xwindow, ROS, shortcuts)   
    3.1 입력 목록                                  
        3.1.1 Xwindow                              
             3.1.1.1 Server IP                     
        3.1.2 ROS                                  
             3.1.2.1 ROS master IP                 
             3.1.2.2 LOCAL IP                      
             3.1.2.2 Default workspace directory   
        3.1.3 Shortcuts                            
             3.1.3.1 Git                           
             3.1.3.2 Change directory              
             3.1.3.3 Build tool                    
## 입력 인자
Arguments

    -fr: force reinstall ros                [yes|y|no|n] (default: no)
    -xw: Xwindow .bashrc configuration      [yes|y|no|n] (default: no)
    -sc: Shortcuts .bashrc configuration    [yes|y|no|n] (default: yes)
    -ut: utility install                    [yes|y|no|n] (default: yes)

## 사용 예시
./ubuntu_initial_setting_with_ros1.sh [command] [input] ....
```
git clone http://KUAilab.synology.me:30000/jiwon.seok/ros_initial_setting_with_ros.git
./ubuntu_initial_setting_with_ros1.sh -fr n -xw y -sc yes 
```