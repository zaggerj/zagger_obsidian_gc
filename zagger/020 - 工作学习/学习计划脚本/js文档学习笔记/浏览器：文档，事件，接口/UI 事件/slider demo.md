---
alias:
tags: 长青笔记
cdate: 2023-12-21 11:57
uid: 20231221115756
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. slider demo

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-21 星期四 11:57:55

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
        .slider {
            border-radius: 5px;
            background: #E0E0E0;
            background: linear-gradient(left top, #E0E0E0, #EEEEEE);
            width: 310px;
            height: 15px;
            margin: 5px;
        }

        .thumb {
            width: 10px;
            height: 25px;
            border-radius: 3px;
            position: relative;
            left: 10px;
            top: -5px;
            background: blue;
            cursor: pointer;
        }

    </style>
</head>

<body>

    <body>

        <div id="slider"
             class="slider">
            <div class="thumb"
                 style="left: 0px;"></div>
        </div>

        <script>
            let thumb = slider.querySelector('.thumb')

            thumb.onmousedown = function (event) {
                event.preventDefault() // prevent selection start (browser action)

                let shiftX = event.clientX - thumb.getBoundingClientRect().left
                // shiftY not needed, the thumb moves only horizontally

                document.addEventListener('mousemove', onMouseMove)
                document.addEventListener('mouseup', onMouseUp)

                function onMouseMove(event) {
                    let newLeft = event.clientX - shiftX - slider.getBoundingClientRect().left

                    // the pointer is out of slider => lock the thumb within the bounaries
                    if (newLeft < 0) {
                        newLeft = 0
                    }
                    let rightEdge = slider.offsetWidth - thumb.offsetWidth
                    if (newLeft > rightEdge) {
                        newLeft = rightEdge
                    }

                    thumb.style.left = newLeft + 'px'
                }

                function onMouseUp() {
                    document.removeEventListener('mouseup', onMouseUp)
                    document.removeEventListener('mousemove', onMouseMove)
                }

            }

            thumb.ondragstart = function () {
                return false
            };

        </script>



    </body>

</body>

</html>

```
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
