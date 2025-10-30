apk add alpine-sdk
apk add linux-headers
wget -O busybox.tar.gz https://github.com/mirror/busybox/archive/refs/tags/1_36_1.tar.gz
tar -xvzf busybox.tar.gz
cd busybox-1_36_1
make defconfig
sed -i 's/^CONFIG_BASH_IS_NONE=y$/# CONFIG_BASH_IS_NONE is not set/' .config
sed -i 's/^CONFIG_FEATURE_TC_INGRESS=y/# CONFIG_FEATURE_TC_INGRESS is not set/' .config
sed -i 's/^CONFIG_TC=y$/# CONFIG_TC is not set/' .config
sed -i 's/^# CONFIG_BASH_IS_ASH is not set.*$/CONFIG_BASH_IS_ASH=y/' .config
sed -i 's/^# CONFIG_STATIC is not set.*$/CONFIG_STATIC=y/' .config
make -j "$(nproc)"
# sed -i 's/^$//' .config
# sed -i 's/^$//' .config
# sed -i 's/^$//' .config
# sed -i 's/^$//' .config
# sed -i 's/^CONFIG_TC=y$/CONFIG_TC=n/' .config
# sed -i 's/^CONFIG_BASH_IS_NONE=y$/# CONFIG_BASH_IS_NONE=y/' .config
# echo "CONFIG_BASH_IS_ASH=y" >> .config
# echo "CONFIG_STATIC=y" >> .config
