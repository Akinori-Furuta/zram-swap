# Makefile do simply install or uninstall zram-swap

ZRAM_SWAP_UNIT?=zram-swap
RUN_TIME_STAMP:=$(shell /bin/date +%y%m%d%H%M%S )

TEST_EXPR=/bin/test
ECHO=/bin/echo
INSTALL=/bin/install
RM=/bin/rm
MV=/bin/mv
SYSYEMCTL=/bin/systemctl

INITD_ZRAM_SWAP_EXIST:=$(shell   /bin/ls "/etc/init.d/$(ZRAM_SWAP_UNIT)" 2>/dev/null )
DEFAULT_ZRAM_SWAP_EXIST:=$(shell /bin/ls "/etc/default/$(ZRAM_SWAP_UNIT)" 2>/dev/null )

.PHONY: install uninstall

install: zram-swap default-zram-swap
	-$(SYSYEMCTL) daemon-reload
	-$(SYSYEMCTL) stop "$(ZRAM_SWAP_UNIT)"
	-$(SYSYEMCTL) disable "$(ZRAM_SWAP_UNIT)"
	$(INSTALL) -o root -g root -m 744 zram-swap "/etc/init.d/$(ZRAM_SWAP_UNIT)"
ifeq "$(DEFAULT_ZRAM_SWAP_EXIST)" ""
	$(INSTALL) \
	  -o root -g root -m 744 \
	  -T \
	  default-zram-swap "/etc/default/$(ZRAM_SWAP_UNIT)"
else
	$(INSTALL) \
	  -o root -g root -m 744 \
	  -T \
	  default-zram-swap "/etc/default/$(ZRAM_SWAP_UNIT).new"
endif
	$(SYSYEMCTL) daemon-reload
	$(SYSYEMCTL) enable "$(ZRAM_SWAP_UNIT)"
	@$(ECHO) "Installed the unit \"$(ZRAM_SWAP_UNIT)\"."
	@$(ECHO) "Now, the unit \"$(ZRAM_SWAP_UNIT)\" is not started."
	@$(ECHO) "To start this unit at now,"
	@$(ECHO) "  sudo $(SYSYEMCTL) start \"$(ZRAM_SWAP_UNIT)\""

uninstall:
	-$(SYSYEMCTL) stop "$(ZRAM_SWAP_UNIT)"
	-$(SYSYEMCTL) disable "$(ZRAM_SWAP_UNIT)"
ifneq "$(INITD_ZRAM_SWAP_EXIST)" ""
	-$(RM) -f "/etc/init.d/$(ZRAM_SWAP_UNIT)"
endif
	-$(RM) -r -f "/var/run/$(ZRAM_SWAP_UNIT)"
ifneq "$(DEFAULT_ZRAM_SWAP_EXIST)" ""
	$(MV) "/etc/default/$(ZRAM_SWAP_UNIT)" \
	      "/etc/default/$(ZRAM_SWAP_UNIT).$(RUN_TIME_STAMP)"
endif
	-$(SYSYEMCTL) daemon-reload
