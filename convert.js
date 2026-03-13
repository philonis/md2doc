const fs = require('fs');
const { parseMarkdown, DocxBuilder } = require('markdown-to-docx');

async function convert() {
  const inputFile = process.argv[2];
  const outputFile = process.argv[3];
  
  // 读取 markdown 文件内容
  const markdown = fs.readFileSync(inputFile, 'utf8');
  
  // 解析 markdown
  const elements = await parseMarkdown(markdown);
  
  // 创建 docx
  const docx = new DocxBuilder();
  for (const el of elements) {
    docx.addElement(el);
  }
  
  // 保存
  await docx.save(outputFile);
  console.log('Done! Output:', outputFile);
}

convert().catch(console.error);
