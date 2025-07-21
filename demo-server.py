#!/usr/bin/env python3
"""
Simple HTTP server for SuiteCRM COBOL Payment Bridge Demo
"""
import http.server
import socketserver
import os
import webbrowser
from threading import Timer

PORT = 8080
DIRECTORY = "quick-demo"

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

def open_browser():
    webbrowser.open(f'http://localhost:{PORT}')

print(f"""
🚀 SuiteCRM COBOL Payment Bridge - Demo Server
==============================================

Starting demo server on http://localhost:{PORT}

The demo will open in your browser automatically...

Features you can test:
1. Payment Gateway Integration - Real-time card validation
2. Interest Calculation - With payment plan options
3. Statement Generation - Instant customer statements
4. Credit Limit Tracking - Visual dashboards
5. Payment Plan Management - Flexible scheduling
6. COBOL System Health - Performance monitoring

Press Ctrl+C to stop the server.
""")

with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
    # Open browser after 1 second
    Timer(1, open_browser).start()
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n✅ Demo server stopped.")
        pass