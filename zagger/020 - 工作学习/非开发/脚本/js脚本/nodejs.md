---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
```js
const fs = require('fs');
const path = require('path');

const targetFolder = './zagger';  // 替换为目标文件夹的实际路径

function deleteFilesWithPattern(folderPath) {
  fs.readdirSync(folderPath).forEach(file => {
    const filePath = path.join(folderPath, file);
    const stats = fs.statSync(filePath);

    if (stats.isDirectory()) {
      deleteFilesWithPattern(filePath);  // 递归遍历子文件夹
    } else if (file.includes('(1)')) {
      fs.unlinkSync(filePath);  // 删除文件
      console.log(`已删除文件：${filePath}`);
    }
  });
}

deleteFilesWithPattern(targetFolder);


 
```