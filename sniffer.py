import sys
import re
import subprocess
from prettytable import PrettyTable

def block_parser(dev_block):
    info={}
    for l in dev_block.splitlines():
        k,v=l.split(":",1)
        info[k.strip()]=v.strip()
    return info

def pnp_parser():
    problem_devices=[]
    log_file=sys.argv[2]
    with open(log_file,"r") as f:
        dev_block=""
        for l in f:
            if "Instance ID" in l.strip():
                dev_block="Instance ID: "+l.split("Instance ID:",1)[1]
            elif dev_block and l.strip():
                if ":" in l.strip():
                    dev_block+=l
            elif dev_block:
                dev_info=block_parser(dev_block)
                if dev_info.get("Status","")=="Problem":
                    problem_devices.append(dev_info)
                dev_block=""
    print(f"Problem found with {len(problem_devices)} instances:\n")
    print("{:<55}{:<10}{:<10}{:<20}{:<20}{:<20}".format("Instance ID","Class Name","Class GUID","Device Description","Problem Code","Problem Status"))
    print("-"*140)

    for dev in problem_devices:
        print("{:<55}{:<10}{:<10}{:<20}{:<20}{:<20}".format(dev["Instance ID"],dev["Class Name"],dev["Class GUID"],dev["Device Description"],dev["Problem Code"],dev["Problem Status"]))

def dmesg_parser():
    keywords='"error|fail|fault|firmware|driver|hw|hardware"'
    if len(sys.argv)==3:
        log_file=sys.argv[2]
        out=subprocess.run(["grep","-iE",keywords,log_file], capture_output=True, check=True)
    else:
        out=subprocess.run(["sh","-c",'dmesg | grep -iE "error|fail|fault|firmware|driver|hw|hardware"'], capture_output=True, check=True,text=True)
        l=out.stdout.splitlines()
    if l:
        print("Filtered dmesg results:")
        table=PrettyTable()
        table.field_names=["Timestamp","Component","Message"]
        
if __name__=="__main__":
    if sys.argv[1]=="win":
        pnp_parser()
    elif sys.argv[1]=="lin":
        dmesg_parser()