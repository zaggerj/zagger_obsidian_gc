---
alias:
tags: 长青笔记
cdate: 2023-12-20 17:05
uid: 20231220170510
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. 移动鼠标：mouseover/out，mouseenter/leave

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-20 星期三 17:05:08

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231221112534.png)

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

### 1.4.1. 移动鼠标：mouseover/out，mouseenter/leave

我们将深入研究鼠标在元素之间移动时发生的事件。

### 1.4.2. [事件 mouseover/mouseout，relatedTarget](https://zh.javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave#shi-jian-mouseovermouseoutrelatedtarget)

当鼠标指针移到某个元素上时，`mouseover` 事件就会发生，而当鼠标离开该元素时，`mouseout` 事件就会发生。
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220170730.png)

这些事件很特别，因为它们具有 `relatedTarget` 属性。此属性是对 `target` 的补充。当鼠标从一个元素离开并去往另一个元素时，其中一个元素就变成了 `target`，另一个就变成了 `relatedTarget`。

对于 `mouseover`：

- `event.target` —— 是鼠标移过的那个元素。
- `event.relatedTarget` —— 是鼠标来自的那个元素（`relatedTarget` → `target`）。

`mouseout` 则与之相反：

- `event.target` —— 是鼠标离开的元素。
- `event.relatedTarget` —— 是鼠标移动到的，当前指针位置下的元素（`target` → `relatedTarget`）。

在下面这个示例中，每张脸及其功能都是单独的元素。当你移动鼠标时，你可以在文本区域中看到鼠标事件。

每个事件都具有关于 `target` 和 `relatedTarget` 的信息：
```html
index.html
<!DOCTYPE HTML>
<html>

<head>
  <meta charset="utf-8">
  <link rel="stylesheet" href="style.css">
</head>

<body>

  <div id="container">
    <div class="smiley-green">
      <div class="left-eye"></div>
      <div class="right-eye"></div>
      <div class="smile"></div>
    </div>

    <div class="smiley-yellow">
      <div class="left-eye"></div>
      <div class="right-eye"></div>
      <div class="smile"></div>
    </div>

    <div class="smiley-red">
      <div class="left-eye"></div>
      <div class="right-eye"></div>
      <div class="smile"></div>
    </div>
  </div>

  <textarea id="log">Events will show up here!
</textarea>

  <script src="script.js"></script>

</body>
</html>
relatedTarget 可以为 null
```

```css
style.css
body,
html {
  margin: 0;
  padding: 0;
}

#container {
  border: 1px solid brown;
  padding: 10px;
  width: 330px;
  margin-bottom: 5px;
  box-sizing: border-box;
}

#log {
  height: 120px;
  width: 350px;
  display: block;
  box-sizing: border-box;
}

[class^="smiley-"] {
  display: inline-block;
  width: 70px;
  height: 70px;
  border-radius: 50%;
  margin-right: 20px;
}

.smiley-green {
  background: #a9db7a;
  border: 5px solid #92c563;
  position: relative;
}

.smiley-green .left-eye {
  width: 18%;
  height: 18%;
  background: #84b458;
  position: relative;
  top: 29%;
  left: 22%;
  border-radius: 50%;
  float: left;
}

.smiley-green .right-eye {
  width: 18%;
  height: 18%;
  border-radius: 50%;
  position: relative;
  background: #84b458;
  top: 29%;
  right: 22%;
  float: right;
}

.smiley-green .smile {
  position: absolute;
  top: 67%;
  left: 16.5%;
  width: 70%;
  height: 20%;
  overflow: hidden;
}

.smiley-green .smile:after,
.smiley-green .smile:before {
  content: "";
  position: absolute;
  top: -50%;
  left: 0%;
  border-radius: 50%;
  background: #84b458;
  height: 100%;
  width: 97%;
}

.smiley-green .smile:after {
  background: #84b458;
  height: 80%;
  top: -40%;
  left: 0%;
}

.smiley-yellow {
  background: #eed16a;
  border: 5px solid #dbae51;
  position: relative;
}

.smiley-yellow .left-eye {
  width: 18%;
  height: 18%;
  background: #dba652;
  position: relative;
  top: 29%;
  left: 22%;
  border-radius: 50%;
  float: left;
}

.smiley-yellow .right-eye {
  width: 18%;
  height: 18%;
  border-radius: 50%;
  position: relative;
  background: #dba652;
  top: 29%;
  right: 22%;
  float: right;
}

.smiley-yellow .smile {
  position: absolute;
  top: 67%;
  left: 19%;
  width: 65%;
  height: 14%;
  background: #dba652;
  overflow: hidden;
  border-radius: 8px;
}

.smiley-red {
  background: #ee9295;
  border: 5px solid #e27378;
  position: relative;
}

.smiley-red .left-eye {
  width: 18%;
  height: 18%;
  background: #d96065;
  position: relative;
  top: 29%;
  left: 22%;
  border-radius: 50%;
  float: left;
}

.smiley-red .right-eye {
  width: 18%;
  height: 18%;
  border-radius: 50%;
  position: relative;
  background: #d96065;
  top: 29%;
  right: 22%;
  float: right;
}

.smiley-red .smile {
  position: absolute;
  top: 57%;
  left: 16.5%;
  width: 70%;
  height: 20%;
  overflow: hidden;
}

.smiley-red .smile:after,
.smiley-red .smile:before {
  content: "";
  position: absolute;
  top: 50%;
  left: 0%;
  border-radius: 50%;
  background: #d96065;
  height: 100%;
  width: 97%;
}

.smiley-red .smile:after {
  background: #d96065;
  height: 80%;
  top: 60%;
  left: 0%;
}
```

```js
script.js
container.onmouseover = container.onmouseout = handler;

function handler(event) {

  function str(el) {
    if (!el) return "null"
    return el.className || el.tagName;
  }

  log.value += event.type + ':  ' +
    'target=' + str(event.target) +
    ',  relatedTarget=' + str(event.relatedTarget) + "\n";
  log.scrollTop = log.scrollHeight;

  if (event.type == 'mouseover') {
    event.target.style.background = 'pink'
  }
  if (event.type == 'mouseout') {
    event.target.style.background = ''
  }
}
relatedTarget 可以为 null
```

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220171119.png)

**`relatedTarget` 可以为 `null`**

`relatedTarget` 属性可以为 `null`。

这是正常现象，仅仅是意味着鼠标不是来自另一个元素，而是来自窗口之外。或者它离开了窗口。

当我们在代码中使用 `event.relatedTarget` 时，我们应该牢记这种可能性。如果我们访问 `event.relatedTarget.tagName`，那么就会出现错误。


### 1.4.3. [跳过元素](https://zh.javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave#tiao-guo-yuan-su)

<mark style="background: #FF5582A6;">小结：mouseover/out/move会跳过元素，但是如果 `mouseover` 被触发了，则必须有 `mouseout`
</mark>

当鼠标移动时，就会触发 `mousemove` 事件。但这并不意味着每个像素都会导致一个事件。

浏览器会一直检查鼠标的位置。如果发现了变化，就会触发事件。

这意味着，如果访问者非常快地移动鼠标，那么某些 DOM 元素就可能被跳过：
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220171329.png)
如果鼠标从上图所示的 `#FROM` 快速移动到 `#TO` 元素，则中间的 `<div>`（或其中的一些）元素可能会被跳过。`mouseout` 事件可能会在 `#FROM` 上被触发，然后立即在 `#TO` 上触发 `mouseover`。

这对性能很有好处，因为可能有很多中间元素。我们并不真的想要处理每一个移入和离开的过程。

另一方面，我们应该记住，鼠标指针并不会“访问”所有元素。它可以“跳过”一些元素。

特别是，鼠标指针可能会从窗口外跳到页面的中间。在这种情况下，`relatedTarget` 为 `null`，因为它是从石头缝里蹦出来的（nowhere）：
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220171458.png)
你可以在下面的测试台中“实时”查看。

它的 HTML 有两个嵌套的元素：`<div id="child">` 在 `<div id="parent">` 内部。如果将鼠标快速移动到它们上，则可能只有 `<div id="child">` 或者只有 `<div id="parent">` 触发事件，或者根本没有事件触发。

还可以将鼠标指针移动到 `<div id="child">` 中，然后将其快速向下移动过其父级元素。如果移动速度足够快，则父元素就会被忽略。鼠标会越过父元素而不会引起其注意。

```html
index.html
<!doctype html>
<html>

<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="style.css">
</head>

<body>

  <div id="parent">parent
    <div id="child">child</div>
  </div>
  <textarea id="text"></textarea>
  <input onclick="clearText()" value="Clear" type="button">

  <script src="script.js"></script>

</body>

</html>
```

```css
style.css
#parent {
  background: #99C0C3;
  width: 160px;
  height: 120px;
  position: relative;
}

#child {
  background: #FFDE99;
  width: 50%;
  height: 50%;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

textarea {
  height: 140px;
  width: 300px;
  display: block;
}
```

```js
script.js
let parent = document.getElementById('parent');
parent.onmouseover = parent.onmouseout = parent.onmousemove = handler;

function handler(event) {
  let type = event.type;
  while (type.length < 11) type += ' ';

  log(type + " target=" + event.target.id)
  return false;
}


function clearText() {
  text.value = "";
  lastMessage = "";
}

let lastMessageTime = 0;
let lastMessage = "";
let repeatCounter = 1;

function log(message) {
  if (lastMessageTime == 0) lastMessageTime = new Date();

  let time = new Date();

  if (time - lastMessageTime > 500) {
    message = '------------------------------\n' + message;
  }

  if (message === lastMessage) {
    repeatCounter++;
    if (repeatCounter == 2) {
      text.value = text.value.trim() + ' x 2\n';
    } else {
      text.value = text.value.slice(0, text.value.lastIndexOf('x') + 1) + repeatCounter + "\n";
    }

  } else {
    repeatCounter = 1;
    text.value += message + "\n";
  }

  text.scrollTop = text.scrollHeight;

  lastMessageTime = time;
  lastMessage = message;
}
```


**如果 `mouseover` 被触发了，则必须有 `mouseout`**

在鼠标快速移动的情况下，中间元素可能会被忽略，但是我们可以肯定一件事：如果鼠标指针“正式地”进入了一个元素（生成了 `mouseover` 事件），那么一旦它离开，我们就会得到 `mouseout`。


### 1.4.4. [当移动到一个子元素时 mouseout](https://zh.javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave#dang-yi-dong-dao-yi-ge-zi-yuan-su-shi-mouseout)

<mark style="background: #FF5582A6;">小结：mouseout/over会冒泡，从父元素到子元素上，会触发父元素的mouseout事件，然后触发子元素的mouseover事件</mark>

`mouseout` 的一个重要功能 —— **当鼠标指针从元素移动到其后代时触发**，例如在下面的这个 HTML 中，从 `#parent` 到 `#child`：
```html
<div id="parent">
  <div id="child">...</div>
</div>
```
如果我们在 `#parent` 上，然后将鼠标指针更深入地移入 `#child`，在 `#parent` 上我们会得到 `mouseout`！
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220172300.png)
这听起来很奇怪，但很容易解释。

**根据浏览器的逻辑，鼠标指针随时可能位于单个元素上 —— 嵌套最多的那个元素（z-index 最大的那个）。**

因此，如果它转到另一个元素（甚至是一个后代），那么它将离开前一个元素。

请注意事件处理的另一个重要的细节。

**后代的 `mouseover` 事件会冒泡。** 因此，如果 `#parent` 具有 `mouseover` 处理程序，它将被触发：
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220172355.png)
你可以在下面这个示例中很清晰地看到这一点：`<div id="child">` 位于 `<div id="parent">` 内部。`#parent` 元素上有 `mouseover/out` 的处理程序，这些处理程序用于输出事件详细信息。

如果你将鼠标从 `#parent` 移动到 `#child`，那么你会看到在 `#parent` 上有两个事件:

1. `mouseout [target: parent]`（离开 parent），然后
2. `mouseover [target: child]`（来到 child，冒泡）。

```html
index.html
<!doctype html>
<html>

<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="style.css">
</head>

<body>

  <div id="parent" onmouseover="mouselog(event)" onmouseout="mouselog(event)">parent
    <div id="child">child</div>
  </div>

  <textarea id="text"></textarea>
  <input type="button" onclick="text.value=''" value="Clear">

  <script src="script.js"></script>

</body>

</html>
```

```css
style.css
#parent {
  background: #99C0C3;
  width: 160px;
  height: 120px;
  position: relative;
}

#child {
  background: #FFDE99;
  width: 50%;
  height: 50%;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

textarea {
  height: 140px;
  width: 300px;
  display: block;
}
```


```js
script.js
function mouselog(event) {
  let d = new Date();
  text.value += `${d.getHours()}:${d.getMinutes()}:${d.getSeconds()} | ${event.type} [target: ${event.target.id}]\n`.replace(/(:|^)(\d\D)/, '$10$2');
  text.scrollTop = text.scrollHeight;
}
```
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220172802.png)
如上例所示，当鼠标指针从 `#parent` 元素移动到 `#child` 时，会在父元素上触发两个处理程序：`mouseout` 和 `mouseover`：

```js
parent.onmouseout = function(event) {
  /* event.target: parent element */
};
parent.onmouseover = function(event) {
  /* event.target: child element (bubbled) */
};
```
**如果我们不检查处理程序中的 `event.target`，那么似乎鼠标指针离开了 `#parent` 元素，然后立即回到了它上面。**

但是事实并非如此！鼠标指针仍然位于父元素上，它只是更深入地移入了子元素。

如果离开父元素时有一些行为（action），例如一个动画在 `parent.onmouseout` 中运行，当鼠标指针深入 `#parent` 时，我们并不希望发生这种行为。

为了避免它，我们可以在处理程序中检查 `relatedTarget`，如果鼠标指针仍在元素内，则忽略此类事件。*mouseout事件处理函数中中如果target是parent，child，就是还在parent内，return掉*

另外，我们可以使用其他事件：`mouseenter` 和 `mouseleave`，它们没有此类问题，接下来我们就对其进行详细介绍。****


### 1.4.5. [事件 mouseenter 和 mouseleave](https://zh.javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave#shi-jian-mouseenter-he-mouseleave)

事件 `mouseenter/mouseleave` 类似于 `mouseover/mouseout`。它们在鼠标指针进入/离开元素时触发。

但是有两个重要的区别：

1. 元素内部与后代之间的转换不会产生影响。
2. 事件 `mouseenter/mouseleave` 不会冒泡。

这些事件非常简单。

当鼠标指针进入一个元素时 —— 会触发 `mouseenter`。而鼠标指针在元素或其后代中的确切位置无关紧要。

当鼠标指针离开该元素时，事件 `mouseleave` 才会触发。

这个例子和上面的例子相似，但是现在最顶部的元素有 `mouseenter/mouseleave` 而不是 `mouseover/mouseout`。

正如你所看到的，唯一生成的事件是与将鼠标指针移入或移出顶部元素有关的事件。当鼠标指针进入 child 并返回时，什么也没发生。在后代之间的移动会被忽略。


```html index.html
<!doctype html>
<html>

<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="style.css">
</head>

<body>

  <div id="parent" onmouseenter="mouselog(event)" onmouseleave="mouselog(event)">parent
    <div id="child">child</div>
  </div>

  <textarea id="text"></textarea>
  <input type="button" onclick="text.value=''" value="Clear">

  <script src="script.js"></script>

</body>

</html>
```

```css style.css
#parent {
  background: #99C0C3;
  width: 160px;
  height: 120px;
  position: relative;
}

#child {
  background: #FFDE99;
  width: 50%;
  height: 50%;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

textarea {
  height: 140px;
  width: 300px;
  display: block;
}
```

```js script.js
function mouselog(event) {
  let d = new Date();
  text.value += `${d.getHours()}:${d.getMinutes()}:${d.getSeconds()} | ${event.type} [target: ${event.target.id}]\n`.replace(/(:|^)(\d\D)/, '$10$2');
  text.scrollTop = text.scrollHeight;
}
```

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220175001.png)
### 1.4.6. [事件委托](https://zh.javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave#shi-jian-wei-tuo)
<mark style="background: #FF5582A6;">小结：事件委托只能使用mouseover、mouseout</mark>

事件 `mouseenter/leave` 非常简单且易用。但它们不会冒泡。因此，我们不能使用它们来进行事件委托。

假设我们要处理表格的单元格的鼠标进入/离开。并且这里有数百个单元格。

通常的解决方案是 —— 在 `<table>` 中设置处理程序，并在那里处理事件。但 `mouseenter/leave` 不会冒泡。因此，如果类似的事件发生在 `<td>` 上，那么只有 `<td>` 上的处理程序才能捕获到它。

`<table>` 上的 `mouseenter/leave` 的处理程序仅在鼠标指针进入/离开整个表格时才会触发。无法获取有关其内部移动的任何信息。

因此，让我们使用 `mouseover/mouseout`。

让我们从高亮显示鼠标指针下的元素的简单处理程序开始：

```js
// 高亮显示鼠标指针下的元素
table.onmouseover = function(event) {
  let target = event.target;
  target.style.background = 'pink';
};

table.onmouseout = function(event) {
  let target = event.target;
  target.style.background = '';
};
```

现在它们已经激活了。当鼠标在下面这个表格的各个元素上移动时，当前位于鼠标指针下的元素会被高亮显示：
```html index.html 
<!DOCTYPE HTML>
<html>

<head>
  <meta charset="utf-8">
  <link rel="stylesheet" href="style.css">
</head>

<body>


  <table id="table">
    <tr>
      <th colspan="3"><em>Bagua</em> Chart: Direction, Element, Color, Meaning</th>
    </tr>
    <tr>
      <td class="nw"><strong>Northwest</strong>
        <br>Metal
        <br>Silver
        <br>Elders
      </td>
      <td class="n"><strong>North</strong>
        <br>Water
        <br>Blue
        <br>Change
      </td>
      <td class="ne"><strong>Northeast</strong>
        <br>Earth
        <br>Yellow
        <br>Direction
      </td>
    </tr>
    <tr>
      <td class="w"><strong>West</strong>
        <br>Metal
        <br>Gold
        <br>Youth
      </td>
      <td class="c"><strong>Center</strong>
        <br>All
        <br>Purple
        <br>Harmony
      </td>
      <td class="e"><strong>East</strong>
        <br>Wood
        <br>Blue
        <br>Future
      </td>
    </tr>
    <tr>
      <td class="sw"><strong>Southwest</strong>
        <br>Earth
        <br>Brown
        <br>Tranquility
      </td>
      <td class="s"><strong>South</strong>
        <br>Fire
        <br>Orange
        <br>Fame
      </td>
      <td class="se"><strong>Southeast</strong>
        <br>Wood
        <br>Green
        <br>Romance
      </td>
    </tr>

  </table>

  <textarea id="text"></textarea>

  <input type="button" onclick="text.value=''" value="Clear">

  <script src="script.js"></script>

</body>
</html>
```

```css style.css
#text {
  display: block;
  height: 100px;
  width: 456px;
}

#table th {
  text-align: center;
  font-weight: bold;
}

#table td {
  width: 150px;
  white-space: nowrap;
  text-align: center;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 12px;
  cursor: pointer;
}

#table .nw {
  background: #999;
}

#table .n {
  background: #03f;
  color: #fff;
}

#table .ne {
  background: #ff6;
}

#table .w {
  background: #ff0;
}

#table .c {
  background: #60c;
  color: #fff;
}

#table .e {
  background: #09f;
  color: #fff;
}

#table .sw {
  background: #963;
  color: #fff;
}

#table .s {
  background: #f60;
  color: #fff;
}

#table .se {
  background: #0c3;
  color: #fff;
}

#table .highlight {
  background: red;
}
```

```js script.js
table.onmouseover = function(event) {
  let target = event.target;
  target.style.background = 'pink';

  text.value += `over -> ${target.tagName}\n`;
  text.scrollTop = text.scrollHeight;
};

table.onmouseout = function(event) {
  let target = event.target;
  target.style.background = '';

  text.value += `out <- ${target.tagName}\n`;
  text.scrollTop = text.scrollHeight;
};
```

![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220180517.png)
在我们的例子中，我们想要处理表格的单元格 `<td>` 之间的移动：进入一个单元格并离开它。我们对其他移动并不感兴趣，例如在单元格内部或在所有单元格的外部。让我们把这些过滤掉。

我们可以这样做：

- 在变量中记住当前被高亮显示的 `<td>`，让我们称它为 `currentElem`。
- `mouseover` —— 如果我们仍然在当前的 `<td>` 中，则忽略该事件。
- `mouseout` —— 如果没有离开当前的 `<td>`，则忽略。

这是说明所有可能情况的代码示例：

```js
// 现在位于鼠标下方的 <td>（如果有）
let currentElem = null;

table.onmouseover = function(event) {
  // 在进入一个新的元素前，鼠标总是会先离开前一个元素
  // 如果设置了 currentElem，那么我们就没有鼠标所悬停在的前一个 <td>，
  // 忽略此事件
  if (currentElem) return;

  let target = event.target.closest('td');

  // 我们移动到的不是一个 <td> —— 忽略
  if (!target) return;

  // 现在移动到了 <td> 上，但在处于了我们表格的外部（可能因为是嵌套的表格）
  // 忽略
  if (!table.contains(target)) return;

  // 给力！我们进入了一个新的 <td>
  currentElem = target;
  onEnter(currentElem);
};


table.onmouseout = function(event) {
  // 如果我们现在处于所有 <td> 的外部，则忽略此事件
  // 这可能是一个表格内的移动，但是在 <td> 外，
  // 例如从一个 <tr> 到另一个 <tr>
  if (!currentElem) return;

  // 我们将要离开这个元素 —— 去哪儿？可能是去一个后代？
  let relatedTarget = event.relatedTarget;

  while (relatedTarget) {
    // 到父链上并检查 —— 我们是否还在 currentElem 内
    // 然后发现，这只是一个内部移动 —— 忽略它
    if (relatedTarget == currentElem) return;

    relatedTarget = relatedTarget.parentNode;
  }

  // 我们离开了 <td>。真的。
  onLeave(currentElem);
  currentElem = null;
};

// 任何处理进入/离开一个元素的函数
function onEnter(elem) {
  elem.style.background = 'pink';

  // 在文本区域显示它
  text.value += `over -> ${currentElem.tagName}.${currentElem.className}\n`;
  text.scrollTop = 1e6;
}

function onLeave(elem) {
  elem.style.background = '';

  // 在文本区域显示它
  text.value += `out <- ${elem.tagName}.${elem.className}\n`;
  text.scrollTop = 1e6;
}
```

再次，重要的功能是：

1. 它使用事件委托来处理表格中任何 `<td>` 的进入/离开。因此，它依赖于 `mouseover/out` 而不是 `mouseenter/leave`，`mouseenter/leave` 不会冒泡，因此也不允许事件委托。
2. 额外的事件，例如在 `<td>` 的后代之间移动都会被过滤掉，因此 `onEnter/Leave` 仅在鼠标指针进入/离开 `<td>` 整体时才会运行。

这是带有所有详细信息的完整示例：
![image.png](https://raw.githubusercontent.com/zaggerj/obsidian_picgo/main/obsidian/20231220180834.png)


尝试将鼠标指针移入和移出表格单元格及其内部。快还是慢都没关系。与前面的示例不同，只有 `<td>` 被作为一个整体高亮显示。

### 1.4.7. [总结](https://zh.javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave#zong-jie)

我们讲了 `mouseover`，`mouseout`，`mousemove`，`mouseenter` 和 `mouseleave` 事件。

以下这些内容要注意：

- 快速移动鼠标可能会跳过中间元素。
- `mouseover/out` 和 `mouseenter/leave` 事件还有一个附加属性：`relatedTarget`。这就是我们来自/到的元素，是对 `target` 的补充。

即使我们从父元素转到子元素时，也会触发 `mouseover/out` 事件。浏览器假定鼠标一次只会位于一个元素上 —— 最深的那个。

`mouseenter/leave` 事件在这方面不同：它们仅在鼠标进入和离开元素时才触发。并且它们不会冒泡。
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
