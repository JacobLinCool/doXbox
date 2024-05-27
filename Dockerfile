FROM ubuntu:22.04 AS builder-base

ARG VERSION=v0.81.1

RUN apt update && \
    apt install -y ccache build-essential libasound2-dev libatomic1 libpng-dev \
    libsdl2-dev libsdl2-net-dev libopusfile-dev \
    libfluidsynth-dev libslirp-dev libspeexdsp-dev libxi-dev \
    libxcb-xinput-dev libxcb-xkb-dev \
    git build-essential meson

RUN apt install -y libxcb1-dev

RUN git clone https://github.com/dosbox-staging/dosbox-staging.git

WORKDIR /dosbox-staging

RUN git checkout $VERSION


FROM builder-base AS builder

RUN meson setup -Ddefault_library=static --wrap-mode=forcefallback -Db_lto=true build/release
RUN meson compile -C build/release


FROM ubuntu:22.04

RUN apt update && apt install -y libgl1 libsdl2-2.0-0 libsdl2-net-2.0-0 && rm -rf /var/lib/apt/lists/* && apt clean

RUN mkdir -p /c

COPY --from=builder /dosbox-staging/build/release/dosbox /usr/bin/dosbox
COPY --from=builder /dosbox-staging/build/release/resources /usr/resources

ENV SDL_VIDEO_X11_VISUALID=
ENV LIBGL_ALWAYS_INDIRECT=1
ENV XDG_RUNTIME_DIR=/tmp/runtime-root

ENTRYPOINT ["dosbox"]
CMD [ "/c" ]
