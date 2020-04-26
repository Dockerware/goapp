# Go App

Build App on Go in Docker

## Usage

**Build apk**

```shell script
docker run --rm -v $PWD:/app -it \
docker.pkg.github.com/dockerware/goapp/go-ndk:1.14.2-21.1.6352462 \
gomobile build -v -target=android golang.org/x/mobile/example/basic
```

**Platform tools**

```shell script
docker run --rm -v $PWD:/app -it \
--privileged  \
-v /dev/bus/usb:/dev/bus/usb \
docker.pkg.github.com/dockerware/goapp/go-ndk:1.14.2-21.1.6352462 \
adb install -r basic.apk
```
