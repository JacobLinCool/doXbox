FROM ubuntu:22.04 AS builder

RUN apt update && \
    apt install -y ccache build-essential libasound2-dev libatomic1 libpng-dev \
    libsdl2-dev libsdl2-net-dev libopusfile-dev \
    libfluidsynth-dev libslirp-dev libspeexdsp-dev libxi-dev \
    git build-essential meson

RUN git clone https://github.com/dosbox-staging/dosbox-staging.git

WORKDIR /dosbox-staging

RUN git checkout main -f && git pull

RUN meson setup build/release && meson compile -C build/release

FROM ubuntu:22.04

RUN apt update && \
    apt install -y libgl1-mesa-dri libgl1-mesa-glx libsdl2-2.0-0 libsdl2-net-2.0-0 libopusfile0 libslirp0 libspeexdsp1 libfluidsynth3

COPY --from=builder /dosbox-staging/build/release/dosbox /usr/bin/dosbox
COPY --from=builder /dosbox-staging/build/release/resources /usr/resources

ENV SDL_VIDEO_X11_VISUALID=
ENV LIBGL_ALWAYS_INDIRECT=1
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

ENTRYPOINT ["dosbox"]
