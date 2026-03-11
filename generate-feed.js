const fs = require('fs');
const path = require('path');

const postsDir = path.join(__dirname, 'posts');
const outputPath = path.join(__dirname, 'feed.xml');
const templatePath = path.join(__dirname, 'feed-template.xml');

// Read template
let template = fs.readFileSync(templatePath, 'utf8');

// Get all HTML posts
const files = fs.readdirSync(postsDir).filter(f => f.endsWith('.html'));

// Build posts XML
const posts = files.map(file => {
  const filePath = path.join(postsDir, file);
  const content = fs.readFileSync(filePath, 'utf8');

  // Extract title
  const titleMatch = content.match(/<title>([^<]+)<\/title>/);
  const title = titleMatch ? titleMatch[1] : 'Untitled';

  // Extract description
  const descMatch = content.match(/<meta\s+name="description"\s+content="([^"]+)"/);
  const description = descMatch ? descMatch[1] : '';

  // Extract date from JSON-LD or guess from file
  let date = new Date(fs.statSync(filePath).mtime).toISOString();
  const dateMatch = content.match(/datePublished":\s*"([^"]+)"/);
  if (dateMatch) {
    date = new Date(dateMatch[1]).toISOString();
  }

  const url = `https://blog.iamdeathgod.tech/posts/${file}`;

  return { title, description, date, url, file };
});

// Sort by date descending
posts.sort((a, b) => new Date(b.date) - new Date(a.date));

// Build posts XML
const postsXml = posts.map(p => `
    <item>
      <title>${escapeXml(p.title)}</title>
      <link>${p.url}</link>
      <description><![CDATA[${p.description}]]></description>
      <pubDate>${new Date(p.date).toUTCString()}</pubDate>
      <guid isPermaLink="true">${p.url}</guid>
    </item>`).join('\n');

// Fill template
const now = new Date().toUTCString();
const output = template
  .replace('{{LAST_BUILD_DATE}}', now)
  .replace('{{POSTS}}', postsXml);

// Write feed
fs.writeFileSync(outputPath, output);
console.log(`Generated feed.xml with ${posts.length} posts`);

function escapeXml(str) {
  return str.replace(/[<>&'"]/g, c => ({
    '<': '&lt;',
    '>': '&gt;',
    '&': '&amp;',
    "'": '&apos;',
    '"': '&quot;'
  })[c]);
}
