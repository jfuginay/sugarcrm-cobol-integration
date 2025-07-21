#!/bin/bash

echo "🚀 SuiteCRM COBOL Payment Bridge - Local Demo Setup"
echo "=================================================="

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check PHP
if ! command -v php &> /dev/null; then
    echo "❌ PHP not found. Please install PHP 7.4+"
    exit 1
fi
echo "✅ PHP found: $(php -v | head -n 1)"

# Check MySQL
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL not found. Please install MySQL"
    exit 1
fi
echo "✅ MySQL found"

# Check Node.js for COBOL API
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js"
    exit 1
fi
echo "✅ Node.js found: $(node -v)"

# Create directories
echo ""
echo "📁 Setting up directories..."
mkdir -p demo-suitecrm/{cache,upload,custom/modules}
mkdir -p logs

# Download minimal SuiteCRM setup
echo ""
echo "📥 Setting up minimal SuiteCRM environment..."
if [ ! -d "demo-suitecrm/include" ]; then
    echo "⚠️  Note: For full demo, download SuiteCRM from:"
    echo "   https://github.com/salesagility/SuiteCRM/releases"
    echo "   Extract to demo-suitecrm/ directory"
fi

# Copy our custom module
echo ""
echo "📦 Installing PaymentBridge module..."
cp -r SuiteCRM/custom/modules/PaymentBridge demo-suitecrm/custom/modules/

# Create minimal config
cat > demo-suitecrm/config.php << 'EOF'
<?php
$sugar_config = array(
    'dbconfig' => array(
        'db_host_name' => 'localhost',
        'db_user_name' => 'root',
        'db_password' => '',
        'db_name' => 'suitecrm_demo',
        'db_type' => 'mysql',
    ),
    'cobol_api_url' => 'http://localhost:3000/api',
    'site_url' => 'http://localhost:8080',
    'log_dir' => './logs/',
    'log_file' => 'suitecrm.log',
    'developer_mode' => true,
);

// Minimal bootstrap
if (!defined('sugarEntry')) define('sugarEntry', true);
EOF

# Create database setup script
cat > setup-database.sql << 'EOF'
-- Create database
CREATE DATABASE IF NOT EXISTS suitecrm_demo;
USE suitecrm_demo;

-- Minimal tables for demo
CREATE TABLE IF NOT EXISTS config (
    category VARCHAR(32),
    name VARCHAR(32),
    value TEXT,
    PRIMARY KEY (category, name)
);

-- Include our payment bridge tables
SOURCE install_payment_bridge.sql;

-- Add test data
INSERT INTO payment_bridge (id, name, card_number_masked, validation_status, credit_limit, current_balance, apr, deleted)
VALUES 
('demo-1', 'Demo Card 1', '4532-****-****-0366', 'Valid', 5000.00, 2500.00, 18.99, 0),
('demo-2', 'Demo Card 2', '5425-****-****-9903', 'Valid', 3000.00, 1500.00, 21.99, 0);

INSERT INTO accounts (id, name, deleted) 
VALUES 
('acct-1', 'Acme Insurance Co', 0),
('acct-2', 'Global Finance Ltd', 0);

GRANT ALL PRIVILEGES ON suitecrm_demo.* TO 'suitecrm'@'localhost' IDENTIFIED BY 'suitecrm';
FLUSH PRIVILEGES;
EOF

echo ""
echo "📊 Setting up database..."
echo "Enter your MySQL root password when prompted:"
mysql -u root -p < setup-database.sql

# Create standalone demo page
cat > demo-suitecrm/payment_demo.php << 'EOF'
<?php
// Standalone demo page for PaymentBridge features
session_start();
?>
<!DOCTYPE html>
<html>
<head>
    <title>SuiteCRM Payment Bridge Demo</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .demo-section { margin: 30px 0; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .result-box { margin: 15px 0; padding: 15px; background: #f8f9fa; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mt-4">🏦 SuiteCRM COBOL Payment Bridge Demo</h1>
        <p class="lead">Enterprise Legacy Modernization for Insurance & Finance</p>
        
        <!-- Feature 1: Card Validation -->
        <div class="demo-section">
            <h2>Feature 1: Payment Gateway Integration</h2>
            <p>Real-time credit card validation using legacy COBOL systems</p>
            <div class="row">
                <div class="col-md-6">
                    <input type="text" id="card-number" class="form-control" placeholder="Enter 16-digit card number" maxlength="16">
                    <small>Test cards: 4532015112830366, 5425233430109903, 4111111111111111</small>
                </div>
                <div class="col-md-6">
                    <button class="btn btn-primary" onclick="validateCard()">Validate Card</button>
                </div>
            </div>
            <div id="validation-result" class="result-box" style="display:none;"></div>
        </div>
        
        <!-- Feature 2: Interest Calculator -->
        <div class="demo-section">
            <h2>Feature 2: Interest Calculation Module</h2>
            <p>Calculate interest and generate payment plans</p>
            <div class="row">
                <div class="col-md-4">
                    <input type="number" id="balance" class="form-control" placeholder="Balance" value="2500">
                </div>
                <div class="col-md-4">
                    <input type="number" id="apr" class="form-control" placeholder="APR %" value="18.99">
                </div>
                <div class="col-md-4">
                    <button class="btn btn-primary" onclick="calculateInterest()">Calculate</button>
                </div>
            </div>
            <div id="interest-result" class="result-box" style="display:none;"></div>
        </div>
        
        <!-- Feature 3: Statement Generation -->
        <div class="demo-section">
            <h2>Feature 3: Statement Generation</h2>
            <p>Generate customer statements from COBOL data</p>
            <button class="btn btn-primary" onclick="generateStatement()">Generate Statement</button>
            <div id="statement-result" class="result-box" style="display:none;"></div>
        </div>
        
        <!-- Feature 4: Credit Tracking -->
        <div class="demo-section">
            <h2>Feature 4: Credit Limit Tracking</h2>
            <p>Monitor credit utilization in real-time</p>
            <div id="credit-tracking" class="result-box">
                <canvas id="creditChart" width="400" height="200"></canvas>
            </div>
        </div>
        
        <!-- Feature 5: Payment Plans -->
        <div class="demo-section">
            <h2>Feature 5: Payment Plan Management</h2>
            <p>Create flexible payment plans</p>
            <div id="payment-plans" class="result-box"></div>
        </div>
        
        <!-- Feature 6: System Health -->
        <div class="demo-section">
            <h2>Feature 6: COBOL System Health Monitoring</h2>
            <p>Monitor legacy system performance</p>
            <button class="btn btn-primary" onclick="checkHealth()">Check System Health</button>
            <div id="health-result" class="result-box" style="display:none;"></div>
        </div>
    </div>
    
    <script>
    // Demo functions
    function validateCard() {
        const cardNumber = $('#card-number').val();
        if (cardNumber.length !== 16) {
            alert('Please enter a 16-digit card number');
            return;
        }
        
        // Simulate API call
        $('#validation-result').html('<div class="spinner-border"></div> Validating...').show();
        
        setTimeout(() => {
            const isValid = ['4532015112830366', '5425233430109903', '4111111111111111'].includes(cardNumber);
            $('#validation-result').html(
                isValid 
                ? '<div class="success">✅ Card Valid - Type: ' + (cardNumber[0] === '4' ? 'VISA' : 'MasterCard') + '</div>'
                : '<div class="error">❌ Card Invalid</div>'
            );
        }, 1000);
    }
    
    function calculateInterest() {
        const balance = parseFloat($('#balance').val());
        const apr = parseFloat($('#apr').val());
        const monthlyRate = apr / 12 / 100;
        const interest = balance * monthlyRate;
        
        $('#interest-result').html(`
            <h4>Interest Calculation Results</h4>
            <p>Monthly Rate: ${(monthlyRate * 100).toFixed(2)}%</p>
            <p>Interest Charge: $${interest.toFixed(2)}</p>
            <p>New Balance: $${(balance + interest).toFixed(2)}</p>
            <h5>Payment Plan Options:</h5>
            <ul>
                <li>3 months: $${((balance * 1.02) / 3).toFixed(2)}/month</li>
                <li>6 months: $${((balance * 1.05) / 6).toFixed(2)}/month</li>
                <li>12 months: $${((balance * 1.10) / 12).toFixed(2)}/month</li>
            </ul>
        `).show();
    }
    
    function generateStatement() {
        $('#statement-result').html(`
            <h4>Statement Generated</h4>
            <pre>
CREDIT CARD STATEMENT
====================
Date: ${new Date().toLocaleDateString()}
Card: 4532-****-****-0366
Balance: $2,500.00
Available: $2,500.00
Min Payment: $75.00
Due Date: ${new Date(Date.now() + 30*24*60*60*1000).toLocaleDateString()}
            </pre>
        `).show();
    }
    
    function checkHealth() {
        $('#health-result').html(`
            <h4>COBOL System Health</h4>
            <p>Status: <span class="badge badge-success">Healthy</span></p>
            <p>Response Time: 45ms</p>
            <p>Availability: 99.9%</p>
            <p>Last Check: ${new Date().toLocaleTimeString()}</p>
        `).show();
    }
    
    // Initialize credit chart
    $(document).ready(function() {
        // Simulate credit tracking
        $('#credit-tracking').html(`
            <h4>Credit Utilization</h4>
            <div class="progress" style="height: 30px;">
                <div class="progress-bar" style="width: 50%">50% Used</div>
            </div>
            <p class="mt-2">Used: $2,500 / Limit: $5,000</p>
        `);
        
        // Payment plans
        $('#payment-plans').html(`
            <h4>Active Payment Plans</h4>
            <table class="table">
                <tr><th>Account</th><th>Plan</th><th>Monthly</th><th>Status</th></tr>
                <tr><td>Acme Insurance</td><td>6 months</td><td>$437.50</td><td><span class="badge badge-success">Active</span></td></tr>
                <tr><td>Global Finance</td><td>12 months</td><td>$229.17</td><td><span class="badge badge-warning">Pending</span></td></tr>
            </table>
        `);
    });
    </script>
</body>
</html>
EOF

echo ""
echo "✅ Setup complete!"
echo ""
echo "🚀 To start the demo:"
echo "1. Start the COBOL API server:"
echo "   cd ../cobol-credit-api && npm start"
echo ""
echo "2. In a new terminal, start PHP server:"
echo "   cd demo-suitecrm && php -S localhost:8080"
echo ""
echo "3. Open your browser to:"
echo "   http://localhost:8080/payment_demo.php"
echo ""
echo "📝 Demo credentials:"
echo "   Test cards: 4532015112830366, 5425233430109903, 4111111111111111"