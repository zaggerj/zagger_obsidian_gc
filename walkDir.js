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
  folderInfo.size = formatFileSize(folderInfo.files.reduce((totalSize, file) => totalSize + file.size, 0) ?? 0)

  return folderInfo
}

// 打印文件夹信息
function printFolderInfo(folderInfo, depth = 0) {
  const indent = '  '.repeat(depth)
  console.log(indent + '文件夹:', folderInfo.path)
  console.log(indent + '大小:', folderInfo.size + ' 字节')
  console.log(indent + '修改日期:', folderInfo.modified)
  console.log(indent + '创建日期:', folderInfo.created)

  folderInfo.folders.forEach(subFolderInfo => {
    printFolderInfo(subFolderInfo, depth + 1)
  })

  folderInfo.files.forEach(fileInfo => {
    console.log(indent + '文件:', fileInfo.name)
    console.log(indent + '路径:', fileInfo.path)
    console.log(indent + '大小:', fileInfo.size + ' 字节')
    console.log(indent + '修改日期:', fileInfo.modified)
    console.log(indent + '创建日期:', fileInfo.created)
  })
}

// 示例用法
// const folderPath = './zagger'
const folderInfo = readFolder(resolvedPath)
console.log('folderInfo:', folderInfo)
console.log('foldMap:', foldMap)
console.log('fileMap:', fileMap)
printFolderInfo(folderInfo)
