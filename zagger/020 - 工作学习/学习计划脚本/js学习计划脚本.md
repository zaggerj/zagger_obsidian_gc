---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
```js
const prefixUrl = 'https://zh.javascript.info'
// 树形结构
const tree = /* list || */ [
  {
    name: 'JavaScript 编程语言',
    children: [
      {
        name: '简介',
        children: [
          {
            name: 'JavaScript 简介',
            url: '/intro'
          },
          {
            name: '手册与规范',
            url: '/manuals-specifications'
          },
          {
            name: '代码编辑器',
            url: '/code-editors'
          },
          {
            name: '开发者控制台',
            url: '/devtools'
          }
        ]
      },
      {
        name: 'JavaScript 基础知识',
        children: [
          {
            name: 'Hello, world!',
            url: '/hello-world'
          },
          {
            name: '代码结构',
            url: '/structure'
          },
          {
            name: '现代模式，"use strict"',
            url: '/strict-mode'
          },
          {
            name: '变量',
            url: '/variables'
          },
          {
            name: '数据类型',
            url: '/types'
          },
          {
            name: '交互：alert、prompt 和 confirm',
            url: '/alert-prompt-confirm'
          },
          {
            name: '类型转换',
            url: '/type-conversions'
          },
          {
            name: '基础运算符，数学运算',
            url: '/operators'
          },
          {
            name: '值的比较',
            url: '/comparison'
          },
          {
            name: "条件分支：if 和 '?'",
            url: '/ifelse'
          },
          {
            name: '逻辑运算符',
            url: '/logical-operators'
          },
          {
            name: "空值合并运算符 '??'",
            url: '/nullish-coalescing-operator'
          },
          {
            name: '循环：while 和 for',
            url: '/while-for'
          },
          {
            name: '"switch" 语句',
            url: '/switch'
          },
          {
            name: '函数',
            url: '/function-basics'
          },
          {
            name: '函数表达式',
            url: '/function-expressions'
          },
          {
            name: '箭头函数，基础知识',
            url: '/arrow-functions-basics'
          },
          {
            name: 'JavaScript 特性',
            url: '/javascript-specials'
          }
        ]
      },
      {
        name: '代码质量',
        children: [
          {
            name: '在浏览器中调试',
            url: '/debugging-chrome'
          },
          {
            name: '代码风格',
            url: '/coding-style'
          },
          {
            name: '注释',
            url: '/comments'
          },
          {
            name: '忍者代码',
            url: '/ninja-code'
          },
          {
            name: '使用 Mocha 进行自动化测试',
            url: '/testing-mocha'
          },
          {
            name: 'Polyfill 和转译器',
            url: '/polyfills'
          }
        ]
      },
      {
        name: 'Object（对象）：基础知识',
        children: [
          {
            name: '对象',
            url: '/object'
          },
          {
            name: '对象引用和复制',
            url: '/object-copy'
          },
          {
            name: '垃圾回收',
            url: '/garbage-collection'
          },
          {
            name: '对象方法，"this"',
            url: '/object-methods'
          },
          {
            name: '构造器和操作符 "new"',
            url: '/constructor-new'
          },
          {
            name: '可选链 "?."',
            url: '/optional-chaining'
          },
          {
            name: 'symbol 类型',
            url: '/symbol'
          },
          {
            name: '对象 —— 原始值转换',
            url: '/object-toprimitive'
          }
        ]
      },
      {
        name: '数据类型',
        children: [
          {
            name: '原始类型的方法',
            url: '/primitives-methods'
          },
          {
            name: '数字类型',
            url: '/number'
          },
          {
            name: '字符串',
            url: '/string'
          },
          {
            name: '数组',
            url: '/array'
          },
          {
            name: '数组方法',
            url: '/array-methods'
          },
          {
            name: 'Iterable object（可迭代对象）',
            url: '/iterable'
          },
          {
            name: 'Map and Set（映射和集合）',
            url: '/map-set'
          },
          {
            name: 'WeakMap and WeakSet（弱映射和弱集合）',
            url: '/weakmap-weakset'
          },
          {
            name: 'Object.keys，values，entries',
            url: '/keys-values-entries'
          },
          {
            name: '解构赋值',
            url: '/destructuring-assignment'
          },
          {
            name: '日期和时间',
            url: '/date'
          },
          {
            name: 'JSON 方法，toJSON',
            url: '/json'
          }
        ]
      },
      {
        name: '函数进阶内容',
        children: [
          {
            name: '递归和堆栈',
            url: '/recursion'
          },
          {
            name: 'Rest 参数与 Spread 语法',
            url: '/rest-parameters-spread'
          },
          {
            name: '变量作用域，闭包',
            url: '/closure'
          },
          {
            name: '老旧的 "var"',
            url: '/var'
          },
          {
            name: '全局对象',
            url: '/global-object'
          },
          {
            name: '函数对象，NFE',
            url: '/function-object'
          },
          {
            name: '"new Function" 语法',
            url: '/new-function'
          },
          {
            name: '调度：setTimeout 和 setInterval',
            url: '/settimeout-setinterval'
          },
          {
            name: '装饰器模式和转发，call/apply',
            url: '/call-apply-decorators'
          },
          {
            name: '函数绑定',
            url: '/bind'
          },
          {
            name: '深入理解箭头函数',
            url: '/arrow-functions'
          }
        ]
      },
      {
        name: '对象属性配置',
        children: [
          {
            name: '属性标志和属性描述符',
            url: '/property-descriptors'
          },
          {
            name: '属性的 getter 和 setter',
            url: '/property-accessors'
          }
        ]
      },
      {
        name: '原型，继承',
        children: [
          {
            name: '原型继承',
            url: '/prototype-inheritance'
          },
          {
            name: 'F.prototype',
            url: '/function-prototype'
          },
          {
            name: '原生的原型',
            url: '/native-prototypes'
          },
          {
            name: '原型方法，没有 __proto__ 的对象',
            url: '/prototype-methods'
          }
        ]
      },
      {
        name: '类',
        children: [
          {
            name: 'Class 基本语法',
            url: '/class'
          },
          {
            name: '类继承',
            url: '/class-inheritance'
          },
          {
            name: '静态属性和静态方法',
            url: '/static-properties-methods'
          },
          {
            name: '私有的和受保护的属性和方法',
            url: '/private-protected-properties-methods'
          },
          {
            name: '扩展内建类',
            url: '/extend-natives'
          },
          {
            name: '类检查："instanceof"',
            url: '/instanceof'
          },
          {
            name: 'Mixin 模式',
            url: '/mixins'
          }
        ]
      },
      {
        name: '错误处理',
        children: [
          {
            name: '错误处理，"try...catch"',
            url: '/try-catch'
          },
          {
            name: '自定义 Error，扩展 Error',
            url: '/custom-errors'
          }
        ]
      },
      {
        name: 'Promise，async/await',
        children: [
          {
            name: '简介：回调',
            url: '/callbacks'
          },
          {
            name: 'Promise',
            url: '/promise-basics'
          },
          {
            name: 'Promise 链',
            url: '/promise-chaining'
          },
          {
            name: '使用 promise 进行错误处理',
            url: '/promise-error-handling'
          },
          {
            name: 'Promise API',
            url: '/promise-api'
          },
          {
            name: 'Promisification',
            url: '/promisify'
          },
          {
            name: '微任务（Microtask）',
            url: '/microtask-queue'
          },
          {
            name: 'async/await',
            url: '/async-await'
          }
        ]
      },
      {
        name: 'Generator，高级 iteration',
        children: [
          {
            name: 'generator',
            url: '/generators'
          },
          {
            name: '异步迭代和 generator',
            url: '/async-iterators-generators'
          }
        ]
      },
      {
        name: '模块',
        children: [
          {
            name: '模块 (Module) 简介',
            url: '/modules-intro'
          },
          {
            name: '导出和导入',
            url: '/import-export'
          },
          {
            name: '动态导入',
            url: '/modules-dynamic-imports'
          }
        ]
      },
      {
        name: '杂项',
        children: [
          {
            name: 'Proxy 和 Reflect',
            url: '/proxy'
          },
          {
            name: 'Eval：执行代码字符串',
            url: '/eval'
          },
          {
            name: '柯里化（Currying）',
            url: '/currying-partials'
          },
          {
            name: 'Reference Type',
            url: '/reference-type'
          },
          {
            name: 'BigInt',
            url: '/bigint'
          },
          {
            name: 'Unicode —— 字符串内幕',
            url: '/unicode'
          }
        ]
      }
    ]
  },
  {
    name: '浏览器：文档，事件，接口',
    children: [
      {
        name: 'Document',
        children: [
          {
            name: '浏览器环境，规格',
            url: '/browser-environment'
          },
          {
            name: 'DOM 树',
            url: '/dom-nodes'
          },
          {
            name: '遍历 DOM',
            url: '/dom-navigation'
          },
          {
            name: '搜索：getElement*，querySelector*',
            url: '/searching-elements-dom'
          },
          {
            name: '节点属性：type，tag 和 content',
            url: '/basic-dom-node-properties'
          },
          {
            name: '特性和属性（Attributes and properties）',
            url: '/dom-attributes-and-properties'
          },
          {
            name: '修改文档（document）',
            url: '/modifying-document'
          },
          {
            name: '样式和类',
            url: '/styles-and-classes'
          },
          {
            name: '元素大小和滚动',
            url: '/size-and-scroll'
          },
          {
            name: 'Window 大小和滚动',
            url: '/size-and-scroll-window'
          },
          {
            name: '坐标',
            url: '/coordinates'
          }
        ]
      },
      {
        name: '事件简介',
        children: [
          {
            name: '浏览器事件简介',
            url: '/introduction-browser-events'
          },
          {
            name: '冒泡和捕获',
            url: '/bubbling-and-capturing'
          },
          {
            name: '事件委托',
            url: '/event-delegation'
          },
          {
            name: '浏览器默认行为',
            url: '/default-browser-action'
          },
          {
            name: '创建自定义事件',
            url: '/dispatch-events'
          }
        ]
      },
      {
        name: 'UI 事件',
        children: [
          {
            name: '鼠标事件',
            url: '/mouse-events-basics'
          },
          {
            name: '移动鼠标：mouseover/out，mouseenter/leave',
            url: '/mousemove-mouseover-mouseout-mouseenter-mouseleave'
          },
          {
            name: '鼠标拖放事件',
            url: '/mouse-drag-and-drop'
          },
          {
            name: '指针事件',
            url: '/pointer-events'
          },
          {
            name: '键盘：keydown 和 keyup',
            url: '/keyboard-events'
          },
          {
            name: '滚动',
            url: '/onscroll'
          }
        ]
      },
      {
        name: '表单，控件',
        children: [
          {
            name: '表单属性和方法',
            url: '/form-elements'
          },
          {
            name: '聚焦：focus/blur',
            url: '/focus-blur'
          },
          {
            name: '事件：change，input，cut，copy，paste',
            url: '/events-change-input'
          },
          {
            name: '表单：事件和方法提交',
            url: '/forms-submit'
          }
        ]
      },
      {
        name: '加载文档和其他资源',
        children: [
          {
            name: '页面生命周期：DOMContentLoaded，load，beforeunload，unload',
            url: '/onload-ondomcontentloaded'
          },
          {
            name: '脚本：async，defer',
            url: '/script-async-defer'
          },
          {
            name: '资源加载：onload，onerror',
            url: '/onload-onerror'
          }
        ]
      },
      {
        name: '杂项',
        children: [
          {
            name: 'DOM 变动观察器（Mutation observer）',
            url: '/mutation-observer'
          },
          {
            name: '选择（Selection）和范围（Range）',
            url: '/selection-range'
          },
          {
            name: '事件循环：微任务和宏任务',
            url: '/event-loop'
          }
        ]
      }
    ]
  },
  {
    name: '其他文章',
    children: [
      {
        name: 'Frame 和 window',
        children: [
          {
            name: '弹窗和 window 的方法',
            url: '/popup-windows'
          },
          {
            name: '跨窗口通信',
            url: '/cross-window-communication'
          },
          {
            name: '点击劫持攻击',
            url: '/clickjacking'
          }
        ]
      },
      {
        name: '二进制数据，文件',
        children: [
          {
            name: 'ArrayBuffer，二进制数组',
            url: '/arraybuffer-binary-arrays'
          },
          {
            name: 'TextDecoder 和 TextEncoder',
            url: '/text-decoder'
          },
          {
            name: 'Blob',
            url: '/blob'
          },
          {
            name: 'File 和 FileReader',
            url: '/file'
          }
        ]
      },
      {
        name: '网络请求',
        children: [
          {
            name: 'Fetch',
            url: '/fetch'
          },
          {
            name: 'FormData',
            url: '/formdata'
          },
          {
            name: 'Fetch：下载进度',
            url: '/fetch-progress'
          },
          {
            name: 'Fetch：中止（Abort）',
            url: '/fetch-abort'
          },
          {
            name: 'Fetch：跨源请求',
            url: '/fetch-crossorigin'
          },
          {
            name: 'Fetch API',
            url: '/fetch-api'
          },
          {
            name: 'URL 对象',
            url: '/url'
          },
          {
            name: 'XMLHttpRequest',
            url: '/xmlhttprequest'
          },
          {
            name: '可恢复的文件上传',
            url: '/resume-upload'
          },
          {
            name: '长轮询（Long polling）',
            url: '/long-polling'
          },
          {
            name: 'WebSocket',
            url: '/websocket'
          },
          {
            name: 'Server Sent Events',
            url: '/server-sent-events'
          }
        ]
      },
      {
        name: '在浏览器中存储数据',
        children: [
          {
            name: 'Cookie，document.cookie',
            url: '/cookie'
          },
          {
            name: 'LocalStorage，sessionStorage',
            url: '/localstorage'
          },
          {
            name: 'IndexedDB',
            url: '/indexeddb'
          }
        ]
      },
      {
        name: '动画',
        children: [
          {
            name: '贝塞尔曲线',
            url: '/bezier-curve'
          },
          {
            name: 'CSS 动画',
            url: '/css-animations'
          },
          {
            name: 'JavaScript 动画',
            url: '/js-animation'
          }
        ]
      },
      {
        name: 'Web components',
        children: [
          {
            name: '从星球轨道的高度讲起',
            url: '/webcomponents-intro'
          },
          {
            name: 'Custom elements',
            url: '/custom-elements'
          },
          {
            name: '影子 DOM（Shadow DOM）',
            url: '/shadow-dom'
          },
          {
            name: '模板元素',
            url: '/template-element'
          },
          {
            name: 'Shadow DOM 插槽，组成',
            url: '/slots-composition'
          },
          {
            name: '给 Shadow DOM 添加样式',
            url: '/shadow-dom-style'
          },
          {
            name: 'Shadow DOM 和事件（events）',
            url: '/shadow-dom-events'
          }
        ]
      },
      {
        name: '正则表达式',
        children: [
          {
            name: '模式（Patterns）和修饰符（flags）',
            url: '/regexp-introduction'
          },
          {
            name: '字符类',
            url: '/regexp-character-classes'
          },
          {
            name: 'Unicode：修饰符 "u" 和类 \\p{...}',
            url: '/regexp-unicode'
          },
          {
            name: '锚点：字符串开始 ^ 和末尾 $',
            url: '/regexp-anchors'
          },
          {
            name: '锚点 ^ $ 的多行模式，修饰符 "m"',
            url: '/regexp-multiline-mode'
          },
          {
            name: '词边界：\\b',
            url: '/regexp-boundary'
          },
          {
            name: '转义，特殊字符',
            url: '/regexp-escaping'
          },
          {
            name: '集合和范围 [...]',
            url: '/regexp-character-sets-and-ranges'
          },
          {
            name: '量词 +, *, ? 和 {n}',
            url: '/regexp-quantifiers'
          },
          {
            name: '贪婪量词和惰性量词',
            url: '/regexp-greedy-and-lazy'
          },
          {
            name: '捕获组',
            url: '/regexp-groups'
          },
          {
            name: '模式中的反向引用：\\N 和 \\k<name>',
            url: '/regexp-backreferences'
          },
          {
            name: '选择 (OR) |',
            url: '/regexp-alternation'
          },
          {
            name: '前瞻断言与后瞻断言',
            url: '/regexp-lookahead-lookbehind'
          },
          {
            name: '灾难性回溯',
            url: '/regexp-catastrophic-backtracking'
          },
          {
            name: '粘性修饰符 "y"，在位置处搜索',
            url: '/regexp-sticky'
          },
          {
            name: '正则表达式和字符串的方法',
            url: '/regexp-methods'
          }
        ]
      }
    ]
  }
]

// 获取下一个工作日的日期
function getNextWorkingDay(date) {
  const nextDate = new Date(date)
  nextDate.setDate(nextDate.getDate() + 1)
  if (nextDate.getDay() === 0) {
    // 如果是周日，则跳到下一个周一
    nextDate.setDate(nextDate.getDate() + 1)
  } else if (nextDate.getDay() === 6) {
    // 如果是周六，则跳到下一个周一
    nextDate.setDate(nextDate.getDate() + 2)
  }
  return nextDate
}

// 递归生成学习计划
function generateStudyPlan(tree, startDate, indent = '') {
  const studyPlan = []
  let count = 0
  function traverse(node, currentIndent, parentOrder, order) {
    const mdList = '* [ ] '
    const orderStr = [parentOrder, order].filter(item => item).join('.')
    const headerStr = mdList + orderStr
    node.name = `${'`' + node.name + '`'}`
    if (!node.children || node.children.length === 0) {
      // 小节节点
      studyPlan.push({ name: `${currentIndent}${headerStr} ${node.name}`, date: startDate, url: node.url })
      count++
      if (count === 5) {
        startDate = getNextWorkingDay(startDate)
        count = 0
      }
    } else {
      // 大章节或中间层级节点
      studyPlan.push({ name: `${currentIndent}${headerStr} ${node.name}` })
    }

    const childIndent = currentIndent + '  '
    if (node.children) {
      node.children.forEach((item, index) => {
        traverse(item, childIndent, orderStr, index + 1)
      })
    }
  }
  tree.forEach((item, index) => {
    traverse(item, indent, undefined, index + 1)
  })

  return studyPlan
}

// 从今天开始安排学习计划
const startDate = new Date()

// 生成学习计划
const studyPlan = generateStudyPlan(tree, startDate)

let studyPlanStr = ''
// 打印学习计划
for (const { name, date, url } of studyPlan) {
  const formattedDate = date ? date.toLocaleDateString('zh-CN') : ''
  studyPlanStr += `${name}${date ? ` (${formattedDate})` : ''}${url ? '[点击]' + `(${prefixUrl + url})` : ''}\n`
  // console.log(`${name}${date ? ` (${formattedDate})` : ''}`)
}

console.log('studyPlanStr:\n', studyPlanStr)
```