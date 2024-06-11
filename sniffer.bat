@echo off
setlocal EnableDelayedExpansion

rem Capture the output of pnputil /enum-devices
pnputil /enum-devices /problem > pnputil_output.txt

echo Instance ID ^| Device Description ^| Class Name ^| Class GUID ^| Manufacturer Name ^| Problem Code ^| Problem Status

rem Loop through the output file and extract the required information
for /f "tokens=1,2,3,4,5,6,7,8,9 delims=:" %%a in (pnputil_output.txt) do (
    if "%%a" == "Instance ID" (
        set "instance_id=%%b"
    ) else if "%%a" == "Device Description" (
        set "device_description=%%b"
    ) else if "%%a" == "Class Name" (
        set "class_name=%%b"
    ) else if "%%a" == "Class GUID" (
        set "class_guid=%%b"
    ) else if "%%a" == "Manufacturer Name" (
        set "manufacturer_name=%%b"
    ) else if "%%a" == "Status" (
        set "status=%%b"
        if "!status:~21!" == "Problem" (
        set "print_device=1"
        ) else (
        set "print_device=0"
        )
    ) else if "%%a" == "Problem Code" (
        set "problem_code=%%b"
    ) else if "%%a" == "Problem Status" (
        set "problem_status=%%b"
    ) else if "%%a" == "Driver Name" (
        set "driver_name=%%b"
        if "!print_device!" == "1" (
        echo !instance_id:~16! ^| !device_description:~9! ^| !class_name:~17! ^| !class_guid:~17! ^| !manufacturer_name:~10! ^| !status:~21! ^| !problem_code:~15! ^| !problem_status:~13! ^| !driver_name:~16!
    )
    rem Reset the variables
    set "instance_id="
    set "device_description="
    set "class_name="
    set "class_guid="
    set "manufacturer_name="
    set "status="
    set "problem_code="
    set "problem_status="
    set "driver_name="
    set "print_device=0"
    )
)

rem Clean up the temporary file
del pnputil_output.txt

endlocal