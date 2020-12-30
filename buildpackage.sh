
#!/bin/bash

name="pg_tailnmail"
version=$(grep Version $name/DEBIAN/control|awk '{print $2}')
arch=$(grep Architecture $name/DEBIAN/control|awk '{print $2}')
echo "Building package... $name version $version"
dpkg-deb --build $name $name\-$version\-$arch.deb
if [ $? -eq 0 ]; then
    echo "Successfully built package"
fi
#mkdir deb
#mv *.deb deb/
