---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
```js
const fs = require('fs')
const path = require('path')

// 读取命令行参数
const args = process.argv.slice(2)

// 验证是否有参数
if (args.length === 0) {
  console.log('请提供路径参数')
  process.exit(1)
}

// 获取第一个参数
const filePath = args[0]

// 验证路径是否正确
const isPathValid = fs.existsSync(filePath)
if (!isPathValid) {
  console.log('无效的路径参数')
  process.exit(1)
}

// 解析路径为标准路径地址
const resolvedPath = path.resolve(filePath)
function formatFileSize(fileSize) {
  const units = ['bytes', 'KB', 'MB', 'GB', 'TB']
  let unitIndex = 0

  while (fileSize >= 1024 && unitIndex < units.length - 1) {
    fileSize /= 1024
    unitIndex++
  }
  return (fileSize ?? 0).toFixed(2) + ' ' + units[unitIndex]
}

const foldMap = {}
const fileMap = {}

// 递归读取文件夹
function readFolder(folderPath) {
  const stats = fs.statSync(folderPath)
  if (!stats.isDirectory()) {
    throw new Error('指定的路径不是一个文件夹')
  }

  const foldName = path.basename(folderPath)

  const folderInfo = {
    name: foldName,
    path: folderPath,
    size: 0,
    modified: stats.mtime.toLocaleString(),
    created: stats.birthtime.toLocaleString(),
    files: [],
    folders: []
  }

  if (!foldMap[foldName]) {
    foldMap[foldName] = []
  } else {
    foldMap[foldName].push(folderInfo)
  }

  const files = fs.readdirSync(folderPath)
  files.forEach(file => {
    const filePath = path.join(folderPath, file)
    const fileStats = fs.statSync(filePath)
    const fileInfo = {
      name: file,
      path: filePath,
      readSize: formatFileSize(fileStats.size),
      size: fileStats.size,
      modified: fileStats.mtime.toLocaleString(),
      created: fileStats.birthtime.toLocaleString()
    }

    if (fileStats.isDirectory()) {
      const subFolderInfo = readFolder(filePath)
      folderInfo.folders.push(subFolderInfo)
    } else {
      if (!fileMap[file]) {
        fileMap[file] = []
      } else {
        fileMap[file].push(folderInfo)
      }

      folderInfo.files.push(fileInfo)
    }
  })

  // 计算文件夹的总大小
  folderInfo.size = formatFileSize(folderInfo.files.reduce((totalSize, file) => to
```