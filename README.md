# ros_overlay_on_gentoo_prefix

This repository contains build tools and docker container to compile ROS Noetic on gentoo prefix 32b. To use this repository you need docker, follow the tutorials here [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

There is multiple ROS versions currently supported on this repo:

***ROS BASE*** Contains the ROS core packages, catkin and rosdep.


***ROS Desktop Simple*** This build is made for a lightweight usage of ROS, without GUI tools and simulator, contains perception and navigation packages.


***ROS Desktop*** This is the full desktop install, currently not building properly due to dependencies errors. Feel free to push a merge!


***ROS Desktop Full*** Not test yet so not supported.


To build your version go into the apporpriate folder and execute:
```buildoutcfg
docker build -f Dockerfile -t "ROS_version" .
```
For instance:
```buildoutcfg
docker build -f Dockerfile -t ROS_noetic_simple .
```

Then, to compress your build into an archive:
```buildoutcfg
docker run --rm --entrypoint /tmp/gentoo/executeonprefix "YOUR_IMAGE" "tar -c --lzma -f - -C /tmp gentoo" > ./gentoo_on_tmp.tar.lzma; ls -lah .
```
For instance:
```buildoutcfg
docker run --rm --entrypoint /tmp/gentoo/executeonprefix  ROS_noetic_simple:latest "tar -c --lzma -f - -C /tmp gentoo" > ./gentoo_on_tmp.tar.lzma; ls -lah .
```

## Some usefull resources

### Create a patch for a package (very usefull):

Run the docker image where you need to modify the build of a package and then follow:

[https://wiki.gentoo.org/wiki/Patches](https://wiki.gentoo.org/wiki/Patches)

### Gentoo official and non-official overlays

Very usefull to find a package that has been deleted from the official overlay.

[https://gpo.zugaina.org/](https://gpo.zugaina.org/)

