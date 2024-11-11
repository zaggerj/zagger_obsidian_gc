---
alias:
tags: 长青笔记
cdate: 2023-12-21 11:01
uid: 20231221110154
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. html5 拖拽 demo

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-21 星期四 11:01:52

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        div {
            margin: 0em;
            padding: 2em;
        }

        #src_copy,
        #src_move {
            color: blue;
            border: 5px solid black;
            max-width: 300px;
            width: fit-content;
            height: 50px;
        }

        #dest_copy,
        #dest_move {
            border: 5px solid blue;
            width: 300px;
            min-height: 50px;
        }

    </style>
    <script>
        function dragstart_handler(ev) {
            console.log('dragstart')
            ev.currentTarget.style.border = 'dashed'
            ev.dataTransfer.setData('text', ev.target.id)
            ev.effectAllowed = "copyMove"
        }
        function dragover_handler(ev) {
            // 此处不阻止默认事件，dragstart中设置的ev.effectAllowed="copyMove"不生效。原因需要找下
            console.log('dragover')
            ev.currentTarget.style.background = 'lightblue'
            ev.preventDefault()

        }
        function dragleave_handler(ev) {
            console.log('dragleave')
            ev.target.style.background = ""
        }
        function drop_handler(ev) {
            console.log('drop')
            ev.preventDefault()
            var id = ev.dataTransfer.getData('text')
            if (id === 'src_move' && ev.target.id === 'dest_move') {
                ev.target.append(document.getElementById(id))
            }
            if (id === 'src_copy' && ev.target.id === 'dest_copy') {
                var cloneNode = document.getElementById(id).cloneNode(true)
                cloneNode.id = "newId"
                ev.target.append(cloneNode)
            }

        }
        function dragend_handler(ev) {
            console.log('dragend')
            ev.target.style.border = 'solid black'
        }
    </script>
</head>

<body>
    <h1>Drag and Drop: Copy and Move elements with <code>DataTransfer</code></h1>
    <div draggable="true"
         id="src_copy"
         ondragstart="dragstart_handler(event);"
         ondragend="dragend_handler(event);">
        Select this element and drag to the <strong>Copy Drop Zone</strong>.
    </div>
    <div id="dest_copy"
         ondrop="drop_handler(event);"
         ondragleave="dragleave_handler(event);"
         ondragover="dragover_handler(event);"><strong>Copy Drop Zone</strong></div>
    <div draggable="true"
         id="src_move"
         ondragstart="dragstart_handler(event);"
         ondragend="dragend_handler(event);">
        Select this element and drag to the <strong>Move Drop Zone</strong>.
    </div>
    <div id="dest_move"
         ondrop="drop_handler(event);"
         ondragleave="dragleave_handler(event);"
         ondragover="dragover_handler(event);"><strong>Move Drop Zone</strong></div>
</body>

</html>

```
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
[HTML 拖放 API - Web API 接口参考 | MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/HTML_Drag_and_Drop_API#%E6%8E%A5%E5%8F%A3)