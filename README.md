# doXbox

DOSBox Staging runs as an X11 app in the Docker container.

## Usage

```bash
docker run --rm -d \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd):/c \
    jacoblincool/doxbox c
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
    jacoblincool/doxbox c
```

## DOSBox Configuration

You can bind the configuration file to `/root/.config/dosbox/dosbox-staging.conf` in the container.

## Accessing Program Memory

Add `CAP_SYS_PTRACE` capability to the container to access program memory at `/proc/1/mem`.
