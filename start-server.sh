# tip: /home/kr/bin/dart-sdk/bin/pub build --mode=release --output=build

if [ -d build ] ; then
	cd build
	python3 -m http.server
else
	echo "build was not found!!!"
fi
