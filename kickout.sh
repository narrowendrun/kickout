#!/bin/bash
function getOutput() {
    local command="$1"
    FastCli << EOF
    enable
    $command
EOF
}
function kickOut() {
    # empty arrays for locations and vtys
    locations=()
    vtys=()
    while read -r line; do
        # Skip the header line
        if [[ "$line" == " Line      User        Host(s)       Idle        Location" ]]; then
            continue
        fi
        # Skip lcurrent session
        if [[ "$line" == \** ]]; then
            continue
        fi
        # Extract vty and location values using awk
        vty=$(echo "$line" | awk '{print $3}')
        location=$(echo "$line" | awk '{print $7}')
        # Append values to arrays if they are not empty
        if [[ -n "$vty" && -n "$location" ]]; then
            vtys+=("$vty")
            locations+=("$location")
        fi
    done < .kickout.txt
    for i in "${!locations[@]}"; do
        if [[ "${locations[i]}" != "$current_ip" ]]; then
            echo -n "ROGUE vty: ${vtys[i]}"
            echo "  |  ip: ${locations[i]}"
            getOutput "clear line vty ${vtys[i]}"
            echo "$(date)   kicked out ${locations[i]}" >> kickout.log
        fi
    done
}
getOutput "show users" > .kickout.txt
current_ip=$(< .kickout.txt grep '^\*' | awk '{print $8}')
echo "your ip address : ${current_ip}"
echo "$(date)   user with role ${USER} and ip ${current_ip} has initiated kickout" >> kickout.log
kickOut

