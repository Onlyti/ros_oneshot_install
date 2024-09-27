# ROS 자동 설치 스크립트

이 프로젝트는 Ubuntu 환경에서 ROS(Robot Operating System)를 자동으로 설치하고 초기 설정을 수행하는 스크립트를 제공합니다.

## 지원 기능

- Ubuntu 버전 자동 감지 및 해당 버전에 맞는 ROS 설치
- ROS 1 (Melodic, Noetic) 및 ROS 2 (Foxy, Humble) 지원
- 기존 ROS 제거 옵션
- 유용한 유틸리티 설치
- `.bashrc` 파일 자동 설정 (Xwindow, ROS, 단축키)

## 설치 유틸리티 목록

1. ROS 관련:
   - novatel_msgs (ROS 1 전용)
   - can_msgs
   - jsk_rviz_plugin (ROS 1 전용)
   - plotjuggler

2. Ubuntu 유틸리티:
   - gedit
   - terminator

## 사용 방법

1. 저장소를 클론합니다:
   ```
   git clone https://github.com/your-username/ros-auto-install.git
   cd ros-auto-install
   ```

2. 스크립트를 실행합니다:
   - ROS 1의 경우:
     ```
     ./ubuntu_initial_setting_with_ros1.sh [옵션]
     ```
   - ROS 2의 경우:
     ```
     ./ubuntu_initial_setting_with_ros2.sh [옵션]
     ```

## 옵션

- `-lt`: 로컬 시간대를 미국으로 설정 [yes|y|no|n] (기본값: no)
- `-fr`: ROS 강제 재설치 [yes|y|no|n] (기본값: no)
- `-xw`: Xwindow .bashrc 설정 [yes|y|no|n] (기본값: no)
- `-sc`: 단축키 .bashrc 설정 [yes|y|no|n] (기본값: yes)
- `-ut`: 유틸리티 설치 [yes|y|no|n] (기본값: yes)

## 예시

```bash
./ubuntu_initial_setting_with_ros1.sh -fr y -xw y -sc yes -ut yes
```

이 명령은 ROS 1을 강제로 재설치하고, Xwindow 설정을 추가하며, 단축키를 설정하고, 유틸리티를 설치합니다.

## 주의사항

- 이 스크립트는 Ubuntu 18.04, 20.04 (ROS 1) 및 20.04, 22.04 (ROS 2)에서 테스트되었습니다.
- 스크립트를 실행하기 전에 시스템 백업을 권장합니다.
- 관리자 권한(sudo)이 필요합니다.

## 기여

버그 리포트, 기능 요청 및 풀 리퀘스트를 환영합니다. 주요 변경사항의 경우, 먼저 이슈를 열어 논의해주세요.

## 라이선스

이 프로젝트는 [MIT 라이선스](LICENSE)하에 배포됩니다.

## 작성자

Jiwon Seok - 초기 작업 - [[GitHub 프로필](https://github.com/Onlyti)]
