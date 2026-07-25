as main.s
gcc -o a a.out -nostdlib -static
./a

rm a
rm a.out