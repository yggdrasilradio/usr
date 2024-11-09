all: usr

usr: usr.bas
	lwasm -9 -f basic -o /tmp/data.bas usr.asm
	fgrep DATA /tmp/data.bas | sed -e 's/,-1,-1//' -e 's/^[^ ]*//' > usr.dat
	rm -f /tmp/data.bas
	decbpp < usr.bas | tee USR.BAS
	rm -r usr.dat
	decb copy -tr USR.BAS /media/share1/COCO/drive3.dsk,USR.BAS
