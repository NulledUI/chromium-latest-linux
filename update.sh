#!/usr/bin/env sh

command -v unzip >/dev/null 2>&1 || { printf "Error: you need to install \"unzip\" first!\n"; exit 1; }

cd $(dirname $0)

case $(uname -m) in
"x86_64")
  ARCH="Linux_x64"
  ;;
"amd64")
  ARCH="Linux_x64"
  ;;
arm*)
  ARCH="Arm"
  ;;
*)
  ARCH="Linux"
  ;;
esac

BASE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/$ARCH"

LASTCHANGE_URL="$BASE_URL%2FLAST_CHANGE?alt=media"

if [ -z "$1" ]; then
  REVISION=$(curl -s -S $LASTCHANGE_URL)
  printf "Latest revision is $REVISION\n"
else
  REVISION=$1
  printf "Using given revision $REVISION as latest revision\n"
fi

if [ -d $REVISION ] ; then
  printf "You already have the latest version\n"
  exit 0
fi

CHROME_DIR=$(dirname $0)
prune() {
    /usr/bin/find "$CHROME_DIR" -maxdepth 1 -type d -cmin +60 -exec rm -Rf {} \;
}

ZIP_URL="$BASE_URL%2F$REVISION%2Fchrome-linux.zip?alt=media"

ZIP_FILE="${REVISION}-chrome-linux.zip"

printf "Fetching $ZIP_URL\n"

rm -rf $REVISION
mkdir $REVISION
cd $REVISION
curl -# $ZIP_URL > $ZIP_FILE
printf "Unzipping...\n"
unzip -q $ZIP_FILE
[ $? -ne 0 ] && { printf "Error: not a valid zip file\n" ; exit 1; }
cd ..
unlink ./latest
ln -fsT $REVISION/chrome-linux/ ./latest
prune
printf "Changing owner and permissions for chrome_sandbox (requires privileges):\n"
sudo chown root:root ./latest/chrome_sandbox
sudo chmod 4755 ./latest/chrome_sandbox
printf "Script completed successfully\n"
