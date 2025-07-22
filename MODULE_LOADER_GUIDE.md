# SuiteCRM Module Loader Package Guide

## Overview
The `PaymentBridge_v1.0.0_ModuleLoader.zip` package is a complete, self-contained module that can be installed through SuiteCRM's Module Loader interface without any manual file copying or system modifications.

## Package Contents
- **manifest.php** - Module metadata and installation instructions
- **modules/PaymentBridge/** - Complete module code
- **scripts/** - Installation/uninstallation automation
- **language/** - Module translations
- **menu/** - Navigation configuration
- **images/** - Module icon
- **README.txt** - User documentation

## Installation Instructions

### Method 1: Module Loader (Recommended)
1. **Login as Administrator**
   - Access your SuiteCRM instance
   - Login with administrator privileges

2. **Navigate to Module Loader**
   - Go to Admin → Module Loader
   - Click on "Choose File"

3. **Upload the Package**
   - Select `PaymentBridge_v1.0.0_ModuleLoader.zip`
   - Click "Upload"

4. **Install the Module**
   - Find "COBOL Payment Bridge" in the list
   - Click "Install"
   - Accept the license agreement
   - Click "Commit"

5. **Complete Installation**
   - The installer will:
     - Create database tables automatically
     - Configure module permissions
     - Add menu items
     - Run repair and rebuild

6. **Configure the Module**
   - Go to Admin → System Settings
   - Configure COBOL API settings:
     ```
     COBOL API URL: http://your-cobol-api:3000/api
     COBOL API Timeout: 30
     Retry Attempts: 3
     ```

### Method 2: Manual Installation
If Module Loader is disabled:

1. **Extract the Package**
   ```bash
   unzip PaymentBridge_v1.0.0_ModuleLoader.zip -d PaymentBridge_temp
   ```

2. **Copy Module Files**
   ```bash
   cp -r PaymentBridge_temp/modules/PaymentBridge /path/to/suitecrm/custom/modules/
   ```

3. **Run Installation Script**
   ```bash
   cd /path/to/suitecrm
   php -r "require_once('PaymentBridge_temp/scripts/post_install.php'); post_install();"
   ```

4. **Repair and Rebuild**
   - Login as admin
   - Go to Admin → Repair → Quick Repair and Rebuild

## Features Included

### 1. Credit Card Validation
- Real-time validation via COBOL
- PCI-compliant masking
- Multiple card type support

### 2. Interest Calculator
- Dynamic APR calculations
- 3, 6, 12, 18, 24 month terms
- Visual payment schedules

### 3. Statement Generation
- JSON and PDF formats
- Template customization
- Batch processing

### 4. Credit Limit Tracking
- Real-time monitoring
- Usage dashboards
- Alert configuration

### 5. Payment Plan Management
- Automated scheduling
- Payment tracking
- Status monitoring

### 6. System Health Dashboard
- COBOL response times
- Error tracking
- Availability metrics

## Module Structure
```
PaymentBridge/
├── manifest.php              # Module metadata
├── modules/PaymentBridge/    # Core module files
│   ├── PaymentBridge.php     # Bean definition
│   ├── CobolApiService.php   # COBOL integration
│   ├── controller.php        # Action handlers
│   ├── vardefs.php          # Field definitions
│   ├── views/               # UI controllers
│   ├── tpls/                # Templates
│   └── language/            # Translations
├── scripts/                 # Install/uninstall
├── language/application/    # Global strings
├── menu/                    # Navigation
└── README.txt              # Documentation
```

## Security Features
- No storage of full card numbers
- Audit logging for all transactions
- Role-based access control
- Encrypted API communication
- Input validation and sanitization

## Troubleshooting

### Module Not Visible
1. Run Quick Repair and Rebuild
2. Check user role permissions
3. Clear browser cache
4. Verify installation completed

### API Connection Issues
1. Verify COBOL API URL
2. Check network connectivity
3. Review firewall settings
4. Check API service status

### Database Errors
1. Verify MySQL permissions
2. Check table creation
3. Review error logs
4. Run database repair

## Uninstallation
1. Go to Admin → Module Loader
2. Find "COBOL Payment Bridge"
3. Click "Uninstall"
4. Confirm removal

**Note**: Tables are preserved for audit compliance. To fully remove:
```sql
DROP TABLE IF EXISTS payment_bridge;
DROP TABLE IF EXISTS payment_bridge_audit;
DROP TABLE IF EXISTS payment_plans;
DROP TABLE IF EXISTS cobol_system_health;
```

## Support
- GitHub: https://github.com/jfuginay/sugarcrm-cobol-integration
- Issues: https://github.com/jfuginay/sugarcrm-cobol-integration/issues

## License
AGPLv3 - Same as SuiteCRM