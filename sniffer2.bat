@echo off
setlocal EnableDelayedExpansion

rem Function to pad a string to a fixed length
set "pad=                                                                                                  "
set "format_length=30"

rem Function to trim spaces
for /f "tokens=* delims= " %%a in ('echo prompt $H ^| cmd') do set "BS=%%a"
set "spaces=                                                             "
set "format_length=30"

rem Check if an input file is specified
if "%~1"=="" (
    rem No input file specified, capture the output of pnputil /enum-devices
    pnputil /enum-devices /problem > pnputil_output.txt
    set "input_file=pnputil_output.txt"
) else (
    rem Use the specified input file
    set "input_file=%~1"
)

rem Function to format each field to a fixed length
call :format_column "Instance ID" 16
call :format_column "Device Description" 9
call :format_column "Class Name" 17
call :format_column "Class GUID" 17
call :format_column "Manufacturer Name" 10
call :format_column "Status" 21
call :format_column "Problem Code" 15
call :format_column "Problem Status" 13
call :format_column "Driver Name" 16

echo.

rem Loop through the output file and extract the required information
for /f "tokens=1,2,3,4,5,6,7,8,9 delims=:" %%a in (%input_file%) do (
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
    )

    if defined instance_id if defined device_description if defined class_name if defined class_guid if defined manufacturer_name if defined status if defined problem_code if defined problem_status (
        if "!print_device!" == "1" (
            call :format_column "!instance_id:~16!" 30
            call :format_column "!device_description:~9!" 30
            call :format_column "!class_name:~17!" 30
            call :format_column "!class_guid:~17!" 30
            call :format_column "!manufacturer_name:~10!" 30
            call :format_column "!status:~21!" 30
            call :format_column "!problem_code:~15!" 30
            call :format_column "!problem_status:~13!" 30
            call :format_column "!driver_name:~16!" 30
            echo.
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

rem Clean up the temporary file if no input file was specified
if "%~1"=="" (
    del pnputil_output.txt
)

endlocal
exit /b

:format_column
set "str=%~1%spaces%"
set "str=!str:~0,%~2!"
echo | set /p=!str!
exit /b
