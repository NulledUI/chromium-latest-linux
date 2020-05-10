#! /bin/bash

cd $(dirname $0)

LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"

REVISION=$(curl -s -S $LASTCHANGE_URL)

echo "latest revision is $REVISION"

if [ -d $REVISION ] ; then
  echo "already have latest version"
  exit
fi

CHROME_DIR=$(dirname $0)
prune() {
    #/usr/bin/find "$CHROME_DIR" -type d -cmin +1440 -exec rm -rf {} \;
    /usr/bin/find "$CHROME_DIR" -maxdepth 1 -type d -cmin +60 -exec rm -Rf {} \;
}

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"

ZIP_FILE="${REVISION}-chrome-linux.zip"

echo "fetching $ZIP_URL"

rm -rf $REVISION
mkdir $REVISION
pushd $REVISION
curl -s $ZIP_URL > $ZIP_FILE
#curl -# $ZIP_URL > $ZIP_FILE
echo "unzipping.."
unzip -qq $ZIP_FILE
#unzip $ZIP_FILE
popd
unlink ./latest
#rm -f ./latest
ln -s $REVISION/chrome-linux/ ./latest
prune
