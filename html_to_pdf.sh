INFILE=$1
OUTFILE=$2
ulimit -n 65536  && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
--headless \
--print-to-pdf=${OUTFILE} \
--print-to-pdf-no-header \
--disable-client-side-phishing-detection \
--disable-component-extensions-with-background-pages \
--disable-default-apps \
--disable-dev-shm-usage \
--disable-extensions \
--enable-automation \
--mute-audio \
--no-default-browser-check \
--allow-running-insecure-content \
--autoplay-policy=user-gesture-required \
--no-first-run \
--use-fake-ui-for-media-stream \
$INFILE 2>&1 