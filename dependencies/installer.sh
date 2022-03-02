#!/usr/bin/env bash
#
echo "Setting up model dependencies...."

apt-get update && apt-get upgrade -y
apt-get install -y sudo wget python3-pip
apt-get install -y liblzma-dev libbz2-dev libzstd-dev libsndfile1-dev libopenblas-dev libfftw3-dev libgflags-dev libgoogle-glog-dev libfst-tools libgmp3-dev
apt-get install -y ffmpeg git
apt-get install -y build-essential cmake libboost-system-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libeigen3-dev zlib1g-dev libbz2-dev sox
apt install -y gcc-10 gcc-10-base gcc-10-doc g++-10 libstdc++-10-dev libstdc++-10-doc libgcc-7-dev libsndfile1

pip3 install packaging soundfile
pip3 install pynini julius

sudo mkdir -p /opt/files
sudo chmod 777 -R /opt/files
cd /opt/files

if [ ! -d kenlm ]; then
  git clone https://github.com/kpu/kenlm.git
fi
cd kenlm
mkdir -p build && cd build
cmake ..
make -j 16
cd ..
export KENLM_ROOT=$PWD
export USE_CUDA=0 ## for cpu
cd ..


git clone https://github.com/flashlight/flashlight.git
cd flashlight/bindings/python
export USE_MKL=0
python3 setup.py install


#pip3 install git+https://github.com/Open-Speech-EkStep/indic-punct.git#egg=indic-punct

cd /opt/files

#pip3 install ray[tune]
#pip3 install 'ray[default]'
#pip3 install -U https://storage.googleapis.com/vakyaansh-open-models/ray/ray-2.0.0.dev0-cp38-cp38-manylinux2014_x86_64.whl
pip3 install Cython
pip3 install nemo_toolkit[all]==v1.0.2

pip3 install git+https://github.com/Open-Speech-EkStep/fairseq.git@v2-hydra

if [ ! -d denoiser ]; then
  git clone https://github.com/Open-Speech-EkStep/denoiser.git
fi

apt install -y graphviz
#wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.1.tar.gz
#tar -xzf openfst-1.8.1.tar.gz
#cd openfst-1.8.1/
#sh ./configure --enable-grm --enable-far=true && sudo make -j install
#echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib" >> ~/.bashrc
#sh ~/.bashrc
#cd ..
#rm -rf openfst-1.8.1

# wget http://www.openfst.org/twiki/pub/GRM/PyniniDownload/pynini-2.1.4.tar.gz
# tar -xzf pynini-2.1.4.tar.gz
# cd pynini-2.1.4/
# python3 setup.py install
# cd ..
# rm -rf pynini-2.1.4

git clone https://github.com/Open-Speech-EkStep/indic-punct.git -b deploy
cd indic-punct
bash install.sh
python3 setup.py bdist_wheel
pip3 install -e .
pip3 install torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html
cd ..


#if [ ! -d fairseq ]; then
#  git clone https://github.com/Open-Speech-EkStep/fairseq -b v2-hydra
#fi
#cd fairseq
#pip3 install -e .

apt install python-is-python3
