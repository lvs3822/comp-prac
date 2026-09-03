FROM openmodelica/openmodelica:v1.27.0-gui

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        xvfb x11vnc fluxbox novnc websockify \
        libgl1-mesa-dri libglu1-mesa mesa-utils \
        x11-utils x11-apps xterm dbus-x11 \
        fonts-dejavu-core \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LIBGL_ALWAYS_SOFTWARE=1 \
    QT_X11_NO_MITSHM=1 \
    QTWEBENGINE_DISABLE_SANDBOX=1 \
    QTWEBENGINE_CHROMIUM_FLAGS="--no-sandbox --disable-gpu"

COPY start-omedit.sh /usr/local/bin/start-omedit.sh
RUN chmod +x /usr/local/bin/start-omedit.sh

EXPOSE 5900 6080
CMD ["/usr/local/bin/start-omedit.sh"]
