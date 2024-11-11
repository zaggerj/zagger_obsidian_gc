---
alias:
tags: 长青笔记
cdate: 2023-12-13 11:46
uid: 20231213114649
searchterm: "#长青笔记"
banner: "040 - Obsidian/附件/banners/book-banner.gif"
cssclass: noyaml
banner_icon: 💌
banner_x: 0.5
banner_y: 0.38
---

# 1. app ui.js

## 1.1. Metadata

Status:: #笔记状态/🌱 发芽
Source Type:: #📥/💭 想法 
Note Type:: #笔记
Topic:: [[00.学习-前端]]
Author:: zagger
Source URL::
Modify:: 2023-12-13 星期三 11:46:04

## 1.2. 长青笔记

_一句话概括这篇笔记的内容_
Summary::

## 1.3. 自我重述

_用自己的话去重述提取的重点内容_

## 1.4. 重点摘抄

_摘抄部分原文后，进行筛选加粗然后对加粗的继续进行筛选荧光笔选出。_

这段代码是noVNC（HTML5 VNC客户端）的一部分，用于创建和管理用户界面（UI）的功能。以下是代码的主要功能和逻辑：

1. 导入所需的模块和文件：

```javascript
import * as Log from '../core/util/logging.js';
import _, { l10n } from './localization.js';
import { isTouchDevice, isMac, isIOS, isAndroid, isChromeOS, isSafari,
         hasScrollbarGutter, dragThreshold }
    from '../core/util/browser.js';
import { setCapture, getPointerEvent } from '../core/util/events.js';
import KeyTable from "../core/input/keysym.js";
import keysyms from "../core/input/keysymdef.js";
import Keyboard from "../core/input/keyboard.js";
import RFB from "../core/rfb.js";
import * as WebUtil from "./webutil.js";
```

这些模块和文件包含了日志记录、本地化、浏览器检测、事件处理、键盘输入、VNC连接等所需的功能。

2. 定义常量和变量：

```javascript
const PAGE_TITLE = "noVNC";

const UI = {
    connected: false,
    desktopName: "",
    statusTimeout: null,
    hideKeyboardTimeout: null,
    idleControlbarTimeout: null,
    closeControlbarTimeout: null,
    controlbarGrabbed: false,
    controlbarDrag: false,
    controlbarMouseDownClientY: 0,
    controlbarMouseDownOffsetY: 0,
    lastKeyboardinput: null,
    defaultKeyboardinputLen: 100,
    inhibitReconnect: true,
    reconnectCallback: null,
    reconnectPassword: null,
};
```

这些常量和变量用于存储与UI状态和操作相关的信息。

3. 定义UI对象的方法和功能：

- `prime()`: 初始化设置并开始UI的渲染和初始化。
- `start()`: 渲染默认UI并初始化设置菜单。
- `initFullscreen()`: 初始化全屏功能。
- `initSettings()`: 初始化设置选项。
- 其他辅助方法和事件处理程序，用于处理控制栏、键盘输入、连接控制等功能。

这段代码的目的是创建一个用户界面，提供一系列功能和设置选项，以便用户可以连接到VNC服务器并进行远程控制。它还包含一些辅助方法和事件处理程序，用于处理UI的交互和状态更新。

这段代码定义了一些事件处理程序，用于处理用户界面的交互和操作。以下是每个事件处理程序的功能：

- `setupSettingLabels()`: 为标签元素添加链接到相应输入元素的功能。它遍历所有的`<label>`元素，找到与之对应的输入元素，并将其链接到标签元素上。
    
- `addControlbarHandlers()`: 添加控制栏的事件处理程序。它为控制栏的各个元素（如鼠标移动、鼠标按下、键盘按下等）绑定事件监听器。
    
- `addTouchSpecificHandlers()`: 添加触摸设备特定的事件处理程序。它为触摸设备上的键盘、控制栏等元素绑定事件监听器，并处理触摸事件。
    
- `addExtraKeysHandlers()`: 添加额外按键的事件处理程序。它为额外按键的各个按钮（如切换额外按键、切换Ctrl键等）绑定事件监听器。
    
- `addMachineHandlers()`: 添加虚拟机相关的事件处理程序。它为虚拟机的各个按钮（如关机、重启、重置）绑定事件监听器。
    
- `addConnectionControlHandlers()`: 添加连接控制的事件处理程序。它为连接控制的各个按钮（如断开连接、连接、取消重连）绑定事件监听器，并处理连接相关的操作。
    

这些事件处理程序用于监听用户界面上的各种交互事件，并根据事件的类型和操作执行相应的功能和操作。通过这些事件处理程序，用户可以与用户界面进行交互，并控制VNC连接和虚拟机操作。

这段代码包含了一些用于管理用户界面的可视化操作的函数。

- `addSettingChangeHandler(name, changeFunc)`: 该函数用于为指定名称的设置项添加变化事件处理程序。它首先获取对应名称的设置元素，然后为其添加一个`change`事件监听器。当设置元素的值发生变化时，该事件处理程序将被触发。如果没有提供`changeFunc`参数，将默认调用`UI.saveSetting(name)`函数保存设置。
    
- `addSettingsHandlers()`: 该函数用于添加设置项的事件处理程序。它为各个设置项的元素添加变化事件处理程序，以便在设置项的值发生变化时执行相应的操作。
    
- `addFullscreenHandlers()`: 该函数用于添加全屏模式的事件处理程序。它为全屏按钮添加点击事件处理程序，并为窗口的全屏状态变化事件（如`fullscreenchange`、`mozfullscreenchange`、`webkitfullscreenchange`、`msfullscreenchange`）添加事件监听器。
    
- `updateVisualState(state)`: 该函数用于更新用户界面的可视状态，根据连接状态来禁用/启用控件。它根据传入的`state`参数来设置用户界面的类名，以显示相应的状态样式。它还根据连接状态来禁用/启用各个设置项，并执行一些与连接状态相关的操作。
    
- `showStatus(text, statusType, time)`: 该函数用于显示状态消息。它根据传入的`statusType`参数设置状态消息的样式，并将消息内容设置为传入的`text`参数。可选的`time`参数用于指定消息显示的持续时间，默认为1.5秒。该函数还会在一定时间后自动隐藏状态消息。
    
- `hideStatus()`: 该函数用于隐藏状态消息。它移除状态消息元素的打开类名，使其不再显示在用户界面中。
    

这些函数共同实现了用户界面的交互和可视化操作，使用户能够方便地进行设置、切换全屏模式，并根据连接状态显示相应的状态消息。

这段代码包含了一些用于控制和操作用户界面中控制栏的函数。

- `activateControlbar(event)`: 该函数用于激活控制栏。它清除之前设置的超时计时器，移除控制栏的空闲类名，并设置一个新的超时计时器来在一段时间后使控制栏进入空闲状态。
    
- `idleControlbar()`: 该函数用于使控制栏进入空闲状态。它检查控制栏是否有焦点，并判断页面是否处于焦点状态。如果控制栏或其子元素有焦点，并且页面处于焦点状态，则重新激活控制栏，否则给控制栏的锚点元素添加空闲类名，使其进入空闲状态。
    
- `keepControlbar()`: 该函数用于保持控制栏的显示状态。它清除之前设置的超时计时器，防止控制栏进入空闲状态。
    
- `openControlbar()`: 该函数用于打开控制栏。它给控制栏元素添加打开类名，以显示控制栏。
    
- `closeControlbar()`: 该函数用于关闭控制栏。它首先关闭所有的面板，然后移除控制栏元素的打开类名，以隐藏控制栏。最后，它将焦点设置回主显示区域。
    
- `toggleControlbar()`: 该函数用于切换控制栏的状态，即打开或关闭控制栏。它检查控制栏元素是否包含打开类名，如果是，则调用`closeControlbar()`关闭控制栏，否则调用`openControlbar()`打开控制栏。
    
- `toggleControlbarSide()`: 该函数用于切换控制栏的位置。它首先检查控制栏元素的显示状态，并根据当前位置添加或移除相应的类名。然后，它根据切换后的位置更新设置，并标记控制栏正在拖动。
    
- `showControlbarHint(show, animate=true)`: 该函数用于显示或隐藏控制栏提示。它根据传入的`show`参数来添加或移除提示元素的激活类名，并根据传入的`animate`参数来控制是否使用动画效果。
    
- `dragControlbarHandle(e)`: 该函数用于处理控制栏手柄的拖动操作。它首先检查控制栏是否被抓取，如果没有，则返回。然后，它获取拖动事件的指针位置，并根据位置判断是否需要切换控制栏的位置。接下来，它检查是否已经开始拖动操作，如果没有，则检查鼠标拖动的距离是否超过阈值，如果超过则标记为已开始拖动。最后，它根据拖动的位置移动控制栏手柄，并阻止事件的默认行为和冒泡，保持控制栏的显示状态，并激活控制栏。
    
- `moveControlbarHandle(viewportRelativeY)`: 该函数用于移动控制栏手柄的位置，并确保其不超出控制栏的边界。它获取手柄元素和控制栏元素的边界信息，并根据传入的`viewportRelativeY`参数计算出新的手柄位置。然后，它检查新位置是否超出控制栏的上边界和下边界，并在超出边界时进行修正。最后，它设置手柄元素的变换样式来实现移动效果。
    
- `updateControlbarHandle()`: 该函数用于更新控制栏手柄的位置。它获取手柄元素和控制栏元素的边界信息，并计算出手柄的当前位置。然后，它根据当前位置设置手柄元素的变换样式来更新手柄的位置。
    

这些函数可以用于控制用户界面中的控制栏，包括打开、关闭、切换位置、拖动等操作。根据具体的实现和使用情境，这些函数可能会被进一步扩展和调整。

这段代码是一个JavaScript对象或类的方法集合，可能是用于控制用户界面的某个应用程序或网页。它包含了一些用于处理设置、面板和控制按钮的方法。

代码中的一些关键方法包括：

1. `toggleExpander(e)`: 一个用于切换展开器状态的方法。它根据元素的类名进行切换，如果元素包含"class"为"noVNC_open"，则移除该类名，否则添加该类名。
    
2. `initSetting(name, defVal)`: 用于在页面加载时读取和初始化设置的方法。它首先检查查询字符串（Query string）中是否存在设置的值，如果不存在，则尝试从cookie中读取设置的值。然后使用`WebUtil.setSetting(name, val)`方法将值保存，并使用`UI.updateSetting(name)`方法更新设置控件的状态。
    
3. `forceSetting(name, val)`: 强制设置某个设置项的值，并更新设置控件的状态。它使用`WebUtil.setSetting(name, val)`方法将值保存，并使用`UI.updateSetting(name)`方法更新设置控件的状态。然后使用`UI.disableSetting(name)`方法禁用设置控件。
    
4. `updateSetting(name)`: 更新设置控件的状态。根据设置项的类型（复选框、下拉框或文本框），更新对应的控件。
    
5. `saveSetting(name)`: 将设置控件的值保存到cookie中的方法。根据设置控件的类型，获取对应的值，并使用`WebUtil.writeSetting(name, val)`方法将值保存到cookie中。
    
6. `getSetting(name)`: 从cookie中读取与设置控件兼容的设置项的方法。根据设置控件的类型，获取对应的值，并根据值的类型进行处理。
    
7. `disableSetting(name)`: 禁用设置控件的方法。通过获取设置控件的元素并设置`disabled`属性为`true`，同时添加一个名为"noVNC_disabled"的类名。
    
8. `enableSetting(name)`: 启用设置控件的方法。通过获取设置控件的元素并设置`disabled`属性为`false`，同时移除名为"noVNC_disabled"的类名。
    
9. `closeAllPanels()`: 关闭所有面板的方法。调用`UI.closeSettingsPanel()`、`UI.closePowerPanel()`、`UI.closeClipboardPanel()`和`UI.closeExtraKeys()`方法，分别关闭设置面板、电源面板、剪贴板面板和额外按键面板。
    

以上是代码中一些重要的方法的简要说明。代码的作用和具体实现可能还涉及其他部分，如果有需要，可以提供更多的代码进行进一步分析。

这段代码是一个JavaScript对象或类的方法集合，可能是用于控制用户界面的某个应用程序或网页。它包含了一些用于处理剪贴板和连接的方法。

代码中的一些关键方法包括：

1. `openClipboardPanel()`: 打开剪贴板面板的方法。它关闭所有面板，打开控制栏，然后通过添加类名"noVNC_open"和"noVNC_selected"来显示剪贴板面板和剪贴板按钮。

2. `closeClipboardPanel()`: 关闭剪贴板面板的方法。通过移除类名"noVNC_open"和"noVNC_selected"来隐藏剪贴板面板和剪贴板按钮。

3. `toggleClipboardPanel()`: 切换剪贴板面板的方法。如果剪贴板面板是显示的，则调用`closeClipboardPanel()`方法隐藏它；如果剪贴板面板是隐藏的，则调用`openClipboardPanel()`方法显示它。

4. `clipboardReceive(e)`: 接收剪贴板内容的方法。它获取剪贴板内容，并将其设置为指定元素的值。在这个例子中，剪贴板内容存储在id为"noVNC_clipboard_text"的元素中。

5. `clipboardSend()`: 发送剪贴板内容的方法。它获取指定元素的值，并将其作为剪贴板的内容发送。在这个例子中，剪贴板内容存储在id为"noVNC_clipboard_text"的元素中。

6. `openConnectPanel()`: 打开连接面板的方法。通过添加类名"noVNC_open"来显示连接面板。

7. `closeConnectPanel()`: 关闭连接面板的方法。通过移除类名"noVNC_open"来隐藏连接面板。

8. `connect(event, password)`: 连接到远程服务器的方法。它根据设置的主机、端口和路径构建连接的URL，并使用`RFB`对象进行连接。连接成功后，将触发"connect"事件，并调用`connectFinished`方法。

9. `disconnect()`: 断开连接的方法。它断开与远程服务器的连接，并更新用户界面的状态。

10. `reconnect()`: 重新连接到远程服务器的方法。它调用`connect`方法以重新建立连接。

11. `cancelReconnect()`: 取消重新连接的方法。它取消之前设置的重新连接回调，并更新用户界面的状态。

12. `connectFinished(e)`: 连接成功后的回调方法。它显示连接成功的消息，并更新用户界面的状态。

以上是代码中一些重要的方法的简要说明。代码的作用和具体实现可能还涉及其他部分，如果有需要，可以提供更多的代码进行进一步分析。
1. `disconnectFinished(e)`: 断开连接完成时的回调方法。它根据连接是否正常断开更新用户界面的状态，并显示相应的状态消息。
    
2. `securityFailed(e)`: 当连接安全性失败时的回调方法。它根据服务器返回的信息显示相应的错误状态消息。
    
3. `serverVerify(e)`: 服务器验证方法。它根据服务器返回的验证类型进行处理，如果是RSA类型，则计算服务器公钥的SHA-1指纹，并在用户界面上显示该指纹。
    
4. `approveServer(e)`: 批准服务器验证的方法。它从用户界面上移除服务器验证对话框，并通过`UI.rfb.approveServer()`方法批准服务器验证。
    
5. `rejectServer(e)`: 拒绝服务器验证的方法。它从用户界面上移除服务器验证对话框，并调用`UI.disconnect()`方法断开与服务器的连接。
    
6. `credentials(e)`: 当服务器要求用户提供凭据时的回调方法。它根据服务器要求的凭据类型显示相应的输入框，并在用户界面上显示凭据对话框。
    
7. `setCredentials(e)`: 设置凭据的方法。它从用户界面上获取输入的用户名和密码，并通过`UI.rfb.sendCredentials()`方法发送给服务器。
    
8. `toggleFullscreen()`: 切换全屏模式的方法。它根据当前是否处于全屏状态执行相应的操作，进入或退出全屏模式，并更新全屏按钮的状态。
    
9. `updateFullscreenButton()`: 更新全屏按钮状态的方法。根据当前是否处于全屏状态，更新全屏按钮的样式。
    
10. `applyResizeMode()`: 应用调整大小模式的方法。它根据用户设置的调整大小模式，设置`UI.rfb.scaleViewport`和`UI.rfb.resizeSession`的值，以控制远程会话的缩放或调整大小。
# 2. 相关文章

_摘抄来源，引用出处，参考链接，文档查询_
Page Link::
