buildOPath="build/o"

if [ -e "$buildOPath" ]
then
    rm "$buildOPath" -r
fi

mkdir -p build
mkdir -p build/o
mkdir -p build/o/utils
mkdir -p build/bin

as src/main.s -o build/o/main.o
as src/utils/print.s -o build/o/utils/print.o
as src/utils/time.s -o build/o/utils/time.o

ld build/o/main.o build/o/utils/print.o build/o/utils/time.o -o build/bin/3dterminal
./build/bin/3dterminal
