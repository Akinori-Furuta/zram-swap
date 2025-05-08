# Makefile do simply install or uninstall zram-swap

ZRAM_SWAP_UNIT?=zram-swap
RUN_TIME_STAMP:=$(shell /bin/date +%y%m%d%H%M%S )

TEST_EXPR=/bin/test
ECHO=/bin/echo
INSTALL=/bin/install
RM=/bin/rm
MV=/bin/mv
SYSYEMCTL=/bin/systemctl

.PHONY: install uninstall

install: zram-swap default-zram-swap
	-$(SYSYEMCTL) daemon-reload
	-$(SYSYEMCTL) stop "$(ZRAM_SWAP_UNIT)"
	-$(SYSYEMCTL) disable "$(ZRAM_SWAP_UNIT)"
	$(INSTALL) -o root -g root -m 744 zram-swap "/etc/init.d/$(ZRAM_SWAP_UNIT)"
	-$(TEST_EXPR) ! -f "/etc/default/$(ZRAM_SWAP_UNIT)" && \
		$(INSTALL) \
		  -b numbered \
		  -s $(RUN_TIME_STAMP) \
		  -o root -g root -m 744 \
		  default-zram-swap "/etc/default/$(ZRAM_SWAP_UNIT)"
	$(SYSYEMCTL) daemon-reload
	$(SYSYEMCTL) enable "$(ZRAM_SWAP_UNIT)"
	@$(ECHO) "Installed the unit \"$(ZRAM_SWAP_UNIT)\"."
	@$(ECHO) "Now, the unit \"$(ZRAM_SWAP_UNIT)\" is not started."
	@$(ECHO) "To start this unit at now,"
	@$(ECHO) "  sudo $(SYSYEMCTL) start \"$(ZRAM_SWAP_UNIT)\""

uninstall:
	-$(SYSYEMCTL) stop "$(ZRAM_SWAP_UNIT)"
	-$(SYSYEMCTL) disable "$(ZRAM_SWAP_UNIT)"
	-$(RM) "/etc/init.d/$(ZRAM_SWAP_UNIT)"
	-$(RM) -r -f "/var/run/$(ZRAM_SWAP_UNIT)"
	$(TEST_EXPR) -f "/etc/default/$(ZRAM_SWAP_UNIT)" && \
		$(MV) "/etc/default/$(ZRAM_SWAP_UNIT)" \
		      "/etc/default/$(ZRAM_SWAP_UNIT).$(RUN_TIME_STAMP)"
	-$(SYSYEMCTL) daemon-reload
