# zram-swap - Raspberry Pi OS swap space on zram block device

## Introduction

The zram-swap places swap space on the zram block device.
Provides swap space and compress it, stores on to main memory.
It works on Raspberry Pi OS.

The zram-swap is System-V init script. It can "start", "stop",
and "restart" as follows,

* start
  * Probes (installs) the kernel zram module
    * If needed
  * Hot adds a zram device
    * Optional
    * You can also specify fixed numbered zram space,
      e.g. /dev/zram0
  * Configures zram device
    * Compression algorithm
    * Size before compress
  * Creates swap space on zram device
    * mkswap
  * Attaches swap space on zram device
    * swapon
      * Set priority
* stop
  * detaches swap space
    * swapoff
  * Hot removes
    * When hot added a zram device
  * Removes (uninstalls) the kernel zram module
    * When zram-swap installs the kernel zram module
* restart
  * stop, then start

To show statistics about zram and swap space, use "zramctl",
and "swapon", they are already installed on Raspberry Pi.

* zramctl
  * Show compression statistics.
* swapon -v
  * Show swap space usage.

## Files

The zram-swap installs and creates following files.

|path|description|
|----|-----------|
|/etc/init.d/zram-swap|System V init script.|
|/etc/default/zram-swap|Configuration file.|
|/etc/default/zram-swap.new|Configuration file newly installed.|
|/etc/default/zram-swap._time_stamp_|Configuration backup file.|
|/var/run/zram-swap/state|Runtime state file.|

## Install

To install the zram-swap, run make as follows,

```bash
# copy files.
sudo make install
# Note: To start service at now, run following command.
#  sudo systemctl start zram-swap
```

If there is an /etc/default/zram-swap configuration file,
"make install" doesn't overwrite it, install new example
configuration file /etc/default/zram-swap.new.

Just after installing the zram-swap. The zram-swap is
not started. To start the zram-swap at now, run following
command.

```bash
sudo systemctl start zram-swap
```

## Uninstall

To uninstall the zram-swap, run make as follows,

```bash
# stop service and remove file,
# Note: Leave configuration file in /etc/default directory.
sudo make uninstall
```

In /etc/default directory, the zram-swap configuration file
will be renamed with time-stamp suffix. You want to remove
completely, remove /etc/zram-swap.* files.

## Settings

See comments in /etc/default/zram-swap or
[default-zram-swap](./default-zram-swap).