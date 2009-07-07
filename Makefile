VERSION		:= 1.0-pre4

ETCDIR		:= /etc
EXTDIR		:= ${DESTDIR}${ETCDIR}
MODE		:= 754
DIRMODE		:= 755
CONFMODE	:= 644

all:
	@grep "^install" Makefile | cut -d ":" -f 1
	@echo dist
	@echo "Select an appropriate install target from the above list" ; exit 1

.PHONY: dist
dist:
	rm -rf "dist/bootscripts-clfs-embedded-$(VERSION)"
	mkdir -p "dist/bootscripts-clfs-embedded-$(VERSION)"
	tar --exclude dist -c * | tar -x -C "dist/bootscripts-clfs-embedded-$(VERSION)"
	(cd dist; tar -cjf "bootscripts-clfs-embedded-$(VERSION).tar.bz2" "bootscripts-clfs-embedded-$(VERSION)")
	rm -rf "dist/bootscripts-clfs-embedded-$(VERSION)"

create-dirs:
	install -d -m ${DIRMODE} ${EXTDIR}/rc.d/{init.d,start,stop}

install-bootscripts: create-dirs
	install -m ${CONFMODE} clfs/rc.d/init.d/functions ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} clfs/rc.d/startup         ${EXTDIR}/rc.d/
	install -m ${MODE} clfs/rc.d/shutdown        ${EXTDIR}/rc.d/
	install -m ${MODE} clfs/rc.d/init.d/network  ${EXTDIR}/rc.d/init.d/
	install -m ${MODE} clfs/rc.d/init.d/syslog   ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/syslog ${EXTDIR}/rc.d/start/S05syslog
	ln -sf ../init.d/syslog ${EXTDIR}/rc.d/stop/K99syslog
	ln -sf ../init.d/network ${EXTDIR}/rc.d/start/S10network
	ln -sf ../init.d/network ${EXTDIR}/rc.d/stop/K80network

install-dropbear: create-dirs
	install -m ${MODE} clfs/rc.d/init.d/sshd   ${EXTDIR}/rc.d/init.d/
	ln -sf ../init.d/sshd ${EXTDIR}/rc.d/start/S30sshd
	ln -sf ../init.d/sshd ${EXTDIR}/rc.d/stop/K30sshd

.PHONY: all create-dirs install install-dropbear
