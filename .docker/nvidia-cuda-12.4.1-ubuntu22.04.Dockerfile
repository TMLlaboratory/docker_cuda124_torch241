FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

# 非対話型のインストール設定
ENV DEBIAN_FRONTEND=noninteractive

# 作業ディレクトリを設定
WORKDIR /app

# 必要なシステム依存関係のインストール
RUN apt update -y && \
    apt install -y \
    software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt update -y && \
    apt install -y \
    wget \
    bzip2 \
    build-essential \
    git \
    git-lfs \
    curl \
    ca-certificates \
    libsndfile1-dev \
    libgl1 \
    python3.12 \
    python3.12-venv \
    python3-pip

# 最新の pip, setuptools, wheel をインストール
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.12 get-pip.py && \
    rm get-pip.py
    
# Python3.12をデフォルトのpythonコマンドに設定
RUN update-alternatives --install /usr/local/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/local/bin/pip3 pip3 /usr/bin/pip3 1


# 依存関係ファイルをコピー
COPY src/requirements.txt /app

# pip のアップグレードと Python パッケージのインストール
RUN python3.12 -m pip install --no-cache-dir -U pip && \
    python3.12 -m pip install --no-cache-dir -r requirements.txt

# # CUDA 12.4
# RUN pip install torch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 --index-url https://download.pytorch.org/whl/cu124
