---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
实现找到所有zy-table行，然后之前添加<!-- prettier-ignore -->
```bash
 grep -r '<zy-table\b' ./ --exclude={'*.html'} --exclude-dir={.git,node_modules,resources,built} |awk -e '❯ grep -r '<zy-table\b' ./ --exclude={'*.html'} --exclude-dir={.git,node_modules,resources,built} |awk -F ':' '{print $1}'odules,resources,built} |awk -F ':' '{print $1}'| xargs sed -i '/<zy-table/i<!-- prettier-ignore -->'
```
[linux三剑客(grep、sed、awk)基本使用 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/532822255)