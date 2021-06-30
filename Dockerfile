FROM nvidia/cudagl:10.0-devel-ubuntu18.04
MAINTAINER minchang <tjdalsckd@gmail.com>
RUN apt-get update &&  apt-get install -y -qq --no-install-recommends \
    libgl1 \
    libxext6 \ 
    libx11-6 \
   && rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

ENV DEBIAN_FRONTEND=noninteractive 
RUN echo 'export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
RUN echo 'export PATH=/usr/local/cuda/bin:/$PATH' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y wget
RUN apt-get install -y sudo curl
RUN su root
RUN apt-get install -y python
RUN apt-get install -y python3
RUN apt-get update && apt-get install -y lsb-release && apt-get clean all
RUN apt-get install -y cmake
RUN apt-get install -y python3-pip
RUN apt install -y python3-rtree
RUN apt-get install -y --force-yes  python3-tk
RUN apt-get install -y git
RUN apt-get install -y software-properties-common
RUN git config --global user.name "Minchang Sung"
RUN git config --global user.email "tjdalsckd@gmail.com"
RUN /bin/bash -c "cd /root/; git clone https://github.com/tjdalsckd/gqcnnddddd gqcnn_smc;cd gqcnn_smc; pip3 install -U pip;pip3 install trimesh;cd gqcnn; git clone https://github.com/BerkeleyAutomation/meshrender.git; pip3 install ."
RUN apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
RUN  add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
RUN apt-get update
RUN apt-get install -y librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg
RUN /bin/bash -c " pip3 install pyrealsense2; pip3 install tqdm; pip3 install torch; pip3 install pycocotools;"
RUN /bin/bash -c "cd root;git clone https://github.com/tjdalsckd/calibration_docker;"
RUN apt-get install -y \
        build-essential \
        python3 \
        python-dev \
        python3-dev \
        python-tk \
        python3-tk \
        python-opengl \
        curl \
        libsm6 \
        libxext6 \
        libglib2.0-0 \
        libxrender1 \
        wget \
        unzip

RUN pip3 install -U setuptools
RUN apt-get install -y gedit
RUN pip3 install torch==1.4.0 torchvision==0.5.0 -f https://download.pytorch.org/whl/cu100/torch_stable.html
RUN /bin/bash -c "mkdir -p /root/gqcnn_smc/gqcnn/models;cd /root/gqcnn_smc/gqcnn/models; cp /root/calibration_docker/GQCNN-4.0-PJ.zip .; unzip GQCNN-4.0-PJ.zip"
RUN /bin/bash -c "cd /root/gqcnn_smc/gqcnn; pip3 install . ;pip3 install autolab-core==0.0.14 autolab-perception==0.0.8 visualization==0.1.1"
RUN /bin/bash -c "cd /root; git clone https://github.com/tjdalsckd/gqcnnddddd gqcnn_smc2; cp gqcnn_smc2/gqcnn_pj_realsense.yaml gqcnn_smc; rm -r gqcnn_smc2"





RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
RUN apt-get update 
RUN sudo apt-get install -y ros-melodic-desktop-full
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash"

RUN sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
RUN sudo rosdep init
RUN rosdep update

RUN /bin/bash -c 'source /opt/ros/melodic/setup.bash; mkdir -p ~/catkin_ws/src; cd ~/catkin_ws; catkin_make'
RUN apt-get install -y vim gedit
EXPOSE 80
EXPOSE 443

 
