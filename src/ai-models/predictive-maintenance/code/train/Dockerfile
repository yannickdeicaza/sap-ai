FROM tensorflow/tensorflow:latest-gpu
RUN export LD_LIBRARY_PATH=/usr/local/nvidia/lib:$LD_LIBRARY_PATH

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

RUN mkdir -m 777 /tmp/NUMBA_CACHE_DIR /tmp/MPLCONFIGDIR
ENV NUMBA_CACHE_DIR=/tmp/NUMBA_CACHE_DIR/
ENV MPLCONFIGDIR=/tmp/MPLCONFIGDIR/

RUN export LD_LIBRARY_PATH=/usr/local/nvidia/lib:$LD_LIBRARY_PATH
RUN export NUMBA_CACHE_DIR=/tmp/

RUN pip3 install --upgrade pip
COPY requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt

#required for librosa
RUN apt-get update -y
RUN apt-get install -y libsndfile-dev

RUN mkdir -p /app/src/ && \
    mkdir -p /app/model && \
    mkdir -p /app/data

COPY train.py /app/src/

ENV DATA_SOURCE=/app/data
ENV OUTPUT_PATH=/app/model

RUN chgrp -R 65534 /app && \
    chmod -R 770 /app
