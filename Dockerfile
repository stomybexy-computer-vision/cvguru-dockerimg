# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.134.0/containers/python-3/.devcontainer/base.Dockerfile
ARG VARIANT="3.8"
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT}

# [Optional] Allow the vscode user to pip install globally w/o sudo
ENV PIP_TARGET=/usr/local/pip-global
ENV PYTHONPATH=${PIP_TARGET}:${PYTHONPATH}
ENV PATH=${PIP_TARGET}/bin:${PATH}
RUN mkdir -p ${PIP_TARGET} \
    && chown vscode:root ${PIP_TARGET} \
    && echo "if [ \"\$(stat -c '%U' ${PIP_TARGET})\" != \"vscode\" ]; then chown -R vscode:root ${PIP_TARGET}; fi" \
        | tee -a /root/.bashrc /home/vscode/.bashrc /root/.zshrc >> /home/vscode/.zshrc 

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential cmake unzip pkg-config software-properties-common

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libjpeg-dev libtiff-dev libpng-dev

RUN add-apt-repository "deb http://security.debian.org/debian-security jessie/updates main"
RUN apt update 

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends libjasper1 libjasper-dev

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libgtk-3-dev

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libv4l-dev

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libxvidcore-dev libx264-dev

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libatlas-base-dev gfortran

RUN pip3 install --upgrade numpy
RUN pip3 install --upgrade scipy matplotlib
RUN pip3 install --upgrade scikit-learn
RUN pip3 install --upgrade scikit-image
RUN pip3 install --upgrade mahotas imutils Pillow json_minify

RUN cd ~ && wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
RUN cd ~ && wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip

RUN cd ~ && unzip opencv.zip
RUN cd ~ && unzip opencv_contrib.zip

RUN cd ~ && mv opencv-4.2.0 opencv
RUN cd ~ && mv opencv_contrib-4.2.0 opencv_contrib

RUN cd ~/opencv && mkdir build 

RUN cd ~/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_EXAMPLES=ON ..

RUN cd ~/opencv/build && make -j6

RUN cd ~/opencv/build && sudo make install
RUN cd ~/opencv/build && sudo ldconfig

RUN cd /usr/local/lib/python3.8/site-packages/cv2/python-3.8/ && sudo mv cv2.cpython-38-x86_64-linux-gnu.so cv2.so


