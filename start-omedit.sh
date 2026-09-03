#!/usr/bin/env bash
set -e

export DISPLAY=:0
: "${RES:=1600x1000x24}"

rm -f /tmp/.X0-lock

Xvfb :0 -screen 0 "$RES" +extension GLX +extension RANDR +render -noreset \
     >/tmp/xvfb.log 2>&1 &

for _ in $(seq 1 60); do xdpyinfo >/dev/null 2>&1 && break; sleep 0.25; done

x11vnc -display :0 -forever -shared -nopw -rfbport 5900 -noxdamage -quiet \
       >/tmp/x11vnc.log 2>&1 &

if command -v websockify >/dev/null 2>&1; then
    websockify --web=/usr/share/novnc 6080 localhost:5900 >/tmp/novnc.log 2>&1 &
else
    /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 \
        >/tmp/novnc.log 2>&1 &
fi

echo "  Открыть в браузере:"
echo "      http://localhost:6080/vnc.html?autoconnect=1&resize=scale"

if [ "$#" -gt 0 ]; then
    "$@" >/tmp/omedit.log 2>&1 &
else
    OMEdit >/tmp/omedit.log 2>&1 &
fi

exec fluxbox >/tmp/fluxbox.log 2>&1
