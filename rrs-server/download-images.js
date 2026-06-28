const fs = require('fs');
const path = require('path');
const https = require('https');

const mockFilePath = path.join(__dirname, 'routes', 'mock.js');
const outputDir = path.join(__dirname, 'public', 'images');

// Create directory structure if not exists
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

async function downloadImage(url, destPath) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(destPath);
    https.get(url, (response) => {
      if (response.statusCode === 301 || response.statusCode === 302) {
        // Handle redirect (e.g., Unsplash redirecting to source image)
        downloadImage(response.headers.location, destPath).then(resolve).catch(reject);
        return;
      }
      if (response.statusCode !== 200) {
        reject(new Error(`Failed to download image. Status: ${response.statusCode}`));
        return;
      }
      response.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      fs.unlink(destPath, () => {});
      reject(err);
    });
  });
}

async function start() {
  console.log('Reading mock.js...');
  let content = fs.readFileSync(mockFilePath, 'utf8');

  // Find all unsplash URLs
  const urlRegex = /https:\/\/images\.unsplash\.com\/photo-[a-zA-Z0-9-]+/g;
  const urls = [...new Set(content.match(urlRegex) || [])];
  
  console.log(`Found ${urls.length} unique external image URLs. Starting downloads...`);

  const urlMap = {};
  for (let i = 0; i < urls.length; i++) {
    const url = urls[i];
    const filename = `img_${i + 1}.jpg`;
    const destPath = path.join(outputDir, filename);

    console.log(`[${i + 1}/${urls.length}] Downloading ${url} -> ${filename}...`);
    try {
      await downloadImage(url, destPath);
      urlMap[url] = `/images/${filename}`;
    } catch (err) {
      console.error(`Error downloading ${url}:`, err.message);
    }
  }

  // Replace URLs in mock.js content
  console.log('Updating mock.js references...');
  let updatedContent = content;
  for (const [externalUrl, localPath] of Object.entries(urlMap)) {
    // Replace all occurrences
    updatedContent = updatedContent.split(externalUrl).join(localPath);
  }

  fs.writeFileSync(mockFilePath, updatedContent, 'utf8');
  console.log('Done! All images downloaded and mock.js successfully updated.');
}

start().catch(console.error);
