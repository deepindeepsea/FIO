from base64 import decode
import subprocess as sp
import sys


class FIO_PreCheck:
    def __init__(self, drive_count, bios) -> None:
        self.check_bios_version(bios)
        self.check_drives_at_all_levels(drive_count)
                
    def check_drives_at_all_levels(self, drive_count):
        i = sp.check_output("lspci | grep -i nvme | awk '{print $1}'", shell=True).decode().splitlines()
        if len(i) - 1 != drive_count:
            raise Exception("Drive count is mismatched in lspci")
        
        j = sp.check_output("nvme list-subsys | grep live | awk '{print $2 $4}'", shell=True).decode().splitlines()
        if len(j) - 1 != drive_count:
            raise Exception("Drive count is mismatched in nvme")
        
        k = sp.check_output('lstopo-no-graphics | grep nvme', shell=True).decode().splitlines()
        if len(k) - 1 != drive_count:
            raise Exception("Drive count is mismatched in lspci")
        
        print("No mismatch in drive count")
    
    def check_bios_version(self, bios):
        i = sp.check_output("dmidecode -t 0 | grep Version | awk '{print $2}'", shell=True).decode()
        if bios not in i:
            raise Exception("BIOS in the system is not latest or same as one given in variables")
        print("BIOS version is good")
        
    
if __name__ == "__main__":
    args = sys.argv
    obj = FIO_PreCheck(int(args[1]), args[2])
    

