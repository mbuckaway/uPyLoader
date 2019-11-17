#!/bin/bash
#SIGNINGCERT="Mac Developer: MARK BUCKAWAY (8JR73M9YJC)"
version=$(python3 Version.py)
AppVerName="uPyLoader $version"
echo "New version is ${AppVerName}"
echo "Cleaning up..."
rm -f $(find . -name "*.pyc")
rm -rf dist build
rm -f *.dmg
echo "Compiling...."
python3 -mcompileall .
echo "Building Mac App..."
cp main.py uPyLoader.py
pyinstaller uPyLoader.py --icon=icons/main.icns --clean --windowed --noconfirm -d all --exclude-module=tcl --exclude-module=tk --exclude-module=Tkinter --exclude-module=_tkinter --osx-bundle-identifier=ca.buckaway.uPyLoader
echo "Copy the Resource files..."
cp -rv icons dist/uPyLoader.app/Contents/Resources/
cp -rv images dist/uPyLoader.app/Contents/Resources/
cp -rv mcu dist/uPyLoader.app/Contents/Resources/
exit
if [ -n "${SIGNINGCERT}" ]
then
	echo "Signing code..."
	pushd .
	cd dist/uPyLoader.app/Contents/MacOS
	for file in *.dylib *.so
	do
		echo "Signing: ${file}"
		codesign -s "${SIGNINGCERT}" $file
	done
	popd
	echo "Signing the entire app..."
	codesign -s "${SIGNINGCERT}" dist/uPyLoader.app
fi
echo "Building DMG image..."
dmgbuild -s dmgsetup.py "uPyLoader" uPyLoader.dmg
