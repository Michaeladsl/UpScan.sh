# UpScan.sh

Designed for quickly identifying active hosts within specified IP ranges. Utilizing nmap for efficient ping scanning, it parses a user-defined list of IP addresses or CIDR ranges from a file, tallying up and listing all responsive hosts. The result is a total count of active hosts and a file output (upscope.txt) detailing each up host.
```
./UpScan.sh path/to/your/scope_file.txt
```
