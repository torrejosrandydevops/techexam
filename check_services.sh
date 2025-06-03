#!/bin/bash

# Function to print a separator line
print_separator() {
    echo "------------------------------------"
}

# Function to print the header
print_header() {
    echo "Service Pre-Deployment Check Report:"
    echo "===================================="
}

# Function to print the footer
print_footer() {
    echo "===================================="
}

# Function to extract service name from path
get_service_name() {
    local service_path="$1"
    basename "$service_path"
}

# Function to get version from version.txt or package.json
get_version() {
    local service_dir="$1"
    
    # Check for version.txt
    if [ -f "$service_dir/version.txt" ]; then
        tr -d '\r' < "$service_dir/version.txt"
        return 0
    fi
    
    # Check for package.json
    if [ -f "$service_dir/package.json" ]; then
        if command -v jq >/dev/null 2>&1; then
            if version=$(jq -r '.version // "unknown"' "$service_dir/package.json" 2>/dev/null); then
                echo "$version"
                return 0
            fi
        else
            echo "unknown (jq not installed)"
            return 1
        fi
    fi
    
    echo "unknown"
}

# Function to check artifact availability
check_artifact() {
    local service_name="$1"
    local version="$2"
    
    if [[ "$version" == "unknown"* ]]; then
        echo "n/a"
        return 0
    fi
    
    # Mock API call - in real scenario, uncomment the curl command
    # response=$(curl -s "https://api.mockrepo.com/check-artifact/$service_name/$version")
    
    # For demonstration, we'll simulate responses based on service name
    case "$service_name" in
        "user-service")
            response='{"status": "available"}'
            ;;
        "payment-service")
            response='{"status": "available"}'
            ;;
        "product-service")
            response='{"status": "unavailable"}'
            ;;
        *)
            response='{"status": "error"}'
            ;;
    esac
    
    if [ -n "$response" ]; then
        if command -v jq >/dev/null 2>&1; then
            status=$(echo "$response" | jq -r '.status // "error_checking_artifact"')
            echo "$status"
        else
            echo "error (jq not installed)"
        fi
    else
        echo "error_checking_artifact"
    fi
}

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "Warning: jq is not installed. Some features will be limited."
    echo "Please install jq using: winget install jqlang.jq"
    echo
fi

# Check if manifest file is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide the path to the services manifest file."
    echo "Usage: $0 <manifest-file>"
    exit 1
fi

manifest_file="$1"

# Check if manifest file exists
if [ ! -f "$manifest_file" ]; then
    echo "Error: Manifest file '$manifest_file' not found."
    exit 1
fi

# Print report header
print_header

# Process each service
while IFS= read -r service_path || [ -n "$service_path" ]; do
    # Skip empty lines
    [ -z "$service_path" ] && continue
    
    # Remove any trailing whitespace and carriage returns
    service_path=$(echo "$service_path" | tr -d '\r' | tr -d ' ')
    
    # Check if service directory exists
    if [ ! -d "$service_path" ]; then
        echo "Service path not found: $service_path"
        print_separator
        continue
    fi
    
    # Get service information
    service_name=$(get_service_name "$service_path")
    version=$(get_version "$service_path")
    artifact_status=$(check_artifact "$service_name" "$version")
    
    # Print service information
    echo "Service: $service_name"
    echo "Version: $version"
    echo "Artifact: $artifact_status"
    print_separator
    
done < "$manifest_file"

# Print report footer
print_footer 
