---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
在前端开发中，开发者常常会使用文件上传、下载或数据转换的操作。`JavaScript` 提供了许多 API 来处理二进制数据和转换数据流，如：`ArrayBuffer`、`FileReader`、`base64` 、`Blob`、`File`等，他们之间的转换与联系如下所示。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/883babfab890407ba396213ec36811bb~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp?)

## Blob

`Blob (binary large object)` ，即二进制大对象，表示一个不可变、原始数据的类文件对象。它的数据可以按文本或二进制的格式进行读取,在 web 网页中的充当数据流使用的相当频繁。

blob 对象上有两个属性：

- **size**：`Blob` 对象中所包含数据的大小（字节）；
- **type**：字符串，认为该 `Blob` 对象所包含的 `MIME` 类型。如果类型未知，则为空字符串。

``` js  复制代码  
let blob = new Blob([1,2,3,4,5], {type: "text/plain"});
// 可以 进行分割切片，如下
const _subBlob = blob.slice(0, 3，{type: "text/plain"});  // 此时切片的type 默认可以省略
URL.createObjectURL(blob);             //12345
URL.createObjectURL(_subBlob);     // 123

```

**注意： 如果`Blob`的数据属于`Unicode` 编码中的 `Supplementary Plane`（辅助平面） 字符，也即是需要用两个 16 位的 UTF-16 编码单元（称为代理对或代理字符）来表示，那么转成的 `createObjectURL` 链接不能获取正确数据,获得的是乱码，此时可以使用FileReader进行获取特定编码格式的数据，如下：**

```js
let blob = new Blob(['！@#￥%']);
const _subBlob_o = blob.slice(0, 1);
const _subBlob_t = blob.slice(0, 2);
const _subBlob_th = blob.slice(0, 3);
URL.createObjectURL(_subBlob_o);      // �
URL.createObjectURL(_subBlob_t);     // 锛
URL.createObjectURL(_subBlob_th);     // 锛�

// 以下使用 FileReader 获取UTF-8类型的text文本数据
let blob = new Blob(['！￥%&*']);
let _subBlob_o = blob.slice(0,3);
let _subBlob_t = blob.slice(3,6);
let _subBlob_th = blob.slice(6,7);
let _subBlob_f = blob.slice(7,8);
let fileReader = new FileReader();

fileReader.onload = function(event) {
  let result = event.target.result;
  console.log(result); // 这里打印出读取的数据，应该正确显示UTF-8编码的字节字符
};

// fileReader.readAsText(blob, 'UTF-8');              // output:   ！（中文叹号占用三个字节）
// fileReader.readAsText(_subBlob_o, 'UTF-8');   // output:   ￥（中文$占用三个字节）
// fileReader.readAsText(_subBlob_t, 'UTF-8');    // output:   %  
// fileReader.readAsText(_subBlob_th, 'UTF-8');  // output:   &
```

## File

文件（`File`）Api 是一种用来描述有关文件信息的对象类型，`File` 对象本质上是继承了 `Blob` 的一种封装之后的对象 (包含 文件size、文件name和文件type) 。

``` js  复制代码  
File.__proto__ === Blob   // true
```

在web应用中可以通过 `type` 为 `file` 的 `input` 标签选择文件后生成的 `FileList` 对象(这里获取的是File的一个数组)，也可以通过拖拽文件生成 DataTransfer 对象得到Filelist (通过 DataTransfer.files 获取 )。

`File` 对象都包含文件对象的一些属性，这些属性都继承自 `Blob` 对象,根据 [MDN](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBlob "https://developer.mozilla.org/zh-CN/docs/Web/API/Blob") 的解释如下：

- **lastModified**：引用文件最后修改日期，为自1970年1月1日0:00以来的毫秒数；
- **lastModifiedDate**：引用文件的最后修改日期；
- **name**：引用文件的文件名；
- **size**：引用文件的文件大小；
- **type**：文件的媒体类型（MIME）；
- **webkitRelativePath**：文件的路径或 URL。

## FileReader

`FileReader` 是一个在 `JavaScript` 中可以用来读取文件内容的 `API`，它允许您读取 `Blob` 或 `File` 对象中的数据，并将其转换为其他格式，比如文本、二进制数据或数据 `URL`。

**注意：`FileReader` 和 一些 `Blob`、`File` 操作，只能读取文件不能修改文件，若想要直接写入文件可以使用 a 标签，指定转成的文本，进行download,或者可以尝试一下 `Chrome` 的实验性的  
`window.chooseFileSystemEntries` 这个api获取文件句柄操作（正式稳定版新版或没有这个 `Api`，了解即可）**

- **downloadLink**

``` js  复制代码  
const blob = new Blob(['{"name": "tong"}']);
const _link = document.createElement("a");
_link.download = 'e.json';
_link.href = URL.createObjectURL(blob);
_link.click();

```

- **chooseFileSystemEntries**

``` js  复制代码  
// 文件句柄
let handle;
button.addEventListener('click', async (e) => {
  handle = await window.chooseFileSystemEntries();
});

```

**1. `FileReader` 常用属性**

- **error**：表示在读取文件时发生的错误；
- **result**：文件内容。该属性仅在读取操作完成后才有效，数据的格式取决于使用哪个方法来启动读取操作。
- **readyState**：表示 FileReader 状态的数字。取值包含0（`EMPTY`）、1（`LOADING`）、2（`DONE`）

**2. `FileReader` 常用 `API`（传参是 `Blob` 或 `File`）**

- **readAsArrayBuffer()** ：读取数据，result 属性中保存的将是被读取文件的 ArrayBuffer 数据对象；
- **readAsBinaryString()** ：读取数据，result 属性中将包含所读取文件的原始二进制数据；
- **readAsDataURL()** ：读取数据，result 属性中将包含一个dataURL 格式的 Base64 字符串以表示所读取文件的内容。
- **readAsText()** ：读取数据，result 属性中将包含一个字符串以表示所读取的文件内容。

**3. `FileReader` 常用 事件**

- **abort**：该事件在读取操作被中断时触发；
- **error**：该事件在读取操作发生错误时触发；
- **load**：该事件在读取操作完成时触发；
- **progress**：该事件在读取 Blob 时触发。

`input` 上传事件，如下：

``` js  复制代码  
<input type="file" id="_input" />


const reader = new FileReader();

_input.onchange = (e) => {
  reader.readAsDataURL(e.target.files[0]);
};

reader.onload = (e) => {
  console.log(e.target.result);
};

```

## ArrayBuffer

`ArrayBuffer` 是 `JavaScript` 中用于表示一段二进制数据的对象。它是在 `ECMAScript 6（ES2015`）中引入的新类型，允许开发者以更直接的方式处理二进制数据，而无需依赖传统的字符串和数组。它可以存储各种数据类型的二进制数据，如整数、浮点数、字节等。`ArrayBuffer` 对象的大小在创建时确定，并且不能被改变，所以需要借助如下方式读写数据。

- **TypedArray**：用来生成内存的视图，通过9个构造函数，可以生成10种数据格式的视图

``` js  复制代码  
Int8Array: 8 位有符号整数（-128 到 127）
Uint8Array: 8 位无符号整数（0 到 255）
Int16Array: 16 位有符号整数（-32,768 到 32,767）
Uint16Array: 16 位无符号整数（0 到 65,535）
Int32Array: 32 位有符号整数（-2^31 到 2^31-1）
Uint32Array: 32 位无符号整数（0 到 2^32-1）
Float32Array: 32 位浮点数（IEEE 754 标准的单精度浮点数）
Float64Array: 64 位浮点数（IEEE 754 标准的双精度浮点数）
BigInt64Array: 64 位带符号整数（-2^63 到 2^63-1）（在 ECMAScript 2020 中引入）
BigUint64Array: 64 位无符号整数（0 到 2^64-1）（在 ECMAScript 2020 中引入）

```

- **DataViews**：用来生成内存的视图，可以自定义格式和字节序。

包含三个参数：

```js
buffer：一个已经存在的 ArrayBuffer 对象，DataView 对象的数据源。

byteOffset：可选，此 DataView 对象的第一个字节在 buffer 中的字节偏移。如果未指定，则默认从第一个字节开始。

byteLength：可选，此 DataView 对象的字节长度。如果未指定，这个视图的长度将匹配 buffer 的长度。

```

对于 `ArrayBuffer` 的读写操作，具体如下：

```js
const buffer = new ArrayBuffer(16); // 创建一个大小为 16 字节的 ArrayBuffer

// 使用DataView 读写 ArrayBuffer 数据
const buffer = new ArrayBuffer(8);
const view = new DataView(buffer);

view.setInt16(0, 42); // 在位置0写入16位整数值42
view.setFloat32(2, 3.14); // 在位置2写入32位浮点数值3.14

const value1 = view.getInt16(0); // 从位置0读取16位整数值42
const value2 = view.getFloat32(2); // 从位置2读取32位浮点数值3.14


// 使用 TypedArray 读写 ArrayBuffer 数据
const buffer = new ArrayBuffer(8);
const uint8Array = new Uint8Array(buffer);

// 使用 Uint8Array 来设置和获取二进制数据
uint8Array[0] = 10;
uint8Array[1] = 20;
uint8Array[2] = 30;

console.log(uint8Array[0]); // 输出 10
console.log(uint8Array[1]); // 输出 20
console.log(uint8Array[2]); // 输出 30

```

## Object URL

 `Object URL`（对象URL）是一个特殊的 URL 格式，用于临时标识 `JavaScript` 中的 `Blob`、`File` 和 MediaSource 等二进制数据对象。通过创建 Object URL，您可以在浏览器中处理这些二进制数据，而无需直接暴露或嵌入这些数据。

`Object URL` 遵循以下格式：`blob:<unique_id>` ，其中 `<unique_id>` 是一个唯一标识符，用于表示一个特定的二进制数据对象。这个 URL 可以被用于在客户端（通常是在浏览器中）引用这些二进制数据，例如在 <`img`> 标签的 `src` 属性、<`a`> 标签的 href 属性、<`video`> 和 <`audio`> 标签的 `src` 属性等处。创建 `Object URL` 的常用方法是使用 `URL.createObjectURL()` 函数。该函数接受一个 `Blob`、`File` 或 `MediaSource` 对象作为参数，并返回一个 `Object URL` 字符串。这个 `URL` 字符串在 `Blob` 对象的生命周期内是有效的。

一般情况下，在以下情况下 `Object URL` 会被自动释放：

- 当相关的 `JavaScript` 代码执行完成并不再引用 `Object URL` 时 （垃圾回收释放）。
- 当页面被卸载（关闭或导航到其他页面）时。
- 当使用 `URL.revokeObjectURL(`) 手动释放 `Object URL` 时。

**注意：在不需要使用URL时，应该通过 `URL.revokeObjectURL()` 函数来释放它，以避免内存泄漏。如下：**

```js
       // 创建一个包含图片数据的 Blob 对象
        const imageData = new Uint8Array([137, 80, 78, 71, 13, 10, 26, 10, /* ... */]);
        const blob = new Blob([imageData], { type: 'image/png' });

        // 创建 Object URL 并将图片显示在 <img> 标签中
        const imageUrl = URL.createObjectURL(blob);
        const imageElement = document.getElementById('image');
        imageElement.src = imageUrl;

        // 在不需要 Object URL 时释放它
        // 通常在不需要显示图片或其他二进制数据时调用
        // 这样可以释放浏览器内存，避免内存泄漏
        // 注意：在实际应用中，请根据需要选择合适的时机来调用 URL.revokeObjectURL()
        // imageElement.onload = () => {
        //   URL.revokeObjectURL(imageUrl);
        // };

```

## Base64

`Base64` 是一种编码方式，它将二进制数据转换成只包含 `ASCII` 字符的文本表示形式。这种编码方式通常用于在文本协议中传输二进制数据，例如在电子邮件、URL、XML、JSON 等文本格式中嵌入图片、音频、视频等二进制数据。Base64 编码基于 64 个可打印的 ASCII 字符（A-Z，a-z，0-9，+ 和 /），以及一个用于填充的字符（通常是等号 =）。编码规则如下：

- 将 3 字节的二进制数据（24 位）划分为四组，每组 6 位。
- 将每组 6 位二进制数据转换为一个可打印字符。
- 如果原始数据不是 3 字节的倍数，则会在末尾添加一个或两个等号（=）字符进行填充。

理论上说：`Base64` 编码后的数据大小通常会比原始数据大约 33%，因为每 3 字节的数据会编码成 4 个字符。会比`blob url`消耗更多内存，但是在不用的时候会自动从内存中清除（通过垃圾回收机制）。

在 `JavaScript` 中，可以使用 `readAsDataURL api` 和 `canvas` 的 `toDataURL api` 获取 `base64` 格式的数据流。

**注意:上述方式获取的是一种根据数据类型生成的base64编码数据，不是真实一一对应的base64编码规则，因为添加了一些数据类型头部，即：base64编码的数据和 dataUrl 类型的数据不是一个东西。如。`data:image/jpeg;base64,/9j/`,这种的类型 (data: - Data URL 的协议头部、image/jpeg - MIME 类型，表示数据的媒体类型、base64 - 表示数据是使用 Base64 编码的。它告诉浏览器如何解码数据、/9j/ - Base64 编码后的数据的起始部分标识)。**

想获取完整标准的 `Base64` 编码，可以使用 `btoa()` 函数将字符串进行 `Base64` 编码，以及使用 `atob()` 函数将 Base64 编码的字符串解码为原始字符串。在 `Node.js` 中，可以使用 Buffer.from() 和 Buffer.toString() 来进行 Base64 编码和解码。

- **atob(ascii to binary)** ： 解码 ，用于将 `ascii` 码解析成binary数据。用于解码 `Base64` 编码的字符串。
- **btoa(binary to ascii)** ：编码，用于将 `binary` 数据用ascii码表示。常用于编码字符串。(不支持`Unicode` 字符编码)，它的编码范围实际上是在 0 到 255 的整数值之间，即一个字节（8 位）的范围。

```js

    const originalString = 'Hello, world!';
    const encodedString = btoa(originalString);
    const decodedString = atob(encodedString);

    console.log(encodedString); // "SGVsbG8sIHdvcmxkIQ=="
    console.log(decodedString); // "Hello, world!"

```

想要支持其他的 `Unicode` 字符编码，可以使用以下方式：

- 编码时，先用 `encodeURIComponent` 对字符串进行编码，再使用 `btoa` 进行编码
- 解码时，先用 `atob` 对数据进行解码 ，再用 `decodeURIComponent` 对字符串进行解码

```js
let str_unicode = "中国"
let encode_str_unicode =  btoa(encodeURIComponent(str_unicode));

console.log(encode_str_unicode);  // JUU0JUI4JUFEJUU1JTlCJUJE
let decode_str_unicode = decodeURIComponent(atob(encode_str_unicode));
console.log(decode_str_unicode);  //  中国

```

**注意:上述的 `decodeURIComponent` 和 `encodeURIComponent` 是一种URI 编码，一种将特殊字符转换为可安全传输和显示的形式的编码方式。在 `URI`（`Uniform Resource Identifier`）中，某些字符被保留用于特殊用途，例如作为分隔符或标记符号。如果要在 URI 中包含这些保留字符，就需要将它们转换为编码形式，才能正确传输和解析。比如常见到网页路径包含这种参数 `%E4%B8%AD%E5%9B%BD`**

## 格式转化

以下是一些常用的基本转化：

**1.Blob → ArrayBuffer**

```js
let blob = new Blob(['Hello,world'],{type: "text/plain"});
let fileReader = new FileReader();

fileReader.onload = function(event) {
  let result = event.target.result;
  console.log(result);  // ArrayBuffer(11)
};
fileReader.readAsArrayBuffer(blob, 'UTF-8');  

```

**2.Blob → (Base64 | DataURL)**

```js
let blob = new Blob(['Hello,world'],{type: "text/plain"});
let fileReader = new FileReader();

fileReader.onload = function(event) {
  let result = event.target.result;
  console.log(result);   //  data:text/plain;base64,SGVsbG8sd29ybGQ=
  let arr = result.split(',');
	let bstr = atob(arr[1]) 
  console.log(bstr)  //   Hello,world
};
fileReader.readAsDataURL(blob, 'UTF-8');  

```

**注意：以上的编码依旧是不能支持所有 `Unicode` 编码方式，因为 `blob` 中的数据有可能是一些高码位的字符，那么 `readAsDataURL` 生成的 `dataurl` 有可能获取的是乱码，所以要给定 `blob` 生成时的字符编码方式，此时处理方式如下：**

```js
const blob = new Blob([''], { type: 'text/plain;charset=UTF-8' }); // Specify UTF-8 encoding in the Blob
let fileReader = new FileReader();

fileReader.onload = function(event) {
  let result = event.target.result;
  console.log(result);   //  data:text/plain;charset=utf-8;base64,8KCcjg==
  let arr = result.split(',');
	let bstr = atob(arr[1]) 
// Convert binary string to UTF-8 string
const decoder = new TextDecoder('utf-8');
const utf8String = decoder.decode(new Uint8Array(bstr.length).map((_, i) => bstr.charCodeAt(i)));

console.log(utf8String); // ""
};
fileReader.readAsDataURL(blob, 'UTF-8');  

```

在上述示例中，我们首先使用 `atob()` 函数将 `Base64` 编码的数据转换为二进制数据（二进制字符串）。然后，我们使用 `TextDecoder` 对象将二进制数据转换回原始的 UTF-8 字符串。

**注意，`TextDecoder` 构造函数的参数 '`utf-8`' 指定了使用 `UTF-8` 编码进行解码。确保在解码时使用与编码时相同的字符编码，以便正确还原原始数据。在我们之前的示例中，我们在创建 `Data URL` 时指定了 `UTF-8` 编码，因此在解码时也要使用 `UTF-8` 编码。**

**3.Blob → Object URL**

```js
let blob = new Blob(['Hello,world']);
const objectUrl = URL.createObjectURL(blob); 

``` 

**4.Blob → File**

```js
let blob = new Blob(['Hello,world']);
let file = new File([blob], "blob", {type: 'text/plain'})  // File{ name: "blob",size:11,type: "text/plain" ... }

```
**5.ArrayBuffer → Blob**

```js
const buffer = new ArrayBuffer(12);
const s = new Uint8Array(buffer);
let u = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100];
for (let i = 0; i < 12; i++) {
  s[i] = u[i]; 
}
const blob = new Blob([s]);
URL.createObjectURL(blob);    // Hello, World

```

**6.ArrayBuffer → Base64**

这里编码方式有两种，一种是可以通过 `btoa` 编码的，即是上文所说的限制 255 以内的字符。另一种是兼容其他的`Unicode` 码点的转换方式。(以下是演示需要，实际使用不需要创建其他多余的数据) 。

```js
//（非高码位）
const buffer = new ArrayBuffer(12);
const s = new Uint8Array(buffer);
let u = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100];
for (let i = 0; i < 12; i++) {
  s[i] = u[i];
}
const base64 = btoa(String.fromCodePoint.apply(null,s));
atob(base64)  // 'Hello, World'

// （高码位）
const encoder = new TextEncoder();
const buffer = encoder.encode("").buffer;  // 这是在高码位的一个字符
const s = new Uint8Array(buffer);     // 演示需要，转成buffer

const  decoder = new TextDecoder();
const str = decoder.decode(buffer);
// console.log(str);  // ""  这里的输出就是 想要的字符，以下的操作是为了演示Unicode也可以编码。

// 编码
let encode_str_unicode =  btoa(encodeURIComponent(str));
// 解码
// let decode_str_unicode = decodeURIComponent(atob(encode_str_unicode));

console.log(encode_str_unicode);  //  JUYwJUEwJTlDJThF  这里的转换得到的高码位的编码结果
// console.log(decode_str_unicode);  // ""

```

**7. (Base64 | DataURL)→ Blob**

```js
const data_url =  "data:text/plain;charset=utf-8;base64,8KCcjg=="; // 这里是dataurl
let arr = data_url.split(',');
	let bstr = atob(arr[1])  // 这里就是base64 
// Convert binary string to UTF-8 string
const decoder = new TextDecoder('utf-8');
const utf8String = decoder.decode(new Uint8Array(bstr.length).map((_, i) => bstr.charCodeAt(i)));
console.log(utf8String); // "”
// 这里必须要给予charset 否则 createObjectURL生成的文本是乱码
const blob = new Blob([utf8String], { type: 'text/plain;charset=UTF-8' });   
URL.createObjectURL(blob)  // 这里访问即可得到   字符

```

**总结： 关于数据流之间的关系以及如何转换已经基本结束，其他的转换也可以通过上述的数据转换以及相关功能得到。关于数据流的一些想法和问题，可以评论区留言。**