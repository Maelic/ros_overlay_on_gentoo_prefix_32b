wget https://sourceforge.net/projects/pyqt/files/sip/sip-4.19.13/sip-4.19.13.tar.gz
wget https://sourceforge.net/projects/pyqt/files/PyQt5/PyQt-5.11.3/PyQt5_gpl-5.11.3.tar.gz
# install SIP first
tar -xzf sip-4.19.13.tar.gz && rm sip-4.19.13.tar.gz
cd sip-4.19.13
python3.8 ./configure.py
make -j8
make install
# install pyqt
tar -xzf PyQt5_gpl-5.11.3.tar.gz && rm PyQt5_gpl-5.11.3.tar.gz
cd PyQt5_gpl-5.11.3
python3.8 ./configure.py --sip ./gentoo/usr/lib/python3.8/site-packages/sip  # <-- This has to point to your sip install location
make -j8
make install