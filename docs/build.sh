#!/bin/bash

VERSION=`cat ../share/version.txt`

# Supported locales
LOCALES="ar ca da de el en es fa fr ga it is ja nb_NO nl pl pt_BR pt_PT ro ru sr@latin sv te tr uk zh_CN zh_TW"

# Generate English .po files
make gettext
rm -rf gettext > /dev/null
cp -r build/gettext gettext

# Update all .po files for all locales
for LOCALE in $LOCALES; do
    sphinx-intl update -p build/gettext -l $LOCALE
done

# Build all locales
rm -rf build/html build/docs > /dev/null
mkdir -p build/docs/$VERSION

make html
mv build/html build/docs/$VERSION/en

for LOCALE in $LOCALES; do
    make -e SPHINXOPTS="-D language='$LOCALE'" html
    mv build/html build/docs/$VERSION/$LOCALE
done

# Redirect to English by default
echo '<html><head><meta http-equiv="refresh" content="0; url=en/" /><script>document.location="en/"</script></head></html>' > build/docs/$VERSION/index.html

# Redirect to latest version
echo '<html><head><meta http-equiv="refresh" content="0; url='$VERSION'/en/" /><script>document.location="'$VERSION'/en/"</script></head></html>' > build/docs/index.html
