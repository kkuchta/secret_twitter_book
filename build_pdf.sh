# !/bin/bash
BOOK_FILE=$1
BOOK_CODE=$(echo "$BOOK_FILE" | grep -o '\d\d_\d\d')
echo "--- Building book ${BOOK_FILE}, code= ${BOOK_CODE} --- "
ulimit -n 65536  && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
--headless \
--print-to-pdf=./out/book_${BOOK_CODE}.pdf \
--print-to-pdf-no-header \
--use-fake-ui-for-media-stream \
--disable-client-side-phishing-detection \
--disable-component-extensions-with-background-pages \
--disable-default-apps \
--disable-dev-shm-usage \
--disable-extensions \
--no-first-run \
--enable-automation \
--mute-audio \
--no-default-browser-check \
--allow-running-insecure-content \
--autoplay-policy=user-gesture-required \
$BOOK_FILE 2>&1 
# ./out/book_${BOOK_NUMBER}.html 2>&1 

# --enable-logging=stderr \
# --v=3 \
# --log-best-effort-tasks \
# --log-gpu-control-list-decisions \
# --log-interface-calls-to=interface_calls.json \
# --log-net-log=netlog.json \
# --log-level=0 \

# --disable-features=ImprovedCookieControls,LazyFrameLoading,GlobalMediaControls,DestroyProfileOnBrowserClose,MediaRouter,AcceptCHFrame,AutoExpandDetailsElement,CertificateTransparencyComponentUpdater \
# --disable-background-networking \
# --enable-features=NetworkService,NetworkServiceInProcess \
# --disable-background-timer-throttling \
# --disable-backgrounding-occluded-windows \
# --disable-breakpad \
# --allow-pre-commit-input \
# --disable-hang-monitor \
# --disable-ipc-flooding-protection \
# --disable-popup-blocking \
# --disable-prompt-on-repost \
# --disable-renderer-backgrounding \
# --disable-sync \
# --force-color-profile=srgb \
# --metrics-recording-only \
# --password-store=basic \
# --use-mock-keychain \
# --no-service-autorun \