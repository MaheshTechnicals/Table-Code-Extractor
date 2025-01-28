document.getElementById('extractBtn').addEventListener('click', async () => {
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

  try {
    const result = await chrome.scripting.executeScript({
      target: { tabId: tab.id },
      function: extractTables,
    });

    if (result && result[0] && result[0].result) {
      displayTables(result[0].result);
    } else {
      displayNoTablesFound();
    }
  } catch (err) {
    console.error('Failed to extract tables:', err);
    displayError();
  }
});

// Function to extract all tables from the page
function extractTables() {
  const tables = document.querySelectorAll('table'); // Use querySelectorAll for better compatibility
  const tableData = [];

  tables.forEach((table, index) => {
    tableData.push({
      id: index + 1,
      code: table.outerHTML.trim(),
    });
  });

  return tableData;
}

// Function to display extracted tables in the popup
function displayTables(tables) {
  const container = document.getElementById('tablesContainer');
  container.innerHTML = '';

  if (tables.length === 0) {
    displayNoTablesFound();
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
      try {
        await navigator.clipboard.writeText(code);
        showCopySuccess(e.target);
      } catch (err) {
        console.error('Failed to copy:', err);
      }
    });
  });
}

// Utility function to display no tables found message
function displayNoTablesFound() {
  const container = document.getElementById('tablesContainer');
  container.innerHTML = '<div class="no-tables">No tables found on this page</div>';
}

// Utility function to display error message
function displayError() {
  const container = document.getElementById('tablesContainer');
  container.innerHTML = '<div class="no-tables">Error occurred while extracting tables</div>';
}

// Utility function to show success message after copying
function showCopySuccess(button) {
  const originalText = button.textContent;
  button.textContent = 'Copied!';
  button.style.backgroundColor = '#16a085';

  setTimeout(() => {
    button.textContent = originalText;
    button.style.backgroundColor = '';
  }, 1500);
}

// Utility function to escape HTML
function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}
