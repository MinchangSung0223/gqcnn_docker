FROM nvidia/cudagl:10.0-devel-ubuntu16.04
MAINTAINER minchang <tjdalsckd@gmail.com>
RUN apt-get update &&  apt-get install -y -qq --no-install-recommends \
    libgl1 \
    libxext6 \ 
    libx11-6 \
   && rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute


RUN echo 'export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
RUN echo 'export PATH=/usr/local/cuda/bin:/$PATH' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y wget
RUN apt-get install -y sudo curl
RUN su root
RUN apt-get install -y python
RUN apt-get update && apt-get install -y lsb-release && apt-get clean all
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
RUN apt-get update 
RUN sudo apt-get install -y ros-kinetic-desktop-full
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"

RUN sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
RUN sudo rosdep init
RUN rosdep update

RUN /bin/bash -c 'source /opt/ros/kinetic/setup.bash; mkdir -p ~/catkin_ws/src; cd ~/catkin_ws; catkin_make'
RUN mkdir -p ~/libraries;
RUN apt-get install -y libssl-dev ; 

RUN /bin/bash -c "cd ~/libraries; wget https://cmake.org/files/v3.18/cmake-3.18.0.tar.gz; tar -zxvf cmake-3.18.0.tar.gz ;  cd cmake-3.18.0;  ./bootstrap; make -j16; make install"

RUN /bin/bash -c "cd ~/libraries ;wget https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.tar.gz ;tar xvf eigen-3.3.9.tar.gz ;  cd eigen-3.3.9;mkdir build; cd build; cmake ..; make -j16; make install;cd ~; "

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate ros" >> ~/.bashrc

RUN /bin/bash -c "cd ~/libraries;wget https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz;tar -zxvf VTK-8.2.0.tar.gz;cd VTK-8.2.0 ;mkdir build ;cd build ; cmake .. ; make -j16 ; make install ;"


RUN /bin/bash -c "cd ~/libraries; wget https://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz;tar -zxvf boost_1_58_0.tar.gz;cd boost_1_58_0;sudo bash bootstrap.sh;./b2;./b2 install;"

RUN /bin/bash -c "cd ~/libraries;sudo apt-get  install -y libudev-dev;sudo apt-get install -y libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libglfw3-dev libglfw3 ;apt-get install -y openjdk-8-jre ;apt-get install -y openjdk-8-jdk;sudo apt-get install -y graphviz;cd ~/libraries;git clone https://github.com/occipital/OpenNI2.git;cd OpenNI2;make -j16;rm -r /usr/local/lib/libOpenNI2.so;rm -r /usr/local/lib/OpenNI2;rm -r /usr/local/include/OpenNI2;sudo ln -s $PWD/Bin/x64-Release/libOpenNI2.so /usr/local/lib/;sudo ln -s $PWD/Bin/x64-Release/OpenNI2/ /usr/local/lib/ ;sudo ln -s $PWD/Include /usr/local/include/OpenNI2;ldconfig;"

RUN /bin/bash -c "cd ~/libraries;sudo apt-get install -y libeigen3-dev;apt-get install  -y libflann-dev;sudo apt-get install  -y g++ cmake cmake-gui doxygen mpi-default-dev openmpi-bin openmpi-common libeigen3-dev libboost-all-dev libqhull* libusb-dev libgtest-dev git-core freeglut3-dev pkg-config build-essential libxmu-dev libxi-dev libusb-1.0-0-dev graphviz mono-complete qt-sdk libeigen3-dev;sudo apt install  -y libglew-dev;sudo apt-get install -y  libsqlite3-0 libpcap0.8  ;sudo apt-get install  -y libpcap-dev;wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz;tar xvf pcl-1.9.1.tar.gz;cd pcl-pcl-1.9.1;mkdir build;cd build;cmake .. -D WITH_OPENNI=True -D WITH_OPENNI2=True;make -j16;make install;"

RUN apt-get install -y ros-kinetic-moveit*
RUN apt-get install -y ros-kinetic-ompl
RUN apt-get install -y ros-kinetic-realsense2-camera
RUN /bin/bash -c "source /opt/conda/etc/profile.d/conda.sh; conda create -n ros python=2;source ~/anaconda3/etc/profile.d/conda.sh;conda activate ros;source ~/.bashrc; pip install -U pip;pip install -U rosdep; cd ~; mkdir workspace; cd workspace; apt-get install cmake-qt-gui;apt-get install libglew-dev;apt-get install libglm-dev;sudo apt-get install qt5-default;git clone https://github.com/fzi-forschungszentrum-informatik/gpu-voxels.git;cd gpu-voxels/;mkdir build;cd build/;cmake .. -D ENABLE_CUDA=True;make -j16; make install;"
RUN /bin/bash -c "export GPU_VOXELS_MODEL_PATH=~/workspace/gpu-voxels/packages/gpu_voxels/models/";
#RUN /bin/bash -c "source ~/.bashrc;apt-get install -y python-pip; pip install -U pip ;pip install typing;pip install pybullet==3.0.8; pip install -U pip; pip install -U numpy;"



RUN apt-get install -y xauth
RUN apt-get install -y at
RUN apt-get install -y software-properties-common
RUN add-apt-repository --keyserver hkps://keyserver.ubuntu.com:443 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE




RUN sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo xenial main" -u
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg

#RUN /bin/bash -c "cd ~/libraries;git clone https://github.com/IntelRealSense/librealsense.git;cd librealsense; mkdir build; cd build; cmake ..; make -j16; make install;"
RUN /bin/bash -c "cd ~/workspace/; git clone https://github.com/tjdalsckd/libfranka_gpu_voxel;cd ~/workspace/ "

RUN apt-get install -y ros-kinetic-libfranka
RUN apt-get install  -y gedit


#RUN /bin/bash -c "cd ~/workspace/gpu_voxel_panda_sim; cp ../ros_trajectory_subscriber/examples_common.* .;"
RUN /bin/bash -c "cd /usr/include; ln -s eigen3/Eigen Eigen;"
RUN /bin/bash -c "cd ~;cd ~/workspace/; git clone https://github.com/tjdalsckd/ros_trajectory_subscriber.git;cd ~/workspace/"

RUN /bin/bash -c "cd ~;cd ~/workspace/; git clone https://github.com/tjdalsckd/gpu_voxel_start_guide.git;cd ~/workspace/"

RUN cd ~/workspace
RUN echo 'cd /root/workspace' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc;"

RUN /bin/bash -c "cd /root/workspace; git clone https://github.com/tjdalsckd/panda_sim_joint_trajectory;"
RUN apt-get install -y python-pip
RUN /bin/bash -c "/opt/conda/envs/ros/bin/pip install -U numpy ;/opt/conda/envs/ros/bin/pip  install pybullet"

EXPOSE 80
EXPOSE 443

 
