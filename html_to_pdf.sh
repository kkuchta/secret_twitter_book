INFILE=$1
OUTFILE=$2
ulimit -n 65536  && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
--headless \
--print-to-pdf=${OUTFILE} \
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
$INFILE 2>&1 