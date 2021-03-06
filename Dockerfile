FROM tensorflow/tensorflow:2.3.0-jupyter

LABEL maintainer="youremail@here.com"

RUN apt-get -y update -o Acquire::https::Verify-Peer=false \ 
    && apt-get -y install --no-install-recommends \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libsm6 \
    libxext6 \
    libxrender1 \
    git \
    && apt-get clean \
    && rm -rf \
    /tmp/hsperfdata* \
    /var/*/apt/*/partial \
    /var/lib/apt/lists/*

ENV PATH="${PATH}:/root/.local/bin"

COPY requirements.txt /

RUN pip3 install --user --upgrade -r /requirements.txt

RUN git clone https://github.com/fizyr/keras-retinanet.git

RUN cd keras-retinanet && \
    pip3 install --user .

RUN pip3 install --user git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI

WORKDIR /

CMD ["/bin/bash", "-c", "jupyter notebook --allow-root --ip='0.0.0.0' --no-browser --NotebookApp.token=''"]
