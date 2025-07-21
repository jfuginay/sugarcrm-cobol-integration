# SuiteCRM COBOL Payment Bridge Integration Guide

## Overview
This guide explains how to integrate the COBOL Payment Bridge module into your existing SuiteCRM installation.

## Integration Options

### Option 1: Direct Module Installation (Recommended)
This is the easiest method for existing SuiteCRM users.

1. **Download the PaymentBridge module**
   ```bash
   git clone https://github.com/jfuginay/sugarcrm-cobol-integration.git
   cd sugarcrm-cobol-integration
   ```

2. **Copy the module to your SuiteCRM installation**
   ```bash
   cp -r SuiteCRM/custom/modules/PaymentBridge /path/to/your/suitecrm/custom/modules/
   ```

3. **Install database tables**
   ```bash
   mysql -u your_db_user -p your_suitecrm_db < install_payment_bridge.sql
   ```

4. **Configure the COBOL API endpoint**
   Add to your `config_override.php`:
   ```php
   $sugar_config['cobol_api_url'] = 'http://localhost:3000/api';
   $sugar_config['cobol_api_timeout'] = 30;
   ```

5. **Repair and Rebuild**
   - Login to SuiteCRM as admin
   - Go to Admin → Repair → Quick Repair and Rebuild
   - Execute any SQL changes if prompted

### Option 2: Module Loader Package
For distribution through SuiteCRM's Module Loader:

1. **Create manifest.php**
   ```php
   <?php
   $manifest = array(
       'acceptable_sugar_versions' => array(
           'regex_matches' => array('7\.*\.*'),
       ),
       'acceptable_sugar_flavors' => array('CE'),
       'name' => 'COBOL Payment Bridge',
       'description' => 'Enterprise COBOL system integration for payment processing',
       'author' => 'Your Organization',
       'version' => '1.0.0',
       'type' => 'module',
       'is_uninstallable' => true,
   );
   
   $installdefs = array(
       'id' => 'PaymentBridge',
       'copy' => array(
           array(
               'from' => '<basepath>/PaymentBridge',
               'to' => 'custom/modules/PaymentBridge',
           ),
       ),
   );
   ```

2. **Package the module**
   ```bash
   zip -r PaymentBridge_v1.0.0.zip manifest.php PaymentBridge/ install_payment_bridge.sql
   ```

3. **Install via Module Loader**
   - Admin → Module Loader → Upload package

### Option 3: Fork and Pull Request
If you want to contribute this to the official SuiteCRM:

1. **Fork SuiteCRM on GitHub**
   - Go to https://github.com/salesagility/SuiteCRM
   - Click "Fork"

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/SuiteCRM.git
   cd SuiteCRM
   ```

3. **Add the PaymentBridge module**
   ```bash
   # Copy module files
   cp -r /path/to/sugarcrm-cobol-integration/SuiteCRM/custom/modules/PaymentBridge custom/modules/
   
   # Create feature branch
   git checkout -b feature/cobol-payment-bridge
   
   # Commit changes
   git add custom/modules/PaymentBridge
   git commit -m "feat: Add COBOL Payment Bridge module for enterprise integration"
   
   # Push to your fork
   git push origin feature/cobol-payment-bridge
   ```

4. **Create Pull Request**
   - Go to your fork on GitHub
   - Click "Pull Request"
   - Provide detailed description

## Module Features

### For End Users
- Credit card validation
- Interest calculations
- Statement generation
- Credit limit tracking
- Payment plan management
- System health monitoring

### For Administrators
- Easy configuration via config_override.php
- Audit logging for compliance
- Performance metrics
- No core file modifications

### For Developers
- Clean modular architecture
- REST API integration pattern
- Extensible service layer
- Well-documented code

## Requirements
- SuiteCRM 7.x
- PHP 7.2+
- MySQL 5.7+
- COBOL API endpoint (see https://github.com/jfuginay/cobol-credit-api)

## Support
- Documentation: https://github.com/jfuginay/sugarcrm-cobol-integration
- Issues: https://github.com/jfuginay/sugarcrm-cobol-integration/issues

## License
This module is provided under the same license as SuiteCRM (AGPLv3).