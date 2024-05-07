#!/bin/bash

read -p "Enter the printer name: " printer_name
read -p "Enter the printer location: " printer_location
read -p "Enter the printer URL (e.g., ipp://printer_ip): " printer_url

# Function to check if the printer is in the list
function is_printer_in_list {
    lpstat -p 2>/dev/null | grep -q $printer_ip
    return $?
}

# Function to add the printer
function add_printer {
    lpadmin -p $printer_name -L $printer_location -E -v $printer_url -m everywhere
}

# Check if printer is in the list
if is_printer_in_list; then
    # Remove the printer
    lpadmin -x $printer_name
    sleep 10
    # Check if removal was successful
    if is_printer_in_list; then
        echo "There was an issue while removing the existing printer"
    else
        # Add the printer
        add_printer
        sleep 10
        # Check if addition was successful
        if is_printer_in_list; then
            echo "Printer successfully added"
        else
            echo "There was a problem adding the printer"
            exit 1
        fi
    fi
else
    # Add the printer
    add_printer
    sleep 10
    # Check if addition was successful
    if is_printer_in_list; then
        echo "Printer successfully added"
    else
        echo "There was a problem adding the printer"
    fi
fi
