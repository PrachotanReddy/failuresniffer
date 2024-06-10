block_parser(){
    local dev_block="$1"
    local info=()
    while IFS= read -r line; do
        local k="${line%%:*}"
        local v="${line#*:}"
        info["$k"]="${v}"
    done <<< "$dev_block"
    declare -p info
}

log_parser(){
    local log_file="$1"
    local problem_devices=()
    local dev_block=""
    echo "Problem found with devices:"
    while IFS= read -r line; do
        if [[ "$line" == "Instance ID"* ]]; then
            dev_block="$line"
        elif [[ "$line" ]]; then
            if [[ "$line" == *":"* ]]; then
                dev_block+="$line"
            fi
        elif [[ "$dev_block" ]]; then
            eval "$(block_parser "$dev_block")"
            if [[ "${info[Status]}" == "Problem" ]]; then
                problem_devices+=("${info[@]}")
            fi
            dev_block=""
        fi
    done < "$log_file"
    printf "%-55s%-10s%-10s%-20s%-20s%-20s\\n" "Instance ID" "Class Name" "Class GUID" "Device Description" "Problem Code" "Problem Status"
    printf "%s\\n" "----------------------------------------------------------------------------------------------------------------------------"
    for dev in "${problem_devices[@]}"; do
        printf "%-55s%-10s%-10s%-20s%-20s%-20s\\n" "${dev[Instance ID]}" "${dev[Class Name]}" "${dev[Class GUID]}" \
            "${dev[Device Description]}" "${dev[Problem Code]}" "${dev[Problem Status]}"
    done
}

log_parser "$1"