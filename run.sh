#!/bin/bash

# Clear any existing directory and create fresh
rm -rf table-code-extractor
mkdir -p table-code-extractor/icons

# Create manifest.json
cat > table-code-extractor/manifest.json << 'EOF'
{
  "manifest_version": 3,
  "name": "Table Code Extractor",
  "version": "1.0",
  "description": "Extract HTML table code from web pages - By Mahesh Technicals",
  "permissions": ["activeTab", "scripting"],
  "action": {
    "default_popup": "popup.html"
  },
  "icons": {
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  }
}
EOF

# Create popup.html
cat > table-code-extractor/popup.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>Table Code Extractor</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body {
      width: 500px;
      min-height: 300px;
      padding: 20px;
      background-color: #1a1a1a;
      color: #ffffff;
      font-family: 'Arial', sans-serif;
    }

    .header {
      text-align: center;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid #3498db;
    }

    .author-info {
      text-align: center;
      margin-bottom: 20px;
      padding: 15px;
      background-color: #2c2c2c;
      border-radius: 8px;
    }

    .author-name {
      font-size: 1.2em;
      color: #3498db;
      margin-bottom: 10px;
    }

    .social-links {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-top: 10px;
    }

    .social-links a {
      color: #ffffff;
      text-decoration: none;
      transition: color 0.3s;
      font-size: 1.5em;
    }

    .social-links a:hover {
      color: #3498db;
    }

    .youtube:hover {
      color: #ff0000 !important;
    }

    .website:hover {
      color: #00ff00 !important;
    }

    .github:hover {
      color: #ffffff !important;
    }

    .telegram:hover {
      color: #0088cc !important;
    }

    .extract-btn {
      width: 100%;
      padding: 12px;
      background-color: #3498db;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
      margin-bottom: 20px;
      transition: background-color 0.3s;
    }

    .extract-btn:hover {
      background-color: #2980b9;
    }

    .tables-container {
      max-height: 400px;
      overflow-y: auto;
    }

    .table-item {
      background-color: #2c2c2c;
      border-radius: 8px;
      padding: 15px;
      margin-bottom: 15px;
    }

    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }

    .copy-btn {
      background-color: #27ae60;
      color: white;
      border: none;
      padding: 8px 15px;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
    }

    .copy-btn:hover {
      background-color: #219a52;
    }

    .code-preview {
      background-color: #363636;
      padding: 10px;
      border-radius: 4px;
      max-height: 150px;
      overflow-y: auto;
      font-family: monospace;
      white-space: pre-wrap;
      color: #e0e0e0;
    }

    .no-tables {
      text-align: center;
      color: #888;
      font-style: italic;
    }

    /* Coffee Support Section Styles */
    .coffee-support {
      margin-top: 30px;
      padding: 20px;
      background: linear-gradient(145deg, #2c2c2c, #363636);
      border-radius: 15px;
      text-align: center;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
      border: 1px solid #444;
    }

    .coffee-title {
      font-size: 1.2em;
      color: #fff;
      margin-bottom: 15px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
    }

    .coffee-emoji {
      font-size: 1.4em;
      animation: steam 2s infinite;
    }

    @keyframes steam {
      0% { transform: translateY(0) rotate(0deg); }
      50% { transform: translateY(-5px) rotate(5deg); }
      100% { transform: translateY(0) rotate(0deg); }
    }

    .donate-methods {
      display: flex;
      gap: 15px;
      justify-content: center;
      flex-wrap: wrap;
      margin-top: 15px;
    }

    .donate-btn {
      padding: 10px 20px;
      border-radius: 8px;
      text-decoration: none;
      color: white;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: all 0.3s ease;
      min-width: 120px;
    }

    .donate-btn.paypal {
      background: linear-gradient(145deg, #0070ba, #005ea6);
    }

    .donate-btn.paypal:hover {
      background: linear-gradient(145deg, #005ea6, #004a8c);
      transform: translateY(-2px);
    }

    .donate-btn.upi {
      background: linear-gradient(145deg, #7b1fa2, #6a1b9a);
    }

    .donate-btn.upi:hover {
      background: linear-gradient(145deg, #6a1b9a, #4a148c);
      transform: translateY(-2px);
    }

    .support-message {
      font-size: 0.9em;
      color: #888;
      margin-top: 15px;
      font-style: italic;
    }

    ::-webkit-scrollbar {
      width: 8px;
    }

    ::-webkit-scrollbar-track {
      background: #2c2c2c;
    }

    ::-webkit-scrollbar-thumb {
      background: #888;
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: #555;
    }
  </style>
</head>
<body>
  <div class="header">
    <h2>Table Code Extractor</h2>
  </div>

  <div class="author-info">
    <div class="author-name">Mahesh Technicals</div>
    <div class="social-links">
      <a href="https://youtube.com/@maheshtechnicals" target="_blank" class="youtube" title="YouTube">
        <i class="fab fa-youtube"></i>
      </a>
      <a href="https://maheshtechnicals.com/" target="_blank" class="website" title="Website">
        <i class="fas fa-globe"></i>
      </a>
      <a href="https://github.com/MaheshTechnicals" target="_blank" class="github" title="GitHub">
        <i class="fab fa-github"></i>
      </a>
      <a href="https://t.me/MaheshTechnicals" target="_blank" class="telegram" title="Telegram">
        <i class="fab fa-telegram"></i>
      </a>
    </div>
  </div>

  <button id="extractBtn" class="extract-btn">Get Tables</button>
  <div id="tablesContainer" class="tables-container"></div>

  <div class="coffee-support">
    <div class="coffee-title">
      <span>Buy Me a Coffee</span>
      <span class="coffee-emoji">☕</span>
    </div>
    <div class="support-message">Support my work and keep me caffeinated!</div>
    <div class="donate-methods">
      <a href="https://www.paypal.com/paypalme/Varma161" target="_blank" class="donate-btn paypal">
        <i class="fab fa-paypal"></i>
        PayPal
      </a>
      <a href="https://www.paypal.com/paypalme/Varma161" target="_blank" class="donate-btn upi">
        <i class="fas fa-mobile-alt"></i>
        UPI
      </a>
    </div>
  </div>

  <script src="popup.js"></script>
</body>
</html>
EOF

# Create popup.js
cat > table-code-extractor/popup.js << 'EOF'
document.getElementById('extractBtn').addEventListener('click', async () => {
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  
  try {
    const result = await chrome.scripting.executeScript({
      target: { tabId: tab.id },
      function: extractTables,
    });

    displayTables(result[0].result);
  } catch (err) {
    console.error('Failed to extract tables:', err);
  }
});

function extractTables() {
  const tables = document.getElementsByTagName('table');
  const tableData = [];
  
  for (let i = 0; i < tables.length; i++) {
    tableData.push({
      id: i + 1,
      code: tables[i].outerHTML
    });
  }
  
  return tableData;
}

function displayTables(tables) {
  const container = document.getElementById('tablesContainer');
  container.innerHTML = '';

  if (tables.length === 0) {
    container.innerHTML = '<div class="no-tables">No tables found on this page</div>';
    return;
  }

  tables.forEach(table => {
    const tableElement = document.createElement('div');
    tableElement.className = 'table-item';
    
    tableElement.innerHTML = `
      <div class="table-header">
        <h3>Table ${table.id}</h3>
        <button class="copy-btn" data-code="${encodeURIComponent(table.code)}">Copy Code</button>
      </div>
      <div class="code-preview">${escapeHtml(table.code)}</div>
    `;
    
    container.appendChild(tableElement);
  });

  // Add copy button functionality
  document.querySelectorAll('.copy-btn').forEach(button => {
    button.addEventListener('click', async (e) => {
      const code = decodeURIComponent(e.target.dataset.code);
      await navigator.clipboard.writeText(code);
      
      const originalText = e.target.textContent;
      e.target.textContent = 'Copied!';
      e.target.style.backgroundColor = '#16a085';
      
      setTimeout(() => {
        e.target.textContent = originalText;
        e.target.style.backgroundColor = '';
      }, 1500);
    });
  });
}

function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}
EOF

# Create icon files
cat > table-code-extractor/icons/icon48.png << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">
  <rect width="48" height="48" fill="#3498db"/>
  <rect x="8" y="8" width="32" height="32" fill="none" stroke="white" stroke-width="2"/>
  <line x1="8" y1="18" x2="40" y2="18" stroke="white" stroke-width="2"/>
  <line x1="8" y1="28" x2="40" y2="28" stroke="white" stroke-width="2"/>
  <line x1="18" y1="8" x2="18" y2="40" stroke="white" stroke-width="2"/>
  <line x1="28" y1="8" x2="28" y2="40" stroke="white" stroke-width="2"/>
</svg>
EOF

cp table-code-extractor/icons/icon48.png table-code-extractor/icons/icon128.png

echo "Project structure created successfully!"
echo "Note: Please convert the SVG icons to PNG format before using the extension."
echo "Author: Mahesh Technicals"

# List the created files
echo -e "\nCreated files:"
ls -R table-code-extractor/
