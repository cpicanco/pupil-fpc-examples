# pupil-fpc-examples
Examples for: https://github.com/cpicanco/pupil-fpc

## steps to compile examples on a 64 bit debian based distro

```bash
# download Lazarus and FPC
cd ~
mkdir lazarus-tmp
cd lazarus-tmp
wget https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0RC4/fpc-src_3.0.4-rc1_amd64.deb/download
wget https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0RC4/fpc_3.0.4-rc1_amd64.deb/download
wget https://sourceforge.net/projects/lazarus/files/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0RC4/lazarus-project_1.8.0RC4-0_amd64.deb/download

# install Lazarus and FPC
sudo apt install ./fpc-src_3.0.4-rc1_amd64.deb
sudo apt install ./fpc_3.0.4-rc1_amd64.deb
sudo apt install ./lazarus-project_1.8.0RC4-0_amd64.deb

# download this repository and all dependencies
cd ~
mkdir git
cd git
git clone --recursive https://github.com/cpicanco/pupil-fpc-examples.git

# install libzmq devkit dependencies
sudo apt-get install libtool-bin

# compile libzmq *note: tested on checkout f1c72dc 
cd pupil-fpc-examples/libzmq
# git checkout f1c72dc8e5a92c32013a07d8aee68deee70adf8a
./autogen.sh
./configure --enable-static
make
sudo make install
sudo ldconfig

# open lazarus
startlazarus

# now you can open and compile .lpi projects
