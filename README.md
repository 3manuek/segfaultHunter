# segfaultHunter

Configure the .segfaultHunter.token with the Hipchat token taken from the integration page.

Run with sudo:

```
sudo ./segfaulthunter.sh
```

IMPORTANT:

The clean up of the log isn't working and I didn't find a clean way to release the lock imposed by strace to do so.

The idea will be to add a threshold on the file size, stop strace and re-run it.


The segfault logs will be labeled as *SEGFAULT* in the file name. Here is an example of the 
files created:

```
total 136K
drwxr-xr-x 2 emanuel emanuel 4,0K Nov 17 23:28 .
drwxr-xr-x 32 emanuel emanuel 4,0K Nov 17 23:28 ..
-rw-r--r-- 1 root root 48 Nov 17 23:28 .segfaultHunter.hash
-rw-r--r-- 1 root root 0 Nov 17 23:27 segfaultHunter.lock
-rw-r--r-- 1 root root 37K Nov 17 22:59 segfaultHunter.log1447811981
-rw-r--r-- 1 emanuel emanuel 7,7K Nov 17 23:00 segfaultHunter.log1447812077.gz
-rw-r--r-- 1 emanuel emanuel 49 Nov 17 23:01 segfaultHunter.log1447812083.gz
-rw-r--r-- 1 root root 5,2K Nov 17 23:02 segfaultHunter.log1447812422.gz
-rw-r--r-- 1 root root 1,1K Nov 17 23:08 segfaultHunter.log1447812603.gz
-rw-r--r-- 1 root root 5,0K Nov 17 23:11 segfaultHunter.log1447812940.gz
-rw-r--r-- 1 root root 965 Nov 17 23:20 segfaultHunter.log1447813249.gz
-rw-r--r-- 1 root root 11K Nov 17 23:22 segfaultHunter.log1447813355.gz
-rw-r--r-- 1 root root 3,4K Nov 17 23:25 segfaultHunter.log1447813630.gz
-rw-r--r-- 1 root root 14K Nov 17 23:28 segfaultHunter.log-SEGFAULT-1447813630.gz
-rwxr-xr-x 1 emanuel emanuel 1,8K Nov 17 23:27 segfaultHunter.sh
-rw-r--r-- 1 emanuel emanuel 49 Nov 17 22:37 .segfaultHunter.token
-rwxr-xr-x 1 emanuel emanuel 383 Nov 17 19:54 sendHipchat.sh
-rw-r--r-- 1 root root 384 Nov 17 23:28 .tempMessages
```

