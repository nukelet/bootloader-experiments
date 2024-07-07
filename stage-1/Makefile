all: stage0.o stage1.o boot.bin

boot.bin:

stage0.o:
	nasm stage0.asm -f bin -o stage0.o

stage1.o:
	nasm stage1.asm -f bin -o stage1.o
