ifndef PODIR
	PODIR=po/
endif

ifndef PRJID
	PRJID=mrim-prpl-underbush
endif

ifndef POPRJ
	POPRJ=${PODIR}${PRJID}
endif

ifndef LIBDIR
	LIBDIR=lib
endif

ifndef FULL_LIBDIR
	FULL_LIBDIR=usr/${LIBDIR}
endif

ifndef CC
	CC=gcc
endif

ifndef CFLAGS
	CFLAGS=-O0  -ggdb -g
endif

CFLAGS+=`pkg-config purple gtk+-2.0 --cflags` -fPIC -DPIC -std=c99
#CFLAGS+=-Wall -Wextra -Wconversion -Wsign-conversion -Winit-self -Wunreachable-code --pedantic  -Wstrict-aliasing
#CFLAGS+= -g -ggdb

LDFLAGS+=`pkg-config purple gtk+-2.0 --libs` -shared -ggdb -fPIC -DPIC

all: compile i18n
clean:
	rm -f *.so
	rm -f *.o
	rm -f ${PODIR}*.mo
install:
	install -Dm0755 libmrim-underbush.so  ${DESTDIR}/${FULL_LIBDIR}/purple-2/mrim-underbush.so
	#install -Dm0755 mrim.so  ${DESTDIR}/${FULL_LIBDIR}/purple-2/mrim.so
	install -Dm0644 pixmaps/mrim16.png  ${DESTDIR}/usr/share/pixmaps/pidgin/protocols/16/mrim.png
	install -Dm0644 pixmaps/mrim22.png  ${DESTDIR}/usr/share/pixmaps/pidgin/protocols/22/mrim.png
	install -Dm0644 pixmaps/mrim48.png  ${DESTDIR}/usr/share/pixmaps/pidgin/protocols/48/mrim.png
	install -Dm0644 ${POPRJ}-ru_RU.mo ${DESTDIR}/usr/share/locale/ru/LC_MESSAGES/${PRJID}.mo
	install -Dm0644 ${POPRJ}-ru_RU.mo ${DESTDIR}/usr/share/locale/ru_RU/LC_MESSAGES/${PRJID}.mo
uninstall:
	rm -f ${DESTDIR}/${FULL_LIBDIR}/purple-2/libmrim-underbush.so
	rm -f ${DESTDIR}/${FULL_LIBDIR}/purple-2/mrim.so
	rm -f ${DESTDIR}/${FULL_LIBDIR}/purple-2/mrim-underbush.so
	rm -f ${DESTDIR}/${FULL_LIBDIR}/purple-2/libmrim.so
	rm -fv ${DESTDIR}/usr/share/pixmaps/pidgin/protocols/16/mrim.png
	rm -fv ${DESTDIR}/usr/share/pixmaps/pidgin/protocols/22/mrim.png
	rm -fv ${DESTDIR}/usr/share/pixmaps/pidgin/protocols/48/mrim.png
	rm -fv ${DESTDIR}/usr/share/locale/ru/LC_MESSAGES/${PRJID}.mo
	rm -fv ${DESTDIR}/usr/share/locale/ru_RU/LC_MESSAGES/${PRJID}.mo
compile: mrim.o package.o statuses.o cl.o message.o mrim-util.o ft.o
	${CC} ${LDFLAGS} -o libmrim-underbush.so mrim.o package.o statuses.o cl.o message.o mrim-util.o ft.o
mrim.o: mrim.c mrim.h statuses.h cl.h message.h package.h config.h ft.h
	${CC} -c ${CFLAGS} -o mrim.o mrim.c
package.o: package.c mrim.h statuses.h cl.h message.h package.h config.h
	${CC} -c ${CFLAGS} -fPIC -DPIC -o package.o package.c
statuses.o: statuses.c mrim.h statuses.h cl.h message.h package.h config.h
	${CC} -c ${CFLAGS} -fPIC -DPIC -o statuses.o statuses.c
cl.o: cl.c mrim.h statuses.h cl.h message.h package.h config.h
	${CC} -c ${CFLAGS} -fPIC -DPIC -o cl.o cl.c
ft.o: ft.c ft.h mrim.h package.h cl.h config.h
	${CC} -c ${CFLAGS} -fPIC -DPIC -o ft.o ft.c
message.o: message.c mrim.h statuses.h cl.h message.h package.h config.h
	${CC} -c ${CFLAGS} -fPIC -DPIC -o message.o message.c
mrim-util.o: mrim-util.c mrim-util.h mrim.h config.h
	${CC} -c ${CFLAGS} -fPIC -DPIC -o mrim-util.o mrim-util.c
i18n:
	msgfmt ${POPRJ}-ru_RU.po --output-file=${POPRJ}-ru_RU.mo
