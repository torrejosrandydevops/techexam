# DevOps Interview Task: Microservice Pre-Deployment Checker

A bash script that automates pre-deployment checks for a list of microservices, verifying versioning and the availability of corresponding artifacts in a mock repository.

## Features

- Reads service paths from a manifest file
- Detects service versions from multiple sources:
  - `version.txt` file
  - `package.json` version field
- Checks artifact availability (mocked API responses)
- Handles various version formats:
  - Standard versions (e.g., 1.2.3)
  - Beta versions (e.g., 1.0.0-beta.3)
  - Release candidates (e.g., 3.1.4-rc.1)
- Provides clear, formatted output

## Directory Structure
```
microservices-check/
├── app/
│   ├── user-service/
│   │   └── version.txt         # Version: 1.2.3
│   ├── product-service/
│   │   └── package.json        # Version: 0.5.0
│   ├── auth-service/
│   │   └── version.txt         # Version: 2.0.1
│   ├── payment-service/
│   │   └── package.json        # Version: 1.0.0-beta.3
│   ├── notification-service/
│   │   └── version.txt         # Version: 3.1.4-rc.1
│   └── inventory-service/
│       └── package.json        # No version field
├── lib/
│   ├── common-utils/          # No version file
│   └── shared-components/
│       └── package.json       # Version: 4.2.0
├── services.txt               # Service manifest
└── check_services.sh         # Main script
```

## Requirements

- Git Bash (for Windows) or Bash shell (for Unix/Linux)
- jq (JSON processor)
- curl (for real API calls, currently mocked)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/torrejosrandydevops/techexam.git
   cd techexam
   ```

2. Install jq:
   - Windows (using winget):
     ```powershell
     winget install jqlang.jq
     ```
   - Or download from: https://stedolan.github.io/jq/download/

3. Make the script executable:
   ```bash
   chmod +x check_services.sh
   ```

## Usage

1. Create or modify the services manifest (`services.txt`):
   ```
   app/user-service
   app/product-service
   lib/common-utils
   ...
   ```

2. Run the script:
   ```bash
   ./check_services.sh services.txt
   ```

## Sample Output
```
Service Pre-Deployment Check Report:
====================================
Service: user-service
Version: 1.2.3
Artifact: available
------------------------------------
Service: product-service
Version: 0.5.0
Artifact: unavailable
------------------------------------
Service: common-utils
Version: unknown
Artifact: n/a
------------------------------------
...
====================================
```

## Script Features

1. **Version Detection**:
   - Primarily checks for `version.txt`
   - Falls back to `package.json` version field
   - Reports "unknown" if no version found

2. **Artifact Status**:
   - `available`: Service artifact exists
   - `unavailable`: Service artifact missing
   - `error`: Service not found or error checking
   - `n/a`: Version unknown, cannot check

3. **Error Handling**:
   - Graceful handling of missing files
   - Clear error messages
   - Continues processing after errors

## Customization

To modify artifact availability checks:
1. Edit the `check_artifact()` function in `check_services.sh`
2. Add or modify service cases:
   ```bash
   case "$service_name" in
       "your-service")
           response='{"status": "available"}'
           ;;
   esac
   ```

## Real API Integration

To use with a real artifact repository:
1. Uncomment the curl command in `check_artifact()`
2. Modify the API endpoint and parameters as needed
3. Update JSON response parsing if necessary

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 