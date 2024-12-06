# This is free and unencumbered software released into the public domain.

curl https://github.com/CISOfy/lynis/archive/refs/tags/3.1.2.tar.gz -LO

gunzip 3.1.2.tar.gz

tar -xvf 3.1.2.tar

cd lynis-3.1.2 || exit

./lynis audit system
