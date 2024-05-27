# doXbox

DOSBox Staging runs as an X11 app in the Docker container.

It’s used as a safe sandbox for running students’ programs that need to interact with the DOSBox program memory in the [NTNU CSIE Computer Programming course](https://sites.google.com/gapps.ntnu.edu.tw/neokent/teaching/2024spring-computer-programming-ii#h.sdhctjkjz4fd).

## Usage

```bash
docker run --rm -d \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd):/c \
    jacoblincool/doxbox
```

### macOS

Install XQuartz and allow connections from 127.0.0.1.

```bash
xhost + 127.0.0.1
```

`DISPLAY` should be `host.docker.internal:0` on macOS.

```bash
docker run --rm -d \
    -e DISPLAY=host.docker.internal:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd):/c \
    jacoblincool/doxbox
```

## Mounting Drives

The host directory that mounts to `/c` in the container will be the C: drive.

## DOSBox Configuration

You can bind the configuration file to `/root/.config/dosbox/dosbox-staging.conf` in the container.

## Accessing Program Memory

Add `CAP_SYS_PTRACE` capability to the container to access program memory at `/proc/1/mem`.
