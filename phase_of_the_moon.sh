#!/bin/bash
echo "POM - Phaeses Of the Moon"

# Check if the script can send an email
if command -v mail &> /dev/null; then
    echo "The mail command is available, so the script can send an email."

    # Get the current phase of the moon
    moon_phase=$(curl -s https://wttr.in/moon | awk 'NR==4{print $1}')
    
    # Send an email with the current phase of the moon
    echo "Current phase of the moon: $moon_phase" | mail -s "Hello World" user@example.com
else
    echo "The mail command is not available, so the script cannot send an email."
fi
