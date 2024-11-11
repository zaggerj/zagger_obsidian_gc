---
created: 2023-11-16 10:06:18
updated: 2023-11-16 13:02:31
---
# 1. front-end

## 1.1. navigator

## 1.2. shortcut

## 1.3. angular执行流程

### 1.3.1. bindJQuery();

```js
function bindJQuery() {
  // bind to jQuery if present;
  jQuery = window.jQuery;
  // Use jQuery if it exists with proper functionality, otherwise default to us.
  // Angular 1.2+ requires jQuery 1.7.1+ for on()/off() support.
  if (jQuery && jQuery.fn.on) {
    jqLite = jQuery;
    extend(jQuery.fn, {
      scope: JQLitePrototype.scope,
      isolateScope: JQLitePrototype.isolateScope,
      controller: JQLitePrototype.controller,
      injector: JQLitePrototype.injector,
      inheritedData: JQLitePrototype.inheritedData
    });
    // Method signature:
    //     jqLitePatchJQueryRemove(name, dispatchThis, filterElems, getterIfNoArguments)
    jqLitePatchJQueryRemove('remove', true, true, false);
    jqLitePatchJQueryRemove('empty', false, false, false);
    jqLitePatchJQueryRemove('html', false, false, true);
  } else {
    jqLite = JQLite;
  }
  angular.element = jqLite;
}
```

- 如果你引入了jQuery库就调用你引用的，没有引用则使用angular内部的一个轻量级的`jQuery（jqLite）`：
`angular.element = jqLite`
-  
![image](assets/12a288a8f0daa6db1c0bf87939a4876d9ab9393b1607ab0f9c4aa97120869fb6.png)

### 1.3.2. publishExternalAPI(angular);

```js
function publishExternalAPI(angular){
  extend(angular, {
    'bootstrap': bootstrap,
    'copy': copy,
    'extend': extend,
    'equals': equals,
    'element': jqLite,
    'forEach': forEach,
    'injector': createInjector,
    'noop': noop,
    'bind': bind,
    'toJson': toJson,
    'fromJson': fromJson,
    'identity': identity,
    'isUndefined': isUndefined,
    'isDefined': isDefined,
    'isString': isString,
    'isFunction': isFunction,
    'isObject': isObject,
    'isNumber': isNumber,
    'isElement': isElement,
    'isArray': isArray,
    'version': version,
    'isDate': isDate,
    'lowercase': lowercase,
    'uppercase': uppercase,
    'callbacks': {counter: 0},
    '$$minErr': minErr,
    '$$csp': csp
  });

  angularModule = setupModuleLoader(window);
  try {
    angularModule('ngLocale');
  } catch (e) {
    angularModule('ngLocale', []).provider('$locale', $LocaleProvider);
  }

  angularModule('ng', ['ngLocale'], ['$provide',
    function ngModule($provide) {
      // $$sanitizeUriProvider needs to be before $compileProvider as it is used by it.
      $provide.provider({
        $$sanitizeUri: $$SanitizeUriProvider
      });
      $provide.provider('$compile', $CompileProvider).
        directive({
            a: htmlAnchorDirective,
            input: inputDirective,
            textarea: inputDirective,
            form: formDirective,
            script: scriptDirective,
            select: selectDirective,
            style: styleDirective,
            option: optionDirective,
            ngBind: ngBindDirective,
            ngBindHtml: ngBindHtmlDirective,
            ngBindTemplate: ngBindTemplateDirective,
            ngClass: ngClassDirective,
            ngClassEven: ngClassEvenDirective,
            ngClassOdd: ngClassOddDirective,
            ngCloak: ngCloakDirective,
            ngController: ngControllerDirective,
            ngForm: ngFormDirective,
            ngHide: ngHideDirective,
            ngIf: ngIfDirective,
            ngInclude: ngIncludeDirective,
            ngInit: ngInitDirective,
            ngNonBindable: ngNonBindableDirective,
            ngPluralize: ngPluralizeDirective,
            ngRepeat: ngRepeatDirective,
            ngShow: ngShowDirective,
            ngStyle: ngStyleDirective,
            ngSwitch: ngSwitchDirective,
            ngSwitchWhen: ngSwitchWhenDirective,
            ngSwitchDefault: ngSwitchDefaultDirective,
            ngOptions: ngOptionsDirective,
            ngTransclude: ngTranscludeDirective,
            ngModel: ngModelDirective,
            ngList: ngListDirective,
            ngChange: ngChangeDirective,
            required: requiredDirective,
            ngRequired: requiredDirective,
            ngValue: ngValueDirective
        }).
        directive({
          ngInclude: ngIncludeFillContentDirective
        }).
        directive(ngAttributeAliasDirectives).
        directive(ngEventDirectives);
      $provide.provider({
        $anchorScroll: $AnchorScrollProvider,
        $animate: $AnimateProvider,
        $browser: $BrowserProvider,
        $cacheFactory: $CacheFactoryProvider,
        $controller: $ControllerProvider,
        $document: $DocumentProvider,
        $exceptionHandler: $ExceptionHandlerProvider,
        $filter: $FilterProvider,
        $interpolate: $InterpolateProvider,
        $interval: $IntervalProvider,
        $http: $HttpProvider,
        $httpBackend: $HttpBackendProvider,
        $location: $LocationProvider,
        $log: $LogProvider,
        $parse: $ParseProvider,
        $rootScope: $RootScopeProvider,
        $q: $QProvider,
        $sce: $SceProvider,
        $sceDelegate: $SceDelegateProvider,
        $sniffer: $SnifferProvider,
        $templateCache: $TemplateCacheProvider,
        $timeout: $TimeoutProvider,
        $window: $WindowProvider,
        $$rAF: $$RAFProvider,
        $$asyncCallback : $$AsyncCallbackProvider
      });
    }
  ]);
}
```

- setModuleLoader方法：
利用ensure函数实现了：
`angular.module = module(name, requires, configFn)`

  - 当调用`angular.module()`返回
```js
moduleInstance = 
{
   _invokeQueue:xx,
   reuqires: xx,
   provider: xx,
   service: xx,
   controller: xx, 
   ...
}
```
注意：
1. 链式调用angular.module(xx).controller(xx)
2. `.controller,.service`之类的方法调用时，并不是立即执行。而且先把参数放入到`_invokeQueues`数组中，此数组在`angularInit`时，调用`bootstrap - > createInjector -> loadModules -> 取出之前存入的相关参数`执行，


	- 最后返回：
	  ```js
instanceInjector = {
  annotate: 
  get: 
  has:
  invoke:
  instantitate:
}
```
	 - ![image](assets/0cc9e9d8e9b97d77fb7ec7df03094c2833e9ace8142f8d50f99df38307e9c3e6.png)
		- moduleFn方法：
1. 所谓的由`setModuleLoader`方法返回的`moduleFn`方法，该方法返回`moduleInstance`，并且`moduleInstance`上的所有方法，几乎最终都返回了`moduleInstance`
2. `moduleFn`方法使用`ensure`返回，如果传递了两个以上的参数，就是设置模板如果传递了一个参数，直接就是获取模板。
3. ![image](assets/00af2b688b3bb1f65e6cef072371d2aafcd99085f376bb5d139655d946ae3f84.png)
 - invokeLate方法：
1. 此方法调用，返回了一个方法，将传递进来的参数，放在invokeQueue数组中。
2. `config，provider，service，fatory，value，constant，filter，controller，directive`等等都会调用invokeLate方法，加入队列invokeQueue。
3. run方法不同，调用run方法的将run方法传递进来的fn参数，放到runBlocks数组中存起来。最终会在createInjector中的loaderModules方法中进行汇总，然后在createInjector中通过forEach(loadModules(modulesToLoad), function(fn) { instanceInjector.invoke(fn || noop); }); 进行了执行。
4. `invokeQueue`中的菜谱也最终是在最终会在createInjector中的loaderModules方法中进行直接进行执行。
![image](assets/64a1eff1a1cee44adfd73e4388b790cfe6dfcb20fe2d9e117db0d021c64850ed.png)

 - 
```js
for(invokeQueue = moduleFn._invokeQueue, i = 0, ii = invokeQueue.length; i < ii; i++) {
            var invokeArgs = invokeQueue[i],
                provider = providerInjector.get(invokeArgs[0]);

            provider[invokeArgs[1]].apply(provider, invokeArgs[2]);
          }
```

- 挂载辅助`api`到`angular`上，如：
`bootstrap，toJson，bind，forEach`等等

- 将`ngLocale`挂载到`angular.module`上

- 将`ng`挂载到`angular.module`上

-  
![image](assets/48b0ac4be2618899b3c917b317d6571a19e0a4cb36d654d6aecd1fdeab69372b.png)

### 1.3.3. angularInit方法:
```js
jqLite(document).ready(function() {
    angularInit(document, bootstrap);
  });
```

- 作用：
通过ng-app="xx"，取出moduleName

- bootstrap方法：
bootstrap(appElement, module ? [module] : []);

	- doBootstrap方法

		- createInjector方法：
var injector = createInjector(modules);

			- 调用的地方

				- createInternalInjector(providerCache, function() {
            throw $injectorMinErr('unpr', "Unknown provider: {0}", path.join(' <- '));
          })),

			- 其他属性或者方法

				- providerCache属性

				- providerInjector属性

				- instanceCache属性

				- instanceInjector属性

			- 返回

				- instanceInjector对象

			- createInternalInjector方法

				- getService方法

					- getService：
1.使用了外层函数createInternalInjector的两个参数，cache和factory
2.参数为serviceName
3.判断cache上本身属性是否有serviceName属性，
       3.1 如果有，直接返回cache[serviceName]
       3.2如果无，尝试做如下操作：先尝试将serviceName放在path数组的头部，设置cache[serviceName]为INSTANTIATING({}),返回cache[serviceName] = factory(serviceName);如果 factory(serviceName)报错，那么就删除cache[serviceName]并且throw err，并且最终都从path头部去掉第一个元素。
4. 最终都返回服务：factory(serviceName)创建出来的服务或者cache中缓存的服务
![image](assets/db77636156cad2937dcd4e1cf5846b4d52bef9644e7352ebd5157d3b43ddbe85.png)

				- invoke方法

					- invoke：
1.首先通过annotate(fn)，拿到fn的依赖参数列表
2.循环$inject，如果locals参数中有当前依赖，直接拿去locals中的依赖，没有，就调用getService方法拿去依赖。
3.调用fn，并且将依赖参数列表传递进去。
![image](assets/5039b11bbade0b6473eee2cadecadce244e0b68ce552ae357bd2634a5844a4b6.png)

				- instantiate方法

					- instantiate(Type,locals)方法创建了一个空的构造函数，并继承自传入的Type，然后实例化得到instance,最后在调用invoke函数。
![image](assets/49f634b94a775d1cce376278e7fa06aa697c757c5a9ec2ad7db3f2494dbb0b7a.png)

				- 返回：
{
      invoke: invoke,
      instantiate: instantiate,
      get: getService,
      annotate: annotate,
      has: function(name) {
        return providerCache.hasOwnProperty(name + providerSuffix) || cache.hasOwnProperty(name);
      }
    };

				- decorator如何使用的：
1.$provider下的decorator
2.修饰已经存在了的provider的key
3.函数参数为$delegate
![image](assets/b562dc6ecd98c9bcf328ecc28470169ef99c1a9929540f014d57f4425038f970.png)

			- loadModules

				-  
![image](assets/32b19d48089e82796528ee6fa9b046d11e95454b20282cdfa09e7f3402f28e1d.png)

				- 1.执行runBlocks：
    forEach(loadModules(modulesToLoad), function(fn) { instanceInjector.invoke(fn || noop); });
2. 字符串类型模块，是直接进行加载后，都汇总到runBlocks中。
3. 函数类型和数组类型的模块，是先调用providerInjector.invoke(module)执行了之后再放进去runBlocks

- annotate方法
全局定义

	-  
![image](assets/e88eead3328a0094fa2f100059e4864293a4693bedf7711279e260f106147ec3.png)

	- annotate：获取参数列表
1. 参数是一个函数，并且函数有参数，通过正则拿到函数的参数，放到函数的$inject属性上
2.参数是个数组，拿到数组的n-1个参数，作为$inject属性
3.最终都将返回$inject属性

### 1.3.4. 问题：

- 
1. runBlocks.push(providerInjector.invoke(module));
2. invokeQueue直接执行：provider[invokeArgs[1]].apply(provider, invokeArgs[2]);
3. instanceInjector.invoke(fn || noop)
三者之间有啥区别

	- instanceInjector和providerInjector上调用invoke，区别在于，在不同的cache上getService拿取服务

- 问题2：
createInjector中的providerCache的$provider下的provider，factory，service，value，constant，decorator方法

### 1.3.5. 加载模块和构建Injector，执行模块
![image](assets/c42e553b6cdaef49d232f38af7cde5a8617e52f49fd9b3e3b7e55b67726fd5d2.png)

### 1.3.6. $provode.provider方法支持两种用法：
1. name，provider_
2. {name: provider_}
![image](assets/0b313cd2195cd25571620780dd77b26b41e1bd6fa91420d58aead7db8e6363b7.png)

## 1.4. 文档集合

### 1.4.1. [1. 10个常见的前端手写功能，你全都会吗？](https://juejin.cn/post/7031322059414175774)

### 1.4.2. [2. 这些一行 JS 实现功能的代码，让你看起来像一个前端专家](https://juejin.cn/post/6921509748785283086)

### 1.4.3. [3. 学习源码整体架构系列](https://juejin.cn/column/6960551178908205093)

### 1.4.4. [4. 「万字总结」熬夜总结50个JS的高级知识点，全都会你就是神！！！](https://juejin.cn/post/7022795467821940773)

### 1.4.5. [5. 一个合格的中级前端工程师需要掌握的 28 个 JavaScript 技巧](https://juejin.cn/post/6844903856489365518)

### 1.4.6. [6.(建议收藏)原生JS灵魂之问, 请问你能接得住几个？(上)](https://juejin.cn/post/6844903974378668039)

### 1.4.7. [7. 你知道 Vue scoped 原理吗？这波你在第几层？](https://juejin.cn/post/7098569051860893709)

### 1.4.8. [8. 用上这个 Mock 神器，让你的开发爽上天！](https://juejin.cn/post/7094892335841935374)

## 1.5. electron

### 1.5.1. 参考链接：

- [1.从 Electron 架构出发，深究 Electron 跨端原理 | 多图详解](https://juejin.cn/post/7103337772424888356)

- [2.vue + electron 开发一个实时监测github的跨端桌面应用](https://juejin.cn/post/7103749039677505566)

- [3.大概是全网最详细的Electron ipc 讲解(三)——定情信物传声筒port](https://juejin.cn/post/7103689764917755940)

## 1.6. ajax，xhr

### 1.6.1. 参考链接：

- [1.Ajax--概述、xhr对象的常用属性和方法、xhr的常用事件、xhr对象发送POST请求、xhr对象发送GET请求、xhr对象的兼容性问题、数据交换格式(XML、JSON)](https://blog.csdn.net/weixin_43285360/article/details/116974774)

### 1.6.2. ajax、fetch、axios

- Ajax

	- Ajax 是一个技术统称，是一个概念模型，它囊括了很多技术，并不特指某一技术，它很重要的特性之一就是让页面实现局部刷新。

	- 特点：

	- 局部刷新页面，无需重载整个页面。

	- 简单来说，Ajax 是一种思想，XMLHttpRequest 只是实现 Ajax 的一种方式。其中 XMLHttpRequest 模块就是实现 Ajax 的一种很好的方式，这也是很多面试官喜欢让面试者手撕的代码之一。

	- 利用 XMLHttpRequest 模块实现 Ajax。

- Fetch

	- Fetch 是一个 API，它是真实存在的，它是基于 promise 的。

	- Fetch 是在 ES6 出现的，它使用了 ES6 提出的 promise 对象。它是 XMLHttpRequest 的替代品。

	- 很多小伙伴会把它与 Ajax 作比较，其实这是不对的，我们通常所说的 Ajax 是指使用 XMLHttpRequest 实现的 Ajax，所以真正应该和 XMLHttpRequest 作比较。

	- 特点：

	- 使用 promise，不使用回调函数。

	- 采用模块化设计，比如 rep、res 等对象分散开来，比较友好。

	- 通过数据流对象处理数据，可以提高网站性能。

	- 所以这里就和 Ajax 又很大不同了，一个是思想，一个是真实存在的 API，不过它们都是用来给网络请求服务的，我们一起来看看利用 Fetch 实现网络请求。

	- 示例代码

		- <body>
  <script>
    function ajaxFetch(url) {
      fetch(url).then(res => res.json()).then(data => {
        console.info(data)
      })
    }
    ajaxFetch('https://smallpig.site/api/category/getCategory')
  </script>
</body>


- Axios

	- Axios 是一个基于 promise 封装的网络请求库，它是基于 XHR 进行二次封装。

	- 特点：

	- 从浏览器中创建 XMLHttpRequests

	- 从 node.js 创建 http 请求

	- 支持 Promise API

	- 拦截请求和响应

	- 转换请求数据和响应数据

	- 取消请求

	- 自动转换 JSON 数据

	- 客户端支持防御 XSRF

	- 所以说，Axios 可以说是 XHR 的一个子集，而 XHR 又是 Ajax 的一个子集。既然说它是一个库，那么我们在使用的时候就需要引入它。

- 总结：

	-  
![image](assets/273b35ed67cd00369e1e4e254d184f530538e44daf49a62c19b3e958351c292c.png)

	-  
![image](assets/f3d50f8e811c6bca2f1000101778b2bf8995b17ff8ec0696e5bab6e76ac3b750.png)

- 参考链接：

	- [请说明 Ajax、Fetch、Axios 三者的区别](https://juejin.cn/post/7103136454267633678)

### 1.6.3. axios

- 参考链接：

	- [1.axios详解](https://blog.csdn.net/asdfadafd/article/details/123344164)

	- [2.详细介绍axios（配置、axios发送请求、拦截器、取消请求）和axios的源码分析](http://www.manongjc.com/detail/27-ixniepskudqdkyg.html)

	- [3.经验|axios封装与api管理：简洁实用](https://juejin.cn/post/7089214265084772388)

	- [4.vue中Axios的封装和API接口的管理](https://juejin.cn/post/6844903652881072141)

## 1.7. 拖拽

### 1.7.1. 参考文档：

- [1、看完就懂的前端拖拽那些事](https://juejin.cn/post/7075918201359433758)

	- html5中提供了一系列Drag and Drop 接口，主要包括四部分：

		- DragEvent，DataTansfer，DataTransferItem 和DataTransferItemList。

	- **DragEvent**

		-  
![image](assets/27b8aa29aad5e8fca6e163298f9c2b8c5d33eea611ee551ad3ab2cdc6e0e2055.png)

	- 拖拽事件

		-  
![image](assets/e2ab3e34639e31ef6986902ef67e14cfe828394e16ebef7f2adee72e00ac318f.png)

	- 触发顺序及次数

		-  
![image](assets/da2cb8ada68432052115419db5e048129913a838b2466418485bca4142b1f366.png)

	- DataTansfer

		-  
![image](assets/b1ba8a21bb1c5e30fa37c9eca4dcd0ec965cc9b1e99003af9a0d16a395e07934.png)

- [2.前端里的“拖拖拽拽”](http://events.jianshu.io/p/d5ce3b712dd9)

## 1.8. 文件上传

### 1.8.1. 文档参考：

- [1.一文讲透文件上传](https://zhuanlan.zhihu.com/p/370229240)

	- 1、文件上传的数据链路

		- 1、第三方文件存储

			- 指的是把文件存储到第三方存储服务。

			- 举个例子，假设需要上传一张图片并存储起来。一般的做法是前端选择完图片后，图片被传输到服务端，

			- 然后服务端调用上传接口把图片上传到第三方存储（这里的第三方存储可以是腾讯云、阿里云这些提供商提供的文件存储服务），

			- 第三方服务再返回一个图片的访问地址给到后台，后台最后把图片地址存储到自己的数据库中。

			- 整个链路：前端选择文件 -> 传输文件到后台 -> 后台传输文件到第三方 -> 第三方返回文件地址 -> 后台把文件地址存储到数据库

			- 文件传输过程中，可能会因为网络、第三方服务不稳定、后台服务bug等导致上传文件失败。

			- 因为链路比较长，所以是哪个节点出错导致的文件上传失败，最好定下具体的失败提示语。

			- 比如如果是第三方服务的问题，可以提示“上传文件到第三方存储失败”，如果文件上传到第三方成功了，但是因为自身服务问题导致文件地址存储数据库失败，可以提示“文件地址存储数据库失败”等等。

		- 2、数据库存储

			- 指的是把文件内容读取出来，存储到数据库。

			- 最常见的场景就是，上传一个excel文件，根据excel内容，把数据批量存储到数据库。

			- 数据链路是：前端选择文件 -> 传输文件到后台 -> 后台解析excel数据 -> 存储数据到数据库

			- 最常出现问题的节点是解析excel数据，这里最好给出数据合法性校验的具体规则和错误提示语，比如单个文件的最大行数、某个字段的唯一性、是否必填、值合法性（比如只能是限定的几个选择词）

	- 2、文件上传的前、中、后 文件上传的数据链路

		- 1、文件上传前

			- 1）、前端合法性校验

				- 前端选择本地文件后，文件会暂时缓存在前端，前端可以获取到文件名、文件大小、文件内容。前端是可以去解析文件内容来做合法性校验，但是一般不建议放在前端做，解析文件性能比不上后台（但也具体问题具体分析）。

				- 前端最常做的合法性校验是文件扩展名、文件大小、文件个数、空文件等校验。

			- 2）、文件是否自动上传

				- 在前端选择完本地文件后，可以自动触发上传到服务器，也可以手动触发。一般来说，多文件的上传采用手动上传，单文件的上传采用自动上传。因为选择多个文件后，可能会对之前选择的文件进行删除操作。

			- 3）、文件个数限制

				- 如果是支持多个文件上传，最好做下文件个数限制，还有已经选择上传的文件，最好支持手动删除。

			- 4）、选择文件后是否展示文件名

				- 选择完文件后，最好要展示文件名，这样可以给用户一个文件上传成功的暗示。如果是图片的话，最好给个图片预览。

		- 2、文件上传中

			- 1）、文件上传进度

				- 文件上传是可以展示上传进度的，ajax有提供上传进度的事件监听。

			- 2）、分片上传

				- 文件上传可分为整个文件上传和分片上传，分片上传一般用于大文件的上传，比如一个30M的文件，可拆分为6份，每次上传5M，等全部上传到服务器后，服务器再把这些片段文件组合成完整的文件。

				- 如果一次性上传一个大文件，会导致整个过程比较漫长，中途可能会因为超时失败，且失败后需要重头开始上传。

				- 分片上传的优点是，一旦上传失败只是损失一个分片而已，不用整个文件重传，这也是我们常听到的 “断点续传”。

				- 分片上传相比整文件上传逻辑要复杂一些，前端和服务端都要实现相应的功能。

			- 3）、取消、暂停、恢复文件上传

				- 取消、暂停、恢复文件上传功能一般用于大文件的分片上传。

				- 对于整个文件的上传，就没必要这些功能了，反而增加了复杂度。

		- 3、文件上传后

			- 1）、文件内容校验失败

				- 如果文件内容检验失败，最好后台返回每一行哪个字段有什么错误给到前端， 这样用户就可以按照提示修改文件了。

			- 2）、文件上传成功

				- 文件上传成功后一般是跳转到一个预览列表页，这样用户就可以即时看到之前上传的数据。

			- 3）、异步上传

				- 文件上传后，如果后台需要根据文件内容做大量的计算，比较耗费时间，可采用异步上传的方式。即文件上传成功后，服务端立即返回上传成功的结果给到前端，但是文件解析的结果稍后通过站内信的方式通知用户解析结果。

	- 在网页端，前端不能直接操作本地文件，必须要用户来触发。

		- 1、通过文件选择按钮选择本地文件

			-  
![image](assets/d8512a0d7ee74f67b0f3ccd670e1f322de107e26e3eab3aedba126531bf3549d.png)

		- 2、通过拖拽的方式把文件拖进来

			-  
![image](assets/e2513e055029f910eea9b15a229669be31202564da288e3fdf1e3eae4f9ff431.png)

		- 3、在编辑框里复制粘贴

			-  
![image](assets/d784840658ba2703d38b0d6de24e6ddc40e9f4c2a9d2c9411f0e803da953f266.png)

			-  
![image](assets/4ebef3c497c02cdb7400c007cd19709a27fbace66f8aa79338092213fc767bb3.png)

- [2.前端文件上传，这8种场景](https://blog.csdn.net/sinat_17775997/article/details/123138383)

	- 一、单文件上传

	- 二、多文件上传

	- 三、目录上传

	- 四、压缩目录上传

	- 五、拖拽上传

		- 要实现拖拽上传的功能，我们需要先了解与拖拽相关的事件。比如 drag、dragend、dragenter、dragover 或 drop 事件等。这里我们只介绍接下来要用到的拖拽事件：

		- dragenter：当拖拽元素或选中的文本到一个可释放目标时触发；

		- dragover：当元素或选中的文本被拖到一个可释放目标上时触发（每100毫秒触发一次）；

		- dragleave：当拖拽元素或选中的文本离开一个可释放目标时触发；

		- drop：当元素或选中的文本在可释放目标上被释放时触发。

	- 六、剪贴板上传

	- 七、大文件分块上传

	- 八、服务端上传

- [3.进阶|监控上传和下载进度](https://juejin.cn/post/7103188024887869476)

- [4.大文件分段上传断点存续，MD5，跨端技术，哪里的上传都是一样的](https://juejin.cn/post/7103799605623521294)

## 1.9. git bash

### 1.9.1. [简介：windows上配置git bash
背景：windows上实在没有更好的终端工具，用来使用。](https://blog.csdn.net/admans/article/details/124380070)

### 1.9.2. 5.参考链接：

- [1.cmd、git bash、powershell等命令行界面美化和集中管理——Windows terminal使用和基础配置教程](https://blog.csdn.net/a1845613403/article/details/122777663)

- [2.windows的git bash设置永久别名](https://blog.csdn.net/u010999809/article/details/82493878)

	- cd /etc/profile.d
vim aliases.sh # 编辑aliases文件

	- 添加一行
alias grep="grep --color"

- [3.Windows-GitBash终端美化](https://mdnice.com/writing/20ddea0c2f594ed59da1ed0d6d238182)

	- # git bash 终端执行

# 2. 了解 vim 的执行如下
vim /etc/profile.d/git-prompt.sh
# 3. 安装 vscode 的执行该操作
code /etc/profile.d/git-prompt.sh

	-  /etc/profile.d/git-prompt.sh

	   if test -f /etc/profile.d/git-sdk.sh
	    then
	        TITLEPREFIX=SDK-${MSYSTEM#MINGW}
	    else
	        TITLEPREFIX=$MSYSTEM
	    fi
	  
	    if test -f ~/.config/git/git-prompt.sh
	    then
	        . ~/.config/git/git-prompt.sh
	    else
	        PS1='\[\033]0;Bash\007\]'      # 窗口标题
	        PS1="$PS1"'\n'                 # 换行
	        PS1="$PS1"'\[\033[32;1m\]'     # 高亮绿色
	        PS1="$PS1"'➜ '               # unicode 字符，右箭头
	        PS1="$PS1"'\[\033[33;1m\]'     # 高亮黄色
	        PS1="$PS1"'\W'                 # 当前目录
	        if test -z "$WINELOADERNOEXEC"
	        then
	            GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
	            COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
	            COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
	            COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
	            if test -f "$COMPLETION_PATH/git-prompt.sh"
	            then
	                . "$COMPLETION_PATH/git-completion.bash"
	                . "$COMPLETION_PATH/git-prompt.sh"
	                PS1="$PS1"'\[\033[31m\]'   # 红色
	                PS1="$PS1"'`__git_ps1`'    # git 插件
	            fi
	        fi
	        PS1="$PS1"'\[\033[36m\] '      # 青色
	    fi
	  
	    MSYS2_PS1="$PS1"
	  
- 4.设置git自动补全功能（windows版本）

### 3.1.1. 4.git bash 相关配置

-  vim /etc/profile.d/aliases.sh

# 4. Some good standards, which are not used if the user
# 5. creates his/her own .bashrc/.bash_profile
  
# 6. --show-control-chars: help showing Korean or accented characters
  alias ls='ls -F --color=auto --show-control-chars'
  alias ll='ls -l'
  alias grep='grep --color'
# 7. proxy
# 8. default socks5 
  alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890"
# 9. company socks5 ssh tunnel
  alias setproxy1="export ALL_PROXY=socks5://59.175.233.194:8181"
# 10. reset proxy
  alias unsetproxy="unset ALL_PROXY"
  
  alias cip="curl -i http://ip.cn"
# 11. clear
  alias c="clear"
# 12. git
  alias gpl="git pull"
  alias gpu="git push"
  alias gs="git status"
  alias glg="git log --stat"
  alias gc='git config credential.helper store'
  
# 13. npm and yarn
  alias ns="npm start"
  alias ys="yarn run serve"
  
# 14. shortcut path
  alias gw="cd d:/code"
  
# 15. ls
  
  alias lsa="sudo ls -la --color=auto"
  alias l='ls -la'
  
# 16. scp
  alias scp142="scp -r js built resources views personal_login css fonts includes root@172.16.65.142:/var/www/html"
  alias scp146="scp -r js built resources views personal_login css fonts includes root@172.16.65.146:/var/www/html"
  
  case "$TERM" in
  xterm*)
  	# The following programs are known to require a Win32 Console
  	# for interactive usage, therefore let's launch them through winpty
  	# when run inside `mintty`.
  	for name in node ipython php php5 psql python2.7
  	do
  		case "$(type -p "$name".exe 2>/dev/null)" in
  		''|/usr/bin/*) continue;;
  		esac
  		alias $name="winpty $name.exe"
  	done
  	;;
  esac
  
  
- vim /etc/profile.d/git-prompt.sh

   if test -f /etc/profile.d/git-sdk.sh
    then
        TITLEPREFIX=SDK-${MSYSTEM#MINGW}
    else
        TITLEPREFIX=$MSYSTEM
    fi
  
    if test -f ~/.config/git/git-prompt.sh
    then
        . ~/.config/git/git-prompt.sh
    else
        PS1='\[\033]0;Bash\007\]'      # 窗口标题
        PS1="$PS1"'\n'                 # 换行
        PS1="$PS1"'\[\033[32;1m\]'     # 高亮绿色
        PS1="$PS1"'➜ '               # unicode 字符，右箭头
        PS1="$PS1"'\[\033[33;1m\]'     # 高亮黄色
        PS1="$PS1"'\W'                 # 当前目录
        if test -z "$WINELOADERNOEXEC"
        then
            GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
            COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
            COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
            COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
            if test -f "$COMPLETION_PATH/git-prompt.sh"
            then
                . "$COMPLETION_PATH/git-completion.bash"
                . "$COMPLETION_PATH/git-prompt.sh"
                PS1="$PS1"'\[\033[31m\]'   # 红色
                PS1="$PS1"'`__git_ps1`'    # git 插件
            fi
        fi
        PS1="$PS1"'\[\033[36m\] '      # 青色
    fi
  
    MSYS2_PS1="$PS1"
  
  
- vim ~/.minttyrc

  Font=Jetbrains Mono
  FontHeight=14
  Transparency=low
  FontSmoothing=full
  Locale=zh_CN
  Charset=UTF-8
  Columns=88
  Rows=26
  OpaqueWhenFocused=no
  Scrollbar=none
  Language=zh_CN
  
  ForegroundColour=255,255,255
  BackgroundColour=0,43,54
  CursorColour=220,130,71
  
  BoldBlack=128,128,128
  Green=64,200,64
  BoldGreen=64,255,64
  Yellow=190,190,0
  BoldYellow=255,255,64
  Blue=135,144,255
  BoldBlue=30,144,255
  Magenta=211,54,130
  BoldMagenta=255,128,255
  Cyan=64,190,190
  BoldCyan=128,255,255
  White=250,240,230
  BoldWhite=250,240,230
  
  BellTaskbar=no
  Term=xterm-256color
  FontWeight=400
  FontIsBold=no
  BellType=0
  
  CtrlShiftShortcuts=yes
  ConfirmExit=no
  AllowBlinking=yes
  BoldAsFont=no
  
  
- vscode 配置文件

### 16.1.1. 3.windows terminal 中配置git bash

-  
![image](assets/e2ab46aeb68c34163f6bbdc5d2a82b556c1d0000a94bfb351c254a912e14c779.png)

### 16.1.2. 2.vscode相关配置

-  "terminal.integrated.profiles.windows": {
      // 名称中不能有空格，否则无法识别
      "Git_Bash": {
        "path": "D:/install/Git/bin/bash.exe",
        // 配置git bash 参数的办法
        "args": ["--login", "-i"]
      }
    },
    "terminal.integrated.defaultProfile.windows": "Git_Bash",

### 16.1.3. 1.windows上桌面快捷方式相关配置

-  
![image](assets/26e62cb5a0daad300555a88d3bf47f9013a37ee7bf38d229c24ecd2c697d859c.png)

-  
![image](assets/b4d35109a2f7d9c0d9cc332b3017bff12669d10caa10a95a6ce9c0dcdc15a532.png)

## 16.2. 工作计划

### 16.2.1. 2022-05-23

- 1.上周：

- 情况：小孩住院请假了

- 1.1上周本来计划要把实习生没有完成的工作，花了两个晚上，加紧完成了

- 1.2上周的bug，也是在医院抽时间完成了

- 1.3上周指定了vpc5.3.3第三迭代的开发计划

- 2.本周：

- 2.1 计划，本周25开始开发vpc5.3.3

- 2.2 继续解决VOI5.4.0和VPC5.3.2天翼云的测试问题

- 2.4 本周需要准备极速分享

- 2.5 6月初 需要写技术白皮书

### 16.2.2. 2022-05-25

- 晨会

- 1.开始vpc5.3.3第三迭代的开发

	- 1. 还原点占用空间展示 （0.5天）5月25号-5月25号

	- 2.磁盘容量分盘显示（0.5天）5月25号-5月25号

- 2.解决VOI5.4.0和VPC5.3.2天翼云的问题

### 16.2.3. vpc5.3.3第三迭代开发计划

- 1. 还原点占用空间展示 （0.5天）5月25号-5月25号

- 2.磁盘容量分盘显示（0.5天）5月25号-5月25号

- 3.voi桌面数据找回（0.5天）5月26号-5月26号

- 4.文件下发模块（3天）5月27号-5月31号

- 5. 文件下发模块-功能联调（1天）6月1号-6月1号

- 6.其他模块-功能联调（0.5天）6月2号-6月2号

- 7.数据漫游设置（1天）6月6号-6月6号

- 8.数据漫游-voi桌面数据漫游和漫游桌面（1天）6月7号-6月号7

## 16.3. work

### 16.3.1. oseasy

- 201.91服务器密码

	- oseasy@666

- 服务器数据库账号密码

	- oseasy
cloudhan

### 16.3.2. 计划

- nodejs计划

	- 1.Nodejs命令行光标位置的设置：https://blog.csdn.net/weixin_34121304/article/details/89473339

	- 2.一个例子看懂所有nodejs的官方网络demo：https://www.cnblogs.com/huenchao/p/7078741.html

	- 3.Node初学者入门，一本全面的NodeJS教程：https://www.cnblogs.com/youhui/articles/12156117.html

	- 4.nodejs前端开发教程：https://blog.csdn.net/qq_36232611/article/details/92579841

	- 5.Introduction - nodebook (whyun.com):https://nodebook.whyun.com/

	- 6.liuxing/node-abc: 《Node.js入门教程》 (github.com):https://github.com/liuxing/node-abc

	- 7.快速撸一个sina视频的demo，youtobe上的那个

### 16.3.3. 导师

- 实习生答辩

	- 技术能力

	- 工作思维

	- 是否努力

	- 学习能力

- vue

	- vuex

	- vuedraggable

		- http://www.itxst.com/vue-draggable/tutorial.html

- angularjs

- 培训

- 导师带徒弟
1）每周3进行代码检查/评审，输出问题列表共享文档， 权重3
    1.1）维护频率 = 维护次数/季度周数，
        不缺勤 优
        > 90 缺勤一次 良好
        > 80 缺勤两次 合格
        < 80 缺勤上次 待改进
2）导师每周和实习生沟通，记录沟通表，权重3
时间 地点 沟通结果（导师心得体会）
3) 实习生考核指标与导师挂钩，权重2
4）每周点评（实习生工作状态，质量） ，权重2

- [2022-05-11更新-噢易云计算新员工培训发展计划-肖林峰](https://www.kdocs.cn/l/chHXePbtj62C)

### 16.3.4. 培训

- 时间：05-07 => 05-17

- 记录布置作业完成的结果数据

- 讲课-课件

	- [URI.js
Intro](https://medialize.github.io/URI.js/)

- 实战，跟后端联调

- 最终结果：可以进行项目，中控

- angularjs培训

- 培训网址

	- http://192.168.0.161:4999/web/#/8?page_id=94

		- zy
123456

	- http://172.16.103.196:8800/sync.cgi

	- angularjs

## 16.4. server side

### 16.4.1. nodejs

### 16.4.2. python

- pre-commit

- django

	- [中文文档](https://docs.djangoproject.com/zh-hans/2.0/)

### 16.4.3. BashShell

### 16.4.4. linux环境

### 16.4.5. 计算机基础知识

### 16.4.6. 数据库

- mongodb

### 16.4.7. 服务器

- nginx

## 16.5. software design

### 16.5.1. [Technical Skills技术能力图](https://blog.csdn.net/frontend_frank/article/details/118886427)

- 基础知识basic

	- html

		- 语义化

		- html元素

		- 文档元数据

		- 其他

	- DOM

	- BOM API

		- window

		- navigator

		- screen

		- history

		- location

	- JavaScript（包含正则）

		- ES6+

			- es6方法

				- [find方法 ](https://www.runoob.com/jsref/jsref-find.html)

					-  const hit1 = find(cache,c=>c.original===obj)

				- es6对象扩展

			- class语法糖

	- css

		- flex

		- 其他

			- css设置英文字符自动换行

				- word-wrap: break-word;
white-space: normal;
word-break: break-all;

	- 计算机网络: IP地址，子网掩码，网段表示法，默认网关，DNS服务器详解

	- http

	- https

	- tcp/ip

	- standard

	- 干货、经验

		- JSON

		- Websocket

		- XML

		- 按位非(~)

			- 我们知道，js中的数字默认是有符号的。有符号的32位二进制的最高位也就是第一位数字代表着正负，1代表负数，0代表整数。那到底11111111111111111111111111111110等于多少呢？最高位为1代表负数，负数的二进制转化为十进制：符号位不变，其他位取反加1。取反之后为10000000000000000000000000000001，加1之后为10000000000000000000000000000010，十进制为-2。

			-  
![image](assets/6ac31f212c3a63d0f366324a6de254826fa5108b5e3f9ba159fc8909a9adf214.png)

- 应用层

	- node

	- webpack

	- Vite

	- Rollup

	- 微信公众号

		- 公众号开发流程 / 部署流程

		- 授权

		- 支付

		- 扫码推送场景

	- 微信服务号开发流程

		- [文档1：微信服务号开发整体流程](https://blog.csdn.net/maoxin604/article/details/80552719)

	- 微信小程序

		- 开发环境搭建

		- 文件组成 / 声明周期 / 全局变量 / 公共设置 / 导航栏处理

		- 组件使用

		- 小程序在android和iphone上的不同

		- 部署发布

	- Typescript

		- TypeScript是什么

		- Typescript和JavaScript的区别是什么

		- TypeScript功能拆分

		- 如何开始使用TypeScript

		- TypeScript和webpack的关系

		- TypeScript和react的关系

		- TypeScript和Eslint的关系

		- [typescript入门教程地址](https://juejin.cn/post/6999440503712251935?utm_source=gold_browser_extension)

	- 环境部署

		- nginx

		- docker部署nginx环境

		- 客户端渲染打包部署

		- 服务端渲染打包部署

		- docker + nginx + cicd 环境部署

			- docker

		- 版本构建计划

			- Jenkins

				- Jenkinsfile 

				- [ Groovy的语法](https://www.jenkins.io/zh/doc/book/pipeline/syntax/)

			- https://vdi.coding.net/p/vdi2021t2/

			- gitlab CI/CD

				- [地址：https://docs.gitlab.com/ee/ci/](https://docs.gitlab.com/ee/ci/)

				- [地址2:https://www.cnblogs.com/cjsblog/p/12256843.html](https://www.cnblogs.com/cjsblog/p/12256843.html)

		- 包管理工具

- 框架

	- react/vue【react举例】

		- vue2

		- react

			- 初步了解 &上手开发demo

			- 核心概念

			- 高级指引

			- API 使用

			- react hooks

			- redux

			- react-router

			- 场景应用

			- 源码学习 & 了解

	- taro/uniapp

		- [快速体验uniCloud后台管理](https://blog.csdn.net/Jackson00709/article/details/115444715?spm=1001.2014.3001.5501)

	- flutter/RN

	- electron

	- next/nuxt

	- angular 1.3

		- angularjs

		- bootstrap ui

		- [$http 的 success和then](https://www.codenong.com/16385278/)

	- 其他

		- [mini programs](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/JS-SDK.html)

		- requirejs

		- seajs

		- jquery/YUI2/YUI3

		- Prototype/Mootools/Extjs

		- Smarty/Django/Zend

		- YUITest/QUnit/jasmine

		- 前端测试/前端MVC

		- BackBone

		- fontAwesome/icomoon.io

- 高级应用

	- 数据结构

	- 算法：JS-ALGORITHM

		- 定义：一系列解决问题的清晰指令，就像食谱

	- 数据结构与算法的关系

		- 程序=数据结构+算法

		- 数据结构为算法提供服务，算法围绕数据结构操作

	- 设计模式

		- 设计原则

		- 常见设计模式

		- 设计模式运用

	- 工程化

	- 性能优化

	- 安全

	- 软知识

		- design pattern

			- 5大设计原则

			- 常用设计模式

		- algorithm

		- 数据结构

		- 面向对象

			- 封装

			- 继承

			- 多态

	- 字符编码问题和二进制相关

	- vnc

		- [windows10 使用vnc View 访问macos](https://jingyan.baidu.com/article/ceb9fb10893b948cac2ba05a.html)

		- [远程桌面：macos](https://juejin.cn/post/6914564419653468168)

		- [github搜索](https://github.com/search?l=JavaScript&q=web-vnc&type=Repositories)

		- [掘金搜索](https://juejin.cn/search?utm_source=gold_browser_extension&query=vnc&period=0&sort=0)

	- 内网穿透

		- NAT（Network Address Translator）

		- Local Area Network，LAN

			- 内网也叫局域网，是在一个局部的地理范围内（如bai一个学校、工厂和机关内），一般是方圆几千米以内，将各种计算机，外部设备和数据库等互相联接起来组成的计算机通信网。

		- 内网内网是相对外网来说的概念

		- 穿透是在跨网（外网访问内网）下的互通

		- 内网穿透即是内网映射，内网（IP）端口映射外网（IP或域名），以实现将内网服务器、网站、和应用发布到外网访问的目的。

		- 通常在内网网络环境搭建服务器（解决无公网IP问题），需要外网访问内网场景（如远程办公）。

		- 可以自己搭建内网穿透服务，也可以直接借助三方内网穿透服务类似有花生壳、nat123、 金万维、等等都可以直接在网上找到。基本功能大同小异，结合自己使用场景需求选择。

		- [文章：内网穿透-理解篇：内网穿透概念（个人理解）](https://blog.csdn.net/u012592994/article/details/103980066)

			- 由于个人的机器一般处于内网环境中，能访问到特定的外部网络，但是外部网络却访问不了内部的机器。也就是说外网ip只能识别外网ip，内网ip只能识别内网ip。如果想实现外网ip识别到内网ip，那就需要使用一种技术，内网穿透。

			- 简单来说呢，内网穿透是先让内网ip先联系上特定的外网ip（A），先建立固定的通道，然后在没有取消的时候一直保持这个通道。所以当前的其他的外网ip能访问到这个特定的外网ip（A）。顺带着也可以访问到这个建立的通道，那么通过这条通道的，其他的外网ip就能访问到个人的机器中。这样就实现了其他外部ip访问到我们内部环境的功能，那么这种方式就叫做内网穿透。

- 架构设计

	- 业务架构

	- 技术架构

- 其他

	- 微前端

	- serverless

	- 前端基础建设

	- 前端监控

	- 前端跨域跨栈

	- 增加代码检查配套工具

	- 前端代码规范

		- [腾讯代码规范](https://tgideas.qq.com/doc/index.html)

		- [ES6编码规范](https://es6.ruanyifeng.com/#docs/style)

		- [prettier](https://prettier.io/playground/#N4Igxg9gdgLgprEAuEAzArlMMCW0AEAEnADYkQDqEATiQCYAUwA5tXHLlM-gLz4A6IABalyggDT5W7eHV74A5IKq06ghZIDOOEghjzUAQxKa4k6AFkI6UwHkAbnGriAvgEp8wflG-58OVAYAQmkOHC43YDYYdGoofCh0MhcAbm9fPz8Aeiz8ABVbABFbJHxC6AV9Gzh8akMoOggAW394tganDN19RJa+C0MYIQA6VHIafAYBoeG6huaGDwAqfABGAFEAagB2N2GYCABlGGpw5kXZuAAHEkMwOAYs-n5h57pNrJxmSUFBN3T4rUOLF4gAeOg4ez4MC3TSaAByhiacB4CmIZEoNHoCnwuBguh4wAABgBNaz4QxsfD2HDaA7UBLoJoAIyc+AAJMBGS0XESXPhLNY7I5qITBdUHE4XAA+AGZfCgzQnaDMaVc0KcZjDTQkHD3Bj4AAMklW+D2BwAqlcrk4AMKGUyLfCbKRsMJcbW6-Wrc0QAAyEAA7naHQ8PC5QVkldQVbLAX4WG7NcMEHRNBQcEMGBI-vgAPwCECF-ClRVXer4JUATwJwGAkHI1FKSn40irChcMokhcjmnLUGl+BcGT8oLgTTj-Bg6qTcDkw58MEj47j8q5DG0ulg-3jmQLgleIBHmVKgiCggXx8jEPs0rSPigLhA4hAECuuGgmmQoEpMcDAAVKQQL8UGMQNDCrL8X2ZOowAAaw4Q5yzAM5kBOdAzBAcdWToOg5z9epmHQQxmDgAAxGgmkGTVkBAQx0AOZ9hBgJoSAoIRMzgPs7jgQ5gMzSFMyrWiwDhJjwlMagYH-OpmCo5AjBMTCACtNAADwAIVghCYEOJE4D9cI4AU4xTBfVS1MOM5dAARXQCB4BMpSX3LahJNo5lDFZEgmKuU5YAzOghmQAAOY0QD8iBTAoOorlovyuKcRwmIAR3s+AZLfEC6M0ABaKB2DwugmLYNKcDYGSSPkpBFLMkBTCaHA0OoDCX20LhbPS4yatMzCYC8wLgqQAAWF8TkMHQzltZpqqwzQAFYmOqPIvJA2rMPsDCAEkOlgQ4wFOd8AEEGmOGtuvWzsgA)

		- 代码优雅写法
![image](assets/2d0b757a76bcf077f0dbf08e4e8a637b7b409a8840eec498a40843c2479fc420.svg)

			- [文章1：如何让你的代码更优雅](https://juejin.cn/post/6962347960340316173)
![image](assets/8f22dee3d3bd9a19e3a9b862780ae26e48b5d8ca28411d48c0e962cf408dd8be.svg)

	- 编码开发

		- 开发工具

			- 编辑器

				- vim

				- vscode

				- sublime

				- webstorm

			- 效率工具

				- build

					- webpack

					- gulp

					- grunt

						- uglify

						- concat

						- cssmin

						- jshint

						- csslint

						- watch

		- 数据准备

			- mockjs

		- 模块定义

			- commonjs

				- [browserify](https://baike.baidu.com/item/browserify/16823990?fr=aladdin)

				  Browserify 可以让你使用类似于 node 的 require() 的方式来组织浏览器端的 Javascript 代码，通过预编译让前端 Javascript 可以直接使用 Node NPM 安装的一些库。
				  
				  install：
				  npm install -g browserify
				  使用 browserify 编译：
				  $ browserify main.js > bundle.js
				  example：
				  这是 main.js 的内容，像普通的 nodejs 程序那样使用 require() 加载库和文件：
				  
				  var foo = require('./foo.js');
				  var bar = require('../lib/bar.js');
				  var gamma = require('gamma');
				  
				  var elem = document.getElementById('result');
				  var x = foo(100) + bar('baz');
				  elem.textContent = gamma(x);
				  导出的方法：
				  
				  module.exports = function (n) { return n * 111 }
				  
				- nodejs

				- grammar rules

			- amd

				- grammar rules

			- cmd

				- grammar rules

			- es6

				- grammar rules

		- 调试

			- chrome控制台

			- firebug

			- [whistle nodejs module](https://wproxy.org/whistle/quickstart.html)

			  快速上手
			  推荐看这篇文章：whistle工具全程入门
			  
			  按上述方法安装好whistle后，用Chrome浏览器打开配置页面: http://local.whistlejs.com
			  
			  如图Rules，whistle的Rules配置页面有一个默认分组Default，用户也可以通过上面的菜单栏按钮Create、Edit、Delete分别创建、重命名、删除自定义分组，whistle先在选中的用户自定义分组中从上到下依次匹配，然后再到Default中匹配(如果Default分组被启用的情况下)。
			  
			  点击页面上方菜单栏的Create按钮，新建一个名为test的分组，并参照下面例子输入对应的规则配置。
			  
			  设置hosts
			  
			  指定www.ifeng.com的ip:
			  
			  www.ifeng.com 127.0.0.1
			  # or
			  127.0.0.1 www.ifeng.com
			  
			  指定www.ifeng.com的ip和端口，把请求转发到本地8080端口，这个在平时开发中可以用来去掉url中的端口号:
			  
			  # www.ifeng.com 127.0.0.1
			  www.ifeng.com 127.0.0.1:8080
			  # or
			  127.0.0.1:8080 www.ifeng.com
			  
			  也可以用某个域名的ip设置hosts
			  
			  www.ifeng.com host://www.qq.com:8080
			  # or
			  host://www.qq.com:8080 www.ifeng.com
			  
			  更多匹配模式参考：匹配模式
			  
			  本地替换
			  
			  平时开发中经常会用到这个功能，把响应替换成本地文件内容。
			  
			  # Mac、Linux
			  www.ifeng.com file:///User/username/test
			  # or www.ifeng.com file:///User/username/test/index.html
			  
			  # Windows的路径分隔符可以用 \ 或者 /
			  www.ifeng.com file://E:\xx\test
			  # or www.ifeng.com file://E:\xx\test\index.html
			  
			  http://www.ifeng.com/会先尝试加载/User/username/test这个文件，如果不存在，则会加载/User/username/test/index.html，如果没有对应的文件则返回404。
			  
			  http://www.ifeng.com/xxx会先尝试加载/User/username/test/xxx这个文件，如果不存在，则会加载/User/username/test/xxx/index.html，如果没有对应的文件则返回404。
			  
			  也可以替换jsonp请求，具体参见tpl
			  
			  更多匹配模式参考：匹配模式
			  
			  请求转发
			  
			  www.ifeng.com域名下的请求都替换成对应的www.aliexpress.com域名
			  
			   www.ifeng.com www.aliexpress.com
			  
			  更多匹配模式参考：匹配模式
			  
			  注入html、js、css
			  
			  whistle会自动根据响应内容的类型，判断是否注入相应的文本及如何注入(是否要用标签包裹起来)。
			  
			  # Mac、Linux
			  www.ifeng.com html:///User/xxx/test/test.html
			  www.ifeng.com js:///User/xxx/test/test.js
			  www.ifeng.com css:///User/xxx/test/test.css
			  
			  # Windows的路径分隔符可以用`\`和`/`
			  www.ifeng.com html://E:\xx\test\test.html
			  www.ifeng.com js://E:\xx\test\test.js
			  www.ifeng.com css://E:\xx\test\test.css
			  
			  所有www.ifeng.com域名下的请求，whistle都会根据响应类型，将处理好的文本注入到响应内容里面，如是html请求，js和css会分别自动加上script和style标签后追加到内容后面。
			  
			  更多匹配模式参考：匹配模式
			  
			  调试远程页面
			  
			  利用whistle提供的weinre和log两个协议，可以实现修改远程页面DOM结构及自动捕获页面js错误及console打印的信息，还可以在页面顶部或js文件底部注入指定的脚步调试页面信息。
			  
			  使用whistle的功能前，先把要相应的系统代理或浏览器代理指向whistle，如何设置可以参考：安装启动
			  
			  weinre：
			  
			  www.ifeng.com weinre://test
			  
			  配置后保存，打开www.ifeng.com，鼠标放在菜单栏的weinre按钮上会显示一个列表，并点击其中的test项打开weinre的调试页面选择对应的url切换到Elements即可。
			  
			  log:
			  
			   www.ifeng.com log://{test.js}
			  
			  配置后保存，鼠标放在菜单栏的weinre按钮上会显示一个列表，并点击其中的test.js项，whistle会自动在Values上建立一个test.js分组，在里面填入console.log(1, 2, 3, {a: 123})保存，打开Network -> 右侧Log -> Page，再打开www.ifeng.com，即可看到Log下面的Page输出的信息。
			  
			  更多匹配模式参考：匹配模式
			  
			  手机设置代理￼
			  
			  iOS￼
			  
			  
			  Android
			  
			  更多功能请参考：协议列表
			  
			  
		- 测试

			- grunt

				- qunit等

			- gulp

				- 插件

		- 版本管理

			- git github

			- svn

		- Mrm

			- [官网](https://mrm.js.org/docs/making-tasks)

			- [npm地址](https://www.npmjs.com/package/mrm)

			- Command line tool to help you keep configuration (package.json, .gitignore, .eslintrc, etc.) of your open source projects in sync

			- 看起来，是跑任务的，有点意思

- 图像

### 16.5.2. [soft skills软能力图](https://blog.csdn.net/frontend_frank/article/details/118886427)

- 技术能力

	- 基础技能

	- 项目技能

	- 快速掌握和上手新技术的能力

	- 指导和帮助初级同学解决问题

	- 原型

		- [蓝湖](https://lanhuapp.com/web/#/item)

			- 上传图片，然后快速添加交互

				- 新增团队

				- 设置团队名称

				- 上传页面图片

				- 添加交互

		- [摹客](https://app.mockplus.cn/team/xpsmbtajpw)

- 规划能力

	- 技术体系规划

	- 任务划分规划 

	- 风险规划

	- 突发情况应对能力

- 业务能力

	- 整理的业务目标是什么

	- 梳理业务流程

		- 流程图

		- 泳道图

	- 业务关键字段和数据在我们系统上的体现

	- 有效的参与业务评审，考虑业务和技术实现的结合

- 协作能力

	- 和项目团队

	- 和部门团队

- 心理能力

	- 心态定位

	- 自我要求

	- 自我化解

- 沟通能力

	- 表达方式

	- 表达对象重点

	- 输入输出

- 判断能力

	- 风险判断

	- 决策判断

	- 技术判断

- 框架能力

	- 脚手架

	- 系统层级

	- 菜单、权限

	- 数据流、高阶函数处理

	- 分析问题、解决问题能力

	- 打包、环境配置

- 架构能力

	- 根据业务需要做一些改动支持业务需求

	- 其他

## 16.6. ssh端口转发

### 16.6.1. ssh隧道通讯

- 本地端口转发
![image](assets/192be5f17ad4ef6ad5dcc2d0fe2f925a6ca0ef0c3150bae00412f62c4f267457.png)

	- 云主机 暴露端口

		- 借助云主机访问一下云里的私有资源

			- 不想花钱买一个浮动的公网ip

			- 想通过云来跳转

		- 云主机中使用docker启动了nginx 8080端口

			- 需要启动安全组把8080暴露出去

			- 需要配置安全组

			- 不能常开安全组

		- ssh -L 8080:localhost:8080 root@47.100.18.162

			- 这样云主机中的8080端口（nginx），就可以被访问了

			- 省去了localhost，只有本机可以访问

			- 如果需要本地局域网可以访问的话，需要配置192.168.2.131

- 本地想访问远端的地址，找不到能到达他的地方，但是两个都能访问公网

	- 远程端口
![image](assets/fca82929bb6eb62bf0664072ad9c2864a0155dd21a9d4a1c0ec63567cafa208a.png)

		- 安全组中放开8000端口
![image](assets/a12adbe4fc69e5ba215f37d91ad4fc7693cf0e2db2a3d4cc57fbbda0b130831a.png)

		- vim /etc/ssh/sshd_config 开启一个字段 GatewayPorts yes
systemctl restart sshd

		- ssh -R 0.0.0.0:8000:10.10.10.2:80 root@47.100.18.162

		- netstat -anp| grep 8000
![image](assets/ac2928cd1e9acf431d94ac50374bcd559b633cfcb24bef650bd5c44708fe6e79.png)

### 16.6.2. 本地端口
![image](assets/2e5fa865ecb7ed1fb2f3646687e64bc303dab294c82ba8db3665f8cd5dffc1ab.png)

-  
![image](assets/0cbaab2d8b01a6edb56d7756de478c0162152171c19efdd0d317a8d3b6883777.png)

### 16.6.3. 远程端口
![image](assets/5e64af97f630946a5d7884feee53e646b661a565a4955bdbf70e8dd4bb8d6947.png)

-  
![image](assets/97c21f63e23b10e4e302141ec5a2bf069c0540af95a92d012c5f2d3f94ba9cbb.png)

- 发起ssh命令的是属于跳板机的角色

	- 可以访问一个客户端无法访问的ip和端口

		- 例子中的10.10.10.2:80起的一个openStack服务

	- 也可以访问公网的云服务器

- 发起命令之后，命令行进入了云服务器中

	- 可以 netstat -anp | grep 8000 可以看到 监听了8000端口，转发到10.10.10.2

- 47.100.18.162:8000

	- 访问10.10.10.2:80端口的服务了

### 16.6.4. autossh 保持ssh连接

### 16.6.5. [视频地址](https://www.bilibili.com/video/BV1C7411P7Er?p=1)

### 16.6.6. [有道笔记](https://note.youdao.com/s/dQFP9jzA)

## 16.7. 计算机网络: IP地址，子网掩码，网段表示法，默认网关，DNS服务器详解

### 16.7.1. IP地址网段表示法

- 172.12.34.0/25

- 子网掩码：用于表示IP地址中的多少位用来做主机号。因为"其中值为1的比特留给网络号和子网号，为0的比特留给主机号"（TCP/IP V1）。

- 172.12.34.0/25含义：

- 172.12.34.0——表示一个子网号

- 25——表示采用子网掩码的二进制中的前25位为有效位，即用 32-25=7big 来表示主机号，该子网可以容纳 2^7-2=126台主机。

- 因此172.12.34.0/25 表示IP范围为 172.12.34.1～172.12.34.126

- [地址](https://www.cnblogs.com/amyzhu/p/11396136.html)

### 16.7.2. 什么是网关？

- 可以联想下海关？什么是海关？）

- 连接两个不同的网络的设备都可以叫网关设备；网关的作用就是实现两个网络之间进行通讯与控制。

- 网关设备可以是 交互机（三层及以上才能跨网络）、路由器、启用了路由协议的服务器、代理服务器、防火墙等

- 网关地址就是网关设备的IP地址。

- 假设我们有两个网络：

	- 网络A的IP地址范围为“192.168.1.1~192.168.1.254”，子网掩码为255.255.255.0

	- 网络B的IP地址范围为“192.168.2.1~192.168.2.254”，子网掩码为255.255.255.0

	- 要实现这两个网络之间的通信，则必须通过网关。

	- 如果网络A中的主机发现数据包的目的主机不在本地网络中，就把数据包转发给它自己的网关，再由网关转发给网络B的网关，网络B的网关再转发给网络B的某个主机（如附图所示）。网络A向网络B转发数据包的过程。

	- 只有设置好网关的IP地址，TCP/IP协议才能实现不同网络之间的相互通信。

- 默认网关 

	- 一台主机可以有多个网关。默认网关的意思是一台主机如果找不到可用的网关，就把数据包发给默认指定的网关，由这个网关来处理数据包。现在主机使用的网关，一般指的是默认网关。

- 扩展：自动设置默认网关

	- 自动设置就是利用DHCP（Dynamic Host Configuration Protocol, 动态主机配置协议）服务器来自动给网络中的计算机分配IP地址、子网掩码和默认网关 。

	- 一旦网络的默认网关发生了变化时，只要更改了DHCP服务器中默认网关的设置，那么网络中所有的计算机均获得了新的默认网关的IP地址。这种方法适用于网络规模较大、TCP/IP参数有可能变动的网络。

	- 另外一种自动获得网关的办法是通过安装代理服务器软件（如MS Proxy）的客户端程序来自动获得，其原理和方法和DHCP有相似之处。

- 扩展说明

	- 问：在网上看到一些人提问：连接到相同（二层）交换机或集线器上的计算机，如果设置不同的网络地址，为什么不能通信。

	- 答：

		- 在 TCP/IP 协议中，网络层（通过IP地址识别通信方）封包完成交给下一层数据链路层（通过MAC地址识别通信方）时，需要通过 ARP 广播 获取目标 IP 对应的 MAC 地址。

		- 但因为 ARP 报文只能在相同网络地址内广播，如果目标计算机与源计算机处于不同网络，则无法进行响应，因此源计算机无法完成链路层数据的封装。

		- [ARP 协议相关信息可见 这里。](https://baike.baidu.com/item/ARP/609343)
![image](assets/b633b141a9110019a990c689e2cb3b1b3b0b7bec673ced6040047dea878c40aa.png)

### 16.7.3. DNS服务器

- [参考：《DNS原理及其解析过程》](https://blog.51cto.com/369369/812889)

- 　　域名与DNS

- 我们访问一个网站的时候，往往使用的是域名（相对IP来说更加语义清晰、更加容易记忆，例如 www.baidu.com)。

- 域名是由一串用点分隔的名字组成的，通常包含组织名，而且始终包括两到三个字母的后缀，以指明组织的类型或该域所在的国家或地区。

- 然而计算机之间的通信网络通信是通过IP进行的， 因此需要将域名解析为对应的IP，DNS就是进行域名解析的服务器。

- DNS 维护着 域名(domain name)和IP地址 (IP address)的对照表表，以解析消息的域名。

- DNS 查询的过程如下图所示
![image](assets/8e2fba53ef260d127be4a9a863b62aad883ca6fab88520c72218412d14f78008.png)

- DNS 维护着 域名(domain name)和IP地址 (IP address)的对照表表，以解析消息的域名。

	- 1、在浏览器中输入www.qq.com域名，操作系统会先检查自己本地的hosts文件是否有这个网址映射关系，如果有，就先调用这个IP地址映射，完成域名解析。 

	- 2、如果hosts里没有这个域名的映射，则查找本地DNS解析器缓存，是否有这个网址映射关系，如果有，直接返回，完成域名解析。

	- 3、如果hosts与本地DNS解析器缓存都没有相应的网址映射关系，首先会找TCP/ip参数中设置的首选DNS服务器，在此我们叫它本地DNS服务器，此服务器收到查询时，如果要查询的域名，包含在本地配置区域资源中，则返回解析结果给客户机，完成域名解析，此解析具有权威性。 

	- 4、如果要查询的域名，不由本地DNS服务器区域解析，但该服务器已缓存了此网址映射关系，则调用这个IP地址映射，完成域名解析，此解析不具有权威性。 

	- 5、如果本地DNS服务器本地区域文件与缓存解析都失效，则根据本地DNS服务器的设置（是否设置转发器）进行查询，如果未用转发模式，本地DNS就把请求发至13台根DNS，根DNS服务器收到请求后会判断这个域名(.com)是谁来授权管理，并会返回一个负责该顶级域名服务器的一个IP。本地DNS服务器收到IP信息后，将会联系负责.com域的这台服务器。这台负责.com域的服务器收到请求后，如果自己无法解析，它就会找一个管理.com域的下一级DNS服务器地址(qq.com)给本地DNS服务器。当本地DNS服务器收到这个地址后，就会找qq.com域服务器，重复上面的动作，进行查询，直至找到www.qq.com主机。 

	- 6、如果用的是转发模式，此DNS服务器就会把请求转发至上一级DNS服务器，由上一级服务器进行解析，上一级服务器如果不能解析，或找根DNS或把转请求转至上上级，以此循环。不管是本地DNS服务器用是是转发，还是根提示，最后都是把结果返回给本地DNS服务器，由此DNS服务器再返回给客户机。

### 16.7.4. IP地址分类（A/B/C/D/E/F类）

- [地址](http://www.t086.com/article/5090)

## 16.8. 常见设计模式

### 16.8.1. 一：理解工厂模式

- 工厂模式类似于现实生活中的工厂可以产生大量相似的商品，去做同样的事情，实现同样的效果;这时候需要使用工厂模式。

- 简单的工厂模式可以理解为解决多个相似的问题;这也是她的优点;

	- 例子：
![image](assets/2124c8e435ec08b76de503f378414873922c68583ff4918114c68a07a425870c.png)

- 复杂的工厂模式定义是：将其成员对象的实列化推迟到子类中，子类可以重写父类接口方法以便创建的时候指定自己的对象类型。

	- 父类只对创建过程中的一般性问题进行处理，这些处理会被子类继承，子类之间是相互独立的，具体的业务逻辑会放在子类中进行编写。

	- 父类就变成了一个抽象类，但是父类可以执行子类中相同类似的方法，具体的业务逻辑需要放在子类中去实现；比如我现在开几个自行车店，那么每个店都有几种型号的自行车出售。我们现在来使用工厂模式来编写这些代码;

	- 父类的构造函数如下：

		-  
![image](assets/2e038e46eecaf731f608172539f8bbef7ab25529297a80cf9a0269c0ef2a3f0b.png)

	- 原型继承：

		-  
![image](assets/7259483838f44cd80edc60f7c454eb2e493d068388d772ab2e22edd8bba876a8.png)

			- 逆向模拟原型链的使用

			- 理解：
1.背景：中间的构造函数的原型设为超类的原型，子类的原型设为中间构造函数的实例，这样子类就是超类的后代
F：女人，F.prototype：F的老公
F.prototype = Sup.prototype;F认Sup的老公为自己的老公
Sub.prototype = new F();F生了一个儿子，Sub认F的儿子为老公
Sub.prototype.constructor = Sub;确认一下Sub的老公的老婆是Sub
Sub.sup = Sup.prototype;Sub将Sup的老公存为sup
2.原理：
2.1实例上有一个属性__proto__指向他的原型（父亲）
2.2构造函数有个prototype属性指向他的原型（老公）
2.3原型对象上有个constructor属性指向他的构造函数（老婆）

		- 原型继承基础知识

			- 原型图：所以设置构造函数的原型属性（prototype）为某一个对象，然后通过new 操作符创建对象实例，该对象实例就拥有了原型对象上的方法
![image](assets/85ed8dd4ef3dce33bd70045cf580024c615e559d82e96df1de2d46e1b83b0cc5.png)

			- prototype 和 __proto__，图示：
![image](assets/f45224723371aa4487e1289b8d9821d96d5d2ae26e14096ddf6db67877b6020e.png)

			- 原型链，查找valueOf图示：
![image](assets/b2ebe734c1a6e79124e4e022acbf0a57de37915cee3e4d36392e7139dd288b7a.png)

	- 子类：

		-  
![image](assets/c8d88e3ce959afe63fcaf84885d4dba9c39844fdb5e6d4816c48ada1b9f0d7c4.png)

	- 好处：

		- 工厂模式最重要的优点是：可以实现一些相同的方法，这些相同的方法我们可以放在父类中编写代码，那么需要实现具体的业务逻辑，那么可以放在子类中重写该父类的方法，去实现自己的业务逻辑；

		- 第一：弱化对象间的耦合，防止代码的重复。在一个方法中进行类的实例化，可以消除重复性的代码。

		- 第二：重复性的代码可以放在父类去编写，子类继承于父类的所有成员属性和方法，子类只专注于实现自己的业务逻辑。

### 16.8.2. 二：理解单体模式

- 单体模式提供了一种将代码组织为一个逻辑单元的手段，这个逻辑单元中的代码可以通过单一变量进行访问。

- 单体模式的优点是：

	- 可以用来划分命名空间，减少全局变量的数量。

	- 使用单体模式可以使代码组织的更为一致，使代码容易阅读和维护。

	- 可以被实例化，且实例化一次。

### 16.8.3. 三：理解模块模式

### 16.8.4. 四：理解代理模式

### 16.8.5. 五：理解职责链模式

### 16.8.6. 六：命令模式的理解：

### 16.8.7. 七：模板方法模式

### 16.8.8. 八：理解javascript中的策略模式

### 16.8.9. 九：Javascript中理解发布--订阅模式

### 16.8.10. 十：理解中介者模式

### 16.8.11. 参考链接：

- [1.代码越写越乱？那是因为你没用责任链](https://juejin.cn/post/7100859237735563301)

## 16.9. 字符编码问题和二进制

### 16.9.1. URI vs URL

### 16.9.2. 文章：javascript 字符串进行 utf8 编码的方法（转

- [地址](https://www.cnblogs.com/zhangdaicong/p/7696738.html)

### 16.9.3. 文章:通过javascript进行UTF-8编码的实现方法

- [地址](https://www.jb51.net/article/87418.htm)

### 16.9.4. 二进制相关的对象

- FIleReader

	- HTML5定义了FileReader作为文件API的重要成员,用于读取文件，根据W3C的定义，FileReader接口提供了读取文件的方法和包含读取结果的事件模型。

	- 创建实例

		- var reader = new FileReader();

	- 方法

		-  
![image](assets/83eeda380f1303a14b737fed34b00e3861f99a8e8c521caf6ce671d84f2f756f.png)

	- 事件

		-  
![image](assets/588a0239b685b5887e6595f8fb0e4ef24b67402b8fdb14e1ec82ee8cb171b99f.png)

	- 例子

		- 下面我们尝试把一个文件的内容通过字符串的方式读取出来：

		-  
![image](assets/9517dae1d11db3bf30653bd18cddbfb5ad190c611086e01ebb42366826b38c43.png)

- canvas

	- 使用js转化画布与图片（canvas与img）

		- 1、使用JavaScript将图片拷贝进画布

			- 将图片放入画布里，使用canvas元素的drawImage方法即可：
![image](assets/9aaa66b6cd19bd820f6087921d26f9a966dcfcdf338e56a4273413bb3d09e328.png)

		- 2、用JavaScript将画布保存成图片格式

			- 画布上的作品已经处理完成，可以用toDataURL将canvas数据转换成图片格式（png）：
![image](assets/0018128002075376df240ed3bf57c67133e3bba389fa799cc42da1b91d5fe9f9.png)

	- drawImage：向画布上绘制图像、画布或视频

		- [例子](https://www.w3school.com.cn/tiy/t.asp?f=eg_html5_canvas_drawimage3)
![image](assets/524d53d50b5b504a85ceacee2d9852e644d233a54bfcb221ae32e5cdbf22ff8d.png)

		- 参数
![image](assets/5346d404e3f9a91d1b1ed2c5bce3ea8d9f16dfe914b3bccd5499042f87d8331d.png)

	- createImageData：创建新的、空白的 ImageData 对象

		- createImageData() 方法创建新的空白 ImageData 对象。新对象的默认像素值 transparent black。

			- 对于 ImageData 对象中的每个像素，都存在着四方面的信息，即 RGBA 值：

			- R - 红色 (0-255)

			- G - 绿色 (0-255)

			- B - 蓝色 (0-255)

			- A - alpha 通道 (0-255; 0 是透明的，255 是完全可见的)

			- 特点

				- 因此 ，transparent black 表示 (0,0,0,0)。

				- color/alpha 以数组形式存在，并且既然数组包含了每个像素的四条信息，数组的大小是 ImageData 对象的四倍。（获得数组大小有更简单的办法，就是使用 ImageDataObject.data.length）

				- 包含 color/alpha 信息的数组存储于 ImageData 对象的 data 属性中。

				- 提示：在操作完成数组中的 color/alpha 信息之后，您可以使用 putImageData() 方法将图像数据拷贝回画布上。

		- 【语法】

			-  
![image](assets/0f4f49dfb0d71aeaf7a3cfb58817ae9717e67247ce6dbcd926e78c2586be9390.png)

		- 【参数】

			-  
![image](assets/17a4839b81d7e2c0291e71aac7fce1056965e5d8bfc4be632662d554fe5ff2dc.png)

	- getImageData：返回 ImageData 对象，该对象为画布上指定的矩形复制像素数据

		- 【语法】

			-  
![image](assets/b18c4b17ea7951d87e97aefc51ab31a773f2274931ed04a48d2c855d42692de2.png)

		- 【参数】

			-  
![image](assets/c036d9dae6ef4a30bed5e77815f9a66d98a5c64e7245c4c7ec3ae68b554c3e96.png)

	- putImageData：把图像数据（从指定的 ImageData 对象）放回画布上

		- 【语法】

			-  
![image](assets/a77325b6ce248dfda7fa4e74501e04767672d8e0f91af9dbc8ecac6d66b9b3ed.png)

		- 【参数】

			-  
![image](assets/336c2c7f16bb28d2ca02f74d647c48f4a351df266de7bba3e9f14220355c4bdb.png)

		- 【例子】

			-  
![image](assets/45191b6eea45b976b01753406f8bccb5dd6ab57bf068964e20d6279cc25dfb22.png)

	- toDataURL

	- [图像处理文章：JavaScript中的图片处理与合成(四)](https://juejin.cn/post/6844903570446221319)

- ArrayBuffer/TypedArray/DataView 对象

	- ArrayBuffer

		- 【定义】

			- ArrayBuffer 对象用来表示通用的、固定长度的原始二进制数据缓冲区。

		- 【语法】

			- // new ArrayBuffer(length)

			- 参数说明：

				- // 参数：length 表示要创建的ArrayBuffer的大小，单位为字节

				- // 返回值：ArrayBuffer对象

				- // 异常：如果length大于Number.MAX_SAFE_INTEGER （>= 2** 53）或者为负数，则跑出一个RangError异常

		- 【实例】

			- const buffer = new ArrayBuffer(32);

// console.log(buffer); // ArrayBuffer(32)

buffer.byteLength; // 32

const v = new Int32Array(buffer);

// console.log(v)  // Int32Array(8) [0, 0, 0, 0, 0, 0, 0, 0]
// 32*8 / 32 8个元素

ArrayBuffer.isView(v); // true

const buffer2 = buffer.slice(0, 1);

// console.log(buffer2) // ArrayBuffer(1)

				- // 上面代码表示实例对象buffer占用32个字节
// 它有实例属性byteLength，表示当前实例占用的内存字节长度
// 它拥有一个静态方法isView()，这个方法可以用来判断是否为TypedArray实例或DataView实例
// 它拥有实例方法slice()，用来复制一部分内存，使用方式同数组的slice方法

// 除了slice方法，ArrayBuffer对象不提供任何直接读写内存的方法，只允许在其上方建立视图，然后通过视图读写


		- 【特点】

			- ArrayBuffer 不能直接操作,而是要通过类型数组对象或 DataView 对象来操作,它们会将缓冲区中的数据表示为特定的格式,并通过这些格式来读写缓冲区的内容.

			- ArrayBuffer也是一个构造函数，可以分配一段可以存放数据的连续内存区域。

				- const buffer = new ArrayBuffer(8);

				- // ArrayBuffer 对象有实例属性 byteLength ，表示当前实例占用的内存字节长度（单位字节）

				- console.log(buffer.byteLength);

			- 由于无法对 Arraybuffer 直接进行操作,所以我们需要借助其他对象来操作. 所有就有了 TypedArray(类型数组对象)和 DataView对象。

		- 【应用图解】

			-  
![image](assets/df47ba4a12002abf280ec89d423107802e21c2696ed78d9edd58b5e36a98dddc.png)

				- 先来介绍ArrayBuffer ,是因为 FileReader 有个 readAsArrayBuffer()的方法,如果被读的文件是二进制数据,那用这个方法去读应该是最合适的,读出来的数据,就是一个 Arraybuffer 对象

	- 视图一：DataView 对象

		- 【介绍】

			- 上面代码生成了一段 8 字节的内存区域，每个字节的值默认都是 0。

			- 为了读写这段内容，需要为它指定视图。DataView视图的创建，需要提供ArrayBuffer对象实例作为参数。

		- 【定义】

			- 【DataView】 视图是一个可以从二进制ArrayBuffer对象中读写多种数值类型的底层接口。使用它时，不用考虑不同平台的字节序问题。

				- setint8() 从DataView起始位置以byte为计数的指定偏移量（byteOffset）处存储一个8-bit数（一个字节）

				- getint8() 从DataView起始位置以byte为计数的指定偏移量（byteOffset）处获取一个8-bit数（一个字节）

				- ❝
字节顺序，又称端序或尾序（英语：Endianness），在计算机科学领域中，指存储器中或在数字通信链路中，组成多字节的字的字节的排列顺序。
字节的排列方式有两个通用规则。例如，一个多位的整数，按照存储地址从低到高排序的字节中，如果该整数的最低有效字节（类似于最低有效位）在最高有效字节的前面，则称小端序；反之则称大端序。在网络应用中，字节序是一个必须被考虑的因素，因为不同机器类型可能采用不同标准的字节序，所以均按照网络标准转化。
例如假设上述变量 x 类型为int，位于地址 0x100 处，它的值为 0x01234567，地址范围为 0x100~0x103字节，其内部排列顺序依赖于机器的类型。大端法从首位开始将是：0x100: 01, 0x101: 23,..。而小端法将是：0x100: 67, 0x101: 45,..。
❝

		- 【语法】

			- new DataView(buffer, [, byteOffset [, byteLength]])

			- 相关的参数说明如下：

				- buffer：ArrayBuffer 对象 或 SharedArrayBuffer 对象；

				- byteOffset（可选）：此 DataView 对象的第一个字节在 buffer 中的字节偏移。如果未指定，则默认从第一个字节开始；

				- 异常：此 DataView 对象的字节长度。如果未指定，这个视图的长度将匹配 buffer 的长度；

		- 【示例】

			- let buffer = new ArrayBuffer(2);
console.log(buffer.byteLength); // 2
let dataView = new DataView(buffer);
dataView.setInt8(0, 1);
dataView.setInt8(1, 2);
console.log(dataView.getInt8(0)); // 1
console.log(dataView.getInt8(1)); // 2
console.log(dataView.getInt16(0)); // 258

				- 例子2

					- const buffer = new ArrayBuffer(16);
const view = new DataView(buffer, 0);

view.setInt8(1, 68);
view.getInt8(1); // 68

		- 【特殊情况】

			- 如果一次操作（get或者set）两个或两个以上字节，就必须明确数据的存储方式，到底是小端字节序还是大端字节序。

			- DataView的操作方法默认使用大端字节序解读数据，如果需要使用小端字节序解读，必须在操作方法中指定参数为true（get方法的第二个参数和set方法的第三个参数）。

			- 例子

				- const buffer = new ArrayBuffer(24);
const dv = new DataView(buffer);
// 1个字节，默认大端字节序
const v1 = dv.getUint8(0);
// 小端字节序
const v1 = dv.getUint16(1, true);
// 大端字节序
const v2 = dv.getUint16(3, false);
// 在第5个字节，以小端字节序写入值为11的32位整数
dv.setInt32(4, 11, true);

		- 对于直接处理ArrayBuffer对象的业务场景不是特别多，特别是写页面比较多的同学。笔者深刻认识并运用的场景，主要是在处理比较复杂且数据量比较大的点云数据，前端接收到的点云数据已经是原始采集数据转换过的二进制数据，前端需要对二进制数据进行解析，运用的解析方法就是上述提到的各种方法。下面介绍一下业务场景中比较常见到的一种二进制表示类型——Blob。

	- 图示二：TypedArray

		- 【定义】

			- 另一种TypedArray视图，与DataView视图的一个区别是，它不是一个构造函数，而是一组构造函数，代表不同的数据格式。

			- TypedArray对象描述了一个底层的二进制数据缓存区（binary data buffer）的一个类数组视图（view）。

			- TypedArray一共包含九种类型，每一种都是一个构造函数。（DataView视图不支持Uint8ClampedArray，其他都支持）

		- 【方法】

			- 常用的实现方法
![image](assets/0e0c1be58f095650b1dd32f36fe23a2a7b64a2f1237b3e949920dddc5ef8228e.png)

			- 所有方法
![image](assets/cb95fbe54c31c4990441160488672a28a4ee72d1aa826c423d165441413404d0.png)

			- 方法中的数字，是指的位数

		- 【静态属性】

			- 每一种视图都有一个BYTES_PER_ELEMENT常数，表示这种数据类型占据的字节数。

				- Int8Array.BYTES_PER_ELEMENT // 1
Uint8Array.BYTES_PER_ELEMENT // 1
Int16Array.BYTES_PER_ELEMENT // 2
Uint16Array.BYTES_PER_ELEMENT // 2
Int32Array.BYTES_PER_ELEMENT // 4
Uint32Array.BYTES_PER_ELEMENT // 4
Float32Array.BYTES_PER_ELEMENT // 4
Float64Array.BYTES_PER_ELEMENT // 8

		- 【例子】

			- const buffer = new ArrayBuffer(8);
console.log(buffer.byteLength); // 8
const int8Array = new Int8Array(buffer);
console.log(int8Array.length); // 8
const int16Array = new Int16Array(buffer);
console.log(int16Array.length); // 4

		- 【特点】

			- 这 9 个构造函数生成的数组，统称为TypedArray视图。它们很像普通数组，都有length属性，普通数组的操作方法和属性，对TypedArray 数组完全适用。

		- 【跟普通数组的差异】

			- 图示
![image](assets/50b804d61808b2132d36edc02f8d3a2cb7cbe181b4e7e7434d5d3f94852656be.png)

		- 【转换】

			- TypedArray和Array之间也可以互相转换

			- 代码：

				- const typedArray = new Uint8Array([1, 2, 3, 4]);
const normalArray = Array.apply([], typedArray);

		- 「建立TypedArray视图」

			- // 创建一个8字节的ArrayBuffer
const a = new ArrayBuffer(8);

// 创建一个指向a的Int32视图，开始于字节0，直到缓冲区的末尾
const a1 = new Int32Array(a);

// 创建一个指向a的Uint8视图，开始于字节4，直到缓冲区的末尾， 为什么第二个参数的单位是字节，因为就是arraybuffer实例的描述单位
const a2 = new Uint8Array(a, 4);

// 创建一个指向a的Int16视图，开始于字节4，长度为2
const a3 = new Int16Array(a, 4, 2);

			- 上面代码在一段长度为 8 个字节的内存（a）之上，生成了三个视图：a1、a2和a3。

		- 【参数】

			- 视图的构造函数可以接受三个参数：

				- 第一个参数（必选）：视图对应的底层ArrayBuffer对象；

				- 第二个参数：视图开始的字节序号，默认从 0 开始；

				- 第三个参数：视图包含的数据个数，默认直到本段内存区域结束；

			- 建立了视图以后，就可以进行各种操作了

			- 这里需要明确的是，视图其实就是普通数组，语法完全没有什么不同，只不过它直接针对内存进行操作，而且每个成员都有确定的数据类型。所以，视图就被叫做“类型化数组”。

		- 「TypedArray视图操作」

			- 上面代码生成一个8字节的ArrayBuffer对象，然后在它的基础上，建立了一个16位整数的视图。

				- const buffer = new ArrayBuffer(8);
 
const int16View = new Int16Array(buffer);
 
for (let i = 0; i < int16View.length; i++) {
  int16View[i] = i * 2;
}
console.log(int16View) // [0, 2, 4, 6]

				- 由于每个字节占据8位，那么16位就占据了2个字节（1个字节等于8位），所以一共可以写入4个整数，依次为0，2，4，6。

			- 如果在这段数据上接着建立一个8位整数的视图，则可以读出完全不一样的结果。

				- const int8View = new Int8Array(buffer);
 
for (let i = 0; i < int8View.length; i++) {
  int8View[i] = i;
}

console.log(int8View) // [0, 0, 2, 0, 4, 0, 6, 0]

				- 首先整个ArrayBuffer对象会被分成8段。然后，由于x86体系的计算机都采用小端字节序（具体概念理解请自主查询），相对重要的字节排在后面的内存地址，相对不重要字节排在前面的内存地址，所以就得到了上面的结果。还可以看到下面这个例子

			- 例子

				- const buffer = new ArrayBuffer(4);
const v1 = new Uint8Array(buffer);
v1[0] = 10;
v1[1] = 3;
v1[2] = 11;
v1[3] = 8;

console.log(v1) // [10, 3, 11, 8]

const uInt16View = new Uint16Array(buffer); // [0xa, 0x3, 0xb, 0x8]

console.log(uInt16View) // 计算机采用小端字节序 [0x030a, 0x080b] => [778, 2059]

				- **如果一段数据是大端字节序（大端字节序主要用于数据传输），TypedArray 数组将无法正确解析，因为它只能处理小端字节序！为了解决这个问题，JavaScript 引入DataView对象，可以设定字节序。**

- FormData

	- 家臣之FormData对象

	- XMLHttpRequest Level 2添加了一个新的接口FormData. 利用FormData对象，我们可以通过JavaScript用一些键值对来模拟一系列表单控件，我们还可以使用XMLHttpRequest的send()方法来异步的提交这个”表单”。比起普通的ajax, 使用FormData的最大优点就是我们可以异步上传一个二进制文件。

	- 以上为官方口吻的解释，略抽象。我们应该都用过jQuery，其中有个方法叫做serialize(), 作用就是表单序列化，也就是以查询字符串形式获得类表单post/get的数据给Ajax请求，例如：userid=123&username=zxx.

	- FormData对象的作用就类似于这里的serialize()方法，不过FormData是浏览器原生的，且支持二进制文件，是个一眼就会让人喜欢的很赞的东西！

	- IE10+浏览器已经良好支持了，下面要介绍的其他家臣也都是IE10+支持。

	- 实际使用是作为构造函数，如下：

	- new FormData ([可选]HTMLFormElement)

	- HTMLFormElement这个参数可选，可有可无。表示form表单元素，就是我们要序列化，要提交的那个表单元素。

	- 例如：

	- var newFormData = new FormData(someFormElement);

	- newFormData就是someFormElement这个表单元素中所有键值对数据了。

	- FormData提交格式的每个数据分三部分：

		- 第一部分也就是第一行，表示“分界线(boundary)”，我尚未深入研究这个分界线，不过，我没估计错的话，二进制大文件分隔传输时候，就是使用这个分界线。在webkit核心中，使用“——WebKitFormBoundary”加16位随机Base64位编码的字符串作为分隔边界。根据Firebug的显示，Firefox中，似乎是使用很多个"-"加时间戳进行边界分隔的。这里的边界的作用比较单纯，可能就是把表单的这两个字段作为两个独立数据流传输。

		- 第二部分也就是第二行，表示内容配置，这里都是统一的form-data（因为是FormData对象格式提交的），然后紧跟着name键值。

		- 第三部分就是第三行，表示传输的值。

		- FormData对象还有一个方法，为append()方法，可以人为的给当前FormData对象添加一个键/值对。

- Blob

	- 【基本介绍】

		- Blob 对象比较常用于文件上传、文件读写操作等。

		- 在对文件读写的时候，我们更多的时候只是操作File对象，而File继承了所有Blob的属性。

		- Blob是用来支持文件操作的。简单的说：在JS中，有两个构造函数 File 和 Blob, 而File继承了所有Blob的属性。

		- 所以在我们看来，File对象可以看作一种特殊的Blob对象。

		- 而Blob 对象与 ArrayBuffer 的区别在于，Blob 对象用于操作二进制文件， ArrayBuffer 用于直接操作内存

			- Blob对象跟ArrayBuffer关系

				- 图示
![image](assets/1df57bed86c9fc776afdfd495c1e3c39861a5b15b98a1970c20cfd59b6c59f8e.png)

	- 【语法】

		- const blob = new Blob(array [, options]);

	- 【参数】

		- array：字符串或二进制对象，表示新生成的Blob实例对象的内容；

		- options（可选）：比较常用的属性 type，表示数据的 MIME 类型，默认空字符串；

	- 【示例】

		- const array = ['<h1>Hello World!</h1>'];
const blob = new Blob(array, {type : 'text/html'});

	- 【属性和方法】

		- 图示
![image](assets/7bb0b4e42a02d4df73ad9d4cee6c46e847cf998d2cbbbbaff22982a4788147c8.png)

		- Blob对象拥有size和type两个属性，以及多种自有方法。

		- 比较常用的方法slice、arrayBuffer等；

			- slice方法主要用来拷贝原来的数据，返回的也是一个Blob实例，这个方法可以用来做切片上传。

			- arrayBuffer方法返回一个 Promise 对象，包含 blob 中的数据，并在 ArrayBuffer 中以二进制数据的形式呈现。

		- 代码

			- const blob = new Blob([]);
blob.slice(0, 1);
blob.arrayBuffer().then(buffer => /* 处理 ArrayBuffer 数据的代码……*/);
![image](assets/1ef0baea960ea91dff01fa6b62e54ef5aac071db8a1927815a8471a2ade8d1c8.png)

	- 【Blob的应用】

		- 上面说了，File对象是一种特殊的Blob对象，那么它自然就可以直接调用Blob对象的方法。让我们看一看Blob具体有哪些方法，以及能够用它们实现哪些功能:

			-  
![image](assets/61684f32d734ba9d143b1c39d1f2e3cc96629dcf5a5699a04e4f9da4adb8409e.png)

		- Blob URL

			- 通过window.URL.createObjectURL方法可以把一个blob转化为一个Blob URL，并且用做文件下载或者图片显示的链接。

			- Blob URL所实现的下载或者显示等功能，仅仅可以在单个浏览器内部进行。而不能在服务器上进行存储，亦或者说它没有在服务器端存储的意义。

			- 下面是一个Blob的例子，可以看到它很短

				- blob:d3958f5c-0777-0845-9dcf-2cb28783acaf

			- 和冗长的Base64格式的Data URL相比，Blob URL的长度显然不能够存储足够的信息，这也就意味着它只是类似于一个浏览器内部的“引用“。从这个角度看，Blob URL是一个浏览器自行制定的一个伪协议。

		- 【文件下载】

			- 后端提供或者返回Blob文件

				- 文件下载场景背景

					- 1. 文件下载地址在服务器上，a标签加上download属性，直接点击就可以下载了

					- 2. 文件是浏览器端js生成的内容或者后端返回blob格式给前端，浏览器进行下载

				- 后端返回Blob格式给前端
![image](assets/98cbb833ccf96932ff001a41e26dd728d4ff587917736395071d35a6848a6347.png)

					- 前端请求blob的返回类型responseType类型
![image](assets/198e94b2a728c4efbd45e47dcb6cfe4e0a52aeacb70460c5e5a945a35949b7fa.png)

				- 前端自己生成的二进制文件，进行下载，这个例子好像忘记了revokeObjectURL
![image](assets/9ddca364c992ec0b017047897a4e50056df7a8180088b72d5062deeb4f21e5c4.png)

			- a标签下载

				- a标签及href指向的如果是一个下载链接，那么相当于下载文件，对于单文件下载还是ok的，不过快速点击几个下载按钮，有的下载会被Cancelled，这可不行

				-  
![image](assets/744e37ab0c2c5cf5481af9b3671739bacb16b9a1d8821eabb5d5b28ed9e5e098.png)

		- 【文件显示】

			- window.URL.createObjectURL生成的Blob URL还可以赋给img.src，从而实现图片的显示

			-  
![image](assets/69206f9c701de5afae6fdea62c1350c5cfe03e558015907a11528c57609b69c4.png)

		- 【Blob实现文件分片上传】

			- 通过Blob.slice(start,end)可以分割大Blob为多个小Blob
xhr.send是可以直接发送Blob对象的

			-  
![image](assets/6a4b1602613457cb774ce59f8401fdb5374d76d828836eff11656ec54eb9407d.png)

			-  
![image](assets/febedd3926c2f8e3e66eff3aa9e27786d30ec69ea42f8d80650189708b75ddb6.png)

		- 【本地读取文件内容】

			- 如果想要读取Blob或者文件对象并转化为其他格式的数据，可以借助FileReader对象的API进行操作

				- FileReader.readAsText(Blob)：将Blob转化为文本字符串

				- FileReader.readAsArrayBuffer(Blob)： 将Blob转为ArrayBuffer格式数据

				- FileReader.readAsDataURL(): 将Blob转化为Base64格式的Data URL

				- 下面我们尝试把一个文件的内容通过字符串的方式读取出来

			-  
![image](assets/4adcea792167d435a19c2fcb78edc3d3c3eed0aafefe4f4ea918823a6059d810.png)

		- 后端可能就是fs.readFileSync读取的二进制数据，前端通过设置resonseType进行切换，浏览器自动转化了类型

			-  
![image](assets/660f34b36dc9d0e01d46335d9149e27b453b0eafca224a8c49e54ddaa0e1789d.png)

		- 【图片转为canvas】

			-  
![image](assets/be22968aa46d0428c22df5e3225d182853ec12968ce02c93eb9939ef9096c074.png)

			- [html2canvas截屏的场景](https://gitee.com/mirrors/html2canvas)

	- 【Blob和ArrayBuffer互相转换】

		- ArrayBuffer转Blob

			- / / 1)var dataView = new DataView(arrayBuffer);

// var blob = new Blob([dataView], { type: mimeString });

			- arraybuffer转blob很方便，作为参数传入就行了
![image](assets/71ff0fb37c135b3d31b3e47354196d495010f8a3966f90658092de023b6b1aa7.png)

		- Blob转ArrayBuffer

			- // 2)fileReader.readAsArrayBuffer(blob);

// var arrayBuffer;

// fileReader.onload = function() {

//     arrayBuffer = this.result;

// };

			- 通过ArrayBuffer的格式读取本地数据
![image](assets/92dbc7cdbe7a523754f06cb6790467b6b46fcee382b1f5baee59a7ab2c4e790b.png)

			- 通过ArrayBuffer的格式读取Ajax请求数据
通过xhr.responseType = “arraybuffer” 指定响应的数据类型，在onload回调里打印xhr.response

				-  
![image](assets/d800e83ecd2a400c8df5566385d4f539ca901b6b6c1e508b0396bbcc31211884.png)

				-  
![image](assets/9984a7495d1034105582e624193395f67afe17a45657342f75a30fe61f2f55c6.png)

- XMLHttpRequest

	- XMLHttpRequest带着两位家臣，DOMString和Document数据类型攻城略地，几乎一统天下。

	- 为了顺应时代的潮流，XMLHttpRequest凹凸曼变身升级到2.0，变化诸多，其中一个很重要的变化就是广招家臣，扩张实力，与HTML5一起完成千秋万载之大业。

	- 这些家臣有：DOMString、Document、FormData、Blob、File、ArrayBuffer这些类型。

- DOMString

	- 家臣之DOMString

	- 跟着XMLHttpRequest闯南走北很多年，看名字似乎很嚣张且高深莫测。实际上，在JavaScript中，DOMString就是String。规范解释说DOMString指的是UTF-16字符串，而JavaScript正是使用了这种编码的字符串，因此，在Ajax中，DOMString就等同于JS中的普通字符串。

	- 大家应该都与XMLHttpRequest中数据返回属性之responseText打过交道吧，按照我的理解，这厮就是与DOMString数据类型发生关系的，表明返回的数据是常规字符串。

- 家臣之Document数据类型

	- 如果单纯看Document对象，则解释很多，在这里，我们只要关注下图标注的这一个：

	- responseXML
![image](assets/ff7bdc38e246c539cb327d765510eb78ed47f5893781b4b3384dd6e1638f5248.png)

	- 可以看到，实际上就是XMLHttpRequest中数据返回属性之responseXML，也就是可以解析为XML的数据。因此，这里的Document数据类似你就可以近似看成XML数据类型。

	- DOMString和Document都是XMLHttpRequest时代就跟随的数据类型，元老级。下面这些数据类型都是XMLHttpRequest 2.0新增的，新招的家臣，各怀绝技哦！

- atob 和 btoa

	- base64 相信大家都不会陌生吧（不知道的看这里）,最常用的操作可能就是图片转 base64 了吧?

	- 在之前要在字符串跟base64之间互转,我们可能需要去网上拷一个别人的方法,而且大部分情况下,你没有时间去验证这个方法是不是真的可靠,有没有bug。

	- 从IE10+浏览器开始，所有浏览器就原生提供了Base64编码解码方法。

	- Base64 解码

		- var decodedData = window.atob(encodedData);

	- Base64 编码

		- var encodedData = window.btoa(stringToEncode);

- Canvas中的ImageData对象

	- [关于Canvas，这里我就不做过多介绍了，具体可参考canvas 文档](https://developer.mozilla.org/zh-CN/docs/Web/API/Canvas_API)

	- 今天主要说一下Canvas中的ImageData对象（也是为下面的那个图片裁剪的项目做一些基础知识的铺垫～）

	- ImageData对象中存储着canvas对象真实的像素数据，它包含以下几个只读属性：

		- width：图片宽度，单位是像素

		- height：图片高度，单位是像素

		- data：Uint8ClampedArray类型的一维数组，包含着RGBA格式的整型数据，范围在 0 至 255 之间（包括 255）。

			- 8位无符号整型固定数组） 类型化数组表示一个由值固定在0-255区间的8位无符号整型组成的数组
![image](assets/8113fe3937ec448dcbc87362ecf565a69f3044d2832b48fa9e47df646ca60590.png)

			- 如果你指定一个在 [0,255] 区间外的值，它将被替换为0或255；如果你指定一个非整数，那么它将被设置为最接近它的整数。（数组）内容被初始化为0。一旦（数组）被创建，你可以使用对象的方法引用数组里的元素，或使用标准的数组索引语法（即使用方括号标记）。

			- 语法

				- new Uint8ClampedArray(length);
new Uint8ClampedArray(typedArray);
new Uint8ClampedArray(object);
new Uint8ClampedArray(buffer [, byteOffset [, length]]);

		- 创建一个ImageData对象

			- 使用createImageData() 方法去创建一个新的，空白的ImageData对象。

			- var myImageData = ctx.createImageData(width, height);

			- 上面代码创建了一个新的具体特定尺寸的ImageData对象。所有像素被预设为透明黑。

		- 得到场景像素数据

			- 为了获得一个包含画布场景像素数据的ImageData对象，你可以用getImageData()方法：

			- var myImageData = ctx.getImageData(left, top, width, height);

			- [HTML canvas getImageData](https://www.w3school.com.cn/tags/canvas_getimagedata.asp)

			- 下面的代码通过 getImageData() 复制画布上指定矩形的像素数据，然后通过 putImageData() 将图像数据放回画布

		- 在场景中写入像素数据

			- 你可以用putImageData()方法去对场景进行像素数据的写入。

			- ctx.putImageData(myImageData, dx, dy);

		- toDataURL 将canvas转为 data URI格式

			- 有如下<canvas>元素：

			- <canvas id="canvas" width="5" height="5"></canvas>

			- 可以用下面的方式获取一个data-URL

				- var canvas = document.getElementById("canvas");
var dataURL = canvas.toDataURL();
console.log(dataURL);
// "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNby
// blAAAADElEQVQImWNgoBMAAABpAAFEI8ARAAAAAElFTkSuQmCC"

		- 像图片裁剪上传这种社区已经有非常成熟的解决方案了，如vue-cropper。

- [参考文档：理解DOMString、Document、FormData、Blob、File、ArrayBuffer数据类型](https://www.zhangxinxu.com/wordpress/2013/10/understand-domstring-document-formdata-blob-file-arraybuffer/)

### 16.9.5. 编码

- base64

	- 原理

		- 「Base64」 是一种基于 64 个可打印字符来表示二进制数据的表示方法。由于 「2⁶ = 64」 ，所以每 6 个比特为一个单元，对应某个可打印字符。3 个字节有 24 个比特，对应于 4 个 base64 单元，即 3 个字节可由 4 个可打印字符来表示。

		- 相应的转换过程如下图所示：
![image](assets/df095c4c1f3b8b897dbb0d6cfe1c51533842356385c9ecbfa738da4804a952fc.png)

	- Base64 常用于在处理文本数据的场合

		- 表示、传输、存储一些二进制数据，包括 MIME 的电子邮件及 XML 的一些复杂数据。

		- 在 MIME 格式的电子邮件中，base64 可以用来将二进制的字节序列数据编码成 ASCII 字符序列构成的文本。

		- 使用时，在传输编码方式中指定 base64。使用的字符包括大小写拉丁字母各 26 个、数字 10 个、加号 + 和斜杠 /，共 64 个字符，等号 = 用来作为后缀用途。

	- Base64 相应的索引表如下：

		- 图示
![image](assets/ca27661126f1d69f674c9059ec9a4761cb83872fce6b0b0a6e1f7ad08f5b3626.png)

	- 过程：编码 Man 为例，来直观的感受一下编码过程。Man 由 M、a 和 n 这 3 个字符组成，它们对应的 ASCII 码为 77、97 和 110。

		- M字母
![image](assets/2417a45cedd069326e69500c7e314569597b7ae7a3cb6bd6194e95a8171138a0.png)

		- 接着我们以每 6 个比特为一个单元，进行 base64 编码操作
![image](assets/8ee895b21ae0f4ef991fc6a04b90e6fbf0020e30fdafe1c80b0f9eac548d500d.png)

	- 如果要编码的字节数不能被 3 整除，最后会多出 1 个或 2 个字节，那么可以使用下面的方法进行处理：先使用 0 字节值在末尾补足，使其能够被 3 整除，然后再进行 base64 的编码。

		- 以编码字符 A 为例，其所占的字节数为 1，不能被 3 整除，需要补 2 个字节，具体如下图所示
![image](assets/ed0dfccb392a7be324340e2eecc351a869d15e15b963857c710f25a8718e7846.png)

	- 在 JavaScript 中，有两个函数被分别用来处理解码和编码 base64 字符串：

		- btoa()：该函数能够基于二进制数据 “字符串” 创建一个 base64 编码的 ASCII 字符串。

		- atob()： 该函数能够解码通过 base64 编码的字符串数据。

	- btoa方法

		- Binary to ASCII，以base-64格式编码一串二进制数据

			- 编码

			- const base64 = window.btoa('abc'); // YWJj

		- binary string parse to base64 encode String

	- atob方法

		- ASCII to Binary，给定一个base-64字符串，它返回二进制数据。

			- 解码

			- const initString = window.atob(base64); // abc

		- base64 encoded ascii to ucs-2 string

	- 单字节-转换方式

		- 编码

		- const base64 = window.btoa('abc'); // YWJj

		- 解码

		- const initString = window.atob(base64); // abc

	- 但是 btoa、atob 仅支持对 ASCII 字符编码，也就是单字节字符，而我们平时的中文都是 3-4 字节的字符。

	- 因此可以先将中文字符转为 utf-8 的编码，将 utf-8 的编码当做字符，这样就可以对多个单字节字符进行编码。往下看。

	- 多字节-转换方式

		- 编码（多字节）

		- const base64 = window.btoa(encodeURIComponent('春节')); // JUU2JTk4JUE1JUU4JThBJTgy

		- 解码（多字节）

		- const initString = decodeURIComponent(window.atob(base64)); // 春节

		- 另一种方式

			- // ucs-2 string to base64 encoded ascii
function utoa(str) {
    return window.btoa(unescape(encodeURIComponent(str)));
}


			- // base64 encoded ascii to ucs-2 string
function atou(str) {
    return decodeURIComponent(escape(window.atob(str)));
}

			- [地址](https://my.oschina.net/dreambreeze/blog/5079687)

	- encodeURIComponent & decodeURIComponent

		- encodeURIComponent()

			- 用于执行将在URI中使用的字符串的URL编码。这将在URI中具有特殊含义的字符转换为%，然后是十六进制编码，例如，空格变成%20。这通常用于创建将在重定向或AJAX请求中使用的URL参数，或将在XMLHTTPRequest.send()中发送的数据。

		- decodeURIComponent()

			- decodeURIComponent()执行encodeURIComponent()的反转，所以如果您有"foo%20bar"它将返回"foo bar"。

		-  
![image](assets/dc578be27180774addbe7150a05928d6a3388f2bd6cec06335316041d8729837.png)

		- 理解：感觉就是atob就是解码base64字符串，从6位二进制索引表对应字符序列，还原成8位二进制对应的字符序列
![image](assets/7541cb7ee7f8ae2831abefa215971a0ee58d898d18a12baa0d5bff328e0f026e.png)

	- [base64实现原理理解文章](https://chrunlee.cn/article/js-str-to-base64.html)

- 基础概念

	- ASCII

		- 英文全称是American Standard Code for Information Interchange

		- 中文意思是美国信息交换标准代码，是基于拉丁字母的一套计算机编码系统，使用8位二进制表示字符。

		- 在计算机内部，所有信息最终都是一个二进制值。每一个二进制位（bit）有0和1两种状态，因此8个二进制位就可以组合出256种状态，这被称为一个字节（byte）。

		- 换句话说，一个字节可以表示256种不同的状态，每一个状态对应一个符号，也就是256个符号，从0000 0000到1111 1111，其数量计算公式：2^{8} = 256。

		- 列举一部分ASCII码表，如图所示
![image](assets/52ae8c8bcd14b464c62c54e8a7f90a0f3eec6cfd5a584da65a13600d81a6f3bc.png)

		- 英语是由26个基本拉丁字母、阿拉伯数字和英式标点符号组成，因此用128个符号就足够l了，但ASCII码对于其他一些复杂的语言，就力不从心了，比如：汉字大约将近10万个（虽然没有准确的数字，但日常使用汉字也有几千字）。

		- 一个字节只能表示256种符号，肯定是不够的，就必须使用多个字节表达一个符号。为了正确显示中文字符，在1981年5月1日，由中国国家标准总局发布了《信息交换用汉字编码字符·基本集》，通常简称GB。

	- GB类

		- GB2312

			- 中国大陆几乎所有的中文系统和国际化的软件都支持GB2312。GB2312是简体中文常见的编码方式，使用两个字节表示一个汉字，所以最多可以表示2^{8} \times 2^{8} = 65536个符号。

			- GB2312标准共收录6763个汉字，其中一级汉字（常用字）3755个，二级汉字（较不常用）3008个，同时收录了包括拉丁字母、希腊字母、日文平假名及片假名字母、俄语西里尔字母在内的682个字符。

			- GB2312基本满足了计算机处理简体汉字的需求，所收录的汉字覆盖了99.75%的使用频率，但对于罕见字和繁体字，GB2312就不能处理了。因此发明了后来的GBK和GB18030。

			- GB2312，GBK和GB18030之间的关系如图所示
![image](assets/e5c236444e8a26538ea3c5be185b9017faf80996e370794195c83a3fff023482.png)

		- GBK

			- GBK编码是GB2312编码的超集，向下完全兼容GB2312，兼容的含义是不仅字符兼容，而且相同字符的编码也相同。

		- GB18030

			- 而GB18030编码向下兼容GBK和GB2312，GB18030编码是变长编码。

		- 缺点

			- 但很多像GB类的编码方式都有一个共同的问题，允许计算机处理双语环境，即拉丁字母和本地语言，却无法同时支持多语言环境，即多种语言混合的情况。Unicode就是为了解决这个问题而诞生的方案。

	- Unicode

		- 背景

			- 世界上存在着多种语言，比如：西班牙语、韩语、俄语等等，它们也都分别有各自的编码方式，所以同一个二进制数字可以被解释成不同的符号。如果想要正确的打开一个文本文件，就必须知道它的编码方式，否则就会出现乱码。

		- 目标

			- 假如有一种编码，将世界上所有的符号都纳入其中。每一个符号都给予一个独一无二的编码，那么乱码问题就会消失。这就是Unicode，一种所有符号的编码。

		- Unicode伴随着通用字符集的标准而发展，当前最新的版本为2019年5月公布的12.1.0，已经收录超过13万个字符。Unicode涵盖的数据除了视觉上的字形、编码方式、标准的字符编码外，还包含了字符特性，如大小写字母。

		- 然而，Unicode只是一个符号集，不代表计算机里的编码，它只规定了符号的二进制代码，却没有规定这个二进制代码应该如何存储。

		- 问题：

			- 计算机怎么知道三个字节表示一个符号，而不是分别表示三个符号呢？

			- 英文字母只用一个字节表示就够了，但按照Unicode规定，每个符号要用3个或4个字节表示，那么英语文本的存储空间将扩大3到4倍，是极大的浪费。

		- UTF-8

			- 随着互联网的发展，不同国家的信息越来越多地在网络中传播，强烈需要一种统一的编码方式，UTF-8就是在互联网上被广泛使用的一种Unicode实现方式。

			- 再次强调一下，UTF-8是Unicode的实现方式之一，并不是唯一，也不等同于Unicode。除了UTF-8，还有UTF-16和UTF-32，只是很少被使用。

			- UTF-8的特点是对不同范围的字符使用不同长度的编码，它可以使用1~4个字节表示一个符号，根据不同的符号而变化字节长度。

			- 编码规则：

				- 对于单字节的符号，字节的第一位设为0，后面7位为这个符号的Unicode码。因此对于英语字母，UTF-8编码和ASCII码是相同的。

				- 对于n字节的符号（n>1)，第一个字节的前n位都设为1，第n+1位设为0，后面字节的前两位一律设为10，剩下的没有提及的二进制位，全部为这个符号的Unicode码。

				-  
![image](assets/38c7a707fd518e9b2a9bb2e70f063d105db06436df8c85e9e599f2c146d09e3f.png)

				- 例子

					- 以“爱”为例，其二进制为01110010 00110001，其的Unicode是U+7231，是在U+0800～U+FFFF范围内，所以采用3个字节进行编码。
![image](assets/a82474d34ce72595dfd3e25032ba75c1fbe9aa83408b8ce64ae1b9dd72a6c631.png)

- 字符编码
![image](assets/a5c43311161ddc2a19ba5e5a5e8fe09a998af8853dbe4d3b6c18cd2b0e4b0078.png)

	- charCodeAt

		- "𠮷".charCodeAt(0).toString(16) //d842

		- "𠮷".charCodeAt(1).toString(16) //dfb7

		- "\ud842\udfb7" //"𠮷"

		- 使用charCodeAt()您需要检索第一个和第二个，并将它们合并。

	- codePointAt

		- JavaScript 内部，字符以 UTF-16 的格式储存，每个字符固定为2个字节。对于那些需要4个字节储存的字符（Unicode 码点大于0xFFFF的字符），JavaScript 会认为它们是两个字符。

		- "𠮷".codePointAt(0) //20bb7

		- "\u{20bb7}" //"𠮷"

		- ES2015中引入了此功能，以处理无法由单个16位Unicode单元表示但需要2个字符的Unicode字符。

	- unescape() 函数可对通过 escape() 编码的字符串进行解码。

	- escape() 函数可对字符串进行编码，这样就可以在所有的计算机上读取该字符串。

		- 并没有说明是如何编码的，啥时候应该使用？

	- 字符串字符数大小vs编码单元的大小

		- [关于 JavaScript 字符串的一个小知识](https://juejin.cn/post/6860651188090585101)

	- URI编解码

		- 预备知识：URI
![image](assets/2830d65418d08f015b469dda8fbaf0c5a47f3edebd7987dc8129747c41d19656.png)

		- 原因？
![image](assets/3029b03bb6fe9943f8debc34f67a6c96de00ab0891025dd455425a8db746486d.png)

			- 通常如果一样东西需要编码，说明这样东西并不适合传输。原因多种多样，如Size过大，包含隐私数据，对于Url来说，之所以要进行编码，是因为Url中有些字符会引起歧义。

			- 例如Url参数字符串中使用key=value键值对这样的形式来传参，键值对之间以&符号分隔，如/s?q=abc& ie=utf-8。如果你的value字符串中包含了=或者&，那么势必会造成接收Url的服务器解析错误，因此必须将引起歧义的&和= 符号进行转义，也就是对其进行编码。

			- 又如，Url的编码格式采用的是ASCII码，而不是Unicode，这也就是说你不能在Url中包含任何非ASCII字符，例如中文。否则如果客户端浏览器和服务端浏览器支持的字符集不同的情况下，中文可能会造成问题。

			- Url编码的原则就是使用安全的字符（没有特殊用途或者特殊意义的可打印字符）去表示那些不安全的字符。

		- 如何做？
![image](assets/82c79ef724c62b3c77aedb19a3ec1ce8f5d172a3e85a07ca48bdaff8d15c0537.png)

		- [文章：为什么要进行URI编解码、怎么做？](https://blog.csdn.net/wxs0124/article/details/79098077)

		- [文章：URI编码解码和base64](https://www.cnblogs.com/accordion/p/4178289.html)

	- base64编码

		- window.btoa()

			- 该函数无法针对宽字节进行base64编码，若针对中文编码，则需现转换为 UTF-8 编码，然后进行 base64 编码。

			- function unicodeToBase64(s){
　　　　return window.btoa(unescape(encodeURIComponent(s)))
　　}

	- [文章：前端开发中的字符编码](https://segmentfault.com/a/1190000005078371)

	- [文章：URI编码解码和base64](https://www.cnblogs.com/accordion/p/4178289.html)

	- [文章：HTML 实体编码与进制编码](https://segmentfault.com/a/1190000005078371)

		- 主要提醒大家在预防 XSS 时需要注意的几点：

			- 检测用户输入时，不仅仅需要防范类似 <> 这样的字符，通过 unicode 编码或进制编码仍有可能注入代码

			- 需要针对特定的关键字做过滤，如 eval、write、prototype

			- 尽可能禁止内联事件处理函数的使用

			- js 过滤 src/href/action 属性，如 javascript:, data:

### 16.9.6. 图片处理

- 图示1
![image](assets/61cea02b7ae263048f5af936313ca9cc0cd1c54bdd6757e603c4becc2122e8f4.png)

- 图示2
![image](assets/df5f2953d708c90e3a576bb6c27a2e5a1c3f1e9d7689e4d3ff064688ba198e8b.png)

### 16.9.7. DOMParser和XMLSerializer两个API简介

- [地址](https://www.zhangxinxu.com/wordpress/2019/06/domparser-xmlserializer-api/)

- 语法

	- var domParser = new DOMParser();​​​​​​

- 该方法语法如下：

	- var doc = domParser.parseFromString(string, mimeType);​​​​​​

- 例子

	- var domParser = new DOMParser();

	- console.dir(domParser.parseFromString('<p>内容</p>', 'text/html'));

- 兼容性

	- DOMParser方法IE9+均支持。

- XMLSerializer

	- XMLSerializer方法的作用和DOMParser相反，XMLSerializer可以让DOM树对象序列化为字符串。

	- 语法

		- var xmlSerializer = new XMLSerializer();

### 16.9.8. 重新复习

- 参考文章：

	- [前端需要搞懂的字符编码ASCII、Unicode、UTF8、UTF16等](https://blog.csdn.net/jimojianghu/article/details/125403110)

		- [有道云笔记登记了](https://note.youdao.com/s/DPHrYwun)

## 16.10. css

### 16.10.1. css引入

### 16.10.2. 选择器

### 16.10.3. 优先级

### 16.10.4. 继承

### 16.10.5. 值和单位

### 16.10.6. 文本属性

### 16.10.7. 盒子模型

### 16.10.8. BFC & IFC

### 16.10.9. 视觉格式化模型 VFM

### 16.10.10. position

### 16.10.11. float

### 16.10.12. flex

### 16.10.13. 布局

### 16.10.14. 层叠上下文

### 16.10.15. less / scss

### 16.10.16. 其他

- css设置英文字符自动换行

	- word-wrap: break-word;
white-space: normal;
word-break: break-all;

### 16.10.17. 参考文档：

- [1.带你玩转清除浮动](https://juejin.cn/post/7103806320809082916)

- [2.详解css中清除浮动的四种方式，float浮动怎么用更为合理](https://juejin.cn/post/7006624020460208164)

## 16.11. 闭包

### 16.11.1. 概念

- 闭包：函数嵌套函数，内部函数就是闭包

- 闭包，通俗的讲就是可以在外部访问局部变量，通过函数可以根据链式作用域原则取到外层局部作用域的原理，将外层局部作用域的变量通过return返回出去，这样就可以在局部作用域外部使用局部作用域内部的变量了.

- 优点

	- 可以在外部使用局部作用域的变量.

- 缺点

	- 使局部作用域变量不能被内存释放，变量就会占用内存，内存消耗大，可能会导致内存泄露.

- 闭包的使用方法

	- 简单来讲就是在局部作用域内通过函数将需要的局部作用域变量通过return返回出去，代码如下：
![image](assets/9534a8a3fb6fcb2e52ab79da36991bc7d830ede57d64c91c727cf388816ae112.png)

		- 我们通过闭包的方式，在全局环境下拿到了{}内部局部作用域的games，这便是闭包

		- 通过函数方式
![image](assets/727e2aec072ad9f16a4f49bae8d8163b39ad031cc02d08c1e3e20510bc34a8ef.png)

### 16.11.2. 代码

- // 闭包：函数嵌套函数，内部函数就是闭包
function outerFun() {
    let a = 10
    function innerFun() {
        console.log(a)
    }
    return innerFun
}

let fun = outerFun()
fun();

### 16.11.3. 作用域链

- 图示
![image](assets/65c4280bd2d79225423626110cc97befe2a28660e6c746b8aa3e583b568acb35.png)

	- 一直向上找

- 代码

	- 
let a = 10
let b = 20
function fun() {
    let a = 30
    let c = 40
    function fn() {
        let a = 50
        let b = 60
    }
}


### 16.11.4. 特点

- 正常情况下，函数调用完成之后，函数中的局部变量中的会释放（内存中）

- 闭包，内部函数没有执行完成，外部函数变量不会被销毁

- 应用：封装一段代码

	- let module = (function () {
    let a = 10
    let b = 20
    function add() {
        return a + b
    }
    function sub() {
        return a - b
    }
    let result1 = add()
    let result2 = sub()
    console.log(result1, result2)
    return {
        add,
        sub,
    }
})()

let result1 = module.add()
let result2 = module.sub()
console.log(result1, result2)

## 16.12. tcp/ip

### 16.12.1. 相关基础知识

- ack:acknowledge

- syn: synchronous,是TCP/IP建立连接时使用的握手信号

	- 英文含义
![image](assets/00001bf3f539a36ecc7193d1064a8a8146d8891d2b0455799744581e0a8e310d.png)

		- 文章
![image](assets/75416e6803ffcb5b3ad1baaa5ee9ad377196106dcde2173890ee3f5e89757e40.png)

- [文章：tcp当主动发出syn_搞懂TCP/IP协议看这篇就够了](https://blog.csdn.net/weixin_34430692/article/details/112412253)
![image](assets/39db04436ae9b502828679bb650eb5b0caa8fc05bf4ce0ca51bcf31f09f9a7da.svg)

- 三次握手过程
![image](assets/6fe50f9db80f39b580721dac7872ed4747dabaacffdf7225fb27479883b58eea.png)

	- 目的：

		- 同步序列号，只有同步序列号之后才能实现可靠传输。

		- 三次握手的信号由TCP头部中的 SYN标志位和 32位序列号两个部分实现。

	- 过程

		- 1.第一次握手：client给server发送连接请求报文，在这个报文中，包含了SYN=1，client_seq=任意值i，发送之后处于SYN-SENT状态；

		- 2.第二次握手：server端接收到了这个请求，并分配资源，同时给client返回一个ACK报文，这个报文中包含了标志位SYN和ACK都为1，而小ack为i+1，此时位于SYN-RCVD状态；

		- 3.第三次握手：client收到server发来的ACK信息后，他会看到server发过来的小ack是i+1，这时他知道了server收到了消息，也给server回一个ACK报文，报文中包含了ACK=1和client_ack=k+1字段；连接建立，client进入established(已建立连接)状态。

	- 三次握手，比较清晰的图解

		- 图示
![image](assets/93d6b53640be508f0f1972a46bca263fe5447896a6ccf967560f3775912fca1e.png)

- 三次握手类比图示：
![image](assets/9965845f1ce3f6192ff5f41c94eaad08e34ebaf8de1137b63d8c930668bffe20.png)

- 服务器半连接队列

	- 图示：
![image](assets/4c49d1ad4205aa121941669391142eef07b26f6c418c45fae0970791673243fe.png)

	- 在服务器第一次收到SYN信号后，服务器状态切换为SYN_RCV，同时维护一个队列来保存未完成的信息，一旦这个队列溢出，则无法建立新的连接。这个队列称为， 半连接队列。 半连接队列 由长度不仅需要tcp_max_syn_backlog，还有backlog和somaxconn的值(控制accept队列大小)共同控制。

	- SYN泛洪攻击发生在此处，攻击的就是这个半连接队列。攻击者不断向服务器发出请求之后就消失，造成服务器端的资源耗尽。 

		- 解决办法： tcp_syn_cookies功能开启后可以在不使用半连接队列的情况下成功建立连接。 工作原理为，服务器根据当前状态计算出一个哈希值， 放在SYN+ACK中一同发出，当客户端返回ACK报文时，去除该值验证，如果合法则认为建立连接成功。
![image](assets/04ed86cca3952b3960d9de63eefc52dde8ad8b2bf29d0e38cfa0ca92ecb83673.png)

- 服务器端全连接队列

	- 建立连接成功后，半连接队列移除，将新的连接添加到全连接队列。 全连接 队列的 长度由somaxconn和backlog之间的最小值决定。 somaxconn是内核参数，backlog是lisen中的第二个参数。

- 丢包 VS 复位

	- 在新的连接无法连接时，TCP 默认采用丢包的方式处理后面的请求。可以用netstat -s 查看丢弃连接的情况，输出值为累计值：

	- 图示
![image](assets/069dedb7db4da899527020fa423fd5a68cc00bf584903e4e4da592a944910b8f.png)

- RTT

	- RTT(Round-Trip Time): 往返时延。在计算机网络中它是一个重要的性能指标，表示从发送端发送数据开始，到发送端收到来自接收端的确认（接收端收到数据后便立即发送确认），总共经历的时延。

		- 一般认为单向时延=传输时延t1+传播时延t2+排队时延t3

		- t1是数据从进入节点到传输媒体所需要的时间，通常等于数据块长度/信道带宽

		- t2是信号在信道中需要传播一定距离而花费的时间，等于信道长度/传播速率（光纤中电磁波的传播速率约为2*10^5 km/s，铜缆中2.3*10^5 km/s）

		- t3可笼统归纳为随机噪声，由途径的每一跳设备及收发两端负荷情况及吞吐排队情况决定(包含互联网设备和传输设备时延)

		- 综上：时延并无标准值只有经验值。某运营商规定网内路由器间时延1000公里之内<=40ms,2000公里之内<=60ms,3000公里之内<=80ms

- TCP四次挥手
![image](assets/5fe799f29cec8e6a5b272cd78d8eca075ef6831b3d937f1511393e0cbd9193ff.png)

	- 特点

		- RST暴力关闭方式和FIN四次挥手流程

		- 关闭连接的函数有两种： 关闭两头的close函数和只关闭一方的shutdown函数。四次挥手是温柔的断开方式，只有FIN和ACK两种信号。

		- 要注意的是， 主动发起关闭的一方会有time_wait阶段。

	- 过程

		- 第一次挥手：client给server发送一个FIN报文，挥手之后client进入FIN_WAIT_1的第一阶段；

		- 第二次挥手：server收到client发来的FIN报文后，给client返回一个ACK信息，并且ack=seq+1，server进入CLOSE_WAIT阶段，而client收到之后处于FIN_WAIT_2；

		- 第三次挥手：当server发完所有数据时，他会给client发送一个FIN报文，告诉client说“我传完数据了，现在要关闭连接了”，server变成LAST_ACK状态，等着client最后的ACK信息；

		- 第四次挥手：当client收到这个FIN报文时，server发ACK信息，但是它怕server收不到信息，所以进入TIME_WAIT状态，等待server确认收到这个ACK信息则正式关闭了tcp连接，进入CLOSED状态。

	- 图示

		-  
![image](assets/cbff5ece4f8bf8706d12236b9f28b896283252e275214cfd5b0cd01217e89061.png)

- 提升
![image](assets/94eade71ad47b52ff49b1a872b1ab29a9484cad6020c8f05e58d437b3482c67a.png)

- [文章：跟着动画学习TCP三次握手和四次挥手](https://mp.weixin.qq.com/s/pSrKbVryn71kDVIXUtpXMA)

### 16.12.2. TCP/IP过程

- 当输入 URL 时，整个过程是什么样子的

	- 图示
![image](assets/0d7d1bf7075eb1f7c4acd688431b2f388352b8753bc0128ac652ea839ff5defb.png)

- TCP/IP协议图示

	- 图：OSI七层模型，TCP/IP四层模型，TPC/IP协议栈
![image](assets/506e509671e184fd3a296f0c2df542b409d046bbe24cf846b5b9f1e8dd41cf43.png)

		- TCP/IP四层模型

			- 应用层：应用程序间沟通的层，如简单电子邮件传输（SMTP）、文件传输协议（FTP）、网络远程访问协议（Telnet）等。

			- 传输层：在此层中，它提供了节点间的数据传送服务，如传输控制协议（TCP）、用户数据报协议（UDP）等，TCP和UDP给数据包加入传输数据并把它传输到下一层中，这一层负责传送数据，并且确定数据已被送达并接收。

				- 发送

			- 网络层：负责提供基本的数据封包传送功能，让每一块数据包都能够到达目的主机（但不检查是否被正确接收），如网际协议（IP）。

				- 寻址

			- 网络接口层：与硬件驱动对话，对实际的网络媒体的管理，定义如何使用实际网络

			- 举例：

				- 比如一个QQ软件，发送某条消息的时候，都会经历过次四层  ，                      hello

				- 经过应用层之后，发送的消息会被加上QQ应用标识                              app+hello

				- 经过传输层之后  ，发送的消息带着QQ应用标识再被加上tcp标记，成了一个TCP段   ， tcp+app+hello

				- 经过网络层之后，再刚刚的数据上再加上ip标记，标识这个带着QQ标记的消息，要发送到哪个IP去   ip+tcp+app+hello  变成了一个数据包

				- 经过接口层之后，把刚刚数据包加上帧头和帧尾   帧头+ip+tcp+app+hello+帧尾  ，这样就变成了完整的数据包 ，可以在网络上传输了

				- 然后这一整个东西，经过各种通信设备，到达了对方机器之后，再经过反向的层层数据剥离，传输到对方的QQ上

			- 理解

				- “我们在传输数据时，可以只使用（传输层）TCP/IP协议，但是那样的话，如果没有应用层，便无法识别数据内容，如果想要使传输的数据有意义，则必须使用到应用层协议，应用层协议有很多，比如HTTP、FTP、TELNET等，也可以自己定义应用层协议。WEB使用HTTP协议作应用层协议，以封装HTTP 文本信息，然后使用TCP/IP做传输层协议将它发到网络上。”

				- “IP”代表网际协议，TCP和UDP使用该协议从一个网络传送数据包到另一个网络。把 IP想像成一种高速公路，它允许其它协议在上面行驶并找到到其它电脑的出口。

				- TCP和UDP是高速公路上的“卡车”，它们携带的货物就是像HTTP，文件传输协议FTP这样的协议等。

				-  HTTP(超文本传输协议)是利用TCP在两台电脑(通常是Web服务器和客户端)之间传输信息的协议。客户端使用Web浏览器发起HTTP请求给Web服务器，Web服务器发送被请求的信息给客户端。

			- 不同的TCP/IP和其他的协议在最初OSI模型
![image](assets/3a353e039518ba7adf30234a49b84305442c25d7e8dc3d4c35bb1578a8a800f5.png)

	- OSI七层模型总结
![image](assets/7922f8ed48b60dfa7d9a5e8430aff993c183b81d785335a007f6d00ba46547b8.png)

	- TCP/IP模型与OSI模型各层的对照关系
![image](assets/06898efd0636aa94b95dc4a3aeea10b6873d2bce21edcac35b0a125ba570c245.png)

		- TCP/IP协议族按照层次由上到下，层层包装。

			- 最上面的是应用层，这里面有http，ftp,等等我们熟悉的协议。

			- 而第二层则是传输层，著名的TCP和UDP协议就在这个层次。

			- 第三层是网络层，IP协议就在这里，它负责对数据加上IP地址和其他的数据以确定传输的目标。

			- 第四层是数据链路层，这个层次为待传送的数据加入一个以太网协议头，并进行CRC编码，为最后的数据传输做准备。

	- 表示了TCP/IP协议中每个层的作用
![image](assets/46431afe9e6374c7fbf66990989ba1bf94dd3d2812c0072a72bd6fd3594eea66.png)

		- 上图清楚地表示了TCP/IP协议中每个层的作用，而TCP/IP协议通信的过程其实就对应着数据入栈与出栈的过程。入栈的过程，数据发送方每层不断地封装首部与尾部，添加一些传输的信息，确保能传输到目的地。出栈的过程，数据接收方每层不断地拆除首部与尾部，得到最终传输的数据。

- http协议图示

	- 数据发送过程
![image](assets/14bf6550ea9b6d3de77e90a82df20aa8f84982549a6aa00b6672996e5b489e45.png)

### 16.12.3. 数据链路层

- 物理层负责0、1比特流与物理设备电压高低、光的闪灭之间的互换。 

- 数据链路层负责将0、1序列划分为数据帧从一个节点传输到临近的另一个节点,这些节点是通过MAC来唯一标识的(MAC,物理地址，一个主机会有一个MAC地址)。

- 图示
![image](assets/bd79a8068399289adf5fefaa16d7febfcce3912a0849d44b6c5db554964c9dc8.png)

- 封装成帧: 把网络层数据报加头和尾，封装成帧,帧头中包括源MAC地址和目的MAC地址。

- 透明传输:零比特填充、转义字符。

- 可靠传输: 在出错率很低的链路上很少用，但是无线链路WLAN会保证可靠传输。

- 差错检测(CRC):接收者检测错误,如果发现差错，丢弃该帧。

### 16.12.4. 网络层

- 1. IP协议

	- 概念

		- P协议是TCP/IP协议的核心，所有的TCP，UDP，IMCP，IGMP的数据都以IP数据格式传输。

		- 要注意的是，IP不是可靠的协议，这是说，IP协议没有提供一种数据未传达以后的处理机制，这被认为是上层协议：TCP或UDP要做的事情。

	- 1.1 IP地址

		- 在数据链路层中我们一般通过MAC地址来识别不同的节点，而在IP层我们也要有一个类似的地址标识，这就是IP地址。

		- 32位IP地址分为网络位和地址位，这样做可以减少路由器中路由表记录的数目，有了网络地址，就可以限定拥有相同网络地址的终端都在同一个范围内，那么路由表只需要维护一条这个网络地址的方向，就可以找到相应的这些终端了。

		- A类IP地址: 0.0.0.0~127.255.255.255

		- B类IP地址:128.0.0.0~191.255.255.255

		- C类IP地址:192.0.0.0~239.255.255.255

	- 1.2 IP协议头

		- 图示
![image](assets/083def336431405ea3aa25c802667e9d1e50ed5aedfe65bac7fe424a8d325b4c.png)

		- 这里只介绍:八位的TTL字段。这个字段规定该数据包在穿过多少个路由之后才会被抛弃。某个IP数据包每穿过一个路由器，该数据包的TTL数值就会减少1，当该数据包的TTL成为零，它就会被自动抛弃。

		- 这个字段的最大值也就是255，也就是说一个协议包也就在路由器里面穿行255次就会被抛弃了，根据系统的不同，这个数字也不一样，一般是32或者是64。

- 2. ARP及RARP协议

	- ARP 是根据IP地址获取MAC地址的一种协议。

	- ARP（地址解析）协议是一种解析协议，本来主机是完全不知道这个IP对应的是哪个主机的哪个接口，当主机要发送一个IP包的时候，会首先查一下自己的ARP高速缓存（就是一个IP-MAC地址对应表缓存）。

	- 如果查询的IP－MAC值对不存在，那么主机就向网络发送一个ARP协议广播包，这个广播包里面就有待查询的IP地址，而直接收到这份广播的包的所有主机都会查询自己的IP地址，如果收到广播包的某一个主机发现自己符合条件，那么就准备好一个包含自己的MAC地址的ARP包传送给发送ARP广播的主机。

	- 而广播主机拿到ARP包后会更新自己的ARP缓存（就是存放IP-MAC对应表的地方）。发送广播的主机就会用新的ARP缓存数据准备好数据链路层的的数据包发送工作。

	- RARP协议的工作与此相反，不做赘述。

- 3. ICMP协议

	- IP协议并不是一个可靠的协议，它不保证数据被送达，那么，自然的，保证数据送达的工作应该由其他的模块来完成。其中一个重要的模块就是ICMP(网络控制报文)协议。ICMP不是高层协议，而是IP层的协议。

	- 当传送IP数据包发生错误。比如主机不可达，路由不可达等等，ICMP协议将会把错误信息封包，然后传送回给主机。给主机一个处理错误的机会，这 也就是为什么说建立在IP层以上的协议是可能做到安全的原因。

### 16.12.5. ping

- ping可以说是ICMP的最著名的应用，是TCP/IP协议的一部分。利用“ping”命令可以检查网络是否连通，可以很好地帮助我们分析和判定网络故障。

	- 例如：当我们某一个网站上不去的时候。通常会ping一下这个网站。ping会回显出一些有用的信息。一般的信息如下:
![image](assets/2b386e7d932148b942f3442fb2c7c483b5a6459ff631feb749733dfdbd91c313.png)

	- ping这个单词源自声纳定位，而这个程序的作用也确实如此，它利用ICMP协议包来侦测另一个主机是否可达。原理是用类型码为0的ICMP发请 求，受到请求的主机则用类型码为8的ICMP回应。

	- ping程序来计算间隔时间，并计算有多少个包被送达。用户就可以判断网络大致的情况。我们可以看到， ping给出来了传送的时间和TTL的数据。

### 16.12.6. Traceroute

- Traceroute是用来侦测主机到目的主机之间所经路由情况的重要工具，也是最便利的工具。

- Traceroute的原理是非常非常的有意思，它收到到目的主机的IP后，首先给目的主机发送一个TTL=1的UDP数据包，而经过的第一个路由器收到这个数据包以后，就自动把TTL减1，而TTL变为0以后，路由器就把这个包给抛弃了，并同时产生 一个主机不可达的ICMP数据报给主机。主机收到这个数据报以后再发一个TTL=2的UDP数据报给目的主机，然后刺激第二个路由器给主机发ICMP数据 报。如此往复直到到达目的主机。这样，traceroute就拿到了所有的路由器IP。

- 图示
![image](assets/94f5ecabb9e2d6f1becd945cdeebc3f10966426228be289d5dd538c71ddf723a.png)

### 16.12.7. 六、TCP/UDP

- TCP/UDP都是是传输层协议，但是两者具有不同的特性，同时也具有不同的应用场景，下面以图表的形式对比分析。

- 图示
![image](assets/f5150413e1d340293c15b944292a507faa2caa44692e8d504e10b6bda559200e.png)

- 面向报文

	- 面向报文的传输方式是应用层交给UDP多长的报文，UDP就照样发送，即一次发送一个报文。因此，应用程序必须选择合适大小的报文。若报文太长，则IP层需要分片，降低效率。若太短，会是IP太小。

- 面向字节流

	- 面向字节流的话，虽然应用程序和TCP的交互是一次一个数据块（大小不等），但TCP把应用程序看成是一连串的无结构的字节流。TCP有一个缓冲，当应用程序传送的数据块太长，TCP就可以把它划分短一些再传送。

- TCP和UDP协议的一些应用
![image](assets/f62d8795c00aa1b22a2addaa8f5e68ab5a617277c082ffc211e686edebbfb0c2.png)

- 什么时候应该使用TCP？

	- 当对网络通讯质量有要求的时候，比如：整个数据要准确无误的传递给对方，这往往用于一些要求可靠的应用，比如HTTP、HTTPS、FTP等传输文件的协议，POP、SMTP等邮件传输的协议。

- 什么时候应该使用UDP？

	- 当对网络通讯质量要求不高的时候，要求网络通讯速度能尽量的快，这时就可以使用UDP。

### 16.12.8. 七、DNS

- DNS（Domain Name System，域名系统），因特网上作为域名和IP地址相互映射的一个分布式数据库，能够使用户更方便的访问互联网，而不用去记住能够被机器直接读取的IP数串。通过主机名，最终得到该主机名对应的IP地址的过程叫做域名解析（或主机名解析）。DNS协议运行在UDP协议之上，使用端口号53。

- 网际层协议：包括：IP协议、ICMP协议、ARP协议、RARP协议。 传输层协议：TCP协议、UDP协议。 应用层协议：FTP、Telnet、SMTP、HTTP、RIP、NFS、DNS

- [文章：应用层协议：DNS域名系统](https://blog.csdn.net/zyhmz/article/details/80490534?utm_term=dns%E5%B1%9E%E4%BA%8E%E4%BB%80%E4%B9%88%E5%B1%82%E5%8D%8F%E8%AE%AE&utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduweb~default-1-80490534&spm=3001.4430)

### 16.12.9. 八、TCP连接的建立与终止

### 16.12.10. [文章地址：](https://www.toutiao.com/i6570218601117123080/?wid=1631159026384#comment_area)

### 16.12.11. TCPIP / LAN、WAN、、VLAN、WLAN 和 WIFI 的区别和联系

- 一、LAN

	- 英文全称：Local Area Network 。

	- 中文名称：局域网。

	- 定义：指在某一区域内由多台计算机互联成的计算机组。

- 二、WAN

	- 英文全称：Wide Area Network 。

	- 中文名称：广域网。

	- 定义：一种跨越大的、地域性的计算机网络的集合。子网可以是局域网也可以是小型的广域网。

- 三、VLAN

	- 英文全称：Virtual Local Area Network 。

	- 中文名称：虚拟局域网。

	- 定义：指网络中的站点不拘泥于所处的物理位置，根据需要灵活划分不同的逻辑子网中的一种网络技术。

	- [vlan是什么，为什么要创建它，即使小白看一遍也能学会](https://baijiahao.baidu.com/s?id=1648461810048002485&wfr=spider&for=pc)

- 四、WLAN

	- 英文全称：Wireless Local Area Network 。

	- 中文名称：无线局域网。

	- 定义：利用电磁波在空气中发送和接受数据，而无需线缆介质的局域网。

	- 其他：WLAN 使用 ISM (Industrial、Scientific、Medical) 无线电广播频段通信。WLAN 的 802.11a 标准使用 5 GHz 频段，支持的最大速度为 54 Mbps，而 802.11b 和 802.11g 标准使用 2.4 GHz 频段，分别支持最大 11 Mbps 和 54 Mbps 的速度。

- 五、WIFI

	- 英文全称：Wireless Fidelity。

	- 中文名称：无线保真。

	- 定义：一种无线网络传输技术。实际上是将有线网络信号转换成无线网络信号，供设备使用。

	- 和WLAN的关系：

	- （1）WIFI 是 WLAN 的一个标准，WIFI 包含于 WLAN 中，属于采用 WLAN 协议中的一项新技术。

	- （2）无线路由器的发射功率一般都在 50 毫瓦以下，也就是 100 米范围内，如果达到 300 米距离的话，大概要到 75-80 毫瓦。而WLAN发射信号的基站功率就大多了，家庭用的一般是在100—300mw，电信级的一般都在400mw以上。

## 16.13. 快捷方式速记

### 16.13.1. vscode

- ctrl+alt+f 替换

- ctrl+`打开关闭终端

- Ctrl+Shift+W 关闭编辑器

- ctrl+alt+n

	- Code Runner start

- ctrl+alt+m

	- Code Runner stop

- cmd+shfit+g

	- 打开git graph

- ctrl+shfit+c

	- c

		- Log

	- p

		- Log with string prefix

	- o

		- Log as object

	- Wrap Console Log Lite

- cssPeek

	- Peek: load the css file inline and make quick edits right there. (Ctrl+Shift+F12)

	- Go To: jump directly to the css file or open it in a new editor (F12)

	- Hover: show the definition in a hover over the symbol (Ctrl+hover)

### 16.13.2. macos

- 进程管理器

	- cmd+alt+esc

### 16.13.3. chrome

- cmd+shfit+delete

## 16.14. vscode

### 16.14.1. 插件

- Vue VSCode Snippets

	- [地址](https://juejin.cn/post/6965382258341445646)

### 16.14.2. 备份macos setting配置的json

{
    "files.associations": {
        "*.vue": "vue",
        "*.wpy": "vue",
        "*.wxml": "html",
        "*.wxss": "css",
        "*.cjson": "jsonc",
        "*.wxs": "javascript",
        "*.ejs": "html"
    },
    "sync.gist": "3020f683c1170760f6e00b3237969bb1",
    "editor.minimap.maxColumn": 100,
    "workbench.tree.indent": 14,
    "sync.autoDownload": true,
    "sync.autoUpload": true,
    "git.autofetch": true,
    "emmet.triggerExpansionOnTab": true,
    "emmet.showAbbreviationSuggestions": true,
    "emmet.showExpandedAbbreviation": "always",
    "emmet.includeLanguages": {
        "vue-html": "html",
        "vue": "html",
        "wpy": "html",
        "wxml": "html"
    },
    "search.followSymlinks": false,
    "editor.tabCompletion": "on",
    // "editor.codeActionsOnSave": { "source.organizeImports": true },
    // 在使用搜索功能时，将这些文件夹/文件排除在外
    "search.exclude": {
        "**/node_modules": true,
        "**/bower_components": true,
        "**/target": true,
        "**/logs": true,
        "**/.data": true,
        "**/.history": true,
        "**/.vscode": true,
        "**/.idea": true,
        "**/built": true,
        "**/bootstrap": true,
        "**/libs": true,
        "**/locale": true,
        "**/plugin": true
    },
    // 这些文件将不会显示在工作空间中
    "files.exclude": {
        "**/.git": true,
        "**/.svn": true,
        "**/.hg": true,
        "**/CVS": true,
        "**/.DS_Store": true,
        "**/*.js": {
            "when": "$(basename).ts" //ts编译后生成的js文件将不会显示在工作空中
        }
        // "**/node_modules": true
    },
    // windows 10 wsl GPM config
    "gitProjectManager.baseProjectsFolders": [
        "D:/work/ngconsole",
        "D:/codes/ngconsole",
        "D:/work/ngconsole_resources",
        "D:/codes/ngconsole_resources",
        "D:/work/region-front",
        "D:/work/edaas-front",
        "D:/work/new-vdi-client",
        "D:/codes/new-vdi-client",
        "D:/work/oefe-docs",
        "D:/work/idv-client",
        "D:/work/oe-dms",
        "D:/Github/face-api-demo",
        "D:/Github/demo",
        "D:/Github/sequelize-test/koa2-weibo-code",
        "D:/Github/webbo_server",
        "D:/Github/todolist-tool",
        "D:/Github/sina",
        "D:/my-dropbox/Dropbox",
        "D:/work/pmv5-fe",
    ],
    "gitProjectManager.storeRepositoriesBetweenSessions": true,
    "gitProjectManager.ignoredFolders": [
        "node_modules"
    ],
    "gitProjectManager.maxDepthRecursion": 4,
    "gitProjectManager.checkRemoteOrigin": false,
    // spell userWords
    "cSpell.userWords": [
        "MVVM",
        "edaas",
        "ngconsole",
        "todolist",
        "viewmodel",
        "zagger"
    ],
    "editor.renderWhitespace": "all",
    /* // 配置 plantuml 插件
    "plantuml.diagramsRoot": "docs/diagrams/src",
    "plantuml.exportOutDir": "docs/diagrams/out",
    "plantuml.exportFormat": "png",
    "plantuml.exportSubFolder": false,
    "plantuml.includepaths": [
        //   "docs/diagrams/style",
        // "docs/diagrams/src",
        // "/data/codes/lib/plantuml/docs/diagrams/style",
        "D:/360MoveData/Users/zagger/Downloads/C4-PlantUML-master/C4-PlantUML-master"
    ],
    "plantuml.server": "http://172.16.91.1:8002", */
    "editor.fontFamily": "Hack",
    "editor.fontSize": 15,
    /* // rest-client
    "rest-client.environmentVariables": {
        "$shared": {},
        "local": {
            "host": "http://localhost:8080",
            "token": "test token"
        },
        "prod": {
            "host": "https://172.16.201.188",
            "token": "prod token"
        }
    }, */
    "emmet.syntaxProfiles": {
        "vue-html": "html",
        "vue": "html"
    },
   /*// python
   "python.languageServer": "Pylance",
    "python.pythonPath": "C:\\Users\\zagger\\AppData\\Local\\Microsoft\\WindowsApps\\python.exe", */
    /* // vetur
    // "vetur.format.defaultFormatter.html": "js-beautify-html",
    // "vetur.format.defaultFormatter.js": "prettier",
    // "vetur.format.defaultFormatterOptions": {
    //     "js-beautify-html": {
    //         // #vue组件中html代码格式化样式
    //         "wrap_attributes": "force-aligned", //也可以设置为“auto”，效果会不一样
    //         "wrap_line_length": 200,
    //         "end_with_newline": false,
    //         "semi": false,
    //         "singleQuote": true
    //     },
    //     "prettier": {
    //         "semi": false,
    //         "singleQuote": true
    //     }
    // }, */
    "workbench.colorTheme": "One Dark Pro",
    // md format onsave
    "markdownlint.run": "onSave",
    // "javascript.updateImportsOnFileMove.enabled": "always",
    // "[json]": {
    //     "editor.defaultFormatter": "vscode.json-language-features"
    // },
    // https://github.com/tickmao/vscode-settings
    // 基于Dracula编辑器主题和material-icon-theme的图标主题的个人编辑器定制页面。
    // 字体
    // "editor.fontFamily": "'Fira Code', Source Code Pro, Menlo, Monaco, 'Courier New', monospace",
    // 软件主题配色
    // "workbench.iconTheme": "material-icon-theme", // 图标主题
    // "workbench.colorTheme": "Dracula", // 颜色主题
    // "workbench.colorCustomizations": {
    //     "[Dracula]": {
    //         // 编辑区域背景
    //         "editor.background": "#292D3E",
    //         "editor.foreground": "#c7d4dd",
    //         // 侧边栏
    //         "sideBar.background": "#292D3E",
    //         "sideBar.foreground": "#c7d4dd",
    //         "sideBar.border": "#292D3E",
    //         // 侧边栏列表
    //         "list.inactiveSelectionBackground": "#292D3E",
    //         "list.inactiveSelectionForeground": "#dfdfdf",
    //         "list.hoverBackground": "#292D3E",
    //         "list.hoverForeground": "#dfdfdf",
    //         // peek 窗口
    //         "peekView.border": "#5b99fc9c",
    //         // 顶部 tab 栏
    //         "tab.border": "#292D3E",
    //         "tab.activeBackground": "#292D3E",
    //         "tab.activeForeground": "#c7d4dd",
    //         "tab.inactiveBackground": "#292D3E",
    //         "tab.hoverBackground": "#292D3E",
    //         "tab.unfocusedHoverBackground": "#292D3E",
    //         "tab.hoverBorder": "#5b99fcb9",
    //         "tab.inactiveForeground": "#8e8e8e",
    //         "editorGroupHeader.tabsBackground": "#292D3E",
    //         "editorGroupHeader.tabsBorder":"#292D3E",
    //         "editorGroup.border": "#292D3E",
    //         "contrastBorder":"#292D3E",
    //         // 最左侧工具栏
    //         "activityBar.background": "#292D3E",
    //         "activityBar.foreground": "#c7d4dd",
    //         "activityBar.border": "#292D3E",
    //         // 状态栏
    //         "statusBar.background": "#292D3E",
    //         "statusBar.foreground": "#c7d4dd",
    //         "statusBar.border" : "#292D3E",
    //         // panel 窗口
    //         "panel.background": "#292D3E",
    //         "panel.border":"#292D3E",
    //         // 光标
    //         "editorCursor.foreground": "#84B1ED",
    //         // 当前行
    //         "editor.lineHighlightBackground": "#393C4C",
    //         //缩进参考线
    //         // "editorIndentGuide.activeBackground": "#5b99fc33",
    //         // 行号栏的当前行
    //         "editorLineNumber.activeForeground": "#dabfe0",
    //         // 行号
    //         "editorLineNumber.foreground": "#7e7d7e",
    //         // 标尺
    //         "editorRuler.foreground": "#7c5881",
    //         // 快捷提示窗口
    //         "editorSuggestWidget.highlightForeground": "#84B1ED",
    //         "editorSuggestWidget.selectedBackground": "#333f5c",
    //         // 单击一个词时，其它相同单词
    //         "editor.selectionHighlightBackground": "#70697ec9",
    //         "editor.selectionBackground": "#70697ec9",
    //         "editor.selectionHighlightBorder": "#b5f1a159",
    //         // terminal
    //         "terminalCursor.foreground": "#84B1ED",
    //         "terminal.background": "#292D3E",
    //         // 侧边栏中一块区域的标题
    //         "sideBarSectionHeader.background": "#292D3E",
    //         "sideBarSectionHeader.border": "#292D3E",
    //         // 区域获取焦点时
    //         "focusBorder": "#5b99fc36",
    //         // 标题栏颜色
    //         "titleBar.activeBackground": "#292D3E",
    //         "titleBar.activeForeground":"#c7d4dd",
    //         "titleBar.inactiveBackground": "#292D3E",
    //         "titleBar.inactiveForeground": "#c7d4dd",
    //         //滚动
    //         "scrollbar.shadow": "#292D3E",
    //         "editorOverviewRuler.border":"#292D3E",
    //     }
    // },
    // "autoDayNightThemeSwitcher.autoToggle": true,// If enabled, toggle to day and night theme automatically given the times (default is true)
    // "autoDayNightThemeSwitcher.autoToggleTimeNightBegin": "14:00",// Time when the automatic toggle to the night theme shall be done (if auto-toggle enabled, default is 19:00)
    // "autoDayNightThemeSwitcher.autoToggleTimeNightEnd": "9:00",// Time when the automatic toggle to the day theme shall be done (if auto-toggle enabled, default is 7:00)
    // "autoDayNightThemeSwitcher.dayTheme": "Solarized-light-functional",// Day theme (default is Visual Studio Light)
    // "autoDayNightThemeSwitcher.nightTheme": "Tokyo Night",// Night theme (default is Visual Studio Dark)
    // "autoDayNightThemeSwitcher.dayThemeCustomizations": {}, // Day theme color customizations (default is {})
    // "autoDayNightThemeSwitcher.nightThemeCustomizations": {},// Night theme color customizations (default is {})
    // "autoDayNightThemeSwitcher.toggleDefaultNight": true// If neither day or night theme are the current theme and toggle is triggered, switch to night theme (default is true)
    // "eslint.alwaysShowStatus": true,
    // "eslint.format.enable": true,
    // "eslint.packageManager": "yarn",
    // "eslint.run": "onSave",
    // "eslint.validate": [
    //     "vue",
    //     "javascript",
    //     "javascriptreact"
    // ],
    // "editor.codeActionsOnSave": {
    //     "source.fixAll.eslint": true
    // },
    // "vetur.validation.template": false,
    // "editor.formatOnPaste": true,
    // "editor.formatOnType": true,
    // "editor.formatOnSave": true,
    // "files.eol": "\n",
    // "[json]": {
    //     // 对json文件，使用 JSON语言功能 进行格式化
    //     "editor.defaultFormatter": "vscode.json-language-features"
    // },
    // "[jsonc]": {
    //     "editor.defaultFormatter": "vscode.json-language-features"
    // },
    // /* "[html]": {
    //     // 对html文件，使用 vscode.html-language-features(vscode内置规则) 进行格式化,不要使用 prettier
    //     "editor.defaultFormatter": "esbenp.prettier-vscode"
    // }, */
    // "[javascript]": {
    //     "editor.defaultFormatter": "esbenp.prettier-vscode"
    // },
    // "[css]": {
    //     "editor.defaultFormatter": "esbenp.prettier-vscode"
    // },
    // "[less]": {
    //     "editor.defaultFormatter": "esbenp.prettier-vscode"
    // },
    // "[scss]": {
    //     "editor.defaultFormatter": "esbenp.prettier-vscode"
    // },
    // "[vue]": {
    //     // 可选值： eslint ："dbaeumer.vscode-eslint"  vetur: "octref.vetur"   prettier: "esbenp.prettier-vscode"
    //     "editor.defaultFormatter": "esbenp.prettier-vscode"
    // },
    // "[typescript]": {
    //     // 对ts文件进行格式化时，使用哪一种风格 (此处使用的是vscode中安装的ts插件默认风格进行格式化)
    //     "editor.defaultFormatter": "vscode.typescript-language-features"
    // },
    // "[markdown]": {
    //     "editor.defaultFormatter": "yzhang.markdown-all-in-one"
    // }
}

## 16.15. 包管理工具

### 16.15.1. npm

- npm cache clean -f

- 改变npm默认路径

	- 步骤如下：
进入终端，依次输入一下命令
（1）创建global安装任务的目录
mkdir ~/.npm-global
（2）配置npm使用新的目录
npm config set prefix '~/.npm-global'
（3）在~/.profile文件中增加配置
export PATH=~/.npm-global/bin:$PATH
（4）配置文件立即生效
source ~/.profile
（5）重新执行命令
npm install -g xxxx 

- 成功有效的一种方式

	- prefix=/mnt/d/software/Nodejs/node_global
cache=/mnt/d/software/Nodejs/node_cache
registry=http://registry.npm.taobao.org


- nrm其他镜像地址查询

	- npm install nrm -g

	- 其他镜像地址查询
nrm ls

- n

	- npm install -g n

		- n stable

- npm切换镜像

	- npm config set -g registry https://registry.npm.taobao.org

	- npm config set registry https://registry.npmjs.org

	- npm config set registry http://registry.npm.taobao.org

	- 如果node-sass安装不成功换成下面的镜像

	- npm config set registry http://npm.taobao.org

	- npm install nrm -g

### 16.15.2. yarn

### 16.15.3. brew

- brew services list

	- 查看使用brew安装的服务列表

- brew services run formula｜--all #启动服务，仅启动不注册

- brew services start formula｜--all #启动服务，并注册

- brew services  stop formula ｜ --all # 停止服务哦，并取消注册

- brew services restart formula｜--all # 重启服务，并注册

- brew services cleanup #清除已卸载应用的无用的配置

- brew services 命令 需要翻墙才能起来 不然报错

	- export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

### 16.15.4. pnpm

- 参考链接：

	- [1.【工程化】最高性能的包管理器——pnpm](https://juejin.cn/post/7103139607243391012)

### 16.15.5. 参考文档：

- [1.关于 npm 和yarn 总结一些细节](https://juejin.cn/post/7103804890547224583)

## 16.16. 增加代码检查配套工具

### 16.16.1. vue.config.js

- const StyleLintPlugin = require('stylelint-webpack-plugin')

module.exports = {
  configureWebpack: {
    plugins: [
      new StyleLintPlugin({
        files: ['**/*.{vue,htm,html,css,sss,less,scss,sass}']
      })
    ]
  }
}


### 16.16.2. eslint

- .eslintrc.js

	- module.exports = {
  root: true,
  extends: [
    'plugin:vue/essential',
    'standard'
  ],
  env: {
    browser: true,
    commonjs: true,
    es6: true,
    node: true
  },
  parserOptions: {
    ecmaVersion: 2021,
    sourceType: 'module'
  },
  rules: {}
}

- Configuration File Formats

	-  The priority order is as follows:

	- .eslintrc.js
.eslintrc.cjs
.eslintrc.yaml
.eslintrc.yml
.eslintrc.json
package.json

- Using Configuration Files

	- via .eslintrc.* and package.json files

	- The second way to use configuration files is to save the file wherever you would like and pass its location to the CLI using the --config option, such as:
使用配置文件的第二种方法是将文件保存在任何您想要的地方，并使用 -- config 选项将其位置传递给 CLI，例如

		- eslint -c myconfig.json myfiletotest.js

		- If you are using one configuration file and want ESLint to ignore any .eslintrc.* files, make sure to use --no-eslintrc along with the -c flag.

如果您正在使用一个配置文件，并希望 ESLint 忽略任何。Eslintrc.* files，确保使用 -- no-eslintrc 和 -c 标志。

- 配置插件

	- ESLint支持使用第三方插件。
在使用插件之前，您必须使用npm进行安装。

	- 要在配置文件中配置插件，请使用plugins包含插件名称列表名称。

	- 插件名称可以省略 eslint-plugin- 前缀

	- 虽然官方提供了上百种的规则可供选择，但是这还不够，因为官方的规则只能检查标准的 JavaScript 语法，如果你写的是 JSX 或者 Vue 单文件组件，这个时候就需要安装 ESLint 的插件，来定制一些特定的规则进行检查。ESLint 的插件与扩展一样有固定的命名格式，以 eslint-plugin- 开头，该eslint-plugin-前缀可以从插件名称被省略。

		- module.exports = {
  root: true,
  parserOptions: {
    parser: 'babel-eslint',
    sourceType: 'module'
  },
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  globals: {
    $: true,
    var2: false
  },
  plugins: [
    'vue',  // 实际上是eslint-plugin-vue
  ],
}

	- 在rules配置中定义插件的约束

		- 配置定义在插件中的一个规则的时候，你必须使用 插件名/规则ID 的形式

		- "rules":{
	"react/no-console":"warn"
}

- 扩展配置

	- 该extends属性值是，ESLint递归地扩展配置：
一个指定配置的字符串
一个字符串数组：每个附加配置扩展了前面的配置

		- module.exports = {
  root: true,
  parserOptions: {
    parser: 'babel-eslint',
    sourceType: 'module'
  },
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  globals: {
    $: true,
    var2: false
  },
  plugins: [
    'vue',  // 实际上是eslint-plugin-vue
  ],
  extends: [
    "eslint:recommended",
    "plugin:vue/recommended",
    "eslint-config-standard"
  ]
}

			- eslint: 开头的是 ESLint 官方的扩展，一共有两个：eslint:recommended 、eslint:all （官方不建议用）。

			- plugin: 开头的是扩展是插件类型，也可以直接在 plugins 属性中进行设置。

			- 最后一种扩展来自 npm 包，官方规定 npm 包的扩展必须以 eslint-config- 开头，使用时可以省略这个头，上面案例中 eslint-config-standard 可以直接简写成 standard

			- 拓展的eslint-config-vue插件就有几种拓展看如图
![image](assets/6f63f56080d08e678ca347f6d180ff5d62c4b5ddf41d499c721c54e45f62990b.png)

				-  
![image](assets/2e4158264a0f85509e4b4cbaf151c1c17cde61aaaf4ea26f1b77eee43bd38a9c.png)

			- 所以最后的规则就是 以下边这个案例为例
"extends": [
    "eslint:recommended",
    "plugin:vue/recommended",
    "eslint-config-standard"
  ]

				-  配置下  recommended 的规则，再加上eslint-config-standard的规则。上边只是举例。（实际不要用我写的顺序）

			- 注意事项：

				- 当插件内就一个规则，就直接在extent里写就行了

				- 当插件像eslint-config-vue这种有好几种规则，那就插件里要写，拓展里选择要使用的规则 例如下边

					- module.exports = {
	root: true,
  env: {
    browser: true,
    es6: true,
  },
  parserOptions: {
    ecmaVersion: 11,
    sourceType: 'module',
  },
  extends: [
    'plugin:vue/essential',
    'airbnb-base',
  ],
  plugins: [
    'vue',
  ],
  rules: {
  },
};

	- 扩展就是直接使用别人已经写好的 规则。扩展一般支持三种类型

- 配置文件

	- 有两种主要的方法来配置ESLint

		- 配置注释 - 使用JavaScript注释将配置信息直接嵌入到文件中。

		- 配置文件 - 使用JavaScript，JSON或YAML文件指定整个目录（不是主目录）及其所有子目录的配置信息。这可以采用.eslintrc。*文件或文件中的eslintConfig字段的形式package.json，ESLint将自动查找和读取，也可以在命令行上指定配置文件。如果您的主目录中（通常~/）有配置文件，则ESLint 仅在ESLint找不到任何其他配置文件时才使用它。

			- 配置文件写很多个。会按照从内层向外找知道顶层，除非遇到 root : true 停止向上查找，一层层覆盖。出现冲突，以最外层位置优先级最高。

所以在你需要的目录下，不希望它向上继续查找。

- 指定解析器选项

	- parserOptions

		- parser

			- 指定解析器

				- 默认情况下，ESLint使用Espree作为其解析器，流行方案使用Babel-Eslint

				- 你可以指定解析器，但是要符合下列要求：

					- 它必须是一个 Node 模块，可以从它出现的配置文件中加载。通常，这意味着应该使用 npm 单独安装解析器包

					- 它必须符合 parser interface

				- 在.eslintrc 文件里指定 parser 选项表明使用该npm模块作为解析器之一

					- {
    "parser": "esprima",
    "rules": {
        "semi": "error"
    }
}

				- 以下解析器与 ESLint 兼容：

					- 1、Esprima

					- 2、Babel-ESLint
一个对Babel解析器的包装，使其能够与 ESLint 兼容。

					- 3、@typescript-eslint/parser
将 TypeScript 转换成与 estree 兼容的形式，以便在ESLint中使用。

				- 注意：

					- 在使用自定义解析器时，为了让 ESLint 在处理非 ECMAScript 5 特性时正常工作，配置属性 parserOptions 仍然是必须的解析器会被传入parserOptions，但是不一定会使用它们来决定功能特性的开关。

		- ecmaVersion

			- emcaVersion用来指定你想要使用的 ECMAScript 版本，设置为3,5（默认）

			- 6,7或8以指定要使用的ECMAScript语法的版本。您也可以设置为2015年（与6）相同，2016年（与7相同）或2017（与8相同）使用年份命名。

			- latest

				- always enables the latest supported ECMAScript version in ESLint's default parser.

		- sourceType

			- 设置为 "script" (默认)或"module"（如果你的代码是 ECMAScript 模块)

			- 指定来源的类型，有两种”script”或”module”

		- ecmaFeatures

			- globalReturn

				- //在全局作用域下使用return语句

			- impliedStrict

				- 启用全局严格模式（如果ecmaVersion是5或更高）

			- jsx

				- 是否启用JSX

			-  想使用额外的语言特性，一个对象，指示您想要使用哪些其他语言功能

- 指定环境

	- 环境定义了预定义的全局变量。可用的环境是

		- browser - 浏览器全局变量。

		- node - Node.js全局变量和Node.js范围。

		- commonjs - CommonJS全局变量和CommonJS范围（使用Browserify / WebPack的浏览器代码）。

		- shared-node-browser - Node.js和Browser的通用全局。

		- es6- 启用除模块外的所有ECMAScript 6功能（这会自动将ecmaVersion解析器选项设置为6）。

		- worker - 网络工作者全局变量。

		- amd- 根据amd规范定义require()和define()作为全局变量。

		- mocha - 增加了所有的Mocha测试全局变量。

		- jasmine - 为版本1.3和2.0添加了所有Jasmine测试全局变量。

		- jest - 是全局变量。

		- phantomjs - PhantomJS全局变量。

		- protractor - 量角器全局变量。

		- qunit - QUnit全局变量。

		- jquery - jQuery全局变量。

		- prototypejs - Prototype.js全局变量。

		- shelljs - ShellJS全局变量。

		- meteor - 流星全球变量。

		- mongo - MongoDB全局变量。

		- applescript - AppleScript全局变量。

		- nashorn - Java 8 Nashorn全局变量。

		- serviceworker - 服务工作者全局变量。

		- atomtest - Atom测试助手全局变量。

		- embertest - 灰烬测试帮手全局。

		- webextensions - 全球网络扩展。

		- greasemonkey - GreaseMonkey全局变量。

- 测试

	- 配置制定的eslint文件，忽略本地跟node_modules同级的.eslintrc.js配置文件

		- eslint -c ../../code/ngconsole/.eslintrc.json --no-eslintrc src/**/*.js --fix   

			- ngconsole中的.eslintrc.json中没有配置babel-eslint解析器
![image](assets/d2bcbe0c1678318d1e6b32b10402c5c34df33d6a07d4ff2ba84854d79b0cea0b.png)

		- eslint -c ../../code/edaas-front/.eslintrc.json --no-eslintrc src/**/*.js --fix

			- edaas-front中的.eslintrc配置了babel-eslint
![image](assets/e4ad7818b310257090e9aa886b833602685e01cdfa635bee45bd8bc7ad5ce2a5.png)

### 16.16.3. prettier

- "tabWidth": 4,
    "semi": true,
    "singleQuote": false,
    "trailingComma": "none",
    "arrowParens": "avoid",
    "javascript.format.insertSpaceBeforeFunctionParenthesis": true,
    "vetur.format.defaultFormatter.js": "vscode-typescript",
    "printWidth": 140,
    "useTabs": false

### 16.16.4. stylelint

- .stylelintrc.json

	- {
  "extends": "stylelint-config-standard"
}


### 16.16.5. [husky](https://zhuanlan.zhihu.com/p/366786798)

- package.json

	-  "prepare": "node -e 'fs.existsSync(`.husky`)||process.exit(1)' || husky install",

	-     "lint": "eslint ./src && stylelint ./src/**/*.vue"

### 16.16.6. [.gitlab-ci.yml](http://http://172.16.203.254/help/ci/yaml/README)

Keyword reference for the .gitlab-ci.yml file


This document lists the configuration options for your GitLab .gitlab-ci.yml file.

For a quick introduction to GitLab CI/CD, follow the quick start guide.
For a collection of examples, see GitLab CI/CD Examples.
To view a large .gitlab-ci.yml file used in an enterprise, see the .gitlab-ci.yml file for gitlab.

When you are editing your .gitlab-ci.yml file, you can validate it with the
CI Lint tool.

Job keywords
A job is defined as a list of keywords that define the job's behavior.
The keywords available for jobs are:



Keyword
Description




script
Shell script that is executed by a runner.


after_script
Override a set of commands that are executed after job.


allow_failure
Allow job to fail. A failed job does not cause the pipeline to fail.


artifacts
List of files and directories to attach to a job on success. Also available: artifacts:paths, artifacts:exclude, artifacts:expose_as, artifacts:name, artifacts:untracked, artifacts:when, artifacts:expire_in, and artifacts:reports.


before_script
Override a set of commands that are executed before job.


cache
List of files that should be cached between subsequent runs. Also available: cache:paths, cache:key, cache:untracked, cache:when, and cache:policy.


coverage
Code coverage settings for a given job.


dependencies
Restrict which artifacts are passed to a specific job by providing a list of jobs to fetch artifacts from.


environment
Name of an environment to which the job deploys. Also available: environment:name, environment:url, environment:on_stop, environment:auto_stop_in, and environment:action.


except
Limit when jobs are not created. Also available: except:refs, except:kubernetes, except:variables, and except:changes.


extends
Configuration entries that this job inherits from.


image
Use Docker images. Also available: image:name and image:entrypoint.


include
Include external YAML files. Also available: include:local, include:file, include:template, and include:remote.


interruptible
Defines if a job can be canceled when made redundant by a newer run.


only
Limit when jobs are created. Also available: only:refs, only:kubernetes, only:variables, and only:changes.


pages
Upload the result of a job to use with GitLab Pages.


parallel
How many instances of a job should be run in parallel.


release
Instructs the runner to generate a Release object.


resource_group
Limit job concurrency.


retry
When and how many times a job can be auto-retried in case of a failure.


rules
List of conditions to evaluate and determine selected attributes of a job, and whether or not it's created.


services
Use Docker services images. Also available: services:name, services:alias, services:entrypoint, and services:command.


stage
Defines a job stage (default: test).


tags
List of tags that are used to select a runner.


timeout
Define a custom job-level timeout that takes precedence over the project-wide setting.


trigger
Defines a downstream pipeline trigger.


variables
Define job variables on a job level.


when
When to run job. Also available: when:manual and when:delayed.




Unavailable names for jobs
Each job must have a unique name, but there are a few reserved keywords that
can't be used as job names:

image
services
stages
types
before_script
after_script
variables
cache
include


Reserved keywords
If you get a validation error when you use specific values (for example, true or false), try to:

Quote them.
Change them to a different form. For example, /bin/true.


Global keywords
Some keywords are defined at a global level and affect all jobs in the pipeline.

Global defaults
Some keywords can be set globally as the default for all jobs with the
default: keyword. Default keywords can then be overridden by job-specific
configuration.
The following job keywords can be defined inside a default: block:

image
services
before_script
after_script
tags
cache
artifacts
retry
timeout
interruptible

In the following example, the ruby:2.5 image is set as the default for all
jobs except the rspec 2.6 job, which uses the ruby:2.6 image:
default:
 image: ruby:2.5

rspec:
 script: bundle exec rspec

rspec 2.6:
 image: ruby:2.6
 script: bundle exec rspec

inherit


Introduced in GitLab 12.9.

You can disable inheritance of globally defined defaults
and variables with the inherit: keyword.
To enable or disable the inheritance of all default: or variables: keywords, use:


default: true or default: false


variables: true or variables: false


To inherit only a subset of default: keywords or variables:, specify what
you wish to inherit. Anything not listed is not inherited. Use
one of the following formats:
inherit:
 default: [keyword1, keyword2]
 variables: [VARIABLE1, VARIABLE2]
Or:
inherit:
 default:
 - keyword1
 - keyword2
 variables:
 - VARIABLE1
 - VARIABLE2
In the example below:


rubocop:

inherits: Nothing.



rspec:

inherits: the default image and the WEBHOOK_URL variable.
does not inherit: the default before_script and the DOMAIN variable.



capybara:

inherits: the default before_script and image.
does not inherit: the DOMAIN and WEBHOOK_URL variables.



karma:

inherits: the default image and before_script, and the DOMAIN variable.
does not inherit: WEBHOOK_URL variable.



default:
 image: 'ruby:2.4'
 before_script:
 - echo Hello World

variables:
 DOMAIN: example.com
 WEBHOOK_URL: https://my-webhook.example.com

rubocop:
 inherit:
 default: false
 variables: false
 script: bundle exec rubocop

rspec:
 inherit:
 default: [image]
 variables: [WEBHOOK_URL]
 script: bundle exec rspec

capybara:
 inherit:
 variables: false
 script: bundle exec capybara

karma:
 inherit:
 default: true
 variables: [DOMAIN]
 script: karma

stages

Use stages to define stages that contain groups of jobs. stages is defined globally
for the pipeline. Use stage in a job to define which stage the job is
part of.
The order of the stages items defines the execution order for jobs:

Jobs in the same stage run in parallel.
Jobs in the next stage run after the jobs from the previous stage complete successfully.

For example:
stages:
 - build
 - test
 - deploy

All jobs in build execute in parallel.
If all jobs in build succeed, the test jobs execute in parallel.
If all jobs in test succeed, the deploy jobs execute in parallel.
If all jobs in deploy succeed, the pipeline is marked as passed.

If any job fails, the pipeline is marked as failed and jobs in later stages do not
start. Jobs in the current stage are not stopped and continue to run.
If no stages are defined in the .gitlab-ci.yml file, then build, test and deploy
are the default pipeline stages.
If a job does not specify a stage, the job is assigned the test stage.
To make a job start earlier and ignore the stage order, use
the needs keyword.

workflow:rules


Introduced in GitLab 12.5

The top-level workflow: keyword determines whether or not a pipeline is created.
It accepts a single rules: keyword that is similar to rules: defined in jobs.
Use it to define what can trigger a new pipeline.
You can use the workflow:rules templates to import
a preconfigured workflow: rules entry.
workflow: rules accepts these keywords:


if: Check this rule to determine when to run a pipeline.

when: Specify what to do when the if rule evaluates to true.

To run a pipeline, set to always.
To prevent pipelines from running, set to never.



When no rules evaluate to true, the pipeline does not run.
Some example if clauses for workflow: rules:



Example rules
Details




if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
Control when merge request pipelines run.


if: '$CI_PIPELINE_SOURCE == "push"'
Control when both branch pipelines and tag pipelines run.


if: $CI_COMMIT_TAG
Control when tag pipelines run.


if: $CI_COMMIT_BRANCH
Control when branch pipelines run.



See the common if clauses for rules for more examples.
For example, in the following configuration, pipelines run for all push events (changes to
branches and new tags). Pipelines for push events with -wip in the commit message
don't run, because they are set to when: never. Pipelines for schedules or merge requests
don't run either, because no rules evaluate to true for them:
workflow:
 rules:
 - if: $CI_COMMIT_MESSAGE =~ /-wip$/
 when: never
 - if: '$CI_PIPELINE_SOURCE == "push"'
This example has strict rules, and pipelines do not run in any other case.
Alternatively, all of the rules can be when: never, with a final
when: always rule. Pipelines that match the when: never rules do not run.
All other pipeline types run:
workflow:
 rules:
 - if: '$CI_PIPELINE_SOURCE == "schedule"'
 when: never
 - if: '$CI_PIPELINE_SOURCE == "push"'
 when: never
 - when: always
This example prevents pipelines for schedules or push (branches and tags) pipelines.
The final when: always rule runs all other pipeline types, including merge
request pipelines.
If your rules match both branch pipelines and merge request pipelines,
duplicate pipelines can occur.

workflow:rules templates

Introduced in GitLab 13.0.

We provide templates that set up workflow: rules
for common scenarios. These templates help prevent duplicate pipelines.
The Branch-Pipelines template
makes your pipelines run for branches and tags.
Branch pipeline status is displayed in merge requests that use the branch
as a source. However, this pipeline type does not support any features offered by
Merge Request Pipelines, like
Pipelines for Merge Results
or Merge Trains.
Use this template if you are intentionally avoiding those features.
It is included as follows:
include:
 - template: 'Workflows/Branch-Pipelines.gitlab-ci.yml'
The MergeRequest-Pipelines template
makes your pipelines run for the default branch (usually master), tags, and
all types of merge request pipelines. Use this template if you use any of the
the Pipelines for Merge Requests features, as mentioned
above.
It is included as follows:
include:
 - template: 'Workflows/MergeRequest-Pipelines.gitlab-ci.yml'

include



Introduced in GitLab Premium 10.5.
Available for Starter, Premium, and Ultimate in GitLab 10.6 and later.

Moved to GitLab Free in 11.4.


Use the include keyword to include external YAML files in your CI/CD configuration.
You can break down one long gitlab-ci.yml file into multiple files to increase readability,
or reduce duplication of the same configuration in multiple places.
You can also store template files in a central repository and include them in projects.
include requires the external YAML file to have the extensions .yml or .yaml,
otherwise the external file is not included.
You can't use YAML anchors across different YAML files sourced by include.
You can only refer to anchors in the same file. Instead of YAML anchors, you can
use the extends keyword.
include supports the following inclusion methods:



Keyword
Method




local
Include a file from the local project repository.


file
Include a file from a different project repository.


remote
Include a file from a remote URL. Must be publicly accessible.


template
Include templates that are provided by GitLab.



The .gitlab-ci.yml file configuration included by all methods is evaluated when the pipeline is created.
The configuration is a snapshot in time and persisted in the database. Any changes to
the referenced .gitlab-ci.yml file configuration is not reflected in GitLab until the next pipeline is created.
The files defined by include are:

Deep merged with those in the .gitlab-ci.yml file.
Always evaluated first and merged with the content of the .gitlab-ci.yml file,
regardless of the position of the include keyword.

NOTE:
Use merging to customize and override included CI/CD configurations with local
configurations. Local configurations in the .gitlab-ci.yml file override included configurations.

Variables with include (FREE SELF)




Introduced in GitLab 13.8.

Feature flag removed in GitLab 13.9.


You can use some predefined variables in include sections
in your .gitlab-ci.yml file:
include:
 project: '$CI_PROJECT_PATH'
 file: '.compliance-gitlab-ci.yml'
For an example of how you can include these predefined variables, and their impact on CI jobs,
see the following CI/CD variable demo.

include:local

include:local includes a file that is in the same repository as the .gitlab-ci.yml file.
It's referenced with full paths relative to the root directory (/).
If you use include:local, make sure that both the .gitlab-ci.yml file and the local file
are on the same branch.
You can't include local files through Git submodules paths.
All nested includes are executed in the scope of the same project,
so it's possible to use local, project, remote, or template includes.
Example:
include:
 - local: '/templates/.gitlab-ci-template.yml'
This can be defined as a short local include:
include: '.gitlab-ci-production.yml'
Use local includes instead of symbolic links.

include:file


Introduced in GitLab 11.7.

To include files from another private project on the same GitLab instance,
use include:file. You can use include:file in combination with include:project only.
The included file is referenced with a full path, relative to the root directory (/). For example:
include:
 - project: 'my-group/my-project'
 file: '/templates/.gitlab-ci-template.yml'
You can also specify a ref. If not specified, it defaults to the HEAD of the project:
include:
 - project: 'my-group/my-project'
 ref: master
 file: '/templates/.gitlab-ci-template.yml'

 - project: 'my-group/my-project'
 ref: v1.0.0
 file: '/templates/.gitlab-ci-template.yml'

 - project: 'my-group/my-project'
 ref: 787123b47f14b552955ca2786bc9542ae66fee5b # Git SHA
 file: '/templates/.gitlab-ci-template.yml'
All nested includes are executed in the scope of the target project.
You can use local (relative to target project), project, remote, or template includes.

Multiple files from a project



Introduced in GitLab 13.6.

Feature flag removed in GitLab 13.8.


You can include multiple files from the same project:
include:
 - project: 'my-group/my-project'
 ref: master
 file:
 - '/templates/.builds.yml'
 - '/templates/.tests.yml'

include:remote

Use include:remote with a full URL to include a file from a different location.
The remote file must be publicly accessible by an HTTP/HTTPS GET request, because
authentication in the remote URL is not supported. For example:
include:
 - remote: 'https://gitlab.com/example-project/-/raw/master/.gitlab-ci.yml'
All nested includes execute without context as a public user,
so you can only include public projects or templates.

include:template


Introduced in GitLab 11.7.

Use include:template to include .gitlab-ci.yml templates that are
shipped with GitLab.
For example:
# 17. File sourced from the GitLab template collection
include:
 - template: Auto-DevOps.gitlab-ci.yml
Multiple include:template files:
include:
 - template: Android-Fastlane.gitlab-ci.yml
 - template: Auto-DevOps.gitlab-ci.yml
All nested includes are executed only with the permission of the user,
so it's possible to use project, remote or template includes.

Nested includes

Introduced in GitLab 11.9.

Use nested includes to compose a set of includes.
You can have up to 100 includes, but you can't have duplicate includes.
In GitLab 12.4 and later, the time limit
to resolve all files is 30 seconds.

Additional includes examples
There is a list of additional includes examples available.

Keyword details
The following are detailed explanations for keywords used to configure CI/CD pipelines.

image

Used to specify a Docker image to use for the job.
For:

Usage examples, see Define image and services from .gitlab-ci.yml.
Detailed usage information, refer to Docker integration documentation.


image:name

An extended Docker configuration option.
For more information, see Available settings for image.

image:entrypoint

An extended Docker configuration option.
For more information, see Available settings for image.

services

Used to specify a service Docker image, linked to a base image specified in image.
For:

Usage examples, see Define image and services from .gitlab-ci.yml.
Detailed usage information, refer to Docker integration documentation.
For example services, see GitLab CI/CD Services.


services:name

An extended Docker configuration option.
For more information, see Available settings for services.

services:alias

An extended Docker configuration option.
For more information, see Available settings for services.

services:entrypoint

An extended Docker configuration option.
For more information, see Available settings for services.

services:command

An extended Docker configuration option.
For more information, see Available settings for services.

script

script is the only required keyword that a job needs. It's a shell script
that is executed by the runner. For example:
job:
 script: "bundle exec rspec"
You can use YAML anchors with script.
This keyword can also contain several commands in an array:
job:
 script:
 - uname -a
 - bundle exec rspec
Sometimes, script commands must be wrapped in single or double quotes.
For example, commands that contain a colon (:) must be wrapped in single quotes (').
The YAML parser needs to interpret the text as a string rather than
a "key: value" pair.
For example, this script uses a colon:
job:
 script:
 - curl --request POST --header 'Content-Type: application/json' "https://gitlab/api/v4/projects"
To be considered valid YAML, you must wrap the entire command in single quotes. If
the command already uses single quotes, you should change them to double quotes (")
if possible:
job:
 script:
 - 'curl --request POST --header "Content-Type: application/json" "https://gitlab/api/v4/projects"'
You can verify the syntax is valid with the CI Lint tool.
Be careful when using these special characters as well:


{, }, [, ], ,, &, *, #, ?, |, -, <, >, =, !, %, @, `.

If any of the script commands return an exit code other than zero, the job
fails and further commands are not executed. Store the exit code in a variable to
avoid this behavior:
job:
 script:
 - false || exit_code=$?
 - if [ $exit_code -ne 0 ]; then echo "Previous command failed"; fi;

before_script

Use before_script to define an array of commands that should run before each job,
but after artifacts are restored.
Scripts specified in before_script are concatenated with any scripts specified
in the main script, and executed together in a single shell.
It's possible to overwrite a globally defined before_script if you define it in a job:
default:
 before_script:
 - echo "Execute this script in all jobs that don't already have a before_script section."

job1:
 script:
 - echo "This script executes after the global before_script."

job:
 before_script:
 - echo "Execute this script instead of the global before_script."
 script:
 - echo "This script executes after the job's `before_script`"
You can use YAML anchors with before_script.

after_script

Use after_script to define an array of commands that run after each job,
including failed jobs.
If a job times out or is cancelled, the after_script commands are not executed.
Support for executing after_script commands for timed-out or cancelled jobs
is planned.
Scripts specified in after_script are executed in a new shell, separate from any
before_script or script scripts. As a result, they:

Have a current working directory set back to the default.
Have no access to changes done by scripts defined in before_script or script, including:

Command aliases and variables exported in script scripts.
Changes outside of the working tree (depending on the runner executor), like
software installed by a before_script or script script.


Have a separate timeout, which is hard coded to 5 minutes. See the
related issue for details.
Don't affect the job's exit code. If the script section succeeds and the
after_script times out or fails, the job exits with code 0 (Job Succeeded).

default:
 after_script:
 - echo "Execute this script in all jobs that don't already have an after_script section."

job1:
 script:
 - echo "This script executes first. When it completes, the global after_script executes."

job:
 script:
 - echo "This script executes first. When it completes, the job's `after_script` executes."
 after_script:
 - echo "Execute this script instead of the global after_script."
You can use YAML anchors with after_script.

Script syntax
You can use special syntax in script sections to:


Split long commands into multiline commands.

Use color codes to make job logs easier to review.

Create custom collapsible sections
to simplify job log output.


stage

stage is defined per-job and relies on stages, which is defined
globally. Use stage to define which stage a job runs in, and jobs of the same
stage are executed in parallel (subject to certain conditions). For example:
stages:
 - build
 - test
 - deploy

job 0:
 stage: .pre
 script: make something useful before build stage

job 1:
 stage: build
 script: make build dependencies

job 2:
 stage: build
 script: make build artifacts

job 3:
 stage: test
 script: make test

job 4:
 stage: deploy
 script: make deploy

job 5:
 stage: .post
 script: make something useful at the end of pipeline

Use your own runners
When you use your own runners, each runner runs only one job at a time by default.
Jobs can run in parallel if they run on different runners.
If you have only one runner, jobs can run in parallel if the runner's
concurrent setting
is greater than 1.

.pre and .post


Introduced in GitLab 12.4.

The following stages are available to every pipeline:


.pre, which is guaranteed to always be the first stage in a pipeline.

.post, which is guaranteed to always be the last stage in a pipeline.

User-defined stages are executed after .pre and before .post.
A pipeline is not created if all jobs are in .pre or .post stages.
The order of .pre and .post can't be changed, even if defined out of order in the .gitlab-ci.yml file.
For example, the following are equivalent configuration:


Configured in order:
stages:
 - .pre
 - a
 - b
 - .post


Configured out of order:
stages:
 - a
 - .pre
 - b
 - .post


Not explicitly configured:
stages:
 - a
 - b



extends


Introduced in GitLab 11.3.

Use extends to reuse configuration sections. It's an alternative to YAML anchors
and is a little more flexible and readable. You can use extends to reuse configuration
from included configuration files.
In this example, the rspec job uses the configuration from the .tests template job.
GitLab:

Performs a reverse deep merge based on the keys.
Merges the .tests content with the rspec job.
Doesn't merge the values of the keys.

.tests:
 script: rake test
 stage: test
 only:
 refs:
 - branches

rspec:
 extends: .tests
 script: rake rspec
 only:
 variables:
 - $RSPEC
The result is this rspec job:
rspec:
 script: rake rspec
 stage: test
 only:
 refs:
 - branches
 variables:
 - $RSPEC
.tests in this example is a hidden job, but it's
possible to extend configuration from regular jobs as well.
extends supports multi-level inheritance. You should avoid using more than three levels,
but you can use as many as eleven. The following example has two levels of inheritance:
.tests:
 only:
 - pushes

.rspec:
 extends: .tests
 script: rake rspec

rspec 1:
 variables:
 RSPEC_SUITE: '1'
 extends: .rspec

rspec 2:
 variables:
 RSPEC_SUITE: '2'
 extends: .rspec

spinach:
 extends: .tests
 script: rake spinach
In GitLab 12.0 and later, it's also possible to use multiple parents for
extends.

Merge details
extends is able to merge hashes but not arrays.
The algorithm used for merge is "closest scope wins", so
keys from the last member always override anything defined on other
levels. For example:
.only-important:
 variables:
 URL: "http://my-url.internal"
 IMPORTANT_VAR: "the details"
 only:
 - master
 - stable
 tags:
 - production
 script:
 - echo "Hello world!"

.in-docker:
 variables:
 URL: "http://docker-url.internal"
 tags:
 - docker
 image: alpine

rspec:
 variables:
 GITLAB: "is-awesome"
 extends:
 - .only-important
 - .in-docker
 script:
 - rake rspec
The result is this rspec job:
rspec:
 variables:
 URL: "http://docker-url.internal"
 IMPORTANT_VAR: "the details"
 GITLAB: "is-awesome"
 only:
 - master
 - stable
 tags:
 - docker
 image: alpine
 script:
 - rake rspec
Note that in the example above:

The variables sections merge, but URL: "http://docker-url.internal" overwrites URL: "http://my-url.internal".

tags: ['docker'] overwrites tags: ['production'].

script does not merge, but script: ['rake rspec'] overwrites
script: ['echo "Hello world!"']. You can use YAML anchors to merge arrays.


Use extends and include together
To reuse configuration from different configuration files,
combine extends and include.
In this example, a script is defined in the included.yml file.
Then, in the .gitlab-ci.yml file, you use extends to refer
to the contents of the script:


included.yml:
.template:
 script:
 - echo Hello!


.gitlab-ci.yml:
include: included.yml

useTemplate:
 image: alpine
 extends: .template



rules


Introduced in GitLab 12.3.

Use the rules keyword to include or exclude jobs in pipelines.
Rules are evaluated in order until the first match. When matched, the job
is either included or excluded from the pipeline, depending on the configuration.
If included, the job also has certain attributes
added to it.
rules replaces only/except and they can't be used together
in the same job. If you configure one job to use both keywords, the linter returns a
key may not be used with rules error.

Rules attributes
The job attributes you can use with rules are:


when: If not defined, defaults to when: on_success.

If used as when: delayed, start_in is also required.



allow_failure: If not defined, defaults to allow_failure: false.

variables: If not defined, uses the variables defined elsewhere.

If a rule evaluates to true, and when has any value except never, the job is included in the pipeline.
For example:
docker build:
 script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
 rules:
 - if: '$CI_COMMIT_BRANCH == "master"'
 when: delayed
 start_in: '3 hours'
 allow_failure: true

Rules clauses
Available rule clauses are:



Clause
Description




if
Add or exclude jobs from a pipeline by evaluating an if statement. Similar to only:variables.


changes
Add or exclude jobs from a pipeline based on what files are changed. Same as only:changes.


exists
Add or exclude jobs from a pipeline based on the presence of specific files.



Rules are evaluated in order until a match is found. If a match is found, the attributes
are checked to see if the job should be added to the pipeline. If no attributes are defined,
the defaults are:

when: on_success
allow_failure: false

The job is added to the pipeline:

If a rule matches and has when: on_success, when: delayed or when: always.
If no rules match, but the last clause is when: on_success, when: delayed
or when: always (with no rule).

The job is not added to the pipeline:

If no rules match, and there is no standalone when: on_success, when: delayed or
when: always.
If a rule matches, and has when: never as the attribute.

This example uses if to strictly limit when jobs run:
job:
 script: echo "Hello, Rules!"
 rules:
 - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
 when: manual
 allow_failure: true
 - if: '$CI_PIPELINE_SOURCE == "schedule"'

If the pipeline is for a merge request, the first rule matches, and the job
is added to the merge request pipeline
with attributes of:


when: manual (manual job)

allow_failure: true (the pipeline continues running even if the manual job is not run)


If the pipeline is not for a merge request, the first rule doesn't match, and the
second rule is evaluated.
If the pipeline is a scheduled pipeline, the second rule matches, and the job
is added to the scheduled pipeline. No attributes were defined, so it is added
with:


when: on_success (default)

allow_failure: false (default)


In all other cases, no rules match, so the job is not added to any other pipeline.

Alternatively, you can define a set of rules to exclude jobs in a few cases, but
run them in all other cases:
job:
 script: echo "Hello, Rules!"
 rules:
 - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
 when: never
 - if: '$CI_PIPELINE_SOURCE == "schedule"'
 when: never
 - when: on_success

If the pipeline is for a merge request, the job is not be added to the pipeline.
If the pipeline is a scheduled pipeline, the job is not be added to the pipeline.
In all other cases, the job is added to the pipeline, with when: on_success.

WARNING:
If you use a when: clause as the final rule (not including when: never), two
simultaneous pipelines may start. Both push pipelines and merge request pipelines can
be triggered by the same event (a push to the source branch for an open merge request).
See how to prevent duplicate pipelines
for more details.

Prevent duplicate pipelines
Jobs defined with rules can trigger multiple pipelines with the same action. You
don't have to explicitly configure rules for each type of pipeline to trigger them
accidentally. Rules that are too broad could cause simultaneous pipelines of a different
type to run unexpectedly.
Some configurations that have the potential to cause duplicate pipelines cause a
pipeline warning to be displayed.
Introduced in GitLab 13.3.
For example:
job:
 script: echo "This job creates double pipelines!"
 rules:
 - if: '$CUSTOM_VARIABLE == "false"'
 when: never
 - when: always
This job does not run when $CUSTOM_VARIABLE is false, but it does run in all
other pipelines, including both push (branch) and merge request pipelines. With
this configuration, every push to an open merge request's source branch
causes duplicated pipelines.
There are multiple ways to avoid duplicate pipelines:


Use workflow: rules to specify which types of pipelines
can run. To eliminate duplicate pipelines, use merge request pipelines only
or push (branch) pipelines only.


Rewrite the rules to run the job only in very specific cases,
and avoid a final when: rule:
job:
 script: echo "This job does NOT create double pipelines!"
 rules:
 - if: '$CUSTOM_VARIABLE == "true" && $CI_PIPELINE_SOURCE == "merge_request_event"'


You can prevent duplicate pipelines by changing the job rules to avoid either push (branch)
pipelines or merge request pipelines. However, if you use a - when: always rule without
workflow: rules, GitLab still displays a pipeline warning.
For example, the following does not trigger double pipelines, but is not recommended
without workflow: rules:
job:
 script: echo "This job does NOT create double pipelines!"
 rules:
 - if: '$CI_PIPELINE_SOURCE == "push"'
 when: never
 - when: always
Do not include both push and merge request pipelines in the same job:
job:
 script: echo "This job creates double pipelines!"
 rules:
 - if: '$CI_PIPELINE_SOURCE == "push"'
 - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
Also, do not mix only/except jobs with rules jobs in the same pipeline.
It may not cause YAML errors, but the different default behaviors of only/except
and rules can cause issues that are difficult to troubleshoot:
job-with-no-rules:
 script: echo "This job runs in branch pipelines."

job-with-rules:
 script: echo "This job runs in merge request pipelines."
 rules:
 - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
For every change pushed to the branch, duplicate pipelines run. One
branch pipeline runs a single job (job-with-no-rules), and one merge request pipeline
runs the other job (job-with-rules). Jobs with no rules default
to except: merge_requests, so job-with-no-rules
runs in all cases except merge requests.
It is not possible to define rules based on whether or not a branch has an open
merge request associated with it. You can't configure a job to be included in:

Only branch pipelines when the branch doesn't have a merge request associated with it.
Only merge request pipelines when the branch has a merge request associated with it.

See the related issue for more details.

rules:if

rules:if clauses determine whether or not jobs are added to a pipeline by evaluating
an if statement. If the if statement is true, the job is either included
or excluded from a pipeline. In plain English, if rules can be interpreted as one of:

"If this rule evaluates to true, add the job" (default).
"If this rule evaluates to true, do not add the job" (by adding when: never).

rules:if differs slightly from only:variables by accepting only a single
expression string per rule, rather than an array of them. Any set of expressions to be
evaluated can be conjoined into a single expression
by using && or ||, and the variable matching operators (==, !=, =~ and !~).
Unlike variables in script
sections, variables in rules expressions are always formatted as $VARIABLE.
if: clauses are evaluated based on the values of predefined CI/CD variables
or custom CI/CD variables.
For example:
job:
 script: echo "Hello, Rules!"
 rules:
 - if: '$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME =~ /^feature/ && $CI_MERGE_REQUEST_TARGET_BRANCH_NAME == "master"'
 when: always
 - if: '$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME =~ /^feature/'
 when: manual
 allow_failure: true
 - if: '$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME' # Checking for the presence of a variable is possible
Some details regarding the logic that determines the when for the job:

If none of the provided rules match, the job is set to when: never and is
not included in the pipeline.
A rule without any conditional clause, such as a when or allow_failure
rule without if or changes, always matches, and is always used if reached.
If a rule matches and has no when defined, the rule uses the when
defined for the job, which defaults to on_success if not defined.
You can define when once per rule, or once at the job-level, which applies to
all rules. You can't mix when at the job-level with when in rules.


Common if clauses for rules

For behavior similar to the only/except keywords, you can
check the value of the $CI_PIPELINE_SOURCE variable:



Value
Description




api
For pipelines triggered by the pipelines API.


chat
For pipelines created by using a GitLab ChatOps command.


external
When you use CI services other than GitLab.


external_pull_request_event
When an external pull request on GitHub is created or updated. See Pipelines for external pull requests.


merge_request_event
For pipelines created when a merge request is created or updated. Required to enable merge request pipelines, merged results pipelines, and merge trains.


parent_pipeline
For pipelines triggered by a parent/child pipeline with rules. Use this pipeline source in the child pipeline configuration so that it can be triggered by the parent pipeline.


pipeline
For multi-project pipelines created by using the API with CI_JOB_TOKEN, or the trigger keyword.


push
For pipelines triggered by a git push event, including for branches and tags.


schedule
For scheduled pipelines.


trigger
For pipelines created by using a trigger token.


web
For pipelines created by using Run pipeline button in the GitLab UI, from the project's CI/CD > Pipelines section.


webide
For pipelines created by using the WebIDE.



For example:
job:
 script: echo "Hello, Rules!"
 rules:
 - if: '$CI_PIPELINE_SOURCE == "schedule"'
 when: manual
 allow_failure: true
 - if: '$CI_PIPELINE_SOURCE == "push"'
This example runs the job as a manual job in scheduled pipelines or in push
pipelines (to branches or tags), with when: on_success (default). It does not
add the job to any other pipeline type.
Another example:
job:
 script: echo "Hello, Rules!"
 rules:
 - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
 - if: '$CI_PIPELINE_SOURCE == "schedule"'
This example runs the job as a when: on_success job in merge request pipelines
and scheduled pipelines. It does not run in any other pipeline type.
Other commonly used variables for if clauses:


if: $CI_COMMIT_TAG: If changes are pushed for a tag.

if: $CI_COMMIT_BRANCH: If changes are pushed to any branch.

if: '$CI_COMMIT_BRANCH == "master"': If changes are pushed to master.

if: '$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH': If changes are pushed to the default
branch (usually master). Use when you want to have the same configuration in multiple
projects with different default branches.

if: '$CI_COMMIT_BRANCH =~ /regex-expression/': If the commit branch matches a regular expression.

if: '$CUSTOM_VARIABLE !~ /regex-expression/': If the custom variable
CUSTOM_VARIABLE does not match a regular expression.

if: '$CUSTOM_VARIABLE == "value1"': If the custom variable CUSTOM_VARIABLE is
exactly value1.


rules:changes

rules:changes determines whether or not to add jobs to a pipeline by checking for
changes to specific files.
rules: changes works exactly the same way as only: changes and except: changes,
accepting an array of paths. It's recommended to only use rules: changes with branch
pipelines or merge request pipelines. For example, it's common to use rules: changes
with merge request pipelines:
docker build:
 script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
 rules:
 - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
 changes:
 - Dockerfile
 when: manual
 allow_failure: true
In this example:

If the pipeline is a merge request pipeline, check Dockerfile for changes.
If Dockerfile has changed, add the job to the pipeline as a manual job, and the pipeline
continues running even if the job is not triggered (allow_failure: true).
If Dockerfile has not changed, do not add job to any pipeline (same as when: never).

To use rules: changes with branch pipelines instead of merge request pipelines,
change the if: clause in the example above to:
rules:
 - if: $CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_BRANCH
To implement a rule similar to except:changes,
use when: never.
WARNING:
You can use rules: changes with other pipeline types, but it is not recommended
because rules: changes always evaluates to true when there is no Git push event.
Tag pipelines, scheduled pipelines, and so on do not have a Git push event
associated with them. A rules: changes job is always added to those pipeline
if there is no if: statement that limits the job to branch or merge request pipelines.

Variables in rules:changes




Introduced in GitLab 13.6.

Feature flag removed in GitLab 13.7.


CI/CD variables can be used in rules:changes expressions to determine when
to add jobs to a pipeline:
docker build:
 variables:
 DOCKERFILES_DIR: 'path/to/files/'
 script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
 rules:
 - changes:
 - $DOCKERFILES_DIR/*
You can use The $ character for both variables and paths. For example, if the
$DOCKERFILES_DIR variable exists, its value is used. If it does not exist, the
$ is interpreted as being part of a path.

rules:exists


Introduced in GitLab 12.4.

exists accepts an array of paths and matches if any of these paths exist
as files in the repository.
In this example, job runs if a Dockerfile exists anywhere in the repository:
job:
 script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
 rules:
 - exists:
 - Dockerfile
Paths are relative to the project directory ($CI_PROJECT_DIR) and can't directly link outside it.
You can use glob patterns to match multiple files in any directory in the repository:
job:
 script: bundle exec rspec
 rules:
 - exists:
 - spec/**.rb
Glob patterns are interpreted with Ruby File.fnmatch
with the flags File::FNM_PATHNAME | File::FNM_DOTMATCH | File::FNM_EXTGLOB.
For performance reasons, GitLab matches a maximum of 10,000 exists patterns. After the 10,000th check, rules with patterned globs always match.

rules:allow_failure


Introduced in GitLab 12.8.

You can use allow_failure: true in rules: to allow a job to fail, or a manual job to
wait for action, without stopping the pipeline itself. All jobs that use rules: default to allow_failure: false
if allow_failure: is not defined.
The rule-level rules:allow_failure option overrides the job-level
allow_failure option, and is only applied when the job is
triggered by the particular rule.
job:
 script: echo "Hello, Rules!"
 rules:
 - if: '$CI_MERGE_REQUEST_TARGET_BRANCH_NAME == "master"'
 when: manual
 allow_failure: true
In this example, if the first rule matches, then the job has when: manual and allow_failure: true.

rules:variables




Introduced in GitLab 13.7.
It was deployed behind a feature flag, disabled by default.

Became enabled by default on GitLab 13.8.
It's enabled on GitLab.com.
It's recommended for production use.
For GitLab self-managed instances, GitLab administrators can opt to disable it. (FREE SELF)



WARNING:
This feature might not be available to you. Check the version history note above for details.
You can use variables in rules: to define variables for specific conditions.
For example:
job:
 variables:
 DEPLOY_VARIABLE: "default-deploy"
 rules:
 - if: $CI_COMMIT_REF_NAME =~ /master/
 variables: # Override DEPLOY_VARIABLE defined
 DEPLOY_VARIABLE: "deploy-production" # at the job level.
 - if: $CI_COMMIT_REF_NAME =~ /feature/
 variables:
 IS_A_FEATURE: "true" # Define a new variable.
 script:
 - echo "Run script with $DEPLOY_VARIABLE as an argument"
 - echo "Run another script if $IS_A_FEATURE exists"

Enable or disable rules:variables (FREE SELF)

rules:variables is under development but ready for production use.
It is deployed behind a feature flag that is enabled by default.
GitLab administrators with access to the GitLab Rails console
can opt to disable it.
To enable it:
Feature.enable(:ci_rules_variables)
To disable it:
Feature.disable(:ci_rules_variables)

Complex rule clauses
To conjoin if, changes, and exists clauses with an AND, use them in the
same rule.
In the following example:

If the Dockerfile file or any file in /docker/scripts has changed, and $VAR == "string value",
then the job runs manually
Otherwise, the job isn't included in the pipeline.

docker build:
 script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
 rules:
 - if: '$VAR == "string value"'
 changes: # Include the job and set to when:manual if any of the follow paths match a modified file.
 - Dockerfile
 - docker/scripts/*
 when: manual
# 18. "when: never" would be redundant here. It is implied any time rules are listed.
Keywords such as branches or refs that are available for
only/except are not available in rules. They are being individually
considered for their usage and behavior in this context. Future keyword improvements
are being discussed in our epic for improving rules,
where anyone can add suggestions or requests.
You can use parentheses with && and || to build more complicated variable expressions.
Introduced in GitLab 13.3:
job1:
 script:
 - echo This rule uses parentheses.
 rules:
 if: ($CI_COMMIT_BRANCH == "master" || $CI_COMMIT_BRANCH == "develop") && $MY_VARIABLE
WARNING:
Before GitLab 13.3,
rules that use both || and && may evaluate with an unexpected order of operations.

only/except (basic)
NOTE:
only and except are not being actively developed. To define when
to add jobs to pipelines, use rules.
only and except are two keywords that determine when to add jobs to pipelines:


only defines the names of branches and tags the job runs for.

except defines the names of branches and tags the job does
not run for.

There are a few rules that apply to the usage of job policy:


only and except are inclusive. If both only and except are defined
in a job specification, the ref is filtered by only and except.

only and except can use regular expressions (supported regexp syntax).

only and except can specify a repository path to filter jobs for forks.

In addition, only and except can use special keywords:



Value
Description




api
For pipelines triggered by the pipelines API.


branches
When the Git reference for a pipeline is a branch.


chat
For pipelines created by using a GitLab ChatOps command.


external
When you use CI services other than GitLab.


external_pull_requests
When an external pull request on GitHub is created or updated (See Pipelines for external pull requests).


merge_requests
For pipelines created when a merge request is created or updated. Enables merge request pipelines, merged results pipelines, and merge trains.


pipelines
For multi-project pipelines created by using the API with CI_JOB_TOKEN, or the trigger keyword.


pushes
For pipelines triggered by a git push event, including for branches and tags.


schedules
For scheduled pipelines.


tags
When the Git reference for a pipeline is a tag.


triggers
For pipelines created by using a trigger token.


web
For pipelines created by using Run pipeline button in the GitLab UI, from the project's CI/CD > Pipelines section.



Scheduled pipelines run on specific branches, so jobs configured with only: branches
run on scheduled pipelines too. Add except: schedules to prevent jobs with only: branches
from running on scheduled pipelines.
In the example below, job runs only for refs that start with issue-,
whereas all branches are skipped:
job:
# 19. use regexp
 only:
 - /^issue-.*$/
# 20. use special keyword
 except:
 - branches
Pattern matching is case-sensitive by default. Use i flag modifier, like
/pattern/i to make a pattern case-insensitive:
job:
# 21. use regexp
 only:
 - /^issue-.*$/i
# 22. use special keyword
 except:
 - branches
In this example, job runs only for refs that are tagged, or if a build is
explicitly requested by an API trigger or a Pipeline Schedule:
job:
# 23. use special keywords
 only:
 - tags
 - triggers
 - schedules
Use the repository path to have jobs executed only for the parent
repository and not forks:
job:
 only:
 - branches@gitlab-org/gitlab
 except:
 - master@gitlab-org/gitlab
 - /^release/.*$/@gitlab-org/gitlab
The above example runs job for all branches on gitlab-org/gitlab,
except master and those with names prefixed with release/.
If a job does not have an only rule, only: ['branches', 'tags'] is set by
default. If it does not have an except rule, it's empty.
For example, job1 and job2 are essentially the same:
job1:
 script: echo 'test'

job2:
 script: echo 'test'
 only: ['branches', 'tags']

Regular expressions
The @ symbol denotes the beginning of a ref's repository path.
To match a ref name that contains the @ character in a regular expression,
you must use the hex character code match \x40.
Only the tag or branch name can be matched by a regular expression.
The repository path, if given, is always matched literally.
To match the tag or branch name,
the entire ref name part of the pattern must be a regular expression surrounded by /.
For example, you can't use issue-/.*/ to match all tag names or branch names
that begin with issue-, but you can use /issue-.*/.
Regular expression flags must be appended after the closing /.
NOTE:
Use anchors ^ and $ to avoid the regular expression
matching only a substring of the tag name or branch name.
For example, /^issue-.*$/ is equivalent to /^issue-/,
while just /issue/ would also match a branch called severe-issues.

Supported only/except regexp syntax
In GitLab 11.9.4, GitLab began internally converting the regexp used
in only and except keywords to RE2.
RE2 limits the set of available features
due to computational complexity, and some features, like negative lookaheads, became unavailable.
Only a subset of features provided by Ruby Regexp
are now supported.
From GitLab 11.9.7 to GitLab 12.0, GitLab provided a feature flag to
let you use unsafe regexp syntax. After migrating to safe syntax, you should disable
this feature flag again:
Feature.enable(:allow_unsafe_ruby_regexp)

only/except (advanced)
GitLab supports multiple strategies, and it's possible to use an
array or a hash configuration scheme.
Four keys are available:

refs
variables
changes
kubernetes

If you use multiple keys under only or except, the keys are evaluated as a
single conjoined expression. That is:


only: includes the job if all of the keys have at least one condition that matches.

except: excludes the job if any of the keys have at least one condition that matches.

With only, individual keys are logically joined by an AND. A job is added to
the pipeline if the following is true:

(any listed refs are true) AND (any listed variables are true) AND (any listed changes are true) AND (any chosen Kubernetes status matches)

In the example below, the test job is only created when all of the following are true:

The pipeline is scheduled or runs for master.
The variables keyword matches.
The kubernetes service is active on the project.

test:
 script: npm run test
 only:
 refs:
 - master
 - schedules
 variables:
 - $CI_COMMIT_MESSAGE =~ /run-end-to-end-tests/
 kubernetes: active
With except, individual keys are logically joined by an OR. A job is not
added if the following is true:

(any listed refs are true) OR (any listed variables are true) OR (any listed changes are true) OR (a chosen Kubernetes status matches)

In the example below, the test job is not created when any of the following are true:

The pipeline runs for the master branch.
There are changes to the README.md file in the root directory of the repository.

test:
 script: npm run test
 except:
 refs:
 - master
 changes:
 - "README.md"

only:refs/except:refs


refs policy introduced in GitLab 10.0.

The refs strategy can take the same values as the
simplified only/except configuration.
In the example below, the deploy job is created only when the
pipeline is scheduled or runs for the master branch:
deploy:
 only:
 refs:
 - master
 - schedules

only:kubernetes/except:kubernetes


kubernetes policy introduced in GitLab 10.0.

The kubernetes strategy accepts only the active keyword.
In the example below, the deploy job is created only when the
Kubernetes service is active in the project:
deploy:
 only:
 kubernetes: active

only:variables/except:variables


variables policy introduced in GitLab 10.7.

The variables keyword defines variable expressions.
These expressions determine whether or not a job should be created.
Examples of variable expressions:
deploy:
 script: cap staging deploy
 only:
 refs:
 - branches
 variables:
 - $RELEASE == "staging"
 - $STAGING
Another use case is excluding jobs depending on a commit message:
end-to-end:
 script: rake test:end-to-end
 except:
 variables:
 - $CI_COMMIT_MESSAGE =~ /skip-end-to-end-tests/
You can use parentheses with && and || to build more complicated variable expressions.
Introduced in GitLab 13.3:
job1:
 script:
 - echo This rule uses parentheses.
 only:
 variables:
 - ($CI_COMMIT_BRANCH == "master" || $CI_COMMIT_BRANCH == "develop") && $MY_VARIABLE

only:changes/except:changes


changes policy introduced in GitLab 11.4.

Use the changes keyword with only to run a job, or with except to skip a job,
when a Git push event modifies a file.
Use only:changes with pipelines triggered by the following refs only:

branches
external_pull_requests

merge_requests (see additional details about using only:changes with pipelines for merge requests)

WARNING:
In pipelines with sources other than the three above
changes can't determine if a given file is new or old and always returns true.
You can configure jobs to use only: changes with other only: refs keywords. However,
those jobs ignore the changes and always run.
In this example, when you push commits to an existing branch, the docker build job
runs only if any of these files change:

The Dockerfile file.
Files in the docker/scripts/ directory.
Files and subdirectories in the dockerfiles directory.
Files with rb, py, sh extensions in the more_scripts directory.

docker build:
 script: docker build -t my-image:$CI_COMMIT_REF_SLUG .
 only:
 refs:
 - branches
 changes:
 - Dockerfile
 - docker/scripts/*
 - dockerfiles/**/*
 - more_scripts/*.{rb,py,sh}
WARNING:
If you use only:changes with only allow merge requests to be merged if the pipeline succeeds,
you should also use only:merge_requests. Otherwise it may not work as expected.
You can also use glob patterns to match multiple files in either the root directory
of the repository, or in any directory in the repository. However, they must be wrapped
in double quotes or GitLab can't parse them:
test:
 script: npm run test
 only:
 refs:
 - branches
 changes:
 - "*.json"
 - "**/*.sql"
You can skip a job if a change is detected in any file with a
.md extension in the root directory of the repository:
build:
 script: npm run build
 except:
 changes:
 - "*.md"
If you change multiple files, but only one file ends in .md,
the build job is still skipped. The job does not run for any of the files.
Read more about how to use this feature with:


New branches or tags without pipelines for merge requests.

Scheduled pipelines.


Use only:changes with pipelines for merge requests
With pipelines for merge requests,
it's possible to define a job to be created based on files modified
in a merge request.
Use this keyword with only: [merge_requests] so GitLab can find the correct base
SHA of the source branch. File differences are correctly calculated from any further
commits, and all changes in the merge requests are properly tested in pipelines.
For example:
docker build service one:
 script: docker build -t my-service-one-image:$CI_COMMIT_REF_SLUG .
 only:
 refs:
 - merge_requests
 changes:
 - Dockerfile
 - service-one/**/*
In this scenario, if a merge request changes
files in the service-one directory or the Dockerfile, GitLab creates
the docker build service one job.
For example:
docker build service one:
 script: docker build -t my-service-one-image:$CI_COMMIT_REF_SLUG .
 only:
 changes:
 - Dockerfile
 - service-one/**/*
In the example above, the pipeline might fail because of changes to a file in service-one/**/*.
A later commit that doesn't have changes in service-one/**/*
but does have changes to the Dockerfile can pass. The job
only tests the changes to the Dockerfile.
GitLab checks the most recent pipeline that passed. If the merge request is mergeable,
it doesn't matter that an earlier pipeline failed because of a change that has not been corrected.
When you use this configuration, ensure that the most recent pipeline
properly corrects any failures from previous pipelines.

Use only:changes without pipelines for merge requests
Without pipelines for merge requests, pipelines
run on branches or tags that don't have an explicit association with a merge request.
In this case, a previous SHA is used to calculate the diff, which is equivalent to git diff HEAD~.
This can result in some unexpected behavior, including:

When pushing a new branch or a new tag to GitLab, the policy always evaluates to true.
When pushing a new commit, the changed files are calculated by using the previous commit
as the base SHA.


Use only:changes with scheduled pipelines
only:changes always evaluates as true in Scheduled pipelines.
All files are considered to have changed when a scheduled pipeline runs.

needs




Introduced in GitLab 12.2.
In GitLab 12.3, maximum number of jobs in needs array raised from five to 50.

Introduced in GitLab 12.8, needs: [] lets jobs start immediately.


Use the needs: keyword to execute jobs out-of-order. Relationships between jobs
that use needs can be visualized as a directed acyclic graph.
You can ignore stage ordering and run some jobs without waiting for others to complete.
Jobs in multiple stages can run concurrently.
Let's consider the following example:
linux:build:
 stage: build

mac:build:
 stage: build

lint:
 stage: test
 needs: []

linux:rspec:
 stage: test
 needs: ["linux:build"]

linux:rubocop:
 stage: test
 needs: ["linux:build"]

mac:rspec:
 stage: test
 needs: ["mac:build"]

mac:rubocop:
 stage: test
 needs: ["mac:build"]

production:
 stage: deploy
This example creates four paths of execution:


Linter: the lint job runs immediately without waiting for the build stage to complete because it has no needs (needs: []).


Linux path: the linux:rspec and linux:rubocop jobs runs as soon
as the linux:build job finishes without waiting for mac:build to finish.


macOS path: the mac:rspec and mac:rubocop jobs runs as soon
as the mac:build job finishes, without waiting for linux:build to finish.


The production job runs as soon as all previous jobs
finish; in this case: linux:build, linux:rspec, linux:rubocop,
mac:build, mac:rspec, mac:rubocop.



Requirements and limitations

If needs: is set to point to a job that is not instantiated
because of only/except rules or otherwise does not exist, the
pipeline is not created and a YAML error is shown.
The maximum number of jobs that a single job can need in the needs: array is limited:

For GitLab.com, the limit is 50. For more information, see our
infrastructure issue.
For self-managed instances, the limit is: 50. This limit can be changed.


If needs: refers to a job that uses the parallel keyword,
it depends on all jobs created in parallel, not just one job. It also downloads
artifacts from all the parallel jobs by default. If the artifacts have the same
name, they overwrite each other and only the last one downloaded is saved.

needs: is similar to dependencies: in that it must use jobs from prior stages,
meaning it's impossible to create circular dependencies. Depending on jobs in the
current stage is not possible either, but support is planned.
Related to the above, stages must be explicitly defined for all jobs
that have the keyword needs: or are referred to by one.


Changing the needs: job limit (FREE SELF)

The maximum number of jobs that can be defined in needs: defaults to 50.
A GitLab administrator with access to the GitLab Rails console
can choose a custom limit. For example, to set the limit to 100:
Plan.default.actual_limits.update!(ci_needs_size_limit: 100)
To disable directed acyclic graphs (DAG), set the limit to 0.

Artifact downloads with needs


Introduced in GitLab v12.6.

Use artifacts: true (default) or artifacts: false to control when artifacts are
downloaded in jobs that use needs.
In this example, the rspec job downloads the build_job artifacts, but the
rubocop job does not:
build_job:
 stage: build
 artifacts:
 paths:
 - binaries/

rspec:
 stage: test
 needs:
 - job: build_job
 artifacts: true

rubocop:
 stage: test
 needs:
 - job: build_job
 artifacts: false
In this example, the rspec job downloads the artifacts from all three build_jobs.
artifacts is:

Set to true for build_job_1.
Defaults to true for both build_job_2 and build_job_3.

rspec:
 needs:
 - job: build_job_1
 artifacts: true
 - job: build_job_2
 - build_job_3
In GitLab 12.6 and later, you can't combine the dependencies keyword
with needs.

Cross project artifact downloads with needs (PREMIUM)


Introduced in GitLab v12.7.

Use needs to download artifacts from up to five jobs in pipelines:


On other refs in the same project.
In different projects, groups and namespaces.

build_job:
 stage: build
 script:
 - ls -lhR
 needs:
 - project: namespace/group/project-name
 job: build-1
 ref: master
 artifacts: true
build_job downloads the artifacts from the latest successful build-1 job
on the master branch in the group/project-name project. If the project is in the
same group or namespace, you can omit them from the project: keyword. For example,
project: group/project-name or project: project-name.
The user running the pipeline must have at least reporter access to the group or project, or the group/project must have public visibility.

Artifact downloads between pipelines in the same project
Use needs to download artifacts from different pipelines in the current project.
Set the project keyword as the current project's name, and specify a ref.
In this example, build_job downloads the artifacts for the latest successful
build-1 job with the other-ref ref:
build_job:
 stage: build
 script:
 - ls -lhR
 needs:
 - project: group/same-project-name
 job: build-1
 ref: other-ref
 artifacts: true
CI/CD variable support for project:, job:, and ref was introduced
in GitLab 13.3. Feature flag removed in GitLab 13.4.
For example:
build_job:
 stage: build
 script:
 - ls -lhR
 needs:
 - project: $CI_PROJECT_PATH
 job: $DEPENDENCY_JOB_NAME
 ref: $ARTIFACTS_DOWNLOAD_REF
 artifacts: true
Downloading artifacts from jobs that are run in parallel: is not supported.
To download artifacts between parent-child pipelines use needs:pipeline.
Downloading artifacts from the same ref as the currently running pipeline is not
recommended because artifacts could be overridden by concurrent pipelines running
on the same ref.

Artifact downloads to child pipelines

Introduced in GitLab v13.7.

A child pipeline can download artifacts from a job in
its parent pipeline or another child pipeline in the same parent-child pipeline hierarchy.
For example, with the following parent pipeline that has a job that creates some artifacts:
create-artifact:
 stage: build
 script: echo 'sample artifact' > artifact.txt
 artifacts:
 paths: [artifact.txt]

child-pipeline:
 stage: test
 trigger:
 include: child.yml
 strategy: depend
 variables:
 PARENT_PIPELINE_ID: $CI_PIPELINE_ID
A job in the child pipeline can download artifacts from the create-artifact job in
the parent pipeline:
use-artifact:
 script: cat artifact.txt
 needs:
 - pipeline: $PARENT_PIPELINE_ID
 job: create-artifact
The pipeline attribute accepts a pipeline ID and it must be a pipeline present
in the same parent-child pipeline hierarchy of the given pipeline.
The pipeline attribute does not accept the current pipeline ID ($CI_PIPELINE_ID).
To download artifacts from a job in the current pipeline, use the basic form of needs.

tags

Use tags to select a specific runner from the list of all runners that are
available for the project.
When you register a runner, you can specify the runner's tags, for
example ruby, postgres, development.
In this example, the job is run by a runner that
has both ruby and postgres tags defined.
job:
 tags:
 - ruby
 - postgres
You can use tags to run different jobs on different platforms. For
example, if you have an OS X runner with tag osx and a Windows runner with tag
windows, you can run a job on each platform:
windows job:
 stage:
 - build
 tags:
 - windows
 script:
 - echo Hello, %USERNAME%!

osx job:
 stage:
 - build
 tags:
 - osx
 script:
 - echo "Hello, $USER!"

allow_failure

Use allow_failure when you want to let a job fail without impacting the rest of the CI
suite. The default value is false, except for manual jobs that use
the when: manual syntax.
In jobs that use rules:, all jobs default to allow_failure: false,
including when: manual jobs.
When allow_failure is set to true and the job fails, the job shows an orange warning in the UI.
However, the logical flow of the pipeline considers the job a
success/passed, and is not blocked.
Assuming all other jobs are successful, the job's stage and its pipeline
show the same orange warning. However, the associated commit is marked as
"passed", without warnings.
In the example below, job1 and job2 run in parallel, but if job1
fails, it doesn't stop the next stage from running, because it's marked with
allow_failure: true:
job1:
 stage: test
 script:
 - execute_script_that_will_fail
 allow_failure: true

job2:
 stage: test
 script:
 - execute_script_that_will_succeed

job3:
 stage: deploy
 script:
 - deploy_to_staging

allow_failure:exit_codes




Introduced in GitLab 13.8.

Feature flag removed in GitLab 13.9.


Use allow_failure:exit_codes to dynamically control if a job should be allowed
to fail. You can list which exit codes are not considered failures. The job fails
for any other exit code:
test_job_1:
 script:
 - echo "Run a script that results in exit code 1. This job fails."
 - exit 1
 allow_failure:
 exit_codes: 137

test_job_2:
 script:
 - echo "Run a script that results in exit code 137. This job is allowed to fail."
 - exit 137
 allow_failure:
 exit_codes:
 - 137
 - 255

when

Use when to implement jobs that run in case of failure or despite the
failure.
The valid values of when are:


on_success (default) - Execute job only when all jobs in earlier stages succeed,
or are considered successful because they have allow_failure: true.

on_failure - Execute job only when at least one job in an earlier stage fails.

always - Execute job regardless of the status of jobs in earlier stages.

manual - Execute job manually.

delayed - Delay the execution of a job for a specified duration.
Added in GitLab 11.14.

never:

With rules, don't execute job.
With workflow:rules, don't run pipeline.



For example:
stages:
 - build
 - cleanup_build
 - test
 - deploy
 - cleanup

build_job:
 stage: build
 script:
 - make build

cleanup_build_job:
 stage: cleanup_build
 script:
 - cleanup build when failed
 when: on_failure

test_job:
 stage: test
 script:
 - make test

deploy_job:
 stage: deploy
 script:
 - make deploy
 when: manual

cleanup_job:
 stage: cleanup
 script:
 - cleanup after jobs
 when: always
The above script:

Executes cleanup_build_job only when build_job fails.
Always executes cleanup_job as the last step in pipeline regardless of
success or failure.
Executes deploy_job when you run it manually in the GitLab UI.


when:manual

A manual job is a type of job that is not executed automatically and must be explicitly
started by a user. You might want to use manual jobs for things like deploying to production.
To make a job manual, add when: manual to its configuration.
Manual jobs can be started from the pipeline, job, environment,
and deployment views.
Manual jobs can be either optional or blocking:


Optional: Manual jobs have `allow_failure: true set by default
and are considered optional. The status of an optional manual job does not contribute
to the overall pipeline status. A pipeline can succeed even if all its manual jobs fail.


Blocking: To make a blocking manual job, add allow_failure: false to its configuration.
Blocking manual jobs stop further execution of the pipeline at the stage where the
job is defined. To let the pipeline continue running, click {play} (play) on
the blocking manual job.
Merge requests in projects with merge when pipeline succeeds
enabled can't be merged with a blocked pipeline. Blocked pipelines show a status
of blocked.


When you use rules:, allow_failure defaults to false, including for manual jobs.
To trigger a manual job, a user must have permission to merge to the assigned branch.
You can use protected branches to more strictly
protect manual deployments from being run by unauthorized users.
In GitLab 13.5 and later, you
can use when:manual in the same job as trigger. In GitLab 13.4 and
earlier, using them together causes the error jobs:#{job-name} when should be on_success, on_failure or always.

Protecting manual jobs (PREMIUM)

Use protected environments
to define a list of users authorized to run a manual job. You can authorize only
the users associated with a protected environment to trigger manual jobs, which can:

More precisely limit who can deploy to an environment.
Block a pipeline until an approved user "approves" it.

To protect a manual job:


Add an environment to the job. For example:
deploy_prod:
 stage: deploy
 script:
 - echo "Deploy to production server"
 environment:
 name: production
 url: https://example.com
 when: manual
 only:
 - master


In the protected environments settings,
select the environment (production in the example above) and add the users, roles or groups
that are authorized to trigger the manual job to the Allowed to Deploy list. Only those in
this list can trigger this manual job, as well as GitLab administrators
who are always able to use protected environments.


You can use protected environments with blocking manual jobs to have a list of users
allowed to approve later pipeline stages. Add allow_failure: false to the protected
manual job and the pipeline's next stages only run after the manual job is triggered
by authorized users.

when:delayed


Introduced in GitLab 11.4.

Use when: delayed to execute scripts after a waiting period, or if you want to avoid
jobs immediately entering the pending state.
You can set the period with start_in keyword. The value of start_in is an elapsed time in seconds, unless a unit is
provided. start_in must be less than or equal to one week. Examples of valid values include:

'5'
5 seconds
30 minutes
1 day
1 week

When a stage includes a delayed job, the pipeline doesn't progress until the delayed job finishes.
You can use this keyword to insert delays between different stages.
The timer of a delayed job starts immediately after the previous stage completes.
Similar to other types of jobs, a delayed job's timer doesn't start unless the previous stage passes.
The following example creates a job named timed rollout 10% that is executed 30 minutes after the previous stage completes:
timed rollout 10%:
 stage: deploy
 script: echo 'Rolling out 10% ...'
 when: delayed
 start_in: 30 minutes
To stop the active timer of a delayed job, click the {time-out} (Unschedule) button.
This job can no longer be scheduled to run automatically. You can, however, execute the job manually.
To start a delayed job immediately, click the Play button.
Soon GitLab Runner picks up and starts the job.

environment

Use environment to define the environment that a job deploys to.
If environment is specified and no environment under that name exists, a new
one is created automatically.
In its simplest form, the environment keyword can be defined like:
deploy to production:
 stage: deploy
 script: git push production HEAD:master
 environment: production
In the above example, the deploy to production job is marked as doing a
deployment to the production environment.

environment:name

The environment: name keyword can use any of the defined CI/CD variables,
including predefined, secure, or variables defined in the .gitlab-ci.yml file.
You can't use variables defined in a script section.
The environment name can contain:

letters
digits
spaces
-
_
/
$
{
}

Common names are qa, staging, and production, but you can use whatever
name works with your workflow.
Instead of defining the name of the environment right after the environment
keyword, it's also possible to define it as a separate value. For that, use
the name keyword under environment:
deploy to production:
 stage: deploy
 script: git push production HEAD:master
 environment:
 name: production

environment:url

The environment:url keyword can use any of the defined CI/CD variables,
including predefined, secure, or variables defined in the .gitlab-ci.yml file.
You can't use variables defined in a script section.
This optional value exposes buttons that take you to the defined URL
In this example, if the job finishes successfully, it creates buttons
in the merge requests and in the environments/deployments pages that point
to https://prod.example.com.
deploy to production:
 stage: deploy
 script: git push production HEAD:master
 environment:
 name: production
 url: https://prod.example.com

environment:on_stop




Introduced in GitLab 8.13.
Starting with GitLab 8.14, when you have an environment that has a stop action
defined, GitLab automatically triggers a stop action when the associated
branch is deleted.


Closing (stopping) environments can be achieved with the on_stop keyword
defined under environment. It declares a different job that runs to close the
environment.
Read the environment:action section for an example.

environment:action


Introduced in GitLab 8.13.

Use the action keyword to specify jobs that prepare, start, or stop environments.



Value
Description




start
Default value. Indicates that job starts the environment. The deployment is created after the job starts.


prepare
Indicates that job is only preparing the environment. Does not affect deployments. Read more about environments



stop
Indicates that job stops deployment. See the example below.



Take for instance:
review_app:
 stage: deploy
 script: make deploy-app
 environment:
 name: review/$CI_COMMIT_REF_NAME
 url: https://$CI_ENVIRONMENT_SLUG.example.com
 on_stop: stop_review_app

stop_review_app:
 stage: deploy
 variables:
 GIT_STRATEGY: none
 script: make delete-app
 when: manual
 environment:
 name: review/$CI_COMMIT_REF_NAME
 action: stop
In the above example, the review_app job deploys to the review
environment. A new stop_review_app job is listed under on_stop.
After the review_app job is finished, it triggers the
stop_review_app job based on what is defined under when. In this case,
it is set to manual, so it needs a manual action from
the GitLab UI to run.
Also in the example, GIT_STRATEGY is set to none. If the
stop_review_app job is automatically triggered,
the runner won’t try to check out the code after the branch is deleted.
The example also overwrites global variables. If your stop environment job depends
on global variables, use anchor variables when you set the GIT_STRATEGY
to change the job without overriding the global variables.
The stop_review_app job is required to have the following keywords defined:


when - reference

environment:name
environment:action

Additionally, both jobs should have matching rules
or only/except configuration.
In the example above, if the configuration is not identical:

The stop_review_app job might not be included in all pipelines that include the review_app job.
It is not possible to trigger the action: stop to stop the environment automatically.


environment:auto_stop_in


Introduced in GitLab 12.8.

The auto_stop_in keyword is for specifying the lifetime of the environment,
that when expired, GitLab automatically stops them.
For example,
review_app:
 script: deploy-review-app
 environment:
 name: review/$CI_COMMIT_REF_NAME
 auto_stop_in: 1 day
When the environment for review_app is created, the environment's lifetime is set to 1 day.
Every time the review app is deployed, that lifetime is also reset to 1 day.
For more information, see
the environments auto-stop documentation

environment:kubernetes


Introduced in GitLab 12.6.

Use the kubernetes keyword to configure deployments to a
Kubernetes cluster that is associated with your project.
For example:
deploy:
 stage: deploy
 script: make deploy-app
 environment:
 name: production
 kubernetes:
 namespace: production
This configuration sets up the deploy job to deploy to the production
environment, using the production
Kubernetes namespace.
For more information, see
Available settings for kubernetes.
NOTE:
Kubernetes configuration is not supported for Kubernetes clusters
that are managed by GitLab.
To follow progress on support for GitLab-managed clusters, see the
relevant issue.

Dynamic environments
Use CI/CD variables to dynamically name environments.
For example:
deploy as review app:
 stage: deploy
 script: make deploy
 environment:
 name: review/$CI_COMMIT_REF_NAME
 url: https://$CI_ENVIRONMENT_SLUG.example.com/
The deploy as review app job is marked as a deployment to dynamically
create the review/$CI_COMMIT_REF_NAME environment. $CI_COMMIT_REF_NAME
is a CI/CD variable set by the runner. The
$CI_ENVIRONMENT_SLUG variable is based on the environment name, but suitable
for inclusion in URLs. If the deploy as review app job runs in a branch named
pow, this environment would be accessible with a URL like https://review-pow.example.com/.
The common use case is to create dynamic environments for branches and use them
as Review Apps. You can see an example that uses Review Apps at
https://gitlab.com/gitlab-examples/review-apps-nginx/.

cache

Use the cache keyword to specify a list of files and directories to
cache between jobs. You can only use paths that are in the local working copy.
If cache is defined outside the scope of jobs, it's set
globally and all jobs use that configuration.
Caching is shared between pipelines and jobs. Caches are restored before artifacts.
Read how caching works and find out some good practices in the
caching dependencies documentation.

cache:paths

Use the paths directive to choose which files or directories to cache. Paths
are relative to the project directory ($CI_PROJECT_DIR) and can't directly link outside it.
You can use Wildcards that use glob
patterns and:

In GitLab Runner 13.0 and later,
doublestar.Glob.
In GitLab Runner 12.10 and earlier,
filepath.Match.

Cache all files in binaries that end in .apk and the .config file:
rspec:
 script: test
 cache:
 paths:
 - binaries/*.apk
 - .config
Locally defined cache overrides globally defined options. The following rspec
job caches only binaries/:
cache:
 paths:
 - my/files

rspec:
 script: test
 cache:
 key: rspec
 paths:
 - binaries/
The cache is shared between jobs, so if you're using different
paths for different jobs, you should also set a different cache:key.
Otherwise cache content can be overwritten.

cache:key

The key keyword defines the affinity of caching between jobs.
You can have a single cache for all jobs, cache per-job, cache per-branch,
or any other way that fits your workflow. You can fine tune caching,
including caching data between different jobs or even different branches.
The cache:key variable can use any of the
predefined variables. The default key, if not
set, is just literal default, which means everything is shared between
pipelines and jobs by default.
For example, to enable per-branch caching:
cache:
 key: "$CI_COMMIT_REF_SLUG"
 paths:
 - binaries/
If you use Windows Batch to run your shell scripts you need to replace
$ with %:
cache:
 key: "%CI_COMMIT_REF_SLUG%"
 paths:
 - binaries/
The cache:key variable can't contain the / character, or the equivalent
URI-encoded %2F. A value made only of dots (., %2E) is also forbidden.
You can specify a fallback cache key to use if the specified cache:key is not found.

Fallback cache key

Introduced in GitLab Runner 13.4.

You can use the $CI_COMMIT_REF_SLUG variable to specify your cache:key.
For example, if your $CI_COMMIT_REF_SLUG is test you can set a job
to download cache that's tagged with test.
If a cache with this tag is not found, you can use CACHE_FALLBACK_KEY to
specify a cache to use when none exists.
In this example, if the $CI_COMMIT_REF_SLUG is not found, the job uses the key defined
by the CACHE_FALLBACK_KEY variable:
variables:
 CACHE_FALLBACK_KEY: fallback-key

cache:
 key: "$CI_COMMIT_REF_SLUG"
 paths:
 - binaries/

cache:key:files


Introduced in GitLab v12.5.

The cache:key:files keyword extends the cache:key functionality by making it easier
to reuse some caches, and rebuild them less often, which speeds up subsequent pipeline
runs.
When you include cache:key:files, you must also list the project files that are used to generate the key, up to a maximum of two files.
The cache key is a SHA checksum computed from the most recent commits (up to two, if two files are listed)
that changed the given files. If neither file is changed in any commits,
the fallback key is default.
cache:
 key:
 files:
 - Gemfile.lock
 - package.json
 paths:
 - vendor/ruby
 - node_modules
In this example we're creating a cache for Ruby and Node.js dependencies that
is tied to current versions of the Gemfile.lock and package.json files. Whenever one of
these files changes, a new cache key is computed and a new cache is created. Any future
job runs that use the same Gemfile.lock and package.json with cache:key:files
use the new cache, instead of rebuilding the dependencies.

cache:key:prefix


Introduced in GitLab v12.5.

When you want to combine a prefix with the SHA computed for cache:key:files,
use the prefix keyword with key:files.
For example, if you add a prefix of test, the resulting key is: test-feef9576d21ee9b6a32e30c5c79d0a0ceb68d1e5.
If neither file is changed in any commits, the prefix is added to default, so the
key in the example would be test-default.
Like cache:key, prefix can use any of the predefined variables,
but cannot include:

the / character (or the equivalent URI-encoded %2F)
a value made only of . (or the equivalent URI-encoded %2E)

cache:
 key:
 files:
 - Gemfile.lock
 prefix: ${CI_JOB_NAME}
 paths:
 - vendor/ruby

rspec:
 script:
 - bundle exec rspec
For example, adding a prefix of $CI_JOB_NAME
causes the key to look like: rspec-feef9576d21ee9b6a32e30c5c79d0a0ceb68d1e5 and
the job cache is shared across different branches. If a branch changes
Gemfile.lock, that branch has a new SHA checksum for cache:key:files. A new cache key
is generated, and a new cache is created for that key.
If Gemfile.lock is not found, the prefix is added to
default, so the key in the example would be rspec-default.

cache:untracked

Set untracked: true to cache all files that are untracked in your Git
repository:
rspec:
 script: test
 cache:
 untracked: true
Cache all Git untracked files and files in binaries:
rspec:
 script: test
 cache:
 untracked: true
 paths:
 - binaries/

cache:when


Introduced in GitLab 13.5 and GitLab Runner v13.5.0.

cache:when defines when to save the cache, based on the status of the job. You can
set cache:when to:


on_success (default): Save the cache only when the job succeeds.

on_failure: Save the cache only when the job fails.

always: Always save the cache.

For example, to store a cache whether or not the job fails or succeeds:
rspec:
 script: rspec
 cache:
 paths:
 - rspec/
 when: 'always'

cache:policy

The default behavior of a caching job is to download the files at the start of
execution, and to re-upload them at the end. Any changes made by the
job are persisted for future runs. This behavior is known as the pull-push cache
policy.
If you know the job does not alter the cached files, you can skip the upload step
by setting policy: pull in the job specification. You can add an ordinary cache
job at an earlier stage to ensure the cache is updated from time to time:
stages:
 - setup
 - test

prepare:
 stage: setup
 cache:
 key: gems
 paths:
 - vendor/bundle
 script:
 - bundle install --deployment

rspec:
 stage: test
 cache:
 key: gems
 paths:
 - vendor/bundle
 policy: pull
 script:
 - bundle exec rspec ...
Use the pull policy when you have many jobs executing in parallel that use caches. This
policy speeds up job execution and reduces load on the cache server.
If you have a job that unconditionally recreates the cache without
referring to its previous contents, you can skip the download step.
To do so, add policy: push to the job.

artifacts

Use the artifacts keyword to specify a list of files and directories that are
attached to the job when it succeeds, fails, or always.
The artifacts are sent to GitLab after the job finishes. They are
available for download in the GitLab UI if the size is not
larger than the maximum artifact size.
Job artifacts are only collected for successful jobs by default, and
artifacts are restored after caches.
Read more about artifacts.

artifacts:paths

Paths are relative to the project directory ($CI_PROJECT_DIR) and can't directly
link outside it. You can use Wildcards that use glob
patterns and:

In GitLab Runner 13.0 and later,
doublestar.Glob.
In GitLab Runner 12.10 and earlier,
filepath.Match.

To restrict which jobs a specific job fetches artifacts from, see dependencies.
Send all files in binaries and .config:
artifacts:
 paths:
 - binaries/
 - .config
To disable artifact passing, define the job with empty dependencies:
job:
 stage: build
 script: make build
 dependencies: []
You may want to create artifacts only for tagged releases to avoid filling the
build server storage with temporary build artifacts.
Create artifacts only for tags (default-job doesn't create artifacts):
default-job:
 script:
 - mvn test -U
 except:
 - tags

release-job:
 script:
 - mvn package -U
 artifacts:
 paths:
 - target/*.war
 only:
 - tags
You can use wildcards for directories too. For example, if you want to get all the files inside the directories that end with xyz:
job:
 artifacts:
 paths:
 - path/*xyz/*

artifacts:public




Introduced in GitLab 13.8
It's deployed behind a feature flag, disabled by default.
It's enabled on GitLab.com.
It's recommended for production use.


Use artifacts:public to determine whether the job artifacts should be
publicly available.
The default for artifacts:public is true which means that the artifacts in
public pipelines are available for download by anonymous and guest users:
artifacts:
 public: true
To deny read access for anonymous and guest users to artifacts in public
pipelines, set artifacts:public to false:
artifacts:
 public: false

artifacts:exclude




Introduced in GitLab 13.1
Requires GitLab Runner 13.1


exclude makes it possible to prevent files from being added to an artifacts
archive.
Similar to artifacts:paths, exclude paths are relative
to the project directory. You can use Wildcards that use
glob or
filepath.Match patterns.
For example, to store all files in binaries/, but not *.o files located in
subdirectories of binaries/:
artifacts:
 paths:
 - binaries/
 exclude:
 - binaries/**/*.o
Files matched by artifacts:untracked can be excluded using
artifacts:exclude too.

artifacts:expose_as


Introduced in GitLab 12.5.

Use the expose_as keyword to expose job artifacts
in the merge request UI.
For example, to match a single file:
test:
 script: ["echo 'test' > file.txt"]
 artifacts:
 expose_as: 'artifact 1'
 paths: ['file.txt']
With this configuration, GitLab adds a link artifact 1 to the relevant merge request
that points to file1.txt.
An example that matches an entire directory:
test:
 script: ["mkdir test && echo 'test' > test/file.txt"]
 artifacts:
 expose_as: 'artifact 1'
 paths: ['test/']
Note the following:

Artifacts do not display in the merge request UI when using variables to define the artifacts:paths.
A maximum of 10 job artifacts per merge request can be exposed.
Glob patterns are unsupported.
If a directory is specified, the link is to the job artifacts browser if there is more than
one file in the directory.
For exposed single file artifacts with .html, .htm, .txt, .json, .xml,
and .log extensions, if GitLab Pages is:

Enabled, GitLab automatically renders the artifact.
Not enabled, the file is displayed in the artifacts browser.




artifacts:name

Use the name directive to define the name of the created artifacts
archive. You can specify a unique name for every archive. The artifacts:name
variable can make use of any of the predefined variables.
The default name is artifacts, which becomes artifacts.zip when you download it.
To create an archive with a name of the current job:
job:
 artifacts:
 name: "$CI_JOB_NAME"
 paths:
 - binaries/
To create an archive with a name of the current branch or tag including only
the binaries directory:
job:
 artifacts:
 name: "$CI_COMMIT_REF_NAME"
 paths:
 - binaries/
If your branch-name contains forward slashes
(for example feature/my-feature) it's advised to use $CI_COMMIT_REF_SLUG
instead of $CI_COMMIT_REF_NAME for proper naming of the artifact.
To create an archive with a name of the current job and the current branch or
tag including only the binaries directory:
job:
 artifacts:
 name: "$CI_JOB_NAME-$CI_COMMIT_REF_NAME"
 paths:
 - binaries/
To create an archive with a name of the current stage and branch name:
job:
 artifacts:
 name: "$CI_JOB_STAGE-$CI_COMMIT_REF_NAME"
 paths:
 - binaries/

If you use Windows Batch to run your shell scripts you need to replace
$ with %:
job:
 artifacts:
 name: "%CI_JOB_STAGE%-%CI_COMMIT_REF_NAME%"
 paths:
 - binaries/
If you use Windows PowerShell to run your shell scripts you need to replace
$ with $env::
job:
 artifacts:
 name: "$env:CI_JOB_STAGE-$env:CI_COMMIT_REF_NAME"
 paths:
 - binaries/

artifacts:untracked

Use artifacts:untracked to add all Git untracked files as artifacts (along
with the paths defined in artifacts:paths). artifacts:untracked ignores configuration
in the repository's .gitignore file.
Send all Git untracked files:
artifacts:
 untracked: true
Send all Git untracked files and files in binaries:
artifacts:
 untracked: true
 paths:
 - binaries/
Send all untracked files but exclude *.txt:
artifacts:
 untracked: true
 exclude:
 - "*.txt"

artifacts:when

Use artifacts:when to upload artifacts on job failure or despite the
failure.
artifacts:when can be set to one of the following values:


on_success (default): Upload artifacts only when the job succeeds.

on_failure: Upload artifacts only when the job fails.

always: Always upload artifacts.

For example, to upload artifacts only when a job fails:
job:
 artifacts:
 when: on_failure

artifacts:expire_in

Use expire_in to specify how long artifacts are active before they
expire and are deleted.
The expiration time period begins when the artifact is uploaded and
stored on GitLab. If the expiry time is not defined, it defaults to the
instance wide setting
(30 days by default).
To override the expiration date and protect artifacts from being automatically deleted:

Use the Keep button on the job page.
Set the value of expire_in to never. Available
in GitLab 13.3 and later.

After their expiry, artifacts are deleted hourly by default (via a cron job),
and are not accessible anymore.
The value of expire_in is an elapsed time in seconds, unless a unit is
provided. Examples of valid values:

'42'
42 seconds
3 mins 4 sec
2 hrs 20 min
2h20min
6 mos 1 day
47 yrs 6 mos and 4d
3 weeks and 2 days
never

To expire artifacts 1 week after being uploaded:
job:
 artifacts:
 expire_in: 1 week
The latest artifacts for refs are locked against deletion, and kept regardless of
the expiry time. Introduced in
GitLab 13.0 behind a disabled feature flag, and made the default behavior
in GitLab 13.4.
In GitLab 13.8 and later, you can disable this behavior at the project level in the CI/CD settings. In GitLab 13.9 and later, you can disable this behavior instance-wide.

artifacts:reports

Use artifacts:reports
to collect test reports, code quality reports, and security reports from jobs.
It also exposes these reports in the GitLab UI (merge requests, pipeline views, and security dashboards).
These are the available report types:



Keyword
Description




artifacts:reports:cobertura
The cobertura report collects Cobertura coverage XML files.


artifacts:reports:codequality
The codequality report collects Code Quality issues.



artifacts:reports:container_scanning (ULTIMATE)

The container_scanning report collects Container Scanning vulnerabilities.



artifacts:reports:dast (ULTIMATE)

The dast report collects Dynamic Application Security Testing vulnerabilities.



artifacts:reports:dependency_scanning (ULTIMATE)

The dependency_scanning report collects Dependency Scanning vulnerabilities.


artifacts:reports:dotenv
The dotenv report collects a set of environment variables.


artifacts:reports:junit
The junit report collects JUnit XML files.



artifacts:reports:license_management (ULTIMATE)

The license_management report collects Licenses (removed from GitLab 13.0).



artifacts:reports:license_scanning (ULTIMATE)

The license_scanning report collects Licenses.



artifacts:reports:load_performance (PREMIUM)

The load_performance report collects load performance metrics.



artifacts:reports:metrics (PREMIUM)

The metrics report collects Metrics.



artifacts:reports:performance (PREMIUM)

The performance report collects Browser Performance metrics.


artifacts:reports:sast
The sast report collects Static Application Security Testing vulnerabilities.


artifacts:reports:terraform
The terraform report collects Terraform tfplan.json files.




dependencies

By default, all artifacts from previous stages
are passed to each job. However, you can use the dependencies keyword to
define a limited list of jobs to fetch artifacts from. You can also set a job to download no artifacts at all.
To use this feature, define dependencies in context of the job and pass
a list of all previous jobs the artifacts should be downloaded from.
You can define jobs from stages that were executed before the current one.
An error occurs if you define jobs from the current or an upcoming stage.
To prevent a job from downloading artifacts, define an empty array.
When you use dependencies, the status of the previous job is not considered.
If a job fails or it's a manual job that isn't triggered, no error occurs.
The following example defines two jobs with artifacts: build:osx and
build:linux. When the test:osx is executed, the artifacts from build:osx
are downloaded and extracted in the context of the build. The same happens
for test:linux and artifacts from build:linux.
The job deploy downloads artifacts from all previous jobs because of
the stage precedence:
build:osx:
 stage: build
 script: make build:osx
 artifacts:
 paths:
 - binaries/

build:linux:
 stage: build
 script: make build:linux
 artifacts:
 paths:
 - binaries/

test:osx:
 stage: test
 script: make test:osx
 dependencies:
 - build:osx

test:linux:
 stage: test
 script: make test:linux
 dependencies:
 - build:linux

deploy:
 stage: deploy
 script: make deploy

When a dependent job fails

Introduced in GitLab 10.3.

If the artifacts of the job that is set as a dependency are
expired or
erased, then
the dependent job fails.
You can ask your administrator to
flip this switch
and bring back the old behavior.

coverage

Use coverage to configure how code coverage is extracted from the
job output.
Regular expressions are the only valid kind of value expected here. So, using
surrounding / is mandatory to consistently and explicitly represent
a regular expression string. You must escape special characters if you want to
match them literally.
For example:
job1:
 script: rspec
 coverage: '/Code coverage: \d+\.\d+/'
The coverage is shown in the UI if at least one line in the job output matches the regular expression.
If there is more than one matched line in the job output, the last line is used.
For the matched line, the first occurrence of \d+(\.\d+)? is the code coverage.
Leading zeros are removed.
Coverage output from child pipelines is not recorded
or displayed. Check the related issue
for more details.

retry




Introduced in GitLab 9.5.

Behavior expanded in GitLab 11.5 to control which failures to retry on.


Use retry to configure how many times a job is retried in
case of a failure.
When a job fails, the job is processed again,
until the limit specified by the retry keyword is reached.
If retry is set to 2, and a job succeeds in a second run (first retry), it is not retried.
The retry value must be a positive integer, from 0 to 2
(two retries maximum, three runs in total).
This example retries all failure cases:
test:
 script: rspec
 retry: 2
By default, a job is retried on all failure cases. To have better control
over which failures to retry, retry can be a hash with the following keys:


max: The maximum number of retries.

when: The failure cases to retry.

To retry only runner system failures at maximum two times:
test:
 script: rspec
 retry:
 max: 2
 when: runner_system_failure
If there is another failure, other than a runner system failure, the job
is not retried.
To retry on multiple failure cases, when can also be an array of failures:
test:
 script: rspec
 retry:
 max: 2
 when:
 - runner_system_failure
 - stuck_or_timeout_failure
Possible values for when are:



always: Retry on any failure (default).

unknown_failure: Retry when the failure reason is unknown.

script_failure: Retry when the script failed.

api_failure: Retry on API failure.

stuck_or_timeout_failure: Retry when the job got stuck or timed out.

runner_system_failure: Retry if there is a runner system failure (for example, job setup failed).

missing_dependency_failure: Retry if a dependency is missing.

runner_unsupported: Retry if the runner is unsupported.

stale_schedule: Retry if a delayed job could not be executed.

job_execution_timeout: Retry if the script exceeded the maximum execution time set for the job.

archived_failure: Retry if the job is archived and can't be run.

unmet_prerequisites: Retry if the job failed to complete prerequisite tasks.

scheduler_failure: Retry if the scheduler failed to assign the job to a runner.

data_integrity_failure: Retry if there is a structural integrity problem detected.

You can specify the number of retry attempts for certain stages of job execution using variables.

timeout


Introduced in GitLab 12.3.

Use timeout to configure a timeout for a specific job. For example:
build:
 script: build.sh
 timeout: 3 hours 30 minutes

test:
 script: rspec
 timeout: 3h 30m
The job-level timeout can exceed the
project-level timeout but can't
exceed the runner-specific timeout.

parallel


Introduced in GitLab 11.5.

Use parallel to configure how many instances of a job to run in parallel.
The value can be from 2 to 50.
The parallel keyword creates N instances of the same job that run in parallel.
They are named sequentially from job_name 1/N to job_name N/N:
test:
 script: rspec
 parallel: 5
Every parallel job has a CI_NODE_INDEX and CI_NODE_TOTAL
predefined CI/CD variable set.
Different languages and test suites have different methods to enable parallelization.
For example, use Semaphore Test Boosters
and RSpec to run Ruby tests in parallel:
# 24. Gemfile
source 'https://rubygems.org'

gem 'rspec'
gem 'semaphore_test_boosters'
test:
 parallel: 3
 script:
 - bundle
 - bundle exec rspec_booster --job $CI_NODE_INDEX/$CI_NODE_TOTAL
WARNING:
Test Boosters reports usage statistics to the author.
You can then navigate to the Jobs tab of a new pipeline build and see your RSpec
job split into three separate jobs.

Parallel matrix jobs



Introduced in GitLab 13.3.


Use matrix: to run a job multiple times in parallel in a single pipeline,
but with different variable values for each instance of the job.
There can be from 2 to 50 jobs.
Jobs can only run in parallel if there are multiple runners, or a single runner is
configured to run multiple jobs concurrently.
Every job gets the same CI_NODE_TOTAL CI/CD variable value, and a unique CI_NODE_INDEX value.
deploystacks:
 stage: deploy
 script:
 - bin/deploy
 parallel:
 matrix:
 - PROVIDER: aws
 STACK:
 - monitoring
 - app1
 - app2
 - PROVIDER: ovh
 STACK: [monitoring, backup, app]
 - PROVIDER: [gcp, vultr]
 STACK: [data, processing]
This example generates 10 parallel deploystacks jobs, each with different values
for PROVIDER and STACK:
deploystacks: [aws, monitoring]
deploystacks: [aws, app1]
deploystacks: [aws, app2]
deploystacks: [ovh, monitoring]
deploystacks: [ovh, backup]
deploystacks: [ovh, app]
deploystacks: [gcp, data]
deploystacks: [gcp, processing]
deploystacks: [vultr, data]
deploystacks: [vultr, processing]
The job naming style was improved in GitLab 13.4.

One-dimensional matrix jobs

Introduced in GitLab 13.5.

You can also have one-dimensional matrices with a single job:
deploystacks:
 stage: deploy
 script:
 - bin/deploy
 parallel:
 matrix:
 - PROVIDER: [aws, ovh, gcp, vultr]

trigger




Introduced in GitLab Premium 11.8.

Moved to GitLab Free in 12.8.


Use trigger to define a downstream pipeline trigger. When GitLab starts a trigger job,
a downstream pipeline is created.
Jobs with trigger can only use a limited set of keywords.
For example, you can't run commands with script, before_script,
or after_script.
You can use this keyword to create two different types of downstream pipelines:

Multi-project pipelines
Child pipelines

In GitLab 13.2 and later, you can
view which job triggered a downstream pipeline. In the pipeline graph,
hover over the downstream pipeline job.
In GitLab 13.5 and later, you
can use when:manual in the same job as trigger. In GitLab 13.4 and
earlier, using them together causes the error jobs:#{job-name} when should be on_success, on_failure or always.
You cannot start manual trigger jobs with the API.

Basic trigger syntax for multi-project pipelines
You can configure a downstream trigger by using the trigger keyword
with a full path to a downstream project:
rspec:
 stage: test
 script: bundle exec rspec

staging:
 stage: deploy
 trigger: my/deployment

Complex trigger syntax for multi-project pipelines
You can configure a branch name that GitLab uses to create
a downstream pipeline with:
rspec:
 stage: test
 script: bundle exec rspec

staging:
 stage: deploy
 trigger:
 project: my/deployment
 branch: stable
To mirror the status from a triggered pipeline:
trigger_job:
 trigger:
 project: my/project
 strategy: depend
To mirror the status from an upstream pipeline:
upstream_bridge:
 stage: test
 needs:
 pipeline: other/project

trigger syntax for child pipeline

Introduced in GitLab 12.7.

To create a child pipeline, specify the path to the
YAML file that contains the configuration of the child pipeline:
trigger_job:
 trigger:
 include: path/to/child-pipeline.yml
Similar to multi-project pipelines,
it's possible to mirror the status from a triggered pipeline:
trigger_job:
 trigger:
 include:
 - local: path/to/child-pipeline.yml
 strategy: depend

Trigger child pipeline with generated configuration file

Introduced in GitLab 12.9.

You can also trigger a child pipeline from a dynamically generated configuration file:
generate-config:
 stage: build
 script: generate-ci-config > generated-config.yml
 artifacts:
 paths:
 - generated-config.yml

child-pipeline:
 stage: test
 trigger:
 include:
 - artifact: generated-config.yml
 job: generate-config
The generated-config.yml is extracted from the artifacts and used as the configuration
for triggering the child pipeline.

Trigger child pipeline with files from another project

Introduced in GitLab 13.5.

To trigger child pipelines with files from another private project under the same
GitLab instance, use include:file:
child-pipeline:
 trigger:
 include:
 - project: 'my-group/my-pipeline-library'
 ref: 'master'
 file: '/path/to/child-pipeline.yml'

Linking pipelines with trigger:strategy

By default, the trigger job completes with the success status
as soon as the downstream pipeline is created.
To force the trigger job to wait for the downstream (multi-project or child) pipeline to complete, use
strategy: depend. This setting makes the trigger job wait with a "running" status until the triggered
pipeline completes. At that point, the trigger job completes and displays the same status as
the downstream job.
trigger_job:
 trigger:
 include: path/to/child-pipeline.yml
 strategy: depend
This setting can help keep your pipeline execution linear. In the example above, jobs from
subsequent stages wait for the triggered pipeline to successfully complete before
starting, which reduces parallelization.

Trigger a pipeline by API call
To force a rebuild of a specific branch, tag, or commit, you can use an API call
with a trigger token.
The trigger token is different than the trigger keyword.
Read more in the triggers documentation.

interruptible


Introduced in GitLab 12.3.

Use interruptible to indicate that a running job should be canceled if made redundant by a newer pipeline run.
Defaults to false (uninterruptible). Jobs that have not started yet (pending) are considered interruptible
and safe to be cancelled.
This value is used only if the automatic cancellation of redundant pipelines feature
is enabled.
When enabled, a pipeline is immediately canceled when a new pipeline starts on the same branch if either of the following is true:

All jobs in the pipeline are set as interruptible.
Any uninterruptible jobs have not started yet.

Set jobs as interruptible that can be safely canceled once started (for instance, a build job).
For example:
stages:
 - stage1
 - stage2
 - stage3

step-1:
 stage: stage1
 script:
 - echo "Can be canceled."
 interruptible: true

step-2:
 stage: stage2
 script:
 - echo "Can not be canceled."

step-3:
 stage: stage3
 script:
 - echo "Because step-2 can not be canceled, this step can never be canceled, even though it's set as interruptible."
 interruptible: true
In the example above, a new pipeline run causes an existing running pipeline to be:

Canceled, if only step-1 is running or pending.
Not canceled, once step-2 starts running.

When an uninterruptible job is running, the pipeline cannot be canceled, regardless of the final job's state.

resource_group


Introduced in GitLab 12.7.

Sometimes running multiple jobs or pipelines at the same time in an environment
can lead to errors during the deployment.
To avoid these errors, use the resource_group attribute to make sure that
the runner doesn't run certain jobs simultaneously. Resource groups behave similar
to semaphores in other programming languages.
When the resource_group keyword is defined for a job in the .gitlab-ci.yml file,
job executions are mutually exclusive across different pipelines for the same project.
If multiple jobs belonging to the same resource group are enqueued simultaneously,
only one of the jobs is picked by the runner. The other jobs wait until the
resource_group is free.
For example:
deploy-to-production:
 script: deploy
 resource_group: production
In this case, two deploy-to-production jobs in two separate pipelines can never run at the same time. As a result,
you can ensure that concurrent deployments never happen to the production environment.
You can define multiple resource groups per environment. For example,
when deploying to physical devices, you may have multiple physical devices. Each device
can be deployed to, but there can be only one deployment per device at any given time.
The resource_group value can only contain letters, digits, -, _, /, $, {, }, ., and spaces.
It can't start or end with /.
For more information, see Deployments Safety.

Pipeline-level concurrency control with Cross-Project/Parent-Child pipelines

Introduced in GitLab 13.9.

You can define resource_group for downstream pipelines that are sensitive to concurrent
executions. The trigger keyword can trigger downstream pipelines. The
resource_group keyword can co-exist with it. This is useful to control the
concurrency for deployment pipelines, while running non-sensitive jobs concurrently.
This example has two pipeline configurations in a project. When a pipeline starts running,
non-sensitive jobs are executed first and aren't affected by concurrent executions in other
pipelines. However, GitLab ensures that there are no other deployment pipelines running before
triggering a deployment (child) pipeline. If other deployment pipelines are running, GitLab waits
until those pipelines finish before running another one.
# 25. .gitlab-ci.yml (parent pipeline)

build:
 stage: build
 script: echo "Building..."

test:
 stage: test
 script: echo "Testing..."

deploy:
 stage: deploy
 trigger:
 include: deploy.gitlab-ci.yml
 strategy: depend
 resource_group: AWS-production
# 26. deploy.gitlab-ci.yml (child pipeline)

stages:
 - provision
 - deploy

provision:
 stage: provision
 script: echo "Provisioning..."

deployment:
 stage: deploy
 script: echo "Deploying..."
Note that you must define strategy: depend
with the trigger keyword. This ensures that the lock isn't released until the downstream pipeline
finishes.

release


Introduced in GitLab 13.2.

release indicates that the job creates a Release.
These keywords are supported:

tag_name
description

name (optional)

ref (optional)

milestones (optional)

released_at (optional)

The Release is created only if the job processes without error. If the Rails API
returns an error during Release creation, the release job fails.

release-cli Docker image
The Docker image to use for the release-cli must be specified, using the following directive:
image: registry.gitlab.com/gitlab-org/release-cli:latest

Script
All jobs except trigger jobs must have the script keyword. A release
job can use the output from script commands, but you can use a placeholder script if
the script is not needed:
script:
 - echo 'release job'
An issue exists to remove this requirement in an upcoming version of GitLab.
A pipeline can have multiple release jobs, for example:
ios-release:
 script:
 - echo 'iOS release job'
 release:
 tag_name: v1.0.0-ios
 description: 'iOS release v1.0.0'

android-release:
 script:
 - echo 'Android release job'
 release:
 tag_name: v1.0.0-android
 description: 'Android release v1.0.0'

release:tag_name

The tag_name must be specified. It can refer to an existing Git tag or can be specified by the user.
When the specified tag doesn't exist in the repository, a new tag is created from the associated SHA of the pipeline.
For example, when creating a Release from a Git tag:
job:
 release:
 tag_name: $CI_COMMIT_TAG
 description: 'Release description'
It is also possible to create any unique tag, in which case only: tags is not mandatory.
A semantic versioning example:
job:
 release:
 tag_name: ${MAJOR}_${MINOR}_${REVISION}
 description: 'Release description'

The Release is created only if the job's main script succeeds.
If the Release already exists, it is not updated and the job with the release keyword fails.
The release section executes after the script tag and before the after_script.


release:name

The Release name. If omitted, it is populated with the value of release: tag_name.

release:description

Specifies the long description of the Release. You can also specify a file that contains the
description.

Read description from a file

Introduced in GitLab 13.7.

You can specify a file in $CI_PROJECT_DIR that contains the description. The file must be relative
to the project directory ($CI_PROJECT_DIR), and if the file is a symbolic link it can't reside
outside of $CI_PROJECT_DIR. The ./path/to/file and filename can't contain spaces.
job:
 release:
 tag_name: ${MAJOR}_${MINOR}_${REVISION}
 description: './path/to/CHANGELOG.md'

release:ref

If the release: tag_name doesn’t exist yet, the release is created from ref.
ref can be a commit SHA, another tag name, or a branch name.

release:milestones

The title of each milestone the release is associated with.

release:released_at

The date and time when the release is ready. Defaults to the current date and time if not
defined. Should be enclosed in quotes and expressed in ISO 8601 format.
released_at: '2021-03-15T08:00:00Z'

Complete example for release

Combining the individual examples given above for release results in the following
code snippets. There are two options, depending on how you generate the
tags. You can't use these options together, so choose one:


To create a release when you push a Git tag, or when you add a Git tag
in the UI by going to Repository > Tags:
release_job:
 stage: release
 image: registry.gitlab.com/gitlab-org/release-cli:latest
 rules:
 - if: $CI_COMMIT_TAG # Run this job when a tag is created manually
 script:
 - echo 'running release_job'
 release:
 name: 'Release $CI_COMMIT_TAG'
 description: 'Created using the release-cli $EXTRA_DESCRIPTION' # $EXTRA_DESCRIPTION must be defined
 tag_name: '$CI_COMMIT_TAG' # elsewhere in the pipeline.
 ref: '$CI_COMMIT_TAG'
 milestones:
 - 'm1'
 - 'm2'
 - 'm3'
 released_at: '2020-07-15T08:00:00Z' # Optional, is auto generated if not defined, or can use a variable.


To create a release automatically when commits are pushed or merged to the default branch,
using a new Git tag that is defined with variables:
NOTE:
Environment variables set in before_script or script are not available for expanding
in the same job. Read more about
potentially making variables available for expanding.
prepare_job:
 stage: prepare # This stage must run before the release stage
 rules:
 - if: $CI_COMMIT_TAG
 when: never # Do not run this job when a tag is created manually
 - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH # Run this job when commits are pushed or merged to the default branch
 script:
 - echo "EXTRA_DESCRIPTION=some message" >> variables.env # Generate the EXTRA_DESCRIPTION and TAG environment variables
 - echo "TAG=v$(cat VERSION)" >> variables.env # and append to the variables.env file
 artifacts:
 reports:
 dotenv: variables.env # Use artifacts:reports:dotenv to expose the variables to other jobs

release_job:
 stage: release
 image: registry.gitlab.com/gitlab-org/release-cli:latest
 needs:
 - job: prepare_job
 artifacts: true
 rules:
 - if: $CI_COMMIT_TAG
 when: never # Do not run this job when a tag is created manually
 - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH # Run this job when commits are pushed or merged to the default branch
 script:
 - echo 'running release_job for $TAG'
 release:
 name: 'Release $TAG'
 description: 'Created using the release-cli $EXTRA_DESCRIPTION' # $EXTRA_DESCRIPTION and the $TAG
 tag_name: '$TAG' # variables must be defined elsewhere
 ref: '$CI_COMMIT_SHA' # in the pipeline. For example, in the
 milestones: # prepare_job
 - 'm1'
 - 'm2'
 - 'm3'
 released_at: '2020-07-15T08:00:00Z' # Optional, is auto generated if not defined, or can use a variable.



Release assets as Generic packages
You can use Generic packages to host your release assets.
For a complete example, see the Release assets as Generic packages
project.

release-cli command line
The entries under the release node are transformed into a bash command line and sent
to the Docker container, which contains the release-cli.
You can also call the release-cli directly from a script entry.
For example, using the YAML described above:
release-cli create --name "Release $CI_COMMIT_SHA" --description "Created using the release-cli $EXTRA_DESCRIPTION" --tag-name "v${MAJOR}.${MINOR}.${REVISION}" --ref "$CI_COMMIT_SHA" --released-at "2020-07-15T08:00:00Z" --milestone "m1" --milestone "m2" --milestone "m3"

secrets


Introduced in GitLab 13.4.

secrets indicates the CI/CD Secrets this job needs. It should be a hash,
and the keys should be the names of the variables that are made available to the job.
The value of each secret is saved in a temporary file. This file's path is stored in these
variables.

secrets:vault (PREMIUM)


Introduced in GitLab 13.4.

vault keyword specifies secrets provided by Hashicorp's Vault.
This syntax has multiple forms. The shortest form assumes the use of the
KV-V2 secrets engine,
mounted at the default path kv-v2. The last part of the secret's path is the
field to fetch the value for:
job:
 secrets:
 DATABASE_PASSWORD:
 vault: production/db/password # translates to secret `kv-v2/data/production/db`, field `password`
You can specify a custom secrets engine path by adding a suffix starting with @:
job:
 secrets:
 DATABASE_PASSWORD:
 vault: production/db/password@ops # translates to secret `ops/data/production/db`, field `password`
In the detailed form of the syntax, you can specify all details explicitly:
job:
 secrets:
 DATABASE_PASSWORD: # translates to secret `ops/data/production/db`, field `password`
 vault:
 engine:
 name: kv-v2
 path: ops
 path: production/db
 field: password

pages

pages is a special job that uploads static content to GitLab that
is then published as a website. It has a special syntax, so the two
requirements below must be met:

Any static content must be placed under a public/ directory.

artifacts with a path to the public/ directory must be defined.

The example below moves all files from the root of the project to the
public/ directory. The .public workaround is so cp does not also copy
public/ to itself in an infinite loop:
pages:
 stage: deploy
 script:
 - mkdir .public
 - cp -r * .public
 - mv .public public
 artifacts:
 paths:
 - public
 only:
 - master
Read more on GitLab Pages user documentation.

variables


Introduced in GitLab Runner v0.5.0.

CI/CD variables are configurable values that are passed to jobs.
They can be set globally and per-job.
There are two types of variables.


Custom variables:
You can define their values in the .gitlab-ci.yml file, in the GitLab UI,
or by using the API. You can also input variables in the GitLab UI when
running a pipeline manually.

Predefined variables:
These values are set by the runner itself.
One example is CI_COMMIT_REF_NAME, which is the branch or tag the project is built for.

After you define a variable, you can use it in all executed commands and scripts.
Variables are meant for non-sensitive project configuration, for example:
variables:
 DEPLOY_SITE: "https://example.com/"

deploy_job:
 stage: deploy
 script:
 - deploy-script --url $DEPLOY_SITE --path "/"

deploy_review_job:
 stage: deploy
 variables:
 REVIEW_PATH: "/review"
 script:
 - deploy-review-script --url $DEPLOY_SITE --path $REVIEW_PATH
You can use only integers and strings for the variable's name and value.
If you define a variable at the top level of the gitlab-ci.yml file, it is global,
meaning it applies to all jobs. If you define a variable in a job, it's available
to that job only.
If a variable of the same name is defined globally and for a specific job, the
job-specific variable overrides the global variable.
All YAML-defined variables are also set to any linked
Docker service containers.
You can use YAML anchors for variables.

Prefill variables in manual pipelines

Introduced in GitLab 13.7.

You can use the value and description keywords to define variables that are prefilled
when running a pipeline manually:
variables:
 DEPLOY_ENVIRONMENT:
 value: "staging" # Deploy to staging by default
 description: "The deployment target. Change this variable to 'canary' or 'production' if needed."

Configure runner behavior with variables
You can use CI/CD variables to configure runner Git behavior:

GIT_STRATEGY
GIT_SUBMODULE_STRATEGY
GIT_CHECKOUT
GIT_CLEAN_FLAGS
GIT_FETCH_EXTRA_FLAGS

GIT_DEPTH (shallow cloning)

GIT_CLONE_PATH (custom build directories)

TRANSFER_METER_FREQUENCY (artifact/cache meter update frequency)

ARTIFACT_COMPRESSION_LEVEL (artifact archiver compression level)

CACHE_COMPRESSION_LEVEL (cache archiver compression level)

You can also use variables to configure how many times a runner
attempts certain stages of job execution.

Special YAML features
It's possible to use special YAML features like anchors (&), aliases (*)
and map merging (<<). Use these features to reduce the complexity
of the code in the .gitlab-ci.yml file.
Read more about the various YAML features.
In most cases, the extends keyword is more user friendly and should
be used over these special YAML features.
You can use YAML anchors to merge YAML arrays.

Anchors
YAML has a feature called 'anchors' that you can use to duplicate
content across your document.
Use anchors to duplicate or inherit properties. Use anchors with hidden jobs
to provide templates for your jobs. When there are duplicate keys, GitLab
performs a reverse deep merge based on the keys.
You can't use YAML anchors across multiple files when leveraging the include
feature. Anchors are only valid in the file they were defined in. Instead
of using YAML anchors, you can use the extends keyword.
The following example uses anchors and map merging. It creates two jobs,
test1 and test2, that inherit the .job_template configuration, each
with their own custom script defined:
.job_template: &job_configuration # Hidden yaml configuration that defines an anchor named 'job_configuration'
 image: ruby:2.6
 services:
 - postgres
 - redis

test1:
 <<: *job_configuration # Merge the contents of the 'job_configuration' alias
 script:
 - test1 project

test2:
 <<: *job_configuration # Merge the contents of the 'job_configuration' alias
 script:
 - test2 project
& sets up the name of the anchor (job_configuration), << means "merge the
given hash into the current one", and * includes the named anchor
(job_configuration again). The expanded version of the example above is:
.job_template:
 image: ruby:2.6
 services:
 - postgres
 - redis

test1:
 image: ruby:2.6
 services:
 - postgres
 - redis
 script:
 - test1 project

test2:
 image: ruby:2.6
 services:
 - postgres
 - redis
 script:
 - test2 project
You can use anchors to define two sets of services. For example, test:postgres
and test:mysql share the script defined in .job_template, but use different
services, defined in .postgres_services and .mysql_services:
.job_template: &job_configuration
 script:
 - test project
 tags:
 - dev

.postgres_services:
 services: &postgres_configuration
 - postgres
 - ruby

.mysql_services:
 services: &mysql_configuration
 - mysql
 - ruby

test:postgres:
 <<: *job_configuration
 services: *postgres_configuration
 tags:
 - postgres

test:mysql:
 <<: *job_configuration
 services: *mysql_configuration
The expanded version is:
.job_template:
 script:
 - test project
 tags:
 - dev

.postgres_services:
 services:
 - postgres
 - ruby

.mysql_services:
 services:
 - mysql
 - ruby

test:postgres:
 script:
 - test project
 services:
 - postgres
 - ruby
 tags:
 - postgres

test:mysql:
 script:
 - test project
 services:
 - mysql
 - ruby
 tags:
 - dev
You can see that the hidden jobs are conveniently used as templates, and
tags: [postgres] overwrites tags: [dev].

YAML anchors for scripts

Introduced in GitLab 12.5.

You can use YAML anchors with script, before_script,
and after_script to use predefined commands in multiple jobs:
.some-script-before: &some-script-before
 - echo "Execute this script first"

.some-script: &some-script
 - echo "Execute this script second"
 - echo "Execute this script too"

.some-script-after: &some-script-after
 - echo "Execute this script last"

job1:
 before_script:
 - *some-script-before
 script:
 - *some-script
 - echo "Execute something, for this job only"
 after_script:
 - *some-script-after

job2:
 script:
 - *some-script-before
 - *some-script
 - echo "Execute something else, for this job only"
 - *some-script-after

YAML anchors for variables
Use YAML anchors with variables to repeat assignment
of variables across multiple jobs. You can also use YAML anchors when a job
requires a specific variables block that would otherwise override the global variables.
In the example below, we override the GIT_STRATEGY variable without affecting
the use of the SAMPLE_VARIABLE variable:
# 27. global variables
variables: &global-variables
 SAMPLE_VARIABLE: sample_variable_value
 ANOTHER_SAMPLE_VARIABLE: another_sample_variable_value

# 28. a job that must set the GIT_STRATEGY variable, yet depend on global variables
job_no_git_strategy:
 stage: cleanup
 variables:
 <<: *global-variables
 GIT_STRATEGY: none
 script: echo $SAMPLE_VARIABLE

Hide jobs
If you want to temporarily 'disable' a job, rather than commenting out all the
lines where the job is defined:
# 29. hidden_job:
# 30. script:
# 31. run test
Instead, you can start its name with a dot (.) and it is not processed by
GitLab CI/CD. In the following example, .hidden_job is ignored:
.hidden_job:
 script:
 - run test
Use this feature to ignore jobs, or use the
special YAML features and transform the hidden jobs
into templates.

!reference tags



Introduced in GitLab 13.9.


Use the !reference custom YAML tag to select keyword configuration from other job
sections and reuse it in the current section. Unlike YAML anchors, you can
use !reference tags to reuse configuration from included configuration
files as well.
In this example, a script and an after_script from two different locations are
reused in the test job:


setup.yml:
.setup:
 script:
 - echo creating environment


.gitlab-ci.yml:
include:
 - local: setup.yml

.teardown:
 after_script:
 - echo deleting environment

test:
 script:
 - !reference [.setup, script]
 - echo running my own command
 after_script:
 - !reference [.teardown, after_script]


In this example, test-vars-1 reuses the all the variables in .vars, while test-vars-2
selects a specific variable and reuses it as a new MY_VAR variable.
.vars:
 variables:
 URL: "http://my-url.internal"
 IMPORTANT_VAR: "the details"

test-vars-1:
 variables: !reference [.vars, variables]
 script:
 - printenv

test-vars-2:
 variables:
 MY_VAR: !reference [.vars, variables, IMPORTANT_VAR]
 script:
 - printenv
You can't reuse a section that already includes a !reference tag. Only one level
of nesting is supported.

Skip Pipeline
To push a commit without triggering a pipeline, add [ci skip] or [skip ci], using any
capitalization, to your commit message.
Alternatively, if you are using Git 2.10 or later, use the ci.skip Git push option.
The ci.skip push option does not skip merge request
pipelines.

Processing Git pushes
GitLab creates at most four branch and tag pipelines when
pushing multiple changes in a single git push invocation.
This limitation does not affect any of the updated merge request pipelines.
All updated merge requests have a pipeline created when using
pipelines for merge requests.

Deprecated keywords
The following keywords are deprecated.

Globally-defined types

WARNING:
types is deprecated, and could be removed in a future release.
Use stages instead.

Job-defined type

WARNING:
type is deprecated, and could be removed in one of the future releases.
Use stage instead.

Globally-defined image, services, cache, before_script, after_script

Defining image, services, cache, before_script, and
after_script globally is deprecated. Support could be removed
from a future release.
Use default: instead. For example:
default:
 image: ruby:2.5
 services:
 - docker:dind
 cache:
 paths: [vendor/]
 before_script:
 - bundle install --path vendor/
 after_script:
 - rm -rf tmp/

- 内容

  # This file is a template, and might need editing before it works on your project.
  # Official framework image. Look for the different tagged releases at:
  # https://hub.docker.com/r/library/node/tags/
  image: node:lts-alpine3.13
  
  # This folder is cached between builds
  # http://docs.gitlab.com/ee/ci/yaml/README.html#cache
  cache:
    key: $CI_COMMIT_REF_SLUG
    paths:
      - .npm/
  
  before_script:
    - node --version
    - npm --version
    - npm ci --cache .npm --prefer-offline --registry https://registry.npm.taobao.org
  
  build:
    only:
      changes:
        - src/**/*
    script:
      - echo "检查代码是否符合规范："
      - npx eslint ./src/**/*.{vue,js}
      - npx stylelint ./src/**/*.vue
      - echo "检查打包是否报错："
      - npm run build
      - test -d dist
      - test -r dist/index.html
  
  
  
### 31.1.1. vue增加代码检查配置

-   .stylelintrc.json  0 → 100644
 
{
  "extends": "stylelint-config-standard"
}
\ No newline at end of file

## 31.2. 算法：JS-ALGORITHM

### 31.2.1. 定义：一系列解决问题的清晰指令，就像食谱

### 31.2.2. 链表

- 遍历链表、删除链表节点

### 31.2.3. 树、图

- 深度 / 广度优先遍历

### 31.2.4. 数组

- 排序

	- 冒泡

	- 选择

	- 插入

	- 归并

	- 快速

- 顺序、二分搜索

### 31.2.5. [刷题](https://leetcode-cn.com/problems/two-sum/solution/jie-suan-fa-1-liang-shu-zhi-he-by-guanpengchn/)

- 时间复杂度

	- log函数，2的多少次方等于n
![image](assets/0b019ac82d73cc321ef2d9a36310d8272b8eb7f4656d30ceac8d4cb839fa37a9.png)

- 空间复杂度

	- 声明的变量

		- 数组中放入了n个元素，占用了n个存储单元
![image](assets/ca0a7b790e4534d67c1cab452d0f724c2048e247978318013462272dd0cd61f4.png)

## 31.3. 数据结构

### 31.3.1. 定义：计算机存储、组织数据的方式，就像锅碗瓢盆

### 31.3.2. 数组

### 31.3.3. 栈

- 后进先出的数据结构

	- 图示：炉子的中蜂窝煤，后进先出，push和pop，进栈和出栈。
![image](assets/10286bf50c7f9518043d1af74d8bd1293a811a5b77dfcaa502ffc31c8b7b647d.png)

- stack

	- arr-push，pop
![image](assets/89dad2d58fdd607d669c95d776f377dbe9be3c5b9525b45ef4d1769dd528d535.png)

- 使用场景

	- 后进先出的场景

		- 十进制转二进制

			-  
![image](assets/02c8d0ea7578c9cd99a55d86d2fadaf29ab9b979439544100d369010b346fbcc.png)

		- 判断字符串的括号是否有效

			- 左括号就入栈，右括号出栈，栈空了，就是合法的。
![image](assets/689a630fb25fdc9c535325046b343b94d4a3b4988ca9f04c61bc7d8cde4b7ae4.png)

				- 思路
![image](assets/204805254071973e4709b6dbf916de2802fa28ca944070b9e52373a1b775ed15.png)

				- 方法
![image](assets/e1c930502a2f8d1c41001dc35dc5b52df72db3de4314467ec8a26a474884f2a8.png)

		- 函数调用堆栈

			-  
![image](assets/b35e5e6e22672e311b080c80a2e808fb481ce4a21bf6d1eba45c631bfa9ee43b.png)

### 31.3.4. 队列

### 31.3.5. 链表

### 31.3.6. 图

### 31.3.7. 树

### 31.3.8. 堆

### 31.3.9. 散列表

### 31.3.10. 栈、队列、链表

- 有序的，连成一串，有前后顺序的

	- 羊肉串

### 31.3.11. 集合、字典

- 无序

	- 像一碗饭

### 31.3.12. 树、堆、图

- 有一定的连接关系

	- 树：组织架构、书籍目录

	- 图：道路、航班、朋友圈

	- 堆：特殊的树

- 高级

## 31.4. mgj

### 31.4.1. jquery

### 31.4.2. 原生js

### 31.4.3. 个人自己维护的框架

- 精髓和架子提炼出来

## 31.5. oseasy

### 31.5.1. vdi

- 服务器查看log

  tailf /etc/thor/log/thorconsole.log 看log
  
  
  ystemctl restart openstack-nova-compute 重启服务
  
  
	- tailf /etc/thor/log/thorconsole.log
tail -f -n 10 /etc/thor/log/thorconsole.log
![image](assets/39db04436ae9b502828679bb650eb5b0caa8fc05bf4ce0ca51bcf31f09f9a7da.svg)

	- systemctl restart thor-supervisor

	- du -sh *

- // 开发时 admin/views 重定向到 views目录的结果，保证开发时，本地代码可以跑起来。
        app.get(/^\/admin\/views\//, function (req, resp) {
            resp.redirect(req.url.replace("/admin/", "/"));
        });

- ngconsole

  # 常用命令
  
  ## 打增量包
  
  用途：需要打补丁包时，一般仅仅打增量包就够了，打全量包有百害而无一利。
  
  原理：打增量包就是把变动的文件集合起来，因此核心在于如何获取变更的文件列表。在 git 里面，获取文件变更列表可以通过两种方式完成，这取决于你的实际情况。
  
  ### build 后提交前获取变更列表
  
  此时，变更的文件列表可以使用 `git status` 命令查看到，因此获取文件列表很简单：
  
  ```bash
  git status -s
  ```
  
  ### build 后提交后获取变更列表
  
  这种方式更常见，通用性也更强，因为可能打了不止一次包，如何找到从开始到现在的所有的变更文件呢？使用 `git diff` 命令
  
  ```bash
  # 假设首次提交的 COMMIT ID 为 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc
  # 则从 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc 到分支当前状态，所有的文件变更列表为：
  git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status
  ```
  
  这条命令获取指定的 git 提交范围（revision range），并计算差异，最终打印变更类型和文件名（--name-status）
  
  变更的文件列表一般长这样：
  
  ```plain
  M built/forget.map
  M built/index.js
  M built/index.map
  M built/init.map
  M built/spice.js
  M built/spice.map
  M built/split.map
  M built/ssh.map
  M built/weblogin.map
  M resources/arm/lang.json
  M resources/en/lang.json
  M resources/vpc/lang.json
  M resources/zh-cn/lang.json
  M resources/zh-tw/lang.json
  ```
  
  可以看到，变更列表由两列组成，第一列就是变更类型，第二列是文件路径，文件列表就是第二列的全部内容。在 git bash 里面可以使用 awk 命令获取这个列表：
  
  ```bash
  git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status | awk -e '{print $2}'
  ```
  
  输出：
  
  ```plain
  built/forget.map
  built/index.js
  built/index.map
  built/init.map
  built/spice.js
  built/spice.map
  built/split.map
  built/ssh.map
  built/weblogin.map
  resources/arm/lang.json
  resources/en/lang.json
  resources/vpc/lang.json
  resources/zh-cn/lang.json
  resources/zh-tw/lang.json
  ```
  
  之后将文件列表传递给 `git archive` 命令即可完成打包压缩：
  
  ```bash
  git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status | awk -e '{print $2}' | xargs git archive -o update.zip HEAD
  ```
  
  某些情况，`git archive` 可能仅仅打了一部分文件，这时可以使用 bash 数组来存储文件列表，然后打包：
  
  ```bash
  FILES=($(git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status | awk -e '{print $2}'))
  # 此处为 bash 数组特定用法，不可修改半个字符
  git archive -o update.zip HEAD "${FILES[@]}"
  ```
  
  ## 打包翻译资源给产品经理
  
  用途：需要做繁体、英文版时，产品经理会要求前端提供目前的翻译资源，然后交由国际部进行翻译，翻译完成后，由前端整合进代码里面
  
  命令（需要提前 build）
  
  ```bash
  cd ngconsole
  mkdir -p out/{en,zh-cn,zh-tw,vpc}
  for dir in en zh-cn zh-tw vpc; do
   for file in code.json lang.json; do
   # 也可以使用 node 格式化
   # node -e 'process.stdout.write(JSON.stringify(fs.readFileSync(process.argv[1], "utf-8"), null, 4))' resources/$dir/$file > out/$dir/$file
   jq -r '.' resources/$dir/$file > out/$dir/$file
   done
  done
  cd out
  zip -r ../语言包.zip .
  cd ..
  rm -rf out
  ```
  
  提交资源给产品经理时，将如下说明一并发送，确保收到的资源被正确的修改。
  
  翻译说明：
  
  1. .json 是一种键值一一对应的纯文本文件，每行的格式为："键": "值"
  2. 翻译时，仅仅翻译值的部分就可以了，如下面绿色部分：
  
   ```json
   {
   "101": "资源池未找到",
   "102": "资源池创建失败",
   "103": "资源池更新失败",
   "104": "资源池销毁失败",
   "105": "创建云PC HA策略名称相同",
   "106": "创建云PC HA策略必须有云PC",
   "分布式存储": "分布式存储",
   "新增分布式存储": "新增分布式存储",
   "修改分布式存储": "修改分布式存储",
   "删除分布式存储": "删除分布式存储",
   "分布式存储名": "分布式存储名",
   }
   ```
  
  3. 以下情况无需翻译：
   * &lt;li&gt; 即 小于号和大于号包裹的区域
   * <https://www.baidu.com> 即 网址无需翻译
   * {{0} } 双大括号直接忽略
   * `&xxxx;` 形如这种格式的都忽略，常见的有 `&nbsp`;
  4. 推荐使用 notepad++ 等支持高亮特性编辑器打开.json文件进行编辑
  
  
	- 跑arm版本的服务器时，需要本地起https服务

		- https://127.0.0.1:8081

		- webpack.devServer.https:true

		- nvm use v8

		- node_modules/spdy-transport/lib/spdy-transport/priority.js 中报错的一行注释掉

	- [input type=number禁止输入小数如何实现](https://www.php.cn/js-tutorial-379946.html)

		- 正则手动替换小数点
$('#number').on('keyup', function () {
    if (!/^\d+$/.test(this.value)) {
         this.value='';
    }
})

	- [awk](https://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html)

		- 统计文件夹下文件占用的字节数（不包括子目录）

			- ls -l |awk 'BEGIN {size=0;} {size=size+$5;} END{print "[end]size is ", size/1024/1024,"M"}' 

		- git diff a8a0456a2f3a2d24e69cd6aa8a5a0ce46845a93d.. --name-status | gawk -e '{print $2}'

			- 从某个提交到现在有多少个文件变更，并输出第二列

		- [git archive](https://www.jianshu.com/p/98fa58073554)

			- git archive --format tar.gz --output "./output.tar.gz" master mydir mydir2  

				- 打包master下的mydir mydir2目录

	- 找到nw进程的路径-从而找到nw资源的名称

		- linux：
ps -eo cmd|grep [n]w|tail -1|awk '{print $2}'

		- macos：
ps -eo command | grep '[n]w' | awk '{print $2}'

	- [jq](https://blog.csdn.net/qq_26502245/article/details/100191694)

		- ibrew install jq

		- cat json.txt | jq '.'

			- 最简单的jq程序是表达式"."，它不改变输入，但可以将其优美地输出，便于阅读和理解。

		- cat json.txt | jq '.[0]'

			- 输出列表中的第一个元素，可以使用[index]

		- cat json.txt | jq '.[0] | {name:.name,city:.address.city}'

			- {
  "name": "站长工具",
  "city": "厦门"
}

		- cat json.txt | jq '.[0] | {name:.name,city:.address.city}'

		- node -e 'process.stdout.write(JSON.stringify(fs.readFileSync(process.argv[1], "utf-8"), null, 4))' resources/$dir/$file > out/$dir/$file

- (id: (\d+),)
id: $2, \n order: $2,

- note 记事 一个便签一条

	- fzf

	- vim

		- c-f 查找 多个关键词 先文件名 后文件内容

	- ranger

		- c-f查找当前文件夹下的文件

- 客户端业务流程图

	- VDI客户端

		- 操作系统

			- 底层：接口服务

				- http请求

			- 客户端程序：c写的

				- nw/webview

					- 资源：new-vdi-client项目，客户端界面

					- spice远程连接界面

					  界面里面就是虚拟机内的操作系统界面
					  
					- flash视频播放界面

					  此界面与虚拟机内的比方界面无缝重合
					  
	- VDI服务器

		- 主动推送服务器虚拟机准备好了

	- flash重定向

		- [flash前端代码](http://172.16.203.254/huangzijie/flash/tree/master)

			- 排查下log，目录：nw_flash/logs/access.log 查看当天的日志

		- [flash插件](http://172.16.203.254/zhangyao/newflashrediredt/tree/master)

			- cs.js

			  前景页面
			  此页面即 src/js/cs.js。
			  
			  当它出于活动状态时，它做了这么几件事情：
			  
			  每隔 1 秒监听一次浏览器窗口位置是否发生了变化，如果变化则发送给背景页面
			  监听浏览器窗口缩放事件，缩放时发送消息给背景页面
			  监听浏览器页面可见性事件，变化时发送消息给背景页面，临时停止此 tab 页的播放
			  
			  
			- core.js

			  背景页面
			  背景页面的概念参考百度文档。
			  
			  背景页面是常驻内存的，它需要为白名单网址提供重定向并保存当前重定向信息。
			  
			  所有的重定向逻辑都在 src/js/core.js 里面，它做了这样几件事：
			  
			  监听来自页面的 viewport-change 事件，并发送给客户端 flash 服务
			  阻止白名单网站的 .swf 文件请求，这样是为了禁用 flash 播放器
			  监听浏览器激活 tab 页变化事件
			  监听浏览器 tab 页更新事件
			  监听浏览器 tab 页关闭事件
			  重定向的核心逻辑就在 tab 页的 3 个事件里面，总的来说就这么几条：
			  
			  打开的时候开始播放
			  关闭的时候停止播放
			  切换 tab 页的时候，前一个 tab 页临时停止播放，当前 tab 页开始播放
			  当一个 tab 页在白名单里面时，就会开始播放，播放时插件会将 src/js/cs.js 注入到当前 tab 页，注入的目的是为了捕获浏览器窗口移动或者缩放。
			  
			  
			  
		- nw

		- linux命令

			- 联调客户端常用的命令

			  1. top查看终端资源
			  2.netstat -a查看网络连接
			  3.ctrl+alt+f6切换终端命令行
			  4.alt+f1切换图形界面
			  5.Ctrl+alt+u在终端程序中打开terminal
			  6.ps -ef|grep nw查看nw进程
			  7.ssh -L 127.0.0.1:9222:127.0.0.1:9222 root@ip
			  
			- 遇到的问题

			  macos上面nw不显示地址栏的话，
			  需要在命令行运行nw，右键nw，显示内容，显示内容，然后里面有个content：路径+--url=传递地址参数，地址为：nwjs：/Users/huangzijie/Downloads/nwjs-sdk-v0.44.0-osx-x64/nwjs.app/Contents/MacOS/nwjs --url=https://www.iqiyi.com/v_260uudpmizo.html
			  
	- linux端快捷方式

		- ctrl+alt+f6
alt+f2

	- 客户端可以设置端类型

		- localStorage.client_type=3 设置为安卓端 这样的话就可以使用http请求，从而使用假数据

	- 客户端翻译需要在vue的this上放_:i18n

		- 这样在dom上面才可以进行_("str_key")进行翻译

	- 打增量包

	  常用命令
	  
	  打增量包
	  
	  
	  用途：需要打补丁包时，一般仅仅打增量包就够了，打全量包有百害而无一利。
	  
	  
	  原理：打增量包就是把变动的文件集合起来，因此核心在于如何获取变更的文件列表。在 git 里面，获取文件变更列表可以通过两种方式完成，这取决于你的实际情况。
	  
	  
	  build 后提交前获取变更列表
	  
	  
	  此时，变更的文件列表可以使用 git status 命令查看到，因此获取文件列表很简单：
	  
	  git status -s
	  
	  build 后提交后获取变更列表
	  
	  
	  这种方式更常见，通用性也更强，因为可能打了不止一次包，如何找到从开始到现在的所有的变更文件呢？使用 git diff 命令
	  
	  # 假设首次提交的 COMMIT ID 为 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc
	  # 则从 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc 到分支当前状态，所有的文件变更列表为：
	  git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status
	  
	  这条命令获取指定的 git 提交范围（revision range），并计算差异，最终打印变更类型和文件名（--name-status）
	  
	  
	  变更的文件列表一般长这样：
	  
	  M       built/forget.map
	  M       built/index.js
	  M       built/index.map
	  M       built/init.map
	  M       built/spice.js
	  M       built/spice.map
	  M       built/split.map
	  M       built/ssh.map
	  M       built/weblogin.map
	  M       resources/arm/lang.json
	  M       resources/en/lang.json
	  M       resources/vpc/lang.json
	  M       resources/zh-cn/lang.json
	  M       resources/zh-tw/lang.json
	  
	  可以看到，变更列表由两列组成，第一列就是变更类型，第二列是文件路径，文件列表就是第二列的全部内容。在 git bash 里面可以使用 awk 命令获取这个列表：
	  
	  git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status | awk -e '{print $2}'
	  
	  输出：
	  
	  built/forget.map
	  built/index.js
	  built/index.map
	  built/init.map
	  built/spice.js
	  built/spice.map
	  built/split.map
	  built/ssh.map
	  built/weblogin.map
	  resources/arm/lang.json
	  resources/en/lang.json
	  resources/vpc/lang.json
	  resources/zh-cn/lang.json
	  resources/zh-tw/lang.json
	  
	  之后将文件列表传递给 git archive 命令即可完成打包压缩：
	  
	  git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status | awk -e '{print $2}' | xargs git archive -o update.zip HEAD
	  
	  某些情况，git archive 可能仅仅打了一部分文件，这时可以使用 bash 数组来存储文件列表，然后打包：
	  
	  FILES=($(git diff 3a7bb6d0a7580eaf3f0c3ddc483dc717c66d01cc.. --name-status | awk -e '{print $2}'))
	  # 此处为 bash 数组特定用法，不可修改半个字符
	  git archive -o update.zip HEAD "${FILES[@]}"
	  
	  
- Ubuntu下图形界面与控制台终端之间切换的快捷键

	- 图形界面——>控制台终端：Ctrl+Alt+F1/F2/F3/F4/F5/F6;

控制台终端——>图形界面：Alt+F7 或者Ctrl+Alt+T



在Linux中控制台、终端及Shell命令窗口都是一回事

- [接口文档showdoc](http://192.168.0.161:4999/web/#/9?page_id=109)

- [公司论坛利用js快捷提交](http://college.os-easy.com/newbbs/#/postdetail?id=9205b8d4-b3ba-41c5-9bfc-eb2dab15541c)

  (function(s){let el=document.querySelector("textarea");while(!el.__vue__){el=el.parentElement;}let x=el.__vue__;x.commentTxt=s;x.publishComment()})("拍这张照片的时候脑子都被震懵了！");
  
  let el=document.querySelector("textarea");while(!el.__vue__){el=el.parentElement;}
  
  el.__vue__
  
  el.__vue__.commentTxt="123"
  
  el.__vue__.publishComment()
  
- 模板遮罩逻辑梳理

	- enable字段决定了是否开启了定时任务

	- 开启了的，显示遮罩

	- 取出时间参数，解析时间

	- 进行读秒

- [Git操作中crlf和lf冲突问题](https://blog.csdn.net/aojianzhong5810/article/details/101851263?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-0&spm=1001.2101.3001.4242)

	- 1、编辑器统一

a. 修改git全局配置，禁止git自动将lf转换成crlf, 命令：

git config --global core.autocrlf false
b. 修改编辑器的用户配置，例如vscode

"files.eol": "\n", // 文件换行使用lf方式

	- 2、git方式统一

git提交的时候，文件中的换行符必须是LF，如果不是不能提交。

# 32. 提交时转换为LF，检出时不转换
git config --global core.autocrlf input

# 33. 拒绝提交包含混合换行符的文件
git config --global core.safecrlf true

	- 3、EditorConfig

主流编辑器都支持EditorConfig，配置end_of_line后，你编辑的代码会自动转化为对应的换行符。当然你需要将autocrlf关闭，防止再次被转换成其他格式，

# 34. 取值包括 crlf,lf,cr
end_of_line = lf

# 35. 提交检出均不转换
git config --global core.autocrlf false


	- 4、prettier

prettier是目前非常流行的代码格式化工具，提供了endOfLine来支持格式化换行符。

{
  // ...
  "endOfLine" : "lf"
  // ...
}
# 36. 提交检出均不转换
git config --global core.autocrlf false

	- 因为我们现有的项目都已经支持prettier，自然就使用了【husky+lint-staged+prettier】的方式，来支持所有代码格式化成 lf 换行符。

转载于:https://www.cnblogs.com/dahe1989/p/10784581.html

相关资源：...+git合并分支解决冲突及详解步骤_idea合并git分支,idea操作git...

- 5.3.0-vpc-arm/x86翻译问题
![image](assets/1886fa4c004e989e5d8e77c6c36a688a1a512cb7220bbb888fc1bc0a7c0f89f2.png)

- eslint

- 后端直接给svg字符串，带数据的那种

	- 标签直接转为dom元素，然后append到父元素中去

		-  function parseDom(arg) {
　　 var objE = document.createElement("div");
　　 objE.innerHTML = arg;
　　 return objE.childNodes;
};

		- et str='<h1>Interesting</h1>';
let parser = new DOMParser();
let doc = parser.parseFromString(str, "text/xml");
let node = doc.getElementsByTagName('h1')[0];
$('#test')[0].append(node);

	- 如何将普通字符串转化为dom节点插入页面

	- [地址](https://www.iteye.com/blog/zha-zi-1931474)

	- DOMParser

		- [地址](https://www.w3school.com.cn/xmldom/dom_domparser.asp)

		- [地址2](https://blog.csdn.net/lu92649264/article/details/113877817)

- webpack熟悉下

- vue快速熟悉下

- 二进制熟悉下

- 原生js熟悉下

- 上传下载

### 36.1.1. voi

- voi桌面

	- 问题

		- 1.voi个人桌面新增-设置关联账号弹窗-取消时报错，取消按钮时，也同样传递的是all

### 36.1.2. 打印机页面结构

- 状态显示：保存中，正在恢复，驱动盘状态载入中

- 恢复按钮

	- onClickRecover

- 保存按钮

	- onClickManage

- 导入按钮

	- onClickUploadPrinter

- 删除按钮

	- onClickDel

- 配合导入按钮的进度条展示区域

- 自动更新复选框

- 然后就是表格主体了

	- 编辑打印机驱动

	- 创建副本

	- 编辑配置文件

	- 查看详情

### 36.1.3. 驱动中心

- 状态显示：正常，合并中，错误，正在恢复

- 恢复按钮

	- onClickRecover

- 保存按钮

	- onClickManage

- 导入按钮

	- onClickUploadPrinter

- 删除按钮

	- onClickDel

- 配合导入按钮的进度条展示区域

- 自动更新复选框

- 然后就是表格主体了

	- 编辑操作

## 36.2. 记事本

### 36.2.1. 问题

- 浏览器为什么有缓存机制，在相关代码文件不变的情况下，会缓存文件，需要刷新之后，才会读取新部署到服务器上的文件

- 实习生提出的，给showDoc文档添加一个小功能，折叠代码的功能

- 远程办公

	- vdiProxy="socks5://59.175.233.194:8181" NGCONSOLE_BRANCH="5.3.0-vpc" ns -- --port="8081"

- 可耻的bug

	- 调用的接口给了，then函数，也就是不管怎样，直接调用，要么函数给then，要么() => fun()
![image](assets/f735ab9de4c7977ca36177a94491e7aadbe6d2ee51a2d5856eef0429835bf755.png)

- 可耻的，该执行的都执行了

	- 防抖和节流

- angularjs
$http.then
$http.success区别

	- $http

		- 返回一个promise对象

			- .then返回新的promise
使用从回调返回的值解析
链式调用
then驱动顺序操作

			- .then()是可链接的，将等待之前的.then()来解决。

			- var p = new Promise(function (resolve) {
resolve("data")
})
p.then((data) => {
console.log(data)
})
resolve传递的参数就是then回调中的形参

		- 该对象，有success和error方法

			- .success返回原始的promise
驱动并行操作，因为处理程序链接在相同的承诺上。
是用更传统的注册回调方式而不返回promise

				- $http(/*...*/).
  success(function parFunc1(data){/*...*/}).
  success(function parFunc2(data){/*...*/})
parFunc1()，parFunc2()并行

			- .success()和.error()可以链接，但它们都会立刻触发(所以没那么多)

### 36.2.2. 日记

- 心态：自我释放

  妥协，不意味着，这样就是对的。
  只是为了把时间和精力放在更加重要的事情中去，
  重心放在工作质量和个人提升中去，而不是工作流程，
  提高自己的工作效率，
  维持好自己的积极心态。
  
- 大道至简

	- 给计划要做的事情，按照重要程度，进行计划安排，这样事情才会按照时间推进，不至于，总觉得自己没有自律，没有守诺！！！

- 起飞

  你假装你要起飞，指定了要起飞的目标，但是你还没有起飞，所以你要忍辱负重，你要借着这个坑，进行你起飞的准备，包装你的羽毛，放飞你的思想，锻炼你的身心，武装你的头脑，等你有信心爬到悬崖，自信的昂头遨游的时候，你就可以起飞了，真正的起飞了。
  
### 36.2.3. 计划

- 日计划

	- 2021-4-22

		- 7030 【VPC5.3.0】【信创部分】桌面配置无中断扩容 4-22 1天

			- 逻辑梳理

				- 单个网卡

					- 数据类型为对象

				- 多个网卡

					- 数据类型为数组

						- 存的是数组

						- 回显也是数组

						- 数据类型: [{
     network:  null,
subnetwork:null,
ip:null
}]

						- 基础数据：
网络数组，networks，subnetworks，ipModes

		- 7029 【VPC5.3.0】【信创部分】支持桌面按状态筛选 4-23 0.5天

		- 虚拟机在线克隆：
POST /api/instances/{{instnace_id}}/clone/
研发部-胡海  18:00:16
源status不变

任务状态：
cloning-src 
cloning-dst

目的虚拟机过程中是SHUTOFF的 前端代码已经完成，等待后端来联调

		- vdi还有一个bug，个人桌面资源域的 - 锟哥说不用管了暂时

	- 2021-4-23

		- 7029 【VPC5.3.0】【信创部分】支持桌面按状态筛选 4-23 0.5天

	- 2021-05-25

		- lazygit

			- 如何使用？（1h）16:00-18:00 抽一个小时时间

			- git相关的东西总结！！！（2h）
interactive rebase
squash

		- nodejs

			- jest（2h）14:00-16:00

	- 2021-05-26

		- [二进制相关（4h）](https://www.cnblogs.com/heyonggang/archive/2013/04/12/3016573.html)

		- 编码相关（4h）

	- 2021-05-27

		- uaa补丁自测用例编写，自测（2h）2021-05-27 14：00-16：00

	- 2021-06-09

		- angularjs简介文档编写

		- 前端项目如何管理依赖版本

	- 2021-06-10

- 笼统计划

	- elementui熟悉下，避免因为不熟悉造成问题

	- webpack配置撸一遍，熟悉熟悉

	- nodejs关联表完成

	- nodejs-user表创建

	- vue细节抓一下，思维导图创建一下

	- react

		- 先撸一个最基础的demo：todolist页面：40%

		- 再撸一个比较复杂点的项目

	- 小程序

	- python

	- [nodejs学习](http://nodejs.cn/api/path.html#path_path_resolve_paths)

		- 1.Nodejs命令行光标位置的设置：https://blog.csdn.net/weixin_34121304/article/details/89473339

		- 2.一个例子看懂所有nodejs的官方网络demo：https://www.cnblogs.com/huenchao/p/7078741.html

		- 3.Node初学者入门，一本全面的NodeJS教程：https://www.cnblogs.com/youhui/articles/12156117.html

		- 4.nodejs前端开发教程：https://blog.csdn.net/qq_36232611/article/details/92579841

		- 5.Introduction - nodebook (whyun.com):https://nodebook.whyun.com/

		- 6.liuxing/node-abc: 《Node.js入门教程》 (github.com):https://github.com/liuxing/node-abc

		- 7.快速撸一个sina视频的demo，youtobe上的那个

	- [vscode配置](https://www.bilibili.com/video/BV1RJ411m7Bj?from=search&seid=5400887660038727441)

### 36.2.4. 记录

- [github中文排行榜](https://github.com/kon9chunkit/GitHub-Chinese-Top-Charts#JavaScript)

	- [yapi](https://github.com/YMFE/yapi)

	  YApi 是一个可本地部署的、打通前后端及QA的、可视化的接口管理平台
	  
	- [ruanyf/es6tutorial](https://github.com/ruanyf/es6tutorial)

	- [qianguyihao/Web](https://github.com/qianguyihao/Web)

	  前端入门到进阶图文教程，超详细的Web前端学习笔记。从零开始学前端，做一名精致优雅的前端工程师。公众号「千古壹号」作者。
	  
	- [lib-flexible](https://github.com/amfe/lib-flexible)

	  可伸缩布局方案
	  
	- [bailicangdu/node-elm](https://github.com/bailicangdu/node-elm)

	  基于 node.js + Mongodb 构建的后台系统
	  
- jwt

	- 五分钟带你了解啥是JWT

	- [地址](https://zhuanlan.zhihu.com/p/86937325)

- Oatuh2

	- [地址](https://zhuanlan.zhihu.com/p/84670338)

- hive

	- [百科](https://baike.baidu.com/item/hive/67986?fr=aladdin)

- Hadoop

	- [百科](https://baike.baidu.com/item/Hadoop/3526507)

- 分布式文件系统（ Distributed File System）

- curl模拟jwt

	- 登录返回token

		- curl -d "userName=zhangsan&password=123" http://127.0.0.1:3000/users/login

			- {
  "errno": 1,
  "data": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJOYW1lIjoiemhhbmdzYW4iLCJuaWNrTmFtZSI6IuW8oOS4iSIsImdlbmRlciI6MSwiaWF0IjoxNjI2NzQ1Mjk3LCJleHAiOjE2MjY3NDg4OTd9._A4F2ME4gvHe99m4PUiI8ZGnunnXrbUcdUKRyqOiBjs"
}

	- 获取用户信息

		- curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJOYW1lIjoiemhhbmdzYW4iLCJuaWNrTmFtZSI6IuW8oOS4iSIsImdlbmRlciI6MSwiaWF0IjoxNjI2NzQ1Mjk3LCJleHAiOjE2MjY3NDg4OTd9._A4F2ME4gvHe99m4PUiI8ZGnunnXrbUcdUKRyqOiBjs" http://127.0.0.1:3000/users/getUserInfo

			- {
  "errno": 0,
  "userInfo": {
    "userId": 1,
    "userName": "zhangsan",
    "nickName": "张三",
    "gender": 1,
    "iat": 1626745297,
    "exp": 1626748897
  }
}

	- [地址](https://www.jianshu.com/p/176198fbdb35)

	- [例子地址](https://github.com/yin-fan/todoList)

	- [例子2地址](https://github.com/lhj767382286/nodejs-koa2-mysql-sequelize-jwt)

- nodejs入门教程

	- [地址](http://nodejs.cn/learn/a-brief-history-of-nodejs)

	- kafka

		- 消息中间件-kafka

		- [地址](https://www.17coding.info/article/19)

		- [地址1](https://blog.csdn.net/qinqinde123/article/details/104442632)

	- Node.js 框架和工具

		- AdonisJs

			- [地址](https://docs.adonisjs.com/guides/application)

		- Express

		- Fastify

		- Gatsby

		- hapi

		- koa

		- Loopback.io

		- Meteor

		- Micro

		- NestJS

		- Next.js

		- Nx

		- Sapper

		- Socket.io

			- [知乎地址](https://zhuanlan.zhihu.com/p/29148869)

			- [github地址](https://github.com/socketio/socket.io)

		- Strapi

- 编译型语言和解释型语言

	- [地址](https://www.cnblogs.com/tsingke/p/12285650.html)

	- [一段解释](https://zhuanlan.zhihu.com/p/32673532)

	  电脑能认得的是二进制数，不能够识别高级语言。所有高级语言在电脑上执行都需要先转变为机器语言。但是高级语言有两种类型：编译型语言和解释型语言。常见的编译型语言语言有C/C++、Pascal/Object 等等。常见的解释性语言有python、JavaScript等等。
	  
	  
	  编译型语言先要进行编译，然后转为特定的可执行文件，这个可执行文件是针对平台的（CPU类型），可以这么理解你在PC上编译一个C源文件，需要经过预处理，编译，汇编等等过程生成一个可执行的二进制文件。当你需要再次运行该代码时，不需要重新编译代码，只需要运行该可执行的二进制文件。优点，编译一次，永久执行。还有一个优点是，你不需要提供你的源代码，你只需要发布你的可执行文件就可以为客户提供服务，从而保证了你的源代码的安全性。但是，如果你的代码需要迁移到linux、ARM下时，这时你的可执行文件就不起作用了，需要根据新的平台编译出一个新可执行的文件。这也就是多个平台需要软件的多个版本。缺点是，跨平台能力差。
	  
	  
	  解释型语言需要一个解释器，在源代码执行的时候被解释器翻译为一个与平台无关的中间代码，解释器会把这些代码翻译为及其语言。打个比方，编译型中的编译相当于一个翻译官，它只能翻译英语，而且中文文章翻译一次就不需要重新对文章进行二次翻译了，但是如果需要叫这个翻译官翻译德语就不行了。而解释型语言中的解释器相当于一个会各种语言的机器人，而且这个机器人会一句一句的翻译你的语句。对于不同的国家，翻译成不同的语言，所以，你只需要带着这个机器人就可以。解释型语言的有点是，跨平台，缺点是运行时需要源代码，知识产权保护性差，运行效率低。
	  
- github搜索技巧

	- blog stars:<10000

	- blog followers:<100

	- blog size:<100

	- blog created:>2021-07-21

	- https://github.com/search

		- dvanced search

			- https://github.com/search/advanced

	- in:name=spring boot

	- in:name spring boot

	- in:name spring boot stars:>1000 pushed:2021-07-01 forks:>2000

	- in:description spring boot stars:>1000 pushed:2020-07-01 forks:>2000

	- 1.收藏量-stars

		- stars:>=500
意为匹配收藏量超过500的项目

	- 2.复刻量-forks

		- forks:>=500
意为匹配复刻量超过500的项目

	- 3.关注者-followers

		- followers:>=500
意为匹配关注者超过500的项目

	- 4.计算机语言-language

		- language:Python
意为匹配用Python语言完成的项目

	- 5.地域-location

		- location:chiina
意为匹配地址在China的用户

	- 6.姓名搜索-in:fullname

		- Ben in:fullname
意为匹配搜索名字里包含Ben的开发者

- vscode

	- 搜索用正则

		- [^/]thor

			- 搜索thor前面没有带/的不规范路径

- :e 新文件 打开文件
:q 退出全部的buffer
:bdelect 关闭该buffer
:ls 列出所有的buffer
:bnext [n] 去接下来的第n个buffer 如果不加就是下一个buffer简化 就是:bn
:bNext n 去第n个缓冲区
:bprevious 前一个缓冲区 简化就是:bp
:blast
:bfirst 第一个缓冲区

- 微信小程序

	- 模板id

		- pbmsbGxKjJcdmgXRB15M57_f3DjsolUHXUqDZVRrM-M

	- openid

### 36.2.5. 生活

- mac book

	- 16G 512G M1 air

	- 显示器-家里使用

- 彩云小译

	- 清空插件cookie可以重置次数用完提示

### 36.2.6. 测试

- 三个问题：

1. 没有打开控制台，查看接口的截图，这个需要，方便查看问题

2. 没有说明环境，无法查看具体环境

3. 进度条还在，证明，还没有结束上传，请问为什么要刷新？



所以综上，问题，可能存在，但是没有bug

### 36.2.7. 内网穿透ngrok

- [地址](https://www.ngrok.cc/user.html)

- [视频地址](https://www.bilibili.com/video/BV17K4y187A2)

### 36.2.8. ssh 公钥 、免密登录

### 36.2.9. 浮动公网ip

### 36.2.10. ssh端口转发
![image](assets/ddb9345b2f4baaa390df72864654355801d53d9bbc3cad11c61df540d2081886.svg)

- ssh隧道通讯

	- 本地端口转发
![image](assets/192be5f17ad4ef6ad5dcc2d0fe2f925a6ca0ef0c3150bae00412f62c4f267457.png)

		- 云主机 暴露端口

			- 借助云主机访问一下云里的私有资源

				- 不想花钱买一个浮动的公网ip

				- 想通过云来跳转

			- 云主机中使用docker启动了nginx 8080端口

				- 需要启动安全组把8080暴露出去

				- 需要配置安全组

				- 不能常开安全组

			- ssh -L 8080:localhost:8080 root@47.100.18.162

				- 这样云主机中的8080端口（nginx），就可以被访问了

				- 省去了localhost，只有本机可以访问

				- 如果需要本地局域网可以访问的话，需要配置192.168.2.131

	- 本地想访问远端的地址，找不到能到达他的地方，但是两个都能访问公网

		- 远程端口
![image](assets/fca82929bb6eb62bf0664072ad9c2864a0155dd21a9d4a1c0ec63567cafa208a.png)

			- 安全组中放开8000端口
![image](assets/a12adbe4fc69e5ba215f37d91ad4fc7693cf0e2db2a3d4cc57fbbda0b130831a.png)

			- vim /etc/ssh/sshd_config 开启一个字段 GatewayPorts yes
systemctl restart sshd

			- ssh -R 0.0.0.0:8000:10.10.10.2:80 root@47.100.18.162

			- netstat -anp| grep 8000
![image](assets/ac2928cd1e9acf431d94ac50374bcd559b633cfcb24bef650bd5c44708fe6e79.png)

- 本地端口
![image](assets/2e5fa865ecb7ed1fb2f3646687e64bc303dab294c82ba8db3665f8cd5dffc1ab.png)

	-  
![image](assets/0cbaab2d8b01a6edb56d7756de478c0162152171c19efdd0d317a8d3b6883777.png)

- 远程端口
![image](assets/5e64af97f630946a5d7884feee53e646b661a565a4955bdbf70e8dd4bb8d6947.png)

	-  
![image](assets/97c21f63e23b10e4e302141ec5a2bf069c0540af95a92d012c5f2d3f94ba9cbb.png)

	- 发起ssh命令的是属于跳板机的角色

		- 可以访问一个客户端无法访问的ip和端口

			- 例子中的10.10.10.2:80起的一个openStack服务

		- 也可以访问公网的云服务器

	- 发起命令之后，命令行进入了云服务器中

		- 可以 netstat -anp | grep 8000 可以看到 监听了8000端口，转发到10.10.10.2

	- 47.100.18.162:8000

		- 访问10.10.10.2:80端口的服务了

- autossh 保持ssh连接

- [视频地址](https://www.bilibili.com/video/BV1C7411P7Er?p=1)

### 36.2.11. eslint "{./src/**/*.{vue,js},*.js}"

- [glob 模式匹配简明教程](https://juejin.cn/post/6844904077801816077)

- --ignore-pattern

- [eslint 命令行](https://www.jianshu.com/p/4133063d1785)

### 36.2.12. github打不开，打开慢，无法显示图片

- [地址](https://www.skillf.xyz/2021/04/20/%E5%85%B3%E4%BA%8EGithub%E7%BD%91%E9%A1%B5%E6%89%93%E4%B8%8D%E5%BC%80%E4%B8%8E%E5%9B%BE%E7%89%87%E6%97%A0%E6%B3%95%E5%8A%A0%E8%BD%BD%E8%A7%A3%E5%86%B3%E6%96%B9%E6%B3%95/)

- [配合地址](https://github.com.ipaddress.com/)

## 36.3. interview

### 36.3.1. nodejs

### 36.3.2. typescript

- [主页](https://www.tslang.cn/docs/handbook/typescript-in-5-minutes.html)

	- 类型注解

### 36.3.3. uniapp

### 36.3.4. 计算机基础

### 36.3.5. tips

- vue的事件传播机制

- 优化前端体验和页面响应速度

- 保证兼容性和执行效率

- es6

### 36.3.6. webpack

### 36.3.7. es6

- [地址](https://es6.ruanyifeng.com/#docs/arraybuffer#TypedArray-%E8%A7%86%E5%9B%BE)

### 36.3.8. 代码风格

- [github链接](https://github.com/standard/standard/blob/master/docs/README-zhcn.md#%E6%9C%89%E4%B8%93%E5%B1%9E%E5%BE%BD%E7%AB%A0%E5%8F%AF%E4%BB%A5%E7%94%A8%E6%9D%A5%E6%94%BE%E5%88%B0%E9%A1%B9%E7%9B%AE%E7%9A%84-readme-%E6%96%87%E4%BB%B6%E4%B8%AD%E5%90%97)

- stylelint

	- [github链接](https://github.com/stylelint/stylelint-config-standard/blob/master/index.js)

### 36.3.9. [Sonar系列之SonarQube简介](https://www.cnblogs.com/lfpriest/p/13366171.html)

### 36.3.10. .gitlab-ci.yml

## 36.4. 计算机基础知识积累和补充

### 36.4.1. [进程与线程](https://www.cnblogs.com/qianqiannian/p/7010909.html)

进程与线程

进程


 我们都知道计算机的核心是CPU，它承担了所有的计算任务，而操作系统是计算机的管理者，它负责任务的调度，资源的分配和管理，


统领整个计算机硬件；应用程序是具有某种功能的程序，程序是运行于操作系统之上的。


 进程是一个具有一定独立功能的程序在一个数据集上的一次动态执行的过程，是操作系统进行资源分配和调度的一个独立单位，是应用


程序运行的载体。进程是一种抽象的概念，从来没有统一的标准定义。进程一般由程序，数据集合和进程控制块三部分组成。程序用于描述


进程要完成的功能，是控制进程执行的指令集；数据集合是程序在执行时所需要的数据和工作区；程序控制块包含进程的描述信息和控制信息


是进程存在的唯一标志


进程具有的特征：


动态性：进程是程序的一次执行过程，是临时的，有生命期的，是动态产生，动态消亡的；


并发性：任何进程都可以同其他进行一起并发执行；


独立性：进程是系统进行资源分配和调度的一个独立单位；


结构性：进程由程序，数据和进程控制块三部分组成


线程


 在早期的操作系统中并没有线程的概念，进程是拥有资源和独立运行的最小单位，也是程序执行的最小单位。任务调度采用的是时间片


轮转的抢占式调度方式，而进程是任务调度的最小单位，每个进程有各自独立的一块内存，使得各个进程之间内存地址相互隔离。


 后来，随着计算机的发展，对CPU的要求越来越高，进程之间的切换开销较大，已经无法满足越来越复杂的程序的要求了。于是就发明


了线程，线程是程序执行中一个单一的顺序控制流程，是程序执行流的最小单元，是处理器调度和分派的基本单位。一个进程可以有一个或


多个线程，各个线程之间共享程序的内存空间(也就是所在进程的内存空间)。一个标准的线程由线程ID，当前指令指针PC，寄存器和堆栈组


成。而进程由内存空间(代码，数据，进程空间，打开的文件)和一个或多个线程组成。


进程与线程的区别


1. 线程是程序执行的最小单位，而进程是操作系统分配资源的最小单位；


2. 一个进程由一个或多个线程组成，线程是一个进程中代码的不同执行路线


3. 进程之间相互独立，但同一进程下的各个线程之间共享程序的内存空间(包括代码段，数据集，堆等)及一些进程级的资源(如打开文件和信


号等)，某进程内的线程在其他进程不可见；


4. 调度和切换：线程上下文切换比进程上下文切换要快得多


线程和进程关系示意图


￼


 

￼

 总之，线程和进程都是一种抽象的概念，线程是一种比进程还小的抽象，线程和进程都可用于实现并发。


在早期的操作系统中并没有线程的概念，进程是能拥有资源和独立运行的最小单位，也是程序执行的最小单位，它相当于


一个进程里只有一个线程，进程本身就是线程。所以线程有时被称为轻量级进程


 后来，随着计算机的发展，对多个任务之间上下文切换的效率要求越来越高，就抽象出一个更小的概念-线程，一般一个进程会有多个


(也可以是一个)线程。


  ￼


任务调度


 大部分操作系统的任务调度是采用时间片轮转的抢占式调度方式，也就是说一个任务执行一小段时间后强制暂停去执行下一个任务，每个


任务轮流执行。任务执行的一小段时间叫做时间片，任务正在执行时的状态叫运行状态，任务执行一段时间后强制暂停去执行下一个任务，被


暂停的任务就处于就绪状态，等待下一个属于它的时间片的到来。这样每个任务都能得到执行，由于CPU的执行效率非常高，时间片


非常短，在各个任务之间快速地切换，给人的感觉就是多个任务在“同时进行”，这也就是我们所说的并发


￼


为何不使用多进程而是使用多线程？


 线程廉价，线程启动比较快，退出比较快，对系统资源的冲击也比较小。而且线程彼此分享了大部分核心对象(File Handle)的拥有权


 如果使用多重进程，但是不可预期，且测试困难

学习无他法，唯有持之以恒

### 36.4.2. [进程和线程的区别（重点）](https://www.cnblogs.com/heyonggang/archive/2013/04/12/3016573.html)

进程和线程的区别（重点）

来源：http://www.cnblogs.com/lmule/archive/2010/08/18/1802774.html


 


简而言之,一个程序至少有一个进程,一个进程至少有一个线程.
线程的划分尺度小于进程，使得多线程程序的并发性高。
另外，进程在执行过程中拥有独立的内存单元，而多个线程共享内存，从而极大地提高了程序的运行效率。
线程在执行过程中与进程还是有区别的。每个独立的线程有一个程序运行的入口、顺序执行序列和程序的出口。但是线程不能够独立执行，必须依存在应用程序中，由应用程序提供多个线程执行控制。
从逻辑角度来看，多线程的意义在于一个应用程序中，有多个执行部分可以同时执行。但操作系统并没有将多个线程看做多个独立的应用，来实现进程的调度和管理以及资源分配。这就是进程和线程的重要区别。


进程是具有一定独立功能的程序关于某个数据集合上的一次运行活动,进程是系统进行资源分配和调度的一个独立单位.
线程是进程的一个实体,是CPU调度和分派的基本单位,它是比进程更小的能独立运行的基本单位.线程自己基本上不拥有系统资源,只拥有一点在运行中必不可少的资源(如程序计数器,一组寄存器和栈),但是它可与同属一个进程的其他的线程共享进程所拥有的全部资源.
一个线程可以创建和撤销另一个线程;同一个进程中的多个线程之间可以并发执行.


进程和线程的主要差别在于它们是不同的操作系统资源管理方式。进程有独立的地址空间，一个进程崩溃后，在保护模式下不会对其它进程 产生影响，而线程只是一个进程中的不同执行路径。线程有自己的堆栈和局部变量，但线程之间没有单独的地址空间，一个线程死掉就等于整个进程死掉，所以多进 程的程序要比多线程的程序健壮，但在进程切换时，耗费资源较大，效率要差一些。但对于一些要求同时进行并且又要共享某些变量的并发操作，只能用线程，不能 用进程。如果有兴趣深入的话，我建议你们看看《现代操作系统》或者《操作系统的设计与实现》。对就个问题说得比较清楚。


5.1 简介


进程（process）是一块包含了某些资源的内存区域。操作系统利用进程把它的工作划分为一些功能单元。


进程中所包含的一个或多个执行单元称为线程（thread）。进程还拥有一个私有的虚拟地址空间，该空间仅能被它所包含的线程访问。


当运行.NET程序时，进程还会把被称为CLR的软件层包含到它的内存空间中。上一章曾经对CLR做了详细描述。该软件层是在进程创建期间由运行时宿主载入的（参见4.2.3节）。


线程只能归属于一个进程并且它只能访问该进程所拥有的资源。当操作系统创建一个进程后，该进程会自动申请一个名为主线程或首要线程的线程。主线程将执行运行时宿主, 而运行时宿主会负责载入CLR。


应用程序（application）是由一个或多个相互协作的进程组成的。例如，Visual Studio开发环境就是利用一个进程编辑源文件，并利用另一个进程完成编译工作的应用程序。


在Windows NT/2000/XP操作系统下，我们可以通过任务管理器在任意时间查看所有的应用程序和进程。尽管只打开了几个应用程序，但是通常情况下将有大约30个进程同时运行。 事实上，为了管理当前的会话和任务栏以及其他一些任务，系统执行了大量的进程。


5.2 进程


5.2.1 简介


在运行于32位处理器上的32位Windows操作系统中，可将一个进程视为一段大小为4GB（232字节）的线性内存空间，它起始于0x00000000结束于0xFFFFFFFF。这段内存空间不能被其他进程所访问，所以称为该进程的私有空间。这段空间被平分为两块，2GB被系统所有，剩下2GB被用户所有。


如果有N个进程运行在同一台机器上，那么将需要N×4GB的海量RAM，还好事实并非如此。

Windows是按需为每个进程分配内存的，4GB是32位系统中一个进程所占空间的上限。
将进程所需的内存划分为4KB大小的内存页，并根据使用情况将这些内存页存储在硬盘上或加载到RAM中，通过系统的这种虚拟内存机制，我们可以有效地减少对实际内存的需求量。当然这些对用户和开发者来说都是透明的。

5.2.2 System.Diagnostics.Process类


System.Diagnostics.Process类的实例可以引用一个进程，被引用的进程包含以下几种。

该实例的当前进程。
本机上除了当前进程的其他进程。
远程机器上的某个进程。

通过该类所包含的方法和字段，可以创建或销毁一个进程，并且可以获得一个进程的相关信息。下面将讨论一些使用该类实现的常见任务。


5.2.3 创建和销毁子进程


下面的程序创建了一个称为子进程的新进程。在这种情况下，初始的进程称为父进程。子进程启动了一个记事本应用程序。父进程的线程在等待1秒后销毁该子进程。该程序的执行效果就是打开并关闭记事本。


例5-1

￼

静态方法Start()可以使用已存在的Windows文件扩展名关联机制。例如，我们可以利用下面的代码执行同样的操作。

￼

默认情况下，子进程将继承其父进程的安全上下文。但还可以使用Process.Start()方法的一个重载版本在任意用户的安全上下文中启动该子 进程，当然需要通过一个System.Diagnostics. ProcessStartInfo类的实例来提供该用户的用户名和密码。


5.2.4 避免在一台机器上同时运行同一应用程序的多个实例


有些应用程序需要这种功能。实际上，通常来说在同一台机器上同时运行一个应用程序的多个实例并没有意义。


直到现在，为了在Windows下满足上述约束，开发者最常用的方法仍然是使用有名互斥体（named mutex）技术（参见5.7.2节）。然而采用这种技术来满足上述约束存在以下缺点：

该技术具有使互斥体的名字被其他应用程序所使用的较小的、潜在的风险。在这种情况下该技术将不再有效并且会造成很难检测到的bug。
该技术不能解决我们仅允许一个应用程序产生N个实例这种一般的问题。

幸而在System.Diagnostics.Process类中拥有GetCurrentProcess()（返回当前进程）和GetPro- cesses()（返回机器上所有的进程）这样的静态方法。在下面的程序中我们为上述问题找到了一个优雅且简单的解决方案。


例5-2

￼

通过方法参数指定了远程机器的名字后，GetProcesses()方法也可以返回远程机器上所有的进程。


5.2.5 终止当前进程


可以调用System.Environment类中的静态方法Exit(int exitCode)或FailFast(stringmessage)终止当前进程。Exit()方法是最好的选择，它将彻底终止进程并向操作系统返回指 定的退出代码值。之所以称为彻底终止是因为当前对象的所有清理工作以及finally块的执行都将由不同的线程完成。当然，终止进程将花费一定的时间。


顾名思义，FailFast()方法可以迅速终止进程。Exit()方法所做的预防措施将被它忽略。只有一个包含了指定信息的严重错误会被操作系统记录到日志中。你可能想要在探查问题的时候使用该方法，因为可以将该程序的彻底终止视为数据恶化的起因。


5.3 线程


5.3.1 简介


一个线程包含以下内容。

一个指向当前被执行指令的指令指针；
一个栈；
一个寄存器值的集合，定义了一部分描述正在执行线程的处理器状态的值；
一个私有的数据区。

所有这些元素都归于线程执行上下文的名下。处在同一个进程中的所有线程都可以访问该进程所包含的地址空间，当然也包含存储在该空间中的所有资源。


我们不准备讨论线程在内核模式或者用户模式执行的问题。尽管.NET以前的Windows一直使用这两种模式，并且依然存在，但是对.NET Framework来说它们是不可见的。


并行使用一些线程通常是我们在实现算法时的自然反应。实际上，一个算法往往由一系列可以并发执行的任务组成。但是需要引起注意的是，使用大量的线程将引起过多的上下文切换，最终反而影响了性能。


同样，几年前我们就注意到，预测每18个月处理器运算速度增加一倍的摩尔定律已不再成立。处理器的频率停滞在3GHz~4GHz上下。这是由于物理 上的限制，需要一段时间才能取得突破。同时，为了在性能竞争中不会落败，较大的处理器制造商如AMD和Intel目前都将目标转向多核芯片。因此我们可以 预计在接下去的几年中这种类型的架构将广泛被采用。在这种情况下，改进应用性能的唯一方案就是合理地利用多线程技术。


5.3.2 受托管的线程与 Windows线程


必须要了解，执行.NET应用的线程实际上仍然是Windows线程。但是，当某个线程被CLR所知时，我们将它称为受托管的线程。具体来说，由受 托管的代码创建出来的线程就是受托管的线程。如果一个线程由非托管的代码所创建，那么它就是非托管的线程。不过，一旦该线程执行了受托管的代码它就变成了 受托管的线程。


一个受托管的线程和非托管的线程的区别在于，CLR将创建一个System.Threading.Thread类的实例来代表并操作前者。在内部实现中，CLR将一个包含了所有受托管线程的列表保存在一个叫做ThreadStore地方。


CLR确保每一个受托管的线程在任意时刻都在一个AppDomain中执行，但是这并不代表一个线程将永远处在一个AppDomain中，它可以随着时间的推移转到其他的AppDomain中。关于AppDomain的概念参见4.1。


从安全的角度来看，一个受托管的线程的主用户与底层的非托管线程中的Windows主用户是无关的。


5.3.3 抢占式多任务处理


我们可以问自己下面这个问题: 我的计算机只有一个处理器，然而在任务管理器中我们却可以看到数以百计的线程正同时运行在机器上！这怎么可能呢？


多亏了抢占式多任务处理，通过它对线程的调度，使得上述问题成为可能。调度器作为Windows内核的一部分，将时间切片，分成一段段的时间片。这 些时间间隔以毫秒为精度且长度并不固定。针对每个处理器，每个时间片仅服务于单独一个线程。线程的迅速执行给我们造成了它们在同时运行的假象。我们在两个 时间片的间隔中进行上下文切换。该方法的优点在于，那些正在等待某些Windows资源的线程将不会浪费时间片，直到资源有效为止。


之所以用抢占式这个形容词来修饰这种多任务管理方式，是因为在此种方式下线程将被系统强制性中断。那些对此比较好奇的人应该了解到，在上下文切换的 过程中，操作系统会在下一个线程将要执行的代码中插入一条跳转到下一个上下文切换的指令。该指令是一个软中断，如果线程在遇到这条指令前就终止了（例如， 它正在等待某个资源），那么该指定将被删除而上下文切换也将提前发生。


抢占式多任务处理的主要缺点在于，必须使用一种同步机制来保护资源以避免它们被无序访问。除此之外，还有另一种多任务管理模型，被称为协调式多任务 管理，其中线程间的切换将由线程自己负责完成。该模型普遍认为太过危险，原因在于线程间的切换不发生的风险太大。如我们在4.2.8节中所解释的那样，该 机制会在内部使用以提升某些服务器的性能，例如SQL Server2005。但Windows操作系统仅仅实现了抢占式多任务处理。


5.3.4 进程与线程的优先级


某些任务拥有比其他任务更高的优先级，它们需要操作系统为它们申请更多的处理时间。例如，某些由主处理器负责的外围驱动器必须不能被中断。另一类高优先级的任务就是图形用户界面。事实上，用户不喜欢等待用户界面被重绘。


那些从Win32世界来的用户知道在CLR的底层，也就是Windows操作系统中，可以为每个线程赋予一个0~31的优先级。但你无法在.NET的世界中也使用这些数值，因为：

它们无法描述自身的含义。
随着时间的流逝这些值是非常容易变化的。

1. 进程的优先级


可以使用Process类中的类型为ProcessPriorityClass的PriorityClass{get;set;}属性为进程赋予一个优先级。System.Diagnostics.ProcessPriorityClass枚举包含以下值：

￼

如果某个进程中属于Process类的PriorityBoostEnabled属性的值为true（默认值为true），那么当该进程占据前台窗口的时候，它的优先级将增加一个单位。只有当Process类的实例引用的是本机进程时，才能够访问该属性。


可以通过以下操作利用任务管理器来改变一个进程的优先级：在所选的进程上点击右键>设置优先级>从提供的6个值（和上图所述一致）中做出选择。


Windows操作系统有一个优先级为0的空闲进程。该进程不能被其他任何进程使用。根据定义，进程的活跃度用时间的百分比表示为：100%减去在空闲进程中所耗费时间的比率。


2. 线程的优先级


每个线程可以结合它所属进程的优先级，并使用System.Threading.Thread类中类型为ThreadPriority的 Priority{get;set;}属性定义各自的优先级。System.Threading.Thread- Priority包含以下枚举值：

￼

在大多数应用程序中，不需要修改进程和线程的优先级，它们的默认值为Normal。


5.3.5 System.Threading.Thread类


CLR会自动将一个System.Threading.Thread类的实例与各个受托管的线程关联起来。可以使用该对象从线程自身或从其他线程来 操纵线程。还可以通过System.Threading.Thread类的静态属性CurrentThread来获得当前线程的对象。

￼

Thread类有一个功能使我们能够很方便的调试多线程应用程序，该功能允许我们使用一个字符串为线程命名：

￼

5.3.6 创建与Join一个线程


只需通过创建一个Thread类的实例，就可以在当前的进程中创建一个新的线程。该类拥有多个构造函数，它们将接受一个类型为 System.Threading.ThreadStart或System.Threading.Parame-trizedThreadStart的委 托对象作为参数，线程被创建出来后首先执行该委托对象所引用的方法。使用ParametrizedThreadStart类型的委托对象允许用户为新线程 将要执行的方法传入一个对象作为参数。Thread类的一些构造函数还接受一个整型参数用于设置线程要使用的最大栈的大小，该值至少为128KB（即 131072字节）。创建了Thread类型的实例后，必须调用Thread.Start()方法以真正启动这个线程。


例5-3

￼

该程序输出：

￼

在这个例子中，我们使用Join()方法挂起当前线程，直到调用Join()方法的线程执行完毕。该方法还存在包含参数的重载版本，其中的参数用于 指定等待线程结束的最长时间（即超时）所花费的毫秒数。如果线程中的工作在规定的超时时段内结束，该版本的Join()方法将返回一个布尔量True。


5.3.7 挂起一个线程


可以使用Thread类的Sleep()方法将一个正在执行的线程挂起一段特定的时间，还可以通过一个以毫秒为单位的整型值或者一个 System.TimeSpan结构的实例设定这段挂起的时间。该结构的一个实例可以设定一个精度为1/10 ms（100ns）的时间段，但是Sleep()方法的最高精度只有1ms。

￼

我们也可以从将要挂起的线程自身或者另一个线程中使用Thread类的Suspend()方法将一个线程的活动挂起。在这两种情况中，线程都将被阻 塞直到另一个线程调用了Resume()方法。相对于Sleep()方法，Suspend()方法不会立即将线程挂起，而是在线程到达下一个安全点之 后，CLR才会将该线程挂起。安全点的概念参见4.7.11节。


5.3.8 终止一个线程


一个线程可以在以下场景中将自己终止。

从自己开始执行的方法（主线程中的Main()方法，其他线程中ThreadStart委托对象所引用的方法）中退出。
被自己终止。
被另一个线程终止。

第一种情况不太重要，我们将主要关注另两种情况。在这两种情况中，都可以使用Abort()方法（通过当前线程或从当前线程之外的一个线程）。使用 该方法将在线程中引发一个类型为ThreadAbortException的异常。由于线程正处于一种被称为AbortRequested的特殊状态，该 异常具有一个特殊之处：当它被异常处理所捕获后，将自动被重新抛出。只有在异常处理中调用Thread.ResetAbort()这个静态方法（如果我们 有足够的权限）才能阻止它的传播。


例5-4 主线程的自杀

￼

当线程A对线程B调用了Abort()方法，建议调用B的Join()方法，让A一直等待直到B终止。Interrupt()方法也可以将一个处于 阻塞状态的线程（即由于调用了Wait()、Sleep()或者Join()其中一个方法而阻塞）终止。该方法会根据要被终止的线程是否处于阻塞状态而表 现出不同的行为。

如果该方法被另一个线程调用时，要被终止的线程处于阻塞状态，那么会产生ThreadInterruptedException异常。
如果该方法被另一个线程调用时，要被终止的线程不处于阻塞状态，那么一旦该线程进入阻塞状态，就会引发异常。这种行为与线程对自己调用Interrupt()方法是一样的。

5.3.9 前台线程与后台线程


Thread类提供了IsBackground{get;set}的布尔属性。当前台线程还在运行时，它会阻止进程被终止。另一方面，一旦所指的进 程中不再有前台线程，后台线程就会被CLR自动终止（调用Abort()方法）。IsBackground的默认值为false，这意味着所有的线程默认 情况处于前台状态。


5.3.10 受托管线程的状态图


Thread类拥有一个System.Threading.ThreadState枚举类型的字段ThreadState，它包含以下枚举值：

￼

有关每个状态的具体描述可以在MSDN上一篇名为“ThreadStateEnumeration”的文章中找到。该枚举类型是一个二进制位域，这 表示一个该类型的实例可以同时表示多个枚举值。例如，一个线程可以同时处于Running、AbortRequested和Background这三种状 态。二进制位域的概念参见10.11.3节。


根据我们在前面的章节中所了解的知识，我们定义了如图5-1所示的简化的状态图。

￼

图5-1 简化的托管线程状态图


5.4 访问资源同步简介


在多线程应用（一个或多个处理器）的计算中会使用到同步这个词。实际上，这些应用程序的特点就是它们拥有多个执行单元，而这些单元在访问资源的时候 可能会发生冲突。线程间会共享同步对象，而同步对象的目的在于能够阻塞一个或多个线程，直到另一个线程使得某个特定条件得到满足。


我们将看到，存在多种同步类与同步机制，每种制针对一个或一些特定的需求。如果要利用同步构建一个复杂的多线程应用程序，那么很有必要先掌握本章的内容。我们将在下面的内容中尽力区分他们，尤其要指出那些在各个机制间最微妙的区别。


合理地同步一个程序是最精细的软件开发任务之一，单这一个主题就足以写几本书。在深入到细节之前，应该首先确认使用同步是否不可避免。通常，使用一些简单的规则可以让我们远离同步问题。在这些规则中有线程与资源的亲缘性规则，我们将在稍后介绍。


应该意识到，对程序中资源的访问进行同步时，其难点来自于是使用细粒度锁还是粗粒度锁这个两难的选择。如果在访问资源时采用粗粒度的同步方式，虽然 可以简化代码但是也会把自己暴露在争用瓶颈的问题上。如果粒度过细，代码又会变的很复杂，以至于维护工作令人生厌。然后又会遇上死锁和竞态条件这些在下面 章节将要介绍的问题。


因此在我们开始谈论有关同步机制之前，有必要先了解一下有关竞态条件和死锁的概念。


5.4.1 竞态条件


竞态条件指的是一种特殊的情况，在这种情况下各个执行单元以一种没有逻辑的顺序执行动作，从而导致意想不到的结果。


举一个例子，线程T修改资源R后，释放了它对R的写访问权，之后又重新夺回R的读访问权再使用它，并以为它的状态仍然保持在它释放它之后的状态。但是在写访问权释放后到重新夺回读访问权的这段时间间隔中，可能另一个线程已经修改了R的状态。


另一个经典的竞态条件的例子就是生产者/消费者模型。生产者通常使用同一个物理内存空间保存被生产的信息。一般说来，我们不会忘记在生产者与消费者 的并发访问之间保护这个空间。容易被我们忘记的是生产者必须确保在生产新信息前，旧的信息已被消费者所读取。如果我们没有采取相应的预防措施，我们将面临 生产的信息从未被消费的危险。


如果静态条件没有被妥善的管理，将导致安全系统的漏洞。同一个应用程序的另一个实例很可能会引发一系列开发者所预计不到的事件。一般来说，必须对那 种用于确认身份鉴别结果的布尔量的写访问做最完善的保护。如果没有这么做，那么在它的状态被身份鉴别机制设置后，到它被读取以保护对资源的访问的这段时间 内，很有可能已经被修改了。已知的安全漏洞很多都归咎于对静态条件不恰当的管理。其中之一甚至影响了Unix操作系统的内核。


5.4.2 死锁


死锁指的是由于两个或多个执行单元之间相互等待对方结束而引起阻塞的情况。例如：


一个线程T1获得了对资源R1的访问权。


一个线程T2获得了对资源R2的访问权。


T1请求对R2的访问权但是由于此权力被T2所占而不得不等待。


T2请求对R1的访问权但是由于此权力被T1所占而不得不等待。


T1和T2将永远维持等待状态，此时我们陷入了死锁的处境！这种问题比你所遇到的大多数的bug都要隐秘，针对此问题主要有三种解决方案：

在同一时刻不允许一个线程访问多个资源。
为资源访问权的获取定义一个关系顺序。换句话说，当一个线程已经获得了R1的访问权后，将无法获得R2的访问权。当然，访问权的释放必须遵循相反的顺序。
为所有访问资源的请求系统地定义一个最大等待时间（超时时间），并妥善处理请求失败的情况。几乎所有的.NET的同步机制都提供了这个功能。

前两种技术效率更高但是也更加难于实现。事实上，它们都需要很强的约束，而这点随着应用程序的演变将越来越难以维护。尽管如此，使用这些技术不会存在失败的情况。


大的项目通常使用第三种方法。事实上，如果项目很大，一般来说它会使用大量的资源。在这种情况下，资源之间发生冲突的概率很低，也就意味着失败的情况会比较罕见。我们认为这是一种乐观的方法。秉着同样的精神，我们在19.5节描述了一种乐观的数据库访问模型。


5.5 使用volatile字段与Interlocked类实现同步


5.5.1 volatile字段


volatile字段可以被多个线程访问。我们假设这些访问没有做任何同步。在这种情况下，CLR中一些用于管理代码和内存的内部机制将负责同步工 作，但是此时不能确保对该字段读访问总能读取到最新的值，而声明为volatile的字段则能提供这样的保证。在C#中，如果一个字段在它的声明前使用了 volatile关键字，则该字段被声明为volatile。


不是所有的字段都可以成为volatile，成为这种类型的字段有一个条件。如果一个字段要成为volatile，它的类型必须是以下所列的类型中的一种：

引用类型（这里只有访问该类型的引用是同步的，访问其成员并不同步）。
一个指针（在不安全的代码块中）。
sbyte、byte、short、ushort、int、uint、char、float、bool（工作在64位处理器上时为double、long与ulong）。
一个使用以下底层类型的枚举类型：byte、sbyte、short、ushort、int、uint（工作在64位的处理器上时为double、long与ulong）。

你可能已经注意到了，只有值或者引用的位数不超过本机整型值的位数（4或8由底层处理器决定）的类型才能成为volatile。这意味着对更大的值类型进行并发访问必须进行同步，下面我们将会对此进行讨论。


5.5.2 System.Threading.Interlocked类


经验显示，那些需要在多线程情况下被保护的资源通常是整型值，而这些被共享的整型值最常见的操作就是增加/减少以及相 加。.NETFramework利用System.Threading.Interlocked类提供了一个专门的机制用于完成这些特定的操作。这个类提 供了Increment()、Decrement()与Add()三个静态方法，分别用于对int或者long类型变量的递增、递减与相加操作，这些变量 以引用方式作为参数传入。我们认为使用Interlocked类让这些操作具有了原子性。


下面的程序显示了两个线程如何并发访问一个名为counter的整型变量。一个线程将其递增5次，另一个将其递减5次。


例5-5

￼

该程序输出（以非确定方式输出，意味着每执行一次显示的结果都是不同的）：

￼
￼

如果我们不让这些线程在每次修改变量后休眠10毫秒，那么它们将有足够的时间在一个时间片中完成它们的任务，那样也就不会出现交叉操作，更不用说并发访问了。


5.5.3 Interlocked类提供的其他功能


Interlocked类还允许使用Exchange()静态方法，以原子操作的形式交换某些变量的状态。还可以使用CompareExchange()静态方法在满足一个特定条件的基础上以原子操作的形式交换两个值。


5.6 使用System.Threading.Monitor类与C#的lock关键字实现同步


以原子操作的方式完成简单的操作无疑是很重要的，但是这还远不能涵盖所有需要用到同步的事例。System.Threading.Monitor类几乎允许将任意一段代码设置为在某个时间仅能被一个线程执行。我们将这段代码称之为临界区。


5.6.1 Enter()方法和Exit()方法


Monitor类提供了Enter(object)与Exit(object)这两个静态方法。这两个方法以一个对象作为参数，该对象提供了一个简 单的方式用于唯一标识那个将以同步方式访问的资源。当一个线程调用了Enter()方法，它将等待以获得访问该引用对象的独占权（仅当另一个线程拥有该权 力的时候它才会等待）。一旦该权力被获得并使用，线程可以对同一个对象调用Exit()方法以释放该权力。


￼一个线程可以对同一个对象多次调用Enter()，只要对同一对象调用相同次数的Exit()来释放独占访问权。


一个线程也可以在同一时间拥有多个对象的独占权，但是这样会产生死锁的情况。


绝不能对一个值类型的实例调用Enter()与Exit()方法。


不管发生了什么，必须在finally子句中调用Exit()以释放所有的独占访问权。


如果在例5-5中，一个线程非要将counter做一次平方而另一个线程非要将counter乘2，我们就不得不用Monitor类去替换对Interlocked类的使用。f1()与f2()的代码将变成下面这样：


例5-6[1]

￼￼
￼

人们很容易想到用counter来代替typeof(Program)，但是counter是一个值类型的静态成员。需要注意平方和倍增操作是不满足交换律的，所以counter的最终结果是非确定性的。


5.6.2 C#的lock关键字


C#语言通过lock关键字提供了一种比使用Enter()和Exit()方法更加简洁的选择。我们的程序可以改写为下面这个样子：


例5-7

￼

和for以及if关键字一样，如果被lock关键字定义的块仅包含一条指令，就不再需要花括号。我们可以再次改写为：

￼

使用lock关键字将引导C#编译器创建出相应的try/finally块，这样仍旧可以预期到任何可能引发的异常。可以使用Reflector或者ildasm.exe工具验证这一点。


5.6.3 SyncRoot模式


和前面的例子一样，我们通常在一个静态方法中使用Monitor类配合一个Type类的实例。同样，我们往往会在一个非静态方法中使用this关键 字来实现同步。在两种情况下，我们都是通过一个在类外部可见的对象对自身进行同步。如果其他部分的代码也利用这些对象来实现自身的同步，就会出现问题。为 了避免这种潜在的问题，我们推荐使用一个类型为object的名为SyncRoot的私有成员，至于该成员是静态的还是非静态的则由需要而定。


例5-8

￼

System.Collections.ICollection接口提供了object类型的SyncRoot{get;}属性。大多数的集合类 （泛型或非泛型）都实现了该接口。同样地，可以使用该属性同步对集合中元素的访问。不过在这里SyncRoot模式并没有被真正的应用，因为我们对访问进 行同步所使用对象不是私有的。


例5-9

￼

5.6.4 线程安全类


若一个类的每个实例在同一时间不能被一个以上的线程所访问，则该类称之为一个线程安全的类。为了创建一个线程安全的类，只需将我们见过的 SyncRoot模式应用于它所包含的方法。如果一个类想变成线程安全的，而又不想为类中代码增加过多负担，那么有一个好方法就是像下面这样为其提供一个 经过线程安全包装的继承类。


例5-10

￼
￼

另一种方法就是使用System.Runtime.Remoting.Contexts.SynchronizationAttribute，这点我们将在本章稍后讨论。


5.6.5 Monitor.TryEnter()方法

￼

该方法与Enter()相似，只不过它是非阻塞的。如果资源的独占访问权已经被另一个线程占据，该方法将立即返回一个false返回值。我们也可以 调用TryEnter()方法，让它以毫秒为单位阻塞一段有限的时间。因为该方法的返回结果并不确定，并且当获得独占访问权后必须在finally子句中 释放该权力，所以建议当TryEnter()失败时立即退出正在调用的函数：


例5-11[2]

￼

5.6.6 Monitor类的Wait()方法, Pulse()方法以及PulseAll()方法

￼
￼

Wait()、Pulse()与PulseAll()方法必须在一起使用并且需要结合一个小场景才能被正确理解。我们的想法是这样的：一个线程获得 了某个对象的独占访问权，而它决定等待（通过调用Wait()）直到该对象的状态发生变化。为此，该线程必须暂时失去对象独占访问权，以便让另一个线程修 改对象的状态。修改对象状态的线程必须使用Pulse()方法通知那个等待线程修改完成。下面有一个小场景具体说明了这一情况。

拥有OBJ对象独占访问权的T1线程，调用Wait(OBJ)方法将它自己注册到OBJ对象的被动等待列表中。
由于以上的调用，T1失去了对OBJ的独占访问权。因此，另一个线程T2通过调用Enter(OBJ)获得OBJ的独占访问权。
T2最终修改了OBJ的状态并调用Pulse(OBJ)通知了这次修改。该调用将导致OBJ被动等待列表中的第一个线程（在这里是T1）被移到 OBJ的主动等待列表的首位。而一旦OBJ的独占访问权被释放，OBJ主动等待列表中的第一个线程将被确保获得该权力。然后它就从Wait(OBJ)方法 中退出等待状态。
在我们的场景中，T2调用Exit(OBJ)以释放对OBJ的独占访问权，接着T1恢复访问权并从Wait(OBJ)方法中退出。
PulseAll()将使得被动等待列表中的线程全部转移到主动等待列表中。注意这些线程将按照它们调用Wait()的顺序到达非阻塞态。

￼如果Wait(OBJ)被一个调用了多次Enter(OBJ)的线程所调用，那么该线程将需要调用相同次数的Exit(OBJ)以释放对OBJ的访问权。即使在这种情况下，另一个线程调用一次Pulse(OBJ)就足以将第一个线程变成非阻塞态。


下面的程序通过ping与pong两个线程以交替的方式使用一个ball对象的访问权来演示该功能。


例5-12

￼
￼

该程序输出（以不确定的方式）：

￼

pong线程没有结束并且仍然阻塞在Wait()方法上。由于pong线程是第二个获得ball对象的独占访问权的，所以才导致了该结果。




### 36.4.3. [线程和进程的区别是什么？](https://www.zhihu.com/question/25532384)

看了一遍排在前面的答案，类似”进程是资源分配的最小单位，线程是CPU调度的最小单位“这样的回答感觉太抽象，都不太容易让人理解。


做个简单的比喻：进程=火车，线程=车厢

线程在进程下行进（单纯的车厢无法运行）
一个进程可以包含多个线程（一辆火车可以有多个车厢）
不同进程间数据很难共享（一辆火车上的乘客很难换到另外一辆火车，比如站点换乘）
同一进程下不同线程间数据很易共享（A车厢换到B车厢很容易）
进程要比线程消耗更多的计算机资源（采用多列火车相比多个车厢更耗资源）
进程间不会相互影响，一个线程挂掉将导致整个进程挂掉（一列火车不会影响到另外一列火车，但是如果一列火车上中间的一节车厢着火了，将影响到所有车厢）
进程可以拓展到多机，进程最多适合多核 ！！！？？？（不同火车可以开在多个轨道上，同一火车的车厢不能在行进的不同的轨道上）
进程使用的内存地址可以上锁，即一个线程使用某些共享内存时，其他线程必须等它结束，才能使用这一块内存。（比如火车上的洗手间）－"互斥锁"
进程使用的内存地址可以限定使用量（比如火车上的餐厅，最多只允许多少人进入，如果满了需要在门口等，等有人出来了才能进去）－“信号量

这个问题，是操作系统里问的最多的问题之一，也是被误解最深的概念之一。Alan Kay说过，好的角度可以提升80分的智商。理解它们的差别，我从资源使用的角度出发。所谓的资源就是计算机里的中央处理器，内存，文件，网络等等。
进程，在一定的环境下，把静态的程序代码运行起来，通过使用不同的资源，来完成一定的任务。比如说，进程的环境包括环境变量，进程所掌控的资源，有中央处理器，有内存，打开的文件，映射的网络端口等等。
这里我把进程对内存的管理稍微展开说一下。一个系统中，有很多进程，它们都会使用内存。为了确保内存不被别人使用，每个进程所能访问的内存都是圈好的。一人一份，谁也不干扰谁。还有内存的分页，虚拟地址我就不深入探讨了。这里给大家想强调的就是，进程需要管理好它的资源。
其中，线程作为进程的一部分，扮演的角色就是怎么利用中央处理器去运行代码。这其中牵扯到的最重要资源的是中央处理器和其中的寄存器，和线程的栈（stack）。这里想强调的是，线程关注的是中央处理器的运行，而不是内存等资源的管理。
当只有一个中央处理器的时候，进程中只需要一个线程就够了。随着多处理器的发展，一个进程中可以有多个线程，来并行的完成任务。比如说，一个web服务器，在接受一个新的请求的时候，可以大动干戈的fork一个子进程去处理这个请求，也可以只在进程内部创建一个新的线程来处理。线程更加轻便一点。线程可以有很多，但他们并不会改变进程对内存（heap）等资源的管理，线程之间会共享这些资源。总结一下，我上面的解释是通过计算机操作系统的角度出发的。进程和线程不是同一个层面上的概念，线程是进程的一部分，线程主抓中央处理器执行代码的过程，其余的资源的保护和管理由整个进程去完成。

### 36.4.4. angulajs源码阅读和笔记

### 36.4.5. vue源码

### 36.4.6. react js

### 36.4.7. nodejs

### 36.4.8. python

### 36.4.9. [二叉树](https://baike.baidu.com/item/%E4%BA%8C%E5%8F%89%E6%A0%91/1602879?fr=aladdin)

- 满二叉树

- 完全二叉树

### 36.4.10. [数据结构：如何理解堆？](https://blog.csdn.net/weixin_30698297/article/details/97531529)

- 最好的实现方式，就是要很直观，甚至是简单粗暴，所以就想到了完全二叉树，完全二叉树特别好的一个性质就是：父结点和子结点的相对位置是确定的，这一点不管是对堆的查找还是建立亦或是删除，都特别的友好。

### 36.4.11. [ip a](https://www.jianshu.com/p/3d754445db5a)

### 36.4.12. “/etc/ssh/sshd_config”是OpenSSH的配置文件，允许设置选项改变这个daemon的运行

- [地址](https://blog.csdn.net/qq_27840695/article/details/80610918)

- 1. vim /etc/ssh/sshd_config

- 2.修改PasswordAuthentication yes , PermitRootLogin yes两行即可

- 3.service ssh status

- 4.service ssh start

- 5.sudo service sshd start

- 6.ps -ef | grep sshd

### 36.4.13. 新的linux服务器配置ip

- sudo ifconfig eth0 192.168.0.1 netmask 255.255.255.0 

- sudo route add default gw 192.168.0.253 eth0

### 36.4.14. Linux下命令行设置IP、网关和DNS
ip 和子网掩码 执行这个命令：ifconfig eth0 192.168.1.123 netmask 255.255.255.0
网关的设定执行这个命令： route add default gw 192.168.1.3 
把这两个命令写到/etc/rc.local 或者/etc/rc.d/rc.local 里面都可以的，这样就可以永久保存

/etc/sysconfig/network设置默认的网关，主机名称，是否启动网络3项；
/etc/sysconfig/network-script/ifcfg-ethN ,N表示网卡编号，这个地方可以设置该网卡的参数，
         如ip,netmask,network,broadcast,gateway,开机取得ip的协议方式（dhcp,static）static,
         是否在开机时启动等，
/etc/resolv.conf配置dns服务器
/etc/hosts将局域网内机器名与ip地址对应起来，达到通过机器名访问其他机器的目的（仅在通过
         机器名无法反查ip情况下）
————————————————
版权声明：本文为CSDN博主「小瑞」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/xiaxiaorui2003/article/details/4278352

### 36.4.15. 参考文档：

- [1.重学JavaScript | 重新认识计算机语言](https://juejin.cn/post/7102368013386514463)

- [2.重学JavaScript | 浏览器的渲染及解析](https://juejin.cn/post/7103475994400391182)

## 36.5. https

### 36.5.1. [文章1：小朋友都能看懂的 HTTPS](https://juejin.cn/post/6877091745071693832)

### 36.5.2. [文章2：《大前端进阶 安全》系列 HTTPS详解（通俗易懂）](https://juejin.cn/post/6844904127420432391)

### 36.5.3. [文章3：漫画：什么是 HTTPS 协议？](https://juejin.cn/post/6844903795776815117)

### 36.5.4. [文章4：前端进阶高薪必看-HTTPS篇](https://juejin.cn/post/6844904150115827725)

### 36.5.5. [文章5：半小时搞懂 HTTP、HTTPS和HTTP2](https://juejin.cn/post/6894053426112495629)

### 36.5.6. [文章6：看完这篇 HTTPS，和面试官扯皮就没问题了](https://juejin.cn/post/6844904089495535624)

### 36.5.7. [github地址](https://github.com/ponkans/F2E)

### 36.5.8. 图示：
![image](assets/52347723f00bfab9c0314c4060ca73aa4efa5b2373130106480d2d731ffbb05a.png)

## 36.6. mongodb

### 36.6.1. noSQL
![image](assets/60cab64c7ff33448e68dbec42ea699de23ab212b48b9e3e1885408666cfbc643.png)

### 36.6.2. /usr/local/etc/mongod.conf

### 36.6.3. mongoose

- 好处

	- 1. 可以为文档创建一个模式结构(schema:约束)

		- 1.限制

			- 字段个数

			- 字段类型

		- 2.先尝试类型转换，转换不了，进不来，数据进入数据库之前，进行了检验

	- 2.可以对模型中的对象/文档进行验证

	- 3.数据可以通过类型转换转换为对象模型

	- 4.可以使用中间件来应用业务逻辑挂钩

	- 5.比node原生的MongoDB驱动更容易

- 新对象

	- Schema:模式对象

		- Schema对象定义约束了数据库中的文档结构

	- Model:模型

		- Model对象作为集合中的所有文档的表示，相当于MongoDB数据库中的集合collection

	- Document

		- Document表示集合中的具体文档，相当于集合中的一个具体的文档

			- 结合中的元素

- 是一个第三方包

	- 1.下载安装Mongoose：npm i mongoose --save

	- 2.项目中引入mongoose：const mongoose = require('mongoose')

	- 3.连接MongoDB数据库：mongoose.connect('mongodb://localhost/test', {userMongoclient:true});

- 特点：

	- 通过关系型数据的思想来设计非关系型数据库

	- 基于mongodb驱动，简化操作

- 定义Schema

	- 相当于集合

	- 但是不能操作数据库

	- 需要定义model，才能操作数据库

- Schema的静态方法

	- // 静态方法
Resource.static.findByProject = function (project, cb) {
  this.find({ project }, function (err, docs) {
    cb(err, docs)
  })
}

- Schema的实例方法

	- // 实例方法
Resource.methods.print = function () {
  console.log('我是一个实例方法')
  console.log(this.name) // 实例中传递的name
  // const instance = new ResourceModel({name: "xxx"})
}

### 36.6.4. [推荐文章地址](https://cloud.tencent.com/developer/article/1683003)

## 36.7. standard

### 36.7.1. w3c/DOM/BOM/XHTML/JSON/JSONP

### 36.7.2. HTML5/CSS3

### 36.7.3. ECMAScript3/ECMAScript5

- 语法

- 宿主对象

- 原型链 继承

- 上下文环境 context

- 作用域 闭包

- 正则表达式

- 严格模式

### 36.7.4. CommonJS/AMD

### 36.7.5. HTTP1.1

## 36.8. nodejs

### 36.8.1. [nodejs相关的文档](https://note.youdao.com/s/FfQ6pyVx)

- [node官方入门教程](http://nodejs.cn/learn/nodejs-buffers)

- [「万字整理 」这里有一份Node.js入门指南和实践,请注意查收 ❤️ - 掘金 (juejin.cn)](https://juejin.cn/post/6844904029219192839)

- [webfansplz/article: record and share (github.com)](https://github.com/webfansplz/article)

- [NodeJS 文件操作 —— fs 基本使用 - _成飞 - 博客园 (cnblogs.com)   (fs讲得很好)](https://www.cnblogs.com/sttchengfei/p/13564618.html)

- [Node.js 流（stream）：你需要知道的一切 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/36728655)

- [(51条消息) Node.js stream模块（四）双工流和转换流_伏城之外的博客-CSDN博客_nodejs 转换流](https://blog.csdn.net/qfc_128220/article/details/122667490)

- [(51条消息) Node 学习七、核心模块 stream之 01 Stream 流、Nodejs 中流的类型_皮蛋很白的博客-CSDN博客](https://blog.csdn.net/u012961419/article/details/121534329)

### 36.8.2. 自带模块

- http

- path

	- 获取路径/文件名/扩展名

		- 获取路径：path.dirname(filepath)

		- 获取文件名：path.basename(filepath)

		- 获取扩展名：path.extname(filepath)

	- 获取所在路径

	  var path = require('path');
	  var filepath = '/tmp/demo/js/test.js';
	  
	  // 输出：/tmp/demo/js
	  console.log( path.dirname(filepath) );
	  
	  
	- 获取文件名

	  严格意义上来说，path.basename(filepath) 只是输出路径的最后一部分，并不会判断是否文件名。
	  
	  
	  但大部分时候，我们可以用它来作为简易的“获取文件名“的方法。
	  
	  
	  var path = require('path');
	  
	  // 输出：test.js
	  console.log( path.basename('/tmp/demo/js/test.js') );
	  
	  // 输出：test
	  console.log( path.basename('/tmp/demo/js/test/') );
	  
	  // 输出：test
	  console.log( path.basename('/tmp/demo/js/test') );
	  如果只想获取文件名，单不包括文件扩展呢？可以用上第二个参数。
	  
	  // 输出：test
	  console.log( path.basename('/tmp/demo/js/test.js', '.js') );
	  
	- 获取文件扩展名

	  var path = require('path');
	  var filepath = '/tmp/demo/js/test.js';
	  
	  // 输出：.js
	  console.log( path.extname(filepath) );
	  
	  
- url

- fs

	- mkdirp

		- mkdirp这是一款在node.js中像mkdir -p一样递归创建目录及其子目录

		- [地址](https://www.cnblogs.com/jiaoshou/p/12187136.html)

		-  mkdirp.sync(path.dirname(targetFile))

	- rimraf

		- rimraf.sync(resPath)

		- The UNIX command rm -rf for node

		- [地址](https://github.com/isaacs/rimraf)

	- fs.mkdirSync(path[, options])

		-  
![image](assets/d3896406e04fc2c356a3c58e452c66d34e1d731427547afc6e0e2e053f827de0.png)

		- [地址](http://nodejs.cn/api/fs.html#fs_fs_mkdirsync_path_options)

		- fs.mkdirSync(dirname, { recursive: true }); 要求nodejs在10版本以上才支持recursive配置

- child_process

	- 事件
![image](assets/02e377592bca9a7d519f213735d0d901cc8cd6aa678710bd262a1ebc204883cc.png)

	- 四个方法

		- exec

			- exec：调用 shell 来执行命令的。这部分跟「exec」这个词的 UNIX/C 语义刚好相反。

			- 子进程执行的是非node程序，传入一串shell命令，执行后结果以回调的形式返回，与execFile不同的是exec可以直接执行一串shell命令

			- 安全性分析

				- 像exec那样，可以直接执行一段shell是极为不安全的，比如有这么一段shell：
echo hello world;rm -rf

					- 通过exec是可以直接执行的，rm -rf会删除当前目录下的文件。exec正如命令行一样，执行的等级很高，执行后会出现安全性的问题，而execFile不同

					- execFile('echo',['hello','world',';rm -rf'])
在传入参数的同时，会检测传入实参执行的安全性，如果存在安全性问题，会抛出异常。除了execFile外，spawn和fork也都不能直接执行shell，因此安全性较高。

			- 通过exec来实现

				- let cp=require('child_process');
cp.exec('echo hello world',function(err,stdout){
  console.log(stdout);
});

				- 执行这个main.js，结果会输出hello world。我们发现exec的第一个参数，跟shell命令完全相似。

		- execFile

			- execFile：不调用 shell，直接执行命令。这命名不明所以

			- 子进程中执行的是非node程序，提供一组参数后，执行的结果以回调的形式返回。

			- 通过execFile来实现

				- let cp=require('child_process');
cp.execFile('echo',['hello','world'],function(err,stdout){
   console.log(stdout);
});

				- execFile类似于执行了名为echo的应用，然后传入参数。execFlie会在process.env.PATH的路径中依次寻找是否有名为'echo'的应用，找到后就会执行。默认的process.env.PATH路径中包含了'usr/local/bin',而这个'usr/local/bin'目录中就存在了这个名为'echo'的程序，传入hello和world两个参数，执行后返回。

		- fork

			- fork：执行一个新的 nodejs 进程，并且建立一个专用的 IPC 通道。子进程除了 IPC 通道外与父进程无任何瓜葛！命名真是一如既往地误人子弟。默认使用与父进程相同的可执行文件（nodejs 版本），也可以另外指定。

			- 子进程执行的是node程序，提供一组参数后，执行的结果以流的形式返回，与spawn不同，fork生成的子进程只能执行node应用。

			- 在javascript中，在处理大量计算的任务方面，HTML里面通过web work来实现，使得任务脱离了主线程。
在node中使用了一种内置于父进程和子进程之间的通信来处理该问题，降低了大数据运行的压力。node中提供了fork方法，通过fork方法在单独的进程中执行node程序，并且通过父子间的通信，子进程接受父进程的信息，并将执行后的结果返回给父进程。
使用fork方法，可以在父进程和子进程之间开放一个IPC通道，使得不同的node进程间可以进行消息通信。

		- spawn

			- spawn：相当于 Python 的 subprocess，可以指定是否使用 shell。默认不使用 shell。也支持 cwd 啊 env 啊 argv0 啊之类的参数。

			- 子进程中执行的是非node程序，提供一组参数后，执行的结果以流的形式返回。

			- spawn同样是用于执行非node应用，且不能直接执行shell，与execFile相比，spawn执行应用后的结果并不是执行完成后，一次性的输出的，而是以流的形式输出。对于大批量的数据输出，通过流的形式可以介绍内存的使用。

				- 我们用一个文件的排序和去重来举例
![image](assets/298a97b65f4797d98ae14a4c27df1b6c7bbbd75c11bc5d3928063e2ee0e2c031.png)

					- 上述图片示意图中，首先读取的input.txt文件中有acba未经排序的文字，通过sort程序后可以实现排序功能，输出为aabc，最后通过uniq程序可以去重，得到abc。我们可以用spawn流形式的输入输出来实现上述功能

					- let cp=require('child_process');
let cat=cp.spawn('cat',['input.txt']);
let sort=cp.spawn('sort');
let uniq=cp.spawn('uniq');

cat.stdout.pipe(sort.stdin);
sort.stdout.pipe(uniq.stdin);
uniq.stdout.pipe(process.stdout);
console.log(process.stdout);

					- 执行后，最后的结果将输入到process.stdout中。如果input.txt这个文件较大，那么以流的形式输入输出可以明显减小内存的占用，通过设置缓冲区的形式，减小内存占用的同时也可以提高输入输出的效率。

		- 四个方法的区别
![image](assets/6a3afa74b1b66456f47d65f4cb0bfff6fff895308a3b497e4afdc6458864b08f.png)

	- 文章

		- nodejs中的子进程，深入解析child_process模块和cluster模块

			- [地址](https://segmentfault.com/a/1190000016169207)

- cluster

- stream

	- 可写事件
![image](assets/126805334a5d238f67550c642dc0ed1263e70fc648140a0d0c9df69bcc332246.png)

	- 可读流事件
![image](assets/496adb6780c262e09f29d6d4c0b589b4f9111c19ac84e7c1c8e49ef391c1f767.png)

### 36.8.3. 其他模块

- backbone

- express

- fs-extra

	- [地址](https://www.jianshu.com/p/d6990a03d610?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

	- 文件操作相关工具库
fs-extra模块是系统fs模块的扩展，提供了更多便利的 API，并继承了fs模块的 API

	- 项目地址：

		- [github(fs-extra)](https://github.com/jprichardson/node-fs-extra)

	- 安装：
npm install --save-dev fs-extra

	- 使用：
var fse = require('fs-extra')

		- 1. copy 复制文件
copy(src, dest, [option],callback)

		- 2. emptyDir 清空目录
异步:
emptydir()
同步:
emptyDirSync(), emptydirSync()

		- 3. ensureFile 创建文件
确保文件存在。如果被请求的文件的目录不存在,创建这些目录。如果文件已经存在,它不修改。
异步:
createFile()
同步:
createFileSync(),ensureFileSync()

		- 4. ensureDir 创建目录
确保目录的存在。如果目录结构不存在,就创建一个。
**同步: **
ensureDirSync()

- got

	- npm install got

	- const got = require('got');
(async () => {
    try {
        const response = await got('sindresorhus.com');
        console.log(response.body);
        //=> '<!doctype html> ...'
    } catch (error) {
        console.log(error.response.body);
        //=> 'Internal server error ...'
    }
})();

- env-cmd

	- [npm地址](https://www.npmjs.com/package/env-cmd)

	- 例子图示：env-cmd自动读取.env.js中的export.modules中的导出的环境变量
![image](assets/9bdf5c1560c48b0c263bf81c478e7a19696e5e25b8c86f170e8b488f34b24e3a.png)

### 36.8.4. [Koa2](https://blog.poetries.top/node-learning-notes/notes/koa2/-1.0%20koa2%E6%A6%82%E8%A7%88%E7%AF%87.html#%E4%B8%80%E3%80%81%E5%9F%BA%E6%9C%AC%E7%94%A8%E6%B3%95)

一种说法：Koa是从第一个中间件开始执行,遇到 await next() 就进入下一个中间件，一直到执行到最后一个中间件。然后再逆序执行上一个中间件 await next() 后面的代码，一直到第一个中间件 await next() 后面的代码执行完毕才发出响应。



另一种说法：app.use 第一个use的 就是最外层的 最外层的用来try catch 错误比较靠谱


还有一种说法：
多个中间件会形成一个栈结构（middle stack），以"先进后出"（first-in-last-out）的顺序执行
最外层的中间件首先执行。
调用next函数，把执行权交给下一个中间件。
...
最内层的中间件最后执行。
执行结束后，把执行权交回上一层的中间件。
...
最外层的中间件收回执行权之后，执行next函数后面的代码


### 36.8.5. npm/npx

npm的m是Management，npx的x可以理解为eXecute。

当执行npx xxx的时候，npx先看xxxz在$PATH里有没有，如果没有，找当前目录的node_modules里有没有，如果还是没有，就安装这个xxx 来执行。

npx也可以理解为少些package.json里一个script而诞生的。

### 36.8.6. log工具

- [morgan](https://www.npmjs.com/package/morgan)

### 36.8.7. [redis](https://blog.csdn.net/hzlarm/article/details/99432240)

- [service redis-server restart](https://zhuanlan.zhihu.com/p/28101275)

- redis-cli

### 36.8.8. nginx配置同域联调

- 安装：apt-get install nginx

- nginx -t 测试配置文件格式是否正确

- 启动nginx

- 重启nginx -s reload

- 停止nginx -s stop

- 代理

### 36.8.9. 撸demo

- sina

	- 框架：koa2-ejs-jest
存储：mysql-sequelize-连表&多模型
用户认证：session-redis-jwt
线上环境：pm2-nginx-日志

	  ￼
	  
	  ￼
	  
	  ￼
	  
	  ￼
	  
	  ￼
	  
	  ￼
	  
	  
	  
		- sina项目搭建

		-     npm i koa-generator

		-     koa2 -e sina

		-     npm i

		-     npm i cross-env -D

	- nodejs

		- 安装依赖

			- [安装mysql
启动service
查看是否启动了](https://dev.mysql.com/doc/)

				- linux上安装mysql
apt-get install sql-server
service mysql start

				-  ps -ef | grep mysql

			- [npm i -S npm i -D](https://www.cnblogs.com/cina33blogs/p/9210931.html)

			  
			    i 是install 的简写
			  
			  
			  -S就是--save的简写
			  -D就是--save-dev 这样安装的包的名称及版本号就会存在package.json的devDependencies这个里面，而--save会将包的名称及版本号放在dependencies里面。
			  
			  
			  我们在使用npm install 安装模块或插件的时候，有两种命令把他们写入到 package.json 文件里面去，比如：
			  
			  
			  --save-dev
			  
			  
			  --save
			  
			  
			  在 package.json 文件里面提现出来的区别就是，使用 --save-dev 安装的 插件，被写入到 devDependencies 对象里面去，而使用 --save 安装的插件，责被写入到 dependencies 对象里面去。
			  
			  
			  那 package.json 文件里面的 devDependencies  和 dependencies 对象有什么区别呢？
			  
			  
			  devDependencies  里面的插件只用于开发环境，不用于生产环境，而 dependencies  是需要发布到生产环境的。
			  
			  
			- npm install express -S

			- npm install nodemon -D

			- npm install nvm -D

			- npm install nrm -D

			- npm install --save mysql2

				- 安装对应数据库驱动

			- [npm install --save sequelize](http://sequelize是node操作mysql的一款npm包，包含很多特性：数据库模型映射、事务处理、模型属性校验、关联映射等，花了两天时间学习了下基本的一些操作，特别是关联映射部分的操作，包含1:1、1:N、N:N部分，利用express框架实现简单的rest服务。)

				- 基于Promise的ORM(Object Relation Mapping)，支持多种数据库、事务、关联等

		- [mysql](https://www.runoob.com/mysql/mysql-administration.html)

			- 一个报错浪费了本人一天半的时间：
auth_socket 导致 Access denied for user 'root'@'localhost'

				- [update user set plugin="mysql_native_password" where user='root';
](https://blog.csdn.net/weixin_43424368/article/details/109600313)

		- postman

			- [遇到一个问题：
使用body传参时，raw格式时，需要设置格式为json](https://www.cnblogs.com/zzcyeah/p/10341856.html)

- ejs 服务端模板引擎

  ￼
  ￼
  
  ￼
  
  ￼
  
  
	-         await ctx.reader('index', {title: 'Hollo Koa 2!', msg: '你好'})
        <p><%= msg %></p>
        

- 项目目录整理

### 36.8.10. nodejs 断点调试代码

- 1. node --inspect-brk="127.0.0.1:9222" bin/Incremental-patch.js

- 2. edge://inspect/#devices

- 3. 
![image](assets/fe528b65a5df800ba0cab046139d2df6c7d76fdcf7d85acbbb3d17cd693bf349.png)

- 4. 
![image](assets/174aed1879d7c464ed857d0f6e13abb63a699443f859e938118c2fd42dabe2a9.png)

### 36.8.11. multer

### 36.8.12. tmp

### 36.8.13. po

- PO 是 Portable Object (可移植对象)的缩写形式。

PO文件是面向翻译人员的、提取于源代码的一种资源文件。当软件升级的时候，通过使用gettext软件包处理 PO文件，可以在一定程度上使翻译成果得以继承，减轻翻译人员的负担。

### 36.8.14. md5

- linux:md5sum

### 36.8.15. NODE_ENV不是内部或外部命令,也不是可运行的程序

- [地址：](https://blog.csdn.net/koufulong/article/details/75270337)

### 36.8.16. other

- 自带模块

	- http

	- path

		- 获取路径/文件名/扩展名

			- 获取路径：path.dirname(filepath)

			- 获取文件名：path.basename(filepath)

			- 获取扩展名：path.extname(filepath)

		- 获取所在路径

		  var path = require('path');
		  var filepath = '/tmp/demo/js/test.js';
		  
		  // 输出：/tmp/demo/js
		  console.log( path.dirname(filepath) );
		  
		  
		- 获取文件名

		  严格意义上来说，path.basename(filepath) 只是输出路径的最后一部分，并不会判断是否文件名。
		  
		  
		  但大部分时候，我们可以用它来作为简易的“获取文件名“的方法。
		  
		  
		  var path = require('path');
		  
		  // 输出：test.js
		  console.log( path.basename('/tmp/demo/js/test.js') );
		  
		  // 输出：test
		  console.log( path.basename('/tmp/demo/js/test/') );
		  
		  // 输出：test
		  console.log( path.basename('/tmp/demo/js/test') );
		  如果只想获取文件名，单不包括文件扩展呢？可以用上第二个参数。
		  
		  // 输出：test
		  console.log( path.basename('/tmp/demo/js/test.js', '.js') );
		  
		- 获取文件扩展名

		  var path = require('path');
		  var filepath = '/tmp/demo/js/test.js';
		  
		  // 输出：.js
		  console.log( path.extname(filepath) );
		  
		  
	- url

	- fs

		- mkdirp

			- mkdirp这是一款在node.js中像mkdir -p一样递归创建目录及其子目录

			- [地址](https://www.cnblogs.com/jiaoshou/p/12187136.html)

			-  mkdirp.sync(path.dirname(targetFile))

		- rimraf

			- rimraf.sync(resPath)

			- The UNIX command rm -rf for node

			- [地址](https://github.com/isaacs/rimraf)

		- fs.mkdirSync(path[, options])

			-  
![image](assets/d3896406e04fc2c356a3c58e452c66d34e1d731427547afc6e0e2e053f827de0.png)

			- [地址](http://nodejs.cn/api/fs.html#fs_fs_mkdirsync_path_options)

			- fs.mkdirSync(dirname, { recursive: true }); 要求nodejs在10版本以上才支持recursive配置

	- child_process

		- 事件
![image](assets/02e377592bca9a7d519f213735d0d901cc8cd6aa678710bd262a1ebc204883cc.png)

		- 四个方法

			- exec

				- exec：调用 shell 来执行命令的。这部分跟「exec」这个词的 UNIX/C 语义刚好相反。

				- 子进程执行的是非node程序，传入一串shell命令，执行后结果以回调的形式返回，与execFile不同的是exec可以直接执行一串shell命令

				- 安全性分析

					- 像exec那样，可以直接执行一段shell是极为不安全的，比如有这么一段shell：
echo hello world;rm -rf

						- 通过exec是可以直接执行的，rm -rf会删除当前目录下的文件。exec正如命令行一样，执行的等级很高，执行后会出现安全性的问题，而execFile不同

						- execFile('echo',['hello','world',';rm -rf'])
在传入参数的同时，会检测传入实参执行的安全性，如果存在安全性问题，会抛出异常。除了execFile外，spawn和fork也都不能直接执行shell，因此安全性较高。

				- 通过exec来实现

					- let cp=require('child_process');
cp.exec('echo hello world',function(err,stdout){
  console.log(stdout);
});

					- 执行这个main.js，结果会输出hello world。我们发现exec的第一个参数，跟shell命令完全相似。

			- execFile

				- execFile：不调用 shell，直接执行命令。这命名不明所以

				- 子进程中执行的是非node程序，提供一组参数后，执行的结果以回调的形式返回。

				- 通过execFile来实现

					- let cp=require('child_process');
cp.execFile('echo',['hello','world'],function(err,stdout){
   console.log(stdout);
});

					- execFile类似于执行了名为echo的应用，然后传入参数。execFlie会在process.env.PATH的路径中依次寻找是否有名为'echo'的应用，找到后就会执行。默认的process.env.PATH路径中包含了'usr/local/bin',而这个'usr/local/bin'目录中就存在了这个名为'echo'的程序，传入hello和world两个参数，执行后返回。

			- fork

				- fork：执行一个新的 nodejs 进程，并且建立一个专用的 IPC 通道。子进程除了 IPC 通道外与父进程无任何瓜葛！命名真是一如既往地误人子弟。默认使用与父进程相同的可执行文件（nodejs 版本），也可以另外指定。

				- 子进程执行的是node程序，提供一组参数后，执行的结果以流的形式返回，与spawn不同，fork生成的子进程只能执行node应用。

				- 在javascript中，在处理大量计算的任务方面，HTML里面通过web work来实现，使得任务脱离了主线程。
在node中使用了一种内置于父进程和子进程之间的通信来处理该问题，降低了大数据运行的压力。node中提供了fork方法，通过fork方法在单独的进程中执行node程序，并且通过父子间的通信，子进程接受父进程的信息，并将执行后的结果返回给父进程。
使用fork方法，可以在父进程和子进程之间开放一个IPC通道，使得不同的node进程间可以进行消息通信。

			- spawn

				- spawn：相当于 Python 的 subprocess，可以指定是否使用 shell。默认不使用 shell。也支持 cwd 啊 env 啊 argv0 啊之类的参数。

				- 子进程中执行的是非node程序，提供一组参数后，执行的结果以流的形式返回。

				- spawn同样是用于执行非node应用，且不能直接执行shell，与execFile相比，spawn执行应用后的结果并不是执行完成后，一次性的输出的，而是以流的形式输出。对于大批量的数据输出，通过流的形式可以介绍内存的使用。

					- 我们用一个文件的排序和去重来举例
![image](assets/298a97b65f4797d98ae14a4c27df1b6c7bbbd75c11bc5d3928063e2ee0e2c031.png)

						- 上述图片示意图中，首先读取的input.txt文件中有acba未经排序的文字，通过sort程序后可以实现排序功能，输出为aabc，最后通过uniq程序可以去重，得到abc。我们可以用spawn流形式的输入输出来实现上述功能

						- let cp=require('child_process');
let cat=cp.spawn('cat',['input.txt']);
let sort=cp.spawn('sort');
let uniq=cp.spawn('uniq');

cat.stdout.pipe(sort.stdin);
sort.stdout.pipe(uniq.stdin);
uniq.stdout.pipe(process.stdout);
console.log(process.stdout);

						- 执行后，最后的结果将输入到process.stdout中。如果input.txt这个文件较大，那么以流的形式输入输出可以明显减小内存的占用，通过设置缓冲区的形式，减小内存占用的同时也可以提高输入输出的效率。

			- 四个方法的区别
![image](assets/6a3afa74b1b66456f47d65f4cb0bfff6fff895308a3b497e4afdc6458864b08f.png)

		- 文章

			- nodejs中的子进程，深入解析child_process模块和cluster模块

				- [地址](https://segmentfault.com/a/1190000016169207)

	- cluster

	- stream

		- 可写事件
![image](assets/126805334a5d238f67550c642dc0ed1263e70fc648140a0d0c9df69bcc332246.png)

		- 可读流事件
![image](assets/496adb6780c262e09f29d6d4c0b589b4f9111c19ac84e7c1c8e49ef391c1f767.png)

- 其他模块

	- backbone

	- express

	- fs-extra

		- [地址](https://www.jianshu.com/p/d6990a03d610?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

		- 文件操作相关工具库
fs-extra模块是系统fs模块的扩展，提供了更多便利的 API，并继承了fs模块的 API

		- 项目地址：

			- [github(fs-extra)](https://github.com/jprichardson/node-fs-extra)

		- 安装：
npm install --save-dev fs-extra

		- 使用：
var fse = require('fs-extra')

			- 1. copy 复制文件
copy(src, dest, [option],callback)

			- 2. emptyDir 清空目录
异步:
emptydir()
同步:
emptyDirSync(), emptydirSync()

			- 3. ensureFile 创建文件
确保文件存在。如果被请求的文件的目录不存在,创建这些目录。如果文件已经存在,它不修改。
异步:
createFile()
同步:
createFileSync(),ensureFileSync()

			- 4. ensureDir 创建目录
确保目录的存在。如果目录结构不存在,就创建一个。
**同步: **
ensureDirSync()

	- got

		- npm install got

		- const got = require('got');
(async () => {
    try {
        const response = await got('sindresorhus.com');
        console.log(response.body);
        //=> '<!doctype html> ...'
    } catch (error) {
        console.log(error.response.body);
        //=> 'Internal server error ...'
    }
})();

- [Koa2](https://blog.poetries.top/node-learning-notes/notes/koa2/-1.0%20koa2%E6%A6%82%E8%A7%88%E7%AF%87.html#%E4%B8%80%E3%80%81%E5%9F%BA%E6%9C%AC%E7%94%A8%E6%B3%95)

  一种说法：Koa是从第一个中间件开始执行,遇到 await next() 就进入下一个中间件，一直到执行到最后一个中间件。然后再逆序执行上一个中间件 await next() 后面的代码，一直到第一个中间件 await next() 后面的代码执行完毕才发出响应。
  
  
  
  另一种说法：app.use 第一个use的 就是最外层的 最外层的用来try catch 错误比较靠谱
  
  
  还有一种说法：
  多个中间件会形成一个栈结构（middle stack），以"先进后出"（first-in-last-out）的顺序执行
  最外层的中间件首先执行。
  调用next函数，把执行权交给下一个中间件。
  ...
  最内层的中间件最后执行。
  执行结束后，把执行权交回上一层的中间件。
  ...
  最外层的中间件收回执行权之后，执行next函数后面的代码
  
  
- npm/npx

  npm的m是Management，npx的x可以理解为eXecute。
  
  当执行npx xxx的时候，npx先看xxxz在$PATH里有没有，如果没有，找当前目录的node_modules里有没有，如果还是没有，就安装这个xxx 来执行。
  
  npx也可以理解为少些package.json里一个script而诞生的。
  
- log工具

	- [morgan](https://www.npmjs.com/package/morgan)

- [redis](https://blog.csdn.net/hzlarm/article/details/99432240)

	- [service redis-server restart](https://zhuanlan.zhihu.com/p/28101275)

	- redis-cli

- nginx配置同域联调

	- 安装：apt-get install nginx

	- nginx -t 测试配置文件格式是否正确

	- 启动nginx

	- 重启nginx -s reload

	- 停止nginx -s stop

	- 代理

- 撸demo

	- sina

		- 框架：koa2-ejs-jest
存储：mysql-sequelize-连表&多模型
用户认证：session-redis-jwt
线上环境：pm2-nginx-日志

		  ￼
		  
		  ￼
		  
		  ￼
		  
		  ￼
		  
		  ￼
		  
		  ￼
		  
		  
		  
			- sina项目搭建

			-     npm i koa-generator

			-     koa2 -e sina

			-     npm i

			-     npm i cross-env -D

		- nodejs

			- 安装依赖

				- [安装mysql
启动service
查看是否启动了](https://dev.mysql.com/doc/)

					- linux上安装mysql
apt-get install sql-server
service mysql start

					-  ps -ef | grep mysql

				- [npm i -S npm i -D](https://www.cnblogs.com/cina33blogs/p/9210931.html)

				  
				    i 是install 的简写
				  
				  
				  -S就是--save的简写
				  -D就是--save-dev 这样安装的包的名称及版本号就会存在package.json的devDependencies这个里面，而--save会将包的名称及版本号放在dependencies里面。
				  
				  
				  我们在使用npm install 安装模块或插件的时候，有两种命令把他们写入到 package.json 文件里面去，比如：
				  
				  
				  --save-dev
				  
				  
				  --save
				  
				  
				  在 package.json 文件里面提现出来的区别就是，使用 --save-dev 安装的 插件，被写入到 devDependencies 对象里面去，而使用 --save 安装的插件，责被写入到 dependencies 对象里面去。
				  
				  
				  那 package.json 文件里面的 devDependencies  和 dependencies 对象有什么区别呢？
				  
				  
				  devDependencies  里面的插件只用于开发环境，不用于生产环境，而 dependencies  是需要发布到生产环境的。
				  
				  
				- npm install express -S

				- npm install nodemon -D

				- npm install nvm -D

				- npm install nrm -D

				- npm install --save mysql2

					- 安装对应数据库驱动

				- [npm install --save sequelize](http://sequelize是node操作mysql的一款npm包，包含很多特性：数据库模型映射、事务处理、模型属性校验、关联映射等，花了两天时间学习了下基本的一些操作，特别是关联映射部分的操作，包含1:1、1:N、N:N部分，利用express框架实现简单的rest服务。)

					- 基于Promise的ORM(Object Relation Mapping)，支持多种数据库、事务、关联等

			- [mysql](https://www.runoob.com/mysql/mysql-administration.html)

				- 一个报错浪费了本人一天半的时间：
auth_socket 导致 Access denied for user 'root'@'localhost'

					- [update user set plugin="mysql_native_password" where user='root';
](https://blog.csdn.net/weixin_43424368/article/details/109600313)

			- postman

				- [遇到一个问题：
使用body传参时，raw格式时，需要设置格式为json](https://www.cnblogs.com/zzcyeah/p/10341856.html)

	- ejs 服务端模板引擎

	  ￼
	  ￼
	  
	  ￼
	  
	  ￼
	  
	  
		-         await ctx.reader('index', {title: 'Hollo Koa 2!', msg: '你好'})
        <p><%= msg %></p>
        

	- 项目目录整理

- nodejs 断点调试代码

	- 1. node --inspect-brk="127.0.0.1:9222" bin/Incremental-patch.js

	- 2. edge://inspect/#devices

	- 3. 
![image](assets/fe528b65a5df800ba0cab046139d2df6c7d76fdcf7d85acbbb3d17cd693bf349.png)

	- 4. 
![image](assets/174aed1879d7c464ed857d0f6e13abb63a699443f859e938118c2fd42dabe2a9.png)

### 36.8.17. C语言简介

### 36.8.18. libuv

### 36.8.19. v8

### 36.8.20. 安装nvm

-  
![image](assets/20739dcc9c8c9494f156b087aa1b26431ce8e6511097d753db3341b625d37e8b.png)

### 36.8.21. commonjs模块化标准

- demo目录
~/Github/commonjs-test

### 36.8.22. debugger-test

- vscode
debugger模块还不会用

### 36.8.23. 考虑cpu和内存

-  
![image](assets/8889eede5043c3872f02764f27f8a95c7ee174bdbc294bc4d6adc23a2668a1d6.png)

### 36.8.24. 日志记录

-  
![image](assets/96741067a526957d1246c77078e1d7ee373e3926ca0cb67296339521ffd6cbbc.png)

### 36.8.25. 接口设计

-  
![image](assets/5df7f83793d5522bd82424a86abd73a5e3a7e85723aa1e41f0745069132d028e.png)

### 36.8.26. 登录

-  
![image](assets/75cfe7d8c92490b98fbc81f10cd1edae4e8ef49c9f2367f5fd430de2fcc268f9.png)

### 36.8.27. http请求

-  
![image](assets/f65d0da9402cd30ab099b3f9aac7070376c74b155399e1bcae6295d7cda91623.png)

### 36.8.28. 请求解析

-  
![image](assets/0b285784769311301841425a250d208fe3e8d5b16ac2e19b826ae771a0cee5d5.png)

### 36.8.29. http服务器

- get请求

	-  
![image](assets/d97a0e4e869ce76a5333315cccfbb0cf479aae88b59f585890050967fa233aa4.png)

		- 浏览器默认的一个请求

- post请求

	-  
![image](assets/b31cc495955166a54f7d5d1d69293a4812ba899007b7de7feb4b74ebd407abf0.png)

		-  
![image](assets/a779398e811841ef2caef9eb3b2b8e7af7295e5b9480b3f8e6f5a8e028a18aef.png)

		-  
![image](assets/08946d39263494ae0e444f5e14c4afc79e2012adbb3ae840fbf46aeab3f255d4.png)

### 36.8.30. nodejs 处理路由

-  
![image](assets/f3cff2b27c6d0a6766ef7bd34ebc3c5d5b3bb1aab14e5c8436ffe7ad49fed17d.png)

### 36.8.31. [cross-env](https://blog.csdn.net/qq_39143170/article/details/105531560)

- cross-env使得您可以使用单个命令，而不必担心为平台正确设置或使用环境变量。 只要在POSIX系统上运行就可以设置好，而cross-env将会正确地设置它。

说人话: 这个迷你的包(cross-env)能够提供一个设置环境变量的scripts，让你能够以unix方式设置环境变量，然后在windows上也能兼容运行。

## 36.9. other side

### 36.9.1. 英语

- 编程命名

	- 命名缩写

	  A
	  
	  常用编程变量命名英文缩写
	  
	  addr = address
	   app = application
	   arg = argument
	   asm = assemble
	   asyn = asynchronization
	   auth = authorization / authentication
	   avg = average
	  
	  
	  B
	  
	  
	  buf = buffer
	  
	  
	  C
	  
	  
	  calc = calculate
	   cert = certificate
	   cmd = command
	   cmp = compare
	   col = column
	   coord = coordinates
	   cur = current
	  
	  
	  D
	  
	  
	  db = database
	   dec = decrease
	   del = delete
	   dest / dst = destination
	   dev = device
	   dict = dictionary
	   diff = different
	   dir = directory
	   disp = display
	   dlg = dialog
	   doc = document
	   drv = driver
	  
	  
	  E
	  
	  
	  env = environment
	   err = error
	   esc = escape
	   ext = extension
	   exec = execute
	  
	  
	  F
	  
	  
	  frm = frame
	   func / fn = function
	  
	  
	  G
	  
	  
	  grp = group
	  
	  
	  H
	  
	  
	  horz = horizontal
	  
	  
	  I
	  
	  
	  idx = index
	   img = image
	   inc = increase
	   info = information
	   init = initial/initialize/initialization
	   ins = insert
	   inst = instance
	   intr = interrupt
	   i18n = internationalization
	  
	  
	  L
	  
	  
	  lang = language
	   len = length
	   lib = library
	   lst = list
	  
	  
	  M
	  
	  
	  max = maximum
	   mem = memory
	   mid = middle
	   min = minimum
	   msg = message
	   mul = multiply
	  
	  
	  N
	  
	  
	  num = number
	  
	  
	  O
	  
	  
	  obj = object
	   ofs = offset
	   org = origin
	  
	  
	  P
	  
	  
	  param = parameter
	   pic = picture
	   pkg = package
	   pos = position
	   prev = previous
	   prg = program
	   proc = process / procedure
	   prop = properties
	   psw = password
	   ptr = pointer
	   pub = public
	  
	  
	  R
	  
	  
	  ref = reference
	   reg = register
	   req = request
	   resp = response
	   res = result
	   ret = return
	   rgn = region
	   rsrc = resource
	  
	  
	  S
	  
	  
	  scr = screen
	   sec = second
	   seg = segment
	   sel = select
	   src = source
	   std = standard
	   stm = stream
	   str = string
	   sub = subtract
	   sum = summation
	   svr = server
	   sync = synchronization
	   sys = system
	  
	  T
	  tmp / temp = temporary
	   tran / trans = translate/transation/transparent
	   txt = text
	  U
	  upd = update
	   upg = upgrade
	   util = utility
	  V
	  var = variable
	   ver = version
	   vert = vertical
	  
	  W
	  wnd = window
	  
	  
	- 命名技巧

	  总的来说，就是英文字母大小写、数字、下划线（_）按照一定的规则搭配，自己比较喜欢的是帕斯卡（pascal）命名法和下划线命名法则。
	  
	  
	  1 三种流行的命名法则
	  
	  目前，业界共有四种命名法则：驼峰命名法、匈牙利命名法、帕斯卡命名法和下划线命名法，其中前三种是较为流行的命名法。
	  
	  
	  (1)驼峰命令法。 正如它的名称所表示的那样，是指混合使用大小写字母来构成变量和函数的名字。例如，下面是分别用骆驼式命名法和下划线法命名的同一个函数：
	  printEmployeePaychecks()；
	  print_employee_paychecks()；
	  
	  第一个函数名使用了驼峰命名法，函数名中的每一个逻辑断点都有一个大写字母来标记。第二个函数名使用了下划线法，函数名中的每一个逻辑断点都有一个下划线来标记。
	  
	  驼峰命名法近年来越来越流行了，在许多新的函数库和Microsoft Windows这样的环境中，它使用得当相多。另一方面，下划线法是C出现后开始流行起来的，在许多旧的程序和UNIX这样的环境中，它的使用非常普遍。
	  
	  (2)匈牙利命名法。 广泛应用于象Microsoft Windows这样的环境中。Windows 编程中用到的变量(还包括宏)的命名规则为匈牙利命名法，这种命名技术是由一位能干的 Microsoft 程序员查尔斯-西蒙尼(Charles Simonyi) 提出的。
	  
	  匈牙利命名法通过在变量名前面加上相应的小写字母的符号标识作为前缀，标识出变量的作用域、类型等。这些符号可以多个同时使用，顺序是先m_(成员变量)、再指针、再简单数据类型、再其它。这样做的好处在于能增加程序的可读性，便于对程序的理解和维护。
	  
	  例如：m_lpszStr, 表示指向一个以0字符结尾的字符串的长指针成员变量。
	  匈牙利命名法关键是：标识符的名字以一个或者多个小写字母开头作为前缀；前缀之后的是首字母大写的一个单词或多个单词组合，该单词要指明变量的用途。
	  
	  (3)帕斯卡(pascal)命名法。 与驼峰命名法类似，二者的区别在于：驼峰命名法是首字母小写，而帕斯卡命名法是首字母大写，如：
	  DisplayInfo();
	  stringUserName;
	  二者都是采用了帕斯卡命名法。
	  
	  (4)三种命名规则的小结 ：MyData就是一个帕斯卡命名的示例；myData是一个驼峰命名法,它第一个单词的第一个字母小写,后面的单词首字母大写,看起来像一个骆驼；iMyData是一个匈牙利命名法,它的小写的i说明了它的型态，后面的和帕斯卡命名相同，指示了该变量的用途。
	  2 命名的基本原则
	  
	  (1)标识符的命名要清晰、明了，有明确含义，同时使用完整的单词或大家基本可以理解的缩写，避免使人产生误解——尽量采用采用英文单词或全部中文全拼表示，若出现英文单词和中文混合定义时，使用连字符“_”将英文与中文割开。较短的单词可通过去掉“元音”形成缩写；较长的单词可取单词的头几个字母形成缩写；一些单词有大家公认的缩写。例如：temp->tmp、flag->标志寄存器、statistic->stat、increment->inc、message->msg等缩写能够被大家基本认可。
	  
	  
	  (2)命名中若使用特殊约定或缩写，则要有注释说明。应该在源文件的开始之处，对文件中所使用的缩写或约定，特别是特殊的缩写，进行必要的注释说明。
	  
	  (3)自己特有的命名风格，要自始至终保持一致，不可来回变化。 个人的命名风格，在符合所在项目组或产品组的命名规则的前提下，才可使用。(即命名规则中没有规定到的地方才可有个人命名风格)。
	  
	  (4)对于变量命名，禁止取单个字符(如i 、j 、k... )，建议除了要有具体含义外，还能表明其变量类型、数据类型等，但i 、j 、k 作局部循环变量是允许的。 变量，尤其是局部变量，如果用单个字符表示，很容易敲错(如i写成j)，而编译时又检查不出来，有可能为了这个小小的错误而花费大量的查错时间。
	  
	  (5)除非必要，不要用数字或较奇怪的字符来定义标识符。
	  
	  (6)命名规范必须与所使用的系统风格保持一致，并在同一项目中统一。
	  
	  (7)在同一软件产品内，应规划好接口部分标识符(变量、结构、函数及常量)的命名，防止编译、链接时产生冲突。对接口部分的标识符应该有更严格限制，防止冲突。 如可规定接口部分的变量与常量之前加上“模块”标识等。
	  
	  (8)用正确的反义词组命名具有互斥意义的变量或相**作的函数等。
	  下面是一些在软件中常用的反义词组。
	  add / remove       begin / end        create / destroy
	  insert / delete       first / last         g et / release
	  increment / decrement                 put / get
	  add / delete         lock / unlock      open / close
	  min / max          old / new         start / stop
	  next / previous      source / target     show / hide
	  send / receive       source / destination
	  cut / paste          up / down
	  
	  示例：
	  int  min_sum;
	  int  max_sum;
	  int  add_user( BYTE *user_name );
	  int  delete_user( BYTE *user_name );
	  
	  (9)除了编译开关/ 头文件等特殊应用，应避免使用_EXAMPLE_TEST_ 之类以下划线开始和结尾的定义。
	  3 变量名的命名规则
	  
	  (1)变量的命名规则要求用“匈牙利法则”。（比较难以掌握）
	  
	  即开头字母用变量的类型，其余部分用变量的英文意思、英文的缩写、中文全拼或中文全拼的缩写,要求单词的第一个字母应大写。
	  即： 变量名=变量类型+变量的英文意思(或英文缩写、中文全拼、中文全拼缩写)
	  对非通用的变量，在定义时加入注释说明，变量定义尽量可能放在函数的开始处。
	  见下表：
	  bool 用b开头 b标志寄存器
	  int 用i开头 iCount
	  short int 用n开头 nStepCount
	  long int 用l开头 lSum
	  char  用c开头 cCount
	  unsigned char 用by开头
	  float 用f开头 fAvg
	  double 用d开头 dDeta
	  unsigned int(WORD) 用w开头 wCount
	  unsigned long int(DWORD) 用dw开头 dwBroad
	  字符串 用s开头 sFileName
	  用0结尾的字符串 用sz开头 szFileName
	  
	  (2)指针变量命名的基本原则为：
	  对一重指针变量的基本原则为：“p”+变量类型前缀+命名，如一个float*型应该表示为pfStat。对二重指针变量的基本规则为：“pp”+变量类型前缀+命名。对三重指针变量的基本规则为：“ppp”+变量类型前缀+命名。
	  
	  (3)全局变量用g_开头,如一个全局的长型变量定义为g_lFailCount。
	  
	  即：变量名=g_+变量类型+变量的英文意思(或缩写)。此规则还可避免局部变量和全局变量同名而引起的问题。
	  
	  
	  (4)静态变量用s_开头,如一个静态的指针变量定义为s_plPerv_Inst。
	  
	  即： 变量名=s_+变量类型+变量的英文意思(或缩写)
	  
	  
	  (5)对枚举类型(enum)中的变量，要求用枚举变量或其缩写做前缀。 并且要求用大写。如：
	  enum cmEMDAYS
	  {
	  EMDAYS_MONDAY;
	  EMDAYS_TUESDAY;
	  ……
	  };
	  
	  (6)对struct、union变量的命名要求定义的类型用大写。 并要加上前缀，其内部变量的命名规则与变量命名规则一致。
	  
	  结构一般用S开头，如：
	  struct ScmNPoint
	  {
	  int nX;//点的X位置
	  int nY; //点的Y位置
	  };
	  
	  联合体一般用U开头，如:
	  union UcmLPoint
	  {
	  LONG lX;
	  LONG lY;
	  }
	  
	  (7)对常量(包括错误的编码)命名，要求常量名用大写，常量名用英文表达其意思。
	  
	  当需要由多个单词表示时，单词与单词之间必须采用连字符“_”连接。
	  
	  如：#define CM_FILE_NOT_FOUND CMMAKEHR(0X20B) 其中CM表示类别。
	  
	  (8)对const 的变量要求在变量的命名规则前加入c_。 即：c_+变量命名规则；示例：const char* c_szFileName;
	  4 函数的命名规范
	  
	  (1)函数的命名应该尽量用英文(或英文缩写、中文全拼、中文全拼缩写)表达出函数完成的功能——函数名应准确描述函数的功能。遵循动宾结构的命名法则，函数名中动词在前,并在命名前加入函数的前缀，函数名的长度不得少于8个字母。函数名首字大写，若包含有两个单词的每个单词首字母大写。如果是OOP 方法，可以只有动词(名词是对象本身)。示例：
	  
	  LONG GetDeviceCount(……);
	  void print_record( unsigned int rec_ind ) ;
	  int  input_record( void ) ;
	  unsigned char get_current_color( void ) ;
	  
	  (2)避免使用无意义或含义不清的动词为函数命名。 如使用process、handle等为函数命名，因为这些动词并没有说明要具体做什么。
	  
	  (3)必须使用函数原型声明。 函数原型声明包括：引用外来函数及内部函数，外部引用必须在右侧注明函数来源： 模块名及文件名；内部函数，只要注释其定义文件名——和调用者在同一文件中(简单程序)时不需要注释。
	  应确保每个函数声明中的参数的名称、类型和定义中的名称、类型一致。
	  5 函数参数命名规范 (1)参数名称的命名参照变量命名规范。
	  (2)为了提高程序的运行效率，减少参数占用的堆栈，传递大结构的参数，一律采用指针或引用方式传递。
	  (3)为了便于其他程序员识别某个指针参数是入口参数还是出口参数，同时便于编译器检查错误，应该在入口参数前加入const标志。
	  如：……cmCopyString(const CHAR * c_szSource, CHAR * szDest)
	  6 文件名(包括动态库、组件、控件、工程文件等)的命名规范 文件名的命名要求表达出文件的内容，要求文件名的长度不得少于5个字母，严禁使用象file1,myfile之类的文件名。
	  
	  
	- 常用英文词汇

	  https://segmentfault.com/a/1190000020073758?utm_source=tag-newest
	  文中的单词并没有给出其词性，很多词性的变化需要读者具备一定的英语语法知识，以便在特定情况下灵活运用。
	  
	  数字
	  数字部分包含英文的数字表示、数字运算符、数字单位
	  
	  infinite: 无限的
	  
	  英文数字
	  
	  zero: 零
	  one: 一
	  two: 二
	  three: 三
	  four: 四
	  five: 五
	  six: 六
	  seven: 七
	  eight: 八
	  nine: 九
	  ten: 十
	  eleven: 十一
	  twelve: 十二
	  thirteen: 十三
	  fourteen: 十四
	  fifteen: 十五
	  sixteen: 十六
	  seventeen: 十七
	  eighteen: 十八
	  nineteen: 十九
	  twenty: 二十
	  thirty: 三十
	  forty: 四十
	  fifty: 五十
	  eighty: 八十
	  ninety: 九十
	  hundred: 百
	  thousand: 千
	  million: 百万
	  billion: 十亿
	  
	  计数单位
	  
	  pixel: 像素
	  percent: 百分比
	  
	  // 中文数字
	  ten: 十
	  hundred: 百
	  thousand: 千
	  ten thousand: 万
	  billion: 亿
	  trillion: 兆
	  
	  // 存储容量
	  byte: 字节 B
	  kilobyte: 千字节 KB
	  megabyte 兆字节 MB
	  gigabyte 吉字节 GB
	  trillionbyte 太字节 TB
	  
	  进制
	  
	  decimal: 十进制
	  hex: 十六进制
	  binary: 二进制
	  octal: 八进制
	  
	  运算符
	  
	  add: 加
	  subtract: 减
	  multiply: 乘
	  divide: 除
	  and: 与
	  or: 或
	  not: 非
	  intersection: 交集
	  compose: 并集
	  键盘符号
	  punctuator: 标点符号
	  identifier: 标识符
	  
	  // Unique graphic character allocations
	  // 独特的图形字符分配
	  // --------------------------------------------------------
	  exclamation mark: ! 感叹号
	  quotation mark: " 双引号
	  percent sign: % 百分号
	  ampersand: & and符号
	  apostrophe: ' 撇号
	  ellipse/apostrophe: …… 省略号
	  left parenthesis: ( 左括号
	  right parenthesis: ) 右括号
	  asterisk: * 星号
	  plus sign: + 加号
	  comma: , 逗号
	  slight-pause mark: 、 顿号
	  hyphen-minus: - 连字符(-) 或者 减号(-)
	  full stop: . 句号
	  middle dot: ・ 中间点
	  interpunct: · 间隔号
	  hyphenation point: · 连字点
	  solidus: / 斜线
	  colon: : 冒号
	  semicolon: ; 分号
	  less-than sign: < 小于符号
	  equals sign: = 等于符号
	  greater-than sign: > 大于符号
	  question mark: ? 问号
	  low line: _ 下划线
	  digital 0: 0 数字 0
	  latin capital letter A:  A 大写拉丁字母
	  latin small letter A: A 小写拉丁字母
	  
	  // Alternative graphic character allocations
	  // 可选的图形字符分配
	  // --------------------------------------------------------
	  number sign: # 数字符号
	  pound sign: £ 英镑符号
	  dollar sign: $ 美元符号
	  currency sign:  货币符
	  
	  // IRV(International Reference Version) graphic character allocations
	  // IRV图形字符分配
	  // --------------------------------------------------------
	  number sign: # 数字符号
	  dollar sign: $ 美元符号
	  commercial at: @ 
	  left square bracket: [ 左方括号
	  reverse solidus: \ 反斜线
	  right square bracket: ] 右方括号
	  circumflex accent: ^ 抑扬音符号
	  grave accent: ` 沉音符
	  left curly bracket: { 左花括号
	  vertical line: | 垂直线
	  right curly bracked: } 右花括号
	  tilde: ~ 波浪符
	  说明：由于标点符号中英文语言环境同一个符号也不同叫法别名，因此上面列举的词汇只能说涉及到了部分，并没有把所有 Dialect(方言) 包含进来。
	  注：· 符号在不同的上下文中有不同的叫法，比如“间隔号”、“中间点”、“项目符号”、“连子点”等，虽然肉眼看起来没有什么大的区别，但是在计算机中的Unicode编码是不一样的，更多参见间隔符
	  时间、日期
	  下面虽然列举了很多时间相关的词汇，但是在实际前端开发过程中用到的就年、月、日和时、分、秒、毫秒。
	  
	  time: 时间
	  date: 日期
	  workday: 工作日
	  weekend: 周末
	  season: 季节
	  anniversary: 周年
	  century: 世纪；百年
	  quarter: 一刻钟
	  holiday: 节日；假日
	  morning: 上午
	  noon/midday: 中午
	  afternoon: 下午
	  night: 晚上
	  midnight: 半夜
	  yesterday: 昨天
	  today: 今天
	  tomorrow: 明天
	  clock: 时钟
	  now: 现在；如今；立刻
	  nowadays: 现今；时下
	  present: 现在（的）
	  former: 从前的；前任的
	  before: 在...之前
	  after: 在...之后
	  future: 将来
	  permanent: 永久的；不变的
	  period: 周期；期间；一段时间
	  during: 在...的期间；在...期间的某个时候
	  term: 学期；期限
	  early: 早期的，提早；在初期
	  ahead: 在前的；领先的；提前的
	  later: 后来；稍后；随后
	  start/begin: 开始
	  end: 结束
	  pause: 暂停
	  suspend: 推迟；使暂停
	  timeout: 超时；暂时休息；工间休息
	  interval: 间隔
	  overtime: 超时的；加班的，加班时间
	  
	  时间
	  
	  year: 年
	  month: 月
	  day: 日
	  week: 周
	  hour: 小时
	  minute: 分
	  seconds: 秒
	  millisecond: 毫秒
	  
	  星期
	  
	  Monday: 星期一
	  Tuesday: 星期二
	  Wednesday: 星期三
	  Thursday: 星期四
	  Friday: 星期五
	  Saturday: 星期六
	  Sunday: 星期日
	  
	  月份
	  
	  January: 一月
	  February: 二月
	  March: 三月
	  April: 四月
	  May: 五月
	  June: 六月
	  July: 七月
	  August: 八月
	  September: 九月
	  October: 十月
	  November: 十一月
	  December: 十二月
	  
	  季节
	  
	  spring: 春季
	  summer: 夏季
	  autumn: 秋季
	  winter: 冬季
	  地理位置
	  map: 地图
	  location: 地理位置
	  place: 地方
	  earth: 地球
	  province: 省
	  city: 市
	  district: 区
	  area: 区域、范围
	  region: 地区、范围、部位
	  address: 地址
	  edges: 边界
	  boundary: 边界；范围；分界线
	  coordinate: 坐标
	  east: 东
	  south: 南
	  west: 西
	  north: 北
	  方位
	  direction: 方向
	  position: 位置
	  top: 上
	  right: 右
	  bottom: 下
	  left: 左
	  opposite: 对面的
	  center: 中间（水平）
	  middle: 中间（垂直）
	  排版
	  abstract: 摘要
	  annex: 附录
	  suffix: 后缀；词尾
	  prefix: 前缀
	  titl: 标题
	  summary: 总结；概要
	  specifications: 规范
	  headline: 大标题；内容提要；栏外标题
	  preface: 前言；引语；序言
	  chapter: 章；篇；回
	  section: 章节；部分
	  abbreviation: 缩写；缩写词
	  
	  font: 字体
	  color: 颜色
	  heading: 标题
	  align: 对齐
	  align left/align center/align right: 左对齐/居中对齐/右对齐
	  align top/align middle/align bottom: 顶对齐/垂直居中/底部对齐
	  text: 文本
	  zoom: 放大
	  size: 大小
	  opacity: 透明度
	  position: 位置
	  rotation: 旋转
	  fill: 填充
	  shadow: 阴影
	  blur: 模糊
	  filter: 滤镜
	  radius: 圆角
	  unite: 合并
	  subtract: 差集
	  intersect: 交集
	  exclude: 排除
	  join: 合并
	  insert image: 插入图片
	  code: 插入代码
	  highlight: 高亮
	  strikethrough: 删除线
	  underscore: 下划线
	  italic: 斜体
	  bold: 粗体
	  horizontal line: 水平分隔线
	  attach file: 附加文件
	  checklist: 清单列表
	  bullet: 项目符号
	  indention: 缩进
	  形状
	  figure: 图形
	  stroke: 描边
	  fill: 填充
	  border: 边框
	  line: 线
	  rectangle: 矩形
	  ellipse: 椭圆
	  sphere: 球
	  triangle: 三角形
	  sector: 扇形
	  annulus: 圆环
	  trapezium: 梯形
	  polygon: 多边形
	  arch: 弓形
	  circle: 圆、循环、周期
	  star: 星形、评分
	  cylinder: 圆柱
	  circle cone: 圆锥
	  love: 爱心
	  语法
	  grammar: 语法
	  syntax: 句法
	  morphology: 词法
	  structure: 结构
	  sentence: 句子
	  clause: 从句
	  phrase: 词组
	  word: 单词
	  adjective: 形容词
	  verb: 动词
	  noun: 名词
	  abstract noun: 抽象名词
	  pronouns: 代词
	  determiner: 限定词
	  conjunction: 连词
	  interjection: 感叹词
	  adverb: 副词
	  preposition: 介词；前置词
	  derivative: 派生词
	  numeral: 数词
	  auxiliary: 助动词
	  tense: 时态
	  passive: 被动语态
	  gerund: 动名词
	  antonym: 反义词
	  article: 冠词
	  antecedent: 先行词
	  regular/irregular verbs: 规则╱不规则动词
	  transitive/intransitive verbs: 及物╱不及物动词
	  subject: 主语
	  object: 宾语
	  predicate: 谓语；表语
	  adverbial: 状语
	  complement: 补语
	  appositive: 同位语
	  adjunct: 修饰语
	  affix: 词缀
	  acronym: 首字母缩略词
	  abbreviation: 缩写词
	  常用颜色
	  pink: 粉红
	  violet: 紫罗兰
	  magenta: 洋红(玫瑰红)
	  purple: 紫色
	  blue: 纯蓝
	  azure: 蔚蓝色
	  cyan: 青色
	  green: 纯绿
	  lime: 闪光绿
	  ivory: 象牙色
	  yellow: 纯黄
	  olive: 橄榄
	  gold: 金色
	  orange: 橙色
	  snow: 雪白色
	  red: 纯红
	  brown: 棕色
	  white: 纯白
	  sliver: 银灰色
	  gray: 灰色
	  black: 纯黑
	  JavaScript语言相关
	  type: 数据类型
	  primitive type: 原始类型
	  object: 对象
	  array: 数组
	  string: 字符串
	  boolean: 布尔值
	  symbol: 符号
	  undefined: 未定义
	  null: 空
	  function: 函数
	  array function: 箭头函数
	  curried function: 柯里函数
	  callback: 回调函数
	  class: 类
	  module: 模块
	  import: 导入
	  export: 导出
	  constructor: 构造函数
	  prototype: 原型
	  reference: 引用
	  closure: 闭包
	  destructure: 解构
	  variable: 变量
	  property: 属性
	  attribute: 特性
	  iterator: 迭代器
	  generator: 生成器
	  yield: 产出
	  observable: 可观赛的
	  hosit: 提升
	  operator: 运算符
	  equal: 相等
	  statement: 语句
	  block: 块
	  comment: 注释
	  whitespace: 空格
	  event: 事件
	  listener: 监听器
	  accessor: 访问器
	  decorator: 装饰器
	  proxy: 代理
	  reflect: 反射
	  promise: 承诺
	  test: 测试
	  fetch: 拿；取
	  descriptor: 描述符号
	  sync: 同步
	  async: 异步
	  await: 等候
	  find: 查找
	  every: 所有
	  some: 部分
	  foreach: 为每一个
	  map: 遍历
	  filter: 过滤
	  pad: 填充
	  index: 索引
	  data: 数据
	  slice: 把...分成部分
	  splice: 拼接，接合
	  reduce: 归纳
	  push: 推
	  pull: 拉
	  pop: 弹出
	  split: 分离
	  join: 连接
	  flatten: 变平
	  replace: 替换
	  search: 搜索
	  scope: 作用域
	  timeout: 超时
	  interval: 间隔
	  value: 值
	  define: 定义
	  math: 数学
	  sum: 求和
	  configurable: 可配置
	  enumerable: 可枚举
	  writable: 可写
	  local: 局部的
	  global: 全局的
	  not: 非
	  or: 或
	  xor: 异或
	  and: 且
	  regexp: 正则表达式
	  match: 匹配
	  pattern: 模式
	  greed: 贪婪
	  color: 颜色
	  rest: 剩余
	  assign: 赋值
	  tag: 标签
	  buffer: 缓冲区
	  super: 极好的
	  extend: 扩展
	  readonly: 只读
	  override: 重写
	  dynamic: 动态的；多态
	  default: 默认的
	  implement: 实现；执行
	  strict: 严格的
	  deprecate: 不推荐；反对
	  tab: 制表符
	  space: 空格
	  indentation: 缩进
	  public: 公共的
	  private: 私有的
	  namespace: 命名空间
	  member: 成员
	  method: 方法
	  parameter/argument: 参数
	  instance: 实例
	  ternary: 三目运算
	  literary: 字面量
	  template: 模板
	  character: 字符
	  markup: 标记
	  syntax: 语法
	  equality: 相等
	  conditional statements: 条件判断语句
	  true: 是
	  false: 否
	  type-checker: 类型检查
	  compile-time: 编译时
	  lexical scope: 词法作用域
	  static scope: 静态作用域
	  loop: 循环
	  notation: 符号
	  operand: 操作数；运算对象
	  ordinary object: 普通对象
	  standard object: 标准对象
	  built-in object: 内置对象
	  exotic object: 外来对象
	  last-in/first-out manner: 后进先出的方式
	  reserved word: 保留单词
	  signature: 签名
	  enumerable: 可枚举的
	  iterable: 可迭代的
	  
	  // 简写
	  ajax
	  json
	  常用简写
	  简写后面用 ”*“ 号标注的为推荐使用简写，可以放心大胆在项目中使用。
	  
	  hd -> head
	  hdr -> header
	  bd -> body
	  ft -> foot
	  ftr -> footer
	  tbl -> table
	  el -> element **
	  cnt -> content
	  cmp -> component
	  btn -> button **
	  sel -> select *
	  opt -> option *
	  chk -> checkbox
	  lbl -> label
	  wiz -> wizard *
	  bg -> background **
	  cur -> current **
	  prev -> previous **
	  idx -> index
	  len -> length **
	  pg -> page
	  vm -> view page
	  repo -> repository *
	  org -> organization *
	  ref -> reference *
	  res -> response **
	  req -> request **
	  msg -> message **
	  str -> string **
	  ch -> chracter *
	  lbl -> label
	  img -> image **
	  buf -> buffer *
	  usr -> user
	  args -> arguments *
	  no -> number
	  err -> error *
	  tmp/temp -> temporary **
	  rst -> result
	  bdr -> border
	  fn/func -> function **
	  nav -> navigator *
	  val -> value
	  params -> parameter *
	  dev -> development *
	  prod -> product *
	  util -> utility *
	  hoc -> high order component *
	  cb -> callback *
	  lib -> library *
	  prop(s) -> property(ies) *
	  attr(s) -> attribute(s) *
	  arr -> array *
	  conf -> config *
	  dlg -> dialog
	  e/ev/evt -> event **
	  pkg -> package *
	  tpl -> template *
	  addr -> address
	  desc -> descending
	  aesc -> aescending
	  expr -> expression **
	  src -> source **
	  hoz -> horizontal
	  vert -> vertical
	  abbr -> abbreviate
	  env -> envirnment **
	  sec -> seconds *
	  ms -> millisecond **
	  bool -> boolean *
	  dbl -> double
	  常用词汇及其变体
	  active -> inactive -> deactive
	  load -> preload -> unload
	  coming -> incoming
	  with -> without
	  sync -> async
	  allowed -> unallowed
	  going -> ingoing -> ongoing
	  online -> offline
	  visible -> invisible
	  finite -> infinite
	  able -> enabled -> unable -> disabled
	  login -> logout
	  singin -> signout
	  check -> uncheck
	  select -> unselect
	  inlet -> outlet
	  regular -> irregular
	  implicit -> explicit
	  import -> export
	  micro -> macro
	  专用名词缩写
	  GUI -> Graphical User Interface 图形用户界面
	  OEM -> Original Equipment manufacturer 原始设备制造商
	  CMS -> Content Manager System 内容管理系统
	  PWA -> Progressive Web App 渐近式Web应用
	  SDK -> Software Development Kit 软件开发工具包
	  IDE -> Integrated Development Envirnment 集成开发环境
	  SOA -> Service-Oriented Architecture 面向服务架构
	  ORM -> Object Relation Mapping 对象关系映射
	  MVC -> Model View Controller
	  OOP -> Object Oriented programing 面向对象编程
	  BEM -> Block Element Modifier 块-元素-修饰符
	  BFC -> Block Format Context 
	  SKU -> Stock Keeping Unit 库存单位
	  AJAX -> Asynchronous JavaScript and 
	  HOC -> High Order Component 高阶组件
	  I18N -> Internationalization 国际化
	  GUID -> Globally Unique Identifier 全球唯一标识符
	  UI组件相关
	  参考Element、Antd、Bootstrap和Material Design
	  
	  // 通用
	  Head: 标题
	  Label: 标签
	  Button: 按钮
	  Icon: 图标
	  Link: 文字链接
	  Input: 输入框
	  Checkbox: 筛选框
	  Radio: 单选框
	  Select: 下拉选择框
	  Switch: 开关
	  Upload: 文件上传
	  Form: 表单
	  Radio: 音频
	  Video: 视频
	  Canvas: 画布
	  
	  // 布局
	  Layout: 布局
	  Grid: 网格；栅格
	  Container: 布局容器
	  
	  // 导航
	  Affix: 固钉
	  Breadcrumb: 面包屑
	  Dropdown: 下拉菜单
	  Menu: 导航菜单
	  Pagination: 分页
	  PageHeader: 页头
	  Steps: 步骤条
	  NavMenu: 导航菜单
	  Minimap: 小地图
	  
	  // 数据录入
	  AutoComplete: 自动完成
	  Cascader: 级联选择框
	  DatePicker: 日期选择框
	  TimePicker: 时间选择框
	  DateRangePicker: 日期区间选择框
	  ColorPicker: 颜色选择框
	  InputNumber: 数字输入框
	  Mentions: 提及
	  Rate: 评分
	  Slider: 滑动输入条；滑块
	  TreeSelect: 树选择器
	  Transfer: 穿梭框
	  Wizard: 向导
	  
	  // 数据展示
	  Avatar: 头像
	  Badge: 徽标数
	  Comment: 评论
	  Collapse: 折叠面板
	  Carousel: 走马灯；轮播
	  Card: 卡片
	  Panel: 面板
	  Calender: 日历
	  Descriptions: 描述列表
	  Empty: 空状态
	  List: 列表
	  Popover: 气泡卡片
	  Statistic: 统计数值
	  Tree: 树形控件
	  Tooltip: 文字提示
	  Timeline: 时间轴
	  Tag: 标签
	  Tabs: 标签页
	  InfiniteScroll: 无限滚动
	  Chips: 芯片
	  Dialog: 对话框
	  
	  // 反馈
	  Alert: 警告提示
	  Drawer: 抽屉
	  Modal: 对话框
	  Message: 全局提示
	  MessageBox: 弹框
	  Notification: 通知提醒框
	  Progress: 进度条
	  Popconfirm: 气泡确认框
	  Result: 结果
	  Spin: 加载中
	  Skeleton: 骨架屏
	  
	  // 其它
	  Anchor: 锚点
	  BackTop: 回到顶部
	  Divider: 分隔线
	  ConfigProvider: 全局化配置
	  
	  // Button 尺寸
	  // --------------------------------------------------------
	  mini: 微型的；袖珍的
	  tiny: 微小的；很少的
	  micro: 极小的；基本的；微小的；微观的
	  small: 小
	  medium: 中等
	  large: 大
	  fixed: 固定宽度的
	  
	  // Button 外观
	  // --------------------------------------------------------
	  default: 默认的
	  plain: 朴素的
	  primary: 主要的
	  info: 信息的
	  warning: 警告的
	  error: 错误的
	  danger: 危险的
	  gray: 灰色的
	  link: 带链接的
	  outline: 带轮廓的
	  dashed: 带虚线的
	  round: 带圆角的
	  circle: 圆形的
	  ghost: 幽灵的
	  
	  // 表单控件验证状态
	  // --------------------------------------------------------
	  valid: 有效的
	  invalid: 无效的
	  pending: 验证中
	  required: 必填的
	  dirty: 脏的
	  pristine: 干净的
	  代码常用词汇
	  下面列出开发过种中经常使用的动词、名词、介词、形容词。这些词汇通常可以相互组合在特定上下文中适当变动可以覆盖工作中的绝大多数场景。
	  
	  // 动词
	  on: 监听、正在进行中
	  get: 取
	  set: 设置
	  fetch: 获取
	  find: 查找
	  add: 添加
	  create: 创建
	  remove: 移除
	  delete: 删除
	  update: 更新
	  upgrade: 升级
	  downgrade: 使降级
	  sync: 同步
	  toggle: 切换
	  pull: 拉
	  push: 推
	  show: 显示
	  hide: 隐藏
	  resolve: 解析；分解
	  parse: 解析
	  lock: 锁定
	  link: 连接
	  merge: 合并
	  close: 关闭
	  clone: 克隆
	  clear: 清除
	  format: 格式化
	  convert: 转变
	  cancel: 取消
	  accept: 承认；同意
	  check: 检查，核对
	  concat: 合并数组、字符串
	  join: 合并
	  split: 分开
	  spread: 展开
	  search: 搜索
	  sort: 排序
	  assign: 分配，指定
	  handle: 处理
	  trigger: 触发
	  login: 登入
	  logout: 登出
	  register: 注册
	  sign: 签名
	  throw: 抛出
	  load: 加载
	  preload: 加载
	  copy: 复制
	  paste: 粘贴
	  connect: 连接
	  change: 改变
	  select: 选择
	  validate: 验证
	  submit: 表单提交
	  commit: 提交
	  match: 匹配
	  scroll: 滚动
	  write: 写
	  read: 读
	  enable: 启用
	  disable: 禁用
	  limit: 限制
	  bootstrap: 启动
	  init: 初始化
	  install: 加载
	  upload: 上传
	  inject: 注入
	  provide: 提供
	  exit: 退出
	  access: 访问
	  flush: 刷新/使暴露
	  refresh: 刷新
	  release: 发布
	  preview: 预览；试映
	  publish: 出版；发行
	  navigate: 导航；浏览
	  redirect: 重定向
	  back: 返回
	  switch: 切换
	  launch: 加载
	  browse/visit: 浏览
	  append: 追加
	  insert: 插入
	  swap: 交换
	  map: 遍历
	  extract: 提取；选取
	  provide: 提供
	  inject: 注入
	  observe: 观察
	  render: 渲染
	  debug: 调试
	  align: 对齐
	  popup: 弹出
	  transfer: 转让、迁移
	  attach: 附加
	  build: 构建
	  diagnose: 诊断，断定
	  ignore: 忽略
	  deploy: 部署；展开
	  send/sent: 送；寄出
	  defer: 推迟
	  delegate: 委托
	  destroy: 销毁
	  dispatch: 派发；分派
	  trace: 追踪
	  
	  // 名词
	  avatar: 头像
	  brand: 品牌
	  record: 记录
	  issue: 问题
	  project: 项目
	  repo(repository): 仓库；知识库
	  ecosystem: 生态系统
	  assets: 资产
	  resource: 资源
	  toolkit: 工具包、工具箱
	  workbench: 工作台
	  item: 项目；条款
	  option: 选项
	  field: 字段
	  type: 类型
	  status: 状态
	  property: 属性
	  attribute: 特性
	  parameter/argument: 参数
	  length: 长度
	  size: 尺寸
	  shape: 形状
	  label: 标签
	  value: 值
	  view: 视图
	  page: 页面
	  env(envirnment): 环境
	  context: 上下文
	  count: 总数；计数
	  amount: 数量；数额
	  sum: 合计；金额
	  num(number): 号码
	  total: 总数
	  money: 钱；货币
	  filter: 过滤器
	  pipe: 管道
	  stream: 流
	  buffer: 缓冲器
	  comment: 评论
	  ref(reference): 引用
	  res(response): 响应
	  req(request): 请求
	  entity: 实体
	  event: 事件
	  setup 设置
	  prefix 前缀
	  suffix 后缀
	  wizard 小部件
	  model 模型
	  flag 标志
	  factory 工厂
	  service 服务
	  constant: 常量
	  var(iable): 变量
	  collection: 集合
	  array: 数组
	  raw: 原始值
	  platform 平台
	  capital: 大写字母
	  uppercase/lowercase: 大/小写
	  letter: 字母
	  entrance: 入口
	  path: 路径
	  route: 路由
	  router: 路由器
	  config: 配置
	  middleware: 中间件
	  success: 成功
	  error: 错误
	  fail(ure): 失败
	  frontend: 前端
	  backend: 后端
	  local: 本地
	  sever: 服务器
	  production: 线上；产品
	  border: 边框
	  outline: 轮廓
	  precision: 精度
	  separator: 分隔符
	  mask: 遮罩
	  metadata: 元数据
	  location: 位置
	  sandbox: 沙箱
	  scope: 作用域
	  queue: 队列
	  heap: 堆
	  notice: 通知
	  bubble: 气泡
	  hooks: 钩子
	  cell: 单元格
	  row: 行
	  column: 列
	  group: 组
	  cursor: 游标
	  pattern: 模式
	  abstract: 抽象
	  compose: 复合；并集
	  callback: 回调函数
	  priority: 优先级
	  grade/rank/hierarchy 等级、层级
	  table,chart, graph, diagram: 表格，图表，曲线图，图表
	  system: 系统、体系
	  guards: 保障、守卫
	  segment/fragment: 片段、碎片
	  shaking: 抖动
	  mix: 混淆
	  dependence: 依赖
	  injection: 注入
	  markup: 标记
	  email: 电子邮件
	  version: 版本
	  detail: 详情
	  stub: 存根
	  score: 成绩
	  breakpoint: 断点
	  record: 记录
	  pointer: 指针
	  thumbnail: 缩略图
	  gallery: 画廊
	  viewport: 视口
	  strategy: 策略
	  outlet: 出口
	  inlet: 入口
	  gist: 主旨；要点；依据
	  licence: 许可证
	  copyright: 版权
	  order: 命令
	  input: 输入
	  output: 输出
	  effect: 影响；效果；作用
	  position: 位置
	  corner: 角落
	  animation: 动画
	  dot: 点
	  palette: 调色板；颜料
	  album: 相册
	  photo: 照片
	  host: 主机
	  session: 会话
	  cookie: 饼干；小甜点
	  domain: 域名
	  certificates: 证书
	  coercion: 强制
	  payload: 载物
	  thread: 线程
	  process: 进程
	  timestamp: 时间缀
	  conflicts: 冲突
	  terminal: 终端
	  portrait: 肖像
	  auxiliary: 附属物
	  backup: 备份
	  bitmap: 位图
	  breakpoint: 断点
	  concurrency: 并发
	  lock: 锁
	  digest: 摘要
	  exception: 异常
	  genericity: 泛型
	  handle: 句柄
	  macro: 宏
	  manifest: 清单
	  modifier: 修饰字；修饰符
	  override: 覆写
	  overload: 重载
	  procedure: 过程
	  protocol: 协议
	  recursion: 递归
	  marquee: 跑马灯
	  
	  // 形容词
	  native: 原生的
	  hybrid: 混合的
	  basic: 基础的
	  complex: 复杂的
	  empty: 空的
	  online: 在线的
	  offline: 离线的
	  public: 公共的
	  private: 私有的
	  static: 静态的
	  dynamic: 动态的
	  shared: 共享的
	  safe: 安全的
	  relative: 相对的
	  absolute: 绝对的
	  original: 原始的
	  infinite: 无限的
	  partial: 局部的
	  ascending: 按升序
	  descending: 按降序
	  primary: 原始的，第一的
	  secondary: 第二的
	  tertiary: 第三的
	  deprecated: 弃用的
	  concrete: 具体的
	  abstract: 抽象的
	  explicit: 显示的；明确的
	  implicit: 含蓄的；暗示的
	  mutable: 可变的
	  业务常用词汇
	  # 电商
	  coupons: 优惠券
	  couponsCode: 优惠码
	  discount: 折扣
	  points: 积分
	  memeber: 会员
	  vip: 会员
	  membership: 会员
	  delivery: 运费
	  domain: 域名
	  dashboard: 仪表盘
	  store: 门店
	  shop: 店铺
	  product: 产品
	  goods: 商品
	  order: 订单
	  setting: 设置
	  manager: 管理
	  channel: 渠道
	  notFound: 404页面
	  feedback: 反馈
	  scratch: 刮刮卡
	  client: 客户端
	  market: 市场
	  promotion: 促销
	  popularize: 推广
	  tool: 工具
	  banner: 广告
	  friendlink：友情链接
	  partner： 合作伙伴
	  vote: 投票
	  技术文章阅读常用词汇
	  
	  // 副词
	  approximately: 大约；近似地；近于
	  indirectly: 间接地；迂回地
	  inevitably:不可避免地；必然地
	  repeatedly: 反复地；再三地
	  defiantly: 挑战地；对抗地
	  
	  // 形容词
	  general: 一般的；普通的；大体的
	  partial: 局部的
	  well-formed：符合语法规则的
	  appropriate: 适当的；恰当的；合适的
	  reasonable: 合理的；公道的
	  non-trivial: 非平凡的
	  conditional: 有条件的；假定的
	  disheartened: 沮丧的；灰心的
	  unmotivated: 对（工作等）不感兴趣的；没有理由的
	  terse: 简洁的；精练的；扼要的
	  chaotic: 混沌的；混乱的，无秩序的
	  effective: 有效的
	  discursive: 离题的；东拉西扯的；无层次的
	  impressive: 感人的；令人钦佩的；给人以深刻印象的
	  error-prone: 于出错的
	  weird: 怪异的；不可思议的；超自然的
	  hypothetical: 假设的；假定的
	  tricky:  狡猾的；机警的；棘手的
	  analogous: 类似的
	  haunted: 闹鬼的；反复出现的；受到困扰的
	  assigned: 指定的；已分配的
	  predictable: 可预言的
	  
	  // 名词
	  dependencies: 依赖性；相关性
	  compatibility: 兼容性
	  consistency: 一致性
	  consensus: 一致；舆论；合意
	  profile: 轮廓；外形；简况
	  utilities: 实用程序
	  assumption: 假定；设想
	  coercion:强制；强迫
	  paradigm: 范例
	  formula: 公式
	  truth: 真值
	  falsey: 假值
	  strategy: 战略；策略
	  precedence: 优先；居先
	  interlude: 插曲
	  mechanism: 机制；原理，途径；进程；机械装置；技巧
	  piece: 片段
	  lookup: 查找；检查
	  multiplication: 乘法
	  analogy: 类比；类推；类似
	  coordinate: 坐标
	  realm: 领域；范围；王国
	  accent: 口音；重音；强调；特点；重音符号
	  radix: 基数；根
	  bullets: 项目符号
	  reconciliation: 调度；和解
	  security: 安全性
	  registry: 注册
	  bot: 网上机器人；自动程序
	  inline: 内联
	  capacity: 容量
	  achievement: 成就；完成；成绩
	  reactivity: 响应式
	  extensions: 扩展程序
	  
	  // 动词
	  persuade: 说服；劝说
	  tackle: 应付；处理（难题或局面）
	  indulge: 沉溺；沉迷
	  initialize: 初始化
	  evaluate: 评价；估价；求...的值
	  vanish: 消失；突然不见
	  plug-n-play: 即插即用
	  commence: 开始；着手
	  comprehend: 理解；包含；由...组成
	  release: 释放；发布
	  pin: 钉住；压住
	  extract: 抽出
	  
	  // 短语
	  write up: 写文章赞扬；提高资产等的账面价值；详细记载；补写
	  
	  // 感叹词
	  lo and behold: 你瞧
	  
	  
	- approach途径

		- The same approach

	- in place to

	- breakdown分为细目

		- For a full breakdown of each method available

	- essential本质的，极其重要的

	- implicit含蓄的

	- desirable值得做的

	- hex十六进制

	- Identical 一样的相同的

		- The two parties fought the last election on almost identical manifestos.

		- 两个政党以几乎完全相同的竞选宣言参加了上次竞选。

		- -p, --print "script"

		- Identical to -e but prints the result.

	- Evaluate估计; 评价; 评估;

		- We need to evaluate how well the policy is working.

		- 我们需要对这一政策产生的效果作出评价

		- -e, --eval "script"

		- Evaluate the following argument as JavaScript.

	- Preload预载; 预装

		- Construction Method for Controlled Water Test to Preload Large Oil Tank Subgrade
大型油罐地基充水预压工法简介

### 36.9.2. 数学

### 36.9.3. 计算机学科

- 计算机网络

- 编辑原理

- 操作系统

- 算法原理

- 软件工程

- 软件测试原理

### 36.9.4. 后端工具

### 36.9.5. 测试

- firebug/firebug-lite

- web inspector

- YSlow/Smushit

- SuperPreview/JsBeautifer

- Fiddler/WireShark/tcpdump

### 36.9.6. 性能

- WebPageTest

- ShowSlow

- YSlow

- 34Rule

- PageSpeed

- HttpWatch

- DynaTrace's Ajax

- 压缩

- css sprites

- 合并 减少http请求

- 缓存

- CDN

- 避免重定向

### 36.9.7. 安全

- 同源策略

- CSRF/XSS

- ADsafe/Caja/FBJS/Sandbox

- 点击劫持

- SQL注入

### 36.9.8. 工作流程

- JSLint/CSSLint/YUICompressor

- JSMin/TPacker-minifier

- Ant/Make

- JSDoc/YUIDoc

- LAMP

### 36.9.9. 移动端

- JqueryMobile/html5/css3

- iPhone/iPad/iOs/android

- responsive UI Design

### 36.9.10. 博客

- [技术方案：docsify + vuep + gitalk](https://lhammer.cn/You-need-to-know-css/#/zh-cn/introduce?v=1)

  网易严选设计规范http://www.zcool.com.cn/work/ZMjAxNjc4ODQ=.html
  
  同类型：
  https://github.com/chokcoco/CSS-Inspiration
  
### 36.9.11. md文档教程

## 36.10. bash

### 36.10.1. [Shell脚本中点号+文件名的作用](https://www.cnblogs.com/cjjjj/p/9817950.html)

### 36.10.2. shell脚本：需要解释器解释

- 1.系统命令的堆积

- 2.特定的语法+系统的命令=文件

- 3.xx.sh

### 36.10.3. shell脚本能做什么

- 基于标准化之上的 => 工具化
作用：简化操作步骤，提高效率，减少认为敢于，减少系统故障

- 1.自动化完成基础配置，（系统初始化操作、系统更新、内核调整、网络、时区、SSH优化）

- 2.自动化安装程序，自动化安装LNMP、LAMP、MySQL、Nginx、Redis

- 3.自动化调整配置文件，（Nginx Conf、MySQL Conf）

- 4.自动化部署业务
部署php、java、秒级回退

- 5.自动定期备份恢复程序，mysql全备+增量+binlog+crond+shell脚本
mysql - e "source /root/db.sql"

- 6.自动化信息的采集,硬件、系统、服务、网络等等，Zabbix+Shell
free -m

- 7. 自动化日志手机（ELK）
收集->存储->展示->分析
日志分析（取值->排序->去重->统计->分析）

- 8.自动化扩容（zabbix+shell）
监控服务器，如果发现cpu持续80%+触发动作（脚本）
脚本：调用api开通云主机->初始化环境->加入集群->对外提供
当前cpu使用率20%->判断有多少web节点->判断是否成超过预设->缩减到对应的预设状态->变更负载的配置

- 9.Shell什么都能做，但要符合实际情况以及实际业务需求

### 36.10.4. Shell技能

- shell是什么

	- 直接上一个 test 文件，里面写入 echo "123"
./test 执行 输出123
bash test 执行 输出123
sh test 执行 输出123
which sh
ls /usr/bin/sh -l
链接到bash了

	- #!/usr/bin/sh
告诉系统，使用什么解释器执行
否则统一要加下

	- 执行方式推荐用
bash 脚本 不需要添加执行权限，使用解释器直接执行了

- 特性

	- 1.命令补全和文件路径补全，如果写错无法补全

	- 2.命令历史记忆功能，history

	- 3.别名功能，alias\unalias

	- 4.常用快捷键,c-u,k,a,e,l,c,z,d,w,r,y

	- 5.前后台作业控制bg,fg,jobs,screen

	- 6.输入输出重定向 >,>>,1>,2>>,&>,cat <

		- cat 命令：
cat  <  /etc/hosts > /etc/etst.sql  读入一个文件，然后重定向到文件中
cat /etc/test.sql > test.sql 读取键盘上的输入值，重定向

	- 7.管道 | 将前者命令的标准输出交给后者命令的输入，tee，把当前管道的内容记录下来

		- tee

			- tee = T 这是管线工人的术语，代表 T 型的管线分叉器

	- 8.命令排序 ; && || 

		- cat /etc/hosts &>/dev/null && mkdir .test2

	- 9.shell 通配符

		- * 匹配任意多个字符

		- ? 匹配任意一个字符

		- []匹配括号中任意一个字符

		- ()在子shell中执行（cd /boot;ls) (umask 077;touch file1000)

			- (cd /boot;ls) 
 pwd
发现文件夹没有变
子shell执行，执行完了关闭就行了

		- {}集合 touch file{1..9}

		- \ 转义

			- 转义后面不要有kongge

	- 10.echo输出颜色、printf格式化输出文本

		- echo -e "\033[30m 黑色字 \033[0m"
echo -e "\033[31m 红色字 \033[0m"
echo -e "\033[32m 绿色字 \033[0m"
echo -e "\033[33m 黄色字 \033[0m"
echo -e "\033[34m 蓝色字 \033[0m" 
echo -e "\033[35m 紫色字 \033[0m" 
echo -e "\033[36m 天蓝字 \033[0m" 
echo -e "\033[37m 白色字 \033[0m" 

- 变量

	- 用一个固定的字符串表示不固定的内容

		- a=1
b=2
c=$a+$b
echo $c | bc

		- ifconfig eth0|grep "inet"
IP=` ifconfig eth0|grep "inet"`
IP=$(ifconfig eth0|grep "inet")

			- address="www.baidu.com"
ping -c1 $address &>/dev/null && echo "$address ok" || echo "$address error"

	- 自定义变量

		- 定义变量

			- 变量名=变量值

				- 不允许数字命名，不能使用-命名

		- 引用变量

	- 系统环境变量

		- env查看环境变量

			- LANG

				- language

				- linux中记录系统字符集 语言
zh_CN.UTF-8

			- PS1

				- 命令行格式

			- PATH

				- 命令的位置

			- 历史命令

				- HISTSIZE

				- HISTFILESIE

				- HISTFILE

			- TMOUT

			- HISTCONTROL

			- PROMPT_COMMAND

	- 预先定义变量

	- 位置参数变量

	- 内置变量 continue、break、exit

- 条件判断

	- if else

- 循环语句

	- for、while

- 流程控制

	- case

- 函数

	- function

- 数组

	- array

- 正则表达式

- 案例、项目

### 36.10.5. 快捷键

- c-l清屏

- c-c终止进程

- c-u从光标删除到行首

- c-k从光标删除到行尾

### 36.10.6. 基本语法

- 命令格式

	- $ command [ arg1 ... [ argN ]]

	  $ ls -l
	  
	  上面这个命令中，ls是命令，-l是参数。
	  
	  有些参数是命令的配置项，这些配置项一般都以一个连词线开头，比如上面的-l。同一个配置项往往有长和短两种形式，比如-l是短形式，--list是长形式，它们的作用完全相同。短形式便于手动输入，长形式一般用在脚本之中，可读性更好，利于解释自身的含义。
	  
	  # 短形式
	  $ ls -r
	  
	  # 长形式
	  $ ls --reverse
	  
	  上面命令中，-r是短形式，--reverse是长形式，作用完全一样。前者便于输入，后者便于理解。
	  
	  Bash 单个命令一般都是一行，用户按下回车键，就开始执行。有些命令比较长，写成多行会有利于阅读和编辑，这时可以在每一行的结尾加上反斜杠，Bash 就会将下一行跟当前行放在一起解释。
	  
	  $ echo foo bar
	  
	  # 等同于
	  $ echo foo \
	  bar
	  
	  
- 空格

  Bash 使用空格（或 Tab 键）区分不同的参数。
  
  $ command foo bar
  
  上面命令中，foo和bar之间有一个空格，所以 Bash 认为它们是两个参数。
  
  如果参数之间有多个空格，Bash 会自动忽略多余的空格。
  
  $ echo this is a     test
  this is a test
  
  上面命令中，a和test之间有多个空格，Bash 会忽略多余的空格。
  
  
  
- 分号

  分号（;）是命令的结束符，使得一行可以放置多个命令，上一个命令执行结束后，再执行第二个命令。
  
  $ clear; ls
  
  上面例子中，Bash 先执行clear命令，执行完成后，再执行ls命令。
  
  注意，使用分号时，第二个命令总是接着第一个命令执行，不管第一个命令执行成功或失败。
  
  
- && ||

  除了分号，Bash 还提供两个命令组合符&&和||，允许更好地控制多个命令之间的继发关系。
  
  Command1 && Command2
  
  上面命令的意思是，如果Command1命令运行成功，则继续运行Command2命令。
  
  Command1 || Command2
  
  上面命令的意思是，如果Command1命令运行失败，则继续运行Command2命令。
  
  下面是一些例子。
  
  $ cat filelist.txt ; ls -l filelist.txt
  
  上面例子中，只要cat命令执行结束，不管成功或失败，都会继续执行ls命令。
  
  $ cat filelist.txt && ls -l filelist.txt
  
  上面例子中，只有cat命令执行成功，才会继续执行ls命令。如果cat执行失败（比如不存在文件flielist.txt），那么ls命令就不会执行。
  
  $ mkdir foo || mkdir bar
  
  上面例子中，只有mkdir foo命令执行失败（比如foo目录已经存在），才会继续执行mkdir bar命令。如果mkdir foo命令执行成功，就不会创建bar目录了。
  
  
  
- echo

	- echo hello world

	- echo hello\
world

	- echo -n 
结尾没有\n

	- echo -e
会eval

- type

	- type echo

	- type -a echo
所有定义

	- type -t bash
命令类型

### 36.10.7. [Bash的模式扩展](https://wangdoc.com/bash/expansion.html)

- 简介

  Shell 接收到用户输入的命令以后，会根据空格将用户的输入，拆分成一个个词元（token）。然后，Shell 会扩展词元里面的特殊字符，扩展完成后才会调用相应的命令。
  
  这种特殊字符的扩展，称为模式扩展（globbing）。其中有些用到通配符，又称为通配符扩展（wildcard expansion）。Bash 一共提供八种扩展。
  本章介绍这八种扩展。
  
  Bash 是先进行扩展，再执行命令。因此，扩展的结果是由 Bash 负责的，与所要执行的命令无关。命令本身并不存在参数扩展，收到什么参数就原样执行。这一点务必需要记住。
  
  模块扩展的英文单词是globbing，这个词来自于早期的 Unix 系统有一个/etc/glob文件，保存扩展的模板。后来 Bash 内置了这个功能，但是这个名字就保留了下来。
  
  模式扩展与正则表达式的关系是，模式扩展早于正则表达式出现，可以看作是原始的正则表达式。它的功能没有正则那么强大灵活，但是优点是简单和方便。
  
  Bash 允许用户关闭扩展。
  
  $ set -o noglob
  # 或者
  $ set -f
  下面的命令可以重新打开扩展。
  
  $ set +o noglob
  # 或者
  $ set +f
  
	-  波浪线扩展  家目录

	  波浪线~会自动扩展成当前用户的主目录。
	  
	  $ echo ~
	  /home/me
	  
	  ~/dir表示扩展成主目录的某个子目录，dir是主目录里面的一个子目录名。
	  
	  # 进入 /home/me/foo 目录
	  $ cd ~/foo
	  
	  ~user表示扩展成用户user的主目录。
	  
	  $ echo ~foo
	  /home/foo
	  
	  $ echo ~root
	  /root
	  
	  上面例子中，Bash 会根据波浪号后面的用户名，返回该用户的主目录。
	  
	  如果~user的user是不存在的用户名，则波浪号扩展不起作用。
	  
	  $ echo ~nonExistedUser
	  ~nonExistedUser
	  
	  ~+会扩展成当前所在的目录，等同于pwd命令。
	  
	  $ cd ~/foo
	  $ echo ~+
	  /home/me/foo
	  
	  
	  
	- ?字符扩展 单个字符

	  ?字符代表文件路径里面的任意单个字符，不包括空字符。比如，Data???匹配所有Data后面跟着三个字符的文件名。
	  
	  # 存在文件 a.txt 和 b.txt
	  $ ls ?.txt
	  a.txt b.txt
	  
	  上面命令中，?表示单个字符，所以会同时匹配a.txt和b.txt。
	  
	  如果匹配多个字符，就需要多个?连用。
	  
	  # 存在文件 a.txt、b.txt 和 ab.txt
	  $ ls ??.txt
	  ab.txt
	  
	  上面命令中，??匹配了两个字符。
	  
	  ? 字符扩展属于文件名扩展，只有文件确实存在的前提下，才会发生扩展。如果文件不存在，扩展就不会发生。
	  
	  # 当前目录有 a.txt 文件
	  $ echo ?.txt
	  a.txt
	  
	  # 当前目录为空目录
	  $ echo ?.txt
	  ?.txt
	  
	  上面例子中，如果?.txt可以扩展成文件名，echo命令会输出扩展后的结果；如果不能扩展成文件名，echo就会原样输出?.txt。
	  
	  
	- * 字符扩展 文件路径任意数量的任意字符包括零个字符

	  *字符代表文件路径里面的任意数量的任意字符，包括零个字符。
	  
	  # 存在文件 a.txt、b.txt 和 ab.txt
	  $ ls *.txt
	  a.txt b.txt ab.txt
	  
	  上面例子中，*.txt代表后缀名为.txt的所有文件。
	  
	  如果想输出当前目录的所有文件，直接用*即可。
	  
	  $ ls *
	  
	  *可以匹配空字符，下面是一个例子。
	  
	  # 存在文件 a.txt、b.txt 和 ab.txt
	  $ ls a*.txt
	  a.txt ab.txt
	  
	  $ ls *b*
	  b.txt ab.txt
	  
	  注意，*不会匹配隐藏文件（以.开头的文件），即ls *不会输出隐藏文件。
	  
	  如果要匹配隐藏文件，需要写成.*。
	  
	  # 显示所有隐藏文件
	  $ echo .*
	  
	  如果要匹配隐藏文件，同时要排除.和..这两个特殊的隐藏文件，可以与方括号扩展结合使用，写成.[!.]*。
	  
	  $ echo .[!.]*
	  
	  注意，*字符扩展属于文件名扩展，只有文件确实存在的前提下才会扩展。如果文件不存在，就会原样输出。
	  
	  # 当前目录不存在 c 开头的文件
	  $ echo c*.txt
	  c*.txt
	  
	  上面例子中，当前目录里面没有c开头的文件，导致c*.txt会原样输出。
	  
	  *只匹配当前目录，不会匹配子目录。
	  
	  # 子目录有一个 a.txt
	  # 无效的写法
	  $ ls *.txt
	  
	  # 有效的写法
	  $ ls */*.txt
	  
	  上面的例子，文本文件在子目录，*.txt不会产生匹配，必须写成*/*.txt。有几层子目录，就必须写几层星号。
	  
	  Bash 4.0 引入了一个参数globstar，当该参数打开时，允许**匹配零个或多个子目录。因此，**/*.txt可以匹配顶层的文本文件和任意深度子目录的文本文件。详细介绍请看后面shopt命令的介绍。
	  
	  
	  
		- ls */*.txt 子目录有一个 a.txt

		- **/*.txt 匹配顶层的文本文件和任意深度子目录的文本文件

	- 方括号扩展

	  方括号扩展的形式是[...]，只有文件确实存在的前提下才会扩展。如果文件不存在，就会原样输出。括号之中的任意一个字符。比如，[aeiou]可以匹配五个元音字母中的任意一个。
	  
	  # 存在文件 a.txt 和 b.txt
	  $ ls [ab].txt
	  a.txt b.txt
	  
	  # 只存在文件 a.txt
	  $ ls [ab].txt
	  a.txt
	  
	  上面例子中，[ab]可以匹配a或b，前提是确实存在相应的文件。
	  
	  方括号扩展属于文件名匹配，即扩展后的结果必须符合现有的文件路径。如果不存在匹配，就会保持原样，不进行扩展。
	  
	  # 不存在文件 a.txt 和 b.txt
	  $ ls [ab].txt
	  ls: 无法访问'[ab].txt': 没有那个文件或目录
	  
	  上面例子中，由于扩展后的文件不存在，[ab].txt就原样输出了，导致ls命名报错。
	  
	  方括号扩展还有两种变体：[^...]和[!...]。它们表示匹配不在方括号里面的字符，这两种写法是等价的。比如，[^abc]或[!abc]表示匹配除了a、b、c以外的字符。
	  
	  # 存在 aaa、bbb、aba 三个文件
	  $ ls ?[!a]?
	  aba bbb
	  
	  上面命令中，[!a]表示文件名第二个字符不是a的文件名，所以返回了aba和bbb两个文件。
	  
	  注意，如果需要匹配[字符，可以放在方括号内，比如[[aeiou]。如果需要匹配连字号-，只能放在方括号内部的开头或结尾，比如[-aeiou]或[aeiou-]。
	  
	  
	  [start-end] 扩展
	  
	  方括号扩展有一个简写形式[start-end]，表示匹配一个连续的范围。比如，[a-c]等同于[abc]，[0-9]匹配[0123456789]。
	  
	  # 存在文件 a.txt、b.txt 和 c.txt
	  $ ls [a-c].txt
	  a.txt
	  b.txt
	  c.txt
	  
	  # 存在文件 report1.txt、report2.txt 和 report3.txt
	  $ ls report[0-9].txt
	  report1.txt
	  report2.txt
	  report3.txt
	  ...
	  
	  下面是一些常用简写的例子。
	  
	  [a-z]：所有小写字母。
	  [a-zA-Z]：所有小写字母与大写字母。
	  [a-zA-Z0-9]：所有小写字母、大写字母与数字。
	  [abc]*：所有以a、b、c字符之一开头的文件名。
	  program.[co]：文件program.c与文件program.o。
	  BACKUP.[0-9][0-9][0-9]：所有以BACKUP.开头，后面是三个数字的文件名。
	  这种简写形式有一个否定形式[!start-end]，表示匹配不属于这个范围的字符。比如，[!a-zA-Z]表示匹配非英文字母的字符。
	  
	  $ echo report[!1–3].txt
	  report4.txt report5.txt
	  
	  上面代码中，[!1-3]表示排除1、2和3。
	  
	  
	- 大括号扩展

	  
	  大括号扩展
	  
	  大括号扩展{...}表示分别扩展成大括号里面的所有值，各个值之间使用逗号分隔。比如，{1,2,3}扩展成1 2 3。
	  
	  $ echo {1,2,3}
	  1 2 3
	  
	  $ echo d{a,e,i,u,o}g
	  dag deg dig dug dog
	  
	  $ echo Front-{A,B,C}-Back
	  Front-A-Back Front-B-Back Front-C-Back
	  
	  注意，大括号扩展不是文件名扩展。它会扩展成所有给定的值，而不管是否有对应的文件存在。
	  
	  $ ls {a,b,c}.txt
	  ls: 无法访问'a.txt': 没有那个文件或目录
	  ls: 无法访问'b.txt': 没有那个文件或目录
	  ls: 无法访问'c.txt': 没有那个文件或目录
	  
	  上面例子中，即使不存在对应的文件，{a,b,c}依然扩展成三个文件名，导致ls命令报了三个错误。
	  
	  另一个需要注意的地方是，大括号内部的逗号前后不能有空格。否则，大括号扩展会失效。
	  
	  $ echo {1 , 2}
	  {1 , 2}
	  
	  上面例子中，逗号前后有空格，Bash 就会认为这不是大括号扩展，而是三个独立的参数。
	  
	  逗号前面可以没有值，表示扩展的第一项为空。
	  
	  $ cp a.log{,.bak}
	  
	  # 等同于
	  # cp a.log a.log.bak
	  
	  大括号可以嵌套。
	  
	  $ echo {j{p,pe}g,png}
	  jpg jpeg png
	  
	  $ echo a{A{1,2},B{3,4}}b
	  aA1b aA2b aB3b aB4b
	  
	  大括号也可以与其他模式联用，并且总是先于其他模式进行扩展。
	  
	  $ echo /bin/{cat,b*}
	  /bin/cat /bin/b2sum /bin/base32 /bin/base64 ... ...
	  
	  # 基本等同于
	  $ echo /bin/cat;echo /bin/b*
	  
	  上面例子中，会先进行大括号扩展，然后进行*扩展，等同于执行两条echo命令。
	  
	  大括号可以用于多字符的模式，方括号不行（只能匹配单字符）。
	  
	  $ echo {cat,dog}
	  cat dog
	  
	  由于大括号扩展{...}不是文件名扩展，所以它总是会扩展的。这与方括号扩展[...]完全不同，如果匹配的文件不存在，方括号就不会扩展。这一点要注意区分。
	  
	  # 不存在 a.txt 和 b.txt
	  $ echo [ab].txt
	  [ab].txt
	  
	  $ echo {a,b}.txt
	  a.txt b.txt
	  
	  上面例子中，如果不存在a.txt和b.txt，那么[ab].txt就会变成一个普通的文件名，而{a,b}.txt可以照样扩展。
	  
	  {start..end} 扩展
	  
	  大括号扩展有一个简写形式{start..end}，表示扩展成一个连续序列。比如，{a..z}可以扩展成26个小写英文字母。
	  
	  $ echo {a..c}
	  a b c
	  
	  $ echo d{a..d}g
	  dag dbg dcg ddg
	  
	  $ echo {1..4}
	  1 2 3 4
	  
	  $ echo Number_{1..5}
	  Number_1 Number_2 Number_3 Number_4 Number_5
	  
	  这种简写形式支持逆序。
	  
	  $ echo {c..a}
	  c b a
	  
	  $ echo {5..1}
	  5 4 3 2 1
	  
	  注意，如果遇到无法理解的简写，大括号模式就会原样输出，不会扩展。
	  
	  $ echo {a1..3c}
	  {a1..3c}
	  
	  这种简写形式可以嵌套使用，形成复杂的扩展。
	  
	  $ echo .{mp{3..4},m4{a,b,p,v}}
	  .mp3 .mp4 .m4a .m4b .m4p .m4v
	  
	  大括号扩展的常见用途为新建一系列目录。
	  
	  $ mkdir {2007..2009}-{01..12}
	  
	  上面命令会新建36个子目录，每个子目录的名字都是”年份-月份“。
	  
	  这个写法的另一个常见用途，是直接用于for循环。
	  
	  for i in {1..4}
	  do
	    echo $i
	  done
	  
	  上面例子会循环4次。
	  
	  如果整数前面有前导0，扩展输出的每一项都有前导0。
	  
	  $ echo {01..5}
	  01 02 03 04 05
	  
	  $ echo {001..5}
	  001 002 003 004 005
	  
	  这种简写形式还可以使用第二个双点号（start..end..step），用来指定扩展的步长。
	  
	  $ echo {0..8..2}
	  0 2 4 6 8
	  
	  上面代码将0扩展到8，每次递增的长度为2，所以一共输出5个数字。
	  
	  多个简写形式连用，会有循环处理的效果。
	  
	  $ echo {a..c}{1..3}
	  a1 a2 a3 b1 b2 b3 c1 c2 c3
	  
		- mkdir {2007..2009}-{01..12}

	- 变量扩展

	  Bash 将美元符号$开头的词元视为变量，将其扩展成变量值，详见《Bash 变量》一章。
	  
	  $ echo $SHELL
	  /bin/bash
	  
	  变量名除了放在美元符号后面，也可以放在${}里面。
	  
	  $ echo ${SHELL}
	  /bin/bash
	  
	  ${!string*}或${!string@}返回所有匹配给定字符串string的变量名。
	  
	  $ echo ${!S*}
	  SECONDS SHELL SHELLOPTS SHLVL SSH_AGENT_PID SSH_AUTH_SOCK
	  
	  上面例子中，${!S*}扩展成所有以S开头的变量名。
	  
	  
		- ${!S*}扩展成所有以S开头的变量名。

	- 子命令扩展

	  
	  子命令扩展
	  
	  $(...)可以扩展成另一个命令的运行结果，该命令的所有输出都会作为返回值。
	  
	  $ echo $(date)
	  Tue Jan 28 00:01:13 CST 2020
	  
	  上面例子中，$(date)返回date命令的运行结果。
	  
	  还有另一种较老的语法，子命令放在反引号之中，也可以扩展成命令的运行结果。
	  
	  $ echo `date`
	  Tue Jan 28 00:01:13 CST 2020
	  
	  $(...)可以嵌套，比如$(ls $(pwd))。
	  
	  
	  
	- 算术扩展

	  
	  算术扩展
	  
	  $((...))可以扩展成整数运算的结果，详见《Bash 的算术运算》一章。
	  
	  $ echo $((2 + 2))
	  4
	  
### 36.10.8. # 1. Hello Bash Script 

- # echo "hello bash linuxhint audience" > file.txt

### 36.10.9. # 2. Rediret to file

- # wait for user input,until user press c-c to stop the process,go and check the file

- # cat > file.txt

- # append some text to the file

- # cat >> file.txt

### 36.10.10. # 3. comment 

-     # one line comment with hash

-     # multi-line comment colon+space+single quote single quote

-     : '

-     this is a cat command

-     this is a cat command'

-     # here doc delimiter

-     : '

-     cat << kceativ

-     this is hello  creative text

-     add another line

-     kceativ'

### 36.10.11. # 4. conditional statements

- 1.if判断单分支

	- 语法格式：

		- if 条件测试命令

		- then 命令序列

		- fi

	- 例子：

		- 如果/boot分区的控件使用超过50%，则输出警告：

			- #!/bin/bash
RATE=`df -hT | grep "/run" | awk '{print $6}' | cut-d "%" -f1`
if [ $RATE -gt 50 ]
then 
      echo "Warning,/boot DISK is full!"
fi

- 2.if判断双分支

	- 语法格式

		- if 条件测试命令

		- then 命令序列1

		- else 命令序列2

		- fi

	- 例子:

		- 判断服务是否启动，如果没有启动则启动

			- #!/bin/bash
http=`netstat -tlun | awk '{print $4 "\n"}' | grep ":80$"`
(或http=$( ps aux | grep httpd | grep -v grep ))


			- if [ -z "$http" ]
then 
       echo "httpd do not run!"
       /usr/bin/nginx
else 
      echo "httpd running"
fi

			- service mysql start

- 3.if判断多分支

	- 语法格式：

		- if 条件测试命令1;
then
       命令序列1
elif 条件测试命令2;
then
       命令序列2
elif ...
else
命令序列n
fi

	- 例子：

		- echo "Mandarin Chinese,please press 1"

		- echo "English,please press 2"

		- echo "changshahua, please press 3"

		- read -p "please input a num:" -t 30 num

		- if [ "$num" == "1" ]

		- then 

		-     echo "Mandarin"

		- elif [ "$num" == "2" ]

		- then 

		-     echo "English"

		- elif [ "$num" == "3" ]

		- then 

		-     echo "changshahua"

		- else 

		-     echo "error,please press again!"

		- fi

- # -gt -ne

	- : '

	- count=10

	- if [ $count -eq 10 ]

	- then

	-     echo "the condition is true"

	- else 

	-     echo "the condition is false"

	- fi'

- # > <

	- # (( $count > 9 ))

	- : '

	- if (( $count < 9 ))

	- then 

	-     echo "first condition is true"

	- elif (( $count > 9 ))

	- then

	-     echo "second condition is true"

	- else 

	-     echo "the coudition is false"

	- fi'

- # and

	- 第一种:&&

		- : '

		- age=30

		- if [ "$age" -gt 18 ] &&  ["$age" -lt 40 ] 

		- then 

		-     echo "Age is correct"

		- else 

		-     echo "Age is not correct"

		- fi'

	- 第二种:-a

		- : '

		- age=30

		- if [ "$age" -gt 18  -a  "$age" -lt 40 ] 

		- then 

		-     echo "Age is correct"

		- else 

		-     echo "Age is not correct"

		- fi'

- # or

	- 第一种

		- : '

		- age=30

		- if [ "$age" -lt 18  -o  "$age" -lt 40 ] 

		- then 

		-     echo "Age is correct"

		- else 

		-     echo "Age is not correct"

		- fi'

	- 第二种

		- : '

		- age=30

		- if [[ "$age" -lt 18 || "$age" -lt 40 ]]

		- then 

		-     echo "Age is correct"

		- else 

		-     echo "Age is not correct"

		- fi'

	- 第三种

		- : '

		- age=30

		- if [ "$age" -lt 18 ] || [ "$age" -lt 40 ]

		- then 

		-     echo "Age is correct"

		- else 

		-     echo "Age is not correct"

		- fi'

- # case

### 36.10.12. # 5. loops

- 第一种：while

	- : '
number=1
while [ $number -lt 10 ]
do
    echo "$number"
    number=$(( number+1 ))
done'

	- 例子

		- cat /etc/passwd
cat /etc/passwd | grep "/bin/zsh"
# 37. 批量添加用户
i=1
while [ $i -le 20 ]
do
    useradd xiaoyu$i
    echo "123456" | passwd --stdin xiaoyu$i &>/dev/null
    i=$(($i+1))
done

# 38. 批量删除的话 直接 userdel -r xiaoyu$i

- 第二种： until

	- : '
number=1
until [ $number -ge 10 ]
do 
    echo "$number"
    number=$(( number+1 ))
done'

- 第三种：for in

	- 语法：

		- 根据变量的不同取值，重复执行一组命令操作：
格式：
for 变量名 in 取值列表
do
命令序列
done

	- 例子1：

		- for i in 1 2 3 4 5
do
    echo $i
done

	- 例子2：

		- for num in 1 2 3 4 5
do
      echo $num
done

	- 例子3：

		- a=`ls /mnt/d/Github`
for file in $a
do
    echo $file
done

	- 例子4：

		- # 输入目录名，显示目录下所有内容
read -p "please input a filename:" -t 30 filename
if [ -z $filename ];then
    echo "please input filename"
    exit 1
fi
if [ ! -e $filename ];then
    echo  "$filename not in" 
    exit 2
fi
if [ ! -d $filename ];then
    echo "$filename is not directory"
    exit 3
fi
file=`ls $filename`
for test in $file
do
    echo $test
done

- 第四种：for in：# {start..ending..increment}

	- : '
for i in {0..20..2} 
do
    echo $i
done'

- case多重分支语句：

	- 根据变量的不同取值，分别执行不同的目录操作

	- 例子：

		- echo "Mandarin Chinese,please press 1"
echo "English,please press 2"
echo "changshahua, please press 3"

read -p "please input a num:" -t 30 num

case $num in
    "1")
        echo "Mandarin"
        ;;
    "2")
        echo "English"
        ;;
    "3")
        echo "changshahua"
        ;;
    *)
        echo "error,please input 1 or 2 or 3"
        ;;
esac

- 第五种：for

	- 例子1

		- for (( i=0; i<5;i++ ))
do
    echo $i
done'

	- 例子2:数值循环

		- s=0
for ((i=1;i<=100;i++))
do 
     s=$(($s+$i))
done
echo $s

- # break

	- : '
for (( i=0;i<=10;i++ ))
do 
    if [ $i -gt 5 ]
    then 
        break
    fi
    echo $i
done'

- # continue out of the loop

	- : '
for (( i=0;i<=10;i++ ))
do 
    if [ $i -eq 3 ] || [ $i -eq 7 ]
    then 
        continue
    fi
    echo $i
done'

### 38.1.1. # 6. script input

- # argument 0,1,2,3  $0 is script itself
# 39. echo $0 $1 $2 $3

	-  args=("$@")

	- # echo ${args[0]} ${args[1]} ${args[2]}

	- # echo $@

	- # length of args

	- # echo $#

- read 

	- : '

	- while read line 

	- do 

	-     echo "$line"

	- done < "${1:-/dev/stdin}" '

### 39.1.1. # 7.output 

- ls -la 1>file1.txt 2>file2.txt

- ls +la > file1.txt 2>&1

### 39.1.2. # 2021-05-04 i can follow again

- # 输出重定向

	- 设备文件名 #文件描述符 # 默认设备

	-  标准输入 /dev/stdin 0 键盘

	-  标准输出 /dev/stdout 1 显示器

	-  标准错误输出 /dev/stderr 2 显示器

	-  输出重定向概念:

	-    把应该输出到屏幕的输出，重定向到文件

	-    > 覆盖 >> 追加

	-  例如: ls > aa 覆盖到aa ls>>aa 追加到aa

	-  ls abcde 2 >> aa 错误信息输出到aa

	-  强调：错误输出，不能有空格

	-  ls &>aa 错误和正确都输入到aa

	-  ls >> aa 2>>bb 正确信息输入aa，错误信息输入bb

	-  ls 1>>aa 2>>bb

	-  ls >> aa 2>&1 错误和正确都输入到aa，可以追加

	-  2会先重定向到1打包的输入而不是1文件，然后在追加到aa中来

	-  2>1和2>&1的写法有什么区别：

	-  2>1的作用是把标准错误的输出重定向到1，但这个1不是标准输出，而是一个文件!!!,文件名就是1；

	-  2>&1的作用是把标准错误的输出重定向到标准输出1，&指示不要把1当作普通文件，而是fd=1即标准输出来处理。

- # 多命令顺序执行

	- 1. command1;command2;

	- 2. command1 && command2

	- 3. command1 || command2

	- 4. command1 | command2 命令1执行的结果当做命令2的执行条件

		- netstat -tlun | grep 80 查询监听端口号，并查看80端口是否启动

		- ls -l /etc/ | more 分屏显示ls内容

		- ls -l /etc/ | grep yum

- # 变量

	- 1. 分类： 本地变量，环境变量，位置参数变量，预定义变量

	- 2. 本地变量：

		-     变量名和值不能是特殊符号

		-     声明: 变量名=变量值

		-     注意：=号两边不能有空格

		-     aa=123

		-     调用: echo $aa

	- 3. 查看变量

		-    set 查看所有变量，包含环境变量和本地变量 

	- 4. 删除变量

		-     unset 

	- 5. 变量设定规则

		-     1》变量以等号连接值，等号不能有空格

		-     2》变量名由数字和字母和下划线组成，不能以数字开头

		-     3》变量值中有空格，用引号括起来

			-     aa="hellow world"

			-     echo "$aa" # hello world

			-     echo '$aa' # $aa

			-     bb="ls" 

			-     echo $bb # bb

			-     bb=ls

			-     echo $bb # bb

			-     bb=`ls`

			-     echo $bb # ls输出

			-     bb=$(ls)

			-     echo $bb # ls输出

		-     4》双引号内，有特殊字符。如$

		-     5》单引号中特殊字符无含义

		-     6》在变量值中，可以输入\转义符

		-     7》变量值可以直接调用系统命令。`命令` $(命令)

		-     8》变量值可以累加 aa=123 aa="$aa"456,ehco $aa --->123456

- # 环境变量

	- 作用域

		- set 

		- bash进入子bash

		- pstree查看级别

		- set

		- exit返回上一次

		- pstree

	- 1. 环境变量

		-     1》声明

			-         export 变量名=变量名

			-         export aa

		-     2》查看

			-         set 查看所有变量

			-         env 

			-         export 只能查看环境变量

			-             declare 声明变量类型的，如果不特别声明，所有变量为字符串型

			-             -i 声明为int

			-             -x 声明为环境变量

		-     3》删除

			-         unset 变量

			- ./helloScript.sh 能执行

			- helloScript.sh 无法执行

			- 环境变量中加入当前目录，之后就可以直接执行了

	- 2. 如何加入环境变量

		- echo $PATH

		- export PATH="$PATH":/root/xiaoyu

		- echo $PATH

	- 3. 常用环境变量

		- echo $PATH 系统查找命令的路径

		- PATH="$PATH":/root/xiaoyu 在系统默认路径后，追加/root/xiaoyu 目录作为目录查找路径（临时生效）

	- 4. 环境变量配置文件

		-   /etc/profile

		-   /etc/bashrc  所有用户生效

		-   ~/.bashrc

		-   ~/.bash_profile 只对指定用户生效

	- 5. 位置参数变量

		-     $0 命令自己

		-     $1 第一个参数

		-     $2 第二个参数

		-     $9 第几个参数

		-     最多九个参数

		-     例如：输出位置参数变量

		-     #!/bin/bash

		-     echo "the command is $0"

		-     echo "canshu1 is $1"

		-     echo "canshu2 is $2"

	- 6. 预定义变量

		-     $? 上一个命令的返回值。0 上一个命令正确执行，非0 上一个命令不正确

		-     $# 统计命令之后的参数个数

		-     $* 返回所有参数

		-     $n 位置参数变量

		- 例如： 输出预定义变量

		- #!/bin/bash

		- echo "canshu zongshu $#"

		- echo "canshu liebiao:$*"

		- echo $?

- # read命令

	-     read -p ”提示信息“ -t 等待时间 变量名

	- 例子：通过read读入变量值

	- #!/bin/bash

	- read -p "please input num1:" -t 30 test1

	- read -p "input num2:" -t 30 test2

	- sum=$(( $test1 + $test2 ))

	- echo "$test1 + $test2 = $sum"

	- 需要计算的表达式形式为：$((  ))

- # 数值运算

	- 变量值默认都是字符串类型，要想进行数值运算。以下三种，任选一种：

	- 1. declare方法

		-     num1=123

		-     num2=456

		-     declare -i sum=$num1+$sum2

		- 注意+两边不能有空格

	- 2. sum=$(( $num1 + $num2 ))

		- 注意：加号两边带不带空格都可以

	- 3. sum=$(expr $num1 + $num2 )

		- 注意：+左右必须空格

	- 4. 运算符

		- +-\*/%取余

- # shell 中常用命令

	- 1. 行提取命令grep

		- 选项：-v 反向选择

		-       -n 提取时，显示行号

		- 举例：

		-     grep "[^a-z]abc" test.txt

		-     abc前不是小写字母的行匹配

		-     grep "\.$" test.txt

		-     匹配以.结尾的行

		-     grep "^[^A-Za-z]" test.txt

		-     匹配不易字母开头的行

	- 2. 列提出命令 cut

		- 语法： cut -d "分隔符" -f 提取列 文件名

		- 举例：

		-     more /etc/passwd | grep "/bin/bash" | cut -d ":" -f 1,3 

		-     提取passwd文件中可以登录的用户的用户名和UID

		-     cut -d " " -f 1,3 test.txt

	-     3. awk

		-     awk '条件 {动作}'

		-     last | awk '{printf $1 "\t" $3 "\n"}'

		-     条件不给 默认 以空格当做分割

		-     提取last显示结果的第一和第三列

		-     ps -ef | awk '{printf $1 "\t" $3 "\n"}'

		- 举例：

		- last | grep "[0-9]\{1,3\})(\.)\1\2\1\2\1" | awk `{prinf $1 "\t" $3 "\n"}`

		-     在last中提取包含ip的行，在行中提取第一和第三列

	- 4. echo命令

		- echo -e "123\t456\n"

		- echo -e "\e[1;31m this is red text \e[0m" 输出红色字体

		- \e[ 格式

		- 1;31m 指定颜色

		- 0m 恢复颜色（重置）

		- 30m=黑色，31=红色，32m=绿色，33m=黄色，34m=蓝色，35m=洋红，36m=青色，37=白色

		- echo -e "\e[1:42 backgroud \e[0m"

		- 背景颜色：40=黑色，41=红色，42=绿色，43=黄色，44=蓝色，45=洋红，46=青色，47=白色

		- jimu.sh 俄罗斯方块游戏

		- shutdown -r now

		- 关机服务器

- 条件测试

	- 语法格式： test 测试条件 测试内容

	- 或者：[ 测试条件 测试内容 ]

	- 测试文件类型：

		- test -e 文件名 ： 测试文件是否存在，存为未真
[ -e 文件名 ]  ：注意：[]中必须有空格

		- test -f 文件名： 判断是否是普通文件

		- test -d 文件名：判断是都为目录

		- test -b 文件名：判断是否为块设备文件

		- test -c 文件名：判断是否为字符设备文件

		- 所有test 都会返回true or false 但是不会输出，需要通过$? 拿到返回结果是否是0，是0 为true。
或者通过test -c file.txt && echo yes || echo no

	- 测试文件权限

		- test -r 文件名：判断是否有可读权限

		- test -w 文件名：判断是否有可写权限

		- test -x 文件名：判断是否有可执行权限

		- test -s 文件名 判断是否为为空白，有内容为真

	- 判断两个文档

		- [ file1 -nt file2 ] : file1 是否比file2新

		- [ file1 -ot file2 ] : file1是否比file2旧

		- [ file1 -ef file2 ] : file1 与file2是否是链接文件
FILE1 and FILE2 have the same device and inode numbers

- 两个数值之间判断：

	- [ n1 -eq n2 ]  n1和n2是否相等

	- [ n1 -ne n2 ] n1和n2是否不等

	- [ n1 -gt n2 ] n1大于n2

	- [ n1 -lt n2 ] n1小于n2

	- [ n1 -ge n2 ] n1大与等于n2

	- [ n1 -1e n2 ] n1小于等于n2

- 判断字符串

	- [ -z 字符串 ] 判断字符串是否为空

	- [字符串1 == 字符串2 ] 判断字符串1是否与字符串2相等

	- [ $aa == $bb ] && echo yes || echo no

	- [ 字符串1 != 字符串2  ] 判断字符串是否不相等

- 多重判断

	- -a 逻辑与
[ -z $file -a -e $file ]

	- -o 逻辑或

	- ! 逻辑非

- 常用的一些shell语句

	- # bash script

	- read -p  "please input your filename:" -t 30 filename

	- test -z $filename && echo "please input your filename!!" && exit 1

	- test ! -e $filename && echo "file do not exist!!" && exit 2

	- test -f $filename && filetype=common

	- test -d $filename && filetype=directory

	- test -r $filename && permission=read

	- test -w $filename && permission="$permission write"

	- test -x $filename && permission="$permission executable"

	- echo -e "the filename is: $filename \n"

	- echo -e "filetype is: $filetype \n"

	- echo -e "permission is: $permission \n"

### 39.1.3. [bash网址](https://wangdoc.com/bash/expansion.html)

## 39.2. linux环境
![image](assets/1CE76CD8-2495-4788-AACB-911BDE16F47A.svg)

### 39.2.1. linux 基础概念

- [linux入门概念](https://mp.weixin.qq.com/s/-cYSuXpxZ_mmhQQayOIiiQ)

	- unix

		- 开源的“操作系统”，作为一个底部框架，有很多孩子，比方说：GNU，BSD

			- 苹果把BSD更改加强编程macos

			- 安卓

	- linux

		- 发行版 ：从linux加改装之后发布到网上
manjaro linux

	- linux中一切都是文件

	- 文件系统都是大体相同的

		- bin：binary，存放最常用命令；

			- 可执行文件，程序存在的地方

		- boot：启动Linux的核心文件；

			- 系统阅读并决定怎么启动系统

		- dev：device，用于存放设备文件

			- 硬件：鼠标，事件，终端，input，各种硬件配置

		- etc：etcetera，and so on，存放各种配置文件

			- 放系统配置文件,是全局的，需要管理员权限才可以更改。pacman.conf软件管理器的配置文件

			- etc
![image](assets/662f621b8b8b1a78250d5074345cfef34e54fc073e05723c9163964134463bfb.png)

		- home：用户主目录

			- 家目录，david用户，下的所有文件，全是用户所有的文件，照片，视频，个人的配置文件，不同用户互相隔离。.vim,.bashrc

		- lib

			- 系统最基本的动态链接共享库；

		- lib64

		- mnt：mount，一般是空的，用来临时挂载别的文件系统

			- 加载后，会在mnt里多出相应设备的目录。是系统临时用的挂载点。uPan或者新的硬盘挂载，可以手动装在

			- 可直接理解为“挂载” 挂接光驱、USB设备的目录

		- proc：process，虚拟目录，是内存的映射；

			- 所有的进程，htop，查看所有进程文件，比方4428，不是所有文件都写在硬盘上了，只是表现为一个文件，这样的话，大家都可以更改和配置。

			- 例子：

				- cat /proc/version

					- 查看Linux版本信息

				- cat /proc/cpuinfo

					- 查看cpu信息

				- cat /proc/interrupts

					- 查看中断

				- cat /proc/loadavg

					- 查看系统负载

		- /sbin

			- 系统管理员命令存放目录；

		- misc：misc device

			- 杂项设备，是用来存放系统没有归类过的文件设备。

			- misc：miscellaneous，abbr，混杂的，各色各样混在一起，多才多艺的

		- root：根目录下，所以高home一级

		- run

		- srv：service，所有的服务文件，跑服务器的话，就会有很多服务的文件，是有可能不存在硬盘。

		- sys：系统文件夹，有很多关于系统可以更改的东西，屏幕亮度的文件。。。

		- tmp：tempory，存放临时文件

		- usr：system resources 还是 software resources，最庞大的目录，要用到的应用程序和文件几乎都在这个目录。

			- 是系统核心所在，包含了所有的共享文件。它是 unix 系统中最重要的目录之一，涵盖了二进制文件，各种文档，各种头文件，x，还有各种库文件；还有诸多程序，例如 ftp，telnet 等等。

			- 所有linux系统不要usr上用来运行，

			- /usr/include：系统头文件；

			- /usr/lib：存放常用动态链接共享库、静态档案库；

			- /usr/bin、/usr/sbin：这是对/bin、/sbin的一个补充；

			- /usr/X11R6 存放X window的目录

			- /usr/bin 众多的应用程序

			- /usr/sbin 超级用户的一些管理程序

			- /usr/doc linux文档

			- /usr/include linux下开发和编译应用程序所需要的头文件

			- /usr/lib 常用的动态链接库和软件包的配置文件

			- /usr/man 帮助文档

			- /usr/src 源代码，linux内核的源代码就放在/usr/src/linux里

			- /usr/local/bin 本地增加的命令

			- /usr/local/lib 本地增加的库

		- var：某些大文件的溢出区，比方说各种服务的日志文件

			- variable，可变的，缓存cache，可能会越来越大。。。

	- 操作系统使用

		- 终端：命令行，ms中的dos

			- pwd

			- ls -la

			- man ls   manual：查看一个命令的使用方法，参数,q退出

				- [man find](https://blog.csdn.net/qq_42347124/article/details/112055628)

					- SYNOPSIS 概要[sɪˈnɒpsɪs]


					- hierarchy 有层次的 [ˈhaɪərɑːki]


					- -H,-L,-P
对比可以看出若不在[路径组]中指明./instance/reports这个软连接-H则无法搜索到./instance下的结果，-L可以搜索到路径下包括软连接在内的结果，-P则无法搜索到任何软连接下的结果。

					  # 一
					  mkdir -p /home/kali/Documents/test0/{instance,reports}
					  touch test.txt
					  # 二
					  ln -s /home/kali/Documents/test0/reports /home/kali/Documents/test0/instance/reports
					  # 三
					  
					  ┌──(kali㉿kali)-[~/Documents/test0]
					  └─$ find -H ./instance/reports -name test.txt
					  ./instance/reports/test.txt
					  
					  ┌──(kali㉿kali)-[~/Documents/test0]
					  └─$ find -L ./instance/reports -name test.txt                                                                                                                  
					  ./instance/reports/test.txt
					  
					  ┌──(kali㉿kali)-[~/Documents/test0]
					  └─$ find -P ./instance/reports -name test.txt
					                                                                                                                                                                      
					  ┌──(kali㉿kali)-[~/Documents/test0]
					  └─$ find -H ./ -name test.txt
					  ./reports/test.txt
					  
					  ┌──(kali㉿kali)-[~/Documents/test0]
					  └─$ find -L ./ -name test.txt
					  ./instance/reports/test.txt
					  ./reports/test.txt
					                                                                                                                                                                       
					  ┌──(kali㉿kali)-[~/Documents/test0]
					  └─$ find -P ./ -name test.txt
					  ./reports/test.txt
					  
					  ————————————————
					  版权声明：本文为CSDN博主「搁浅的人、落水的鲸」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
					  原文链接：https://blog.csdn.net/qq_42347124/article/details/112055628
					  
					- 路径组

						- 路径组为被搜寻的路径，要搜寻多个路径时用空格隔开，如find -L ./reports ./instance -name test.txt即为在目录./reports和./instance中搜寻名为test.txt的文件。

					- 操作符

						- 当存在需要表达式实现有逻辑关系的搜寻或执行时就可能会用到操作符。常用的操作符有-a（和）和-o（或），例如sudo find / -iname '*.jpeg' -o -iname '*.jpg'即为搜索电脑中全部的jpeg(jpg)格式的文件。

			- cd:change directory

				- ~,用户目录

			- mkdir:make directory

			- touch:摸一下？

			- nano,open,vim,nvim 编辑

			- cat,less 显示文件

			- mv：move，移动文件,重命名
mv -i是否覆盖

			- cp:copy，复制文件，重命名

			- rm:remove，删除文件
rm -r 删除文件夹 --recursive递归重复性的删除

			- pwd：print working directory

- linux遇到问题处理

	- go代理配置 - fzf build

	  Goproxy 中国
	  https://goproxy.cn/
	  
	  make install
	  GOARCH=amd64 go build -a -ldflags "-s -w -X main.version=0.27.0 -X main.revision=19759ed3" -tags "" -o target/fzf-linux_amd64
	  go: github.com/gdamore/tcell@v1.4.0: Get "https://proxy.golang.org/github.com/gdamore/tcell/@v/v1.4.0.mod": dial tcp 216.58.200.49:443: connect: connection refused
	  Makefile:126: recipe for target 'target/fzf-linux_amd64' failed
	  make: *** [target/fzf-linux_amd64] Error 1
	  
	  
	  解决办法：go env -w GOPROXY=https://goproxy.cn
	  
	  make install 成功 
	  
	- gzip -d filename.gz

	- .zshrc文件一直报错

		- 一直报错.fzf/shell  command not found: bind

			- # [ -f ~/.fzf.bash ] && source ~/.fzf.bash 这句话应该运行在bash上面估计是因为不zsh语法不兼容，所以不应该出现在这里20210425

		- 一直报不是一个git仓库 其实是因为命令行启动时 执行了git命令

			- # alias show-last-tag=git describe --tags `git rev-list --tags --max-count=1` #这个代码一直报错  因为读取到这里时，代码会首先执行rev-list --tags --max-count=1

	- 查看日志命令集合

		- tail -f servece.log 
查看服务器日志

		- 查看文件集合

			- cat 查看文本内容

			- more分页看

			- less分页看，搜索，回翻

			- tail -10 查看文件尾部10行

			- head -20 查看文件头部20行

		- cat service.log | grep 13888888888
service.log中所有含有13888888888的记录给搜出来，搜索的速度还是贼快的

		- cat -n service.log | grep 13888888888 行号

		- sed -n "29496,29516p" service.log
从29496行开始检索，到29516行结束

		- cat -n service.log | tail -n +29496 | head -n 20
从29496行开始检索，往前推20条

		- cat service.log | grep 13 |more ：
将查询后的结果交由more输出

		- cat service.log | grep 13 &gt; /home/sanwai/aa.txt  将查询后的结果写到/home/sanwai/aa.txt文件上

		- 有的时候，我们想统计这个日志输出了多少行，我们可以使用这条命令：
cat service.log | wc -l

	- vim -c 'set encoding=utf-8' /var/log/vdi/api.log

	- wget -c https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf


	- linux电脑无法使用root帐号进行代码联调时

	  解决办法1：
	  target host
	   wget http://172.16.55.99:8081
	  
	  des host
	   http-server => hs
	  Starting up http-server, serving ./
	  Available on:
	    http://172.16.55.99:8080
	    http://127.0.0.1:8080
	  
- [linux比较好的网站，](https://zhuanlan.zhihu.com/p/36801617)

### 39.2.2. linux上开发环境配置

- windows10 wsl

- ubuntu 20.04

- zsh,.oh-my-zsh

	- git

		- 默认开启，git命令缩写

		- cat ~/.oh-my-zsh/plugins/git/git.plugin.zsh

		- alias | grep config

	- Z

		- 内置组件

		- z -x 无效路径

	- autojump

		- linux安装autojump

			- git clone git://github.com/joelthelion/autojump.git
./install.py

			- 最后把以下代码加入 .zshrc：
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

		- autojump 的缩写 j

		- j --purge 无效路径 删除无效路径

		- jo music 打开 muisc 文件夹

		- j w in 多个参数一起使用 打开 /home/user/work/inbox

	- zsh-syntax-highlighting

		- git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

		- 在 ~/.zshrc 中配置
plugins=(其他的插件 zsh-syntax-highlighting)

		- source ~/.zshrc

	- zsh-autosuggestions

		- git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

		- 在 ~/.zshrc 中配置
plugins=(其他的插件 zsh-autosuggestions)

		- bindkey ',' autosuggest-accept

	- git-open

		- git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open

		- plugins=(其他的插件 git-open)

		- alias go="git-open"

	- history 

		- HIST_STAMPS="yyyy-mm-dd"

	- trash 官网

		- npm install --global trash-cli
alias cp="cp -i

		- 防止 copy 的时候覆盖已存在的文件, 带上 i 选项，文件已存在的时候，会提示，需要确认才能 copy

	- bat 代替 cat

		- cat 某个文件，可以在终端直接输出文件内容，bat 相比 cat 增加了行号和颜色高亮 👍

- node

	- npm配置

		- It's not recommended to use sudo with npm install, follow the steps from npmjs official docs instead

		- mkdir ~/.npm-global

		- npm config set prefix '~/.npm-global'

		- export PATH=~/.npm-global/bin:$PATH

		- source ~/.profile

		- [npm install -g xxxx
https://docs.npmjs.com/getting-started/fixing-npm-permissions](https://stackoverflow.com/questions/46058546/error-eacces-permission-denied-access-usr-lib-node-modules)

		- sudo chown -R 1000:1000 "/home/zagger/.npm"

		- sudo chown -R 1000:1000 "/home/zagger/.npm_global"

- [pip，pip3](https://ywnz.com/linuxjc/6998.html)

	- pip3

		- sudo apt update
sudo apt install python3-pip
pip3 --version

	- pip2

		- https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py

- nvim

- fzf

	- [安装最新的](https://github.com/junegunn/fzf/releases)

		- 鼠标右键下载的那个包，点击复制链接，下载tar的链接如下：wget https://github.com/junegunn/fzf/releases/download/0.27.0/fzf-0.27.0-linux_amd64.tar.gz

			- tar xvf fzf-0.27.0-linux_amd64.tar.gz

				- apt-get install fzf
where fzf
cp fzf /usr/bin
fzf --version

- lazygit

	- https://github.com/jesseduffield/lazygit#ubuntu

		- sudo add-apt-repository ppa:lazygit-team/release
sudo apt-get update
sudo apt-get install lazygit

- [zim](https://github.com/zimfw/zimfw)

- [dotfiles  ](https://luolei.org/dotfiles-tutorial/)

### 39.2.3. [常用命令](https://blog.csdn.net/weixin_30340745/article/details/96306905)

进入文件 cd /home 进入 '/ home' 目录' cd .. 返回上一级目录 cd ../.. 返回上两级目录 查看文件夹中的文件 ls 查看目录中的文件 ll 查看目录中的文件 ls -l 显示文件和目录的详细资料 ls -a 显示隐藏文件 创建文件夹 mkdir dir1 创建一个叫做 'dir1' 的目录' mkdir dir1 dir2 同时创建两个目录 删除文件 rm -f file1 删除一个叫做 'file1' 的文件' rmdir dir1 删除一个叫做 'dir1' 的目录' rm -rf dir1 删除一个叫做 'dir1' 的目录并同时删除其内容 rm -rf dir1 dir2 同时删除两个目录及它们的内容 mv dir1 new_dir 重命名/移动 一个目录 cp file1 file2 复制一个文件 cp -a dir1 dir2 复制一个目录 cp -r dir1 dir2 复制一个目录及子目录 编辑一个文件 vim a.js 当编辑完退出时候 esc :w + enter 保存 :q + enter 退出vim模式 vim 编辑手册 vimtutor 

- rsync

  rsync -avz js built resources views personal_login css fonts includes scope_manage root@172.16.201.91:/var/www/html
  
	- [rsync -avz js built resources views personal_login css fonts includes scope_manage root@172.16.201.91:/var/www/html](https://www.runoob.com/linux/linux-comm-chown.html)

- [chown：change owner](https://www.runoob.com/linux/linux-comm-chown.html)

  Linux chown 命令
  ￼ Linux 命令大全
  Linux chown（英文全拼：change owner）命令用于设置文件所有者和文件关联组的命令。
  Linux/Unix 是多人多工操作系统，所有的文件皆有拥有者。利用 chown 将指定文件的拥有者改为指定的用户或组，用户可以是用户名或者用户 ID，组可以是组名或者组 ID，文件是以空格分开的要改变权限的文件列表，支持通配符。 。
  chown 需要超级用户 root 的权限才能执行此命令。
  只有超级用户和属于组的文件所有者才能变更文件关联组。非超级用户如需要设置关联组可能需要使用 chgrp 命令。
  使用权限 : root
  
  语法
  
  chown [-cfhvR] [--help] [--version] user[:group] file...
  参数 :
  user : 新的文件拥有者的使用者 ID
  group : 新的文件拥有者的使用者组(group)
  -c : 显示更改的部分的信息
  -f : 忽略错误信息
  -h :修复符号链接
  -v : 显示详细的处理信息
  -R : 处理指定目录以及其子目录下的所有文件
  --help : 显示辅助说明
  --version : 显示版本
  
  实例
  
  把 /var/run/httpd.pid 的所有者设置 root：
  chown root /var/run/httpd.pid
  将文件 file1.txt 的拥有者设为 runoob，群体的使用者 runoobgroup :
  chown runoob:runoobgroup file1.txt
  将当前前目录下的所有文件与子目录的拥有者皆设为 runoob，群体的使用者 runoobgroup:
  chown -R runoob:runoobgroup *
  把 /home/runoob 的关联组设置为 512 （关联组ID），不改变所有者：
  chown :512 /home/runoob
  ￼ Linux 命令大全
  
  
- [chmod：change mode](https://www.runoob.com/linux/linux-comm-chmod.html)

  Linux chmod命令
  ￼ Linux 命令大全
  Linux chmod（英文全拼：change mode）命令是控制用户对文件的权限的命令
  Linux/Unix 的文件调用权限分为三级 : 文件所有者（Owner）、用户组（Group）、其它用户（Other Users）。
  ￼
  只有文件所有者和超级用户可以修改文件或目录的权限。可以使用绝对模式（八进制数字模式），符号模式指定文件的权限。
  ￼
  使用权限 : 所有使用者
  
  语法
  
  chmod [-cfvR] [--help] [--version] mode file...
  
  参数说明
  
  mode : 权限设定字串，格式如下 :
  [ugoa...][[+-=][rwxX]...][,...]
  其中：
  u 表示该文件的拥有者，g 表示与该文件的拥有者属于同一个群体(group)者，o 表示其他以外的人，a 表示这三者皆是。
  + 表示增加权限、- 表示取消权限、= 表示唯一设定权限。
  r 表示可读取，w 表示可写入，x 表示可执行，X 表示只有当该文件是个子目录或者该文件已经被设定过为可执行。
  其他参数说明：
  -c : 若该文件权限确实已经更改，才显示其更改动作
  -f : 若该文件权限无法被更改也不要显示错误讯息
  -v : 显示权限变更的详细资料
  -R : 对目前目录下的所有文件与子目录进行相同的权限变更(即以递归的方式逐个变更)
  --help : 显示辅助说明
  --version : 显示版本
  
  符号模式
  
  使用符号模式可以设置多个项目：who（用户类型），operator（操作符）和 permission（权限），每个项目的设置可以用逗号隔开。 命令 chmod 将修改 who 指定的用户类型对文件的访问权限，用户类型由一个或者多个字母在 who 的位置来说明，如 who 的符号模式表所示:
  who用户类型说明
  u | user | 文件所有者
  g | group | 文件所有者所在组
  o | others | 所有其他用户
  a | all | 所用用户, 相当于 ugo
  operator 的符号模式表:
  Operator说明
  + | 为指定的用户类型增加权限
  - | 去除指定用户类型的权限
  = | 设置指定用户权限的设置，即将用户类型的所有权限重新设置
  permission 的符号模式表:
  模式名字说明
  r | 读 | 设置为可读权限
  w | 写 | 设置为可写权限
  x | 执行权限 | 设置为可执行权限
  X | 特殊执行权限 | 只有当文件为目录文件，或者其他类型的用户有可执行权限时，才将文件权限设置可执行
  s | setuid/gid | 当文件被执行时，根据who参数指定的用户类型设置文件的setuid或者setgid权限
  t | 粘贴位 | 设置粘贴位，只有超级用户可以设置该位，只有文件所有者u可以使用该位
  
  八进制语法
  
  chmod命令可以使用八进制数来指定权限。文件或目录的权限位是由9个权限位来控制，每三位为一组，它们分别是文件所有者（User）的读、写、执行，用户组（Group）的读、写、执行以及其它用户（Other）的读、写、执行。历史上，文件权限被放在一个比特掩码中，掩码中指定的比特位设为1，用来说明一个类具有相应的优先级。
  #权限rwx二进制
  7 | 读 + 写 + 执行 | rwx | 111
  6 | 读 + 写 | rw- | 110
  5 | 读 + 执行 | r-x | 101
  4 | 只读 | r-- | 100
  3 | 写 + 执行 | -wx | 011
  2 | 只写 | -w- | 010
  1 | 只执行 | --x | 001
  0 | 无 | --- | 000
  例如， 765 将这样解释：
  所有者的权限用数字表达：属主的那三个权限位的数字加起来的总和。如 rwx ，也就是 4+2+1 ，应该是 7。
  用户组的权限用数字表达：属组的那个权限位数字的相加的总和。如 rw- ，也就是 4+2+0 ，应该是 6。
  其它用户的权限数字表达：其它用户权限位的数字相加的总和。如 r-x ，也就是 4+0+1 ，应该是 5。
  
  实例
  
  将文件 file1.txt 设为所有人皆可读取 :
  chmod ugo+r file1.txt
  将文件 file1.txt 设为所有人皆可读取 :
  chmod a+r file1.txt
  将文件 file1.txt 与 file2.txt 设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入 :
  chmod ug+w,o-w file1.txt file2.txt
  为 ex1.py 文件拥有者增加可执行权限:
  chmod u+x ex1.py
  将目前目录下的所有文件与子目录皆设为任何人可读取 :
  chmod -R a+r *
  此外chmod也可以用数字来表示权限如 :
  chmod 777 file
  语法为：
  chmod abc file
  其中a,b,c各为一个数字，分别表示User、Group、及Other的权限。
  r=4，w=2，x=1
  若要 rwx 属性则 4+2+1=7；
  若要 rw- 属性则 4+2=6；
  若要 r-x 属性则 4+1=5。
  chmod a=rwx file
  和
  chmod 777 file
  效果相同
  chmod ug=rwx,o=x file
  和
  chmod 771 file
  效果相同
  若用 chmod 4755 filename 可使此程序具有 root 的权限。
  
  更多说明
  
  命令说明
  chmod a+r file | 给file的所有用户增加读权限
  chmod a-x file | 删除file的所有用户的执行权限
  chmod a+rw file | 给file的所有用户增加读写权限
  chmod +rwx file | 给file的所有用户增加读写执行权限
  chmod u=rw,go= file | 对file的所有者设置读写权限，清空该用户组和其他用户对file的所有权限（空格代表无权限）
  chmod -R u+r,go-r docs | 对目录docs和其子目录层次结构中的所有文件给用户增加读权限，而对用户组和其他用户删除读权限
  chmod 664 file | 对file的所有者和用户组设置读写权限, 为其其他用户设置读权限
  chmod 0755 file | 相当于u=rwx (4+2+1),go=rx (4+1 & 4+1)。0 没有特殊模式。
  chmod 4755 file | 4设置了设置用户ID位，剩下的相当于 u=rwx (4+2+1),go=rx (4+1 & 4+1)。
  find path/ -type d -exec chmod a-x {} \; | 删除可执行权限对path/以及其所有的目录（不包括文件）的所有用户，使用'-type f'匹配文件
  find path/ -type d -exec chmod a+x {} \; | 允许所有用户浏览或通过目录path/
  
  
  
- curl -O 

  Mac 终端 命令行 下载文件
  curl -O 文件链接
  curl -O https://apk.izuiyou.com/download/zuiyou_data_20190625.txt
  
	- curl -O https://apk.izuiyou.com/download/zuiyou_data_20190625.txt

- ssh

  ssh -NL 8099:172.16.203.10:80 zhangyao@50.175.233.194
  
	- ssh -NL 8099:172.16.203.10:80 zhangyao@50.175.233.194

- du

  sudo du -sh *
  
	- sudo du -sh *

- export

  export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;
  
	- export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;

- grep

  grep -rn "treeControl" ./ --exclude-dir={.git,node_modules,resources,built}
  
	- grep -rn "treeControl" ./ --exclude-dir={.git,node_modules,resources,built}

- cut

	- cut out selected portions of each line of a file

	- 剪切文件每行的选定部分

	- synopsis概要

	- delim定界

	- -d

		- -d delim

		-              Use delim as the field delimiter character instead of the tab character.

	- -c

		- -c list

		- The list specifies character positions

	- -f

		- -f list

		- The list specifies fields, separated in the input by the field delimiter character (see the -d option.)  Output fields are separated by a single occurrence of the field delimiter character.

	- -n

		- -n      

		- Do not split multi-byte characters.  Characters will only be output if at least one byte is selected, and, after a prefix of zero or more unselected bytes, the rest of the bytes that form the character are selected.

	- -s

		-      -s      

		- Suppress lines with no field delimiter characters.  Unless specified, lines with no delimiters are passed through unmodified.

	- -b list

		- The list specifies byte positions Extract users' login names and shells from the system passwd(5) file as ``name:shell'' pairs:
           cut -d : -f 1,7 /etc/passwd

	- Show the names and login times of the currently logged in users:
           who | cut -c 1-16,26-38

		- zagger   console15:05
zagger   ttys00015:07
zagger   ttys00115:07
zagger   ttys00215:07
zagger   ttys00315:07
zagger   ttys00415:07
zagger   ttys00516:57
zagger   ttys00618:36

	- git branch|grep '*'|cut -d' ' -f2

- [awk](https://www.runoob.com/linux/linux-comm-awk.html)

- [tee = T 这是管线工人的术语，代表 T 型的管线分叉器](https://blog.csdn.net/jjlovefj/article/details/83176871)

  vim 用 :w !sudo tee % 进行保存的终极奥义 - ayanmw - 博客园 (cnblogs.com)
  
- [proxychains](https://www.chenxublog.com/2020/06/12/proxychains-proxy.html)

	- apt-get install proxychains

	- /etc/proxychains.conf中加入
socks5 127.0.0.1 10808

	- proxychains git clone xxxxxxxxx

- lsd

- [bat](https://zhuanlan.zhihu.com/p/43653265)

  sharkdp/bat: A cat(1) clone with wings. (github.com)
  
- onefetch

- [neofetch](https://www.linuxprobe.com/neofetch-ubuntu.html)

- du -h -d1

- [ncdu ](https://github.com/rofl0r/ncdu)

  (4 封私信 / 47 条消息) 哪些命令行工具让你相见恨晚？ - 知乎 (zhihu.com)
  
- netstat 命令

	- 简介

		- 用于显示网络状态。
利用 netstat 指令可让你得知整个 Linux 系统的网络情况。

	- 参数解释：

		- netstat -tulpn 
t:tcp
u:utp
l:listen
p:process
n:Show network addresses as numbers
n是不进行dns反向解析

	- 例子

		- netstat -n | grep 8080
windows10-bash上能找到wsl中开启的8080dev-server服务，wsl命令行中找不到。

		- watch netstat -tulpn

		- # netstat -a //显示详细的网络状况

		- 显示当前户籍UDP连接状况
# 40. netstat -nu

		- 显示UDP端口号的使用情况
# 41. netstat -apu

		- 显示网卡列表 interfaces 
# 42. netstat -i

		- 显示组播组的关系
# 43. netstat -g

		- 显示网络统计信息
# 44. netstat -s

		- 显示监听的套接口
# 45. netstat -l

- netstat

  netstat -a      # 列出所有端口
  netstat -at     # 列出所有TCP端口
  netstat -au    # 列出所有UDP端口
  netstat -ax    # 列出所有unix端口
  
  netstat -atnlp | grep "1045.spicy"  #直接使用ip地址列出所有处理监听状态的TCP端口，且加上程序名
  
	- netstat -atnlp | grep "1045.spicy"

- ss命令

	- ss -tulpn

	- watch ss -tulpn

- xargs命令

	- 概念理解

		- 通过管道接受字符串，并将接收到的字符串通过空格分割成许多参数(默认情况下是通过空格分割) 然后将参数传递给其后面的命令，作为后面命令的命令行参数

		- echo '--help' | cat 跟
echo '--help' | xargs cat 区别 

			- echo '--help' | cat 

				-  echo '--help' | cat   该命令输出的是echo的内容，也就是说将echo的内容当作cat处理的文件内容了

				- 实际上就是echo命令的输出通过管道定向到cat的输入了。然后cat从其标准输入中读取待处理的文本内容

				- 这等价于在test.txt文件中有一行字符 '--help' 然后运行  cat test.txt 的效果。

			- echo '--help' | xargs cat

				- 等价于 cat --help

				- xargs将其接受的字符串 --help 做成cat的一个命令参数来运行cat命令

				- echo 'test.c test.cpp' | xargs cat 等价于 cat test.c test.cpp 此时会将test.c和test.cpp的内容都显示出来。

	- 选项

		- -d 选项

			- 默认情况下xargs将其标准输入中的内容以空白(包括空格、Tab、回车换行等)分割成多个之后当作命令行参数传递给其后面的命令，并运行之，我们可以使用 -d 命令指定分隔符

			- echo '11@22@33' | xargs echo
输出：
11@22@33

				- 默认情况下以空白分割，那么11@22@33这个字符串中没有空白，所以实际上等价于 echo 11@22@33 其中字符串 '11@22@33' 被当作echo命令的一个命令行参数

			- echo '11@22@33' | xargs -d '@' echo
输出：
11 22 33

				- 指定以@符号分割参数，所以等价于 echo 11 22 33 相当于给echo传递了3个参数，分别是11、22、33

		- -p 选项

			- 使用该选项之后xargs并不会马上执行其后面的命令，而是输出即将要执行的完整的命令(包括命令以及传递给命令的命令行参数)，询问是否执行，输入 y 才继续执行，否则不执行。这种方式可以清楚的看到执行的命令是什么样子，也就是xargs传递给命令的参数是什么

			- echo '11@22@33' | xargs -p -d '@'  echo
输出：
echo 11 22 33

				-  ?...y      ==>这里询问是否执行命令 echo 11 22 33 输入y并回车，则显示执行结果，否则不执行
 11 22 33   ==>执行结果

		-  -n 选项

			- 该选项表示将xargs生成的命令行参数，每次传递几个参数给其后面的命令执行，例如如果xargs从标准输入中读入内容，然后以分隔符分割之后生成的命令行参数有10个，使用 -n 3 之后表示一次传递给xargs后面的命令是3个参数，因为一共有10个参数，所以要执行4次，才能将参数用完

			- echo '11@22@33@44@55@66@77@88@99@00' | xargs -d '@' -n 3 echo

				- 输出结果：
11 22 33
44 55 66
77 88 99
00

					- 等价于：
echo 11 22 33
echo 44 55 66
echo 77 88 99
echo 00

				- 实际上运行了4次，每次传递3个参数，最后还剩一个，就直接传递一个参数。

		- -E 选项，有的系统的xargs版本可能是-e  eof-str

			- 该选项指定一个字符串，当xargs解析出多个命令行参数的时候，如果搜索到-e指定的命令行参数，则只会将-e指定的命令行参数之前的参数(不包括-e指定的这个参数)传递给xargs后面的命令

			- echo '11 22 33' | xargs -E '33' echo
输出：
11 22

				- 可以看到正常情况下有3个命令行参数 11、22、33 由于使用了-E '33' 表示在将命令行参数 33 之前的参数传递给执行的命令，33本身不传递。等价于 echo 11 22 这里-E实际上有搜索的作用，表示只取xargs读到的命令行参数前面的某些部分给命令执行。

			- 注意：-E只有在xargs不指定-d的时候有效，如果指定了-d则不起作用，而不管-d指定的是什么字符，空格也不行。

				- echo '11 22 33' | xargs -d ' ' -E '33' echo  => 输出 11 22 33
echo '11@22@33@44@55@66@77@88@99@00 aa 33 bb' | xargs -E '33' -d '@' -p  echo  => 输出 11 22 33 44 55 66 77 88 99 00 aa 33 bb

		- ## -0 选项表示以 '\0' 为分隔符，一般与find结合使用

			- find . -name "*.txt"
输出：
./2.txt
./3.txt
./1.txt     => 默认情况下find的输出结果是每条记录后面加上换行，也就是每条记录是一个新行

			- find . -name "*.txt" -print0
输出：
./2.txt./3.txt./1.txt     => 加上 -print0 参数表示find输出的每条结果后面加上 '\0' 而不是换行

				- find . -name "*.txt" -print0 | xargs -0 echo
输出：
./2.txt ./3.txt ./1.txt

				- find . -name "*.txt" -print0 | xargs -d '\0' echo
输出：
./2.txt ./3.txt ./1.txt

				- xargs的 -0 和 -d '\0' 表示其从标准输入中读取的内容使用 '\0' 来分割，由于 find 的结果是使用 '\0' 分隔的，所以xargs使用 '\0' 将 find的结果分隔之后得到3个参数： ./2.txt ./3.txt ./1.txt  注意中间是有空格的。上面的结果就等价于 echo ./2.txt ./3.txt ./1.txt

				- 实际上使用xargs默认的空白分隔符也是可以的  find . -name "*.txt"  | xargs  echo   因为换行符也是xargs的默认空白符的一种。find命令如果不加-print0其搜索结果的每一条字符串后面实际上是加了换行

	- [讲得很好的一个地址](https://www.cnblogs.com/wangqiguo/p/6464234.html)

- ps命令:Processes Status 

	- process status,用于显示当前进程的状态，类似于 windows 的任务管理器

	- UNIX风格:ps -ef | grep node

		- wsl:ps -ef | grep dev-server 

		- # ps -ef | grep php //查找指定进程格式：

		- # ps -A //显示进程信息：

		- # ps -u root //显示root进程用户信息

		- # ps -ef //显示所有命令，连带命令行

		- 图示：
![image](assets/5ef133033d6bc52fd7bb845c9b84ffa450851356c4f5cf4345db38985c8a5951.png)

	- BSD风格:ps aux | grep -v grep | grep mongod

		- 图示
![image](assets/da4bea907e8680024494d1acec0dee74ff0b7a385791cbdb368706e8f323d664.png)

- top命令

- cat aaa.txt | grep bbb | cut -d' ' -f3 | sort | uniq |wc -l

- systemctl restart vdi-*;thor-*

- lsof -i tcp:8081：查看系统进程

	- lists openfiles

		- 在Unix中一切（包括网络套接口）都是文件

	- [地址](https://www.jianshu.com/p/a3aa6b01b2e1)

	- ps -A|grep nginx

		- ps -ef|grep nw

	- netstat -n|grep 80

- kill pid：杀掉系统进程

- git diff 97ecd986a7bb38cfecc745e93544f6c31ebbf48a.. --name-only | xargs zip ../patch/update.zip

- zip

	- 选项

		- -q:--quiet

			- 表示不显示压缩进度状态

		- -r:--recurse-paths

			- 表示子目录子文件全部压缩为zip；这部分比较重要，不然的话只有something这个文件夹被压缩，里面的没有被压缩进去

		- -e:--encrypt

			- 表示你的压缩文件需要加密，终端会提示你输入密码的；还有种加密方法，这种是直接在命令行里做的，比如zip -r -P Password01! modudu.zip SomeDir, 就直接用Password01!来加密modudu.zip了

		- -m：--move

			- 表示压缩完删除原文件

		- o:--latest-time

			- 表示设置所有被压缩文件的最后修改时间为当前压缩时间

	- 跨目录操作

		- zip -q -r -e -m -o '\user\someone\someDir\someFile.zip' '\users\someDir'

	- zip  [-aABcdDeEfFghjklLmoqrRSTuvVwXyz!@$]  [--longoption ...]  [-b path] [-n suffixes] [-t date] [-tt date]
       [zipfile [file ...]]  [-xi list]

- unzip

	- 选项

		- -x

			- 文件列表 解压缩文件，但不包括指定的file文件。

				- [-x xfile(s)]
An  optional list of archive members to be excluded from processing.  Since wildcard characters nor-
mally match (`/') directory separators (for exceptions see the option -W), this option may  be  used
to  exclude  any  files  that are in subdirectories.  For example, ``unzip foo *.[ch] -x */*'' wouldextract all C source files in the main directory, but none in any subdirectories.   Without  the  -x
option, all C source files in all directories within the zipfile would be extracted.

		- -n

			- 不覆盖已经存在的文件

		- -v 

			- 查看压缩文件目录，但不解压。 

		- -t

			- 测试文件有无损坏，但不解压。 

		- -d 

			- 目录 把压缩文件解到指定目录下。

		- -o

			- 覆盖已存在的文件且不要求用户确认

		- -j 

			- 不重建文档的目录结构，把所有文件解压到同一目录下

		- -z

			-  只显示压缩文件的注解。 

	- unzip [-Z] [-cflptTuvz[abjnoqsCDKLMUVWX$/:^]] file[.zip] [file(s) ...]  [-x xfile(s) ...] [-d exdir]

		- unzip test.zip 				->将test.zip解压到当前文件下
unzip -n test.zip -d /tmp 	->将test.zip解压到/tmp目录下，并且不要覆盖已有文件
unzip -v test.zip			->查看test.zip内容，但不解压
unzip -o test.zip -d tmp/	->将test.zip解压到/tmp目录下，并且覆盖已有文件


- 分类

	- 目录切换命令

		- cd usr： 切换到该目录下usr目录

		- cd ..（或cd../）： 切换到上一层目录

		- cd /： 切换到系统根目录

		- cd ~： 切换到用户主目录

		- cd -： 切换到上一个所在目录

	- 目录的操作命令（增删改查）

		- 1. mkdir 目录名称： 增加目录

		- 2. ls或者ll（ll是ls -l的缩写，ll命令以看到该目录下的所有目录和文件的详细信息）：查看目录信息

		- 3. find 目录 参数： 寻找目录（查）

			- 示例：

				- 列出当前目录及子目录下所有文件和文件夹: find .

				- 在/home目录下查找以.txt结尾的文件名:find /home -name "*.txt"

				- 同上，但忽略大小写: find /home -iname "*.txt"

				- 当前目录及子目录下查找所有以.txt和.pdf结尾的文件:find . \( -name "*.txt" -o -name "*.pdf" \)或find . -name "*.txt" -o -name "*.pdf"

			- find

				- 例子

					- find . -name "*.txt" -ok rm {} \;

					- find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch

					- 先通过find . -name '*.txt' -size +1M -type f 查看是否有大于1M的txt文件，没有的话就不用继续了
再通过find . -name '*.txt' -size +1M -type f -print0|xargs -0 
du -m|sort -nr|head -10​

					- sudo find ./ -name ".DS_Store" -depth -exec rm {} \; 

						- 删除当前目录下的所有文件是是这个的文件

				- 选项

					- 格式：
find   path   -option   [   -print ]   [ -exec   -ok   command ]   {} \;

					- -name
按照文件名查找文件。

					- -perm
按照文件权限来查找文件。

					- -user
按照文件属主来查找文件。

					- -group
按照文件所属的组来查找文件。

					- pathname: find命令所查找的目录路径。例如用.来表示当前目录，用/来表示系统根目录。

					- -prune                       #忽略某个目录

					- -print： find命令将匹配的文件输出到标准输出。

					- -exec： find命令对匹配的文件执行该参数所给出的shell命令。相应命令的形式为'command' { } \;，注意{ }和\；之间的空格。

					- -ok： 和-exec的作用相同，只不过以一种更为安全的模式来执行该参数所给出的shell命令，在执行每一个命令之前，都会给出提示，让用户来确定是否执行。

					- -axxx,xxx代表时间单位，time，min等等
a代表access，访问的文件

					- -mmin   # 查找在系统中最后N分钟里修改过的文件
m代表modify

					- -ctime    -n +n               #按文件创建时间来查找文件，-n指n天以内，+n指n天以前 

					- -size      n[c]               #查长度为n块[或n字节]的文件

					- -type    b/d/c/p/l/f         #查是块设备、目录、字符设备、管道、符号链接、普通文件

		- 4. mv 目录名称 新目录名称： 修改目录的名称（改）

			- 注意：mv的语法不仅可以对目录进行重命名而且也可以对各种文件，压缩包等进行	重命名的操作。mv命令用来对文件或目录重新命名，或者将文件从一个目录移到另一个目录中。后面会介绍到mv命令的另一个用法。

		- 5. mv 目录名称 目录的新位置：  移动目录的位置---剪切（改）

			- 注意：mv语法不仅可以对目录进行剪切操作，对文件和压缩包等都可执行剪切操作。另外mv与cp的结果不同，mv好像文件“搬家”，文件个数并未增加。而cp对文件进行复制，文件个数增加了。

		- 6. cp -r 目录名称 目录拷贝的目标位置： 拷贝目录（改），-r代表递归拷贝

			- 注意：cp命令不仅可以拷贝目录还可以拷贝文件，压缩包等，拷贝文件和压缩包时不	用写-r递归

		- 7. rm [-rf] 目录: 删除目录（删）

			- 注意：rm不仅可以删除目录，也可以删除其他文件或压缩包，为了增强大家的记忆，	无论删除任何目录或文件，都直接使用rm -rf 目录/文件/压缩包

	- 文件的操作命令（增删改查）

		- 1. touch 文件名称:  文件的创建（增）

		- 2. cat/more/less/tail 文件名称 文件的查看（查）

			- cat： 只能显示最后一屏内容

			- more： 可以显示百分比，回车可以向下一行，	空格可以向下一页，q可以退出查看

			- less： 可以使用键盘上的PgUp和PgDn向上	和向下翻页，q结束查看

			- tail-10 ： 查看文件的后10行，Ctrl+C结束

			- 注意：命令 tail -f 文件 可以对某个文件进行动态监控，例如tomcat的日志文件，	会随着程序的运行，日志会变化，可以使用tail -f catalina-2016-11-11.log 监控	文	件的变化

		- 3. vim 文件：  修改文件的内容（改）

			- vim编辑器是Linux中的强大组件，是vi编辑器的加强版，vim编辑器的命令和快捷方式有很多，但此处不一一阐述，大家也无需研究的很透彻，使用vim编辑修改文件的方式基本会使用就可以了。

			- 在实际开发中，使用vim编辑器主要作用就是修改配置文件，下面是一般步骤：

			- vim 文件------>进入文件----->命令模式------>按i进入编辑模式----->编辑文件	------->按Esc进入底行模式----->输入:wq/q! （输入wq代表写入内容并退出，即保存；输入q!代表强制退出不保存。）

		- 4. rm -rf 文件： 删除文件（删）

			- 同目录删除：熟记 rm -rf 文件 即可

	- 压缩文件的操作命令

		- 1）打包并压缩文件：

			- Linux中的打包文件一般是以.tar结尾的，压缩的命令一般是以.gz结尾的。

			- 而一般情况下打包和压缩是一起进行的，打包并压缩后的文件的后缀名一般.tar.gz。

			- 命令：tar -zcvf 打包压缩后的文件名 要打包压缩的文件

			- 其中：

				- z：调用gzip压缩命令进行压缩

				- c：打包文件

				- v：显示运行过程

				- f：指定文件名

			- 比如：加入test目录下有三个文件分别是 :aaa.txt bbb.txt ccc.txt,如果我们要打包test目录并指定压缩后的压缩包名称为test.tar.gz可以使用命令：tar -zcvf test.tar.gz aaa.txt bbb.txt ccc.txt或：tar -zcvf test.tar.gz /test/

		- 2）解压压缩包：

			- 命令：tar [-xvf] 压缩文件

				- 其中：x：代表解压

			- 示例：

				- 1 将/test下的test.tar.gz解压到当前目录下可以使用命令：tar -xvf test.tar.gz

				- 2 将/test下的test.tar.gz解压到根目录/usr下:tar -xvf xxx.tar.gz -C /usr（- C代表指定解压的位置）

	- Linux的权限命令

		- 权限概念：

			- 操作系统中每个文件都拥有特定的权限、所属用户和所属组。

			- 权限是操作系统用来限制资源访问的机制，在Linux中权限一般分为读(readable)、写(writable)和执行(excutable)，分为三组。分别对应文件的属主(owner)，属组(group)和其他用户(other)，通过这样的机制来限制哪些用户、哪些组可以对特定的文件进行什么样的操作。

		- 查看权限

			- 通过 ls -l 命令我们可以查看某个目录下的文件或目录的权限

				- 示例：在随意某个目录下ls -l
![image](assets/df5b6e75a9b8bc09886d87900a89d2b285f97a49ce5e239e9ad9b2a4c33e0b6f.png)

					- 第一列的内容的信息解释如下：
![image](assets/7306a9313541702fe931338d0322dcaccce5707cd1d25616cb33dee7c4aaba01.png)

		- 下面将详细讲解文件的类型、Linux中权限以及文件有所有者、所在组、其它组具体是什么？

			- 文件的类型：

				- d： 代表目录

				- -： 代表文件

				- l： 代表链接（可以认为是window中的快捷方式）

			- Linux中权限分为以下几种：

				- r：代表权限是可读，r也可以用数字4表示

				- w：代表权限是可写，w也可以用数字2表示

				- x：代表权限是可执行，x也可以用数字1表示

			- 文件和目录权限的区别：

				- 对文件和目录而言，读写执行表示不同的意义。

					- 文件
![image](assets/940987cc7ca56db832700324c802eae1f514954f628660cd5d5ed47e8b8bfb82.png)

					- 目录
![image](assets/1b7fb12fed1d378a3f0f6b48bb4e53a26021bba6b1184842d196a6457cf1c662.png)

			- 在linux中的每个用户必须属于一个组，不能独立于组外。在linux中每个文件有所有者、所在组、其它组的概念。

				- 所有者

					- 一般为文件的创建者，谁创建了该文件，就天然的成为该文件的所有者，用ls ‐ahl命令可以看到文件的所有者 也可以使用chown 用户名 文件名来修改文件的所有者 。

				- 文件所在组

					- 当某个用户创建了一个文件后，这个文件的所在组就是该用户所在的组 用ls ‐ahl命令可以看到文件的所有组 也可以使用chgrp 组名 文件名来修改文件所在的组。

				- 其它组

					- 除开文件的所有者和所在组的用户外，系统的其它用户都是文件的其它组

		- 我们再来看看如何修改文件/目录的权限。

			- 修改文件/目录的权限的命令：chmod

				- 示例：修改/test下的aaa.txt的权限为属主有全部权限，属主所在的组有读写权限， 其他用户只有读的权限

				- chmod u=rwx,g=rw,o=r aaa.txt

					- 图示
![image](assets/fd119b4b9b784daf0e2428029afef9305c61ecc04296d58716967402091ceca6.png)

					- chmod 764 aaa.txt

			- 补充一个比较常用的东西:

				- 假如我们装了一个zookeeper，我们每次开机到要求其自动启动该怎么办？

				- 新建一个脚本zookeeper

				- 为新建的脚本zookeeper添加可执行权限，命令是:chmod +x zookeeper

				- 把zookeeper这个脚本添加到开机启动项里面，命令是：chkconfig --add zookeeper

				- 如果想看看是否添加成功，命令是：chkconfig --list

	- Linux 用户管理

		- 概念：

			- Linux系统是一个多用户多任务的分时操作系统，任何一个要使用系统资源的用户，都必须首先向系统管理员申请一个账号，然后以这个账号的身份进入系统。

			- 用户的账号一方面可以帮助系统管理员对使用系统的用户进行跟踪，并控制他们对系统资源的访问；另一方面也可以帮助用户组织文件，并为用户提供安全性保护。

		- Linux用户管理相关命令:

			- useradd 选项 用户名:添加用户账号

			- userdel 选项 用户名:删除用户帐号

			- usermod 选项 用户名:修改帐号

			- passwd 用户名:更改或创建用户的密码

			- passwd -S 用户名 :显示用户账号密码信息

			- passwd -d 用户名:  清除用户密码

		- 总结

			- useradd命令用于Linux中创建的新的系统用户。useradd可用来建立用户帐号。帐号建好之后，再用passwd设定帐号的密码．而可用userdel删除帐号。使用useradd指令所建立的帐号，实际上是保存在/etc/passwd文本文件中。

			- passwd命令用于设置用户的认证信息，包括用户密码、密码过期时间等。系统管理者则能用它管理系统用户的密码。只有管理者可以指定用户名称，一般用户只能变更自己的密码。

	-  Linux系统用户组的管理

		- 概念

			- 每个用户都有一个用户组，系统可以对一个用户组中的所有用户进行集中管理。不同Linux 系统对用户组的规定有所不同，如Linux下的用户属于与它同名的用户组，这个用户组在创建用户时同时创建。

			- 用户组的管理涉及用户组的添加、删除和修改。组的增加、删除和修改实际上就是对/etc/group文件的更新。

		- Linux系统用户组的管理相关命令:

			- groupadd 选项 用户组 :增加一个新的用户组

			- groupdel 用户组:要删除一个已有的用户组

			- groupmod 选项 用户组 : 修改用户组的属性

	- 其他常用命令

		- pwd： 显示当前所在位置

		- grep 要搜索的字符串 要搜索的文件 --color： 

			- 搜索命令，--color代表高亮显示

		- ps -ef/ps aux： 这两个命令都是查看当前系统正在运行进程，两者的区别是展示格式不同。

			- 如果想要查看特定的进程可以使用这样的格式：ps aux|grep redis （查看包括redis字符串的进程）

			- 注意：如果直接用ps（（Process Status））命令，会显示所有进程的状态，通常结合grep命令查看某进程的状态。

		- kill -9 进程的pid： 杀死进程（-9 表示强制终止。）

			- 先用ps查找进程，然后用kill杀掉

		- 网络通信命令：

			- 查看当前系统的网卡信息：ifconfig

			- 查看与某台机器的连接情况：ping

			- 查看当前系统的端口使用：netstat -an

		- shutdown：  shutdown -h now： 指定现在立即关机；

			- shutdown +5 "System will shutdown after 5 minutes":指定5分钟后关机，同时送出警告信息给登入用户。

		- reboot：  reboot：  重开机。

			- reboot -w： 做个重开机的模拟（只有纪录并不会真的重开机）。

	- [文章来源地址](https://juejin.cn/post/6844903634036064269)

	- 查询linux命令的网站
![image](assets/28e3036368c3a722e38da6184a2834c43fed2c8b5434eb1cb78d2f5782015de0.svg)

		- [地址](https://man.linuxde.net/)

### 45.1.1. [chrome plugin: vimium](https://www.zhihu.com/question/23483616?sort=created)

作者：小佐
链接：https://www.zhihu.com/question/23483616/answer/246787555
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

最常用的快捷键
向下/上/左/右移动  j/k/h/l
向下/上跳动  d/u
回到顶/尾部  gg/G
窗口打开模式 本窗口/新窗口 f/F
查找历史记录+书签   o/O
关闭/恢复标签 x/X
查找书签  b/B（当前/新窗口打开）
选择左/右标签 J/K
搜索剪贴板关键字 在当前/新窗口  p/P
跳转到当前url上一级/最高级 gu/gU
创建/查看标签页  t/T
将焦点聚集在第一个输入框  gi  (2gi就是第二个输入框)
刷新 r
新标签中打开多个链接   <a-f> 即：alt+f
开/关静音  <a-m>即：alt+m
固定标签栏 <a-p>即 alt+p
上一个标签  ^


其他不常用快捷键

查找（不支持中文）  /
    向下/上查找结果  n/N  (回车后直接打开链接，不用再使用f/F定位)
复制当前链接 yy
新模式 i
查看源码 gs
查看所以快捷键 ?
编辑当前地址栏 g+e/E   并在当前/新窗口中打开
复制当前标签页  yt
移动当前标签到左/右侧边  <</>>
滚动到页面最左/右边（在有滚动条下才有效果） zH/zL
插入模式  i（可以屏蔽掉vimium快捷键，使其不和网页默认快捷键冲突）
将标签页移动到新窗口  W
创建新标记（可创建多个   m 使用方法
      设置当前/全局滚动条位置   m+小/大写字母
      跳转到设置的滚动位置   ~+字母
切换到复制模式 v


其他技巧

焦点切换
    从地址栏切换回页面  tag
翻页
    下/上一页  ]]  [[  部分网站不支持  可以使用 Shortcut Manager 插件代替
    下一页代码：
        function next(){
            var a=$(".cur").next().find("a").attr("href");
             window.location.assign(a);
        }
        next();
    上一页代码：
        function after(){
            var a=$(".cur").prev().find("a").attr("href");
             window.location.assign(a);
        }
        after();
自定义搜索引擎
    设置：
        请查看选项：Custom search engines
    使用：
        按b/B打开搜索框，输入搜索引擎关键字+空格
    扩展：
        计算功能
            g (1+2)*3-4=     进入google搜索模式直接输入公式后面加"="号
打开chrome系统页面
    chrome设置页面
        about:setting
    扩展程序
        about:extensions
    历史(history)，下载(downloads)，书签(bookmarks),建议使用chrome默认快捷键代替
        ctrl+h,ctrl+j,ctrl+shift+o
关于<a-p>,<c-e>
    是emacs中的表示方法，分别指alt+p,ctrl+e
快速定位+复制文本：alt+f,v,hjkl,y四步曲
    alt+f 搜索指定关键字，并定位到起始点
    再按v切换到复制模式
    再使用hjkl控制方向选择范围
    最后y复制
删除/修改命令
    删除指定命令
        unmap j   删除命令j
        unmapAll  删除所有命令
    修改命令（后面的命令参数可以在选择里面打开 show available commands找到）
        map a LinkHints.activateMode  把a定义原来f的功能
        map f scrollPageDown   把f定义成原来d的功能
本地文件中使用vimium
    打开chrome插件设置页面，勾选"允许访问文件网址"

### 45.1.2. 虚拟机

-  
![image](assets/e7fee5fd46356b984b4ed89a02da8859a75fca930cf4666e1b0e346d845f2a09.png)

-  
![image](assets/956e943a8656814ea63d49c02befa7bb9cd2976cb87b98ec0132580fa5bbb5d9.png)

### 45.1.3. 文件权限

- [地址](https://www.cnblogs.com/songgj/p/8890710.html)

- 文件基本权限

	- 首先看下linux下的文件权限，可以使用ll命令或者是带-l（长列表选项）的ls命令。
![image](assets/ad2bbcde3f8456f534c94787c32c7dc26739e077ffedf307e58b40537896ec4a.png)

- 文件列表信息

	- ：文件类型、权限、链接数、所属用户、所属用户组、文件大小、最后修改时间、文件名。

### 45.1.4. linux命令可以从两个地方读取要处理的内容

- 一个是通过命令行参数

- 一个是标准输入

- cat、grep

	- 命令行参数、标准输入，两个都支持

		- echo 'main' | cat test.cpp

			- cat会输出test.cpp的内容，而不是'main'字符串

			- echo 'main' | 会通过管道将 echo 的标准输出(也就是字符串'main')导入到 cat 的标准输入，也就是说此时cat的标准输入中是有内容的，其内容就是字符串'main'但是上面的内容中cat不会从它的标准输入中读入要处理的内容

			- 标准输入是有一个缓冲区的

			- 很多的命令的设计是先从命令行参数中获取参数，然后从标准输入中读取

		- echo 'main' | cat

			- 命令中cat会从其标准输入中读取内容并处理，也就是会输出 'main' 字符串

			- echo命令将其标准输出的内容 'main' 通过管道定向到 cat 的标准输入中。

		- cat

			- 仅仅输入cat并回车，则该程序会等待输入，我们需要从键盘输入要处理的内容给cat

			- 此时cat也是从标准输入中得到要处理的内容的，因为我们的cat命令行中也没有指定要处理的文件名

		- echo 'main' | cat -

			- 大多数命令有一个参数  -  如果直接在命令的最后指定 -  则表示从标准输入中读取

			- 会显示 'main' 字符串

		- echo 'main' | cat test.cpp -

			- 同时指定test.cpp 和 - 参数，此时cat程序会先输出test.cpp的内容，然后输出标准输入'main'字符串

		- echo 'main' | cat - test.cpp

			- 会先输出标准输入'main'字符串，然后输出test.cpp文件的内容

		- echo 'main' | grep 'main' test.cpp -

			-  
![image](assets/8d6b33ca8a1a5842e6b8a9b2eaf8c53a58f9b5ff68b3ef98fdb9ad78ecddb3e6.png)

- 另外很多程序是不处理标准输入的，例如 kill , rm 这些程序如果命令行参数中没有指定要处理的内容则不会默认从标准输入中读取

	- 不执行

		- echo '516' | kill

		- echo 'test' | rm -f

	- kill 是结束进程，rm是删除文件

	- 方法

		- 1. 通过 kill `ps -ef | grep 'ddd'`    
#这种形式，这个时候实际上等同于拼接字符串得到的命令，其效果类似于  kill $pid

		- 2. for procid in $(ps -aux | grep "some search" | awk '{print $2}'); do kill -9 $procid; done   
#其实与第一种原理一样，只不过需要多次kill的时候是循环处理的，每次处理一个

		- 3. ps -ef | grep 'ddd' | xargs kill  
#OK，使用了xargs命令，铺垫了这么久终于铺到了主题上。xargs命令可以通过管道接受字符串，并将接收到的字符串通过空格分割成许多参数(默认情况下是通过空格分割) 然后将参数传递给其后面的命令，作为后面命令的命令行参数

### 45.1.5. [Linux和UNIX的关系及区别（详解版）](http://c.biancheng.net/view/707.html)

### 45.1.6. 命令行翻墙：用proxychains-ng为程序设置代理

- [地址](https://www.jianshu.com/p/f7902bba9499)

- macos配置文件目录：nvim /usr/local/etc/proxychains.conf

	- 图示
![image](assets/f527b72ad50243bba9095ca3bfb30be3454fde3127336d60693f46f350fce9d9.png)

- proxychains后面接ping命令是不可以的，因为proxychains是在tcp层，ping命令是基于icmp在ip层

- proxychains后面可以接很多命令，curl、wget、git等等，当要下载国外资源的时候这个能提速很多，特别是链接github。

- macos上失效时，尝试这么解决

	- 图示
![image](assets/4b1d5daae4a1f11e9b02c561d73f3a9fe701413155b197a8c1c6c06f52f76bea.png)

	- m1电脑尝试长按电源键进入恢复模式而不是cmd+r

### 45.1.7. tar
![image](assets/EC42BE1B-4426-47DA-AAD8-C8BE1F30926D.svg)

- tar打包压缩指令
-c --create create a new archive
-t --list list the contents of an archive
-x  --extract extract files from an archive
 -C, --directory=DIR        change to directory DIR
 -v, --verbose              verbosely list files processed
![image](assets/20625b8b0a5ff28b66cc35b789ee047c6d35a61619dedc76cfc887c95120e7fe.png)

- 参考链接

	- [1. Linux中tar归档命令、zip压缩、gzip压缩、bzip2压缩](https://blog.csdn.net/m0_52165864/article/details/123998531)

### 45.1.8. 2>&1 &
![image](assets/2E151106-C2A9-49AB-987D-ADBBED303E7F.svg)

- [bash中 2>&1 & 的详细解释](https://blog.csdn.net/astonqa/article/details/8252791)
![image](assets/788dfb1fd20d8a82bcfa70ec4e8279c735abcb2016490f558b51ea64dc529bae.png)

- 参考链接：
1.一起深入理解 Linux shell 中 2>&1 的含义叭~：https://baijiahao.baidu.com/s?id=1709055194390039623&wfr=spider&for=pc

### 45.1.9. sort

- sort用法和实例
![image](assets/458150b541736521dab45158f3a38b12df6776313f34d3f5e2c677defed7c4fa.png)

### 45.1.10. uniq

- uniq用法和示例
![image](assets/4f6ac37efaeb318993e100aa421adc367b0a0ee77ea36749eb9ecce2ddb1c271.png)

- 例子
![image](assets/ccf0967ac7371319575bf88b7b01b0df675caeeb7b150f024330d5bfcd4c621a.png)

### 45.1.11. tee

- read from standard input and write tostandard output and files
翻译：读取标准输入的数据，并将其内容输处成文件，

- 语法
![image](assets/181e34f4a14143943eff34dcdbf87ea92ee668c55833d0b383cda655fe591820.png)

- 例子2
![image](assets/0060b183b80a02bfd6ecb70dc5899227a1ecb9f7e472d4b898eb242a79f1a614.png)

- :w !sudo tee %

	- 假设你是一个非root用户，你正在修改root用户拥有的文件，忘记使用sudo权限打开文件，现在你想保存更改

- 参考链接：https://blog.51cto.com/linux2023/5011391

### 45.1.12. grep

- g/re/p（globally search a regular expression and print)，使用正则表示式进行全局查找并打印

- 选项：
$ grep [-acinv] [--color=auto] 搜寻字符串 filename
-c ： 统计匹配到行的个数
-i ： 忽略大小写
-n ： 输出行号
-v ： 反向选择，也就是显示出没有 搜寻字符串 内容的那一行
--color=auto ：找到的关键字加颜色显示

- 两个例子
![image](assets/6033f414673de8b5a7655394d7a73d9011384b8a51291f3b5dcdd43114098367.png)

### 45.1.13. printf

- 例子
![image](assets/7b9deb8a36a6b2e97ebc21e0a000c0530a8d9295cf8d8cb1372009c94b3fe610.png)

- printf说明
![image](assets/4668520b8ff01065b3dbde146edbfc148c058e825045122e2d4e2a826fbf5ae3.png)

### 45.1.14. awk

- 语法：
awk 'BEGIN{ commands } /pattern/ {commands} END{ commands }'

- 1、BEGIN{ commands }，开始块就是在程序启动的时候执行的代码部分，并且它在整个过程中只执行一次。一般情况下，我们可以在开始块中初始化一些变量。
注意：开始块部分是可选的，你的程序可以没有开始块部分。
2、/pattern/ {commands}，pattern 部分匹配该行内容成功后，才会执行commands 的内容。
3 END{ commands }，结束块是在程序结束时执行的代码。
注意：结束块部分也是可选的


- 参考链接：https://blog.csdn.net/weixin_43623871/article/details/118436010


- awk基本用法

	- 选项
![image](assets/1112eda367af237a73c1aed11be4205024e029f0ab01a1f6ccfcca58296e22d7.png)

	- 不同的例子：
cat 1.txt
 2 this is a test1
 3 Are you like awk1
 This's a test1
 10 There are orange,apple,mongo

		-  
![image](assets/65d6103b25ccda50b7a1ece23f92da9366cca71ccdfa29d66b19d9228d949ab8.png)

		-  
![image](assets/ecc0e3272d99a5af783dce85d1d02f977a0747a5856aa6f5eec23e5099f367ed.png)

		-  
![image](assets/a826ccd719b2497a90fdd2d243a2de095ff780e54a08dccb11f86dab17b5d2d9.png)

		-  
![image](assets/419e73586199fbc8034a2c46aa1b2af29dc836b160bc570faed959c90e979010.png)

		-  
![image](assets/0fd2dea3372cc7b782d639c23df0db04a45c546cc93199af8b2d25fce933fc30.png)

		-  
![image](assets/78ba984911a509b8d4f7161ff5c0b64772e17dbba8ed91ba7df8b70e34d6ac1e.png)

		-  
![image](assets/e223c53fdeb5e94f10cd3fb50ad76569bf3f5b50201fca450bf0c03798d8fdf6.png)

		- 直接跑脚本读取awk命令
![image](assets/51e2a55657470975980b8e5cc04d410eb5388cca3da8a09eba8a719c7c1fe187.png)

- awk常用系统变量

	-  
![image](assets/badd60a835a17153d0ed38c3644adcb3f0b55990d71e3a04f7e221743d093ddb.png)

		- FS：The input field separator，a space by default
OFS：The output field separator, a space by default
RS:The input record separator,bu default a newline
NR:The total number of input records seen so far
NF：The number of fileds in the currnet input record

	- 例子

		- FS指定读取分隔符
![image](assets/407149b4372b9ebec8060a8312f6bc1ee820b694fe35b684329c0d06774dccbf.png)

		- OFS指定输出分隔符
![image](assets/49d1a44f9e8b781d9afd384fbe57cd8917b35efee3d601b05f23879cf4bcf724.png)

		- RS，默认的行分隔符从\n改为：
![image](assets/8f7ac7071938d5e0afef7c15000565e7b906488c7fd42b4c541706048ff92e52.png)

		- NR和FNR显示行号
![image](assets/f7ceb0b8f4fa7c7fcb922aec81028c826b075cb2cf1200ecb774dc6f0823693a.png)

		- NF输出每行中字段有多少个和$NF输出最后一行的内容
![image](assets/73028c166f5ac982e208391d340d2e8f44236633e0f0e38311ab50a6baa390c2.png)

	- 继续例子:
$ cat log.txt
 2 this is a test1
 3 Are you like awk1
 This's a test1
 10 There are orange,apple,mongo

		- 输出包含re的行
![image](assets/2b2fc40eedce5b0ce9546079cb567868627b622e726751a748740024f0580e0d.png)

		- 忽略大小写
![image](assets/e5211624d2c58fbb1de118c8a654c95a34c4e81b85ba63ac79909ec7b2a9651e.png)

		- 输出第二列包含 "th"，并打印第二列与第四列  ~代表模式
![image](assets/967e6d50ca6f795dade69a60d19ac9192b14e5f7e62f385693837f52a17c2dae.png)

		- 模式取反
![image](assets/c2640edfca404b417bbc4416e6a2c148d310819260384df4feeb9d20743f448b.png)

		- 模式取反
![image](assets/353664986e70c9c49622e0e4b3a53c9106f5b8a4e7ad4c5a8affec2990e28f21.png)

		- 计算大小
![image](assets/19cdfb60b548e822f54ae1ad5b741d2d1f0b119e0625606838399616c494b29c.png)

		- #从文件中找出长度大于 80 的行
![image](assets/51502244e7229b09d30d735fd958ccd59bdcf605271c4ec8fe06b69b987e1741.png)

		- seq 9 | sed 'H;g' | awk -v RS='' '{for(i=1;i<=NF;i++)printf("%dx%d=%d%s", i, NR, i*NR, i==NR?"\n":"\t")}' 
#打印九九乘法表

- awk循环和数组

	- 例子

		- 从一行的第二个字段开始读取，NF自动读取该行有多少个字段
![image](assets/568439311a709241b78d2105a1d90b20bf821fa22dd4682b33553dcb0ee88421.png)

		- 求每行第二个字段到最后一个字段相加的平均数
![image](assets/4029231640923ebfb0239d1ae23bab742e3396d5d726bf195470d91b00605b7e.png)

		- 将每行第二个字段到最后一个字段相加的平均数按照$1表示的字符串作为key，平均数作为value，形成一个对象，average。然后打印average，
![image](assets/5ae18a2f99d057c47c85db6da3d8cd3e263678330ec13a42c11aef6fe1a2386e.png)

		- 按照不同格式打印average
![image](assets/111340205265a3a4d2210dc830a507dcfcf5b52a40d26e9ae259d2ff7ec91769.png)

- 命令行参数数组
ARGC 命令行参数的数目
ARGV 包含命令行参数的数组

	- ARGC命令行参数树木
ARGV命令行参数数组
![image](assets/283367d95e586d5c50c8ccd121561300d9730130e9da20503012f6b3a632272c.png)

- 参考链接：

	- [1.Linux-awk用法](https://blog.csdn.net/weixin_43623871/article/details/118436010)

### 45.1.15. sed

- Linux sed 命令是利用脚本来处理文本文件。

sed 可依照脚本的指令来处理、编辑文本文件。

sed 主要用来自动编辑一个或多个文件、简化对文件的反复操作、编写转换程序等。

- 语法
sed [-hnV][-e<script>][-f<script文件>][文本文件]

- 参数说明：

-e<script>或--expression=<script> 以选项中指定的script来处理输入的文本文件。
-f<script文件>或--file=<script文件> 以选项中指定的script文件来处理输入的文本文件。
-h或--help 显示帮助。
-n或--quiet或--silent 仅显示script处理后的结果。
-V或--version 显示版本信息。
-i	此选项会直接修改源文件，要慎用。
-i[SUFFIX], --in-place[=SUFFIX]  edit files in place (makes backup if SUFFIX supplied)

	- 注意:，原本应该是要 sed -e 才对，没有 -e 也！同时也要注意的是， sed 后面接的动作，请务必以 '' 两个单引号括住

- 动作说明：

a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
d ：删除，因为是删除啊，所以 d 后面通常不接任何东东；
i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！

- sed脚本命令

	- sed s 替换脚本命令

		- 此命令的基本格式为：
[address]s/pattern/replacement/flags

		- 其中，address 表示指定要操作的具体行，pattern 指的是需要替换的内容，replacement 指的是要替换的新内容。

		-  sed s命令flags标记及功能

			- flags 标记	功能
n	1~512 之间的数字，表示指定要替换的字符串出现第几次时才进行替换，例如，一行中有 3 个 A，但用户只想替换第二个 A，这是就用到这个标记；
g	对数据中所有匹配到的内容进行替换，如果没有 g，则只会在第一次匹配成功时做替换操作。例如，一行数据中有 3 个 A，则只会替换第一个 A；
p	会打印与替换命令中指定的模式匹配的行。此标记通常与 -n 选项一起使用。
w file	将缓冲区中的内容写到指定的 file 文件中；
&	用正则表达式匹配的内容进行替换；
\n	匹配第 n 个子串，该子串之前在 pattern 中用 \(\) 指定。
\	转义（转义替换部分包含：&、\ 等）。

	- sed d 替换脚本命令

		- 此命令的基本格式为：
[address]d

			- 删除 data6.txt 文件内容中的第 3 行
 sed '3d' data6.txt

			- 删除 data6.txt 文件内容中的第 2、3行
 sed '2,3d' data6.txt

			- sed 会删除两个指定行之间的所有行（包括指定的行）
sed '/1/,/3/d' data6.txt

				- 可以使用两个文本模式来删除某个区间内的行，但这么做时要小心，你指定的第一个模式会“打开”行删除功能，第二个模式会“关闭”行删除功能，因此，sed 会删除两个指定行之间的所有行（包括指定的行）

			- 通过特殊的文件结尾字符，比如删除 data6.txt 文件内容中第 3 行开始的所有的内容
 sed '3,$d' data6.txt

	- sed a 和 i 脚本命令

		- a 命令表示在指定行的后面附加一行，i 命令表示在指定行的前面插入一行，这里之所以要同时介绍这 2 个脚本命令，因为它们的基本格式完全相同，如下所示：
[address]a（或 i）\新文本内容

	- sed c 替换脚本命令

		- c 命令表示将指定行中的所有内容，替换成该选项后面的字符串。该命令的基本格式为：
[address]c\用于替换的新文本

	- sed y 转换脚本命令

		- y 转换命令是唯一可以处理单个字符的 sed 脚本命令，其基本格式如下：
[address]y/inchars/outchars/

		- 转换命令会对 inchars 和 outchars 值进行一对一的映射，即 inchars 中的第一个字符会被转换为 outchars 中的第一个字符，第二个字符会被转换成 outchars 中的第二个字符...这个映射过程会一直持续到处理完指定字符。如果 inchars 和 outchars 的长度不同，则 sed 会产生一条错误消息。

			- sed 'y/123/789/' data8.txt
This is line number 7.
This is line number 8.
This is line number 9.
This is line number 4.
This is line number 7 again.
This is yet another line.
This is the last line in the file.

	- sed p 打印脚本命令

		- p 命令表示搜索符号条件的行，并输出该行的内容，此命令的基本格式为：
[address]p

	- sed w 脚本命令

		- w 命令用来将文本中指定行的内容写入文件中，此命令的基本格式如下：
[address]w filename

	- sed r 脚本命令

		- r 命令用于将一个独立文件的数据插入到当前数据流的指定位置，该命令的基本格式为：
[address]r filename

	- sed q 退出脚本命令

		- q 命令的作用是使 sed 命令在第一次匹配任务结束后，退出 sed 程序，不再进行对后续数据的处理。

			- [root@localhost ~]# sed '2q' test.txt
This is line number 1.
This is line number 2.

			- [root@localhost ~]# sed '/number 1/{ s/number 1/number 0/;q; }' test.txt
This is line number 0.

使用 q 命令之后，sed 命令会在匹配到 number 1 时，将其替换成 number 0，然后直接退出。

	- 参考链接：

		- [1.Linux sed命令完全攻略（超级详细）](http://c.biancheng.net/view/4028.html)

### 45.1.16. 虚拟机切换图形界面和命令行的快捷键
![image](assets/a07400765174535bec0a4b2a713d9e4f8f0c53cc1eb2f9ec58b3595a4e9c3b83.svg)

- 快捷键
![image](assets/77ed8b3c4b5e728ffae414604d2a171fd33fca09e8d0a276a8d28f24bcf894f9.png)

### 45.1.17. cut
![image](assets/EADB7270-629E-4288-8976-D9D8E3F7E364.svg)

- last | cut -c 1-8

- last | cut -d ' ' -f 1

- 参考链接：
【Linux篇】cut命令详解：https://blog.csdn.net/weixin_45842494/article/details/124679008

### 45.1.18. ubuntu arm64版本 fd安装

- apt-get install cargo

git clone https://github.com/sharkdp/fd

# 46. Build
cd fd
cargo build

# 47. Run unit tests and integration tests
cargo test

# 48. Install
cargo install --path .

vim ~/.zshrc 

# 49. add env
PATH=/root/.cargo/bin:$PATH




### 49.1.1. 一、Linux发展史

- 1、linux前身-Unix

	- 1968年Multics项目
MIT：美国麻省理工
Bell实验室
美国通用电气有点公司

	- 1970年Unix诞生
Multics项目中，一个开发成员开发了一款游戏叫travel space
他提议重新在Multics项目上重新开发，就出现了1970的Unix，
当时Unix操作系统是使用汇编语言（机器语言）开发的
时间戳指从1970年的1月1号0点0分0秒，1970叫Unix元年

	- 1973年用c语言重写了Unix

		- 汇编语言对硬件要求高，导致软件移植性不好

	- 1975年Bell实验室允许大学使用Unix

	- 1975年Bell实验室允许大学Unix操作系统用于教学，不允许商业用途

- 2、Linux诞生

	- linus是linux之父

		- 背景
荷兰大学
当时1991年，学校使用Unix操作系统
任何人都可以修改，linus进行了修改。
文件名命名为linus's Unix，后面网络管理员发现不好听，改成了Linux
其他同学也将自己的代码贡献给linus产生了1992年0.02版本，1994年1.0版本，2003年2.6版本
这个版本号并不是Linux分支版本，而是linux的内核版本

- 3、开源文化

	- Linux是开源的操作系统，所谓开源就是指开放源代码，任务 stallman，开源文化倡导人

	- 1983年 GNU计划

	- 1985年FSF基金会

	- 1990年Emacs、Gcc(C语言的编译器)、程序库

	- 1991年Stallman去找Linux加入其开源计划（GNU计划）

	- 1992年GNU/Linux

- 4、Linux系统特点

	- 开放性（开源）
多用户、
多任务
良好的用户界面
优异的性能与稳定性（可以连续用很多天，1658天，使用ups备用电源，用的时间更长）

	- 单用户：在登录计算机（操作系统），只能允许同时登录一个用户
多用户：多个用户，在登录计算机，允许同时登录多个用户进行同步操作

	- 单任务：允许用户同时进行的操作任务数量
多任务：允许用户同时进行多个操作任务

	- Windows单用户、多任务

		- 单用户：别人远程登录我的用户，我当前用户就一定锁屏了
多任务：任务管理器，多个进程，多个软件可以同时运行

	- linux多用户、多任务

- 5、Linux分支

	- Linux是一个笼统的概念，
Linux分支有很多，现在比较有名的有：Ubuntu、debian（主线）、centos（redhat主线上的分支）、redhat（主线）、suse（slackware主线上的分支）

		- 主线：
debian
redhat
slackware

		- Ubuntu用户界面很好看

		- centos
Community Enterprise Operating System
社区企业操作系统，Linux发行版之一，它是来自于Red Hat Enterprise Linux
为什么不直接用redhat，因为redhat收费

### 49.1.2. 二、Linux系统的安装

- 1、安装方式

	- 目前安装操作系统方式有两种：真机安装、虚拟机安装
真机安装：使用真实的电脑进行安装，想安装windows操作系统一样；真机安装的结果就是替换掉当前的windows操作系统或者双系统。
虚拟机安装：通过一些特定的手段来进行模拟安装，并不会影响当前计算机的真实操作系统，如果是学习或者测试使用，强烈建议使用虚拟机安装方式。

- 2、虚拟机软件

	- 虚拟机：
模拟真机的环境，碍于使用真机安装代价比较大，因此而诞生的一款可以模拟操作系统运行的软件
虚拟机目前有两个比较有名的产品：
vmware出品的vmware workstation（重量级）、oracle 出品的virtual Box（轻量级）。

- 3、虚拟机的安装

	- 1、vmware出品的vmware workstation

		- 网上找破解软件 直接安装

			-  
![image](assets/5ae53e045786fb524954e141ea50d8d8427cff154e85578432d69e881e20703e.png)

			- 比较重要，检查系统是否有两个虚拟机网卡，如果没有，就说明虚拟机安装有问题
没有，会相应后期windows系统与虚拟机其中操作系统之间的相互通讯（比如共享网络、文件传输等等）
![image](assets/8e8c8f1af190a1318479e42bc4d2e5d87bb4de62852ab5087b3188280996ee74.png)

	- 2、virtual box

		- 1.点击安装程序
![image](assets/0f4974239a1071d044c555ec9e8be0688b467013cb65568609a4929da60b45ac.png)

		- 2.断网警告
![image](assets/c31d392ab4768d65066c4b01e27fd5558184dbcc968d7525a301f82fe684c855.png)

		- 3.界面
![image](assets/fd62ebc3817aa8ba598d106ec12b0a304aeec4e4076a68c6a774da30e7504782.png)

- 4、linux版本的选择

	- 版本选择：Centos6.5
【镜像一半都是xxx.iso文件】

	- 问题：为什么不选择最新版的7.x版本？
6.x目前依然是主流
6.x的各种系统操作模式是基础
7.x实际上也支持大多数6.x的操作形式

	- 官网
https://www.centos.org/

- 5. centos安装

	- 1. 虚拟机安装

		- 1.选择高级
![image](assets/25955bf3bedc9acb67e0f274b96eef8df75718ad28304496b0ef57a0a33e5c7b.png)

		- 2.选择兼容性为最高的那个，默认即可
![image](assets/3ecc00b97e476d74b1134be48c1abfaf33bd2a2574fdefcfd87fa868b9ac7183.png)

		- 3.先选择稍后安装
![image](assets/8cf1b942597d48946bc6c29c3b5418ab6b782934b7dd0c97bcb42a14375ce821.png)

		- 4.选择linux centos 64位
![image](assets/0670dc5aaeab7ed12decb057a75de08f9abc33af6e4dc18a09b3d315784ce52e.png)

		- 5.填写虚拟机的名称和虚拟机的位置
![image](assets/06ba6f710aa3cb3a072afccff349161931bd29a240797792b23621eb65e5d566.png)

		- 6.选择cpu的配置，默认即可
![image](assets/3a74123fdb8d245754156a7c30ffbbaa26314597d32f2825f606ebafc5163980.png)

		- 7.选择内存配置
![image](assets/c47eeb79e992f11ab5661a2bf196eb6f100c6235b38451f718f3cee9079fd5e5.png)

		- 8.选择网络类型，使用NAT，配置好之后，windows既可以和虚拟机进行相互通讯，但是教室内的其他同学不能连。
NAT网络地址转换：本机能上网，虚拟机能上网。
桥接：虚拟机融入到教室了，当做一台真实电脑，ip使用的是教室ip，同桌之间是可以互相访问的
![image](assets/6063bf6f3aeef29da1bafc2b2ef9b7f6d9180690f1aa0aee5869f6353e7988e6.png)

			- （1）NAT模式：虚拟机通过PC机的网卡去通信，虚拟机依赖PC机上网，可以理解成虚拟机被包含在PC机中，对外还是只有PC机一台电脑；
（2）桥接模式：逻辑上可以理解成虚拟出一台交换机，虚拟机和PC机处于同一地位，是两台独立地位的主机，两台电脑共用一个物理网口去上网；
(3)比较：NAT模式的设置比桥接简单；桥接模式设置复杂，并且有些情况不得不用，有些情况又不能用；一般没有特殊需求只是为了上网，选择NAT模式最简单；


				- [参考链接：虚拟机上网设置——桥接模式 & NAT模式](https://blog.csdn.net/weixin_42031299/article/details/121193097)

		- 9.默认类型
![image](assets/41b82063e9d030fcfb936150556781a8e0d6ce60705f1279c107082384cfb115.png)

		- 10磁盘类型，默认的
![image](assets/2cf7bbf4fa41d9a09289dcb46a4f0f9d99593d215d121eeed8a36a25d9dfb184.png)

		- 11.默认磁盘
![image](assets/f2c5ce1f10ac2ac93d23753e9a4613f796a5647d9a89b4c916d690a29fa9eb73.png)

		- 12.默认20G，多个文件
![image](assets/24d1bca3f9278abbbe4d60c1c3673b2704a78fd59a32c3261c6101d35c10202d.png)

		- 13.默认，到此创建好了虚拟机了
![image](assets/301b7833888b520f87f5118ec8896a85d41b40b433ff9bf1ccc3a342641e6eb1.png)

	- 2. 安装centos系统

		- 1. 指定iso位置

			-  
![image](assets/144a489c976298e185d43a017bfeab5b8b65ad409ebfe078da192436ece5a298.png)

		- 2. 开启虚拟机
释放鼠标ctrl+alt，
3.开始安装，选择安装install Centos 7,开始自动安装

			-  
![image](assets/e8134643b8f008b1eab13f163ab558c800efeb9183513312cd885bd287c95c4d.png)

		- 选择中文
![image](assets/b8d58708d73cab603db84f02b5563f9540ed0b5baa21fe4ab0a2bf1445e17354.png)

### 49.1.3. 三、Linux系统的文件

- 1、文件与文件夹（目录）

	- 什么是文件？

		- 通过工具可以打开的独立的东西，并且其中不能再包含除了文字以外的东西。

	- 什么是文件夹？

		- 可以在其中包含其他文件的东西

	- 什么先讲文件？

		- 1.日常运维工作中，有近一半以上的工作内容经理都是对文件的操作

		- 2.Linux本身也是一个基于文件形式标识的操作系统

		- Linux一切皆是文件

			- 1.在windows是文件的，在Linux下同样也是文件

			- 2.在windows不是文件的，在Linux下也是以文件的形式进行存储

		- 日常学习和工作中，对于文件的操作有哪些？

			- 创建文件、编辑文件、保存文件、关闭文件、重命名文件、删除文件、恢复文件。

- 2.文件夹目录结构

	- bin

		- binary

			- 存储的都是二进制文件，文件都是可以被运行的

	- dev

		- 该目录中主要存放的是外接设备，例如，盘，其他光盘等，在其中的外接设备是不能直接被使用的，需要挂载（类似于windows下的分配盘符）

	- etc

		- 该目录主要存储一些配置文件

	- home

		- 表示「家」
除了root以外的用户目录
类似于windows下的users用户目录

	- proc

		- process
进程

			- 该目录中存储的是Linux运行时的进程

	- root

		- 该目录是root用户自己的目录

	- sbin

		- super binary

			- 该目录也是存储一些可以被执行的二进制文件，但是必须得有super权限的用户才能执行。

	- tmp

		- temp临时的

			- 当系统运行时产生的临时文件会在这个目录存着，一般不用动，类似windows中的C://WINDOWS/Temp

	- usr

		- 存放的是用户自己安装的软件

			- 类似于windows下的 Program files

	- var

		- 存在的是程序/系统的日志文件的目录

	- mnt

		- mout

			- 当外接设备需要挂载的时候，就需要挂载到mnt目录下

			- 当访问U盘和移动硬盘的，都是访问的mnt下的某个目录

### 49.1.4. Linux的基本指令

- 一、指令与选项

	- 什么是Linux的指令？

		- 指在Linux终端（命令行）中输入的内容就称之为指令

	- 一个完整的指令的标准的格式

		- Linux通用的格式

			- # 指令主体 【选项】【操作对象】

			- 一个指令可以包含多个选项

			- 操作对象也可以是多个

	- 虚拟机操作切换命令和图形界面

		- ctrl+alt+f1

			- 恢复图形界面

		- ctrl+alt+f2或者f3

			- 去命令行

	- 1.ls指令

		- 含义：ls（list）

			- 用法1：
#ls

				- 含义：
列出当前工作目录下的所有文件/文件夹的名称

			- 用法2：
#ls 路径

				- 含义：列出指定路径下的所有文件/文件夹的名称

				- 关于路径（重要）：
路径可以分为两种：
相对路径、绝对路径。

					- 相对路径：
相对首先得有一个参照物（一般就是当前的工作路径）；
相对路径的写法：在相对路径中通常会用到2个符号"./"，"../"

					- 绝对路径：
绝对路径不需要参照物，直接从根『/』开始寻找对应路径

			- 用法3：
#ls 选项 路径

			- 用法4：
#ls -lh 路径

				- 含义：列出指定路径下的所有文件/文件夹的名称

				- h
以可读性较高的方式显示大小
文件夹大小为啥是4k
因为文件夹创建出来了之后，就是4k，哪怕是放了东西之后，还是4k

		- ls输出结果

			- 第一列：-或者d
文档的类型

			- 在Linux中隐藏文档一般都是以『.』开头

	- 2.pwd指令

		- 用法：#pwd

		- print working directory
打印当前工作目录

	- 3.cd命令

		- change directory，切换目录

		- 语法：
#cd 路径

		- Linux中特殊符号"~"，表示当前用户的家目录
切换方式：#cd ~

	- 4.mkdir命令

		- make directory，创建目录

		- 语法1：#mkdir 路径
路径，可以是文件夹名称也可以是包行名称的一个完整路径

			- 这里为什么是路径，而不是文件名？
因为如果是路径，可以创建到路径下的文件夹，
文件夹名就定死了

			- 已经有了，创建时，会报错，已经存在

			- 注意：ls列出结果的颜色说明，其中蓝色的名称表示文件夹，黑色的表示文件，绿色表示其权限为拥有所有权限（可读可写可执行）

		- 语法2：#mkdir -p 路径

			- Intermediate directories are created with permission bits of “rwxrwxrwx” (0777) as
 modified by the current umask, plus write and search permission for the owner.

			- 一次性创建多层目录

		- 语法3：#mkdir 路径1 路径2 路径3

			- 一次性创建多个路径

	- 5.touch指令

		- 指令：touch
作用：创建文件
语法1：#touch 文件路径

		- 语法2：#touch 文件路径1 文件路径2

	- 6.cp指令

		- copy，复制，
复制文件/文件夹到指定位置

		- 语法1：#cp 被复制的文档路径 文档被复制到路径

			- 没有特殊需求
文档被复制到的路径的文件名称最好不要变，实际上是可以变的。

		- 语法2：#cp -r 被复制的文件夹 文档被复制到的路径

			- -r【递归复制】
当使用cp命令进行文件夹复制操作时，需要添加选项-r，表示递归复制，否则目录将被忽略

	- 7.mv指令

		- move，移动，剪切，
作用：移动文档到新的位置

		- 语法1：#mv 需要移动的文档路径 需要保存的位置路径

		- 语法2：#mv 旧名称 新名称

	- 8.rm指令

		- remove，移除，删除
移出文档

			- 选项：
-f force(强制)
-r recursive(递归)

				- 不带选项，会提示是否删除，需要确定，输入y
不用确认带-f
删除文件夹-r

				- copy和rm 都有-r选项

		- 语法1：#rm 选项 需要移出的文档路径

		- 语法2：#rm 选项 路径1 路径2

		- 例子

			- 删除有公共特性的文档

				- rm -rf linux*

			- 其中*称之为通配符，意思表示任意字符，Linux*则表示文件以Linux开头，后续字符则不管。

	- 9.vim指令

		- 指令：vim （vim是一款文档编辑器，类似于notepad）

		- 语法：#vim 文件路径
作用：打开一个文件（可以不存在，也可以存在）

	- 10.输出重定向

		- 一般命令的输出都会显示在终端中，有时候需要将一些命令的执行结果保存到文件中进行后续的分析/统计，这时，就需要使用到输出重定向技术。

		- > 覆盖输出，会覆盖掉原先的文件内容
>>追加输出，不会覆盖原始文件内容，会在原始内容末尾继续添加

		- 语法：#正常执行的指令 >/>> 文件的路径
注意：文件可以不存在

		- 例子：

			- 使用覆盖重定向，保存ls -la执行结果，保存到当前目录下的ls.txt中去
ls -la > ls.txt

	- 11.cat指令

		- 作用1：cat有直接打开一个文件的功能
语法：#cat 文件路径 

自动读取退出之后输出

		- 作用2：cat还可以对文件进行合并
语法2：#cat 待合并的文件路径1 待合并的文件路径2  ...

			-  
![image](assets/50a068eed37505fb7b0f99f6af761532e554e2aa7bd3ed53b74860cea81b29a0.png)

		- 例子：多个文件合并，输出到一个文件中

			-  
![image](assets/29dc5c0f8bc056b45122f8db5eb5f93413a31ec90ab35d35f7fa2412474efc7c.png)

- 二、进阶指令

	- 1.df指令

		- display free disk space

		- 作用：查看磁盘空间

		- 语法：#df -h

			- -h "Human-readable" output.表示以可读性较高的形式展示大小

				- centos上输出
![image](assets/f26616eea50f2f3ce05bc56e314cc9ea8899eb62b059c105a9b713b95b69d0da.png)

	- 2.free指令

		- 作用：查看内存使用情况

		- 语法：#free -m 
-m表示以mb为单位查看

			- centos上输出
![image](assets/95377413141b6178994cf97d289d77be2d06955a510425dc3cc6b7826c438793.png)

			- 看第一行不准确，包含，内存被系统分配了，但是没有使用的，free是未被分配的，buffers和cached就是被系统分配了的，但是没有使用的，buffers，输出，cached输入。
应该看第二行，最后一列
Swap是表示交换的意思（系统有一个机制：当内存不够时，允许我们使用硬盘空间，充当临时的内存使用），交换空间

				- readyBoost当应急使用的
![image](assets/04cb4cbe80d0ca0109637eb4d5c8cb6e2c0718f372c0703d813211fb70ad9b69.png)

				- free -m 解读
![image](assets/311b57a322dc908090322a25fec3df38dfe54667345ed33f66adedb61c701026.png)

	- 3.head指令

		- 作用：查看一个文件的前n行，不指定n，则默认显示前十行

		- 语法1：#head -n 文件路径 ，n表示数组

	- 4.tail指令

		- 作用1：查看一个文件的末n行，不指定n，则默认显示末十行
语法1：#tail -n 文件路径

			- 最后一行
![image](assets/a294520c4dbeebfcf286034827cfb2caf0bfab019e82c5cc56c8c1ecd7b8f8cd.png)

		- 作用2：可以通过tail指令查看一个文件的动态变化
语法：#tail -f 文件路径
变化的内容不能是用户手动添加的，不能手动打开编辑保存的

			- 不停追加数据
![image](assets/d39914bd37e48a92fa1992e87b542417e61b26e31d9149ef4fefd10f82c0f81c.png)

			- 不停输出
![image](assets/1442a1c91d58fc52ee6434dbc18e42bdbf1e88c5c7bed017a36cf101f2a6b7ca.png)

			- 文档手册
![image](assets/ef2fb755a7c8ce64aa5610604314ccae1a1aee0c9a719efb24b4399d958f67d0.png)

			- 手册文档
![image](assets/b6fa81a8d0ccf2963952f628bbf0c416b56db7f3a1b166272900772332f253fb.png)

	- 5.less指令

		- 作用：查看文件，以较少的内容进行输出，按下辅助功能键（数字+回车，跳转到指定行，空格键，下翻页，b上翻页）查看更多

		- 语法：#less 需要查看的文件路径

	- 6.wc指令

		- word, line, character, and byte count
作用：统计文件内容信息（包括行数，单词数，字节数）

			- 测试
![image](assets/091cc71a7b22163965fee00050c28340687360078d172b0e4431cfa52470a801.png)

		- 语法格式：#wc -l

		- 语法格式：#wc -w

		- 语法格式：#wc -c

		- 语法格式：#wc 

	- 7.date指令

		- 作用：表示操作时间日期（读取，设置）

		- 语法1：#date

			- UCT
CST 当地时间
GMT

			- 输出形式
![image](assets/ff9fdc99760d9d48b610a64297b4af2c8543c17a606f3007b19a3cdb9adb9c1c.png)

		- 语法2：#date +%F
等价于#date '%Y-%m-%d'

			- 输出格式
![image](assets/f714f2c4a7bcc0a2ad6c1f9054194c79d62e995338b74ff63632a62a14cb2e3a.png)

			- 输出格式2
![image](assets/86ac764cb838893fc1a15146148fc0cdf3acd90a625297d2d74c3508e3763b75.png)

		- 语法3：#date '+%F %T'
等价于：#date "+%Y-%m-%d %H:%M-%S"

			- 输出
![image](assets/5c8181d8fbd0280490329b1f29e2425c9de5cd5ced04584c6d01bdc0cfbccdbc.png)

			- 引号表示让'年月日与时分秒'成为一个不可分割的整体

			-  
![image](assets/f0547723d9e92923dbe8f1672d6a72a39fa00d367e7272dc2ec5061603877c87.png)

		- 语法4：获取之前或者之后的某个时间（备份）
#date -d  "-1 day" "+%Y-%m-%d %H:%M-%S"

			- 输出一年前的
![image](assets/52a700ea19c55df45ea387710930bb3d9a33b52b5c63e14522f79f4072f40bc5.png)

			- 选项说明
![image](assets/1c4a7477929290100cfe563ae634b1f31a4ef8d93292bda8c59230be6d08c32d.png)

			- 8个格式
![image](assets/81fc3b23a482c15551412c8ed7a05ca8f1207cf0a40398850a395b74d6de29d0.png)

	- 8.cal指令

		- displays a calendar and the date of Easter

		- 作用：操作日历的

		- 语法1：#cal 
直接输出当前月份的日历
等价于#cal -1

		- 语法2：#cal -3
表示输出上一个月+本月+下个月的日历

		- 语法3：#cal -y 年份
表示输出某个年份的日历

		- 语法4：#cal -m
一个星期的第一年从周日改为周一

	- 9.clear/ctrl + L 指令

		- 作用：清楚终端中已经存在的命令和结果（信息）

		- 语法：clear
或者快捷键：ctrl + L

		- 需要注意的是，该命令并不是真的清除了之前的信息，而是把之前的信息隐藏到了最上面，可以通过滚动条继续查看以前的信息。

	- 10.管道（重要）

		- 管道符：|

		- 作用：管道一般可以用于『过滤『特殊』『扩展处理』。

		- 语法：管道不能单独使用，必须需要配合前面所讲的一些指令来一起使用，其作用主要是辅助作用。

		- 一、过滤案例：需要通过管道查询处根目录下包含"y"字符的文档名称
#ls / | grep y

![image](assets/2bdccaa4e8132e37df34d9b87b1f898794a58f631020fadc532dcb36f68e23ca.png)

			- 1. 以管道作为分界线，前面的命令有个输出，后面需要先输入，然后再过滤，最后再输出，通俗的讲，就是管道前面的输出就是后面命令的输入
2.grep指令：主要用于过滤

		- 二、特殊用法案例：通过管道的操作用法来实现less的等价效果（了解）

			- 之前通过管道可以：
#cat 路径 | less
#less 路径

		- 三、扩展处理：请使用命令来统计某个目录下的文档的总个数

			- #ls / | wc -l

- 三、高级指令

	- 1.hostname指令

		- 作用：操作服务器的主机名（读取、设置（临时））

			- centos
![image](assets/b31c160756327ec75f76dede24adb44013129940c9d02954591cd6baa88482c2.png)

			- windows
![image](assets/affe26855f6c7a3172dc866efb41015956fdebf9f2e77fdc3264a76e3322a440.png)

		- 语法1：#hostname

			- 含义：输出完整的主机名

		- 语法2：#hostname -f

			- 含义：表示输出当前主机名中的FQDN（权限定域名），fully qualified domain name

				- -f

![image](assets/c3aad385c8a031dfa387a36bc8abe67a5debd53c67359dacae3860db36af855b.png)

	- 2.id指令

		- identify

			- 手册
![image](assets/dfe19bbb3aab34972cf3d11ac1c9a110f153ba73956bb773ce22815ef7c60aff.png)

		- 作用：查看一个用户的一些基本信息（包含用户id，用户组id，附加组id。。。），该指令如果不指定用户，则默认当前用户。

		- 语法1：#id
默认显示当前执行该命令的用户的基本信息

			- 输出：
gid是组id，后面的组是附加组
![image](assets/06bfe2a0e9955c8156815ed408c1b05037ec69707ad834f40fce99baf7ee0863.png)

		- 语法2：id 用户名
显示指定用户的基本信息

			- 输出结果
![image](assets/68834ed9ecfc89ae58a243abba461bb879bb47d22c0ffec6336091dc9f927c17.png)

			- 验证上述信息是否正确？
验证用户信息，通过文件/etc/passwd
验证用户组信息，通过文件/etc/group

				- 输出
![image](assets/2885ba39c81c6fe22a5fc9df4a9ea3b43971b3efa26f2c616321f46e36d1ef76.png)

	- 3.whoami指令

		- 作用：『我是谁？』显示当前登录的用户名,一般用户shell脚本，用户获取当前操作的用户名

			- 输出
![image](assets/d8dab04f276f1e3b522ad49aa08aab1f467234061a496ef3488f1f51c7a5830c.png)

		- 语法：#whoami

			- 查看日志
![image](assets/3995582dfa10443e5bda571de4ba78c1625d3a6f5fd2a4fd508547cf300a5e97.png)

	- 4.ps -ef指令（重点）

		- 指令：ps process status
作用：参看服务器进程信息
选项：
  -e：等价于-A，列出全部进程
   -f：显示全部的列（显示全字段）

			- -e -A
![image](assets/a20ff09a5abac937df0665df3c927badcf0e8fa3eff26bb5a37658460792ebca.png)

			- -f
![image](assets/4019a0aa62a363b4ce7c6a8c88a5c09ae004ba1949cc74ded2031e64f20db6cf.png)

			- 执行结果：
列的含义：
UID：该进程执行的用户id
PID：进程id
PPID：该进程的父级进程id，如果一个程序的父级进程找不到，该程序的进程为僵尸进程。没啥用，还占用了资源。
C：cpu占用率，形式是百分数
STIME：start time 该进程的启动时间
TTY：终端设备，发起该进程的设备识别符号，如果显示？，则表示该进程并不是由终端设备发起。
TIME：进程的执行时间
CMD：进程的名称或者对应的路径
![image](assets/44839f5ca568aac13654ab4ab612d97c1d652b306c4517411ab2f103fe070658.png)

				- tty
![image](assets/0368b8894d0a5603239e3b9997260ced7940b90f769b2d5756ba6b4ecb30ded4.png)

			- windows的进程状态

				- windows
![image](assets/d0cbd183b6370ca5c7339bfc132ef6d6b4331b0be62aa555dea4fa4d49ce9d98.png)

			- 案例：在ps的结果中过滤出想要查看的进程状态

				- 进程过滤
![image](assets/5077c7dd08cd9f3a2c96d330f522b21698605fbe25303a398b561061d1820d12.png)

			- grep

				- -i忽略大小写
![image](assets/565a701b996810bf7cc598aaf9a257113313a269b44d894b56ba4f1365c536c9.png)

				- -o 仅显示符合正则表达式的内容，不显示整行
![image](assets/ee11592c207256bbf23c27c5e012207f30cffc3b9ee8ace4668262bdd5da1f7c.png)

					- -o
![image](assets/b2d8f5b29be0ec6009978ddc9e3508429efe27871aeb3fe6945acd10e8822240.png)

					- 显示匹配的位置
注意: 以上输出显示的不是行内的位置，而是整个文件中的字节byte位置
![image](assets/9e2a3f73e3724c5468cff1776aa1e469286c9e7a56fe226af31fd68640135fa2.png)

				- -v反向过滤
![image](assets/5ea0f5f3e95788e703436903a977cfbbd35418a5bbb2b342c63d7bec04d85687.png)

				- -E支持扩展正则表达式
![image](assets/8534bbfb05026c6f43589f7927ace5a02b0308178cc8b16e099bb357c846d7a0.png)

				- -e根据多条件过滤文件
![image](assets/e31f3b92c3d062bdfaf20685a64bba0f4eb3cb91b0ac5c19eb359fa79108a1e7.png)

				- -n 显示行号
![image](assets/6a37d9959a938c67e4e843249c4d6038afd05efe825776a76886b7c58773fec9.png)

					- -A n显示符合条件的后2行
![image](assets/78bf4ca6980e73660d759988db8cf79a388946be30e5b838b00ba7b2f62490cd.png)

					- -B n 显示符合条件的前2行
![image](assets/6bd72fc57d1a2eefd679a504da05cf257793bf73f6d017e6abf43a17ba5b3a0e.png)

				- -w搜索整个词，而不是词中的部分字串
![image](assets/d137e45be0d8583f9382132fdf5e650e08e5dc35d86bfd28ec93cdd37a89abc7.png)

				- -r用grep -r递归搜索全部的文件
![image](assets/75300c93c5948e70d982c377f149d45be2e0a632b8eb1bd0e7505b3f5b96add8.png)

				- -v -e
显示不匹配全部模式的行
![image](assets/414d8059eb0e48490316713c737848cb2aa20d4a37abe30b6109693814c0f4fc.png)

				- -c
-v -c
”-C”有Context之意（上下文之意）
![image](assets/0ad579535b0f7022cff1a7e33d3e975a7b4984645e246dee254b7ff862507404.png)

				-  
![image](assets/c932022276998d959d41ab2939c308cab55f7325bdd5fa5d4a72a521ac2e61e0.png)

					- 1）匹配单个字符的元字符


						- . 任意单个字符（前面是一个小点）
grep 'r..t' /etc/passwd
![image](assets/19a7cd6a0d2d0680b6be886f7a0a489c7816ff8ba15f823db6eb365f918e9e6c.png)

						-   [ ]   代表或者的关系

 连续的字符范围

[a-z]  : a到z的所有小写字母

[A-Z]   ： A到Z所有的大写字母

[a-zA-Z] ：包含所有的大小写字母 

[0-9]  ：0到9的所有数字

[a-zA-Z0-9 ]  ：包含所有大小字母和数字
![image](assets/ce9301d4c1e99f21c69e8d94f467b3eeb8d795a76b500b76baafd1325e950894.png)

						- ^ 取反

[^a-z]

grep "r[^0-9]t" 1.txt 
![image](assets/3685bf00b72e4271c59801e5fcc048c9bd370f7b97d0146d2d07af35b82dff44.png)

					- (2)匹配字符出现的位置

						-  
![image](assets/c155820ec016acf6e9935fb5b71512bcef6e45aa31731c9f87a92e864933e641.png)

						-  
![image](assets/49cf29920c61433d2f0fc86fc63335969cfa7b89d9ecbdf8c3487d4ecd09f5bd.png)

						- 子主题 3
![image](assets/81e7a3618ec5be8db5c1da780469f8e296f041a177340b728c1931ba6138a86a.png)

						- 子主题 4
![image](assets/bc26db35eb85b6bc98b5aa034d038207ccfc6bdcb5bf8386e6997e9ec9ba245b.png)

						- 子主题 5
![image](assets/460304a3e8b5867a87833acd1723c786a4fc78ec2b11834d87ef4154c41395c7.png)

						- ^$ ： 代表 空行

						- 子主题 7
![image](assets/4d11ed19e7fd9bfdde414d6f1d1f4ad3205a949ac3a4cccd3c9f69000cbce122.png)

						- 子主题 8
![image](assets/4d7ce1db509eabde20fbdfd25646a15067fe96e2bd69a0c1380d8840832f0da0.png)

						- 子主题 9
![image](assets/709ba8676ea2c88c6a4329b4b143928dfc3804aed03fec98e2fa7bf5ffb5deb8.png)

						- 子主题 10
![image](assets/ba762646ab90f004e3e195f2b10c99b50053247bd8ac9d1e1dd19dcae943d79f.png)

						- 子主题 11
![image](assets/fe132b60fec602c2884859e809a0df73b4c4dca36b25d2125f9d981635098093.png)

				- ps -ef | grep java | grep job | grep -v grep | awk '{print $2}' | xargs kill -9
当我们要杀掉某个应用服务进程时，一般会执行以下命令：

					- [查看链接](https://blog.csdn.net/u012069313/article/details/124663148)

				- 例子：
搜索
grep -rn 'bootstrap' ./ --exclude-dir={.git,node_modules,resources,built} --exclude={'*bundle*','*.min*',angular.js}

	- 5.top指令（重点）

		- 作用：查看服务器进程占的资源

		- 语法：进入命令：#top
动态显示
退出命令：按下q键
在运行top时，可以按下方便快捷键
M：表示结果按照内存（MEM）从高到低降序排列
P：表示将结果按照CPU使用率从高到低降序排列
1：当服务器拥有多个cpu时，可以使用「1」快捷键来切换是否展示显示cpu的详细信息，跟windows中的cpu使用逻辑处理器展示

			- 输出结果
![image](assets/5221611bc55a528e33b1a158094531c386f36e20e7f78ec981f5d68cfb73c966.png)

			- 表头含义：
PID：进程id
USER:该进程对应的用户
PR：权重，优先级
NI：用户进程空间内改变过优先级的进程的百分比
VIRT：虚拟内存   *
RES：常驻内存    *
SHR：share共享内存 *
       计算一个进程实际使用的内存 = 常驻内存（RES）- 共享内存（SHR）
S：表示进程的状态（sleeping）
%CPU：表示CPU占用的百分比
%MEM：表示内存的占用百分比
TIME+：执行的时间
COMMAND：cmd进程的名称或者路径 *
![image](assets/36d7c74d0221a1d4106f4076018373d788db352107f47e4970e34ce63df9328a.png)

				- 依赖其他进程
![image](assets/88ac70e631a7a79684350089a9f8b325ab74ba8250f160d17478f867a92b2797.png)

				- 扣除共享内存
![image](assets/b8d9b4a87fc85e39472a7edd5a2f77646a0c7abbf1f11f69d979509d5f8d4a4e.png)

			- plants vs zombies

	- 6.du -sh指令

		- display disk usage statistics
作用：参看目录的真实大小
选项含义：
 -s：summaries，只显示汇总大小
 -h：表示以较高可读性的形式进行显示

		- 统计某个目录
![image](assets/cfd09377fc1b7f513187941affe5cd3a5014c0e66afe4ac4e3cc59ad338a3b0a.png)

		- 输出
![image](assets/685d116381ed21afd84a11a0a7da513d959bad376fdfb5d7f185ebd9e9c009a9.png)

		- du -h 和 du -sh 区别
![image](assets/e9cee499dc84dd8f0ec10ae0cfd8026fb356bc8a493fe02645740b03c6423add.png)

	- 7.find指令

		- 作用：用于查找文件
其参数有55个之多
语法:#find 路径范围 选项 选项的值
选项：
  -name：按照文档名称进行搜索（支持模糊搜索）
  -type：按照文档的类型进行搜索，
       文档类型："-"表示文件（find中使用f来代替），"d"表示文件夹

		- 案例1:使用find来搜索httpd.conf
![image](assets/4a07cf35726772e36919f6a535d3d34a6067c7afb05aaa0a4346c71747ffb0a7.png)

		- 案例2：使用find搜索/etc下的*.conf
![image](assets/b3c06e3f0252b0a9f5f6524cb3672472e33a5427f53a276828ea6192c655c9b5.png)

		- 3.使用find来搜搜/etc/sane.d/目录下的所有文件
![image](assets/fc09ed10d7b995623c496d30d60f180fedd5f0b67bab37ca93b395bbf50fadfc.png)

		- 4.使用find来搜索/etc/目录下所有文件夹
![image](assets/c8e8e6375af81310f07de4a8c2c192dd1b8e1673403a7ac18b7fa819e6f868f1.png)

	- 8.service指令（重点）

		- 作用：用于控制一些软件的服务启动/停止/重启

		- 语法：#service 服务名 start/stop/restart

		- 启动本机安装的Apache服务（网站服务器软件），其服务名为httpd
#service httpd start

		- 启动httpd服务
好像是root用户可以启动，
但是zagger用户启动不了，失败了
![image](assets/ff25def434c683e3ae9b5160c5f1a222013036304093dc396b1487c5b87f53be.png)

		- zagger用户启动不了，据说是没有权限
![image](assets/5e1c24daa838832a012fc6707bd81624539fee7fddd074f866d5297778ab1aa7.png)

		- 查看进程：ps -ef | grep httpd
第一个是父进程，其他都是子进程，先开几个子进程，给用户使用，如果不够用，再继续分配
![image](assets/1ba5f76af2696a63491093db2c581dbae9450dae91ad9ea5dcced2eb95933458.png)

	- 9.kill指令（重点）

		- 文档
![image](assets/497c12ffd6a68f28248c8421043e50bdf6d0339ff5b6e36e508eaa925bd8824d.png)

		- 文档2
![image](assets/ea092ab30558558b8a714de5d8d6c587d6c67a17705ca2066a6cb5ec8b249508.png)

	- 10.ifconfig指令（重点）

		- 获取网卡信息
![image](assets/a1ef8ce40357f29db005abd346255a8ce779f298feaadef75272a9485059593d.png)

		- 解释
![image](assets/73aa4a326cf2d34dd3f8884d81baeca3cdac0d7da17a0c9d1258f6f5d3199ab2.png)

	- 11.reboot指令

		- 作用：重新启动计算机

		- 语法1：#reboot
重启

		- 语法2：#reboot -w
模拟重启，但是不重启，(只写关机与开机的日志信息)

	- 12.shutdown指令

		- 作用：关机 （慎用）

		- 语法1：#shutdown -h now ["关机提示"]
或者#shutdown -h 15:25

		- 案例：设置Linux系统关机时间在12:00

			- 例子:shutdown -h 12:00 "提示消息"
![image](assets/99408f87ffd9d96b77be94ff44f045e005c1c7ce2b0c328e24f85ab9fe4eedf5.png)

			- centos7 可以使用shutdown -c 中断关机计划
![image](assets/3e114aaa0c753f368d4d8f422cc422c6f8d2f5da29cee81cec5485e3ee9d4a49.png)

				- 取消关机
![image](assets/103908b12536a81e7c2c1064839bcd8c6f00c8f740ed454740628715dd2b9f37.png)

		- 其他关机方式
![image](assets/58028278b5ec91ff11ec2ecd66792209a3a53ed0b2619d60967f2f79d7d4ecbe.png)

	- 13.uptime指令

		- 作用：输出计算机的持续在线时间（计算机从开机以来到现在运行的时间）

		- 语法：#uptime

			- 输出
load average最近一分钟负载，最近五分钟负 载，最近15分钟负载，跟top命令中的第一行很接近
![image](assets/6c60f0b6f292369e4076a8e2445edd63ef6fc853037d629985af01cd15597710.png)

		- windows上是systemInfo

			- systeminfo中的系统启动时间
![image](assets/12cda2be74466de79f36e8e2ec6572b3a11bbf7e10f9356fd5af6a78ccee59ed.png)

	- 14.uname指令

		- 作用：获取计算机操作系统相关信息

		- 语法1：#uname 获取操作系统的类型

		- 语法2：#uname -a
all表示获取全部的系统信息

			- 系统类型
全部主机名
内核版本，
发布时间
开源计划
![image](assets/fe63506ec330fabd4f1ac32088ba3f00f270e31ad8060e3c23eb079ec528d6ee.png)

	- 15.netstat -tnlp指令

		- 作用：查看网络链接状态

		- 语法：netstat -tnlp

			- 输出
选项说明：
 -t ：表示只列出tcp协议的连接,--tcp
 -n：表示将地址从字母组合转换为ip地址，将协议转化为端口号来显示,--numeric
 -l：表示过滤"state（状态）"列中其值为LISTEN（监听）的连接；
-p：显示发起连接的进程pid和进程名称
![image](assets/40604648d986252fed9e4b09108f6633096f33fdad2e187cf3183eb8f93e2983.png)

				- 文档：
-p
-l
![image](assets/c1d700bd7463acb1ad2f3c1bf11648d49cb92ab78f98686d71ac269595df14f2.png)

				- -n
![image](assets/3f8a34e8e7a9581529f33f4ed4567977d6b8fd307af18bc63b84af40626f5a45.png)

			- mac上使用netstat
![image](assets/33a8622cb5fd04f0c7f289b00f0d2af9a8137f40e5f2163068cb6933da077701.png)

	- 16.man指令

		- 作用：manual，手册（包含了Linux中全部命令手册，英文）

		- 语法：#man 命令 
按q退出

	- 命令行光标之前和之后的字符

		- 前：ctrl+u
后：ctrl+k

	- xargs

		- 文档
![image](assets/a15fbb72de9d3ecad689ef0acddcf55d431643995c9a93f71e8a776545dea8c6.png)

	- 删除/tmp下所有文件

		- rm -rf /tmp 删除了tmp和下面的文件
rm -rf /tmp/* 删除tmp下所有文件
![image](assets/2826e683223dc4c2bc22a21e939d7f508ead713a4c55c108eefaf2f0ed2f8d72.png)

	- 启动apache之后，干掉进程

		- service httpd start 
ps -ef | grep httpd | grep -v 'grep' | awk '{print $2}' | xargs kill
ps -ef | grep httpd | grep -v 'grep'

- 编辑器之神-vim编辑器

	- 1.vi介绍

		- vi编辑器是所有Unix及Linux系统下标准的编辑器，类似于windows下的notepad记事本，由于Unix及Linux系统的任何版本，vi编辑器是完全相同的，因此可以在其他任何介绍vi的地方都能进一步了解它

	- 2.vim三种模式（重点）

		- vim是vi的升级版

		- Vim中存在三种模式（大众认知）：
命令模式、编辑模式、末行模式（尾行模式）

			- 命令模式：
该模式下是不能对文件直接编辑，可以输入快捷键进行一些操作（删除行，复制行，移动光标，粘贴等），打开文件后，默认进入的模式

			- 编辑模式：
该模式下可以对文件的内容进行编辑

			- 末行模式：
可以在末行输入命令来对文件进行操作（搜索、替换、保存、退出、撤销、高亮等等）

		- vim打开文件的方式

			- #vim 文件路径
作用：打开指定文件

			- #vim +数字 文件的路径
打开指定的文件，并且将光标移动到指定行

			- #vim +/关键字 文件路径
打开指定的文件，并且高亮显示关键词

			- #vim 文件路径1 文件路径2 文件路径3
同时打开多个文件

			- 例子
![image](assets/5414f0c815138f02a070b7a9289273434cc53efe2c6d0424ae052b3f7478d3fd.png)

		- 命令模式

			- 注意：该模式是打开文件的第一个看到的模式（打开文件即可进入）

			- 1.光标移动

				- a.光标移动到行首 ^

				- b.光标移动到行位$

				- c.光标移动到首行gg

				- d.光标移动到末行G

				- e.向上翻屏ctrl+b（before）或pageUp

				- f.上下翻屏ctrl+f（forward）或pgDn

			- 2.复制操作

				- a.复制光标所在行yy

					- 粘贴：在想要粘贴的地方按下p键

				- b.向下复制指定的行数：nyy

					- 复制时，包行当前所在行

					- 粘贴时，是在哪个位置粘贴的呢？
看起来是在当前行下一行，开始粘贴的
复制行粘贴是这个行为
复制区块粘贴，是当前光标下一下

				- c.可视化复制ctrl+v，方向键

						- ctrl+v，然后按下上下左右方向键来控制复制的区块，按下yy键是复制整行，按y复制区块。

			- 3.剪切/删除

				- a.剪切/删除光标所在行dd

					- 删除之后，下一行上移

					- 严格意义就是剪切，剪切之后不粘贴就是删除的效果

				- b.剪切/删除多行ndd

## 49.2. macos

### 49.2.1. Command+Shift+.  显示隐藏文件快捷方式

### 49.2.2. iterm2

- 快捷方式

	- cmd+d: 垂直分屏

	- cmd+shfit+d：水平分屏

	- cmd+alt+arraw：切换屏幕

	- cmd+; ：查看历史命令

	- cmd+shift+h：查看剪切板历史

	- cmd+enter：全屏切换

	- cmd+w：关闭标签

	- cmd+t：新建标签

	- ctrl+u：清除当前行

	- ctrl+l：清屏

	- ctrl+a：到行首

	- ctrl+e：到行尾

	- ctrl+f/b：前进后退

	- ctrl+p：上一条命令

	- ctrl+r：搜索命令历史

### 49.2.3. vscode

- 快捷方式

	- cmd+k v：打开markdown预览

### 49.2.4. neovim

- pip install neovim
pip3 install neovim

### 49.2.5. mac 软件

- mindnote思维导图

- pages写文章

- Photoshop修图

- final cut pro 剪视频

- pr 视频剪辑

- downie4收集素材

### 49.2.6. 工具

- awk进行git提交分析

  1.文件：5.2.0.awk
  
  BEGIN     {  }
  {ismsg = 1 }
  /^commit/ { ismsg = 0; flushCommit(); hash = $2 }
  /^Author:/ { ismsg = 0; author = $2 }
  /^Date:/ { ismsg = 0; date = substr($0, 6) }
  /^[ACDMRTUXB]/ {
      if(ismsg == 1) {
          if(index($2, "built/") != 1 && index($2, "resources/") != 1 && index($2, ".data/") != 1 && index($2, "zips/") != 1) {
              files = length(files) == 0 ? $2 : files "; " $2;
              fileCount++;
          }
          ismsg = 0;
      }
      else {
          ismsg = 0;
      }
  }
  { if(ismsg == 1) messages = messages $0 }
  END  { flushCommit(); printStats();  }
  
  
  function flushCommit() {
      stats[fileCount] += 1
      print hash, "|", author, "|" fileCount, "|" files, "|", messages
      author = ""
      date = ""
      fileCount = 0
      hash = ""
      files = ""
      messages = ""
  }
  
  function printStats() {
      for(key in stats) {
          print key, ":", stats[key]
      }
  }
  
  2. git中切换到5.2.0-uos分支
  命令行：git log 5.2.0-vpc HEAD --name-status
  git log 5.2.0-vpc.. --name-status > diff.log
  
  3.命令行：gawk -f ~/Downloads/5.2.0\(1\).awk diff.log > diff.gawk.log
  
  4. mac上awk输出不一致，使用gawk，brew install gawk
  linux 上直接使用awk
  
  输出文件https://www.kdocs.cn/p/110942009149?from=docs&source=docsWeb
  
  
  输出的源代码：
  
  
   |  | | | 
  3d966e95de78342f65f9b7249da8ab42a738368c | wangchuan |0 | |     build
  96362aa70ebcf6d66938bc7341f7f6374fc6ebc4 | wangchuan |1 |personal_login/js/webLogin.js |     合并vpc代码，密码登录：全局enter提交
  c59a604beca3eabb9d5303188096b9b18ecf28e3 | wangchuan |0 | |     国产化包：个人桌面，全局enter登录
  d7c01aaa0cc355277566c094f46598f73fe7ca95 | zhangyao |0 | |     build
  94102845952871882b853feea8257c9e6cb04d1a | 魏聪 |2 |views/idv/dialog/desktop/modify_scene.html; views/voi/dialog/desktop/edit_sence.html |     解决编辑场景时挂载的数据盘可以为空的问题
  2aa0ce39c527b155eb02036e713c6f9d65292f6d | tianyiwen |1 |views/vdi/help/deploy.html |     快速部署自定义模板样式调整
  fdf489d636e38658240c6fc1e0394a01db46c722 | tianyiwen |2 |views/idv/template/teach.html; views/voi/template/teach.html |     去掉公共模板voi，vdi的绝对定位
  e63130b6765d2e2fd06d703bfa39a9f7173a6d15 | tianyiwen |1 |780093d9c |     Merge branch '5.2.0-uos' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.2.0-uos
  780093d9cf707a5e93ccd2d551f302ad270d2b5a | tianyiwen |3 |views/vdi/plan/host_switch.html; views/vdi/plan/snapshot.html; views/vdi/plan/switch.html |     修改计划任务模块的表单描述溢出隐藏
  4fd35c0ad0e21741e01b66ddd985b52df6dc470a | wangchuan |0 | |     build
  bbc97bac2512a739544d0b40ea4a74343ee0d46e | wangchuan |0 | |     国产化包
  25a63197e8fa0a8a546524b5899df5b50d93701b | tianyiwen |1 |views/vdi/template/teach.html |     去掉公共模板瓦片checkbox绝对定位
  eb05b5b5a921fbafe973bb6c187aa9111d244854 | wangchuan |0 | |     国产化包
  e8b1ec058bc9b172b283793824830aa723e66f50 | tianyiwen |1 |views/vdi/desktop/teach.html |     去掉teach中的用户名
  1e16d13f4f74dfd9244a53a0cefadf95695ac3c1 | tianyiwen |1 |9ae0a6930 |     Merge branch '5.2.0-uos' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.2.0-uos
  9ae0a6930cfcd4ff5924d6d71c0dbf6445632af5 | tianyiwen |4 |views/vdi/desktop/teach.html; views/vdi/dialog/desktop/personal_alter.html; views/vdi/dialog/system/system_deploy_advance_options.html; views/voi/dialog/desktop/edit_roam_desktop.html |     根据需求5869和bug18122屏蔽掉部分计算机名
  50f02fa58df37e637e5343ffaf77634a2412a654 | wangchuan |0 | |     国产化包
  c75621736edf3907a170b151128e2b48f9d67f03 | tianyiwen |1 |js/vdi/desktop/scene.js |     修改新增公共桌面时无论什么情况，usb_version都为3.0
  48c39ba299d74d6cd3ac6bf9ae20296beaaaf26c | tianyiwen |1 |views/vdi/desktop/teach.html |     去掉公共桌面中场景列表的计算机名
  8c1c7f966fc745e6b8fc3aa8ae0c61f5e2626425 | wangchuan |0 | |     国产化VDI包
  fa8706435f68c72139798d15abd989a799d98e06 | zagger |0 | |     build
  b04aa257b339d9322456302d75725266252c48f6 | zagger |1 |js/voi/system/controller.system.js |     VOI默认设置项-默认值设置
  6c12fc2394b791902d9a1eba5456ae43068f3d85 | tianyiwen |4 |js/vdi/desktop/personal-desktop-pool.js; js/vdi/desktop/personal.js; js/vdi/desktop/scene.js; js/voi/desktop/controller.roam.js |     新增个人桌面、公共桌面、个人桌面池、漫游桌面USB默认改成3.0
  214565e1df16e1a68a82c86208d90a29c54888f8 | zagger |0 | |     '    build
  072a3ffdddc80dd4a8d348c462577c9c05a1c822 | zagger |2 |js/voi/system/controller.system.js; views/voi/system/set-voi.html |     bug# 15311 国产化服务器（ARM）【管理台/网络/DHCP】增加选择底层包的功能 - 前端
  2a760dc24d008264b35238022036318e762065fd | zagger |0 | |     build for uos
  b6c22377224a6200a4cad48e9f136ba440bd7b65 | zagger |1 |js/vdi/user/admin-user.js |     改变分页信息,调用接口两次问题
  0ef59e39dc68269ba2c60d986ae4534a6d917f27 | wangchuan |0 | |     国产化包：设置客户端桌面问题
  24805c5d89ee40b62ba0e336d7f3db38b4d3f6b9 | wangchuan |0 | |     build
  e174f44c2b3ca6fcc13a8a90d0d0cdbddf35b6f9 | wangchuan |0 | |     国产化VDI包
  2f39b0a4be43bb23d24bd365cee117662a6afad2 | wangchuan |1 |e016164d1 |     Merge branch '5.1.4-vpc' into 5.2.0-uos
  e016164d16dcef1d5d4db69d035eb04969d19ab0 | zagger |0 | |     build for uos
  d2b74f080f7137150164d885f88136e28a8e136b | zagger |1 |spice.html |     bug#【国产化-web端】-web端登录个人桌面后，界面存在“移出安装介质”功能按钮，应该只在模板编辑界面存在此功能 17911
  1074fe6483e63410e42b6c9dce9884b7d6e860a4 | zagger |1 |views/vdi/dialog/desktop/scene_new2.html |     bug# 17906 【国产化-公共桌面】-新增公共桌面时仍然可以配置修改计算机名，与需求不符
  5e4852cb751d6e2826450df56d1c86d7cd3803bc | wangchuan |0 | |     build
  92b18f6a396615502d29831046169b9257ab4429 | wangchuan |0 | |     国产化VDI包
  2f3235afd14ee2e8d33072cb33d911758290bdf9 | tianyiwen |1 |img/logo/vpc-fusion_zh-hans.png |     管理台的logo换了一张旁边空白部分少的
  2f201043a9af76dd614441daa142aff608d7132c | zagger |2 |js/vdi/security/shared.js; views/vdi/dialog/security/manage_desktops_for_strategy.html |     bug# 17835 【国产化-桌面安全】-国产化操作系统启用屏幕水印后，详情信息中显示屏幕水印策略不生效，实际是生效的
  bc41c09ba5e5913499e171ffe96fbe28ff365f1c | zagger |0 | |     build for uos
  1097ba542f21097eceebb117d6a08605595f3183 | wangchuan |0 | |     build
  0d0832cb2e0a358cd16089b4983f24af9324f5e2 | wangchuan |0 | |     国产化VDI包
  a6a68efaf65b81e43a854af0899981b0f4e16254 | 魏聪 |1 |views/voi/dialog/terminal/terminal_config.html |     voi终端屏蔽静默更新
  6c8b1b183a48f0b1547c51cf6787a5e0ec557bdb | 魏聪 |3 |js/vdi/utils/ui.js; views/idv/dialog/terminal/terminal_move_groups.html; views/voi/dialog/terminal/terminal_move_groups.html |     修改voi与idv终端移动下拉框无法收起问题,修改uiTreePicker支持自动收起
  b359a971366e68a392e815126c01e936a1687c70 | 魏聪 |1 |views/idv/dialog/terminal/terminal_move_groups.html |     解决idv终端移动下拉框不自动收起问题
  0aa54db309a4ba5a536ee65b315806f9adb24065 | 魏聪 |3 |js/vdi/utils/ui.js; package-lock.json; views/voi/dialog/terminal/terminal_move_groups.html |     voi终端移动树结构没收起，修改uiTreePicker支持自动收起
  df76adc48711ccbd27cc096840e8c0f03baae727 | tianyiwen |1 |views/vdi/dialog/security/watermark_preview.html |     修改水印预览
  4da08db495443a59a0759a8f73da7f95f355daa9 | tianyiwen |2 |init.html; views/vdi/dialog/resource/pool/new_host.html |     去掉硬件虚拟化检测提示
  1927fa759018a1c40a8ff0abea4c85d1d0f9869d | zagger |1 |views/vdi/dialog/desktop/newDeskPool.html |     国产化-17755 【国产化-个人桌面池】新增个人桌面池时，USB3.0重定向选项不可选
  7c6b04fa317a4e10499a9ea4c0cc4675bcc5899b | zagger |3 |img/clientLogo/vpc-fusion_zh-hans.png; img/client_voi_logo/vpc-fusion_zh-hans.bmp; img/logo/vpc-fusion_zh-hans.png |     姣姐三种logo图替换,vdilogo,vdi端logo,voi端logo
  5b0e100e9c7f38626ef79f7cb74b3625ec4713f3 | zagger |0 | |     build for uos
  25d29fcc1f53e124d90e420163310af8a407f722 | zagger |1 |css/your_style.css |     系统桌面瓦片样式修改
  5742c25e643ba500bae357ef776a2f38d09dff24 | zagger |2 |js/vdi/spice.js; spice.html |     移除安装介质
  da3ba4cb03a5625c6f4376d44de247111d46cc22 | zagger |1 |package.json |     xterm low edition
  ae12cedb755f2b19c75593b428798987902e0281 | zagger |1 |package.json |     xterm low edition
  8fbb2ff6768970035ce8c7c53d76305c72d14d4c | wangchuan |0 | |     国产化包
  b397f48501c1ad125f4d85c47725023dc114c771 | zhangyao |0 | |     build
  07dca05cf8bab0414b6ee0c7c68e2914c4f50f63 | zhangyao |1 |b1e7ada50 |     Merge branch '5.1.4-vpc' into 5.2.0-uos
  b1e7ada50417331071ff9a3f97a203d137e5717a | zagger |0 | |     build for uos
  b84e9f2f07aed8f52066b8664c10bf16b4ef19cf | zagger |1 |views/vdi/dialog/desktop/scene_new2.html |     袁阳需求编号:5869 新增公共桌面设置用户名功能屏蔽需求说明
  e4ab919b63305787fdef48180c5e0d5fd19e2b53 | wangchuan |1 |views/vdi/terminal/client.html |     国产化：去掉动态密码功能
  31f88f09995e2401e8929c3fa1e8723328d2e0c3 | tianyiwen |1 |init.html |     虚拟化检测已通过
  b5842463b4338ffb40364e02eddd211d1b325d5d | wangchuan |0 | |     国产化VDI客户端包
  e10828fa3737440b17206ffcc03f3d4c213a8231 | zagger |0 | |     build for uos
  e35444329f0faaccc12e10d05d05592a4b7677b5 | zagger |1 |js/vdi/vdi.js |     阻止鼠标右键的默认事件
  b8b109bcf90681c8957ef88c994f91141b119110 | zagger |1 |package-lock.json |     build for uos
  c09abe241be1b0be79de151294ebd47cd7b8e252 | zagger |1 |js/vdi/os-types.js |     国产化os-type添加_64
  6d61cf8041e220bff5089a0fe21fa9b0baf11a32 | 魏聪 |1 |js/voi/desktop/controller.scene.js |     解决voi场景下桌面轮训判断hash错误
  e059c82e7178f93881b130ac6c565462f6695103 | wangchuan |0 | |     build
  b62c464f38cc825af5b8c643e2e9133b9b118d4c | wangchuan |1 |64b359ecd |     合并5.1.4-vpc代码
  ad0bdb62a41146df3b87bd9ed9254a8e93e9d8ad | 魏聪 |1 |js/idv/terminal/controller.terminal.js |     idv终端移动区时放开isLoading
  64b359ecd761d09fc3e2fb7f486e3b5f778fa6b5 | 魏聪 |7 |css/your_style.css; js/idv/terminal/controller.terminal.js; js/voi/terminal/controller.terminal.js; views/idv/dialog/desktop/add_scene.html; views/idv/dialog/terminal/terminal_move_groups.html; views/voi/dialog/desktop/add_scene.html; views/voi/dialog/terminal/terminal_move_groups.html |     解决voi,idv创建场景区域选择，voi,idv终端移动到区域下拉树的一些问题
  761e6bfb338e5b5f68a5d7fc1c0ba965ae37b455 | 魏聪 |9 |css/your_style.css; js/idv/terminal/controller.terminal.js; js/voi/terminal/controller.terminal.js; package-lock.json; package.json; views/idv/dialog/desktop/add_scene.html; views/idv/dialog/terminal/terminal_move_groups.html; views/voi/dialog/desktop/add_scene.html; views/voi/dialog/terminal/terminal_move_groups.html |     解决voi,idv创建场景时下拉树可以输入的问题，解决voi,idv终端移动区域时，允许取消选择的问题，同时也统一了 创建场景和移动教室2个组件
  0fc77edc6fb6ae3f0c24bfd3ec163cf0fffa2d0b | zagger |0 | |     build for vpc
  a9e881a591ce909ecf1347f85c72719855cb63d1 | zagger |1 |js/vdi/user/admin-user.js |     loading 问题
  fe03639d669c2165e380bc5ec2a6479d65dae0a6 | zagger |1 |js/vdi/user/admin-user.js |     destroy=>
  3a699e8437f5cc8fd2e3910e4db803c941b001c1 | zagger |3 |js/vdi/user/admin-user.js; js/vdi/vdi.js; views/vdi/common/account-config-info.html |     1. bug for header部分按钮的帐号设置,确定接口成功之后,当时处于/user/admin路径时,获取一次管理帐号列表接口.    2. !!!未完成,管理帐号这里,需要重新更改接口,不需要传递所有数据.
  ebc657ea8f7393656076200c661da6ba3c07736b | wangchuan |2 |js/vdi/terminal/controller.terminal.js; views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     产品要求：设置终端去掉一个配置
  2a05118b4bcbbd849da4b694da687f473b0d3517 | wangchuan |0 | |     国产化VDI客户端包
  2fb2b6fe49af5a9dbba222a45a694f8438edaa15 | wangchuan |0 | |     VDI客户端包
  baee29d61eb1f25dae23768971b36c0edc66b709 | zagger |1 |js/vdi/user/admin-user.js |     destroy=>
  cc53d4766e067a89cdf067e575a32feb246c14ec | zagger |3 |js/vdi/user/admin-user.js; js/vdi/vdi.js; views/vdi/common/account-config-info.html |     1. bug for header部分按钮的帐号设置,确定接口成功之后,当时处于/user/admin路径时,获取一次管理帐号列表接口.    2. !!!未完成,管理帐号这里,需要重新更改接口,不需要传递所有数据.
  dbdfdf135889dd87a0e0436135cd848185745708 | zagger |0 | |     build for vpc 5.28 backend login
  adf5a1f3994d7d344fd554aa3e4b5f2921ca13e4 | zagger |0 | |     build for uos
  4185fc9edbc7666362746f369105d275e5603cea | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式存储：监控图表bug
  8de76bef2bf08faebdce2ef42b76819a3b3e99bd | 魏聪 |1 |views/voi/dialog/desktop/desktop_detail.html |     说是voi的个人桌面要取列表里的域信息，已改
  042aa33cdf2faac05a0e7790f1d787a8f41809c1 | zhangyao |1 |ngconsole-webpack-plugin.js |     修复 middleware 顺序
  791828f673ef1f7711e64001995b4ba201026e1e | zhangyao |1 |9a8df7d76 |     Merge branch '5.1.4-vpc' into 5.2.0-uos
  9a8df7d7680853d97baca38170715742463c400d | wangchuan |0 | |     国产化VDI客户端包
  12bb6a4f8ed57f3f82f5cebd41c156d23e44b8c7 | wangchuan |0 | |     国产化VDI客户端包
  2d0870d763e8c95c3b6abab5938363e6a6d508a5 | zagger |0 | |     build for 投影仪
  2d51417e393b41a00ba58a42bdd69690716aa438 | zagger |1 |css/your_style.css |     vpc投影仪样式修改-bug2
  442cdd0f764e059d263761cb6b51aae12141cddb | zagger |1 |css/your_style.css |     vpc投影仪样式修改-bug
  83934259411e5a4f71ab4bc4e23c4f5d6fdb3f55 | zagger |2 |css/your_style.css; img/new_login_icon/header_bg.png |     vpc投影仪样式修改
  6ee2af62a1ec8cf6d5a0fca1aa3883c423462857 | wangchuan |3 |css/smartadmin-production.min.css; js/vdi/summary/controllers.js; js/vdi/summary/summary.css |     投影仪版概要
  ac6576cc772cca682968e9468b1193a275dd296e | 魏聪 |0 | |     voi桌面水印提示信息去掉 windows 字样
  bc2bfa5e5a21098e39c3996663b13e4ae9e4c84d | 魏聪 |1 |views/idv/dialog/template/register_tpl.html |     修改idv注册模板下拉范围影响确定问题
  f497ad5a3598325b634f759d1add761bbc6cd535 | 魏聪 |1 |ce2abb187 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ce2abb187f7c85f10d121835979d7c91ab33689f | 魏聪 |1 |views/idv/dialog/template/register_tpl.html |     'idv模板注册模板下拉范围选择无法确定bug'
  3c10981af494d242295fa5f087a1d3e5b51f1b30 | wangchuan |0 | |     build
  6158b3d376e3b05c18211a76d09db282ea14a3b7 | wangchuan |0 | |     VDI客户端包
  50b1da3135e36308ef22e0a149c9b064612f4ccc | tianyiwen |1 |5977ed6ff |     Merge branch '5.2.0-uos' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.2.0-uos
  5977ed6ff232111f0e2c172daae6429718613d08 | tianyiwen |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     修改设置运行参数table下边距
  04ff45e361a15446e63fbe9d19a710e6d244ff75 | 魏聪 |1 |package-lock.json |     voi自测打包
  b1902a8bf46670b31fb1ebbef44587f316395c20 | 魏聪 |3 |js/idv/terminal/controller.classes.js; js/voi/hardware/controller.printer.js; js/voi/terminal/controller.schoolroom.js |     修改voiidv区域下有默认区域时的提示
  c0c6f7721798df631850a40808d18f29c9da5618 | 魏聪 |1 |3a363e021 |     'voi_idv区域子下存在默认情况进行判断'
  3a363e021f7c2cfd108f8ace05938b20878ccbd0 | 魏聪 |2 |js/idv/terminal/controller.classes.js; js/voi/terminal/controller.schoolroom.js |     'voi_idv区域子下存在默认情况进行判断'
  eda3e5c4af716e52e93bd000706ec63999bffbdb | zagger |1 |views/vdi/system/set-general.html |     去掉影响样式代码
  9e83e3ba9d67aef5c504c5552edc8937813a4ed1 | tianyiwen |2 |views/vdi/help/activeAuth.html; views/vdi/system/set-vdi.html |     fixBugs:17245,17043-去除共享磁盘、去除激活授权idv
  1186683f849f7adee654541b27d7281958661352 | zagger |0 | |     build for uos
  551d76d4f608c5717d2df50ca73028f965d752bb | zagger |0 | |     build for vpc
  d9a2486f386f35845a9bce8c7fb63574b1df8c05 | wangchuan |0 | |     国产化端
  2ab22fa50672d14edd2d7a7efce78431a5c1aa66 | wangchuan |0 | |     VDI客户端包
  4d86da0e9ae176186269e356be49e35029173b2a | wangchuan |2 |personal_login/js/components/user-form.js; personal_login/views/user-form.html |     解决bug#17249
  ec65fee73140f35ed1f597510f5e4b3301d5a5c2 | wangchuan |0 | |     VDI客户端包
  bba600179a710359898c43e668563d1e93c4fd0c | tianyiwen |2 |views/vdi/dialog/system/template_add.html; views/vdi/dialog/system/template_register.html |     fixBug:17238-修改系统桌面类型选项初始值
  906d2b2c60ca593093dbe6dbdf44195372572e56 | tianyiwen |1 |94ee16982 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  94ee16982f55d6a5ec1ede7bb599e157b421b310 | tianyiwen |2 |css/your_style.css; views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     fixBug:17140-修改设置终端快捷键
  d2c53fc0ab4c94d737e78f2aa32f26d12b0542dc | wangchuan |0 | |     build
  a121d85407bdcf7057d04603e4930c2d92199650 | tianyiwen |1 |js/vdi/help/controllers.js |     nothing
  430d86e9a029d7620f2651eb2e1dfdadcc88a093 | tianyiwen |1 |js/vdi/help/controllers.js |     fixBug:17229-修改激活授权中已用点数逻辑
  e4b52a15858f7cfd7cc36e3d3ba00dfc98815394 | zagger |0 | |     build for vpc
  263f9a0a3ff479b83f778e30b49159be70609a76 | zagger |1 |48617e601 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  48617e6015e4bb3c1c8df44e862815d2a925a5c1 | zagger |0 | |     build for vpc
  a72bf10e3a62e95bc465ca6628f355ee6284130c | wangchuan |3 |js/vdi/security/system/controller.security.system.css; js/vdi/security/system/controller.security.system.js; views/vdi/security/system/security_system.html |     tip
  c18478b181cd8aa7dcb573c6024453a49feda0d1 | wangchuan |3 |css/your_style.css; js/vdi/vdi.js; views/vdi/resource/storage/disk.html |     loading加背景色
  338fb5662260cbf3ec3f0423d5971bc57ceed502 | wangchuan |0 | |     VDI客户端资源包
  2336d494562e881d57d75172b8624111cc96b54f | zhangyao |1 |ngconsole-webpack-plugin.js |     修改合并资源的时机
  455d63a01815024382e25177ee47e76a045fe19e | zhangyao |1 |ngconsole-webpack-plugin.js |     修改合并资源的时机
  19e900e509bd09d8d5234364b4574747aeedf47b | wangchuan |0 | |     国产化端
  cd37a6f5bb7790501a72e8d0839f7a2608a0fa7e | zagger |1 |package-lock.json |     国产化前端build
  116b56266855049c399d92b921e5a646c710ca77 | zhangyao |3 |ngconsole-webpack-plugin.js; package.json; yarn.lock |     优化开发服务器
  4a317ff15d5a529aed13b6a6d0f1aae74c9b265b | zhangyao |3 |ngconsole-webpack-plugin.js; package.json; yarn.lock |     优化开发服务器
  060bd368a6dafd2eb43e97251bbad141546c3c47 | 魏聪 |1 |139b620d2 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  139b620d2dc8439f26429e79e4588653f24c395e | 魏聪 |2 |js/voi/hardware/controller.printer.js; views/voi/dialog/hardware/edit_printer.html |     '将文件名上传限制到60字符长'
  8fd149f3b3a68db854128e426e95ffa72292d675 | zhangyao |1 |50aa4d3cb |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  50aa4d3cb148ec5bee6ea1cf1803c24fa38c17c9 | zhangyao |1 |js/vdi/system/system-log.js |     修复日志备份下载问题
  37fc375cf7d11ea9f436da45de170ea902167839 | 魏聪 |1 |a8eb44c66 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a8eb44c669004d7f62eec5a7c9c18cde94974ee3 | 魏聪 |1 |views/voi/dialog/desktop/add_roam_desktop.html |     '去掉漫游桌面上的注解'
  baff6b228442b04d7dffe5903df1cd7c987ddaa8 | tianyiwen |1 |views/vdi/system/set-general.html |     修改自定义logo界面两个btn位置
  ac5c681e50779b5d495d850fead28b51c563b833 | tianyiwen |1 |views/vdi/system/set-general.html |     fixBug：17200-修改自定义logo界面btn位置
  24c9ae2ad640dbbaac6d1dc633050d1dc61f379c | zagger |1 |8a22302d9 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  8a22302d953c901da113ffd40495ecfefd5fc803 | zagger |1 |views/voi/help/deploy.html |     voi部署按钮样式类添加
  7da4f533caf3822161af1014fb4121284369b17f | zagger |1 |views/voi/help/deploy.html |     voi部署按钮样式类添加
  5a9c3d7085d4c85deb4e5ed6d74c39e92d0f7ffb | wangchuan |1 |views/vdi/system/recycle/system_recycle.html |     产品要求改个表头
  f155c818de4ce085bd9b00b16f6e152c5588b453 | 魏聪 |1 |js/voi/terminal/controller.schoolroom.js |     'voi修改区域下存在默认区域的删除提示'
  2f5a57ac09aa08e011b6db369a18b2ce7dee5ac3 | 魏聪 |0 | |     voi打包
  2b683a361fbf71cd30ea7e9ce186a5035b71b34b | 魏聪 |1 |js/voi/terminal/controller.schoolroom.js |     解决子下存在默认区域问题的删除
  f6454fa065530d5040022bc1197db637b7b86751 | wangchuan |0 | |     VDI客户端
  d741ac91e893efe5babc719385215e0ddec2ec95 | 魏聪 |1 |74f0165d5 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  74f0165d5394f38a15063d6423192214b02ae68f | 魏聪 |1 |js/voi/terminal/controller.schoolroom.js |     '区域删除判断'
  138073fdf66702b74a0a06cca6daf510f59ce3e0 | wangchuan |0 | |     VDI客户端包
  6f6def755282fb2a278c9028e46521025174b351 | zagger |2 |views/vdi/dialog/desktop/personal_alter.html; views/vdi/dialog/desktop/personal_new.html |     vdi隐藏镜像分层代码
  1c929714bb9bef8569769fddfd39f25ee2df8a17 | tianyiwen |1 |views/vdi/dialog/security/new_desktop_strategy.html |     fixBug:17165-处理桌面安全编辑的问号换行
  e22fc50bb2e8e9f52c0725bc69d3433dcb31739d | tianyiwen |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     删除写错的代码
  97bf0363a1d37b86aa02cc65abbd89ab1ec53be6 | tianyiwen |1 |76c523ea9 |     Merge branch '5.1.4-vpc' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.1.4-vpc
  76c523ea9f3e9c5307c690e74116fe5daf688daa | tianyiwen |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     fixBug:17140
  120a5f94e4fdaecbfbd4d4545404fbd0e1ad6d04 | 魏聪 |2 |views/voi/dialog/desktop/add_personal.html; views/voi/dialog/desktop/edit_personal.html |     'voi去掉镜像分层功能'
  64291107e0912117c665877adba4e1689b9f884f | tianyiwen |1 |views/vdi/resource/storage/storage.html |     fixBug:17169-去除设置网盘存储
  e0a0bee3fca454a97f6d014f600044a1a6e15851 | 魏聪 |1 |views/voi/dialog/desktop/add_scene.html |     去掉异构
  59bc95bf3b9a2f03b8d44851491c7291ef333886 | tianyiwen |1 |views/vdi/desktop/personal.html |     fixBug:17125-修改录屏管理菜单的位置
  949b541b9395704cd218ca5f0965271caae5bed4 | tianyiwen |1 |fb979c190 |     Merge branch '5.1.4-vpc' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.1.4-vpc
  fb979c1900c82200dc373e89c132a0cfc695da1c | tianyiwen |1 |views/vdi/desktop/personal.html |     fixBug:17125-修改个人桌面设置菜单
  8b2c9c28a41bd92eb8a5715a8107c028be2678c3 | tianyiwen |1 |js/vdi/help/controllers.js |     fixBug：17133-去掉帮助/关于里的win，an，vdi
  dd2698a3a6315caff48b5c9d56ece8dd7dfbfbf8 | 魏聪 |1 |js/voi/voi.js |     '添加一个scheduling状态翻译'
  2f5cb01af04bab93f30ce02e1cf7889520c8403f | wangchuan |2 |js/vdi/security/client/controller.security.client.js; views/vdi/security/client/security_client.html |     终端安全列表：文件传输列只显示开启关闭
  3ec1ed8bbeecb46637053adb558455680caee874 | wangchuan |0 | |     假数据
  e66d5ac3334485b8df9214163e41b544fded264b | wangchuan |1 |views/vdi/dialog/security/client/add_edit_security_client.html |     新增终端安全：图标修改
  16e4698d5c6f33c3ac046b0b6b51d9d304a8a226 | wangchuan |2 |js/vdi/template/system-iso.js; js/vdi/vdi.js |     去掉MessageBox
  849bc446378feaab2291a14bfbb9791cefce5faa | tianyiwen |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     fixBug：17140
  ccdf35e34500a4345b7752034210922074223dff | tianyiwen |1 |0aff96626 |     Merge branch '5.2.0-uos' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.2.0-uos
  0aff966267729488d6934d731698dcfb27a69bb8 | tianyiwen |1 |spice.html |     fixBug:17114
  209b7977e982c04ffcd4e0c90276668e9c0f1658 | wangchuan |0 | |     VDI客户端包
  98bc6405e68608e80c19e29492cad13526779c7e | zhangyao |0 | |     build
  babb09366263ff5053287746aec8920199904cc7 | 魏聪 |0 | |     voi打印机联调中
  df445029de9998d4a031e5257e15f677f2ecc99f | 魏聪 |1 |views/voi/dialog/terminal/printer_bind_detail.html |     打印机失败详细中字段修改
  71192fc7df5c59c9a0e4fe844bdf69449385f0e6 | zhangyao |0 | |     build
  193ce75014de731770f07e1db4678516dac16e29 | zhangyao |1 |js/vdi/desktop/api.js |     fix: 17081
  90bf44e4ffb0fe19f005988cbe135398982af981 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式存储列表轮询bug
  5ace8d4371f74c73370f7020012e70c7051e72b6 | zagger |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     bug#17026 【国产化-终端管理】设置终端运行参数的快捷键里出现了Linux，Windows信息
  33d9a71715c90c86adb10c2f7cb530ab8a65b5a6 | 魏聪 |1 |views/voi/dialog/terminal/printer_bind.html |     'voi个人桌面重置'
  b40b76b11f28e0f12c054dd2d6ebabc1ba0f1e65 | tianyiwen |5 |views/vdi/desktop/teach.html; views/vdi/dialog/desktop/newDeskPool.html; views/vdi/dialog/desktop/scene_new.html; views/vdi/dialog/system/system_deploy_advance_options.html; views/vdi/system/set-general.html |     fixBugs:17031,17037,17039,17042,17046
  b6a8bc3cb288a96d943586a53846fb5274005d1e | zhangyao |2 |js/vdi/i18n/index.js; js/vdi/resource/console/controllers.js |     修复禅道bugs
  2e77ba3c7c26a6323d68aa0b9cf9bc5b238437cd | 魏聪 |1 |img/uos.png |     替换uoslogo
  96873e7d60890ed97e5124bbbe5dc04a5b1d6bf8 | zagger |1 |views/vdi/dialog/desktop/personal_detail.html |     17032 【国产化-个人桌面】个人桌面详情有域相关信息
  f78d0400d856ffa99e020512b9afb21276e393e9 | wangchuan |1 |views/vdi/dialog/template/template_imgManage.html |     分发镜像bug
  d55b4c92c0bb093be92ab62760cb5bbb372a313d | zagger |3 |js/vdi/desktop/personal-desktop-pool.js; views/vdi/dialog/desktop/newDeskPool.html; views/vdi/dialog/desktop/personal_new.html |     vpc-新增资源池-更换新接口-conflict
  d8f6af327f6763540eb17f53a44d320eee01bcdb | wangchuan |1 |d6976131b |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  d6976131b57ab65510a67c5807827b7ba8207775 | wangchuan |3 |js/vdi/template/controller.person.js; js/vdi/template/controller.teach.js; views/vdi/dialog/template/template_imgManage.html |     分布式存储：个人、教学模板，分发
  5cbdc7270e96919c323dfbc40e5b12351386d276 | zagger |1 |e43618d8d |     QMerge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  e43618d8d6e528647c6cdaf41bbc0990a495f640 | zagger |3 |js/vdi/desktop/personal-desktop-pool.js; views/vdi/dialog/desktop/newDeskPool.html; views/vdi/dialog/desktop/personal_new.html |     vpc-新增资源池-更换新接口
  3334cbc7f04057ef61acc1fe982d8d189cb30b38 | 魏聪 |1 |views/voi/dialog/terminal/printer_bind.html |     voi打印机功能优化
  117d68a5b4f185dfe1526ac4a5d6788712ef05ec | 魏聪 |2 |views/voi/dialog/terminal/printer_bind.html; views/voi/dialog/terminal/printer_bind_detail.html |     '在打印界面添加了提示'
  64c5d90d8f43aaff017ab3d1e76ae76b92e4bcec | 魏聪 |1 |views/voi/dialog/terminal/printer_bind.html |     '打印机绑定窗口添加tip'
  0696838db6e81f3b84c91d268b981a15bb9fcf6f | 魏聪 |3 |js/voi/desktop/controller.scene.js; views/voi/dialog/desktop/add_roam_desktop.html; views/voi/dialog/desktop/add_scene.html |     去掉新增漫桌镜像分层的提示，去掉新增场景中3个镜像类型的tab
  6923a0be457f6b6bfe7b3dae752bf5b1c6f9ded7 | 魏聪 |3 |js/voi/desktop/controller.personal.js; js/voi/voi.js; views/voi/desktop/personal.html |     'voi个人桌面重置功能'
  9b80962269393f5fc980b111fc26377a4018ff26 | zagger |3 |views/vdi/dialog/system/template_add.html; views/vdi/dialog/system/template_config.html; views/vdi/dialog/system/template_register.html |     国产化-新增系统桌面去掉-新增，配置，注册等界面，系统桌面类型中去掉共享服务选项
  4b9e69184b9a59aedb84199d0a21daa485ac83b8 | tianyiwen |1 |cf40b360f |     Merge branch '5.2.0-uos' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.2.0-uos
  cf40b360f20af244ea43e14e25fb5414484b73b4 | tianyiwen |1 |views/vdi/resource/storage/storage.html |     bugFix:17022
  cbe1e5b042ed887b67ffe3db1dea002ecd06e935 | zagger |1 |views/vdi/template/teach.html |     共享模板不能删除，只有是owner才可以删除
  d574b0ac2b9a94c3be0c86a32d8e1563b41b3921 | zagger |1 |views/vdi/template/teach.html |     共享模板不能删除，只有是owner才可以删除
  ce851aea743838bff65096459b27542df0af8e95 | zhangyao |1 |b4cf958b3 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b4cf958b36a16d02dcb2147ac5e9f046f12a9fd5 | zhangyao |1 |js/vdi/config/http.js |     web端界面过期后跳转到web端登录界面
  ab81caa994316aa2be9a7697ffc4b179afa85733 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     代码优化
  acbf946aac94b7f4b7aefb3f39b6af201a6abe78 | 魏聪 |1 |views/voi/hardware/printer.html |     修改打印机列表中显示字段name
  39f8087f1372cdbd373c2019a32237edc5481808 | 魏聪 |1 |views/voi/hardware/printer.html |     '修改打印机列表显示字段name'
  17c9ab93fb9622a4705623d763fccc66dfdab841 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     数据平衡bug
  3ec121bdaf9ece6ddebaf2c2e082d15ae86a2291 | zagger |5 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js; js/vdi/utils/ui.js; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     confilct+cherry-pick
  51aefcd8d2360856a90064faa14d94be55c16d93 | zagger |2 |views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     confilct
  3a72ee47b87bd4c5e631e6076ffd4cd5dc1d8f18 | zagger |2 |views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     checPackAll ==>checkPackAll 单词拼写错误
  1829445e6a50472d70746577fb03dc4c10985eda | zagger |0 | |     build for verify allSelect
  117945c7e5129c7a7c199091ecd65bdb7586c127 | zagger |5 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js; js/vdi/utils/ui.js; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     bug for allSelect
  04142fac9120ce5f2340678a8624309ea476754f | zagger |0 | |     build for verify allSelect
  d61eecc87845147821e516a834395492a6b7409c | zagger |1 |78246f3a6 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  78246f3a6401fd3de5e29f49a91603aa9abeb2da | root |1 |js/vdi/utils/ui.js |     bug 全选
  9b44da5011308e44370b97cd2dee03f01716f7a9 | zhangyao |0 | |     build
  d4140e085d1d64dc5f3b14d90185c3812b7a62db | zhangyao |1 |c8d1567df |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  c8d1567df10a087945f5d4b53f1c72eb85355170 | zhangyao |2 |js/vdi/desktop/personal.js; js/vdi/utils/ui.js |     修复bugs
  16e4321b9abf04276889968ac590b30d6bcbb29e | wangchuan |0 | |     idv客户端包
  14835178be84e6c1b8e099bef971d8fb6ec46e67 | zhangyao |1 |87d83ef84 |     fix conflicts & build
  4f49f0794a4efff967d31b855092ad52111ce634 | zagger |1 |js/vdi/spice.js |     定时更新-模板文字修改
  87d83ef84657aab31d96dc0dd04244134ae47b6e | 魏聪 |8 |js/idv/template/controller.template.js; js/idv/terminal/controller.terminal.js; js/voi/hardware/controller.printer.js; js/voi/template/controller.template.js; views/voi/dialog/hardware/edit_printer.html; views/voi/dialog/hardware/upload_printer.html; views/voi/dialog/terminal/terminal_edit_order.html; views/voi/hardware/printer.html |     解决公共模板iso筛选问题
  36a4a43f497999a539bfa7ea26d995c3a7074b8e | 魏聪 |0 | |     'voi打印机打包'
  cb339e1fe4f7dc8a3f7212290fcf8e67a4f9a9e7 | 魏聪 |6 |js/idv/template/controller.template.js; js/voi/hardware/controller.printer.js; js/voi/template/controller.template.js; views/voi/dialog/hardware/edit_printer.html; views/voi/dialog/terminal/terminal_edit_order.html; views/voi/hardware/printer.html |     '打印机修改验证名称'
  df0b0941f3fbacaa895122f3f8c27f7c2df6a2a8 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：修改文本
  034c40e317c6a5e33fb34a11e6b047f22112e2f9 | tianyiwen |1 |927fe2dac |     Merge branch '5.2.0-uos' of 172.16.203.254:hanxiaoxiang/ngconsole into 5.2.0-uos
  927fe2dac9943751527894ad4ef71bcf2cb80980 | tianyiwen |1 |js/vdi/help/system-upgrade.js |     过滤win、an、gue-需求5746
  90cf4be5bcba9c7221de0f4e1b3a5e7a22b14bf8 | zagger |1 |js/vdi/scheduler/disk.controller.js |     添加注释bug#16861 【网盘】解绑网盘服务器成功后界面弹出网盘服务尚未启用
  b5c0fd149e58401eb743a687c92a45a0a98edecb | zagger |1 |js/vdi/scheduler/disk.controller.js |     网盘界面，绑定和解绑网盘服务器期间，暂停前端轮询，成功了之后或者失败之后，调用check_used接口决定是否需求获取list接口
  8c32f860bac66c40c3a827eef2eccf53d2298076 | zagger |1 |css/your_style.css |     loading 背景颜色补上
  beaf330820ba6c1d5ad2f846ffc9aceccf94002f | zagger |1 |css/your_style.css |     loading 背景颜色补上
  b7471aaff521ff19dc72c88329a78c43f8cdfd1d | zhangyao |1 |js/vdi/split.js |     临时打包
  6859b65371c1b714594dfbd2746b705442c9a48a | 魏聪 |1 |views/voi/hardware/printer.html |     'voi解决打印机列表字段没显示问题'
  be74ed8b3f36e582a00ff727b7ba86313d1ede09 | 魏聪 |1 |views/voi/dialog/hardware/edit_printer.html |     'voi打包'
  e0361c8d5641192f819c8b6c20f8b7bdd9f92750 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：存储监控图例横排居右
  99326e715bfd8b2829f1e9d91fba4772aaa11163 | wangchuan |0 | |     .data/8081
  29002d73f8bdef4e149979a2a81f86349d4375b0 | zhangyao |1 |js/vdi/resource/console/controllers.js |     fix: 16893
  09ed7fc70300271bef0eef6d65cec01b60ec732b | zagger |1 |js/vdi/scheduler/disk.controller.js |     添加注释bug#16861 【网盘】解绑网盘服务器成功后界面弹出网盘服务尚未启用
  40d60913ae98554ee139371c779d923474076512 | zagger |1 |ae713a088 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ae713a088c463c3a340ac9962ecc2e9e7af9c76b | zagger |1 |js/vdi/scheduler/disk.controller.js |     网盘界面，绑定和解绑网盘服务器期间，暂停前端轮询，成功了之后或者失败之后，调用check_used接口决定是否需求获取list接口
  35dd35e1e8346a20ed6b7c100954722b8e21b449 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：分布式存储列表加轮询
  951e4d489b6509bcf433c2c258a6a0cd28f1fe84 | 魏聪 |1 |views/voi/dialog/hardware/upload_printer.html |     修改上传打印机配置时的提示
  3a7a7cf38fcd29ad64e8d1dd586e43ee8155de1d | tianyiwen |0 | |     去掉VDI终端升级需求5746
  74db66d09520c4dbd81c8a21cc0077d8de2f0741 | zagger |1 |img/new_login_icon/login_3v.png |     2v图片更新
  fcdaec8fc93f042bef4abbc9b7f67ee4e8494cd3 | wangchuan |0 | |     build
  8012a40f86f5f0ae592e36126704cbddcd0d468f | 魏聪 |1 |de96ce8f0 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  de96ce8f099ce516898b7947caf6103684d2337a | 魏聪 |1 |js/idv/terminal/controller.terminal.js |     voi打包
  47899e652c6f802c75e4b87068d5d605b90dacc6 | wangchuan |0 | |     IDV客户端包
  84d7ae1351eef7e1268a4180bc0af901b8df9b46 | zagger |0 | |     build
  2a499325bf63c2b62cdb2c4e59948c483c9c2a79 | wangchuan |0 | |     VDI客户端包
  cc6adb432be00000c44cbbfc899e0c2262a37d2d | zagger |0 | |     假数据
  abc1918afb9fcd9e3d5dc11ad91b0c99daddf509 | zhangyao |1 |js/vdi/desktop/personal.js |     fix: 16815
  db318a672ec96d3c0c316173533349384550b2ac | zhangyao |1 |a439a5d1b |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a439a5d1b8bb601420b214efff557f4f171910b5 | zhangyao |2 |js/vdi/bootstrap.js; js/vdi/split.js |     修改裂脑问题
  9fa8a1ecced87066c9480d03d3b7dd2e0df0605b | 魏聪 |1 |js/idv/terminal/controller.terminal.js |     '修改idv重命名终端的提示'
  b0d8554634bbd1bda1911cf6cbb4c363e876cb79 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：存储监控添加轮询
  63f10792c6f08f701a502bc2f1f123ead418c15f | zhangyao |1 |93e30e987 |     合并 5.1.4 后来的改动
  f47e7c45cbc95b652bcc947108ae0a47365c90e5 | zagger |0 | |     build
  6cf26a5dad4c8dbbaf7594c9c65203477aa9313e | zagger |1 |a41224175 |     Merge branch '5.2.0-uos' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.2.0-uos
  4d9fe70e79a818a7dfed6a73605e16d03c860a7b | zhangyao |1 |73c58a1dc |     fix conflicts
  a41224175b302aa6afdb4e963eb7db27b5461313 | zagger |1 |f947721b2 |     Merge branch '5.2.0-uos' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.2.0-uos
  73c58a1dcc315edb7fa1a83fe4ec85753f53ddf9 | wangchuan |0 | |     客户端包
  f947721b249c72fd736d8926c75ab72b20a2f95c | zagger |1 |8b6b5d66c |     Merge branch '5.2.0-uos' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.2.0-uos
  93e30e9871a1eb4ac5953e35da1f4a0be700525e | zhangyao |1 |f68707227 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  f68707227b1477f60f6eec01561c23d9f139f07c | zhangyao |1 |ngconsole-webpack-plugin.js |     适配 5.2.0 打包
  33bfe729136fdc640cf9064a93f66b3f151bc963 | 魏聪 |1 |views/voi/terminal/client.html |     '终端打印机显示条件修改'
  2486be4ad872d2b97a8ff4d58d9aea0c1806d586 | 魏聪 |1 |img/client_voi_logo/vpc-fusion_zh-hans.bmp |     添加了voi终端logo
  2825e4357015cf2452a818dac4308e064ffa4c35 | 魏聪 |1 |979b7c0c0 |     Merge branch '5.2.0-uos' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.2.0-uos
  979b7c0c01f5c3d8be0503f9ef74a9baa8f63559 | 魏聪 |10 |css/your_style.css; js/idv/desktop/controller.scene.js; js/voi/hardware/controller.printer.js; views/idv/dialog/template/add_tpl.html; views/idv/dialog/template/edit_tpl.html; views/idv/dialog/template/register_tpl.html; views/voi/dialog/template/add_tpl.html; views/voi/dialog/template/edit_tpl.html; views/voi/dialog/template/register_tpl.html; views/voi/dialog/terminal/printer_bind_detail.html |     修改了voi idv 下拉树换行问题
  f6d33eddc0116bf3585985e6f9926d1f4662b7d8 | zagger |1 |views/vdi/dialog/desktop/personal_new.html |     新增桌面 去掉 镜像分层
  1f4d88ffeaefd136a8075984c8868f8eed8b70b4 | 魏聪 |1 |img/client_voi_logo/vpc-fusion_zh-hans.bmp |     添加voi终端logo
  8b6b5d66caa1dbc250e740d1ac18620659c1f2f0 | zagger |1 |views/vdi/dialog/desktop/personal_new.html |     去掉新增桌面，镜像分层代码
  c78b06419e90fab4d19bac42c234d63061ffe231 | wangchuan |0 | |     VDI客户端包
  f21630334870ff6b279f75d26fb22870c583fca7 | wangchuan |0 | |     VDI客户端包
  ab41085bcf45ae917821e23c784d9cbf65f5c142 | zhangyao |1 |6e2b9871c |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  6e2b9871c46bb89e6ad71020ebcd238b8e2e7354 | zhangyao |2 |js/vdi/desktop/common.js; js/vdi/desktop/scene.js |     fix: 16677
  775830c1a37a8f2cc1c738073f1ca20ba663fc89 | zagger |4 |js/vdi/desktop/personal.js; js/vdi/template/controller.person.js; views/vdi/dialog/desktop/personal_save_template.html; views/vdi/dialog/template/template_person_copy.html |     添加遗漏的管理范围的地方
  449457d91f5c45422e5019ab1e579d9cf22b38be | zagger |1 |views/vdi/monitor/alarm.html |     告警信息-日期框改为跟日志这里一样的
  4653540b37b420076c482b720a096074f23522e0 | 魏聪 |5 |views/vdi/dialog/template/template_teach_add.html; views/vdi/dialog/template/template_teach_edit.html; views/vdi/dialog/template/template_teach_register.html; views/vdi/dialog/template/template_teach_save_as.html; views/vdi/dialog/user/user_admin_scope.html |     vdi idv 范围选择下拉树添加不换行水平滚动
  702de4bf56bbb0b3046db6c3e3add07447cd1f1b | 魏聪 |1 |70c0814c1 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  70c0814c1cb9341d36cd356ae618d87ea67e697e | 魏聪 |7 |css/your_style.css; views/idv/dialog/template/add_tpl.html; views/idv/dialog/template/edit_tpl.html; views/idv/dialog/template/register_tpl.html; views/voi/dialog/template/add_tpl.html; views/voi/dialog/template/edit_tpl.html; views/voi/dialog/template/register_tpl.html |     voi注册模板下拉范围选择框，文本换行改水平滚动
  c3f72b26bbc7511f8794b8b82c2132a47e38fdad | zagger |0 | |     build for veryfy
  8fd67737dedd086a3dfa5bd220ce7e2f9c6642ec | zagger |1 |ssh_terminal/terminal.js |     拼接webssh wss，在修改服务器端口号时，url地址
  c42ea97bfd756fab96d0911803a4e5d1a2cb18d4 | wangchuan |0 | |     build
  c0336105e8a7389564dc661879f3a060dadda490 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     存储监控：无数据时的样式
  b31d71b41e9f5fdf0b88e94d2fec46e598e25800 | 魏聪 |1 |js/voi/hardware/controller.printer.js |     voi打印机转测
  e78c57095cf6fb0b935f9d277f7f8e8b764306e5 | 0obuwawao0 |1 |views/voi/dialog/terminal/printer_bind_detail.html |     '修改打印机显示字段'
  cb09e09fb572ebca9c786c2492b53fa9a3f1a1d1 | 0obuwawao0 |1 |views/voi/terminal/client.html |     '修打印字段'
  687ac9231f7aa24a2feaa0a1fd332a2a818fbfbb | 0obuwawao0 |1 |views/voi/desktop/personal.html |     voi屏蔽个人桌面重置功能
  6ca07873d5cfa89d382d8ce9e25c43a8cc02a972 | 0obuwawao0 |1 |views/voi/terminal/client.html |     修改点击样式
  8a371a50bb4792ff0284175609c6a6a07e4f432c | 0obuwawao0 |1 |views/voi/terminal/client.html |     打印机终端列表里显示版本
  21c1913050b78c3e1e2d5916e3f4fd04047ca876 | zagger |0 | |     build
  754226d2e865b0d8f6818b844139b25f666843b8 | zagger |1 |a42ea0f05 |     Merge branch '5.2.0-uos' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.2.0-uos
  a42ea0f0581ad45541f5184405249bf9b8382ac9 | zagger |3 |views/vdi/dialog/desktop/personal_alter.html; views/vdi/dialog/desktop/personal_new.html; views/vdi/dialog/desktop/sence_alter.html |     共享磁盘三个地方去掉：个人桌面：新增和修改，教学桌面：修改
  80e0c87ae6932409ffe8d9fee43451f42d5b2198 | 魏聪 |0 | |     voi打包测试
  893efbe5d98e0f2040ced4550e4b28aea51b0478 | 魏聪 |3 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/voi.js |     同步解决voi个人桌面和漫游桌面筛选域问题
  9e03f37568b527ff104f04d1bbddfe81c2382b7b | 魏聪 |0 | |     voi打包测试
  7c81ee8c51d16894644b8bfa522ebd7cfad008e3 | 魏聪 |1 |e2b103748 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  e2b103748355df0d1b5390f2d1ba42b208cbe02f | 魏聪 |5 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/voi.js; views/voi/desktop/personal.html; views/voi/dialog/desktop/alert_input_ok.html |     解决域树筛选桌面和数据更新问题
  22e653df58f5ebe42641955a9d307bc1e3639b01 | zhangyao |0 | |     build
  454daa52638f2193934bd33ce69c62d7110b5987 | zhangyao |3 |js/libs/spice/scripts/oevdi-0.1.12.min.js; js/libs/spice/scripts/workerprocess-0.1.12.min.js; js/vdi/utils/remote-desktop.spice.js |     更新 spice 库到 0.1.13
  333040c3cf2406985ef5186b6951fe9425877b4a | wangchuan |0 | |     客户端包
  a691081573919a0ec0282be94773cbe6e4f30cea | wangchuan |1 |b78b93a75 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  77fefbe228ba883f25c9161f08f718f0d3b45db7 | zagger |0 | |     添加定时修改密码假数据
  b78b93a75c07bf6a71f24a93e1627497131d7848 | zagger |0 | |     添加定时修改密码假数据
  25f986382322b324db2a5ca1ebd42ce9a5c94114 | zagger |1 |css/your_style.css |     镜像管理表格样式修复
  9d0bd8cbef76a1a5f917be2f0fc04c0635f6e097 | zagger |1 |css/your_style.css |     系统桌面中特殊help-tip的dom结构样式修复
  042e76d27a467767e95a893100d31736a00f8378 | zagger |2 |js/vdi/security/common.js; views/vdi/scheduler/disk.html |     用户帐号-添加帐号名称过长时，省略号显示，title显示全称
  9a14f299094e0d76a7b152fe0560210b264c3413 | zagger |3 |css/your_style.css; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     conflict
  8c7bc9df30e3bb335e3afbc37fe80560ba062fbc | zagger |1 |views/vdi/dialog/desktop/personal_new.html |     conflict
  dbaf650a35c98c8a33b5808dab4a4afddb17a812 | zagger |1 |js/vdi/scheduler/disk.controller.js |     添加冲突
  6142b9ae5f83d561e5b6ec7f9c54abf3cde3678d | zagger |1 |js/vdi/monitor/alarm.js |     告警信息-list接口-筛选参数问题：#16704
  0dc1992920cf6e412c28da7317bfa99326ea812c | 魏聪 |0 | |     voi打包
  cb7823d4c659e6117a6cbe616510ef0ba0821617 | zagger |1 |js/vdi/monitor/alarm.js |     告警信息-list接口-筛选参数问题：#16704
  79711a668d927c859aaa575d77b07616672f436b | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/dialog/resource/storage/add_disk_group.html |     分布式存储：代码优化
  a2f86aee5a584fe1e959bb930536d20b6f4e7417 | wangchuan |0 | |     假数据
  3db55602f3d93310d3032821a5e83db2bae51f9a | wangchuan |1 |js/vdi/resource/storage/controllers.js |     配置公共存储：不激活不显示分布式选项
  58485f6759676b13a0fada78b0d240506097895a | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     分布式存储：代码优化
  ec988a846cbfa0218d824abb45a2c7ae25302ac3 | zagger |0 | |     build for verify
  eb34d15f1c7bda4ad2a53d9f4a6e9db99d61da41 | zagger |1 |b5e2e6bb9 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b5e2e6bb9307c9c7f31385234452279774fda43f | zagger |2 |js/vdi/scheduler/disk.controller.js; views/vdi/dialog/desktop/personal_new.html |     bugs
  534904fff241ff4a20d049aba19448a540ccd445 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     存储监控：bug修改
  e4909d12ef313b2fa4eefbc0d9a26d532f83721b | wangchuan |0 | |     build
  3e38918c949df279bdb8184e044e9631d0b29782 | wangchuan |1 |08984aaed |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  eeb9b83be9ecdc19ced8c4e22dc1f2d5ef6dbb14 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     存储监控：优化
  675f9c7fc207da9f503e432b35d07b3b199fb762 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     IO时延轮询优化
  08984aaed61e632f7d5bb9e78d17515d4830fdb7 | zagger |3 |css/your_style.css; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     去掉影响全局的样式代码-帐号导入-样式
  193a1cd90213374e7344f84e730f804aecd4966c | zagger |1 |b285010fc |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  4c89f726c41fd34ce2e0180f6af8fffc5e2f7340 | wangchuan |1 |views/vdi/dialog/resource/storage/add_disk_group.html |     添加分布式存储/磁盘：界面优化
  b285010fc2cc9ae23111a2a8fc8e900072af661d | zagger |2 |js/vdi/security/common.js; views/vdi/scheduler/disk.html |     用户帐号-添加帐号名称过长时，省略号显示，title显示全称
  ca775040208af09ca46df17a73211d05004e7af7 | 0obuwawao0 |1 |00d226890 |     合并代码
  e323866977b8b8482d202eb158fc23bb10a801e2 | 0obuwawao0 |0 | |     voi打包测试
  1e3dd30da2125cfcd926f032c13a8daa19aabf4a | 0obuwawao0 |1 |js/voi/desktop/controller.scene.js |     修改voi场景新增时下拉框可选
  88fb7131474f556e172c36b73ec1212e2c158215 | zhangyao |1 |f1cae2551 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  f1cae255153f6a99b242e243a5306462aec984e5 | zhangyao |1 |js/vdi/spice.js |     fix: 16534
  563101a0bc4600b11627e9e842844ef7ef89db8d | 0obuwawao0 |4 |js/idv/desktop/controller.scene.js; js/voi/desktop/controller.scene.js; views/idv/dialog/desktop/add_scene.html; views/voi/dialog/desktop/add_scene.html |     voi idv公共桌面新增的下拉树可选择
  b56df3d128ec1f69aa436844337297fc25eea39c | zagger |1 |css/your_style.css |     系统桌面中特殊help-tip的dom结构样式修复
  be4188e9e9824b6609864d9e128a4c3221d779c2 | wangchuan |0 | |     国产化：build
  7c9f3bf6bf63f2577186f1277871c966e0a16843 | wangchuan |1 |ngconsole-webpack-plugin.js |     国产化：打包配置
  6e51b27975ddf9d168f269c02f0a49e7652c4e47 | wangchuan |1 |a719661d9 |     合并5.1.4-vpc
  a719661d98ad775ba0ac4ee505e1f36587890e50 | wangchuan |0 | |     国产化：VDI客户端包
  cc4081cd9e5015b658aff547f1c4b28b7da3c530 | wangchuan |0 | |     VDI客户端包
  ecd06792b1c2adf599a31000cd4a0d4d960092f7 | zagger |1 |css/your_style.css |     镜像管理表格样式修复
  881094f0661978ad764a35798fe37e2e7760ba20 | wangchuan |0 | |     build
  21d4760cdb96ccef56c7d422536801493c517dc7 | wangchuan |1 |192a89757 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  c58e4c9a70f033d267dfe2d1c06a56ff34c1a342 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     IO次数：四舍五入
  a00344aac1f2e2bbacd7df2fa3a78132be5c96a2 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：IO吞吐趋势
  192a89757b7910e584e67c2db26a1bb0352a34d6 | zhangyao |1 |753f0e8fb |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  753f0e8fbaeba4e31e01794c4fe7c663974b1a9e | zhangyao |1 |views/vdi/common/account-password-modify.html |     修改密码时去掉对旧密码的校验
  00d226890d00c85ee7c534b87b391b56c8bf6c33 | 0obuwawao0 |15 |js/vdi/spice.js; js/voi/hardware/controller.printer.js; js/voi/help/controller.deploy.js; js/voi/terminal/controller.terminal.js; views/idv/desktop/scene.html; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/voi/desktop/personal.html; views/voi/desktop/roam.html; views/voi/desktop/scene.html; views/voi/dialog/hardware/upload_printer.html; views/voi/hardware/printer.html; views/voi/help/deploy.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     修改voi idv 左侧树支持水平滚动
  4b18527184bba5aaf1dab2837caef5fcb2516ee5 | 0obuwawao0 |2 |js/vdi/spice.js; js/voi/help/controller.deploy.js |     删除一些注解
  deba3a5effd143f9fdda33576c9b72ca716fc7fc | 0obuwawao0 |0 | |     voi 打印机联调打包
  dfd453f74e4110c72fedec66d8d5a0106b7c5e09 | 0obuwawao0 |1 |views/voi/desktop/scene.html |     修改voi场景左侧树支持水平滚动
  4fc0192bd90fd3c13385694c95a868da17ecaebc | 0obuwawao0 |16 |js/vdi/spice.js; js/voi/hardware/controller.printer.js; js/voi/help/controller.deploy.js; js/voi/terminal/controller.terminal.js; spice.html; views/idv/desktop/scene.html; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/voi/desktop/personal.html; views/voi/desktop/roam.html; views/voi/desktop/scene.html; views/voi/dialog/hardware/upload_printer.html; views/voi/hardware/printer.html; views/voi/help/deploy.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     修改voi idv 列表左侧树统一为自动水平滚动，避免深级别无法显示问题
  1d72911894ea019848523851fea5f4d5d8806991 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     分布式：数据盘替换按钮显示逻辑
  c189c33afb37971f5de777bcb0e7d778a6b9174a | zagger |7 |css/your_style.css; js/vdi/desktop/personal-desktop-pool.js; js/vdi/desktop/personal.js; js/vdi/desktop/scene.js; views/vdi/dialog/desktop/newDeskPool.html; views/vdi/dialog/desktop/personal_new.html; views/vdi/dialog/desktop/scene_new2.html |     【管理台】-【模板】模板类型调整说明需求
  5e72378241a84ed9f07feabb82b39144e6f83fbb | zagger |2 |js/vdi/desktop/personal.js; js/vdi/os-types.js |     系统类型-删除不需要的系统类型，删除个人桌面不需要的代码
  e5845ff9a2900d69584a6d08fe0ca0932051ea83 | zhangyao |1 |b1fb28075 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b1fb28075fab01efbe5156d48f687fa280b6607b | zhangyao |5 |js/vdi/desktop/personal.js; js/vdi/resource/console/controllers.js; js/vdi/user/common.js; views/vdi/desktop/personal.html; views/vdi/desktop/scene.html |     fix 15568，16572，16533，16456
  3259f227b52989f9459f0f01558f7a0ba59cc4bc | zagger |1 |views/vdi/scheduler/disk.html |     去掉多余代码
  d810f1a666a371fb8e3c1d80666fcf60531652e3 | zagger |1 |views/vdi/scheduler/disk.html |     loading 时不显示分页，看下效果
  e708356d82bd2a27b3a2a0acefa5f5f70f8cacfd | zagger |0 | |     build for verify
  6fe49abccce8d69d90049b4977b1bb9d697f06f7 | zagger |1 |e955e3868 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  e955e38686f8f01f700a555af9ae95543de41558 | zagger |5 |js/vdi/scheduler/disk.controller.js; js/vdi/user/admin-user.js; js/vdi/user/uaa.js; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     网盘参数整理-uaa导入帐号代码bug
  8788f558b5bf121a9c0c36dec906115ce89b38dd | zagger |3 |css/your_style.css; js/vdi/scheduler/disk.controller.js; js/vdi/user/admin-user.js |     1.添加弹窗中 影响全局的样式 加了个over-flow：hidden；2.添加注释代码
  57d87e92ab236ad3bd970fc6c7b82a6f33c0237c | 0obuwawao0 |23 |js/idv/desktop/controller.scene.js; js/idv/template/controller.template.js; js/idv/terminal/controller.terminal.js; js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/desktop/controller.scene.js; js/voi/help/controller.deploy.js; js/voi/template/controller.template.js; js/voi/voi.js; views/idv/desktop/scene.html; views/idv/dialog/template/merge_tpl.html; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/voi/desktop/personal.html; views/voi/desktop/roam.html; views/voi/desktop/scene.html; views/voi/dialog/desktop/desktop_detail.html; views/voi/dialog/desktop/host_config.html; views/voi/dialog/template/merge_tpl.html; views/voi/dialog/terminal/pool_add_edit.html; views/voi/help/deploy.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     手动合并voi idv 5.1.4-vpc分支的改动
  6d52836170a4d8a09b0ee71e0b5c2767318d1545 | 0obuwawao0 |3 |js/voi/hardware/controller.printer.js; js/voi/help/controller.deploy.js; views/voi/help/deploy.html |     voi打包自测
  fc9f281fe900f2eaa3a33370b92d8ce94111c2a9 | zhangyao |1 |a32c4247a |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a32c4247a727758e8617474dd30d307e214f1fbf | zhangyao |2 |js/vdi/utils/ui.js; views/vdi/common/password-strength.html |     解耦密码复杂度和密码强度
  222d46c5127885499a1b800716cb9b5a58d0125a | zhangyao |2 |js/vdoi/main.js; views/vdi/login.html |     修复登录跳转后，登录页面销毁时有残影问题
  c9e6776455b6fd423dda638415f7039efcab0502 | 0obuwawao0 |1 |js/idv/terminal/controller.terminal.js |     idv终端载入显示效果
  62b7b9708d524c9ffc0198ea77e5a876941d1d0a | zagger |0 | |     build for verify
  aff00ff231780fea0e645f80148274bf85946c41 | zagger |6 |css/font-jj.css; fonts/icomoon.eot; fonts/icomoon.svg; fonts/icomoon.ttf; fonts/icomoon.woff; views/vdi/login.html |     添加字体库 + login登录tab页两个icon添加
  549e9b91471208d0dacdaa4c8bb974e9af5481e0 | zagger |1 |2332dcbb5 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2332dcbb512ddd1b8288315ad50d484a74b2c928 | zagger |2 |css/your_style.css; img/logo/vpc-fusion_zh-hans.png |     设计师换图
  93e92dd6a082e44640c09ddbd9a8b9abaf26231e | 0obuwawao0 |5 |js/idv/template/controller.template.js; js/voi/desktop/controller.roam.js; js/voi/template/controller.template.js; views/idv/dialog/template/merge_tpl.html; views/voi/dialog/template/merge_tpl.html |     voi解决漫游桌面下载录像地址问题
  ba9db9a50afdd7233ee38ae03b37baf88770200c | 0obuwawao0 |6 |js/idv/template/controller.template.js; js/voi/desktop/controller.scene.js; js/voi/help/controller.deploy.js; js/voi/template/controller.template.js; views/idv/dialog/template/merge_tpl.html; views/voi/dialog/template/merge_tpl.html |     处理模板合并窗口提示，处理快速部署
  53ccd65b8040e7578e056023a6359e3bdee23f22 | wangchuan |2 |js/vdi/security/system/controller.security.system.js; views/vdi/security/system/security_system.html |     系统安全：启用/禁用策略优化
  bb7a00be6cf0521af7e40a5cb5e3af307d6e91a7 | wangchuan |1 |views/vdi/security/system/security_system.html |     系统安全：启用/禁用策略bug
  d8db747207bbb37d20118bfc2840d76fc054ae5a | 0obuwawao0 |3 |js/voi/desktop/controller.roam.js; views/voi/desktop/roam.html; views/voi/dialog/desktop/host_config.html |     解决漫游桌面上的一些bug
  1f871ebd526db1d9b0e2c3d9fd4e6562f139beb6 | wangchuan |1 |views/vdi/dialog/security/client/manage_security_client.html |     需求变更。产品要求：管理终端详情改为和管理桌面那一样
  2d592fe461c39d5186792c5db1dac66d7aa9f459 | zagger |2 |js/vdi/user/role.js; views/vdi/app-header.html |     dms功能移除
  92c03f37d9d297ce9d7aa93298f1f66d4f2376f1 | wangchuan |1 |2a018aa9c |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  2a018aa9ce8c1d4151fb979924b33c3e580a80fa | 0obuwawao0 |1 |2a78eaeef |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2a78eaeefdea9f3fc499b1d86050eb64547d3763 | 0obuwawao0 |4 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/terminal/controller.terminal.js; views/voi/desktop/personal.html |     解决跳转搜索问题，保持唯一性以及筛选显示
  c6241991909a6b681a494e3e59d62582178c9ce7 | zagger |1 |083875203 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  083875203a835d3c5057cb03dbc40834883dc59c | zagger |1 |css/your_style.css |     logo靠左的边距10px
  49bf88321d45726b611a92b428064a916a31dbeb | 0obuwawao0 |7 |js/idv/desktop/controller.scene.js; js/vdi/terminal/controller.terminal.js; js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/desktop/controller.scene.js; views/voi/desktop/personal.html; views/voi/desktop/roam.html |     解决一批bug
  51d66d0d4b85f23915f832cb24032ee11f5f0441 | wangchuan |1 |views/vdi/dialog/HA/new_ha.html |     新增HA提示
  b88d18dd49c2c0ce00127fd81c329da67af754b1 | wangchuan |0 | |     build
  0b156a9955fd3360933f674ae917045a1c1b172d | wangchuan |1 |8d5d141aa |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  fa1a8d95a81c333be9517f4fa0d5b634e0b9ec80 | wangchuan |2 |personal_login/js/webLogin.js; personal_login/selectDesk.html |     修改选择桌面样式
  761a627c63b761014fa1b071386554a1337da64b | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：IOPS数据去掉小数位
  8d5d141aa9bf88f5f18f65592d8076563bed4ffb | wangchuan |1 |7aa31d08f |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  f5283d0ca0ce842be2e34ff8bfba27e4a73572dd | wangchuan |12 |views/idv/desktop/scene.html; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/vdi/dialog/security/client/apply_security_client.html; views/vdi/dialog/terminal/terminal_schoolroom_add.html; views/vdi/dialog/terminal/terminal_schoolroom_edit.html; views/vdi/terminal/client.html; views/vdi/terminal/schoolroom.html; views/voi/desktop/scene.html; views/voi/dialog/terminal/pool_add_edit.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     超出显示...的树
  b2e76a1e42b05dcade1ac771fd02a056189b3bc2 | wangchuan |1 |css/your_style.css |     超出显示...的树
  aa6d359cf7becfff0eb92aedaa172cf9213cfdd9 | wangchuan |13 |css/your_style.css; views/idv/desktop/scene.html; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/vdi/dialog/security/client/apply_security_client.html; views/vdi/dialog/terminal/terminal_schoolroom_add.html; views/vdi/dialog/terminal/terminal_schoolroom_edit.html; views/vdi/terminal/client.html; views/vdi/terminal/schoolroom.html; views/voi/desktop/scene.html; views/voi/dialog/terminal/pool_add_edit.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     超出显示...的树
  7aa31d08f23e2d7df1781be02e9440ea5aef4b51 | zhangyao |1 |views/vdi/desktop/personal.html |     fix: 16455
  f6c97579c4eb2dff3a1a8ca8ae389c1e3b33165b | zagger |1 |views/vdi/dialog/desktop/personal_detail.html |     个人桌面详情-gpu代码隐藏
  71b66ecd801687d174c23477fa54540be72f39b0 | zhangyao |1 |3fc68f6ba |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  3fc68f6ba88ae6a5e8d8fe0a7acdbe8395aeb9d6 | zhangyao |1 |js/vdi/help/quick-deploy.js |     fix: 16228
  69c326eb32d1767127698dc2ac82e3329f78db14 | zagger |11 |views/vdi/desktop/personal.html; views/vdi/desktop/poolList.html; views/vdi/desktop/teach.html; views/vdi/dialog/desktop/personal_alter.html; views/vdi/dialog/template/template_person_config.html; views/vdi/dialog/template/template_person_register.html; views/vdi/dialog/template/template_personal_add.html; views/vdi/dialog/template/template_teach_add.html; views/vdi/dialog/template/template_teach_config.html; views/vdi/dialog/template/template_teach_register.html; views/vdi/resource/pool/host.html |     gpu相关的代码隐藏
  886cccacb6e9730653702e5729c35ce0911b1048 | zagger |2 |js/vdi/template/controller.hardware.js; views/vdi/dialog/template/template_hardware_add.html |     硬件配置-新增-添加注释
  b995789d834bd77293230be3d3f229facd7d015a | zagger |2 |js/vdi/template/controller.hardware.js; views/vdi/dialog/template/template_hardware_add.html |     隐藏-硬件配置-新增硬件配置-html和js中gpu显卡的相关内容
  58cae0a4ca3f727efb68ec98db5cae39d0f5d39c | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求：IOPS数据去掉小数位
  9f7e695749de4027a503802851317cd27abae1f9 | 0obuwawao0 |1 |js/voi/template/controller.template.js |     voi打包自测
  65a6579ed4606d3aa9a657907d9714bcdeec0570 | 0obuwawao0 |8 |js/idv/template/controller.template.js; js/voi/template/controller.template.js; views/idv/dialog/template/add_tpl.html; views/idv/dialog/template/edit_tpl.html; views/idv/dialog/template/register_tpl.html; views/voi/dialog/template/add_tpl.html; views/voi/dialog/template/edit_tpl.html; views/voi/dialog/template/register_tpl.html |     修改voi idv模板新增，编辑，注册范围下拉框
  0ffb1cf908dd25c8d96522fb1ae021cc957931a4 | 0obuwawao0 |2 |js/idv/template/controller.template.js; js/voi/template/controller.template.js |     修改voi idv注册，编辑，新增模板时区域的下拉样式
  3372f2c6905e02bbd1a24fe3fa1aed0f02fd170e | 0obuwawao0 |8 |js/idv/template/controller.template.js; js/voi/template/controller.template.js; views/idv/dialog/template/add_tpl.html; views/idv/dialog/template/edit_tpl.html; views/idv/dialog/template/register_tpl.html; views/voi/dialog/template/add_tpl.html; views/voi/dialog/template/edit_tpl.html; views/voi/dialog/template/register_tpl.html |     修改voi idv注册，编辑，新增模板时区域的下拉样式
  af2e6f5b3318c501f103c1ae331432460091db5e | zagger |0 | |     build for voi test
  141c9f7c8585c186496118815004bb06205e8707 | zagger |1 |fa5d2d54d |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  0e98f29d844616175218e2b00b8b1f5103e24f43 | 0obuwawao0 |4 |js/voi/desktop/controller.personal.js; js/voi/template/controller.template.js; views/voi/dialog/template/edit_tpl.html; views/voi/dialog/template/register_tpl.html |     正在改注册下拉框树
  fa5d2d54dd79b76132b0d6110f4930848519b41a | zagger |1 |js/vdi/user/common.js |     多选框兼容voi和idv
  8b6350818f129b37a233cea168a8435f1a26991e | zagger |1 |js/vdi/user/common.js |     多选框兼容voi和idv
  76bccd85f1a279fc7d34219eda306da3d0218a86 | 0obuwawao0 |2 |js/voi/desktop/controller.personal.js; views/voi/dialog/desktop/add_personal.html |     去掉新增个人桌面时的3种类型
  f192194d1a221ce04bf2e1ee59455b1a1b5291ea | wangchuan |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     设置终端
  5125f2baab2f3b4aa303a8495d8c4f6cad6d61d4 | wangchuan |1 |2b6fadce7 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  1cda7b7a2f3bbd1476f1ff45b0f163622cd17e02 | wangchuan |2 |js/vdi/resource/storage/storage.css; views/vdi/resource/storage/disk.html |     分布式：样式
  b945449f27abcadaf82715e9ed1a59247f5fdcb3 | wangchuan |5 |css/your_style.css; js/vdi/resource/storage/controllers.js; js/vdi/resource/storage/storage.css; views/vdi/resource/storage/disk.html; views/vdi/resource/storage/storage.html |     分布式：样式修改
  63775d3ef8fe67c626c76cac8a80e56adcf4a783 | zagger |1 |js/vdi/user/role.js |     角色删除逻辑修改
  2b6fadce79c4da3371248a95145e16465b98862f | zagger |0 | |     build for 91
  52a291e803e38f67383fb9a0e12ff570154e4678 | 0obuwawao0 |1 |76f9ce5d8 |     合并修改
  5d2b612608af9c08a6ccc712aed681937ac2eb17 | zagger |1 |84587d646 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  84587d646df310c6ebe2d5e7fc83ec0c1a423819 | zagger |1 |js/vdi/user/role.js |     角色删除逻辑修改
  76f9ce5d848b0ae462a7f9de088543c9f9bd7f85 | 0obuwawao0 |8 |views/vdi/system/hardware_tab.html; views/voi/desktop/personal.html; views/voi/desktop/roam.html; views/voi/desktop/teach-list.html; views/voi/dialog/desktop/add_personal.html; views/voi/dialog/desktop/desktop_detail.html; views/voi/dialog/template/add_person_tpl.html; views/voi/terminal/client.html |     去掉不要的展开列表功能
  5bc3c2695ab4f241832c79df834e999e49df306b | zhangyao |1 |b67d26493 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b67d26493160bcdb92f7929237c1c44931e01d80 | zhangyao |1 |js/vdi/desktop/personal.js |     fix: 16388
  d60d110e65473f8d0f9b959ae6f0f708536dd10c | zagger |4 |views/vdi/desktop/personal.html; views/vdi/desktop/scene.html; views/voi/desktop/personal.html; views/voi/desktop/teach-list.html |     移除-域操作移出需求说明
  f6b78f22e845ed25fc2eaac8a4a62accabbdd81f | zagger |1 |js/vdi/help/controllers.js |     袁阳曰：小于0的强行改为0
  dc180f38d2b830e8aba698ef2ce1866cf5801d2f | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     uaa帐号改变传参方式
  2a93a7119e36f848498afa467f37712eb14727f5 | zagger |1 |js/vdi/user/role.js |     16394 【角色权限】有dms权限的管理账号登录管理台功能结构树会多一个dms
  e937bc145ce8c0578decfbcfd2230a162ad1a19c | zagger |2 |css/your_style.css; views/vdi/help/deploy.html |     快速部署 袁阳需求强行要修改这里的按钮样式
  b5aa3f8ecd8bc9779773a98cac8c2a129a191c81 | zagger |1 |js/vdi/help/controllers.js |     袁阳曰：小于0的强行改为0
  8e002741f806efd0fb4ecc14898f38ad7a0cf3b6 | zagger |0 | |     build for 91
  099ba7a991b046f53aad9b925fa0c322ee1910a5 | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     uaa帐号改变传参方式
  c43acbaf2bdba8ca52208c83b201a5281309280c | zagger |0 | |     build for verify logo img
  44239b309cacc2cc099eec0f4e935f8abf6954f2 | zagger |1 |img/logo/vpc-fusion_zh-hans.png |     换为最新的logo图片
  4290de4cc13bb942217be0bef36cc87e4954faec | zagger |1 |js/vdi/user/role.js |     角色删除-去掉之前的判断
  ee18e1f0e768ce071d0f78fab4acff6499651281 | zagger |1 |js/vdi/user/role.js |     16394 【角色权限】有dms权限的管理账号登录管理台功能结构树会多一个dms
  a3220397c4ae74d4167b2141fab1dd4c90e5f171 | zagger |1 |js/vdi/user/role.js |     角色能否被删除不能通过名称去判断，暂时改为由后端去判断
  d34d19cb91a1529ea2c6423fdf1486c5ac99f6f2 | wangchuan |1 |css/your_style.css |     样式修改
  369d7640d2c5efde716691e6b70f6e485dfde4df | zagger |1 |views/vdi/login.html |     去掉登录界面温馨提示
  b8ced109a91ccc3df2f2b53bcad50e963f950aa9 | zagger |2 |css/your_style.css; views/vdi/help/deploy.html |     快速部署 袁阳需求强行要修改这里的按钮样式
  f54d0cc1245d03a449004eba93c673e7c1ee856b | zagger |1 |ngconsole-webpack-plugin.js |     临时解决读取不了翻译代码问题
  8da36ac6f12540fcd590b896d66c62e51414a0d9 | wangchuan |1 |views/vdi/resource/storage/disk.html |     产品要求：去掉裂脑时间
  b70bd36764a52004cef69c84242c798da846dbf4 | wangchuan |0 | |     build
  19fa6f9ff36e3ca4ddf7ccf59703f8a870bf42ba | zhangyao |1 |1f02b0b66 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  1f02b0b6605fcc802675e8eb611ef1c51d9dc3e2 | zhangyao |1 |views/vdi/desktop/scene.html |     添加 title
  58d6c9b6cffcf64f3b509a2662f0880f890511eb | wangchuan |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     设置终端
  a93e362cd8b0806b8f154439add9dd6df2612c50 | wangchuan |2 |js/vdi/security/client/controller.security.client.js; views/vdi/dialog/security/client/add_edit_security_client.html |     终端安全：新增编辑
  bcaccc4c059ff0af17ab0fa2b9b457c9039e92d4 | 0obuwawao0 |1 |013c95b57 |     voi打包准备
  013c95b57d6524f1c15152b9d03a887c6cd83c5c | 0obuwawao0 |2 |js/voi/desktop/controller.personal.js; js/voi/voi.js |     修改个人桌面下拉框
  758cb5b0bb125109c7f609abd6cd5ee34c618f09 | wangchuan |1 |fc02f9f35 |     Merge branch '5.1.4-vpc' into 5.2.0-uos
  9db06542877601cd3f135fb3830dd7e9790e3b79 | wangchuan |1 |08b740bbc |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  fc02f9f352c3f93ac71497d7875d6ccf3912890a | zagger |1 |js/vdi/menus.js |     隐藏网盘功能
  08b740bbc5c42e91792241d2533853f68e165f01 | zagger |0 | |     build for verify
  5af22c3d9c73ef20b7e080921d579d0de91b0b86 | zagger |1 |js/vdi/scheduler/disk.controller.js |     初始化网盘分页页码
  e227588b7438a8d6e03e0824debd48514fa385f7 | zagger |2 |js/vdi/scheduler/disk.controller.js; views/vdi/scheduler/disk.html |     处理清空页码数量所导致的bug
  2c6a7b9a8cb02a37c43c3e253dea69ba0db74f31 | zagger |1 |views/vdi/dialog/desktop/personal_alter.html |     个人桌面桌面修改始终disabled掉镜像分层复选框空间
  22c57fc4ebba0cb252e4030af77b7746dc1ab067 | wangchuan |1 |js/vdi/init.js |     杨燕思要求：初始化时查不到时间就一直查
  0a4b368e06ad1169c7a48f907208f2bab40856fb | wangchuan |1 |js/vdi/summary/controllers.js |     概览修改
  ca08f225df88922e2de3b584db267f9eab5d2803 | zagger |1 |35c4ff5e0 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  35c4ff5e039e0cc9785fb7613d1395cd6efd63fc | zagger |1 |views/vdi/dialog/scheduler/disk_show_detail.html |     网盘个人信息详情显示bug
  7a7e162b8afd8bfa4ed1283bed7efe9bec67f24f | 0obuwawao0 |3 |js/vdi/spice.js; js/voi/desktop/controller.personal.js; spice.html |     在编辑模板界面加入载入打印机驱动
  e8d7d473730e9e8015ef82365b83ed579605f784 | 0obuwawao0 |2 |js/voi/desktop/controller.personal.js; js/voi/voi.js |     修改个人桌面下拉框
  97855cfc9cdca01d6f40a686da6d2bc74b5c7db1 | zagger |2 |js/vdi/desktop/personal.js; views/vdi/dialog/desktop/personal_alter.html |     去掉镜像分层代码
  801de889460b9ac833e19e2068206b2b9d0d1812 | wangchuan |2 |js/vdi/security/client/controller.security.client.js; views/vdi/dialog/security/client/manage_security_client.html |     终端安全：管理终端列表过滤bug
  5875ac500e8a4c0c920600ec035fec93b41f567a | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     磁盘是否可以替换逻辑更新
  67a3badd78631b3ab5cefcf731544128301fbc39 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     产品要求:副本集只剩一个磁盘，不显示替换按钮
  5e7e60108e11416d55689a3090ac1a61071039cd | wangchuan |0 | |     build
  b36ef144bc73d375d00cf2ff3d99ec97f5c2ce2a | wangchuan |1 |314df0010 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  a2abf17d710145abec6d07b40f6247408e9b6237 | wangchuan |2 |js/vdi/system/system-logo-settings.js; views/vdi/system/set-general.html |     仲裁IP始终显示
  314df00108d49517d2cc684e1f21cd2cdce9065f | zagger |1 |js/vdoi/main.js |     dms返回的路径去掉/
  5428e27ff78f3d346b78b2d4baddd9a6f914e0a5 | zagger |0 | |     build
  a7f3d41ef090b834c2b6ac3cbb7a780aeab7037b | zagger |1 |js/vdi/scheduler/disk.controller.js |     加上排序参数
  e133cca86cefb93eebd040b8b48f4429d755e6fe | zagger |0 | |     build
  f7e29a08b614abfbc1e546a6230071c058dc5a3d | zagger |2 |js/vdoi/main.js; views/vdi/app-header.html |     dms加上新接口来返回跳转地址
  0be5a7e295046301b5502799d26baafc336b380a | zagger |1 |js/vdi/scheduler/disk.controller.js |     网盘加注释+加上一个固定项
  832cede8c774eeeb0897cdea04db269cc0dc9b4d | wangchuan |1 |js/vdi/resource/storage/controllers.js |     IO时延echarts
  6960a6ed1d3136b0ae4d421897269d9b5022e67e | wangchuan |1 |js/vdi/summary/common.js |     bug修改
  adb3ad84e5ff66c9c09a31ff3ebef6f0fcadf405 | zagger |1 |js/vdi/vdi.js |     去掉无用代码
  4610912ef77b09650c69dd2f671c033340c89fca | zagger |0 | |     build for verify
  977991aca032814a6a3cb8bccaa83cac6edb93bb | zagger |1 |js/vdi/scheduler/disk.controller.js |     分页输入框清空时，如何获取分页
  c6a3044c016916a4f35663abb9e4d191da65e1fb | zagger |0 | |     build for verify
  ceae6a2f8b66a15e794cfaf2c9b203a42f2a4323 | zagger |3 |js/vdi/vdi.js; views/vdi/scheduler/disk.html; views/vdi/user/admin.html |     bugs
  db394c1104f62c2cc5df47bf05fe0b3839c37bb2 | zagger |1 |views/vdi/dialog/scheduler/disk_show_detail.html |     网盘-uaa管理帐号详情部门显示问题
  fb3c63cb79e083891e7431cfc025174b99da311e | zagger |1 |js/vdi/scheduler/disk.controller.js |     build for verify
  b87e0aac9849c97e8378bf8738cfb9e140670ad6 | wangchuan |0 | |     build
  28f6bf045189ec5dda65272181173cc6b145f0ba | wangchuan |1 |89e048828 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  89e0488280bd9a0f29006d231fcf8d9a27cf9a15 | zagger |1 |9b6563e50 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  9b6563e504ff24ab8ccf3580ee521c4f982ef120 | zagger |4 |css/your_style.css; js/vdi/scheduler/disk.controller.js; views/vdi/template/teach.html; views/vdi/user/admin.html |     build for verify
  b3d296a70dc78ae9e8859544b542ace7508f2812 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求:有一个节点异常,则所有节点显示异常...
  4d65928a7e4319ff0872b9689c2f80c1b28aedaf | wangchuan |1 |js/vdi/resource/storage/controllers.js |     产品要求io时延显示节点IP+磁盘名称
  c780a0d0a61365c3ade1b1b0e401e63d17f1d82c | 0obuwawao0 |2 |js/voi/terminal/controller.terminal.js; views/voi/dialog/terminal/printer_bind.html |     修改打印机绑定提示
  7fece634d1a43bf3b63b6a8b568f6a61b4de84ee | zhangyao |1 |189259d85 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  189259d85163782ed86eff396d1e873210f11582 | zhangyao |2 |js/vdi/desktop/styles.css; views/vdi/help/deploy.html |     修复bug
  189441ea6832cda5ad11e1c8991af5d3de53e794 | wangchuan |2 |js/vdi/resource/pool/controllers.js; views/vdi/dialog/resource/pool/config_storage.html |     录屏存储不支持设置为分布式卷组
  d92ff77fbc617940eb4232edb7634f004e793a03 | zagger |0 | |     build for5
  99ad44eba546734159592b51975ba7954fc52136 | zagger |2 |js/vdi/scheduler/disk.controller.js; js/vdi/vdi.js |     build for5
  4ecdbc6a6eac31382f3c399d58549ab1fee43e9c | zagger |2 |js/vdi/scheduler/disk.controller.js; js/vdi/vdi.js |     build for4
  15d93f22e74395c892335381114a724d495549ca | zagger |3 |js/vdi/scheduler/disk.controller.js; js/vdi/template/controller.teach.js; js/vdi/vdi.js |     build for3
  d60fbb57e6977bd22addc40d36e44ae8831e310d | zagger |1 |js/vdi/scheduler/disk.controller.js |     build for2
  20576accc59361882605a973d38e4bdbb76e8f2e | zagger |2 |js/vdi/scheduler/disk.controller.js; views/vdi/scheduler/disk.html |     build for
  0cffbb00537bc79f0d3015ef0e6d836892607506 | zagger |1 |b4b18e687 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b4b18e687f90946ffc2e4af9ea63427500b4ec68 | zagger |1 |js/vdi/scheduler/disk.controller.js |     轮询改为了timeout，随之要去掉abort逻辑
  3a4e6f23b950ba4aaa1be7ff4a4d0a19091f8a3f | zhangyao |1 |2537b263c |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2537b263cc249c4f5235e22e176aa33b8e86dfeb | zhangyao |1 |js/vdi/security/style.css |     详情保持一致
  8bd735e37373bbb846ec452b46c485d70857ad59 | 0obuwawao0 |0 | |     voi打印机自测
  507a7e7404e6eec9f75171fc20a4e68166fd60a1 | 0obuwawao0 |7 |js/voi/terminal/controller.terminal.js; js/voi/voi.js; views/voi/dialog/hardware/upload_printer.html; views/voi/dialog/terminal/printer_bind.html; views/voi/dialog/terminal/printer_bind_detail.html; views/voi/hardware/printer.html; views/voi/terminal/client.html |     完成打印机解绑，查看打印机详细
  64e98a8313e62c84ba7e8acc5f9e1af7df41a0ad | wangchuan |1 |views/vdi/resource/storage/disk.html |     分布式存储：监控图表重绘前清空
  9341a06a6f38acf5a6a725907e9dec7c04de99ad | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式存储：监控图表重绘前清空
  11e6a5d0a413696d0889f8f10adf8234c75f5f6b | wangchuan |1 |js/vdi/summary/common.js |     扩展uiEcharts
  fa9bca39ec404d66f1a137b12def7b2c62bf31b0 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式存储：监控echarts优化
  719965eae89b56e47e27b9645d5509e9863a498a | zhangyao |1 |de0426be9 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  de0426be935dc0b4413088305d6df2a0761b9fe6 | zhangyao |1 |js/vdi/help/quick-deploy.js |     fix: #16225
  8318d1949c46e57527a110418ebb5b5c7e4f169e | wangchuan |1 |views/vdi/dialog/security/client/manage_security_client.html |     管理终端：样式修改
  2998bbc179e304b3411f395367ca66b6a063cabe | wangchuan |1 |img/clientLogo/vpc-fusion_zh-hans.png |     更改管理台vdi客户端默认logo
  534af046b29143bc4cb405645769da350fdfcadf | 0obuwawao0 |1 |js/voi/hardware/controller.printer.js |     添加打印机控制器
  aa042fe31518eab2b8527d509221b8106e45a011 | wangchuan |1 |js/vdi/summary/common.js |     恢复历史文件，option变化时去掉更新echarts前的clear
  0ea1287196ad2ae7765065b46d5266f83d051a9c | 0obuwawao0 |9 |js/vdi/system/index.js; js/vdoi/system.js; js/voi/voi.js; views/vdi/system/hardware_tab.html; views/voi/dialog/hardware/edit_printer.html; views/voi/dialog/hardware/upload_printer.html; views/voi/dialog/terminal/printer_bind.html; views/voi/dialog/terminal/printer_bind_detail.html; views/voi/hardware/printer.html |     加入打印机功能
  33cfc788769284425b32a726140732324891ae53 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式存储：监控echarts横纵坐标自动适配
  9663612347a67169f12d47206015f777ee8923a5 | 0obuwawao0 |0 | |     解决voi bug测试
  2de6b13c41dbc8d374f716e453612facd477ace1 | 0obuwawao0 |2 |js/idv/terminal/controller.terminal.js; js/voi/terminal/controller.terminal.js |     解决终端online状态获取bug
  b2ef88ee2a1515564e739738dee24b899f2df278 | zhangyao |1 |08950dba3 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  08950dba35c3e31cd90ed88b846b85f8bb191386 | zhangyao |3 |js/vdi/help/system-upgrade.js; js/vdi/help/upgrade-server-modal.css; views/vdi/help/upgrade-tab-vdiclient.html |     fix: #16206
  099c1433979a3f0715ca1d80114514bed8a86e72 | zagger |0 | |     更新获取管理帐号假数据
  9dfa7ed147c5244eae9a41108d63dbb55a77f95e | zagger |2 |js/vdi/desktop/personal.js; views/vdi/dialog/desktop/personal_alter.html |     个人桌面 修改桌面-帐号树结构-去掉uaa
  abddbbe20e5f647daa5c139d26f99444c0832358 | wangchuan |2 |views/vdi/terminal/client.html; views/vdi/terminal/schoolroom.html |     idv区域管理、终端管理样式
  74db64d6a5382ecc7d64101fa0ba82ab0477c243 | wangchuan |1 |views/vdi/dialog/security/client/add_edit_security_client.html |     终端安全：新增编辑样式
  9d93801e86be2670c1d4cbbbd1b69a87cc47ea69 | 0obuwawao0 |1 |js/voi/desktop/controller.personal.js |     修改voi个人桌面编辑时下拉树结构
  846a3cea4ed767b36de1419d0bba91a616dcaa3a | zagger |1 |js/vdi/desktop/personal.js |     //胡海曰 镜像分层开启需要过滤boot_index为1的磁盘
  019094256e56092a8d6f791efa7dd458b2366797 | zagger |1 |js/vdi/monitor/common.js |     highchart图受到左侧菜单栏动态宽度的影响
  fb0d8e1f12510377bb61946997cd222a8901eb1c | zagger |3 |js/vdi/system/system-settings.js; js/vdi/user/common.js; views/vdi/system/set-general.html |     其他小问题
  ac449624f2de6568e394a40e6b92250025daa591 | zagger |2 |js/vdi/auth/controllers.js; js/vdi/utils/user.js |     锟哥bug获取token的两个地方分别加上参数
  fbdfedf14a69c59ce984fa2ed76bfb1f12a879a4 | wangchuan |3 |js/vdi/desktop/personal.js; js/vdi/terminal/controller.terminal.js; views/vdi/desktop/personal.html |     跳转到终端
  7f2f1b41b9070f05cd0d1bfbc5116bf5718c3734 | wangchuan |1 |js/vdi/template/controller.teach.js |     公共模板-镜像管理：添加分布式存储tab
  80291bd7c754ec50622a383572554e2e561aea3f | zagger |1 |views/vdi/system/set-general.html |     统一配置邮箱服务器验证邮箱规则
  411f534afe4b3bffafcd41a0b173e30a1b251b38 | zagger |1 |js/vdi/system/system-settings.js |     bug#16131 【通用设置】必现-配置邮箱服务器处输入邮箱信息后点击取消，输入框报红
  6df7725ea932ea25b25e40aa24b6f4a7485e346e | wangchuan |0 | |     build
  dcb9b3517c66fc1bba6f2e9c4cfee6db2ef071d2 | wangchuan |1 |74a0e5b1a |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  74a0e5b1a8b0331134dfd09cd18be5e2b5cf6647 | zhangyao |3 |js/vdi/template/common.js; views/vdi/security/desktop.html; views/vdi/security/group.html |     修复列展示问题
  051f0e991b068416ea3241b6c9475ca6a3c78c56 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     分布式存储：对接监控新数据
  d0a0fa5bad0552920fefc798888ab26e2b140496 | zhangyao |1 |a87755e96 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a87755e96dbfb71fe11665ea8ed3a8c548f5fc77 | zhangyao |0 | |     idv 打包
  1d19d4566811a719a881adf02ba4e4fd048cac89 | wangchuan |1 |views/vdi/dialog/resource/storage/new_storage.html |     研发讨论，去掉添加存储处的录屏存储下拉选项
  1e0d9a43de465fcc5b330f67a712d535e37d1622 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     挑选磁盘优化
  e925b4aa08d0bf3719ab02922e6b593c325b2feb | wangchuan |1 |views/vdi/dialog/resource/storage/add_bak_disk.html |     分布式存储：添加热备盘提示
  d0faedaaa87f299783a3230cab9e5f834cfde03c | zagger |2 |js/vdi/template/controller.teach.js; js/vdi/user/common.js |     16118 【vdi-公共模板】vdi公共模板执行注册模板，指定区域里面有voi和idv的教室信息 16124 【管理账号-权限设置】权限设置中没有显示voi和idv下面的子区域
  fc8fc48caf23ee4236958fcb87c7d88648c8d0e2 | zagger |1 |1aa54a16e |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  1aa54a16edf547669be0c881720ba1d1c3189bce | zagger |1 |views/vdi/common/select-multiple-dom.html |     去掉管理范围的userCommon-tree样式类
  4828ab5efaf0f649f39a2869a356ae1cb4148149 | wangchuan |0 | |     build
  1b0b6d766eb109420731da393e71acee1447047b | wangchuan |1 |ed2a478ae |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  ed2a478ae0466b9c09dd4017a2d2ab960da0c391 | wangchuan |0 | |     VDI客户端包
  67444c0fb5d23cdd884aae12feb3b2c09ecefd30 | wangchuan |1 |js/vdi/desktop/common.js |     桌面-高级：存储设置默认选第一个不为disabled的
  f458f2aef613fc89fbc6b42ad449cbe587bdb2df | wangchuan |3 |views/vdi/dialog/security/client/apply_security_client.html; views/vdi/dialog/terminal/terminal_schoolroom_add.html; views/vdi/dialog/terminal/terminal_schoolroom_edit.html |     应用终端、vdi新增编辑区域：区域树鼠标悬浮提示
  4ca55b348ca93772c54b205c24cef780a0ab06f2 | wangchuan |0 | |     idv包
  ef66872df6db0829f59ecf25882e2a7320eda47b | wangchuan |1 |d0b96c9dc |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  bb99b9eeb1f3a2b31dcf2426b7e41d3be634e0a8 | wangchuan |1 |views/vdi/terminal/client.html |     vdi终端：去掉查看桌面
  0aaff8418aebefe10f8c55436afa3fc0a710d7fe | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式：监控新数据
  9c1859dbff05b935824dbb5c2276094dd294845c | wangchuan |3 |js/vdi/vdi.js; views/vdi/dialog/desktop/host_config.html; views/vdi/dialog/resource/pool/config_storage.html |     select禁用选项
  c517a5e089f55c5f79c1b8131e485e7be03ab213 | wangchuan |1 |views/vdi/dialog/desktop/host_config.html |     恢复历史文件
  d0b96c9dcc1a242a3ac538fa7c02213c73a38623 | zagger |1 |adf743e04 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  adf743e0408e471d77e0d9b1b30d32aa822c99ca | zagger |1 |js/vdi/help/controllers.js |     授权激活+关于=》vpc激活标识+分布式激活标识引起的改变
  a9d05f135f9f015dbce14009e46ae78fbfb0aa3c | wangchuan |1 |views/vdi/dialog/resource/pool/config_storage.html |     恢复历史文件
  07632032bb04fe43513e197d721ae975cec0bb5c | zhangyao |1 |spice.html |     放开上传文件功能
  64c249dafacd286862f2c4984e0639e9fd3c1513 | 0obuwawao0 |7 |js/voi/terminal/controller.schoolroom.js; views/idv/desktop/scene.html; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/voi/desktop/scene.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     套用vdi树样式
  c2fe379c41e33dfa375fd72cfd3828cf77962c27 | wangchuan |1 |views/vdi/resource/storage/disk.html |     被替换磁盘tip
  019752ace74e8c52ce979a4e22f0e318669ab4ea | zagger |3 |js/vdi/scheduler/disk.controller.js; views/vdi/scheduler/disk.html; views/vdi/user/uaa.html |     1.网盘新增和解绑服务器端口号默认改为443 2.涉及到的树结构名称加上title显示全部名称
  292aabb82da7934a36f63118a50592b348c1dd54 | zagger |1 |d525c2667 |     解决冲突
  f37150e19c7e82e9edafdb76ffb2e84b6c1fd0b7 | wangchuan |1 |ffc57030b |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  290c4d3e17718f258b06c892f48521ab3405bed3 | wangchuan |1 |css/your_style.css |     所有树，横向超出隐藏
  d525c2667a266e182a91c4db7b17eac80a5ae04c | zagger |1 |views/vdi/scheduler/disk.html |     网盘这里部门- 判断node.user_num != null就显示帐号数量
  ffc57030b19f7af2d5fca79558452c446b74f817 | wangchuan |0 | |     build
  1c5a9662afe11d16b683c9fa90b079b2888053bd | wangchuan |1 |b97d52297 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  c7dfec2028a2fe7c3f4dff1d4e5af2d3db412b05 | wangchuan |2 |views/vdi/terminal/client.html; views/vdi/terminal/schoolroom.html |     idv区域管理、终端管理：树结构超出隐藏
  ba6e551282bc7903eace278af575966159aa18b3 | wangchuan |1 |css/your_style.css |     超出显示...的树
  b97d522976b15799e22f5faa9b050b4a94d73bdd | 0obuwawao0 |2 |js/idv/system/controller.system.js; js/voi/system/controller.system.js |     voi打包自测
  f6e7ef1166eb3fb56c7183f13fd5309f3800fc3a | wangchuan |1 |js/vdi/vdi.js |     IP范围校验bug
  ce792672c561666d6fb99dc660cbb00e5df89608 | wangchuan |1 |views/vdi/dialog/resource/storage/replace-disk-dialog.html |     替换磁盘优化
  1edb80bfe9c7bdf6cf54fd23460a95809b3d5c70 | wangchuan |1 |0b685abad |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  0b685abad88ac3265a44abddb3cc07c7d956d6c9 | 0obuwawao0 |7 |js/idv/desktop/controller.scene.js; js/idv/terminal/controller.classes.js; js/voi/desktop/controller.scene.js; js/voi/system/controller.system.js; js/voi/terminal/controller.schoolroom.js; views/idv/desktop/scene.html; views/voi/dialog/terminal/pool_add_edit.html |     解决idv场景排序问题
  a12280a6981c9ec774341e17caac17cb3b9398a2 | 0obuwawao0 |1 |5c9e17fa3 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  db049969ed7b5d94751c9b5b15d7d58056084ea3 | wangchuan |1 |js/vdi/summary/common.js |     bug
  e7e283c077eccd5a33c36c3cef1caf8e2e3e9c91 | wangchuan |2 |js/vdi/monitor/policy.js; views/vdi/dialog/monitor/config.html |     热备盘替换告警
  c65474b9a5d61bfd1d92cd4a3601eae53aea2af9 | zagger |1 |5caa9a62e |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5caa9a62ed1b55c8ac3f3bc84995c594bc98e379 | zagger |0 | |     build for verify
  6fde250ff99006bfab0cda2e72dc58211f065794 | wangchuan |1 |f59dcaa54 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  5790a5c1ff4b078406f63bf3321085300fba9110 | wangchuan |6 |js/vdi/bootstrap.js; js/vdi/desktop/common.js; js/vdi/monitor/policy.js; js/vdi/resource/pool/controllers.js; js/vdi/system/system-logo-settings.js; js/vdi/template/controller.person.js |     分布式存储授权
  f022c1f2b5128c8905475de8140dcc8a146cc2f8 | wangchuan |2 |js/vdi/help/controllers.js; views/vdi/help/activeAuth.html |     激活授权：分布式授权展示
  f59dcaa54bee9cc77a113bea2bcba86e2540364f | zagger |1 |js/vdi/system/system-logo-settings.js |     去掉无用代码
  798bf9d6fdf5d12f894af1cba0ba8bc2f9c01993 | wangchuan |1 |js/vdi/bootstrap.js |     分布式授权
  5c9e17fa351db3c12475c82fa35b3f23c14aecd6 | 0obuwawao0 |1 |661aff58b |     合并修改
  661aff58b2c02260b27cab1062501ed25035ae41 | weicong |1 |9f427e275 |     正在解决idv终端场景排序
  61672af1cad0853dbc566300a22af9a7415e0287 | zagger |1 |51b9b7db8 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  51b9b7db889a69f47009a83366ed421b886e78a5 | zagger |2 |js/vdi/system/system-logo-settings.js; views/vdi/system/set-vdi.html |     vdi-logo上传等验证尺寸时机问题解决
  99225388b00f209e0841c35c00862f1f42c4d803 | wangchuan |1 |5cd634a6d |     合并代码
  2317723a7063340f1d67b426e233bfe074958563 | wangchuan |5 |js/vdi/desktop/common.js; js/vdi/resource/pool/controllers.js; js/vdi/resource/storage/controllers.js; views/vdi/dialog/desktop/host_config.html; views/vdi/dialog/resource/pool/config_storage.html |     分布式:授权到期
  41954272fb72d19c0e36f74084ee92205e9c5b23 | wangchuan |1 |views/vdi/dialog/resource/storage/replace-disk-dialog.html |     替换磁盘：无磁盘提示
  c1b0eb85ec06464b7f4cfcdf3d1670819355ca49 | wangchuan |2 |personal_login/js/rules.js; personal_login/views/user-form.html |     web桌面：用户名最短2字符，最长不限制
  5cd634a6d70a8a471e1d9cc7bd1cced93581df6f | zhangyao |1 |js/vdi/desktop/personal.js |     个人桌面过滤模板字段修改
  f6f87a4f489882d5bd18ee53c1b362ad99b75a90 | wangchuan |1 |23f064176 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  384e7825cf036b4da73ed9aa296678720fd2d1d0 | wangchuan |2 |js/vdi/resource/storage/controllers.js; js/vdi/utils/echarts.js |     分布式存储：监控echarts修改
  9f427e275fe0582744ff8b51d572071b1756b1fd | weicong |4 |js/idv/desktop/controller.scene.js; js/voi/terminal/controller.schoolroom.js; views/idv/desktop/scene.html; views/voi/dialog/terminal/pool_add_edit.html |     正在解决idv终端界面上的一些问题
  b40183aaefa048e3fdfa334f6931e20629f69960 | wangchuan |1 |js/vdi/summary/common.js |     echarts指令bug
  23f0641761dfa4e962dcdbc1e241961592903cb1 | zagger |1 |js/vdi/menus.js |     菜单icon更换
  e1ce15d63d8b9462b47e4ff93261d70380f3dfe8 | zagger |1 |views/vdi/user/uaa.html |     用户帐号-部门-icon换新
  cb7a932a2eb8d7449f84cbc74b0e4c582be8698d | wangchuan |1 |a5d6a2471 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  1ed5ee6e933008f711afc755aa6963b7e6b4a6d5 | wangchuan |3 |views/idv/terminal/classes.html; views/vdi/terminal/schoolroom.html; views/voi/terminal/schoolroom.html |     区域管理：更换图标
  eaf503902db902618b542d7d1a344ab3b27bcd05 | wangchuan |5 |css/font-jj.css; fonts/icomoon.eot; fonts/icomoon.svg; fonts/icomoon.ttf; fonts/icomoon.woff |     字体包更新
  a5d6a247157919f419a18c06c3baab67b5a42f81 | 0obuwawao0 |3 |js/idv/terminal/controller.terminal.js; js/voi/terminal/controller.tab.terminal.js; js/voi/terminal/controller.terminal.js |     voi自测
  aa8114bd96e3ad9e7f13ae7a993c4acb71186c44 | zagger |1 |afba3e677 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  afba3e6771e0d8c1b4d0b653caa9202ccc1758ec | zagger |3 |js/vdi/scheduler/disk.controller.js; views/vdi/dialog/desktop/personal_new.html; views/vdi/scheduler/disk.html |     个人桌面切换硬件配置和是否开启镜像分层-交替显示隐藏分层空间
  f6bf8be8016368adc0b811171a9a706d5399cbc4 | 0obuwawao0 |1 |81bd62297 |     优化idv终端代码
  54a079f3e405347bad81c3315f6db6164513f8f4 | wangchuan |1 |4b2e6fefb |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  5d104dbd2b13cec46e517991fbf292dd92e7db4e | wangchuan |3 |js/vdi/resource/storage/controllers.js; views/vdi/dialog/resource/storage/replace-disk-dialog.html; views/vdi/resource/storage/disk.html |     分布式存储：磁盘替换联调
  4ae04d202c4e4ab74859a3ca386ae909dd409624 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     分布式存储监控联调
  4b2e6fefbc67bd469dacec8c39c8ffb76c26ea91 | zagger |1 |views/vdi/desktop/personal.html |     个人桌面 镜像分层开启的 桌面 无法另存为模板
  05b8f8278cd2ffe7b21424bef532586b76c526bc | zagger |1 |css/your_style.css |     表格 去掉斑马色
  643c553423246473a77c991abd4e7e2a8b0bad0a | zagger |1 |css/your_style.css |     瓦片按钮颜色问题修复
  d7145ce9d1db30e0a0771f2c4e2f2b541bcb944e | zagger |2 |js/vdi/template/controller.teach.js; js/vdi/user/admin-user.js |     获取所有区域的传参方式
  81bd62297bdace826865db794f5e596698732191 | 0obuwawao0 |1 |5a20fe572 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5a20fe57296db3fcb463c3fa07d236e564cd080c | weicong |2 |js/voi/dashboard/controller.dashboard.js; views/voi/dashboard/dashboard.html |     修改dash界面
  bd78b2db3f6b0bd8e180e146ea70824566bc68b1 | zagger |0 | |     build
  34827bc967830a13aaacf336d223dbb1dcefc4c7 | 0obuwawao0 |1 |cfaaf729d |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  cfaaf729ddacf3e71287e7b96cc70814fe2dfeea | 0obuwawao0 |2 |js/voi/terminal/controller.terminal.js; views/voi/dialog/desktop/add_personal.html |     解决个人桌面上判断镜像分层
  c08df4d0d5ecb6c0388c681800efd849a818e010 | zhangyao |1 |views/vdi/security/group.html |     其它协议 => 所有协议
  002c6fc92d0d84039a77e305ea1e72126a90eb8d | wangchuan |1 |2a631c389 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  bd869ad7693d1f3b0905907f5a9071bb4a5f0125 | wangchuan |2 |js/vdi/resource/pool/controllers.js; views/vdi/dialog/resource/pool/config_storage.html |     配置存储
  2a631c38905326933712d010888147ed28040ad1 | 0obuwawao0 |1 |js/voi/terminal/controller.terminal.js |     voi终端修改代码格式化
  b66f044c9d7ed8cd03897c19f07a3abf9d6a6938 | wangchuan |1 |js/vdi/resource/pool/controllers.js |     录屏存储位置优化
  50e8588973a37e5de3ef1d8bb6cc7aa160054669 | 0obuwawao0 |1 |js/idv/terminal/controller.classes.js |     修改idv区域编辑ip
  73ebb12bf048970ba4657bfd514cc92fdf1a7728 | 0obuwawao0 |2 |js/voi/terminal/controller.schoolroom.js; views/voi/dialog/terminal/pool_add_edit.html |     修改VOI区域IP终端
  b4b259b2354119919404e2d7825742608091ea52 | wangchuan |1 |bebd5702d |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  7dc3abf6aef80f0f26d0fe4341e624fd6aae37bd | wangchuan |2 |js/vdi/resource/pool/controllers.js; views/vdi/dialog/resource/pool/config_storage.html |     资源池-配置存储
  bebd5702dee6c00092314ae07d004f8232084074 | wangchuan |1 |1172595c3 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  7aeb8351277093828df2315bd7ff62e84986c8d0 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     卷组详情饼图优化
  f3f7c0e3c8ca11766f38800df647dfb8ad64caa9 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     自动修复策略优化
  1172595c307bbe7f0e2a9eaee319f317fd41a1f9 | zagger |1 |85a0a0bde |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  85a0a0bded9850d05d88ce97856c7d00ed524a4f | zagger |7 |css/your_style.css; js/vdi/template/controller.teach.js; js/vdoi/template.js; views/vdi/dialog/template/template_teach_add.html; views/vdi/dialog/template/template_teach_edit.html; views/vdi/dialog/template/template_teach_register.html; views/vdi/dialog/template/template_teach_save_as.html |     vdi模板区域范围选择修改
  6cacacc402011229e30c1faadce87ba424dd09db | wangchuan |1 |746b9de97 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  4c876c024950dfe7c5ebf4fff6f637b564cd7356 | wangchuan |1 |views/vdi/dialog/resource/storage/config_repair.html |     自动修复策略弹窗
  746b9de97d6d543fe84ee3a0468b72173d1c755f | wangchuan |1 |7b554ab39 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  50b025ff296ca642f70fb974d43d62a6cdf81247 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/dialog/resource/storage/config-strategy-dialog.html |     自动修复策略联调
  7b554ab398b0ec1724abae9ad1eb1aa7a7284d94 | zhangyao |1 |js/vdi/config/http.js |     spice 页面长时间未访问管理台退出优化
  495fd4f5f0b73e6572e1cff1f01dd4176749f240 | zhangyao |4 |js/vdi/system/system-log.js; views/vdi/system/admin-log.html; views/vdi/system/backup-log.html; views/vdi/system/user-log.html |     fix: #15818
  b59de294d62725c686106e5135b6cb906c541657 | zhangyao |1 |js/vdi/split.js |     裂脑修复接口发送到主控
  95d889d382e8534935ebd2d61341ba0aa0d7a981 | zhangyao |1 |js/vdi/resource/console/controllers.js |     切换主备控时请求发给主控
  1fad0b16d3dece20a8db0cb30e3333d5e346a4bd | wangchuan |0 | |     build
  db581064c0b63ba25bd2401b9fcae739e8be47af | 0obuwawao0 |1 |js/voi/terminal/controller.terminal.js |     解决voi的一些bug
  e350a9c18fbe3172de91488a65894755bf3b98b8 | zagger |3 |css/your_style.css; views/idv/system/set-idv.html; views/voi/system/set-voi.html |     voi,idv-系统设置页面空间禁用背景样式
  afaefd0dbc3006778249818af929da28cf863599 | zagger |1 |327b01dea |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  327b01deac8d5af9f2fe6a0340ccee7fae0bc58b | zagger |2 |js/vdi/help/controllers.js; views/vdi/help/activeAuth.html |     about+授权激活界面
  243fd59152d50e6773fa809245779232b23b8afe | wangchuan |1 |03c1cdf7a |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  4e4beca5616f3550cfc00201b04d28adbe06b712 | wangchuan |9 |js/vdi/bootstrap.js; js/vdi/monitor/policy.js; js/vdi/resource/storage/controllers.js; js/vdi/system/system-logo-settings.js; js/vdi/template/controller.person.js; views/vdi/dialog/monitor/config.html; views/vdi/dialog/template/template_imgManage.html; views/vdi/resource/storage/storage.html; views/vdi/system/set-general.html |     【分布式存储】未激活/授权到期
  edf9ea6a3abf08f08124a9cea80276469588fbb5 | wangchuan |1 |js/vdi/security/system/controller.security.system.js |     系统安全：修改删除规则弹窗标题
  03c1cdf7a38f815990535cf551108a464f82e4c2 | zhangyao |1 |d8ed96b50 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  d8ed96b5044a148fe2960df756bea8bf40920038 | zhangyao |2 |js/idv/desktop/controller.scene.js; views/idv/dialog/desktop/add_scene.html |     修复IDV新增场景无法显示公共模板的问题
  6bcb30c57c33aed576cdaf72d472ee736d58180a | wangchuan |1 |a368787bb |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  d25c8a72b7c8fcc2482990376b0dcfc1e84b097c | wangchuan |1 |js/vdi/summary/controllers.js |     概要修改
  a368787bbb4b12b454b3df99c3856686dfe3fad1 | zhangyao |1 |18f3cbf1f |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  18f3cbf1fbe10b748728acdc905d8f156bc61c08 | zhangyao |1 |views/vdi/desktop/personal.html |     屏蔽移动至入口
  829a0380d7106bf31e3eb97e07c400c7195ab131 | wangchuan |1 |b4297d8aa |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  4c3f2004b41b46333818ff65cfbc3e6cbc4d8a0b | wangchuan |2 |js/idv/terminal/controller.terminal.js; js/vdi/terminal/controller.terminal.js |     vdi，idv终端管理bug
  125a4427c5030eaae9c1df2d9c45c4cb876d9666 | wangchuan |5 |css/your_style.css; js/vdi/resource/storage/controllers.js; views/vdi/dialog/resource/storage/add_disk_group.html; views/vdi/dialog/resource/storage/replace-disk-dialog.html; views/vdi/resource/storage/disk.html |     替换磁盘
  b4297d8aaa73b625266075719c228ec2e96c5a86 | 0obuwawao0 |1 |views/voi/dialog/desktop/desktop_detail.html |     修改了桌面详细
  e25c38630355e65a7472e7863c2633fdc1ab5020 | 0obuwawao0 |1 |js/voi/voi.js |     voi打包测试
  772fd4b44d6e4cb9a6be09f02c9bab7f005ae561 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     删除分布式存储，始终刷新列表
  80e5170d6633c72b36f5f324d9b0bec2f41e9458 | wangchuan |0 | |     客户端包
  28f492f090ed33e545e61a04fec0bd58a554bc14 | wangchuan |0 | |     客户端包
  7d2c33aaec42fa95688d98694c18b9bca70347f3 | 0obuwawao0 |1 |views/idv/template/teach.html |     idv模板解决 注册模式下 不显示详细
  e4d2fd7364ec0d5ebb32340c8e83e58d99f17f91 | zagger |1 |views/vdi/system/set-general.html |     15804 【系统设置-配置认证服务器】端口号中输入小数，输入框没有标红提示
  4872d7abf1c5fa5df518ffc805c3dd33ea7e2111 | zagger |1 |views/vdi/template/teach.html |     教学模板 瓦片 判断darken还是primery 条件不一样 现改成一样
  beea7998f3abfb8a146178a7fee8ed5305c69801 | zagger |0 | |     build
  69329e46c2517b178aaa64de6c1b2a4471e45441 | zagger |1 |4297f9d5c |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  4297f9d5ccfed37f53bf221b8b9f8e9223df6721 | zagger |1 |js/vdi/desktop/personal.js |     镜像分层bug
  a49b3a93e9e38f6ed4bb9bebe38d6fec64c53007 | 0obuwawao0 |1 |views/voi/dialog/desktop/edit_personal.html |     voi修改镜像分层编辑时 也禁用对应的 系统还原属性
  a746435808f96397fa71b2a5c151aac8ae63cdf0 | wangchuan |4 |js/vdi/resource/storage/controllers.js; js/vdi/resource/storage/storage.css; views/vdi/dialog/resource/storage/config-strategy-dialog.html; views/vdi/resource/storage/disk.html |     去掉数据平衡-立即执行，配置自动修复策略，样式调整
  f417edff38f1ebf7c23604fdc383e6f163e5d63c | wangchuan |1 |235fd3b58 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  2f16f400c6ed3a47caa8a21d7307ff80a6cbebc2 | wangchuan |5 |img/icon-schoolroom.png; img/icon-terminal.png; js/vdi/summary/controllers.js; js/vdi/summary/summary.css; views/vdi/summary.html |     概要修改
  235fd3b58f03a3ca15e10ddd5a6d16b654b8c4d0 | wangchuan |1 |d0f645d38 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  5d6e2116c7b16046eaee4948abb75536bb870a8c | wangchuan |1 |js/vdi/terminal/controller.schoolroom.js |     VDI区域管理：新增编辑优化
  fe44329f8f7cd9451c118f467ec4126f378076bf | wangchuan |4 |js/idv/terminal/controller.classes.js; views/vdi/dialog/terminal/terminal_schoolroom_add.html; views/vdi/dialog/terminal/terminal_schoolroom_edit.html; views/voi/dialog/terminal/pool_add_edit.html |     VDI，IDV区域管理：IP范围校验
  45a31591456024fc74ce1fc56cdfe4288c90c7a8 | wangchuan |1 |js/vdi/vdi.js |     validateIpRange添加disabled支持
  5ca20b6a9cdf055b8fd3c80864872a4cdfd2cb7d | wangchuan |1 |css/your_style.css |     validateIpRange样式
  9017e907eb3ddcb7c4229597a2840c2fc6ca3db9 | wangchuan |1 |js/vdi/vdi.js |     辅助formatIp校验IP范围指令
  d0f645d386e28bde95ae5fee084b732364cce193 | zhangyao |0 | |     build
  594f3e678c18ecb4c6e24d59d0364acfb50d9963 | zhangyao |1 |js/vdi/desktop/common.js |     修复获取教室列表传参问题
  f562c7d944c6d2c3024069480710c8b6a2a88299 | wangchuan |0 | |     build
  ca648d1a0efd0b54d988ea566280a4cc367d18c2 | wangchuan |1 |e2388635d |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  e8bf3ffaa3b9c936283ef36c1ea071e01d2a6320 | wangchuan |1 |personal_login/js/webLogin.js |     web登录：bug
  e2388635d0f39e8ee5613aaf25ff5f7260977f41 | 0obuwawao0 |0 | |     voi 打包自测
  02fcfd689f223c385a78c0751adaadecef045977 | 0obuwawao0 |1 |6ac30b729 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  6ac30b72928859ecfff440b3cf1cf06201c13d8a | 0obuwawao0 |8 |css/your_style.css; js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/desktop/controller.scene.js; js/voi/terminal/controller.terminal.js; views/voi/desktop/scene.html; views/voi/dialog/desktop/desktop_detail.html; views/voi/dialog/desktop/download_video.html |     voi解决bug
  ab645023774a21c95d29595a304c0a8101866903 | wangchuan |1 |views/vdi/system/recycle/system_recycle.html |     回收站：无桌面时清空回收站按钮禁用
  eb3d6ea52daa6a5b655311a3afe7446251035639 | wangchuan |1 |views/vdi/dialog/system/recycle/deleteCompletely.html |     回收站：彻底删除提示信息标红
  93281bf24e10329e8e382c36f52352d01a6fd967 | zhangyao |1 |e6d5f0905 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  e6d5f0905200b3af3298b03f20ec30f2fcf24d1f | zhangyao |6 |js/vdi/resource/console/controllers.js; js/vdi/system/common.js; js/vdi/system/system-log.js; views/vdi/desktop/personal.html; views/vdi/system/admin-log.html; views/vdi/system/user-log.html |     修复禅道bugs
  37afb61e6ca9f8c50c901c672c3a51fc37de0860 | wangchuan |1 |js/vdi/system/recycle/controller.system.recycle.js |     回收站：编辑保留天数bug
  fddc2d143df73695e9096b1092512db7a7638820 | 0obuwawao0 |8 |js/voi/help/controller.deploy.js; js/voi/terminal/controller.terminal.js; views/idv/template/teach.html; views/idv/terminal/classes.html; views/voi/dialog/help/system_deploy_import_from_local.html; views/voi/help/deploy.html; views/voi/template/teach.html; views/voi/terminal/schoolroom.html |     修改voi快速部署本地导入机制
  e69551d93fc851bdc3e3a74f1e3aa29404c9b476 | wangchuan |2 |views/idv/terminal/client.html; views/vdi/terminal/client.html |     VDI,IDV:终端列表显示每页条数
  b20d172407ca066c48d0296002bd336e7e0bc932 | wangchuan |1 |js/vdi/terminal/controller.terminal.js |     需求变回去了。。恢复历史
  0571a3a9872ce97de407eeb2c50827e985fa5f75 | wangchuan |1 |views/vdi/dialog/terminal/terminal_calculateconfigureparameter_edit.html |     需求变回去了。。恢复历史文件
  749e66d8a94b1e59451a8a17acfd59679e595b53 | zagger |1 |css/your_style.css |     区域选中样式先恢复-后面想办法
  1394ca89ec4418ce69a8c894543ce71a81710aba | wangchuan |1 |js/vdi/terminal/controller.schoolroom.js |     产品要求，VDI第一个顶层节点视为默认节点
  9ac8ae28fc8c8ca97444b9dc7fb471b5884ddfee | zagger |1 |js/vdi/monitor/alarm.js |     15774 【告警信息】-筛选选择起止时间后界面一直显示“数据正在加载”
  b20a24f2a5706226b4c72f4da36933b22784feab | wangchuan |3 |personal_login/forgetPwdPage.html; personal_login/webLogin.html; personal_login/webRegister.html |     修改错误信息样式
  87c5b1189f5fde0c9d9b03f963c8554943d4be84 | wangchuan |1 |views/vdi/dialog/system/recycle/editLeftDays.html |     回收站:剩余保留天数只能输入正整数
  9596a84395a23851875cc396eb537db585e4b417 | zhangyao |1 |75947dfc5 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  75947dfc587e3f89c5efe5bf960a02b5345a52e6 | zhangyao |7 |js/idv/desktop/controller.scene.js; js/vdi/desktop/common.js; js/vdi/desktop/scene.js; js/vdi/utils/ui.js; views/idv/desktop/scene.html; views/idv/dialog/desktop/add_scene.html; views/vdi/desktop/scene.html |     公共桌面相关逻辑优化
  5c6dcd2be1f39fd955ea9ae11fe0529167d380c0 | zhangyao |1 |webpack.config.js |     允许自定义假数据
  5587da68b5ca67b3e1ee542b024b5e5b5d9a8583 | zhangyao |3 |js/idv/desktop/controller.scene.js; views/idv/desktop/scene.html; views/idv/dialog/desktop/add_scene.html |     IDV添加区域树
  f0cd98b2365e55b0f567c7d1d424b94db534979c | zhangyao |2 |js/vdi/desktop/scene.js; js/vdi/utils/ui.js |     公共桌面bug修改
  e85eee956c92d6496017a1f5d88a7fcbfd27d55c | wangchuan |0 | |     build
  b1340e0ded62986dd3db7c58c2c2f1eb3aee1dde | wangchuan |1 |a63145fd6 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  24d81ffb967c364a46ed4e42bd18995439274056 | wangchuan |3 |js/vdi/terminal/controller.schoolroom.js; views/vdi/dialog/terminal/terminal_schoolroom_add.html; views/vdi/dialog/terminal/terminal_schoolroom_edit.html |     vdi区域IP范围校验
  a63145fd6ef5a09c9e6131f22bf9d37bc93a759e | 0obuwawao0 |1 |js/voi/desktop/controller.roam.js |     打包voi转测
  8d710beaadb21a37bea926b8550d48dd0045ae27 | 0obuwawao0 |1 |js/voi/desktop/controller.roam.js |     打包voi
  5b35c58739ea1ef830fe2fed6aab530b025ac7ee | 0obuwawao0 |1 |13c5e1182 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  13c5e1182f6c74e51df61e863ff6a500aa11d44b | 0obuwawao0 |4 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/template/controller.template.js; js/voi/voi.js |     打包voi
  a5246eae5ad23f03d530eabf857a3bab7de8f2c7 | wangchuan |1 |3164e2f96 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  8ace827ac2debaa7c596c356d049abac7b485259 | wangchuan |1 |multi-select/isteven-multi-select.js |     多选下拉框
  3164e2f96c84b5f31faa44a72d9ca697c21451fd | zagger |1 |2d182248b |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2d182248b4d0f46c25d57bb8e89ba68af7bda981 | zagger |1 |js/vdi/monitor/alarm.js |     15698 【警告信息 】必现-导出警告日志不选择时间可以导出
  7da32474a27028792cadf40e181a017325d17a79 | 0obuwawao0 |3 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/voi.js |     voi个人桌面部门树接口修改
  eb12bb7f0aa87d06626b5a1d70aa8cc237d6cabf | wangchuan |1 |views/vdi/dialog/terminal/terminal_schoolroom_edit.html |     VDI区域管理：编辑区域不支持空格
  eb15f59c38a97e3202fd7ce826238fa8d569f5c8 | 0obuwawao0 |0 | |     voi打包
  7acae9e8cae85203a7e6c663df2c16f1919170e6 | zagger |0 | |     build for package
  c5e133df02a6e5cca7590365d44a8b5d0e3902d8 | zagger |1 |img/computer-other.png |     补图2
  fb3424be1f5d0d19ca9e8b256758c3f6b73e1ee7 | zagger |1 |f76647965 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  f7664796572d31412e41e9fc1e679f47df364241 | zagger |2 |img/nostate.png; img/pause.png |     补图
  9b323713a0995ef3ea44aad006ece0dfa74d7e09 | zagger |7 |css/your_style.css; img/terminal_defend.png; img/terminal_deploy.png; img/terminal_menu.png; img/terminal_power_off.png; img/terminal_power_on_linux.png; img/terminal_power_on_windows.png |     gs
  0b0ddca20086aa57468acdd6d318ab7cd0c178ea | 0obuwawao0 |4 |views/idv/terminal/classes.html; views/idv/terminal/client.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     修改区域样式
  f238b6a35eea1e6b95d4980d457edec69a7e285b | zhangyao |1 |2bbc0376d |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2bbc0376dd51b6bb133f8ba6c8859b71588a6ae2 | zhangyao |1 |js/vdi/security/group.js |     fix: #15586
  419373c3678db13d2803b30f0eb955fd2b09fb12 | zagger |0 | |     build
  b1ce78940085c8fef22b603585376b97872e9957 | zagger |1 |a661e9246 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a661e924693fe51de3fdd97301ddb20aaeb0ef1f | zagger |2 |css/your_style.css; views/vdi/user/domain.html |     用户-域用户-瓦片样式
  32148401e9cd97c0cec41d96214b7eedff1579c7 | wangchuan |0 | |     build
  ce1f89100e94835c2dc4e8038819ea9da36d5cf9 | wangchuan |1 |336101e84 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  336101e84ebace7699da289838060ed0deff8188 | 0obuwawao0 |1 |js/voi/voi.js |     voi打包自测
  73430e9e28eaddcadd67b32f17eadec8dbc13e18 | 0obuwawao0 |1 |ac219601a |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ac219601adf901185233ca47153f2b6e92e14814 | 0obuwawao0 |8 |js/idv/terminal/controller.terminal.js; js/voi/desktop/controller.roam.js; js/voi/terminal/controller.terminal.js; js/voi/voi.js; views/idv/terminal/classes.html; views/idv/terminal/client.html; views/voi/desktop/scene.html; views/voi/terminal/schoolroom.html |     添加 VOI idv终端管理授权解除功能
  9c73d91a84b964982d67e5d36e4f128572b9bbc6 | zagger |0 | |     build
  02e662242fa8cabdeeec63d84f77463f0f40426a | zagger |1 |74d041429 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  74d04142942dbd0e679057057f91d812e2980d42 | zagger |2 |js/vdi/user/domain-user.js; views/vdi/user/domainList.html |     域账号
  496f30d874d0619b9201530d1c0c0a81ad866eaa | zhangyao |0 | |     build
  7766f37185f0f4a3234f1682a00888b4b39db084 | zhangyao |4 |js/vdi/config/http.js; views/idv/desktop/scene.html; views/vdi/desktop/poolList.html; views/vdi/desktop/teach.html |     去掉idv相关界面字段
  f2e7917f2b8bdab34e21bc927a4fca34741f2b27 | wangchuan |1 |views/vdi/dialog/monitor/config.html |     【分布式存储】告警策略配置项
  e129815ba3294713703751f63df23339908cd89f | zagger |2 |css/your_style.css; views/vdi/user/uaa.html |     背景颜色修改
  907e96d88da542f2e7a554842b79c995d074408b | zagger |2 |views/vdi/terminal/client.html; views/vdi/terminal/schoolroom.html |     去掉终端两个界面多余的框
  561270de5dc917b93d8c64fc45f7911b6d945d73 | zagger |1 |421a3b811 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  421a3b8110a85565ce97eb08234fbf37ee640295 | zagger |1 |js/vdi/monitor/controllers.js |     highchart loading背景样色修改
  5a7af5dbd4da4de8bd735e69c5f073b008b0bb7d | 0obuwawao0 |0 | |     voi打包自测
  d0652f0a780ba909d4eee732a5060aa1bffbfd38 | 0obuwawao0 |1 |d62c01d14 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  d62c01d14b3a03f90fb83f8974bd9c482d00036e | 0obuwawao0 |4 |js/voi/terminal/controller.terminal.js; js/voi/voi.js; views/voi/dialog/desktop/add_personal.html; views/voi/dialog/terminal/alert_input_password.html |     终端解除限制
  f7d9eeeabaec9ea8220b8260dc95e98c7764c1e9 | zhangyao |1 |541737c93 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  541737c93289e724273eb0b496d7137bccc91b30 | zhangyao |9 |js/vdi/config/http.js; js/vdi/security/group.js; js/vdi/system/system-log.js; js/vdi/utils/ui.js; views/vdi/dialog/security/new_desktop_strategy.html; views/vdi/dialog/security/new_rule.html; views/vdi/dialog/system/backup-log-config.html; views/vdi/dialog/system/set-keeptime.html; views/vdi/security/group.html |     修改禅道bugs
  e4f3fda5be4c97e8d58e51776e943927c8f55c01 | zagger |1 |b028dd823 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b028dd823f223f230f9f3dc145a03f1d1cea9d3b | zagger |0 | |     新增个人模板获取接口 逻辑5build
  bfa59f8c1368738dafe6aa49621e08a4d6385531 | zagger |1 |js/vdi/desktop/personal.js |     新增个人模板获取接口 逻辑5build
  9e2ee95333b432aaa73925d25abc5937848840a5 | wangchuan |1 |363bd86f2 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  363bd86f2bc10a635c3c7579a2ae85c6c2f6f7f6 | wangchuan |1 |900dafd28 |     合并代码
  edca40280c3f77079862b1bcd56370121f37d877 | zagger |0 | |     新增个人模板获取接口 逻辑4build
  900dafd2876c322ddbaad05d2ab6b837306f51f5 | zagger |1 |js/vdi/desktop/personal.js |     新增个人模板获取接口 逻辑4
  46b395ff4388fea56876ed18b336cac88750f3eb | zagger |0 | |     新增个人模板获取接口 逻辑build3
  a1a90c487b7d1124ee3bc811243156a93cc2ef27 | zagger |1 |js/vdi/desktop/personal.js |     新增个人模板获取接口 逻辑3
  9ccdc675de31ad437247060bb6eec14a9d2c137b | zagger |0 | |     新增个人模板获取接口 逻辑build
  d3d8903231d59be39ea1bd9388f7410b598f25c9 | zagger |1 |js/vdi/desktop/personal.js |     新增个人模板获取接口 逻辑
  d0093080a875e54231b055ca7271a2054f632889 | zagger |0 | |     联调镜像分层代码
  653a8eceb1e29263ddcd9abd19d0cf03b9cb632e | zagger |21 |css/your_style.css; img/computer-off.png; img/computer-on.png; img/intance_error.png; img/intance_running.png; img/intance_suspended.png; js/vdi/desktop/personal.js; js/vdi/user/common.js; views/vdi/desktop/personal.html; views/vdi/desktop/scene.html; views/vdi/dialog/desktop/personal_alter.html; views/vdi/dialog/desktop/personal_new.html; views/vdi/network/dhcp/dhcp.html; views/vdi/network/externalNetwork/externalNetwork.html; views/vdi/scheduler/disk.html; views/vdi/system/desktop.html; views/vdi/system/set-general.html; views/vdi/system/set-vdi.html; views/vdi/terminal/schoolroom.html; views/vdi/user/domain.html; views/vdi/user/uaa.html |     镜像分层代码 + 一大波样式修改
  ac346fe0804b04bff6f6bd66d8d5a43dfe7bec1d | wangchuan |6 |img/computer-off.png; img/computer-on.png; img/terminal_defend.png; js/vdi/summary/controllers.js; js/vdi/summary/summary.css; views/vdi/summary.html |     概要修改
  5d980cf80524db76865e454d4e3e7c09a437f32c | wangchuan |1 |js/vdi/security/client/controller.security.client.js |     产品要求改个文字
  4baaa6b2ed2cc3566f9d104290cab7736e70e2f1 | 0obuwawao0 |3 |js/voi/terminal/controller.terminal.js; views/voi/dialog/terminal/alert_input_password.html; views/voi/terminal/client.html |     正在做终端解除限制功能
  f97bebda71ead8601271db31d974b12c49840b75 | 0obuwawao0 |1 |a3f3af758 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a3f3af7586c247a51739732e9aaddb9374d78843 | 0obuwawao0 |1 |views/voi/desktop/roam.html |     漫游桌面列表去掉CPU 资源池列
  47a9bf1a310503a5df5382ebf989cbdefc160f54 | wangchuan |1 |views/vdi/dialog/security/client/apply_security_client.html |     产品要求给区域加个终端数量展示
  f6c742ff9fa5e8ddb839b78a92e770f92cad6368 | wangchuan |1 |personal_login/index.html |     上一次提交错误
  e932831b5487e9e66abb87fa53ec8238fcf9e7cd | wangchuan |1 |2b96cc901 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  7f5e37bc327602f35d52730a4270ca04b812e5ee | wangchuan |1 |personal_login/index.html |     历史bug
  7b124bff9fdc258ece099e743ecb8da470204bd5 | wangchuan |1 |views/vdi/dialog/resource/storage/add_disk_group.html |     产品要求加个提示
  94c355e8e550a2b81ab4f70df4f06d6599d32b38 | wangchuan |1 |js/vdi/security/client/controller.security.client.js |     产品要求添加时间限制
  2b96cc90182e08680a01e92f847933ae03782a8c | 0obuwawao0 |2 |js/vdoi/system.js; views/vdi/system/set-general.html |     放开通用设置中的随机码
  32976ac2dc84dc8ac0a7848f219378ad23e46f50 | zagger |2 |js/vdi/monitor/common.js; views/vdi/system/set-general.html |     1.bug#15544 【通用设置-】必现-配置邮箱服器复杂的测试邮件地址不能输入    2.15542 【通用设置-】必现-配置邮箱服务可以输入不合法的端口号
  7e8fa92f489dc874ca7c728d5294aa365a02c628 | zhangyao |2 |js/vdi/desktop/common.js; js/vdi/utils/ui.js |     教室树形选择器优化
  48fdacd347c41f971f3bf3f395fb46dfe79dc375 | zhangyao |1 |d7840727c |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  d7840727cf1c79576ae5261c5f8aedb0c885e3be | zhangyao |2 |js/vdi/security/desktop.js; views/vdi/dialog/security/new_desktop_strategy.html |     核对编辑策略需求
  2c9ffec58361f36cde825c26d66e3b40a8c42398 | 0obuwawao0 |2 |js/voi/help/controller.deploy.js; views/voi/dialog/help/system_deploy_import_from_local.html |     块速部署本地上传和vdi保持一致
  0354dff9cab5b221e560f419eb18bdcfa643c2c5 | zhangyao |3 |js/vdi/desktop/common.js; js/vdi/desktop/scene.js; js/vdi/utils/ui.js |     教室选择器细节优化
  e8046125624cca86e48471e13d05905c3f5cb90d | zhangyao |3 |js/vdi/desktop/common.js; js/vdi/desktop/scene.js; js/vdi/utils/ui.js |     进一步完善 picker 逻辑
  985220b382f0f0f1483d3a90ea2d30b575c12c49 | zhangyao |7 |.gitignore; css/your_style.css; js/vdi/desktop/common.js; js/vdi/desktop/scene.js; js/vdi/utils/ui.js; js/vdi/utils/user.js; views/vdi/dialog/desktop/scene_new2.html |     完善picker指令
  9ab2d65241e614a4d361b9b3aa45a43532e5ef64 | zhangyao |1 |4c9b0f1f6 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  4c9b0f1f6aa1f277773436eb2e858db3cec8bcd0 | zhangyao |1 |js/vdi/utils/ui.js |     添加 ui-picker ui-tree-picker 指令
  2fe989fe5ea7e61216c3ac9e8802964a879c2c60 | wangchuan |1 |b49adf5e2 |     概要修改
  322460b71749345f08693ead01040e0c1932332c | wangchuan |4 |js/vdi/summary/controllers.js; js/vdi/summary/summary.css; js/vdi/vdi.js; views/vdi/summary.html |     概要
  b49adf5e276d9090b0a2d36336e046a61ce6d18f | zhangyao |1 |ff4d69a28 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ff4d69a28dcb768801f10ae0a3af533b396acf39 | zhangyao |4 |js/vdi/help/quick-deploy.js; js/vdi/system/common.js; views/vdi/dialog/system/system_deploy_import_from_local.html; views/vdi/help/deploy.html |     fix #15471
  fb8c9cabd96f6ea688fe05568e75991e0092445e | 0obuwawao0 |1 |a2eb2ef79 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a2eb2ef795d83ed6601751ff18319a0f6cb74153 | 0obuwawao0 |4 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; views/voi/dialog/desktop/add_scene.html; views/voi/dialog/desktop/desktop_detail.html |     修改VOI个人桌面详细，漫游桌面详细
  a613ed7006dd7318365b2e66e44b71867bc4b586 | zhangyao |0 | |     build
  7a23a0f465ff5bae7ba2e920641206efb9dfc983 | wangchuan |0 | |     客户端包
  c190a3938841c82b74df2b2fcfce2202b18174d6 | wangchuan |1 |6212328c3 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  6212328c3af77343c5cc6a8bb01108f085f5137d | zhangyao |1 |bf8bf9080 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  bf8bf9080f1d59cc05f9cbe8dfae8bb3250e77d2 | zhangyao |1 |js/vdi/system/system-log.js |     修复日志设置保留时间问题
  f8c44d7da97853d0361cac73a4cff99da86bbf81 | wangchuan |1 |js/vdi/summary/controllers.js |     概要修改
  1abbf47276ecb901350378b0f606d90e70297c3a | wangchuan |2 |js/vdi/summary/controllers.js; views/vdi/summary.html |     概要修改
  61c4e066cbd9c30c09b7a7718074e506f3a66b9d | wangchuan |1 |js/vdi/resource/storage/controllers.js |     存储管理：配置公共存储bug
  d21c71009fd171c37cc6c8e369de66ec68e93674 | wangchuan |4 |js/vdi/terminal/controller.terminal.css; js/vdi/terminal/controller.terminal.js; js/vdi/vdi.js; views/vdi/dialog/terminal/terminal_configureclassroom_edit.html |     终端管理：移动至优化
  57e5abdaccf844d1955777d3d042746326b2150e | zagger |1 |js/vdi/user/uaa.js |     build
  4a676fe810fd13899f4a1e2d105d85fe50d20a86 | zagger |1 |7added9ea |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  7added9eac69e9c8a9055f60f40a83ff01527685 | zagger |1 |js/vdi/monitor/alarm.js |     告警信息成功提示信息添加
  1eab79acafb1156b61b362c3b3823dc1d3515464 | zhangyao |1 |c3c5df4b6 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  c3c5df4b6e2909e038368c60b955150f24dff706 | zhangyao |2 |js/vdi/security/shared.js; views/vdi/dialog/security/manage_desktops_for_strategy.html |     fix: #15464
  30cd998bb9b45408cf33cef689af02b5a763a287 | zagger |0 | |     build for backend fixed bug
  38d0be98526c11e4820db8311d270ebdff8bbe1f | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     uaa-管理帐号和普通帐号-一键同步配合后端修改
  8fea297e997fcd1413f678a1ecf572aad6296ff3 | zagger |1 |js/vdi/monitor/controllers.js |     监控兼容一下报错
  6cea52c2fbe5d4767db19d1a91f1493ef583751f | zagger |1 |66762828c |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5833a5461537565eee48d7f8cd09da2927c2061f | 0obuwawao0 |0 | |     voi联调
  6f1da9a2e2ddbde39a4e0b600585bfe6a30186d1 | 0obuwawao0 |0 | |     登录假数据修改
  16540cd3560275cb5d12c6d73206e659caf5230c | 0obuwawao0 |5 |img/yhkylin.png; js/voi/dashboard/controller.dashboard.js; js/voi/desktop/controller.roam.js; js/voi/desktop/controller.scene.js; views/vdi/summary.html |     修改dash
  188f73f14d2df8a7b77a14bc4aeda2d5e30fd8ec | 0obuwawao0 |1 |f1d4d7d2d |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  f1d4d7d2db80bf0d9c468e41dadbc3a115f00da7 | 0obuwawao0 |5 |js/voi/help/controller.deploy.js; js/voi/voi.js; views/voi/dialog/help/system_deploy_import_by_server.html; views/voi/dialog/help/system_deploy_import_from_local.html; views/voi/help/deploy.html |     修改快速部署
  66762828c906a84b02aa326fa2f6de80008288e9 | zagger |2 |css/your_style.css; js/vdi/scheduler/disk.controller.js |     1.修改select多选框样式，高度掉下来了2. 网盘界面，开始loading问题
  254b882a81312db0f82840169be7af5c46b7c4e4 | zhangyao |1 |6d4211247 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  6d421124771bc409045eec231f289e245c16e2e6 | zhangyao |0 | |     build
  a6c29e0081fab62aeba25b6adc8f96f1fde1a50f | wangchuan |0 | |     客户端包
  83a34637aa687574f4665032c4624c0f15b56960 | wangchuan |1 |3e6dc6aec |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  3e6dc6aec828ef80eb79b3c3960f882465b2222e | zagger |2 |js/vdi/auth/controllers.js; js/vdi/scheduler/disk.controller.js |     1. 登录失败-清空密码框    2. 网盘域帐号-查询条件
  258cfa5fda14e70ee320d07ed59d9f06d687a46f | zhangyao |2 |js/vdi/security/group.js; views/vdi/security/group.html |     fix: #15232
  e8c85681aa266bb0a5a445b5073dfb82f95c8974 | zhangyao |1 |da76995ee |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  da76995ee1f273cc4ba75b9a11aceea816c5d822 | zhangyao |1 |js/vdi/utils/ui.js |     fix: #15450, colorpicker 问题
  f249f819b959112c3cd011aaaa92739c56dfe992 | wangchuan |3 |personal_login/js/common.js; personal_login/js/components/pwd-complexity-tooltip.js; personal_login/js/rules.js |     密码强度
  8c55c2a2a2770279667dae599b26d4a2a58d2be0 | 0obuwawao0 |5 |js/voi/voi.js; views/voi/desktop/roam.html; views/voi/desktop/scene.html; views/voi/terminal/client.html; views/voi/terminal/schoolroom.html |     树高修改
  5d1f5c6c4cfc4f5d0934bd11ae714d05cad353c6 | 0obuwawao0 |6 |js/idv/terminal/controller.terminal.js; js/voi/terminal/controller.terminal.js; js/voi/voi.js; views/voi/desktop/personal.html; views/voi/dialog/terminal/terminal_move_groups.html; views/voi/terminal/client.html |     处理VOI,IDV移动终端窗口逻辑
  db0b95d64e0ea87b886fa8d2b8dc8bf1a8a359fe | wangchuan |0 | |     客户端包
  6726161e9e374e8d537661d4118b1f6deee5869a | zagger |1 |views/vdi/user/uaa.html |     15376 【用户帐号】-必现-普通帐号登录了终端，帐号信息上次登录IP未记录
  584dd9589ea716d488f03066791d1b828c00adca | zagger |2 |js/vdi/user/admin-user.js; views/vdi/user/admin.html |     15389 【管理帐号】-必现-admin帐号重置密码与需求不符
  a9ddc9391e11ee4a13087119b14709bbc93f89de | zagger |1 |forget-pwd.html |     15401 【登录-忘记密码】-必现-忘记密码不输入密码可以修改成功
  31d373a8c0d6a40dc4fb44c51a8df886e82f6320 | zagger |2 |js/vdi/user/common.js; views/vdi/common/select-multiple-dom.html |     恢复select多选框的结果项删除功能
  ddd0189279ad8d6c25dfaac7da67b0b7681b6ded | 0obuwawao0 |1 |bb742859c |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  bb742859c61cc8aabcb187f0a23cc36ad485c545 | 0obuwawao0 |6 |css/your_style.css; img/uos.png; img/yhkylin.png; js/vdi/os-types.js; js/voi/desktop/controller.scene.js; js/voi/voi.js |     修改模板图标标识
  af13108567a3078d9f775db07b69ba8bc3980995 | wangchuan |1 |9211972d4 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  9211972d4c6cdd26aaba8e41bc97c89719faed7b | zagger |1 |01259b87d |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  01259b87d789d5cd65cd0651c1d6f8116c2381cb | zagger |4 |css/your_style.css; js/vdi/user/admin-user.js; js/vdi/user/common.js; views/vdi/common/select-multiple-dom.html |     多选框样式解决
  eac49455973d27937f4f2f48c15a4ec569a8c7a7 | wangchuan |0 | |     客户端包
  cbcb8ddd42ae72c332fc70e7f22712e55b623cc4 | 0obuwawao0 |6 |css/your_style.css; js/voi/desktop/controller.scene.js; views/idv/template/teach.html; views/voi/desktop/scene.html; views/voi/template/personal.html; views/voi/template/teach.html |     修改VOI,IDV模板界面样式，隐藏工具栏按钮图标，修改voi公共区域界面
  929f600138569a331d97c7bc5e98c3a757820887 | zagger |3 |js/vdi/user/common.js; views/vdi/common/select-multiple-dom.html; views/vdi/dialog/user/user_admin_scope.html |     管理帐号-范围代码-完整保存-完整读取版
  3e72a4267d12d4af5c2ba79ceb3993087ad83968 | wangchuan |6 |css/smartadmin-production.min.css; js/vdi/summary/controllers.js; js/vdi/summary/summary.css; js/vdoi/main.js; views/vdi/app-main.html; views/vdi/summary.html |     概要界面
  2e36d0e329a4f9bac33e50bc4606cf1d89a55154 | zhangyao |1 |js/vdi/utils/ui.js |     修复树形删除逻辑
  1871bb8b865e53b0e95836262bc48711d3fe4ca9 | zagger |4 |css/your_style.css; js/vdi/user/admin-user.js; js/vdi/user/common.js; views/vdi/common/select-multiple-dom.html |     管理帐号-范围代码
  b9c0276ccbb1801534d5e9f089f20d19b92a03c2 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     bug
  cccdfbdb2673d0f4027de607c23db5bb9a109f4d | 0obuwawao0 |5 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.scene.js; js/voi/terminal/controller.terminal.js; views/vdi/system/set-general.html; views/voi/desktop/scene.html |     正在修改场景
  01f5505526c78631788fcbab3aa1c13f34147237 | zhangyao |6 |img/watermark-bg.png; js/vdi/desktop/scene.js; js/vdi/security/desktop.js; js/vdi/security/style.css; views/vdi/desktop/scene.html; views/vdi/dialog/security/watermark_preview.html |     解决场景过滤问题
  b1c92db2e7ae04dc172a8215c3345621fcbffd3d | zhangyao |0 | |     build
  c07a11ca3ee30acee22820af4595e0c722d64f2e | zhangyao |1 |a60a33b1e |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a60a33b1e55077e28235024be9b09a0fd7100d65 | zhangyao |5 |css/your_style.css; js/vdi/config/http.js; js/vdi/utils/ui.js; views/vdi/common/confirm.html; views/vdi/system/set-general.html |     修复影响打包问题
  bfbd80e2da5706c50fec404388be4e2e5e96756a | wangchuan |0 | |     客户端包
  a974f270dda96f39520d35d3ec4fcec9a48f223a | zhangyao |0 | |     build
  13340f8f441873b24f5212d252b376c050fddd62 | zhangyao |1 |73c8b3f98 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  73c8b3f98b1eed637708bd1d84ca86642232f88a | zhangyao |4 |js/vdi/desktop/personal.js; js/vdi/resource/storage/controllers.js; js/vdi/security/shared.js; views/vdi/dialog/security/manage_desktops_for_strategy.html |     修复几个bug
  55e1f675dfcd66689d702350c6e8c5aec077fa00 | 0obuwawao0 |3 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; views/voi/desktop/roam.html |     漫游桌面添加详细窗口
  8a26d601e8b91277816c7c55d93ffc9732163d76 | 0obuwawao0 |1 |646b6f578 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  646b6f578bf853fb1c121348b01aa8e92df9db56 | 0obuwawao0 |7 |js/idv/system/controller.system.js; js/vdoi/system.js; js/voi/system/controller.system.js; js/voi/voi.js; views/idv/system/set-idv.html; views/vdi/system/set-general.html; views/voi/system/set-voi.html |     修改设置，分离出局部控制器
  94494680a11bea3107b5e94d68bb17a7dbaf898e | zagger |3 |css/your_style.css; views/vdi/help/about.html; views/vdi/help/activeAuth.html |     激活授权界面样式修改
  57df7d0753fa968026f92ec2156267d910e6e20d | zagger |0 | |     forget.js参数改错地方了
  ccd4bdb1e06935a5bf7647fc4383c6ea28a09efb | zagger |1 |js/vdi/forget.js |     forget.js参数改错地方了
  31b05d2aad207d06fe3607c367e45fc55bd5f39d | zagger |0 | |     打包给后端测试
  daab63ada75e45330212e8db3e4cd7fdd259faba | zagger |2 |css/your_style.css; views/vdi/help/about.html |     about 界面样式修改
  da14c483d456d8c18e39f398578489416aa4aa3b | zagger |1 |9c83bcae8 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  9c83bcae874660e95a76afb8e42110e8ad75cd60 | zagger |1 |js/vdi/forget.js |     忘记密码界面-获取验证码接口配合后端加个参数type
  535853254f2c591632669711d80a87fa886866d1 | wangchuan |0 | |     客户端包
  3630f6408e3c8de55bfae713691aff5793cf1efb | wangchuan |1 |9d7d9cdaf |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  3f3e79d8ca5791b7010a263016bdba4965c2f0ff | wangchuan |1 |views/vdi/terminal/client-tab.html |     终端管理文本
  9d7d9cdafa7fc113686f67042f2bd6db523c4f84 | wangchuan |1 |views/vdi/system/set-general.html |     仲裁IP
  6f5abca0a2ac652f276c3bb9cf1a33c52153cc70 | wangchuan |1 |38c07c87d |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  141bd092fdd2a69569c21fd8c2dc479e733853f6 | wangchuan |2 |js/vdi/system/system-settings.js; views/vdi/system/set-general.html |     仲裁IP设置
  38c07c87d56b631c2c9f581316f43946b7101448 | zagger |1 |678dd6cdc |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  678dd6cdcdbc581b06bfd49dae1ff1d0affa01da | zagger |6 |css/your_style.css; views/vdi/resource/console/console.html; views/vdi/resource/pool/host.html; views/vdi/template/hardware.html; views/vdi/template/personal.html; views/vdi/template/teach.html |     一大波样式修改-待验证
  561af8b61e7676ca3a710b85eef8984686f7d49e | zhangyao |0 | |     build
  0c234c786e501a9ad3b9a4875130d8fd7642f3a5 | zagger |1 |ssh_terminal/terminal.js |     调试3
  cc6c5b475e4bd9834f5c82bcb28f0231e2cbac4e | zagger |1 |ssh_terminal/terminal.js |     调试2
  4b2a1cd4ced3f6b6c334c679529282be8efd5a30 | zagger |0 | |     yuancheng 调试
  47c614a4fc8784f8fc8886587f7944389b4ac7e0 | zagger |1 |ssh_terminal/terminal.js |     ss2
  15f492607d2b9efb8656c4cbbcf821bb27a08418 | zagger |1 |ssh_terminal/terminal.js |     ssh
  da64860e1ae11eff7ec83792d98d81eca71adaab | zagger |1 |041284f7d |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  041284f7df983a3173ce33290704b2d794a00e20 | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     没有邮箱重置密码给提示
  db934ec8760df95ed21ed41091a36094fc8f2d51 | zhangyao |1 |ebfc489f0 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ebfc489f099b03ef082a29681421cd8af87c0a96 | zhangyao |1 |views/vdi/dialog/license/addlicense.html |     修复下载链接
  a235f5e9df228d01bdb5127e94e701bd44ec89c9 | zagger |1 |1d19423b9 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  1d19423b9511fd7326b818e16fc54fcff549eaac | zagger |1 |js/vdi/monitor/controllers.js |     代码提交timer
  c7ed73bc0cd0fae65a61f35debd87f11a749a41d | 0obuwawao0 |5 |js/idv/terminal/controller.terminal.js; js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/voi.js; views/voi/desktop/roam.html |     修改漫游桌面布局
  b07d1d80fcbc6d40b8f0b51b2088421fd258305f | zhangyao |2 |js/vdi/desktop/scene.js; views/vdi/desktop/scene.html |     添加区域树
  7a26abfae447c1e1f73b850ebef0d4f7c6d98127 | zhangyao |0 | |     build
  f61579655dc605c6ba23f30a9d88d3f00c7e08a5 | wangchuan |1 |15f27130e |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  15f27130e4bd23eb8ecdf56f3ca59b3d89d4f746 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     echarts
  48ec3a2c9f130cacf7173a73d29adbea6b2b3a9d | zhangyao |1 |d1670f41f |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  d1670f41f8a933924564a4443d5b9dbbd28e9736 | zhangyao |6 |js/vdi/config/http.js; js/vdi/resource/api.js; js/vdi/security/desktop.js; js/vdi/security/shared.js; views/vdi/desktop/personal.html; views/vdi/dialog/security/manage_desktops_for_strategy.html |     修复禅道BUGs
  04efe2fcd3fc5c7bf67787650e2d5fe14268852d | wangchuan |1 |js/vdi/resource/storage/controllers.js |     echarts
  a8684bb0deac1f0095ad65392be754a25284dc4d | zagger |1 |js/vdoi/main.js |     兼容报错代码
  747774b44fa38af75cfce6ba38d9770cb8b11cb4 | zagger |1 |css/your_style.css |     工具条样式修改
  868dec439a7b12fd46ce3616747298ce5a6be847 | zagger |1 |views/vdi/system/set-general.html |     认证服务器+修改时不能解除认证服务器+保存时验证表单
  d8c863aa67179921082e8da7956237451fe0f780 | zhangyao |2 |includes/userMenu.html; js/vdi/vdi.js |     fix 15085
  8c84f09cc35a14dba21f37cc3e71ee7660c09a96 | wangchuan |1 |js/vdi/system/recycle/controller.system.recycle.js |     bug
  dc3fc43e742d948ea35ea8ecbec0cbe0f815ffa8 | zagger |2 |js/vdi/system/system-settings.js; views/vdi/system/set-general.html |     邮箱服务器bug
  d78cfc829cbc0143b67e4ffb96d1c8a27a6cce19 | zagger |1 |js/vdi/menus.js |     bug#15275 【管理台】-必现-主界面桌面、模板菜单顺序与需求不一致
  ca62f735fffaaac7fc684e933ce4c24714b5997b | zagger |1 |js/vdi/monitor/common.js |     修改textarea-email指令 bug， 换行之后的值没有trim掉空格
  14f22515562eef01521d7644020632607b4f8763 | zagger |2 |js/vdi/system/system-settings.js; views/vdi/system/set-general.html |     认证服务器bug#15290，认证成功提示+取消之后，重置填完之后的值
  83d8b03b206c304a07d9561df80d5ce4e9097caf | zagger |1 |e23bbcaa5 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  e23bbcaa5d228e9699b945eec01cd644a49b5f2f | zagger |1 |css/your_style.css |     header背景图 background-size:cover;展示
  01bb5e9f937db4bdaf590e41c6f3ec219aa3db24 | zhangyao |0 | |     build
  31f72e3cea3313911821d4e6ea0dfbe196f2a752 | zhangyao |3 |js/vdi/bootstrap.js; js/vdi/config/http.js; js/vdi/split.js |     http请求拦截器修改
  c567febc1de927d2e1d3a83bd973cbab866b2abe | wangchuan |0 | |     build
  e625c379fae0ce48ec72b05abc6a86931bae3fae | wangchuan |1 |fa4ec8f11 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  be6345c4017c90b6f3a464333fe42697e203d177 | wangchuan |1 |personal_login/js/components/user-form.js |     获取token加type
  719077f6455a809ac457713f8ca484e222e5b75b | wangchuan |4 |personal_login/index.html; personal_login/js/components/login-timeout-tip-modal.js; personal_login/js/components/pwd-expired-tip-modal.js; personal_login/js/webLogin.js |     登录时效性提示
  fa4ec8f115c33c03ee351ca5642e3eedee2e89a3 | zhangyao |0 | |     build
  6684209be077e0de43f758ec2c5be6a446dff0f1 | wangchuan |1 |24c4ee956 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  24c4ee9564f63b587ee84e32f6422fa9eb0efdbe | wangchuan |0 | |     客户端包
  27a6a1e05795e5206fe2fd79fe8e219e12fdc3cd | zagger |1 |8858b982f |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  8858b982fa6f05574f6fb8e7afbdec8c327a59ff | zagger |1 |js/vdi/auth/controllers.js |     邮箱获取验证码时已经知道了验证码的邮箱的，不用前端提示
  9189ed6b638860002fe497432fa413dba57afbc9 | zagger |2 |views/vdi/user/admin.html; views/vdi/user/uaa.html |     前端放开对帐号的重置密码的限制
  6f14cbf8937ba46a6f081acb9c87acf894b2684a | wangchuan |1 |cf41b5a5c |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  37f06a32bf688b8c5115a373d9ce63dc87830cdd | wangchuan |5 |js/vdi/resource/storage/controllers.js; personal_login/forgetPwdPage.html; personal_login/js/components/combined-login-modal.js; personal_login/js/components/user-form.js; personal_login/js/webLogin.js |     代码优化
  cf41b5a5cb20bf5bd9981eaed3fe51a243f9aa2d | zhangyao |2 |js/vdi/utils/ui.js; views/vdi/dialog/security/new_desktop_strategy.html |     修复禅道bugs
  3034c2bf82ad7cf8daa17e8d2ed3b68029b6bbff | zhangyao |1 |d0e963f8d |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  d0e963f8d0b08cb8ac4bc8199403bab934ac6fd8 | zhangyao |4 |js/vdi/config/http.js; js/vdi/desktop/personal.js; js/vdi/utils/ui.js; views/vdi/dialog/desktop/personal_download_video.html |     完善通用校验指令
  48a0d3161bc887485fb7839d69838d97219fe33a | wangchuan |0 | |     客户端包
  acf80373149625ed66525527773ce2a8ebf680b7 | wangchuan |0 | |     build
  4051dae9d8dd900f8e8ad0675e454254bedcbc50 | wangchuan |1 |a24d1a135 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  4b1a56432a2d643ca6dcd1d1f636422626f14291 | wangchuan |1 |personal_login/js/components/bind-mail-modal.js |     代码优化
  a24d1a135d51d437d3507a6cf919a2e21477422b | zhangyao |1 |f7dc49dad |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  f7dc49dade95a0f7fce12c4cd5793409a625b29c | zhangyao |3 |js/vdi/desktop/personal.js; js/vdi/security/group.js; views/vdi/dialog/desktop/personal_delete.html |     修复禅道bug
  8ddc3fa5e9eae89e5e64d0002dd6df89d5a46c82 | wangchuan |10 |personal_login/css/webLogin.css; personal_login/js/components/bind-mail-modal.js; personal_login/js/components/modify-default-pwd-modal.js; personal_login/js/components/user-form.js; personal_login/js/rules.js; personal_login/js/validator.js; personal_login/js/webLogin.js; personal_login/views/user-form.html; personal_login/webLogin.html; views/vdi/dialog/security/client/apply_security_client.html |     代码优化
  50fd5b0d7c72d559b5991df3708c1b0fc0486d7b | zagger |5 |forget-pwd.html; js/vdi/auth/controllers.js; views/vdi/common/force-modify-pwd.html; views/vdi/common/login-step2.html; views/vdi/login.html |     验证码和动态密令
  61eb93440762ccd01942766bfd9dcefbe09826b3 | zagger |0 | |     测试强制绑定邮箱-假数据
  32722fe60d455316ddcec7610c77f2e7809eeb67 | zagger |4 |js/vdi/auth/controllers.js; js/vdi/forget.js; js/vdi/utils/user.js; views/vdi/common/login-step2.html |     获取验证码-前端提示黄色框，提示邮箱地址
  f6c17371430c4d2f74d5462e3f60e625c0b38074 | wangchuan |6 |css/your_style.css; views/vdi/dialog/security/client/add_edit_security_client.html; views/vdi/dialog/security/system/add_edit_security_system.html; views/vdi/security/client/security_client.html; views/vdi/security/system/security_system.html; views/voi/dialog/terminal/pool_add_edit.html |     bug修改
  1da34a9b8fe01fda8163a16bf3668ed5640d8c36 | wangchuan |2 |js/vdi/resource/storage/controllers.js; views/vdi/resource/storage/disk.html |     bug修改
  e82850905cc75bc41c532850d36fa5a8be39eda0 | zhangyao |5 |js/vdi/security/desktop.js; js/vdi/system/common.js; js/vdi/system/system-log.js; views/vdi/dialog/security/manage_desktops_for_strategy.html; views/vdi/dialog/system/export-log.html |     修改bug
  9b8f8aa76152a0bdc6f5f009d6c22a80fc6d0f20 | zagger |1 |2d31ddce9 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2d31ddce9a089e61468d6179488e529fe25d3873 | zagger |1 |views/vdi/dialog/user/admin_uaa_import.html |     优化选择角色的问题
  94e327b354457fd8b59bc3d58bc9d8ee91b29909 | 0obuwawao0 |1 |5cb78bc17 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5cb78bc170b67ec56ce8819f22412ee60757fd01 | 0obuwawao0 |14 |js/voi/desktop/controller.personal.js; js/voi/desktop/controller.roam.js; js/voi/terminal/controller.schoolroom.js; js/voi/terminal/controller.terminal.js; js/voi/voi.js; package-lock.json; views/voi/desktop/personal.html; views/voi/desktop/roam.html; views/voi/desktop/teach-list.html; views/voi/dialog/desktop/add_personal.html; views/voi/dialog/desktop/desktop_detail.html; views/voi/dialog/desktop/download_video.html; views/voi/dialog/desktop/edit_personal.html; views/voi/terminal/client.html |     漫游桌面添加录像管理，VOI终端修改布局，VOI公共桌面修改布局,VOI区域管理修改布
  06c0c601cd048b8d212452445ca6c66b1a4646a6 | zhangyao |1 |591328cb8 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  8ded53434d2e707a7457ced95d608aa81c2fbd9e | zagger |2 |views/vdi/dialog/user/common_uaa_import.html; views/vdi/user/uaa.html |     去掉多余的代码所有分组+ 由于需求原因，uaa少显示了邮箱这一列
  303c81dac60c1cc8319a423e095837f1a7215a05 | zagger |1 |views/vdi/dialog/user/admin_uaa_import.html |     添加默认请选择角色占位选择项
  dd1a5bedb934373bcc53cf6993b37437449d9c66 | zagger |5 |js/vdi/user/admin-user.js; views/vdi/common/account-password-modify.html; views/vdi/common/force-modify-pwd.html; views/vdi/dialog/user/user_admin_scope.html; views/vdi/user/admin.html |     bug#15125#15124
  591328cb8a57e21aa4aa556764d7df5f8a3cb70e | zhangyao |1 |js/vdi/security/desktop.js |     透明值改为不透明
  6a3f0bd1613e34165133b859b9b796f326fc3de7 | zagger |1 |views/vdi/common/force-modify-pwd.html |     绑定邮箱提示
  a803125b2f0d0e90cd998869ffe74b9f97e2daa1 | zagger |1 |7f7f5fcc6 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  7f7f5fcc6748f36cb2afab3c5edb7cd26ee6a9e1 | zagger |4 |js/vdi/help/controllers.js; js/vdi/help/index.js; views/vdi/help/about.html; views/vdi/help/activeAuth.html |     about代码整理
  da25ed99c3c9265b93d31f4eaa7ee62bf4b66c5b | zagger |6 |css/font-jj.css; css/your_style.css; js/vdi/help/about-authority.css; js/vdoi/main.js; views/vdi/app-header.html; views/vdi/app-menu.html |     样式修改1
  d973e894eeb089af3750f65f40685d69eb59c045 | zhangyao |1 |views/vdi/security/desktop.html |     fix #15083
  053756c8c71171e2915319cd678156c042c31281 | zhangyao |1 |05a7fb2b7 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  05a7fb2b7fa4752147233dcd5955d6fa1c401b91 | zhangyao |2 |js/vdi/desktop/personal.js; js/vdi/utils/ui.js |     优化个人桌面左侧部门树
  d11eb450bb88b97933e2a243f3758343c3e1b232 | wangchuan |1 |5fe5710ae |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5fe5710aed84559e978e4d54cda54720eea4244e | wangchuan |4 |js/vdi/security/client/controller.security.client.js; views/vdi/dialog/security/client/add_edit_security_client.html; views/vdi/dialog/security/client/manage_security_client.html; views/vdi/dialog/terminal/terminal_schoolroom_add.html |     代码优化，bug
  c5b579519bd152ec6c113e10d3a6f3fc953358f8 | zagger |1 |1ae5fd922 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  1ae5fd922adb0518e08b969e3fe817c1ebd8c4d2 | zagger |6 |img/new_login_icon/about_bg.png; js/vdi/scheduler/disk.controller.js; js/vdi/user/admin-user.js; js/vdi/user/uaa.js; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     bugs
  4f2f80ef1453bceaf7d7cdc4801f624eecda4e33 | wangchuan |4 |js/vdi/security/client/controller.security.client.js; js/vdi/security/system/controller.security.system.js; js/vdi/system/recycle/controller.system.recycle.js; views/vdi/security/client/security_client.html |     代码优化
  8c1ef8a89d3e2de49af6a7fc12bd8b7f5c89d4a9 | wangchuan |1 |fd7d39952 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  d3692f1957bafbf5ed422eafd7c955360b2b58f6 | wangchuan |2 |js/vdi/security/client/controller.security.client.js; views/vdi/security/client/security_client.html |     终端安全：后端过滤
  fd7d3995271d6593ee444d2e4632049511facbfd | zagger |1 |js/vdi/bootstrap.js |     添加todo
  99beafa03660bbb027642c8ab6ef083cfbdbf42d | zagger |1 |js/vdi/bootstrap.js |     端口统一-继承port+host+protocol，只考虑路径问题
  72b1df90c6dbe3db453b9ef3c8cc3b3fd1b004a0 | wangchuan |1 |personal_login/views/user-form.html |     bug
  752aed82b4aafeb6bd4cd95483901036dd181c67 | zhangyao |1 |dc076a0d9 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  dc076a0d9c43b60fe10f255e10e9df3a88dad3ea | zhangyao |13 |css/your_style.css; js/vdi/desktop/personal.js; js/vdi/security/group.js; js/vdi/system/system-log.js; views/vdi/desktop/personal.html; views/vdi/dialog/security/apply_strategy2desktop.html; views/vdi/dialog/security/new_rule.html; views/vdi/dialog/system/export-log.html; views/vdi/security/group.html; views/vdi/system/admin-log.html; views/vdi/system/backup-log.html; views/vdi/system/logs-tabpanel.html; views/vdi/system/user-log.html |     修复测试发现的问题
  f88213e9815735d3f100a6baf5c0d8a32dd5c09e | zagger |0 | |     build
  208d844a791662978adae661adee8f0de268fd34 | zagger |1 |5d96ffa95 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5d96ffa95839a20b0629e92f0085387817a2fe98 | zagger |1 |views/vdi/app-header.html |     隐藏主题
  1f7e1d9c75c7319ed12a5eda06e2f0bc57b3bac6 | wangchuan |0 | |     build,客户端包
  74c44fc7e16830977a311d747386fe920aefd855 | wangchuan |1 |a9b689c6b |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  a9b689c6b2f32d2fdd86617f81d4f2c375506f90 | wangchuan |1 |personal_login/js/webLogin.js |     bug
  4c332667335dda5b93638de3b74dd8b6e11970ec | zagger |0 | |     build
  c1b4485e1f54916615f3e8755e5852ccd3c89801 | wangchuan |1 |personal_login/js/webLogin.js |     web登录bug
  b64fb0bec2a199cade6b8cc549c1201c17495136 | zagger |1 |76556cfd8 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  76556cfd897824da179fb56f2eda28eb93d45764 | zagger |4 |css/forget-pwd.css; css/your_style.css; forget-pwd.html; js/vdi/forget.js |     忘记密码bug修复
  74563be96fa18ae487ca16bf7be5fc2476ec19cf | wangchuan |1 |5f7ef8c9b |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  ab3dea68234e54441b18418a18ed88c84eeef692 | wangchuan |1 |personal_login/js/webLogin.js |     bug
  5f7ef8c9bf80cd834a7af5b031cd45af7ee09b8e | wangchuan |1 |7a5a43699 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  7a5a4369925b85785563c16f7ad18c81308d6732 | zagger |3 |js/vdi/auth/controllers.js; js/vdi/forget.js; js/vdi/utils/user.js |     验证码获取问题修复
  2680e5fc7f4dd4c3b2ebbeb83f5fd0db49481880 | wangchuan |1 |personal_login/js/components/bind-mail-modal.js |     假数据；样式
  73ca9f9f350bafe84d2921ccaab2d3085ed34e0b | zagger |1 |js/vdi/utils/ui.js |     初次登录修改密码，自动飘红的问题
  fb37c1e8f45330eba9111b1526f5ce9bb0588db8 | zagger |1 |bc55a2d1f |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  bc55a2d1f454818d705ec0c986dbc835d4df4921 | zagger |1 |views/vdi/common/force-modify-pwd.html |     特殊字符无法显示的问题
  144f4566dee9b273391d1a76f843d7f22bf38594 | wangchuan |1 |10b15c1eb |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  147c3a3b6d109b6ac7326f200c67cc2693ecd2b9 | wangchuan |2 |personal_login/css/webLogin.css; personal_login/js/webLogin.js |     web桌面：登录时效性；样式
  10b15c1eb4f0979f63178b998c54384e38c8870a | zagger |1 |js/vdi/monitor/alarm.js |     告警信息传参 都传字符串
  1637c119566a92719891faf01c41ae08805db528 | wangchuan |0 | |     客户端包
  286f0bc23c0d5ae09415da360a4cd1d3c613eab7 | zagger |0 | |     build for package
  0c6b0dce2c504bcd8d69ea19de6b8e7a1a3eb75d | wangchuan |1 |a7b9cb735 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  3ef467401aff113d6b58ea97909088b39003c9ef | wangchuan |4 |personal_login/js/components/bind-mail-modal.js; personal_login/js/components/user-form.js; personal_login/js/webLogin.js; personal_login/webLogin.html |     web个人桌面登录
  a7b9cb73542165014cac6eb2f31baba2a5fdc691 | wangchuan |0 | |     客户端重新打包
  2a7dc514de6e8c2b828897cd2676c238e1d2befe | zagger |4 |js/vdi/auth/controllers.js; views/vdi/common/account-password-modify.html; views/vdi/common/time-modify-pwd.html; views/vdi/login.html |     添加定时修改密码逻辑
  79db70fc2c358dbc5b000fb98b90b29d541978d7 | zagger |1 |views/vdi/app-menu.html |     恢复菜单显示代码
  1dfea75125abfaf55813b349dbfbe7b3a910db71 | jiazhihao |0 | |     添加客户端包
  9c215df4acb16275487c671d7532d0e9d60491e4 | jiazhihao |0 | |     build
  7261492d6558289b5c5fddd3beeca659912a8b65 | jiazhihao |1 |b3b483041 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc        merge
  e82fd02621f88926eb03f19b1a39c7f37aacd385 | wangchuan |2 |personal_login/js/components/pwd-expired-tip-modal.js; views/vdi/dialog/security/system/add_edit_security_system.html |     代码优化
  b3b48304196d4f9dc9b011d9c11a5dd45cc6dc0e | wangchuan |2 |js/vdi/security/system/controller.security.system.js; views/vdi/security/system/security_system.html |     系统安全：禁止关闭策略
  9481ebd183cb479d3f1ae55104a1254977021aa8 | zagger |0 | |     build
  e7f174e63a1a4151d818a213ce1568f3c2424107 | zagger |1 |views/vdi/app-menu.html |     显示-菜单展开和收缩错误修复
  6ea94a448222ddf4e54989fdcee2049a5b2a37f7 | zagger |1 |921174043 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  92117404360bc02790ae072e6d72ce869f943709 | zagger |2 |img/new_login_icon/header_bg.png; js/vdi/auth/controllers.js |     强制绑定邮箱-回显邮箱地址
  52eb47aefaa7310406b7a5ec4d562c57a72554f0 | wangchuan |0 | |     提交vdi客户端资源包
  eb0c5d5f59d0f1430fd369e3bec4d0607aa16686 | zagger |0 | |     build
  4052445b97019e9cb8be02206961fa09821b11cc | zagger |1 |88e8431cc |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  88e8431cc4c50de1b31419f743dea54c3b971b29 | zagger |0 | |     build
  bd9f5efd53496dc226de04fa94b037b4bce3682a | zagger |3 |js/vdi/system/system-settings.js; js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     解绑认证服务器url修改    导入帐号-传参问题``
  ea9266292a5aa66e85eaf05699bcf00f30af77a7 | zhangyao |7 |js/vdi/security/common.js; js/vdi/security/desktop.js; js/vdi/system/system-log.js; js/vdi/system/system-logo-settings.js; js/vdi/utils/ui.js; views/vdi/security/desktop.html; views/vdi/system/set-general.html |     修改共享文档上的问题
  34ebd2bc10611789edbfb748e376b584f7c26994 | zagger |1 |4628281d5 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  4628281d514fa464b3f6e6a385e5a3f8f543a2d4 | zagger |1 |js/vdi/monitor/alarm.js |     告警信息获取
  bcde666afb3abc80c952319b9927655f1fa473d7 | zhangyao |1 |85f64b6c4 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  85f64b6c4fe5c56799303bdb8ef1106970e0b460 | zhangyao |3 |js/vdi/security/desktop.js; js/vdi/system/system-log.js; views/vdi/dialog/system/backup-log-config.html |     备份日志去掉 请选择
  7d397c209fcfe0a7579c35ddc2b92d160b6a1b18 | zagger |0 | |     built
  2d8ce4b6d1af56b5b2eb08b0dbc5984cc3a7df3c | zagger |1 |742fc3c85 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  742fc3c858c5ac111d46a1f6526909423ee0e772 | zagger |3 |js/vdi/user/admin-user.js; views/vdi/user/admin.html; views/vdi/user/uaa.html |     zicebugs
  8dd38d6ec3d6f5f30388dea020a7bdebfe55f3ba | wangchuan |1 |cfad25112 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  d7747c59227e09123908622aaeb13c4f1ffc8627 | wangchuan |2 |js/vdi/system/recycle/controller.system.recycle.js; personal_login/js/components/pwd-expired-tip-modal.js |     代码优化
  cfad251120e55fd2f942aae3735fb40af918b6a7 | zagger |0 | |     build
  6cbfbf6c98b8a30d035dc5c7074407b3a8c728dc | zagger |1 |js/vdi/monitor/alarm.js |     导出下载
  0acbab5778eb8cf4503ac1e4eedd923a154b64e5 | zagger |0 | |     build
  f2980c1b711fe900c5f8be5fb6bcf3c72f49a14a | zagger |1 |5c7bc037c |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  5c7bc037cd1c3aceb883f8fa46b0d27f710b8a11 | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     编辑邮箱接口添加
  a087b0db0a5956453567e3e34977e108c213aa90 | zhangyao |1 |2f6f84f4e |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2f6f84f4eb71ccd3bafca1cd938e2e6f7416ae3e | zhangyao |4 |js/vdi/desktop/personal.js; js/vdi/security/common.js; js/vdi/security/shared.js; views/vdi/security/group.html |     修复自测发现的问题
  a6e0631cae2f2b0d4cfa6d4c58af8ef8beac5251 | wangchuan |1 |b8e82d09d |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  b8e82d09dbcf1ebd52246d26318c4a70061ee236 | zagger |1 |86f3810f2 |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  86f3810f2d9ff3dd5797a133e4f10a72beb4cb3c | zagger |2 |js/vdi/forget.js; js/vdi/user/uaa.js |     url地址显示问题
  cf66b32e39c140d0b72c1162ab5ca79e9915db05 | zhangyao |1 |b88c2842b |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  b88c2842be2abc257979a26328debcca1b340e9a | zhangyao |12 |js/vdi/bootstrap.js; js/vdi/config/http.js; js/vdi/desktop/personal.js; js/vdi/security/common.js; js/vdi/security/desktop.js; js/vdi/security/group.js; js/vdi/security/shared.js; views/vdi/dialog/security/manage_desktops_for_strategy.html; views/vdi/dialog/security/new_group.html; views/vdi/dialog/security/new_rule.html; views/vdi/security/desktop.html; views/vdi/security/group.html |     自测问题修复
  127f4979d2037679736a661cfeb62f8df96661b8 | zagger |0 | |     build
  88390c68ca7e8b5b344641c2c734c82bdc124524 | zagger |1 |js/vdi/scheduler/disk.controller.js |     网盘传递参数bug
  5b8e82c3c146b9575fa75a8229d29e531368fbd2 | zhangyao |1 |c5c31c6cc |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  c5c31c6cc8dba9fbe99cd51f33ee355e0393cc59 | zhangyao |9 |includes/pagination.html; js/vdi/security/desktop.js; js/vdi/system/system-log.js; js/vdi/vdi.js; views/vdi/dialog/desktop/personal_detail.html; views/vdi/dialog/desktop/personal_download_video.html; views/vdi/help/deploy.html; views/vdi/system/admin-log.html; views/vdi/system/user-log.html |     自测问题修复
  9b904fca04334fd87a8ab367e41fbc865b850a81 | zagger |0 | |     build
  a75ddded10ab9ee72644628865a963c985f5b980 | zagger |2 |js/vdi/monitor/alarm.js; views/vdi/dialog/monitor/set-keep-time.html |     告警信息-补缺少接口-获取配置接口
  2c88d24d442256dee70df8dfbe4ff414bb0d82ee | zagger |1 |js/vdi/user/uaa.js |     普通帐号修改邮箱-报错
  c13c04b9c37150097225613ab4cafb6b23d3f734 | wangchuan |3 |personal_login/css/webLogin.css; personal_login/js/webLogin.js; personal_login/webLogin.html |     web个人桌面:样式
  52437baf4eb4f172e5ba9b43523f461eea662d4a | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     添加重置密码对邮箱的判断，没有邮箱无法重置密码
  0a98f4d4b96795f72fb11bcccc8d3fa03bae5a60 | wangchuan |7 |personal_login/css/webLogin.css; personal_login/js/components/bind-mail.js; personal_login/js/components/mail-after-login-modal.js; personal_login/js/components/modify-default-pwd-modal.js; personal_login/js/components/password-expired-tip.js; personal_login/js/webLogin.js; personal_login/webLogin.html |     web个人桌面登录:代码优化
  0d21c5124415c503abf40acd7add093ae82f918b | wangchuan |1 |personal_login/selectDesk.html |     恢复文件历史
  1595948e7c608fb1b803c6cdd747d3d1d6aaf0a7 | zagger |0 | |     build代码
  2d8007b6504c300ffca44b8a720137502ef92f2e | zagger |1 |views/vdi/user/admin.html |     解决管理帐号普通管理员无法选中admin用户的问题
  4b00c23f5dbbc21e9db140918e7644d96470cb9a | zagger |1 |js/vdi/menus.js |     解决网盘菜单没有显示wenti
  ca35d42e1587cededba48babe3ea1f4469fccc48 | zagger |2 |js/vdi/bootstrap.js; js/vdi/config/http.js |     还原前端跨域问题代码
  21386f3376c792f50f70adb550f72eaf0984dc82 | zagger |1 |9a921eaeb |     Merge branch '5.1.4-vpc' of http://bbt.os-easy.com/hanxiaoxiang/ngconsole into 5.1.4-vpc
  9a921eaebad273ef05a241a8c32d1a95d277dd79 | zagger |5 |js/vdi/user/uaa.js; views/vdi/dialog/user/user_admin_edit_email.html; views/vdi/dialog/user/user_common_department_add.html; views/vdi/dialog/user/user_common_department_modify.html; views/vdi/user/admin.html |     1.部门名称不能有空格    2.管理帐号-loading问题
  4b3f0d9b4a23af14ca8474d454045b26d503ec83 | wangchuan |1 |1f3181ced |     Merge branch '5.2.0-vpc' into 5.1.4-vpc
  1f3181ced3e92c40873a091fcff239688f687e06 | wangchuan |1 |4d81cba9d |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  4d81cba9d05b4a2b17ee16d19fb803c148cd9efb | zhangyao |8 |js/vdi/bootstrap.js; js/vdi/config/http.js; js/vdi/desktop/personal.js; js/vdi/help/quick-deploy.js; js/vdi/security/common.js; js/vdi/security/group.js; views/vdi/dialog/security/manage_desktops_for_strategy.html; views/vdi/help/deploy.html |     根据自测用例自测
  e95bddce2f8569301d092e95127e74add697ba2a | zhangyao |5 |js/vdi/desktop/personal.js; js/vdi/init.js; js/vdi/plan/api.js; js/vdi/resource/api.js; js/vdi/template/api.js |     修复自测问题
  c7039bffe5cd21e604bbf7eb22482738da61be87 | zagger |4 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js; views/vdi/dialog/user/admin_uaa_import.html; views/vdi/dialog/user/common_uaa_import.html |     导入帐号-细节处理
  e1c7dcc454804809a4386a25b816b9e2274882f4 | zagger |3 |js/vdi/template/system-iso.js; js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     导入帐号-分组信息改变，触发change事件处理
  e016160fa061558dba34ee85f642531271d603ce | wangchuan |1 |847d70cbe |     Merge branch '5.2.0-vpc' into 5.1.4-vpc
  5ab6fa992e2d8c67315cf8b0f0fe2c42f4b8955c | zagger |1 |js/vdi/template/system-iso.js |     添加iso移动至接口
  b8a7f246a61af0837c54fdddf100ec5340d16cd7 | zagger |0 | |     添加权限返回数据-以便联调
  3a22b5647f8376d2f3d95b9164abd15d472e0ff1 | zagger |2 |js/vdi/user/role.js; views/vdi/user/role.html |     默认角色不能删除的问题
  03152d2c0effafdfdb751b31594968d9f3501c41 | zagger |1 |92f69e33b |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  92f69e33be9cc92271a63ae08b8a3f98679630e1 | zagger |1 |js/vdi/user/uaa.js |     分页参数传错了
  3b77e98455bf3a76d5753433ffd3766fbf8cf710 | zhangyao |1 |847d70cbe |     xMerge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  847d70cbe5e53afb1e7a2838bc4e033aadef83ac | zhangyao |2 |views/vdi/system/admin-log.html; views/vdi/system/user-log.html |     日志主机字段修改为 host
  372b073e354b1e937675cbc850d7a8704045d9b4 | zhangyao |0 | |     build
  83f0b07a3be47d4c76d4dba656821bdada90269f | zhangyao |1 |ea28cfd75 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ea28cfd75aedd53245f9971314968ce1c7be1d9a | zhangyao |5 |js/vdi/desktop/personal.js; js/vdi/security/group.js; js/vdi/system/system-log.js; views/vdi/dialog/desktop/personal_detail.html; views/vdi/security/group.html |     fix bugs
  bbd819cb0597385e9933299d46ba098f6e69dce7 | wangchuan |0 | |     build
  7083d9c539cab50e7dcc3a8c9495e4fad43998be | wangchuan |1 |personal_login/js/webLogin.js |     修改初始密码url
  1b7e676b71c307150e2b8412dc91777c8bd5d2c9 | wangchuan |1 |bfbc72635 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  39a20c75dbdefb911e7118093699b47f43390a8e | wangchuan |4 |personal_login/js/components/user-form.js; personal_login/js/rules.js; personal_login/js/validator.js; personal_login/js/webLogin.js |     web桌面:代码优化
  bfbc72635f090f51a3d77d60fae851b984927b50 | wangchuan |1 |84a4f3492 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  696e9332689a593b1cffa4b765749fcb539b5de8 | wangchuan |4 |personal_login/css/webLogin.css; personal_login/js/components/pwd-complexity-tooltip.js; personal_login/js/webLogin.js; personal_login/views/user-form.html |     web桌面：bug
  84a4f3492fe8538aa0a54837eb4907d15c0ac73b | wangchuan |1 |46d7a865d |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  f2da45bc6a06fab138dfa556adb0ab4717baff4b | wangchuan |1 |personal_login/js/components/user-form.js |     web桌面：bug修改
  693e875cf39ca3a40e391160071202b95b940494 | wangchuan |1 |personal_login/js/webLogin.js |     web桌面：bug修改
  46d7a865d221fcd00d36b568bf0a0c849ac95d38 | zhangyao |1 |ada7af1d0 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  ada7af1d083f81deba14d9f590392abe48002deb | zhangyao |10 |js/vdi/desktop/personal.js; js/vdi/security/desktop.js; js/vdi/security/shared.js; js/vdi/system/system-log.js; views/vdi/desktop/personal.html; views/vdi/dialog/desktop/personal_delete.html; views/vdi/dialog/desktop/personal_detail.html; views/vdi/dialog/security/manage_desktops_for_strategy.html; views/vdi/dialog/security/new_desktop_strategy.html; views/vdi/dialog/system/backup-log-config.html |     fix bugs
  0719136371c447a0a62e4632ea36741584f484c4 | wangchuan |1 |716a6efe2 |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  3c37dcdd94b43efa82e016975472e0177aaee98c | wangchuan |6 |personal_login/js/components/mail-after-login-modal.js; personal_login/js/components/password-expired-tip.js; personal_login/js/components/pwd-complexity-tooltip.js; personal_login/js/components/user-form.js; personal_login/js/webLogin.js; personal_login/webLogin.html |     web桌面登录：代码优化
  716a6efe279b1f33085c91611cf8413afca7ddd5 | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     重置密码
  bc1b0f2c5db1bb7e0bc961f450f018f9d79be61f | zhangyao |3 |js/vdi/utils/ui.js; js/vdi/vdi.js; views/vdi/common/account-password-modify.html |     修复修改密码的校验问题
  062ff63c4d359252c2bc68c82a431f2217539e83 | zagger |1 |2f6a1009d |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2f6a1009d3e4891a1b52e27e2d90a8d39bc79046 | zagger |1 |views/vdi/app-header.html |     解除uaa禁用密码修改功能
  fc6ca8a7b73bcd2ce523fef1fd72b2ad46d574e6 | zhangyao |1 |ngconsole-webpack-plugin.js |     资源的处理过程增加魔法替换功能
  d06f3254983c598df1962991d5be7ed3904d335e | zagger |1 |js/vdi/user/admin-user.js |     build
  d9be9521b3dff8dcd856db40dd286b09fd6015fa | zagger |1 |package-lock.json |     build
  e0c45fa46681db5fbe25334fc66a20eb5abfda72 | zagger |1 |0ef7cca6b |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  0ef7cca6bb481cbd9b63e13aa33d4908a55fbc3a | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     uaa_id
  97a3a6126b6bbd16b3306cc46e0e127c9e7b0518 | wangchuan |0 | |     build
  e3994d24901aa09d2fbf239b0dd7313c174a025e | wangchuan |0 | |     假数据
  64ef49795cd6a4e9dba3c1e9eda9be6343319cb1 | wangchuan |1 |js/vdi/security/client/controller.security.client.js |     终端安全：bug
  e8673848c4bc0b58d5228390dc5d37349ff5aeba | wangchuan |1 |303a90ef6 |     Merge branch '5.2.0-vpc' into 5.1.4-vpc
  303a90ef62c178caf5425f76355cdfc8d4f124a3 | wangchuan |1 |966f7ccd9 |     合并5.2.0-vpc到5.1.4-vpc
  966f7ccd927d0e6deac1cea4142280ca0f95488a | zhangyao |1 |5f0bd32aa |     Merge branch '5.1.4-vpc' of e.coding.net:mystorp/ngconsole into 5.1.4-vpc
  5f0bd32aa689bfb8e6cf11e7295925775c8c2e60 | zagger |8 |js/vdi/auth/controllers.js; js/vdi/scheduler/disk.controller.js; js/vdi/user/admin-user.js; js/vdi/user/role.js; js/vdi/utils/user.js; js/vdoi/main.js; views/vdi/app-header.html; views/vdi/user/admin.html |     1.添加dms权限配置带啊2.网盘添加排除本地帐号的过滤参数3.管理帐号添加对admin帐号的特殊处理
  4af52c41cb5fc0cd5952bdad0187b910ad3efb77 | wangchuan |1 |views/vdi/resource/storage/storage.html |     恢复网盘存储
  3437158385efa243c74e0a6629957956162f6351 | wangchuan |3 |personal_login/js/components/user-form.js; personal_login/js/rules.js; personal_login/js/webLogin.js |     web个人桌面:联调
  e3887866461dae4a731037a7f688f7c4d9e4fe37 | wangchuan |11 |personal_login/css/webLogin.css; personal_login/js/components/bind-mail.js; personal_login/js/components/mail-after-login-modal.js; personal_login/js/components/modify-default-pwd-modal.js; personal_login/js/components/user-form.js; personal_login/js/validator.js; personal_login/js/webLogin.js; personal_login/selectDesk.html; personal_login/views/associate-mail-modal.html; personal_login/views/user-form.html; personal_login/webLogin.html |     web个人桌面：联调
  64d187e366e4ba8d7294c9585134eb958a457da8 | zagger |0 | |     build for zice
  73d6f47f498e1ebc1fe32e8a9bab49fdcaac6dc0 | zagger |6 |js/vdi/auth/controllers.js; js/vdi/forget.js; js/vdi/user/admin-user.js; js/vdi/user/uaa.js; js/vdi/utils/user.js; views/vdi/dialog/user/admin_uaa_import.html |     帐号部门问题修改
  0979aa87c93ee7fbff2e01e43ad6a46b694ac56c | zagger |2 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js |     部门帐号-一键同步传参
  e7a2966e3632d50884887cabd5b4d7a20dfdbc75 | wangchuan |15 |js/vdi/utils/validator.js; personal_login/css/webLogin.css; personal_login/forgetPwdPage.html; personal_login/index.html; personal_login/js/components/mail-after-login-modal.js; personal_login/js/components/modify-default-pwd-modal.js; personal_login/js/components/pwd-complexity-tooltip.js; personal_login/js/components/user-form.js; personal_login/js/rules.js; personal_login/js/validator.js; personal_login/js/webLogin.js; personal_login/views/associate-mail-modal.html; personal_login/views/user-form.html; personal_login/webLogin.html; personal_login/webRegister.html |     web个人桌面：联调
  70aebb2fa38e9e0271bc8376bb377d1f967ef0be | wangchuan |1 |e85217dbe |     Merge remote-tracking branch 'base/5.1.4-vpc' into 5.1.4-vpc
  d631afad4041d3f99cb03f7b855108a63caa6397 | wangchuan |1 |views/vdi/dialog/template/template_imgManage.html |     提交到错误分支，恢复历史
  835fa003ac8b29c21ede9f4fefb387a4067735b6 | wangchuan |1 |views/vdi/dialog/template/template_imgManage.html |     接口返回更改
  39f1fa4632282834e49392168cdfaf5a77d28976 | wangchuan |2 |views/vdi/dialog/resource/pool/config_storage.html; views/vdi/dialog/resource/storage/new_storage.html |     桌面录屏存储设备
  e85217dbe42c5d530b13af17152b123718a239d1 | zagger |4 |js/vdi/auth/controllers.js; js/vdi/forget.js; js/vdi/utils/user.js; views/vdi/common/login-step2.html |     登录代码优化
  e2cef0bbeabbd1b643e48665793cc015b0a17a0b | wangchuan |1 |js/vdi/resource/storage/controllers.js |     提交到错误分支，恢复历史
  466757b7b9078d0ae12c36eb3b990238ca0430e4 | wangchuan |1 |js/vdi/resource/storage/controllers.js |     分布式存储：解决bug，14880
  f69a1487e86c6e56c213ab0dc0a56ced2513bde6 | zagger |1 |js/vdi/spice.js |     还原端口号
  3a036a5d34d86445c0f0973c79c16797a7a9487a | zagger |0 | |     端口号修改测试
  95e4c0b50e45d51fdaa3873454462bb336e4262b | zagger |2 |js/vdi/monitor/controllers.js; js/vdi/spice.js |     端口号修改测试
  75028b07d12a7070a4238307614437f6f61358e4 | zagger |10 |desktopScreenshot.html; js/vdi/bootstrap.js; js/vdi/spice.js; js/vdi/system/system-log.js; js/vdi/template/browser.openVNC.js; js/vdi/utils/user.js; personal_login/js/webLoginSpice.js; ssh_terminal/terminal.js; views/idv/desktop/desktopScreenshot.html; views/voi/desktop/desktopScreenshot.html |     打包测试接口统一
  7178aec58673c4a9086b24dd2033d42a31fb45de | zagger |1 |.gitignore |     添加.gitignore
  61b9be9382140293484977fd5f206f2969a85007 | zagger |0 | |     打包后端验证问题
  f38e476716de773a4090ccf26856f70ed9561cbc | zagger |1 |js/vdi/utils/user.js |     验证码laoding问题
  f9fd22772dcc4afdfa184612548dbb31fc70a722 | zagger |4 |js/vdi/auth/controllers.js; js/vdi/forget.js; js/vdi/utils/user.js; views/vdi/common/login-step2.html |     登录接口联调
  d399feaaed3083cf7f9a7e27989d7a3e42336747 | wangchuan |2 |js/vdi/utils/validator.js; package.json |     通用form验证
  5773e0e249980b349d7bfa3795aa81e3050f4b51 | zagger |3 |js/vdi/monitor/policy.js; js/vdi/system/system-settings.js; views/vdi/system/set-general.html |     配置邮箱服务器-前端代码完成
  eaa54e96b0efdb760744dd809a7b7c02ea196259 | zagger |2 |js/vdi/monitor/policy.js; views/vdi/dialog/monitor/config.html |     告警信息+新增认证服务器离线
  045d0ee3d18c03473a752de22df0141f6bdf5df1 | zagger |4 |js/vdi/user/admin-user.js; js/vdi/user/uaa.js; views/vdi/user/admin.html; views/vdi/user/uaa.html |     帐号部门接口文档给-接口联调
  e4f4020116e838df69a40991db2c071a743e1028 | wangchuan |1 |js/vdi/terminal/controller.terminal.js |     终端管理：终端设置，去掉H264、磁盘共享到桌面联调
  d6a895aec2f37e9335c9122e2f1b20d50cc8d5b9 | wangchuan |0 | |     终端安全：假数据
  cbbac9ddd2976ef478d1c7de9da264edfa64f3e3 | wangchuan |2 |js/vdi/security/client/controller.security.client.js; views/vdi/dialog/security/client/manage_security_client.html |     终端安全：联调
  0470e428c4f60464f85ca90b723385d84238a811 | wangchuan |1 |js/vdi/security/system/controller.security.system.js |     系统安全：联调
  69d3cc3e6c3b65889d907e0349ad82d14ad19408 | wangchuan |0 | |     系统安全：假数据
  04602c746448d9c1d723a32df1f6d9f0d798bed7 | wangchuan |1 |views/vdi/security/system/security_system.html |     系统安全:bug修改
  b1ed18ce7a9168c7d2e0b4c6416ddfd77d29db95 | wangchuan |1 |js/vdi/system/recycle/controller.system.recycle.js |     回收站：代码优化
  b2c185011b37ad5036a6a18988f7eec8d8acdd4b | wangchuan |3 |js/vdi/security/system/controller.security.system.js; views/vdi/dialog/security/system/add_edit_security_system.html; views/vdi/security/system/security_system.html |     系统安全：联调
  1e9703dcee5b6d25717db97ac7d536da6fcd9aa2 | wangchuan |0 | |     终端安全：假数据
  50794e7038bd7795c5772962beebddb7ecc02acd | wangchuan |0 | |     终端安全：假数据
  16052b7eb7e834325c3c3c740df4511d18a46abb | wangchuan |1 |css/your_style.css |     禁用下的input样式
  343c0e6ee279b06e78564445c7f0c7b83328e897 | wangchuan |2 |js/vdi/security/client/controller.security.client.js; views/vdi/dialog/security/client/manage_security_client.html |     终端安全：联调
  f9d64d70d62ab9b3980a67cbfc981f7af9e7a89f | wangchuan |1 |js/vdi/security/client/controller.security.client.js |     终端安全：联调
  79c82daee5d835de3ce5dba3101ac30501740895 | zagger |2 |js/vdi/auth/controllers.js; js/vdi/utils/user.js |     登录之后弹弹窗临时解决
  80e7f16416ab321d4132fb0885b012a151f5d7be | zagger |4 |forget-pwd.html; js/vdi/auth/controllers.js; js/vdi/forget.js; views/vdi/common/force-modify-pwd.html |     强制修改密码接口+忘记密码，接口代码
  23109dd74448876a83c1250f762c0a0c3db666c5 | zagger |7 |css/your_style.css; js/vdi/auth/controllers.js; js/vdi/scheduler/disk.controller.js; js/vdi/utils/user.js; views/vdi/common/force-modify-pwd.html; views/vdi/common/login-step2.html; views/vdi/login.html |     登录初次联调-走完-登录第一步到第二部，登录后是否弹窗----未完成：密令-验证码-走流程
  988e08ecee8369745445b1590e41b778d87124f8 | zagger |2 |js/vdi/scheduler/disk.controller.js; views/vdi/scheduler/disk.html |     网盘帐号部门-添加管理帐号和域账号
  64d2bcd4968b3071463758e97d2ee8205ea494b5 | zagger |2 |js/vdi/monitor/controllers.js; views/vdi/monitor/host.html |     图标样式设置
  07ae4bf6182d2cfce1b1229e26af3fc82af7b536 | zagger |2 |js/vdi/monitor/common.js; js/vdi/monitor/controllers.js |     监控-代码整理
  3d64ba4ae4b4391e43a6bd50aad74fcd09fcdfc7 | zagger |1 |js/vdi/monitor/controllers.js |     监控-定时器处理
  b40bb840589de2ffcf1232a576d6dd4c570dacb5 | zagger |1 |2bc007309 |     Merge branch '5.1.4-vpc' of http://172.16.203.254/hanxiaoxiang/ngconsole into 5.1.4-vpc
  2bc0073097d0bb8337a02d4a4750007dedff14d7 | zagger |2 |js/vdi/monitor/controllers.js; views/vdi/monitor/host.html |     监控-画图代码
  6c2ff9d30065b3bc0775496bc9acbfe45f84be80 | zagger |1 |js/vdi/monitor/controllers.js |     监控-时间联调
  e1e69a706e849cb95377576352782db7df8941b2 | zhangyao |1 |views/vdi/system/iso.html |     修复安装包下载链接问题
  3b53f894ec0a91291fdff22768c38d6ba14985e2 | zhangyao |1 |6f6bdfc80 |     fix conflicts
  6f6bdfc80618c04cb280fd806c1aa4dc88fe3772 | zhangyao |0 | |     build
  d37c874fd549fbbe9ce921738ac934f66a1cade5 | zhangyao |1 |js/vdi/terminal/controller.terminal.js |     修复手动排序报错
  0ebe948fde7124dadeb642531a6e5a2eb95fd52b | zhangyao |1 |js/vdi/terminal/controller.terminal.js |     终端自动排序界面，默认不自动按序号排序
  efdba7019a2eed23cb33c45cc9a836cba77d0042 | zhangyao |1 |js/vdi/terminal/controller.terminal.js |     适配自动排序需求变更
  4 : 40
   : 1
  5 : 26
  6 : 18
  7 : 15
  8 : 9
  9 : 5
  10 : 4
  11 : 2
  21 : 1
  12 : 2
  13 : 2
  0 : 194
  14 : 1
  23 : 1
  1 : 610
  15 : 2
  2 : 150
  16 : 1
  3 : 64
  
  
- [vim](https://github.com/KiteAB/.config/tree/master/zsh)

	- w!!  

	- jj <Esc>

	- enter

	- enter+c

	- enter+d

	- v+%

	- visual模式下，S"

	- cs"'

	- c-n

	- v选中后，再按c-n

	- n/N下一个和上一个光标

	- q skip当前选中的

	- c-up c-down 自由选中多个光标

	- coc.vim

		- Language server protocol
微软开发的 让任何编辑器不限编程语言都能享受统一补全体验的协议

		- 需要安装nodejs

			- npm i -g neovim yarn

		- coc也需要安装插件 

			- CocInstall coc-json

		- [coc-settings.json](https://github.com/neoclide/coc.nvim/blob/master/data/schema.json)

		  {
		   |   "$schema": "http://json-schema.org/draft-07/schema#",
		   |   "description": "Configuration file for coc.nvim",
		   |   "additionalProperties": false,
		   |   "definitions": {
		   |     "languageServerBase": {
		   |       "type": "object",
		   |       "properties": {
		   |         "enable": {
		   |           "type": "boolean",
		   |           "default": true
		   |         },
		   |         "cwd": {
		   |           "type": "string",
		   |           "default": "",
		   |           "description": "Working directory of languageserver, absolute path or relative to workspace folder, use workspace root by default"
		   |         },
		   |         "disableDynamicRegister": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Disable dynamic registerCapability feature for this languageserver to avoid duplicated feature regstration."
		   |         },
		   |         "disableWorkspaceFolders": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Disable workspaceFolders feature for this languageserver."
		   |         },
		   |         "disableSnippetCompletion": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Disable completion snippet feature for this languageserver, the languageserver may not respect it."
		   |         },
		   |         "disableDiagnostics": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Disable handle diagnostics for this languageserver."
		   |         },
		   |         "disableCompletion": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Disable completion feature for this languageserver."
		   |         },
		   |         "formatterPriority": {
		   |           "type": "number",
		   |           "default": 0,
		   |           "description": "Priority of this languageserver's fomatter."
		   |         },
		   |         "env": {
		   |           "type": "object",
		   |           "default": null,
		   |           "description": "Environment variables for child process."
		   |         },
		   |         "stdioEncoding": {
		   |           "type": "string",
		   |           "default": "utf8",
		   |           "description": "Encoding used for stdio of child process."
		   |         },
		   |         "rootPatterns": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Root patterns used to resolve rootPath from current file, default to workspace root",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "requireRootPattern": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "If true, doesn't start server when root pattern not found."
		   |         },
		   |         "ignoredRootPaths": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Absolute root paths that language server should not use as rootPath, higher priority than rootPatterns.",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "filetypes": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Supported filetypes, add * in array for all filetypes.",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "additionalSchemes": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Additional uri schemes, default schemes including file & untitled.",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "revealOutputChannelOn": {
		   |           "type": "string",
		   |           "default": "never",
		   |           "description": "Configure message level to show the output channel buffer",
		   |           "enum": ["info", "warn", "error", "never"]
		   |         },
		   |         "progressOnInitialization": {
		   |           "type": "boolean",
		   |           "default": true,
		   |           "description": "Enable progress report on languageserver initialize."
		   |         },
		   |         "initializationOptions": {
		   |           "type": "object",
		   |           "default": {},
		   |           "description": "initializationOptions passed to languageserver"
		   |         },
		   |         "settings": {
		   |           "type": "object",
		   |           "default": {},
		   |           "description": "Settings of languageserver"
		   |         },
		   |         "trace.server": {
		   |           "type": "string",
		   |           "default": "off",
		   |           "enum": ["off", "messages", "verbose"],
		   |           "description": "Trace level of communication between server and client"
		   |         }
		   |       }
		   |     },
		   |     "languageServerSocket": {
		   |       "type": "object",
		   |       "allOf": [{ "$ref": "#/definitions/languageServerBase" }],
		   |       "required": ["port", "filetypes"],
		   |       "additionalProperties": false,
		   |       "properties": {
		   |         "port": {
		   |           "type": "integer",
		   |           "description": "Port number of socket server"
		   |         },
		   |         "host": {
		   |           "type": "string",
		   |           "default": "127.0.0.1",
		   |           "description": "Host of server"
		   |         },
		   |         "disableWorkspaceFolders": {},
		   |         "disableSnippetCompletion": {},
		   |         "disableDynamicRegister": {},
		   |         "disableDiagnostics": {},
		   |         "disableCompletion": {},
		   |         "formatterPriority": {},
		   |         "enable": {},
		   |         "rootPatterns": {},
		   |         "requireRootPattern": {},
		   |         "ignoredRootPaths": {},
		   |         "filetypes": {},
		   |         "additionalSchemes": {},
		   |         "revealOutputChannelOn": {},
		   |         "progressOnInitialization": {},
		   |         "initializationOptions": {},
		   |         "settings": {},
		   |         "stdioEncoding": {},
		   |         "trace.server": {}
		   |       }
		   |     },
		   |     "languageServerModule": {
		   |       "type": "object",
		   |       "allOf": [{ "$ref": "#/definitions/languageServerBase" }],
		   |       "required": ["module", "filetypes"],
		   |       "additionalProperties": false,
		   |       "properties": {
		   |         "module": {
		   |           "type": "string",
		   |           "default": "",
		   |           "description": "Absolute path of javascript file, should works in IPC mode"
		   |         },
		   |         "args": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Extra arguments of module",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "runtime": {
		   |           "type": "string",
		   |           "default": "",
		   |           "description": "Absolute path of node runtime."
		   |         },
		   |         "execArgv": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Argv passed to node when using module, normally used for debugging, ex: [\"--nolazy\", \"--inspect-brk=6045\"]",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "transport": {
		   |           "type": "string",
		   |           "default": "ipc",
		   |           "description": "Transport kind used by server, could be 'ipc', 'stdio', 'socket' and 'pipe'",
		   |           "enum": ["ipc", "stdio", "socket", "pipe"]
		   |         },
		   |         "transportPort": {
		   |           "type": "integer",
		   |           "description": "Port number used when transport is 'socket'"
		   |         },
		   |         "cwd": {},
		   |         "env": {},
		   |         "enable": {},
		   |         "disableDynamicRegister": {},
		   |         "disableWorkspaceFolders": {},
		   |         "disableSnippetCompletion": {},
		   |         "disableDiagnostics": {},
		   |         "disableCompletion": {},
		   |         "formatterPriority": {},
		   |         "rootPatterns": {},
		   |         "requireRootPattern": {},
		   |         "ignoredRootPaths": {},
		   |         "filetypes": {},
		   |         "additionalSchemes": {},
		   |         "revealOutputChannelOn": {},
		   |         "progressOnInitialization": {},
		   |         "initializationOptions": {},
		   |         "stdioEncoding": {},
		   |         "settings": {},
		   |         "trace.server": {}
		   |       }
		   |     },
		   |     "languageServerCommand": {
		   |       "type": "object",
		   |       "required": ["command", "filetypes"],
		   |       "allOf": [{ "$ref": "#/definitions/languageServerBase" }],
		   |       "additionalProperties": false,
		   |       "properties": {
		   |         "command": {
		   |           "type": "string",
		   |           "default": "",
		   |           "description": "Executable in $PATH to start languageserver, should not used with module"
		   |         },
		   |         "args": {
		   |           "type": "array",
		   |           "default": [],
		   |           "description": "Arguments of command",
		   |           "items": {
		   |             "type": "string"
		   |           }
		   |         },
		   |         "detached": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Detach the languageserver process"
		   |         },
		   |         "shell": {
		   |           "type": "boolean",
		   |           "default": false,
		   |           "description": "Use shell for process"
		   |         },
		   |         "cwd": {},
		   |         "env": {},
		   |         "enable": {},
		   |         "disableDynamicRegister": {},
		   |         "disableWorkspaceFolders": {},
		   |         "disableSnippetCompletion": {},
		   |         "disableDiagnostics": {},
		   |         "disableCompletion": {},
		   |         "formatterPriority": {},
		   |         "rootPatterns": {},
		   |         "requireRootPattern": {},
		   |         "ignoredRootPaths": {},
		   |         "filetypes": {},
		   |         "additionalSchemes": {},
		   |         "revealOutputChannelOn": {},
		   |         "progressOnInitialization": {},
		   |         "initializationOptions": {},
		   |         "stdioEncoding": {},
		   |         "settings": {},
		   |         "trace.server": {}
		   |       }
		   |     }
		   |   },
		   |   "properties": {
		   |     "http.proxy": {
		   |       "type": "string",
		   |       "default": "",
		   |       "pattern": "^https?://([^:]*(:[^@]*)?@)?([^:]+|\\[[:0-9a-fA-F]+\\])(:\\d+)?/?$|^$",
		   |       "description": "The proxy setting to use. If not set, will be inherited from the `http_proxy` and `https_proxy` environment variables."
		   |     },
		   |     "http.proxyStrictSSL": {
		   |       "type": "boolean",
		   |       "description": "Controls whether the proxy server certificate should be verified against the list of supplied CAs",
		   |       "default": true
		   |     },
		   |     "http.proxyAuthorization": {
		   |       "type": ["null", "string"],
		   |       "description": "The value to send as the `Proxy-Authorization` header for every network request.",
		   |       "default": null
		   |     },
		   |     "http.proxyCA": {
		   |       "type": "string",
		   |       "description": "CA (file) to use as Certificate Authority",
		   |       "default": null
		   |     },
		   |     "npm.binPath": {
		   |       "type": "string",
		   |       "default": "npm",
		   |       "description": "Command or absolute path to npm or yarn."
		   |     },
		   |     "suggest.enablePreselect": {
		   |       "type": "boolean",
		   |       "description": "Enable preselect feature of LSP, only works on neovim",
		   |       "default": false
		   |     },
		   |     "suggest.maxPreviewWidth": {
		   |       "type": "number",
		   |       "default": 80,
		   |       "description": "Maximum width of floating preview window."
		   |     },
		   |     "suggest.enablePreview": {
		   |       "type": "boolean",
		   |       "description": "Add preview option to completeopt, default: false.",
		   |       "default": false
		   |     },
		   |     "suggest.floatEnable": {
		   |       "type": "boolean",
		   |       "description": "Enable floating window for documentation when possible.",
		   |       "default": true
		   |     },
		   |     "suggest.labelMaxLength": {
		   |       "type": "number",
		   |       "description": "Max length of abbr that shown as label of complete item.",
		   |       "default": 200
		   |     },
		   |     "suggest.detailMaxLength": {
		   |       "type": "number",
		   |       "description": "Max length of detail that should be shown in popup menu.",
		   |       "default": 100
		   |     },
		   |     "suggest.detailField": {
		   |       "type": "string",
		   |       "default": "preview",
		   |       "description": "Where to show the detail text of CompleteItem from LS.",
		   |       "enum": ["abbr", "menu", "preview"]
		   |     },
		   |     "suggest.autoTrigger": {
		   |       "type": "string",
		   |       "default": "always",
		   |       "description": "How should completion be triggered",
		   |       "enum": ["always", "trigger", "none"]
		   |     },
		   |     "suggest.languageSourcePriority": {
		   |       "type": "number",
		   |       "default": 99,
		   |       "description": "Priority of language sources."
		   |     },
		   |     "suggest.numberSelect": {
		   |       "type": "boolean",
		   |       "description": "Input number to select complete item, works on neovim >= 0.4.0 only.",
		   |       "default": false
		   |     },
		   |     "suggest.disableKind": {
		   |       "type": "boolean",
		   |       "description": "Remove kind field from vim complete item.",
		   |       "default": false
		   |     },
		   |     "suggest.disableMenu": {
		   |       "type": "boolean",
		   |       "description": "Remove menu field from vim complete item.",
		   |       "default": false
		   |     },
		   |     "suggest.disableMenuShortcut": {
		   |       "type": "boolean",
		   |       "description": "Disable shortcut of completion source in menu.",
		   |       "default": false
		   |     },
		   |     "suggest.snippetIndicator": {
		   |       "type": "string",
		   |       "default": "~",
		   |       "description": "The character used in abbr of complete item to indicate the item could be expand as snippet."
		   |     },
		   |     "suggest.maxCompleteItemCount": {
		   |       "type": "number",
		   |       "default": 50,
		   |       "description": "Maximum number of complete items shown in vim"
		   |     },
		   |     "suggest.preferCompleteThanJumpPlaceholder": {
		   |       "type": "boolean",
		   |       "description": "Confirm completion instead of jump to next placeholder when completion is activated.",
		   |       "default": false
		   |     },
		   |     "suggest.fixInsertedWord": {
		   |       "type": "boolean",
		   |       "description": "Make inserted word replace word characters after cursor position.",
		   |       "default": true
		   |     },
		   |     "suggest.localityBonus": {
		   |       "type": "boolean",
		   |       "description": "Boost suggestions that appear closer to the cursor position.",
		   |       "default": true
		   |     },
		   |     "suggest.triggerAfterInsertEnter": {
		   |       "type": "boolean",
		   |       "description": "Trigger completion after InsertEnter, auto trigger should be 'always' to enable this option",
		   |       "default": false
		   |     },
		   |     "suggest.timeout": {
		   |       "type": "integer",
		   |       "default": 5000,
		   |       "minimum": 500,
		   |       "maximum": 15000,
		   |       "description": "Timeout for completion, in miliseconds."
		   |     },
		   |     "suggest.minTriggerInputLength": {
		   |       "type": "number",
		   |       "default": 1,
		   |       "description": "Mininal input length for trigger completion, default 1"
		   |     },
		   |     "suggest.triggerCompletionWait": {
		   |       "type": "integer",
		   |       "default": 100,
		   |       "minimum": 30,
		   |       "maximum": 500,
		   |       "description": "Wait time between text change and completion start, cancel completion when text changed during wait."
		   |     },
		   |     "suggest.echodocSupport": {
		   |       "type": "boolean",
		   |       "default": false,
		   |       "description": "When enabled, add function signature to user_data.signature to support echodoc.vim"
		   |     },
		   |     "suggest.acceptSuggestionOnCommitCharacter": {
		   |       "type": "boolean",
		   |       "default": false,
		   |       "description": "Controls whether suggestions should be accepted on commit characters. For example, in JavaScript, the semi-colon (`;`) can be a commit character that accepts a suggestion and types that character. Requires CompleteChanged event to work."
		   |     },
		   |     "suggest.noselect": {
		   |       "type": "boolean",
		   |       "description": "Not make vim select first item on completion start",
		   |       "default": true
		   |     },
		   |     "suggest.keepCompleteopt": {
		   |       "type": "boolean",
		   |       "description": "When enabled, completeopt is not overriden, auto completion will be disabled if completeopt doesn't have noinsert and noselect.",
		   |       "default": false
		   |     },
		   |     "suggest.lowPrioritySourceLimit": {
		   |       "type": "integer",
		   |       "minimum": 1,
		   |       "maximum": 100,
		   |       "description": "Max items count for source priority lower than 90."
		   |     },
		   |     "suggest.highPrioritySourceLimit": {
		   |       "type": "integer",
		   |       "minimum": 1,
		   |       "maximum": 100,
		   |       "description": "Max items count for source priority bigger than or equal to 90."
		   |     },
		   |     "suggest.removeDuplicateItems": {
		   |       "type": "boolean",
		   |       "description": "Remove completion items with duplicated word for all sources, snippet items are excluded.",
		   |       "default": false
		   |     },
		   |     "suggest.defaultSortMethod": {
		   |       "type": "string",
		   |       "description": "Default sorting behavior for suggested completion items.",
		   |       "default": "length",
		   |       "enum": ["length", "alphabetical", "none"]
		   |     },
		   |     "suggest.completionItemKindLabels": {
		   |       "type": "object",
		   |       "default": {},
		   |       "description": "Set custom labels to completion items' kinds.",
		   |       "properties": {
		   |         "text": { "type": "string" },
		   |         "method": { "type": "string" },
		   |         "function": { "type": "string" },
		   |         "constructor": { "type": "string" },
		   |         "field": { "type": "string" },
		   |         "variable": { "type": "string" },
		   |         "class": { "type": "string" },
		   |         "interface": { "type": "string" },
		   |         "module": { "type": "string" },
		   |         "property": { "type": "string" },
		   |         "unit": { "type": "string" },
		   |         "value": { "type": "string" },
		   |         "enum": { "type": "string" },
		   |         "keyword": { "type": "string" },
		   |         "snippet": { "type": "string" },
		   |         "color": { "type": "string" },
		   |         "file": { "type": "string" },
		   |         "reference": { "type": "string" },
		   |         "folder": { "type": "string" },
		   |         "enumMember": { "type": "string" },
		   |         "constant": { "type": "string" },
		   |         "struct": { "type": "string" },
		   |         "event": { "type": "string" },
		   |         "operator": { "type": "string" },
		   |         "typeParameter": { "type": "string" },
		   |         "default": { "type": "string" }
		   |       },
		   |       "additionalProperties": false
		   |     },
		   |     "suggest.invalidInsertCharacters": {
		   |       "type": "array",
		   |       "items": {
		   |         "type": "string"
		   |       },
		   |       "description": "Invalid character for strip valid word when inserting text of complete item.",
		   |       "default": [" ", "(", "<", "{", "[", "\r", "\n"]
		   |     },
		   |     "suggest.asciiCharactersOnly": {
		   |       "type": "boolean",
		   |       "description": "Suggest ASCII characters only",
		   |       "default": false
		   |     },
		   |     "diagnostic.enable": {
		   |       "type": "boolean",
		   |       "description": "Set to false to disable diagnostic display",
		   |       "default": true
		   |     },
		   |     "diagnostic.level": {
		   |       "type": "string",
		   |       "description": "Used for filter diagnostics by diagnostic severity.",
		   |       "default": "hint",
		   |       "enum": ["hint", "information", "warning", "error"]
		   |     },
		   |     "diagnostic.locationlistUpdate": {
		   |       "type": "boolean",
		   |       "description": "Update locationlist on diagnostics change, only works with locationlist opened by :CocDiagnostics command and first window of associated buffer.",
		   |       "default": true
		   |     },
		   |     "diagnostic.checkCurrentLine": {
		   |       "type": "boolean",
		   |       "description": "When enabled, show all diagnostics of current line if there are none at the current position.",
		   |       "default": false
		   |     },
		   |     "diagnostic.messageTarget": {
		   |       "type": "string",
		   |       "description": "Diagnostic message target.",
		   |       "default": "float",
		   |       "enum": ["echo", "float"]
		   |     },
		   |     "diagnostic.messageDelay": {
		   |       "type": "number",
		   |       "description": "How long to wait (in milliseconds) before displaying the diagnostic message with echo or float",
		   |       "default": 200
		   |     },
		   |     "diagnostic.refreshOnInsertMode": {
		   |       "type": "boolean",
		   |       "description": "Enable diagnostic refresh on insert mode, default false.",
		   |       "default": false
		   |     },
		   |     "diagnostic.displayByAle": {
		   |       "type": "boolean",
		   |       "description": "Use Ale for display diagnostics in vim, will disable coc for display diagnostics, restart required on change.",
		   |       "default": false
		   |     },
		   |     "diagnostic.virtualText": {
		   |       "type": "boolean",
		   |       "description": "Use NeoVim virtual text to display diagnostics",
		   |       "default": false
		   |     },
		   |     "diagnostic.virtualTextCurrentLineOnly": {
		   |       "type": "boolean",
		   |       "description": "Only show virtualText diagnostic on current cursor line",
		   |       "default": true
		   |     },
		   |     "diagnostic.virtualTextPrefix": {
		   |       "type": "string",
		   |       "description": "The prefix added virtual text diagnostics",
		   |       "default": " "
		   |     },
		   |     "diagnostic.virtualTextLines": {
		   |       "type": "number",
		   |       "description": "The number of non empty lines from a diagnostic to display",
		   |       "default": 3
		   |     },
		   |     "diagnostic.virtualTextLineSeparator": {
		   |       "type": "string",
		   |       "description": "The text that will mark a line end from the diagnostic message",
		   |       "default": " \\ "
		   |     },
		   |     "diagnostic.enableSign": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Enable signs for diagnostics."
		   |     },
		   |     "diagnostic.enableHighlightLineNumber": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Enable highlighting line numbers for diagnostics, only works with neovim and diagnostic.enableSign is true."
		   |     },
		   |     "diagnostic.enableMessage": {
		   |       "type": "string",
		   |       "default": "always",
		   |       "description": "When to enable show messages of diagnostics.",
		   |       "enum": ["always", "jump", "never"]
		   |     },
		   |     "diagnostic.highlightOffset": {
		   |       "type": "number",
		   |       "description": "Offset number of buffer.addHighlight, neovim only.",
		   |       "default": 1000
		   |     },
		   |     "diagnostic.signPriority": {
		   |       "type": "number",
		   |       "description": "Priority of diagnostic signs, default to 10",
		   |       "default": 10
		   |     },
		   |     "diagnostic.errorSign": {
		   |       "type": "string",
		   |       "description": "Text of error sign",
		   |       "default": ">>"
		   |     },
		   |     "diagnostic.warningSign": {
		   |       "type": "string",
		   |       "description": "Text of warning sign",
		   |       "default": "⚠"
		   |     },
		   |     "diagnostic.infoSign": {
		   |       "type": "string",
		   |       "description": "Text of info sign",
		   |       "default": ">>"
		   |     },
		   |     "diagnostic.hintSign": {
		   |       "type": "string",
		   |       "description": "Text of hint sign",
		   |       "default": ">>"
		   |     },
		   |     "diagnostic.maxWindowHeight": {
		   |       "type": "number",
		   |       "description": "Maximum height of diagnostics floating window.",
		   |       "default": 8
		   |     },
		   |     "diagnostic.maxWindowWidth": {
		   |       "type": "number",
		   |       "description": "Maximum width of diagnostics floating window.",
		   |       "default": 80
		   |     },
		   |     "diagnostic.filetypeMap": {
		   |       "type": "object",
		   |       "description": "A map between buffer filetype and the filetype assigned to diagnostics. To syntax highlight diagnostics withs their parent buffer type use `\"default\": \"bufferType\"`",
		   |       "default": {}
		   |     },
		   |     "diagnostic.format": {
		   |       "type": "string",
		   |       "description": "Define the diagnostic format that shown in float window or echoed, available parts: source, code, severity, message",
		   |       "default": "[%source%code] [%severity] %message"
		   |     },
		   |     "diagnostic.separateRelatedInformationAsDiagnostics": {
		   |       "type": "boolean",
		   |       "default": false,
		   |       "description": "Separate related information as diagnostics"
		   |     },
		   |     "diagnostic.showUnused": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Show unused variables"
		   |     },
		   |     "diagnostic.showDeprecated": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Show deprecated variables"
		   |     },
		   |     "signature.enable": {
		   |       "type": "boolean",
		   |       "description": "Enable signature help when trigger character typed, require restart service on change.",
		   |       "default": true
		   |     },
		   |     "signature.triggerSignatureWait": {
		   |       "type": "integer",
		   |       "default": 500,
		   |       "minimum": 200,
		   |       "maximum": 1000,
		   |       "description": "Timeout for trigger signature help, in miliseconds."
		   |     },
		   |     "signature.target": {
		   |       "type": "string",
		   |       "description": "Target of signature help, use float when possible by default.",
		   |       "default": "float",
		   |       "enum": ["float", "echo"]
		   |     },
		   |     "signature.maxWindowWidth": {
		   |       "type": "integer",
		   |       "default": 80,
		   |       "description": "Maximum width of signature float window (or popup on vim8)."
		   |     },
		   |     "signature.maxWindowHeight": {
		   |       "type": "number",
		   |       "description": "Maximum height of signature float window (or popup on vim8).",
		   |       "minimum": 3,
		   |       "default": 8
		   |     },
		   |     "signature.preferShownAbove": {
		   |       "type": "boolean",
		   |       "description": "Show signature help float window above cursor when possible, require restart service on change.",
		   |       "default": true
		   |     },
		   |     "signature.hideOnTextChange": {
		   |       "type": "boolean",
		   |       "description": "Hide signature float window when text changed on insert mode.",
		   |       "default": false
		   |     },
		   |     "codeLens.enable": {
		   |       "type": "boolean",
		   |       "description": "Enable codeLens feature, require neovim with set virtual text feature.",
		   |       "default": false
		   |     },
		   |     "codeLens.separator": {
		   |       "type": "string",
		   |       "description": "Separator text for codeLens in virtual text",
		   |       "default": "‣"
		   |     },
		   |     "codeLens.subseparator": {
		   |       "type": "string",
		   |       "description": "Subseparator between codeLenses in virtual text",
		   |       "default": " "
		   |     },
		   |     "refactor.openCommand": {
		   |       "type": "string",
		   |       "description": "Open command for refactor window.",
		   |       "default": "vsplit"
		   |     },
		   |     "refactor.saveToFile": {
		   |       "type": "boolean",
		   |       "description": "Save to file when write refactor buffer with ':noa wa' command, set to false if you want save buffer by yourself.",
		   |       "default": true
		   |     },
		   |     "refactor.beforeContext": {
		   |       "type": "number",
		   |       "default": 3,
		   |       "description": "Print num lines of leading context before each match."
		   |     },
		   |     "refactor.afterContext": {
		   |       "type": "number",
		   |       "default": 3,
		   |       "description": "Print num lines of trailing context after each match."
		   |     },
		   |     "dialog.maxHeight": {
		   |       "type": "number",
		   |       "default": 20,
		   |       "description": "Maximum height of dialog window."
		   |     },
		   |     "dialog.maxWidth": {
		   |       "type": "number",
		   |       "default": 80,
		   |       "description": "Maximum width of dialog window."
		   |     },
		   |     "dialog.confirmKey": {
		   |       "type": "string",
		   |       "default": "<cr>",
		   |       "description": "Confirm key for confirm selection used by menu and picker, you can always use <esc> to cancel."
		   |     },
		   |     "dialog.pickerButtons": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Show buttons for picker dialog window/popup."
		   |     },
		   |     "dialog.pickerButtonShortcut": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Show shortcut in buttons of picker dialog window/popup, used when dialog.pickerButtons is true."
		   |     },
		   |     "dialog.floatHighlight": {
		   |       "type": ["string", "null"],
		   |       "default": null,
		   |       "description": "Highlight group for dialog window/popup, default to 'CocFloating'"
		   |     },
		   |     "dialog.floatBorderHighlight": {
		   |       "type": ["string", "null"],
		   |       "default": null,
		   |       "description": "Highlight group for border of dialog window/popup, default to 'CocFloating'"
		   |     },
		   |     "notification.marginTop": {
		   |       "type": "number",
		   |       "default": 1,
		   |       "description": "Margin top for notification dialog."
		   |     },
		   |     "notification.marginRight": {
		   |       "type": "number",
		   |       "default": 1,
		   |       "description": "Margin right for notification dialog."
		   |     },
		   |     "notification.maxWidth": {
		   |       "type": "number",
		   |       "default": 60,
		   |       "description": "Maximum content width of notification dialog."
		   |     },
		   |     "notification.maxHeight": {
		   |       "type": "number",
		   |       "default": 10,
		   |       "description": "Maximum content height of notification dialog."
		   |     },
		   |     "notification.highlightGroup": {
		   |       "type": "string",
		   |       "default": "CocFloating",
		   |       "description": "Highlight group of notification dialog."
		   |     },
		   |     "notification.minProgressWidth": {
		   |       "type": "number",
		   |       "default": 30,
		   |       "description": "Minimum width of progress notification."
		   |     },
		   |     "workspace.ignoredFiletypes": {
		   |       "type": "array",
		   |       "default": ["markdown", "log", "txt", "help"],
		   |       "description": "Filetypes that should be ignored for resolve workspace folder.",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "workspace.bottomUpFiletypes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "description": "Filetypes that should have workspace folder should resolved from base directory of file.",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "workspace.workspaceFolderCheckCwd": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Whether the cwd directory should be checked first when resolving workspace folder."
		   |     },
		   |     "list.indicator": {
		   |       "type": "string",
		   |       "default": ">",
		   |       "description": "The character used as first character in prompt line"
		   |     },
		   |     "list.alignColumns": {
		   |       "type": "boolean",
		   |       "default": false,
		   |       "description": "Whether to align lists in columns, default: `false`"
		   |     },
		   |     "list.interactiveDebounceTime": {
		   |       "type": "number",
		   |       "default": 100,
		   |       "description": "Debouce time for input change on interactive mode."
		   |     },
		   |     "list.height": {
		   |       "type": "number",
		   |       "default": 10,
		   |       "description": "Height of split list window."
		   |     },
		   |     "list.statusLineSegments": {
		   |       "type": ["array", "null"],
		   |       "default": [
		   |         "%#CocListMode#-- %{get(b:list_status, \"mode\", \"\")} --%*",
		   |         "%{get(b:list_status, \"loading\", \"\")}",
		   |         "%{get(b:list_status, \"args\", \"\")}",
		   |         "(%L/%{get(b:list_status, \"total\", \"\")})",
		   |         "%=",
		   |         "%#CocListPath# %{get(b:list_status, \"cwd\", \"\")} %l/%L%*"
		   |       ],
		   |       "items": {
		   |         "types": "string"
		   |       },
		   |       "description": "An array of statusline segments that will be used to draw the status line for list windows."
		   |     },
		   |     "list.signOffset": {
		   |       "type": "number",
		   |       "default": 900,
		   |       "description": "Sign offset of list, should be different from other plugins."
		   |     },
		   |     "list.selectedSignText": {
		   |       "type": "string",
		   |       "default": "*",
		   |       "description": "Sign text for selected lines."
		   |     },
		   |     "list.extendedSearchMode": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Enable extended search mode which allows multiple search patterns delimited by spaces."
		   |     },
		   |     "list.limitLines": {
		   |       "type": "number",
		   |       "default": 30000,
		   |       "description": "Limit lines for list buffer."
		   |     },
		   |     "list.maxPreviewHeight": {
		   |       "type": "number",
		   |       "default": 12,
		   |       "description": "Max height for preview window of list."
		   |     },
		   |     "list.previewSplitRight": {
		   |       "type": "boolean",
		   |       "default": false,
		   |       "description": "Use vsplit for preview window."
		   |     },
		   |     "list.matchHighlightGroup": {
		   |       "type": "string",
		   |       "default": "Search",
		   |       "description": "Highlight group used for matched texts in list window."
		   |     },
		   |     "list.previewHighlightGroup": {
		   |       "type": "string",
		   |       "default": "Search",
		   |       "description": "Highlight group used for highlight the range in preview window."
		   |     },
		   |     "list.nextKeymap": {
		   |       "type": "string",
		   |       "default": "<C-j>",
		   |       "description": "Key used for select next line on insert mode."
		   |     },
		   |     "list.previousKeymap": {
		   |       "type": "string",
		   |       "default": "<C-k>",
		   |       "description": "Key used for select previous line on insert mode."
		   |     },
		   |     "list.normalMappings": {
		   |       "type": "object",
		   |       "default": {},
		   |       "description": "Custom keymappings on normal mode."
		   |     },
		   |     "list.insertMappings": {
		   |       "type": "object",
		   |       "default": {},
		   |       "description": "Custom keymappings on insert mode."
		   |     },
		   |     "list.source.diagnostics.includeCode": {
		   |       "type": "boolean",
		   |       "description": "Whether to show the diagnostic code in the list.",
		   |       "default": true
		   |     },
		   |     "list.source.diagnostics.pathFormat": {
		   |       "type": "string",
		   |       "description": "Decide how the filepath is shown in the list.",
		   |       "enum": ["full", "short", "filename", "hidden"],
		   |       "default": "full"
		   |     },
		   |     "list.source.symbols.excludes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "description": "Patterns of minimatch for filepath to execlude from symbols list.",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "list.source.outline.ctagsFilestypes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "description": "Filetypes that should use ctags for outline instead of language server.",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "cursors.cancelKey": {
		   |       "type": "string",
		   |       "default": "<esc>",
		   |       "description": "Key used for cancel cursors session."
		   |     },
		   |     "cursors.nextKey": {
		   |       "type": "string",
		   |       "default": "<C-n>",
		   |       "description": "Key used for jump to next cursors position. "
		   |     },
		   |     "cursors.previousKey": {
		   |       "type": "string",
		   |       "default": "<C-p>",
		   |       "description": "Key used for jump to previous cursors position."
		   |     },
		   |     "coc.preferences.enableMessageDialog": {
		   |       "type": "boolean",
		   |       "default": false,
		   |       "description": "Enable messages shown in notification dialog."
		   |     },
		   |     "coc.preferences.maxFileSize": {
		   |       "type": "string",
		   |       "default": "10MB",
		   |       "description": "Maximum file size in bytes that coc.nvim should handle, default '10MB'"
		   |     },
		   |     "coc.preferences.promptWorkspaceEdit": {
		   |       "type": "boolean",
		   |       "description": "Prompt confirm from user when apply workspace edit for unloaded files.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.listOfWorkspaceEdit": {
		   |       "type": "string",
		   |       "default": "quickfix",
		   |       "description": "List should contains changed locations after workspace edit, default to vim's quickfix",
		   |       "enum": ["quickfix", "location", "none"]
		   |     },
		   |     "coc.preferences.useQuickfixForLocations": {
		   |       "type": "boolean",
		   |       "description": "Use vim's quickfix list for jump locations,\n need restart on change.",
		   |       "default": false
		   |     },
		   |     "coc.preferences.extensionUpdateCheck": {
		   |       "type": "string",
		   |       "default": "never",
		   |       "description": "Interval for check extension update, could be daily, weekly, never",
		   |       "enum": ["daily", "weekly", "never"]
		   |     },
		   |     "coc.preferences.snippetStatusText": {
		   |       "type": "string",
		   |       "default": "SNIP",
		   |       "description": "Text shown in statusline to indicate snippet session is activated."
		   |     },
		   |     "coc.preferences.hoverTarget": {
		   |       "type": "string",
		   |       "description": "Target to show hover information, default is floating window when possible.",
		   |       "enum": ["preview", "echo", "float"]
		   |     },
		   |     "coc.preferences.colorSupport": {
		   |       "type": "boolean",
		   |       "description": "Enable color highlight if language server support it.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.previewAutoClose": {
		   |       "type": "boolean",
		   |       "description": "Auto close preview window on cursor move.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.previewMaxHeight": {
		   |       "type": "number",
		   |       "default": 12,
		   |       "description": "Max height of preview window for hover."
		   |     },
		   |     "coc.preferences.currentFunctionSymbolAutoUpdate": {
		   |       "type": "boolean",
		   |       "description": "Automatically update the value of b:coc_current_function on CursorHold event",
		   |       "default": false
		   |     },
		   |     "coc.preferences.formatOnSaveFiletypes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "description": "Filetypes that should run format on save.",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.preferences.enableFloatHighlight": {
		   |       "type": "boolean",
		   |       "description": "Enable highlight for floating window.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.rootPatterns": {
		   |       "type": "array",
		   |       "default": [".git", ".hg", ".projections.json"],
		   |       "description": "Root patterns to resolve workspaceFolder from parent folders of opened files, resolved from up to down.",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.preferences.watchmanPath": {
		   |       "type": "string",
		   |       "description": "executable path for https://facebook.github.io/watchman/, detected from $PATH by default",
		   |       "default": null
		   |     },
		   |     "coc.preferences.jumpCommand": {
		   |       "type": "string",
		   |       "description": "Command used for location jump, like goto definition, goto references etc.",
		   |       "enum": ["edit", "split", "vsplit", "tabe", "drop", "tab drop", "pedit"],
		   |       "default": "edit"
		   |     },
		   |     "coc.preferences.messageLevel": {
		   |       "type": "string",
		   |       "description": "Message level for filter echoed messages, could be 'more', 'warning' and 'error'",
		   |       "default": "more",
		   |       "enum": ["more", "warning", "error"]
		   |     },
		   |     "coc.preferences.bracketEnterImprove": {
		   |       "type": "boolean",
		   |       "description": "Improve enter inside bracket `<> {} [] ()` by add new empty line below and place cursor to it. Works with `coc#on_enter()`",
		   |       "default": true
		   |     },
		   |     "coc.preferences.formatOnType": {
		   |       "type": "boolean",
		   |       "description": "Set to true to enable format on type",
		   |       "default": false
		   |     },
		   |     "coc.preferences.formatOnTypeFiletypes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "description": "Filetypes that should run format on typing. Only take effect when `coc.preferences.formatOnType` set `true`",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.preferences.highlightTimeout": {
		   |       "type": "integer",
		   |       "default": 500,
		   |       "minimum": 200,
		   |       "maximum": 5000,
		   |       "description": "Highlight timeout for buffer in floating window."
		   |     },
		   |     "coc.preferences.snippets.enable": {
		   |       "type": "boolean",
		   |       "description": "Set to false to disable snippets support.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.floatActions": {
		   |       "type": "boolean",
		   |       "description": "Set to false to disable float/popup support for actions menu, won't work on vim without float or popup window support.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.promptInput": {
		   |       "type": "boolean",
		   |       "description": "Use prompt buffer in float window for user input.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.enableMarkdown": {
		   |       "type": "boolean",
		   |       "description": "Tell the language server that markdown text format is supported, note that markdown text may not rendered as expected.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.silentAutoupdate": {
		   |       "type": "boolean",
		   |       "description": "Not open split window with update status when performing auto update.",
		   |       "default": true
		   |     },
		   |     "coc.preferences.willSaveHandlerTimeout": {
		   |       "type": "integer",
		   |       "default": 500,
		   |       "minimum": 200,
		   |       "maximum": 5000,
		   |       "description": "Will save handler timeout"
		   |     },
		   |     "coc.source.around.enable": {
		   |       "type": "boolean",
		   |       "default": true
		   |     },
		   |     "coc.source.around.firstMatch": {
		   |       "type": "boolean",
		   |       "description": "Filter complete items by first letter strict match.",
		   |       "default": true
		   |     },
		   |     "coc.source.around.shortcut": {
		   |       "type": "string",
		   |       "default": "A"
		   |     },
		   |     "coc.source.around.priority": {
		   |       "type": "integer",
		   |       "default": 1
		   |     },
		   |     "coc.source.around.disableSyntaxes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.source.buffer.enable": {
		   |       "type": "boolean",
		   |       "default": true
		   |     },
		   |     "coc.source.buffer.shortcut": {
		   |       "type": "string",
		   |       "default": "B"
		   |     },
		   |     "coc.source.buffer.priority": {
		   |       "type": "integer",
		   |       "default": 1
		   |     },
		   |     "coc.source.buffer.firstMatch": {
		   |       "type": "boolean",
		   |       "description": "Filter complete items by first letter strict match.",
		   |       "default": true
		   |     },
		   |     "coc.source.buffer.ignoreGitignore": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Ignore git ignored files for buffer words"
		   |     },
		   |     "coc.source.buffer.disableSyntaxes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.source.file.enable": {
		   |       "type": "boolean",
		   |       "default": true
		   |     },
		   |     "coc.source.file.shortcut": {
		   |       "type": "string",
		   |       "default": "F"
		   |     },
		   |     "coc.source.file.priority": {
		   |       "type": "integer",
		   |       "default": 10
		   |     },
		   |     "coc.source.file.disableSyntaxes": {
		   |       "type": "array",
		   |       "default": [],
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.source.file.triggerCharacters": {
		   |       "type": "array",
		   |       "default": ["/"],
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.source.file.trimSameExts": {
		   |       "type": "array",
		   |       "default": [".ts", ".js"],
		   |       "description": "Trim same extension on file completion",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "coc.source.file.ignoreHidden": {
		   |       "type": "boolean",
		   |       "default": true,
		   |       "description": "Ignore completion for hidden files"
		   |     },
		   |     "coc.source.file.ignorePatterns": {
		   |       "type": "array",
		   |       "default": [],
		   |       "description": "Ignore patterns of matcher",
		   |       "items": {
		   |         "type": "string"
		   |       }
		   |     },
		   |     "languageserver": {
		   |       "type": "object",
		   |       "default": {},
		   |       "description": "Dictionary of languageservers, key is used as id of languageserver.",
		   |       "patternProperties": {
		   |         "^[_a-zA-Z]+$": {
		   |           "oneOf": [
		   |             {
		   |               "$ref": "#/definitions/languageServerModule"
		   |             },
		   |             {
		   |               "$ref": "#/definitions/languageServerCommand"
		   |             },
		   |             {
		   |               "$ref": "#/definitions/languageServerSocket"
		   |             }
		   |           ]
		   |         }
		   |       }
		   |     }
		   |   }
		   | }
		  
			- suggest.noselect:true,
suggest.enablePreseect:false
自动补全不默认选中，直接回车，直接下一行
如果按tab就自动选中第一行，再回车，会展开那个补全的提示。

		- [neovim安装coc缺失bash-language-server](https://blog.csdn.net/u013297137/article/details/103507199)

	- 多选多行进行选择

		- 1.c-v,上下选中多行选中visualblock模式
2.shfit+i,输入注释符号
3.esc退出visualblock模式

	- easyalign

		- ga=,用＝对齐

	- autoformat

		- \f执行自动格式化

		- AutoformatLine

	- To make prettier do the format, use command :CocCommand prettier.formatFile
To save without formatting, use :noa w

	- *#

	- %

		- 使用 % 在匹配的括号之间跳转

	- /?

		- 使用 / 和 ? 来快速正向和反向搜索等

	- <leader>s

		- nmap <leader>s <Plug>(easymotion-s2)

	- [vim中输入方向键 转化为 A B C D](https://blog.csdn.net/stpeace/article/details/49407857)

	- [解决wsl中安装好了xclip也无法访问系统剪切板的问题](https://qastack.cn/vi/12376/vim-on-wsl-synchronize-system-clipboard-set-clipboard-unnamed)

		- if system('uname -r') =~ "Microsoft"
  augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe ',@")
  augroup END
endif

- ranger

	- shfit-v:创建文件

	- shfit-m:创建文件夹

	- cw：重命名文件名，包括后缀

- [fzf](https://zhuanlan.zhihu.com/p/91873965)

	- fzf安装方法和问题集合

		- fzf相关地址

			- https://github.com/junegunn/fzf#installation

	- c-t

	- c-r

	- c-j/c-k/c-n/c-m光标移动

	- enter用来选中

	- -m，tab和shfit-tab用来多选

	- 可扩展搜索

	  fzf默认会以“extened-search"模式启动， 这种模式下你可以输入多个以空格分隔的搜索关键词， 如^music .mp3$, sbtrkt !fire.
	  
	  如果你不想用fuzzy match， 可以用fzf -e做精确匹配 符号"|"可以做or匹配， 比如
	  
	   # 表示以core开头，以go或rb或py结尾的
	   ^core go$|rb$|py$
	  
- [lazygit](https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md)

	- file面板

		- a：all files stage/unstage

		- space: one single file stage

		- enter: enter into one line stage mode

		- 如果只想stage一个文件的一部分：
先enter，进入界面，
按空格一行一行的stage，
可以按a，选中所有hook，然后按空格，直接hook添加例如
按tab切换unstage面板还是stage面板，
在unstage面板中在某一行上按d，然后回车，就直接删除了，不可逆。

		- c:commit

		- A：amend last commit

		- C:编辑消息

		- d：放弃一个更改
D:快速清理工作目录

	- branch面板

		- 默认显示本地分支

		- n（现在设为i）：添加分支

		- 空格：选中分支

		- P：发布分支到远程

		- s：隐藏文件

		- M：merge合并分支：先切换到我想合并到的分支，然后移动到新提交的分支，按大写M

	- commit提交面板

		- enter：查看本次提交中改动的文件

			- d：删除本次提交中此文件的修改

			- c:回滚，帮你添加一个更改，把文件回到这次提交的版本

		- ,.：翻页
<>：最上最下

		- /：搜索

		- r: 更改提交信息
R：在编辑器中更改提交信息

		- 滚回：选中一次提交，按空格，就可以checkout到这个提交了，到了一个假分支，可以新增分支

		- reflog上选中一个，按小写g，reset

		- g：显示重置选项
soft：选择的那次commit之前的所有提交都会从历史消失，但是更改的文件，恢复到了工作目录，编程没有提交的更改。
hard：选择的那次commit之前的所有提交都会从历史消失，文件也不存在了
mixed：

		- 复制提交：commit面板c：cherry-pick复制commit，回到想复制到的分支，commit面板中按v粘贴commit

		- 删除一次提交：在一个提交上按d，删除提交

		- interactive rebase

	- stash 隐藏面板

		- g：pop一次stash，隐藏恢复出来并把这次隐藏删除

		- 空格：直接应用这次隐藏，apply

		- d:直接删除这次隐藏drop

	- x: 查看帮助

	- []切换面板

	- s隐藏提交

	- m移动提交到新的分支上

	- r更改提交信息

	- R在编辑器中编辑

	- e编辑commit
f，s，d，p，修改状态
m，continue


	- 冲突

		- b两个版本

	- delta pager

		- delta --dark --paging=never --24-bit-color=never --theme="OneHalfDark"

	- [主题颜色配置](https://github.com/969191832/lazygit/blob/master/docs/Config.md)

	- cherry-pick使用教程

		- 1.c
2.换分支
3.v

- less编辑器

  less 是linux快速浏览文件的命令(防止 误修改文件) 
  
  less主要就是 浏览文件 查找文件 浏览文件涉及到的就是上下翻页 具体翻页的按键如下表
  
  less | 向上翻页 | 向下翻页
  一页 | b (back) | 空格
  半页 | u (undo) | d (down)
  一行 | y (...) | 回车
  
## 49.3. webpack

### 49.3.1. devServer.proxy

- [文章：http-proxy-middleware 源码解读](https://zhuanlan.zhihu.com/p/49259795?from_voters_page=true)

- [Github官方地址](https://github.com/chimurai/http-proxy-middleware#options)

### 49.3.2. webpack中使用mockjs的例子

- 手写方式

	- 步骤一：

		- 引用mockjs库
![image](assets/3d1e38845dd0249bf7680cdc43167e4c555e4007ddbea9bde19109537ce29d15.png)

	- 步骤二：

		- 在devServer的after钩子中配置bindDevServerAfter方法
![image](assets/0e7ba5917e8af83ae764f601bb5fcc6488f3ee1507c02ba022c00e6ebeff0282.png)

	- 步骤三：

		- bindDevServerAfter做了什么？

![image](assets/9b92b2828c8803dbb743ee04f2c33f924f32af1fb630d5bd195f687e20c1b939.png)

			- 1.拦截所有请求
![image](assets/10f447fc9193c7b2c3c6e7dbfa6c07a095f41e37e3abf7dd0fe69e2ab85e2542.png)

			- 2.请求路径中如结尾带有/自动去掉。
![image](assets/64d62bf8f56bf62b42870bc71374a2df9d6448f5c7e1d7566d92dbf0cfac520d.png)

				- substring不含尾
![image](assets/a3367d8ede315cb7dbab1e14cac794c0b2dddc9c404a85d257c1773d128fa868.png)

			- 3.realpathname是当前目录拼上./.data文件夹再拼上路径
![image](assets/4d76ebb32ee81a7f493966e151777cc445289ce863abaa6523a1837f39aa05cd.png)

			- 4.
path.dirname(path)方法返回 path 的目录名
path.basename(path[, ext])方法返回 path 的最后一部分
![image](assets/1d9df49cc95ad48e378d4feeda4fd95ea8dac13f1b8ed414c6b9056a16a36775.png)

				- dirname方法
![image](assets/f2aa987bff64f7b8224b432e93d6e8e297323147d65e0b995487795dd1b19086.png)

				- basename方法
![image](assets/3cc771c0d0d773334bba980a6e46ddb713c6be9207f86efa97a248b93ae6e5b3.png)

			- 5.猜测三种路径，判断是否存在，存在的话就调用smartResponse方法
![image](assets/3daf750a01959bdd075ee04b1a0864399281b32f65aeceff060d6ca02859041e.png)

	- 步骤四：

		- smartResponse
![image](assets/d18fc51c58f6d3b69b33f9f720ddfd7537c4e992aefc29cc45ca2fbcd5840496.png)

			- /^\s*\/\//
没明白这个正则到底是干嘛用的，也没有注释说明。

- 使用中间件hm-middleware

	- [介绍文章](https://blog.csdn.net/ancaixie6996/article/details/102007410)

	- 步骤一：

		- 引用http-mock-middleware
![image](assets/c76ffd499a5923d3af8cf93ad6abbd6669c233d84b246ed8478aaf6014ea43e0.png)

	- 步骤二：

		- devServer
![image](assets/96bed697f69758e7b7ccdc2bbbd7b0a8917a6af615f179e4484d1e4e052e6226.png)

			- 其他例子
![image](assets/b48e27402064849e648ad0ea4033ee8d1c85f4b1da0e8bb324fe9f526bc7fd0a.png)

- ngconsole中的使用方式
http-proxy-middleware中间件进行转发

	- mockjs，进行假数据
![image](assets/4e3fd7d22a9dcceed2ecc80362aac4f0f88949665182f0a7f91827cf4b73e476.png)

### 49.3.3. webpack中使用http-proxy-middleware，实现通过代理跑devServer的例子

### 49.3.4. 入门了解 & 核心概念

### 49.3.5. 配置

- devServer.proxy

	- 如果你有单独的后端开发服务器 API，并且希望在同域名下发送 API 请求 ，那么代理某些 URL 会很有用。

	- object [object, function]

	- proxy直接设为一个地址
![image](assets/01f312affd26e2c29b6fdb54ad23a35fa1ba7a6ebe8898439dcdf87ff38d3b9e.png)

	- 代理的官方文档,devServer.proxy默认使用了http-proxy-middleware
![image](assets/856cb6e0c62bf4c3a83badc01c5557060d6239a316cc32d184de7666e12d8b23.png)

		- [http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)

### 49.3.6. 实战方面

### 49.3.7. 优化

### 49.3.8. 原理

### 49.3.9. [vue-cli脚手架默认配置文件位置](https://blog.csdn.net/zhengjihao/article/details/107074437)

### 49.3.10. [webpack4.0-webpack与浏览器缓存问题-10](https://blog.csdn.net/memedadexixaofeifei/article/details/103892548)

### 49.3.11. [webpack学习历程 优化使用缓存(一)](https://blog.csdn.net/weixin_44021417/article/details/106765483?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-2.no_search_link&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-2.no_search_link)

## 49.4. mockjs

### 49.4.1. vue+webpack(vue.config.js)

- const Mock = require("mockjs")
resp.json(Mock.mock(jsonData));

  function bindDevServerAfter(app){
      // serve mock data
      app.all("*", function(req, resp, next){
          var pathname = req.path;
          if(pathname.endsWith("/")) {
              pathname = pathname.substring(0, pathname.length - 1);
          }
          var realpathname = path.join(__dirname, "./.data", pathname);
          var dirname = path.dirname(realpathname);
          var filename = path.basename(realpathname) + ".json";
          var localpath = [
              realpathname,
              dirname + "/" + req.method.toLowerCase() + "-" + filename,
              dirname + "/" + filename
          ].filter(function(pathstr){
              return fs.existsSync(pathstr) && fs.lstatSync(pathstr).isFile();
          })[0];
          if(localpath) {
              smartResponse(req, resp, localpath);
          } else {
              next();
          }
      });
  }
  
### 49.4.2. 直接引用

Getting Started
nuysoft edited this page on 17 Feb 2016 · 14 revisions
开始 & 安装
Node (CommonJS)
# 50. 安装
npm install mockjs
// 使用 Mock
var Mock = require('mockjs')
var data = Mock.mock({
    // 属性 list 的值是一个数组，其中含有 1 到 10 个元素
    'list|1-10': [{
        // 属性 id 是一个自增数，起始值为 1，每次增 1
        'id|+1': 1
    }]
})
// 输出结果
console.log(JSON.stringify(data, null, 4))
Bower
# 51. 安装
npm install -g bower
bower install --save mockjs
<script type="text/javascript" src="./bower_components/mockjs/dist/mock.js"></script>
RequireJS (AMD)
// 配置 Mock 路径
require.config({
    paths: {
        mock: 'http://mockjs.com/dist/mock'
    }
})
// 加载 Mock
require(['mock'], function(Mock){
    // 使用 Mock
    var data = Mock.mock({
        'list|1-10': [{
            'id|+1': 1
        }]
    })
    // 输出结果
    document.body.innerHTML +=
        '<pre>' +
        JSON.stringify(data, null, 4) +
        '</pre>'
})
// ==>
{
    "list": [
        {
            "id": 1
        },
        {
            "id": 2
        },
        {
            "id": 3
        }
    ]
}
JSFiddle

Sea.js (CMD)
因为 Sea.js 社区尚未提供 webpack 插件，所以 Mock.js 暂不完整支持通过 Sea.js 加载。

一种变通的方式是，依然通过 Sea.js 配置和加载 Mock.js，然后访问全局变量 Mock。

// 配置 Mock 路径
seajs.config({
    alias: {
        mock: 'http://mockjs.com/dist/mock.js'
    }
})

// 加载 Mock
seajs.use('mock', function(__PLACEHOLDER) {
    // 使用 Mock（全局变量）
    var data = Mock.mock({
        'list|1-10': [{
            'id|+1': 1
        }]
    });
    document.body.innerHTML +=
        '<pre>' +
        JSON.stringify(data, null, 4) +
        '</pre>'
})
JSFiddle

Random CLI
# 52. 全局安装
$ npm install mockjs -g

# 53. 执行
$ random url
# 54. => http://rmcpx.org/funzwc

# 55. 帮助
random -h


- [使用方法](https://github.com/nuysoft/Mock/wiki/Getting-Started)

  // 引入 Mock
  var Mock = require('mockjs')
  
  var random = Mock.Random;
  
  //扩展数据模板
  random.extend({
    type: function (index:number) {
      const types = ['products', 'industryApp', 'solution', 'experts'];
      return this.pick(types[index])
    }
  });
  
  // 定义数据类型
  const  menuSource:Array<any> = [];
   menuSource[0] = Mock.mock({
    "type": "@type(0)",
     'data|3-4':[{
       'id|+1': 1,
       name: "@ctitle( 4,6)",
       "childs|5-10": [{
         'id|+1': 1,
         name: "@ctitle(4,6)",
       }]
     }]
  });
  // 输出结果
   console.log(data);
  
  
### 55.1.1. ngconsole实现方式总结


使用到两个插件
hm-middleware
http-proxy-middleware

- hm-middleware

  https://www.npmjs.com/package/hm-middleware
  
  http-mock-middleware 是一个 http mock 库，或者说 ajax/websocket mock 库，它接收来自 web 前端页面的 ajax/websocket 请求，将请求映射到本地 mock 文件并经过一系列插件处理后返回给 web 前端页面。http-mock-middleware 内建了多个插件以实现各种各样的功能，比如：根据 query 参数等的不同响应不同的数据，按需将请求转发给后端服务器，延迟响应，设置 cookie，主动向 websocket 客户端发送数据等。
  什么是本地 mock 文件？就是用于存放对应请求的假数据文件，比如要将请求 /login 映射为本地假数据文件 .data/login.json，就称 .data/login.json 为 mock 文件。
  http-mock-middleware 本身导出为一个兼容 express middleware 的函数，因此你可以很方便的集成到 webpack-dev-server, vue-cli-service, express 等现有服务器中。
  https://gitee.com/mirrors/http-mock-middleware
  devServer: {
          host: "0.0.0.0",
          disableHostCheck: true,
          before (app) {
              NgconsoleWebpackPlugin.bindDevServerBefore(app);
          },
          after (app, server){
              const middleware = require("hm-middleware");
              app.use(middleware({
                  mockRules: {
                      "/": process.env.NGCONSOLE_DATA || ".data"
                  },
                  proxy: {
                      autoSave: true,
                      saveDirectory: ".data",
                      overrideSameFile: "override"
                  }
              }));
          }
      },
  ￼
  
  
  
- http-proxy-middleware

  function proxyMiddleware(options){
      let useProxy = true;
      accessable("http://172.16.203.254/users/sign_in", "http://172.16.203.12/zentao/my/").then(function(){
          useProxy = false;
      }, function(){});
      return function(req, resp, next){
          let proxyHost = req.get("X-Mock-Proxy");
          if(!proxyHost) {
              return next();
          }
          let proxyUri = useProxy ? options.vdiProxy : false;
          let proxyMiddleware = proxyCache[proxyHost];
          if(!proxyMiddleware) {
              proxyMiddleware = proxyCache[proxyHost] = createProxyMiddleware("/", {
                  target: `https://${proxyHost}`,
                  secure: false,
                  changeOrigin: true,
                  logLevel: "debug",
                  agent: proxyUri ? new ProxyAgent(proxyUri) : undefined
                  , onProxyRes: function onProxyRes (proxyRes, req, res) {
                      let original_cookie = proxyRes.headers['set-cookie'];
                      if (!original_cookie) return;
                      let modified_cookie = original_cookie.map(str => {
                          return str.replace(/(;\s*)?SameSite=None/, '')
                                    .replace(/(;\s*)?secure/, '');
                      });
                      if (modified_cookie.every((str, i) => str === original_cookie[i])) return;
                      console.log(original_cookie);
                      console.log(modified_cookie);
                      proxyRes.headers['set-cookie'] = modified_cookie;
                  }
              });
          }
          proxyMiddleware(req, resp, next);
      }
  }
  
  function accessable(...urls) {
      return Promise.race(urls.map(url => {
          let httplib = url.indexOf("https://") === 0 ? https : http;
          return new Promise(function(resolve, reject) {
              let obj = urllib.parse(url);
              httplib.request({
                  method: "GET",
                  path: obj.path,
                  host: obj.host,
                  timeout: 3000
              }, function(){
                  resolve();
              }).on("error", reject).end();
          });
      }));
  }
  
### 55.1.2. edaas-front实现方式总结

- const Mock = require("mockjs")

- 使用

  。。。
  devServer: {
          after: bindDevServerAfter
      }
  };
  
  function bindDevServerAfter(app){
      // serve mock data
      app.all("*", function(req, resp, next){
          var pathname = req.path;
          if(pathname.endsWith("/")) {
              pathname = pathname.substring(0, pathname.length - 1);
          }
          var realpathname = path.join(__dirname, "./.data", pathname);
          var dirname = path.dirname(realpathname);
          var filename = path.basename(realpathname) + ".json";
          var localpath = [
              realpathname,
              dirname + "/" + req.method.toLowerCase() + "-" + filename,
              dirname + "/" + filename
          ].filter(function(pathstr){
              return fs.existsSync(pathstr) && fs.lstatSync(pathstr).isFile();
          })[0];
          if(localpath) {
              smartResponse(req, resp, localpath);
          } else {
              next();
          }
      });
  }
  
  function smartResponse(req, resp, file) {
      let directives = [];
      let pos1 = 0, pos2 = 0, line;
      let regexp = /^\s*\/\//;
      let text = fs.readFileSync(file, "utf-8");
      while(pos2 < text.length) {
          pos2 = text.indexOf("\n", pos1);
          line = text.substring(pos1, pos2);
          if(regexp.test(line)) {
              directives.push(line.substring(2));
              pos1 = pos2 + 1;
          } else {
              break;
          }
      }
      let actions = directives.reduce(function(actions, text){
          let pos = text.indexOf(":");
          let key = text.substring(0, pos).trim();
          let value = text.substring(pos + 1).trim();
          try {
              value = JSON.parse(value);
          } catch(e) {
              // ignore
          }
          actions[key] = value;
          return actions;
      }, {code: 200, delay: false, stop: false, error: false});
      let jsonData;
      try {
          jsonData = JSON.parse(text.substring(pos1));
      } catch(e) {
          actions.code = 500;
          actions.error = "parse json file " + file + " error: " + e.message;
      }
      let doResponse = function(){
          if(actions.stop) {
              return resp.socket.destroy();
          }
          resp.status(actions.code);
          if(actions.error) {
              resp.end(actions.error);
          } else {
              resp.set("Content-Type", "application/json");
              resp.json(Mock.mock(jsonData));
          }
      };
      setTimeout(doResponse, actions.delay || 0);
  }
  
  
## 55.2. 微信小程序

### 55.2.1. 开发环境搭建

### 55.2.2. 文件组成 / 声明周期 / 全局变量 / 公共设置 / 导航栏处理

### 55.2.3. 组件使用

### 55.2.4. 小程序在android和iphone上的不同

### 55.2.5. 部署发布

### 55.2.6. 微信小程序开发vs网页开发

- 区别
![image](assets/c18b96e670a2f3257232d9e5101e91288d14e81801755471e5487e0f4f8ff8f6.png)

- 运行环境
![image](assets/7e8116bfa6319ea54a8de302889e8e71b5f5afc55882ca1595dcb52eb3b5f7e8.png)

- 小程序特点
![image](assets/d0f08bef0657e99bbcb7e3cfe719815901fed96c0f16fa83ed9bfd2f3f6c543c.png)

- 开源项目
![image](assets/291dbde108736f68c71a66ec348c7a07c7a8465e7541e3bba31f997411124f3d.png)

- 尺寸单位
![image](assets/3175c207a00cf75492228ef5f3acf93833b060d32c3bb1d7ef543a27a379f66b.png)

## 55.3. docker

### 55.3.1. 基础知识

- YAML 入门教程

	- [地址](https://www.runoob.com/w3cnote/yaml-intro.html)

- cat /proc/version

- ls

- exit

- 学习总线

	- 即使再小的帆也能远航，只要学不死，就往死里学！
![image](assets/fdaa15c2f86d1d57f0ee63453293849241c74b116a8873f3df0a85b933443910.png)

	- dock概述
![image](assets/ee648ad662360cc42d0ff17de3ade8d8cc1792613cac7e663177e5c18f6eff47.png)

		- 为什么出现？
![image](assets/2b0c5b4c9f62d3db5635cf9fd6261a8f829eb8db2f6dc34102cd2e7ca5092243.png)

	- 历史：vm比较重，还要模拟硬件
![image](assets/bd0b9599602d8a468bdd1803f6304af85f4fb3b55167d573d5f23027f5fd5cc5.png)

		- docker历史
![image](assets/d36a517ef71d9305f5b621cc01d98d68fbb5c5141d680040a20da08d87f7d673.png)

		- docke的网站
![image](assets/dbe9b83083985d27a6c5f1aa3bfc06f033ac32b4cb85fbc135b3397b8df78591.png)

			- 官网：https://www.docker.com/

			- 文档地址：https://docs.docker.com/

			- 仓库地址：https://hub.docker.com/

			- 百度百科：https://baike.baidu.com/item/Docker/13344470?fr=aladdin

	- 比较Docker和虚拟机技术的不同：

		- 创通虚拟机，虚拟出一条硬件，运行一个完整的操作系统，然后在这个系统上安装和运行软件

		- 容器内的应用直接运行在宿主机的内容，容器是没有自己的内核的，也没有虚拟我们的硬件的，所以就轻便了

		- 每个容器间是互相隔离的，每个容器内都有一个属于自己的文件系统，互不影响

	- DevOps（开发、运维）
![image](assets/35580a7320d64ae19abbd5dabb53a317620482f7add3163f38c0f3384e0ececc.png)

	- docker的组成，像redis一样，redis client 访问redis server，docker起起来之后，也一样，docker run pull build命令，真正运行在，docker服务上的，有一个docker的守护进程（Docker daemon）运行时，需要通过镜像运行，镜像就好比java类，运行起来时，会返回很多对象（容器）。镜像来自远程仓库。
![image](assets/c099eda6a7696fd6b09bf0d5995f22ba947fd08ffbf174fc30e22f0df4893d8e.png)

		- 镜像（image）

			- docker镜像就好比是一个模板，可以通过这个模板来创建容器服务，tomcat镜像 =》run =》tomcat01容器（提供服务器），通过这个镜像可以创建多个容器（最终服务运行或者项目运行就是在容器中的）。

		- 容器（container）

			- docker利用容器技术，独立运行一个或者一组应用，通过镜像来创建的。启动，停止，删除，基本命令！

				- 目前可以把容器理解为一个简易的linux系统，项目就放在其中

		- 仓库（repository）

			- 仓库就是存放镜像的地方

			- 仓库分为公有仓库和私有仓库！

			- Docker Hub（默认是国外的）

			- 阿里云。。。都有容器服务（配置镜像加速！）

	- 安装docker

- 介绍

	- Docker是什么

		- 出现的原因

		  虚拟机占用资源特别大 启动慢
		  
		  传统的交换模式：只给程序，不给环境
		  
		  1、开发和运维之间的鸿沟
		  2、减少运维的工作量
		  
		  
		  
		- 设计理念

		  解决了什么问题：
		  运行环境和配置的问题，方便持续集成，有助于整体发布
		  
	- 能干什么

		- 企业级

			- 美团

			- 京东

		- 开发和运维

		  对开发和运维比较简单
		  
	- 获取

		- www.docker.com

		  英文官网
		  
		  文档地址：
		  https://docs.docker.com/get-started/
		  
		- www.docker-cn.com

		  中文网站，解决英文网站访问慢的问题
		  
	- 仓库

		- hub.docker.com

		  docker 仓库地址
		  国内访问速度比较慢，可以使用Ali云加速
		  
		  加速方式
		  1、请求时制定镜像地址
		  docker pull registry.docker-cn.com/library/ubuntu:16.04
		  
		  2、启动docker守护进程时，添加--registry-mirror参数
		  
		  3、修改配置文件/etc/docker/daemon.json
		  {
		    "registry-mirrors": ["https://registry.docker-cn.com"]
		  }
		  
	- docker介绍

		- Docker 是服务器----客户端架构。命令行运行docker命令的时候，需要本机有 Docker 服务。如果这项服务没有启动，可以用下面的命令启动（官方文档）。
# 56. service 命令的用法
$ sudo service docker start
# 57. systemctl 命令的用法
$ sudo systemctl start docker

		- Docker 把应用程序及其依赖，打包在 image 文件里面。只有通过这个文件，才能生成 Docker 容器

		- docker run -i -t ubuntu /bin/bash
![image](assets/263000903efc4910ac0ae365f25ccb8f1699aa9fbd71f3ca51b42bed18db83f3.png)

			- 可以看出容器中包含了基本的进程，网络设备，文件系统，跟传统中的虚拟机有着非常相似的现象

		- 容器
![image](assets/d2f201096df2e1fa8e115306432847698882b293829e607512f0ee10e28ccc30.png)

		- Linux容器技术vs虚拟机
![image](assets/85d406a3b9dc7fafc367b7f3ebb41f8a6fb37501bd4af0cba14aef16f92ceb49.png)

		- 什么是docker
![image](assets/744131f7db7118aaa5b9056d977c142851aa7a69f2b9af74fe419b35b191481d.png)

		- docker目标

			- 提供简单轻量级的建模方式

			- 职责的逻辑分离

			- 快速高效的开发生命周期

			- 鼓励使用面向服务的架构

		- docker的使用场景

			- 1.使用docker容器开发、测试、部署服务

			- 2.创建隔离的运行环境

			- 3.搭建测试环境

			- 4.构建多用户的平台即服务（PaaS）基础设施

			- 5.提供软件即服务（SaaS）应用程序

			- 6.高性能、超大规模的宿主机部署

		- docker的基本组成

			- 1.Docker Client 客户端

				- C/S架构

				- 本地/远程

				- 客户端和守护进程
![image](assets/8adef183656003f7ce0809a42a1df426cc6630682f71a317792b472473704c97.png)

			- 2.Docker Daemon守护进程

			- 3.Docker Image镜像

				- 容器的基石

					- 只读层
![image](assets/bfff73f3d4ec3b8b8861d7b897f7bd88d5cd50e76e8ee9464264a68278fad2dd.png)

				- 层叠的只读文件系统

				- 最底端是一个引导文件系统 bootfs

				- 联合加载（union mount）

			- 4.Docker Container容器

				- 通过镜像启动

					- 镜像是打包和启动阶段

				- 启动和执行阶段

					- 容器的阶段

						- 读写层
![image](assets/583da2e7fc0cec44047d254f00b0d1643206626b20bc6856e4fd307a718bb1ab.png)

				- 写时复制（copy on write）

			- 5.Docker Registry仓库

			- 图示
![image](assets/34b1b44d253d6ca0ac1865eeed0acb0d439c28d9cd4610f5548e9515437904e5.png)

- 【特点】

	- 启动速度快

	- 更轻量

- 【docker内部组件】

	- Namespace  

		-  命名空间，提供一种对进程隔离的一种机制，例如进程，网络、挂载等资源

	- ControlGroups  

		- 资源控制组的作用就是控制计算机资源的，与namespace不同CGroups 主要做的是硬件资源的隔离。

	- Union File System  

		- 联合文件系统，支持将不同位置的目录挂载到同一个虚拟文件系统，形成一种分层的模型

- 【docker的核心组成】

	- 镜像

		- 是什么

			- UnionFS(联合文件系统)

			- 镜像加载原理

			- 分层镜像

			- 为什么采用这种设计

		- docker commit 镜像提交

			- docker commit -m="" -a="作者" 容器id 目标镜像名称:[标签名]

			  docker commit --help
			  
			  docker commit -m="create image from current container" -a="panshen" 3a90f19f1669 "tomcat2:2.0"
			  
			  用已经存在的容器做一个新的镜像
		- 镜像是一个特殊的文件系统，可以理解为一个只读包，甚至可以理解为类与实例中的类。每个镜像可能有多个镜像组成。它是一种层级结构，每次对镜像的修改，docker都会铸造成一个镜像层。

	- 容器

		- 容器可以理解为类与实例中的实例，镜像是死的是不可变的。而容器却是一个活的空间。每次启动容器都是通过镜像启动一个新的容器。

	- 仓库

		- 远端中的镜像仓库，例如npm仓库

- 【docker安装】

	- 参考官方文档

	  安装社区版本就行
	  
	  centos 安装地址
	  https://docs.docker.com/install/linux/docker-ce/centos/#os-requirements
	  
	- 配置仓库地址

	- 两个系列：

		- 社区版（ce）

		- 企业版（ee）

			- 收费，提供额外服务

	- centos安装

		- sudo yum install yum-utils device-mapper-persistent-data lvm2 
sudo yum-config-manager --add-repo    https://download.docker.com/linux/centos/docker-ce.repo 
sudo yum install docker-ce

- 【docker的运行过程】

	- docker的运行过程可以简单的理解为，从远端仓库中拉取合适的镜像到本地-->通过镜像创建容器-->启动容器

	- 【图示】
![image](assets/6f8d14d711fab54ffd99e2017ed5781da8bb968d0e396bb10b7dce75f37825e7.png)

- 架构

  https://www.cnblogs.com/CloudMan6/p/6763789.html
  
  client
  
  docker服务器 （docker 守护进程）
  
  docker镜像
  
  docker容器 镜像运行的实例
  
  仓库 存放镜像的仓库，包含共有和私有
  
  运行过程
  当client 执行命令docker run nginx时，client发送socket消息给docker守护进程，
  
  docker守护进程先在本地看下有没有这个镜像存在，如果不存在就去远程仓库下载，然后保存到本地；
  
  然后通过 container run命令把这个镜像做成一个容器然后运行起来
  
  
- 组成

	- 镜像

	- 容器

	- 仓库

- 数据卷

	- 是什么

	- 能干什么

	- 数据卷

	- 数据容器卷

		- 是什么

		- 能干什么

			- 日志系统存储（典型场景）

		- 使用

			- docker run -it --name n1 --volumes-from n0 centos

	- 【背景】

		- 因为容器内部的文件系统是随着容器内部的生命周期所创建和移出的，并且容器隔离，我们很难从外部获得或者操作容器内部文件中的数据。

	- 【3种挂载方式】

		- Bind Mount

			- bind mount相对于volumn唯一的区别就是将容器内的目录映射到宿主机中的任意一个位置。

			- docker run -d -v /mnt:/mnt -name logs centos 

			- 唯一区别的就是，volume对应的是文件名(nginx-html)，而bindMount则是一个相对路径(/mnt)

		- Volume

			- volumes是docker管理宿主机文件系统的一部分，在/var/lib/docker/volumes目录下，当你创建一个数据卷时，会默认放在volumes目录

			- 创建命令

				- docker volume create nginx-html

					-  
![image](assets/8abe622a6a7cfdbf7bd5867c0495dd0b5858e08453782f6436bb7461de9ce8c5.png)

				- docker volume ls查看

			- 通过docker vlolume inspect nginx-html来查看具体信息

				-  
![image](assets/b4441d6df340cab166fda388c14642a4616abb869ef909539e38fb760c51d489.png)

			- 我们来创建一个新的nginx容器来和数据卷进行挂载

				- docker run -d --name nginx -v nginx-html:/usr/share/nginx/html nginx


			- 挂载成功后我们进入宿主机中

				- cd /var/lib/docker/volumes/nginx-html/_data

			- 你会发现宿主机中的nginx-html目录中多了两个文件

				-  
![image](assets/c36e18de7f7b36fc9d74ff55e6bafbca9c9cb30b05c21f7c60afbbe80ce0d97d.png)

			- 同时我们进入到容器内部

				- docker exec -it 7454e37763d0 bash

				- cd /usr/share/nginx/html

			-  
![image](assets/8eba9e2a67eea0c23f937aefdd1e57d2e49c4773545ffe6dae184b5ef9583609.png)

		- Tmpfs mount

			- Tmpfs Mount是临时挂载到系统内存中，存储不是永久的，会随着容器的停止而消失。适用于不需要持久保存的数据。挂载时需要用--tmpfs来指定。

			- docker run -d --name webapp --tmpfs /webapp/cache webapp:latest

- 网络

	- 【背景】

		- 一个完整的项目可能存在很多容器：nodejs，mysql，redis，webapp等

		- 他们之间彼此之间可能存在通信问题

		- 比如node容器如何连接mysql，为此docker提供了网络驱动

	- 可以通过 docker network ls 来查看网络驱动

	- 如果想看网络驱动的具体信息和对应的容器，使用 docker network inspect [网络驱动]

		- docker network inspect bridge

	- 单机

		- Bridge Network

			- 会在主机上创建一个虚拟网桥，此主机上启动的Docker容器会连接到这个虚拟网桥上。

			- 如图所示，bridge的ip地址都是以172.17开头显示的。不指定网络默认为bridge模式。

				-  
![image](assets/77f1819b1d48af556aa2523cee830de9ab4903fdeda8d9c8e88f131c026c88f0.png)

		- Host Network

			- 通过--net host来使用host模式，host模式是宿主机公用一个network，使用宿主机的IP和端口。

			- 创建一个新的nginx3的容器，通过--net host来指定网络驱动

			- docker run -d --name nginx3 --network host nginx

			- 启动完毕，进入到host详情，会发现多出了一个容器，并且没有ip地址，如图下

				-  
![image](assets/242f65f4ecbbd77f9d8ccadc1ea72d807a614794b798d2380f227b4c720849f2.png)

		- None Network

			- 不为Docker容器进行任何网络配置。通过 --net none

	- 多机

		- Overlay Network

	- 创建自定义网络

		- docker network create -d bridge mynetwork

		- 执行查看  docker network ls

			-  
![image](assets/d92e284c8a0cff738e18f7b6e59159ee1bbc0cf418ef1f809b596ae96137b8bc.png)

	- 容器之间的link

		- 通常由于容器之前隔离，两个容器之间的网络是无法进行通信的，通常我们需要通过link来建立容器之间的连接。

		- docker run -d --name nodeapp --link mysql node

		- 或者说两个容器同时加入自定义的网络中也是可行的

		- docker run -d --name mysql --network mynetwork mysql

		- docker run -d --name nodeapp --network mynetwork node 

### 57.1.1. 命令

- 帮助命令

	- docker version

	- docker info

	- docker --help

- docker search 镜像名

  starts 类似github上的stars
  
  official 是否官方
	- 查看远端库的镜像，跟npm search类似

		- 出现的列表表头是
![image](assets/5660add74d5121096601f551837e58c4b4f0039a0b21a38b08b9eaa80e359a00.png)

- docker pull

	- 拉取镜像

	- docker pull centos

		- 不指定tag时，默认拉取最新的tag

- docker images

	- 查看镜像

	- 参数

		- -a 列出所有镜像

		- -q 只显示镜像ID

		- --digests：显示摘要信息

		- --no-trunc：不截断输出，显示完整的镜像ID

- docker create 

	- 创建容器

	- 如果说镜像是个类，那么我们需要创建一个实例来让我们操作。

		- docker create centos

		- 如果当你本地没有centos的镜像时候，会默认从远端仓库中的拉取对应的版本。我们还可以通过--name来指定容器的别名。

- docker ps 

	- 查看容器

	- 通过docker ps可以查看当前所有正在运行的容器，但是由于上方容器没有运行，在执行操作时，需要在后面加一个-a参数。代表所有容器。

		- docker ps -a

- docker start  stop  reset（启动/停止/重启容器）

	- docker stop

	- 通过 docker create创建的容器，是处于 Created 状态的，其内部的应用程序还没有启动，所以我们需要通过docker start命令来启动它。

		- docker start 8c784b9b2118

		- 通过docker start + 容器id 来启动容器，如果给容器配置了别名，也可以通过别名来启动容器。启动容器后通过docker ps。

		- 执行 docker ps 发现空空如也

		- 执行 docker ps -a，发现容器处于Exited状态

		- 这是因为如果容器内部没有进程正在运行，那么容器在 start 之后会停止。如果存在进程的容器，例如nginx，mysql，你在启动后就会变成up状态。

- docker run

	- -v 宿主机目录:容器目录

		- -v, --volume=[]， 给容器挂载存储卷，挂载到容器的某个目录

	- --rm 停止后清空

		- --rm=false， 指定容器停止后自动删除容器(不支持以docker run -d启动的容器)

	- -d detached运行容器

	- -p端口号，映射

	- -e，docker run -e传递环境变量

	- 【常用选项说明】

		- -d, --detach=false， 指定容器运行于前台还是后台，默认为false

			- 后台运行容器，并返回容器ID

		- -i, --interactive=false， 打开STDIN，用于控制台交互

			- 以交互模式运行容器，通常与 -t 同时使用；

		- -t, --tty=false， 分配tty设备，该可以支持终端登录，默认为false

			- 为容器重新分配一个伪输入终端，通常与 -i 同时使用

		- -u, --user=""， 指定容器的用户

		- -a, --attach=[]， 登录容器（必须是以docker run -d启动的容器）

		- -w, --workdir=""， 指定容器的工作目录

		- -c, --cpu-shares=0， 设置容器CPU权重，在CPU共享场景使用

		- -e, --env=[]， 指定环境变量，容器中可以使用该环境变量

		- -m, --memory=""， 指定容器的内存上限

		- -P, --publish-all=false， 指定容器暴露的端口

		- -p, --publish=[]， 指定容器暴露的端口

			- 端口映射，格式为： 主机(宿主)端口:容器端口

		- -h, --hostname=""， 指定容器的主机名

		- -v, --volume=[]， 给容器挂载存储卷，挂载到容器的某个目录

			- 绑定数据卷

		- --volumes-from=[]， 给容器挂载其他容器上的卷，挂载到容器的某个目录

		- --cap-add=[]， 添加权限，权限清单详见：http://linux.die.net/man/7/capabilities

		- --cap-drop=[]， 删除权限，权限清单详见：http://linux.die.net/man/7/capabilities

		- --cidfile=""， 运行容器后，在指定文件中写入容器PID值，一种典型的监控系统用法

		- --cpuset=""， 设置容器可以使用哪些CPU，此参数可以用来容器独占CPU

		- --device=[]， 添加主机设备给容器，相当于设备直通

		- --dns=[]， 指定容器的dns服务器

		- --dns-search=[]， 指定容器的dns搜索域名，写入到容器的/etc/resolv.conf文件

		- --entrypoint=""， 覆盖image的入口点

		- --env-file=[]， 指定环境变量文件，文件格式为每行一个环境变量

		- --expose=[]， 指定容器暴露的端口，即修改镜像的暴露端口

		- --link=[]， 指定容器间的关联，使用其他容器的IP、env等信息

		- --lxc-conf=[]， 指定容器的配置文件，只有在指定--exec-driver=lxc时使用

		- --name=""， 指定容器名字，后续可以通过名字进行容器管理，links特性需要使用名字

		- --net="bridge"， 容器网络设置:

			- 指定容器的网络连接类型

			- bridge 使用docker daemon指定的网桥

			- host //容器使用主机的网络

			- container:NAME_or_ID >//使用其他容器的网路，共享IP和PORT等网络资源

			- none 容器使用自己的网络（类似--net=bridge），但是不进行配置

		- --privileged=false， 指定容器是否为特权容器，特权容器拥有所有的capabilities

		- --restart="no"， 指定容器停止后的重启策略:

		- no：容器退出时不重启

		- on-failure：容器故障退出（返回值非零）时重启

		- always：容器退出时总是重启

		- --rm=false， 指定容器停止后自动删除容器(不支持以docker run -d启动的容器)

		- --sig-proxy=true， 设置由代理接受并处理信号，但是SIGCHLD、SIGSTOP和SIGKILL不能被代理

	- [【示例】](https://www.cnblogs.com/ycg-blog/p/12666119.html)

		- 运行一个在后台执行的容器，同时，还能用控制台管理：docker run -i -t -d ubuntu:latest

		- 运行一个带命令在后台不断执行的容器，不直接展示容器内部信息：docker run -d ubuntu:latest ping www.docker.com

		- 运行一个在后台不断执行的容器，同时带有命令，程序被终止后还能重启继续跑，还能用控制台管理，docker run -d --restart=always ubuntu:latest ping www.docker.com

		- 为容器指定一个名字，docker run -d --name=ubuntu_server ubuntu:latest

		- 容器暴露80端口，并指定宿主机80端口与其通信(: 之前是宿主机端口，之后是容器需暴露的端口)，docker run -d --name=ubuntu_server -p 80:80 ubuntu:latest

		- 指定容器内目录与宿主机目录共享(: 之前是宿主机文件夹，之后是容器需共享的文件夹)，docker run -d --name=ubuntu_server -v /etc/www:/var/www ubuntu:latest

		- docker run -d --rm --name webres -p 27017:27017 -v $PWD/db/.data/configdb:/data/configdb -v $PWD/db/.data/db:/data/db -e MONGO_INITDB_ROOT_USERNAME=webres -e MONGO_INITDB_ROOT_PASSWORD=123456 mongo:4

	- 【示例】

		- docker run ubuntu:15.10 /bin/echo "hello world"

		- docker run -i -t ubuntu:15.10 /bin/bash

		- docker run -d ubuntu:15.10 /bin/sh -c "while true; do echo hello world; sleep 1; done"

			- 使用-p 将您的机器的端口4000映射到集装箱发布的端口80

				- docker run -p 4000:80 friendlyhello

			- -d

				- detached

					- docker run -d -p 4000:80 friendlyhello

		- docker run -p 80:80 -v nginx-html:/usr/share/nginx/html -d --name nginx nginx:latest

			- 使用镜像 nginx:latest，以后台模式启动一个容器,将容器的 80 端口映射到主机的 80 端口,将容器的/usr/share/nginx/html目录映射到主机目录下的docker中的nginx-html数据卷中。并取名为nginx。 可以看到容器的状态变成了up。

			- 每个docker容器和我们宿主机之间存在隔离关系，假设有一个nginx服务，内部容器监听的端口号是80，这时候如何将外面访问宿主机80端口号的时候，能够访问到nginx服务呢

			- 所以我们需要作出映射通过-p将宿主机上的80端口和nginx端口进行映射。

			- -v将宿主机中的目录挂载到容器的目录中，便于以后数据的备份和防止容器删除后数据的丢失。

- docker exec   (在运行的容器中执行命令)

	- 很多时候，我们需要的操作并不仅仅是按照镜像所给出的命令启动容器而已，我们还会希望进一步了解容器或者操作容器，这时候最佳的方式就是让我们进入到容器内部

	- docker exec -it ngnix bash

	- 你会发现命令行前缀变成了一串容器的hash，说明你已经成功进入了容器内部。这里我是以bash方式进入了，当然你也可以以其他的交互方式进入。-it命令和上方的docker run中的参数一样，在run中代表着创建一个新的容器并启动进入容器内部

- docker rmi 删除镜像

	- 删除容器或者镜像

		- docker rmi 镜像id

		- docker rmi 容器id

		- 需要注意的是，如果容器正在运行中，需要先将容器停止后方能删除。

	- 删除单个 docker rmi&nbsp;镜像id/镜像名称

	- 删除多个镜像 docker rmi id1 id2

	- 删除全部镜像 docker rmi ${docker images -qa}

	  docker rmi `docker images -qa`
	  
	  $() ($+小括号)子shell命令
- docker inspect (获取容器/镜像的元数据)

	- docker inspect [容器id/镜像id]

	- 通过上述命令可以获取容器或者镜像的相关信息

	- 包含端口号映射情况，数据卷挂载情况，网络情况等，反正只要想看容器或者镜像的具体信息时候，敲这个命令准没错

- docker save load （导出镜像/导入镜像）

	- 将容器导出成一个tar文件-o指定为指定文件中

		- docker save -o nginx.tar [镜像id]

	- 导入镜像

		- docker load -i nginx.tar

- docker export import (导出容器/导入容器)

	- 将容器导出成一个tar文件

		- docker export -o nginx.tar [容器id]

	- 导入容器

		- 这里需要注意的是，使用docker import并非直接将容器导入，而是将容器运行时的内容以镜像的形式导入。所以导入的结果其实是一个镜像，而不是容器。

			- docker import nginx.tar

- docker cp

	- 用于容器与主机之间的数据拷贝

	- 【语法】

		- docker cp [OPTIONS] container:src_path dest_path
docker cp [OPTIONS] dest_path container:src_path 


	- 【例子】

		- docker cp b80f4b3ad86a:/root/Neptune/docs ~/

		- 将b80f4b3ad86adocker中的docs文件夹复制到宿主机的home目录下

		- 在主机目录下创建一个abc.txt文件

			- touch abc.txt

			- 将目录下的abc.txt文件移到容器中的/data目录下

			- docker cp ./abc.txt a175b4a2fd94:/data

			- 进入容器内部

				- docker exec -it a175b4a2fd94 bash

			- 会发现/data目录下存在了abc.txt文件，反之，容器内容的文件或者目录也可以复制到主机内，只要将两者调换顺序即可。

				- docker cp  a175b4a2fd94:/data /data/

- docker logs

	- 获取容器的日志

- 其他不常用的命令

	-  
![image](assets/ed839993be9c79e5dbae31ce5bd30d8e107f80e734df4a7c2335f3cf80a32277.png)

- docker 运行命令

	- 新建并运行

		- docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

			- OPTIONS --name为容器指定新名称
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -d 后台运行
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -i交换方式运行
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -t伪终端
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -p端口映射
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; -P随机端口映射


			  docker ps status列中包含up，标识服务已经起来了
			  
			  
			  
	- 列出所有运行的容器

		- docker ps [options]

			- -a :所有正在运行和运行过的
-l: 显示最近创建的容器
-n:显示最近创建的n个容器
-q:只显示容器id

	- 退出容器

		- exit / ctrl + d：退出并停止容器

		  待验证
		- ctrl+p+q:退出不停止容器

	- 启动容器

		- docker start 容器id/名称

		  启动已经退出的容器
		  
	- 重启容器

		- docker restart 容器id/名称

	- 停止容器

		- docker stop&nbsp;容器id/名称

	- 强制停止所有容器

		- docker kill 容器id/名称

	- 删除容器

		- docker rm 容器id/名称

	- 删除所有容器

		- docker rm -f $(docker ps -aq)
docker ps -a -q | xargs docker rm

	- 以后台方式运行容器

		- docker run -d 容器

		  不占用当前终端
		  
		  比如tomcat容器，有后台方式运行就不占用当前控制台
		  
		  
	- 进入正在运行的容器，并以前台方式运行

		- docker exec -it 容器id/名称 bashshell 产生新的进程

		  -t 伪终端
		  docker exec -it c600f5bdd5b0 /bin/bash
		  
		  docker exec -it c600f5bdd5b0 bash
		  
		- docker attach 容器id/名称 进入容器不产生新的进程

		- -it：exec -i:  --interactive(相互作用的)       Keep STDIN open even if not attached(即使没有连接，也要保持STDIN打开)
       exec -t:   --tty                          Allocate a pseudo-TTY(分配一个 冒充的终端设备)

	- 容器 <->拷贝文件<->主机

		- docker copy 容器id/名称:容器中路径 主机路径
docker copy&nbsp;主机路径 容器id/名称:容器中路径&nbsp;

		  docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
		  
		  docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH
		  
### 57.1.2. Dockerfile介绍

- 是什么

  构建Docker镜像的构建文件
- 执行流程

- 关键字

	- FROM

		- 基础镜像，当前镜像是基于那个镜像

	- MAINTAINER

		- 镜像维护者的姓名和邮箱地址

	- RUN

		- 镜像构建时需要运行的命令

	- WORKDIR

		- 容器创建后，默认在那个目录

	- EXPOSE

		- 当前容器对外暴露的接口

	- ENV

		- 用来构建镜像时设置环境变量

	- ADD

		- 将宿主机目录下的文件copy到镜像且ADD命令会自动解压压缩包

		  ADD 不能加压zip包
	- COPY

		- 拷贝数据

	- VOLUME

		- 容器数据卷，用来保存和持久化

	- CMD

		- 指定容器启动时需要运行的命令

		- 多条CMD命令，只有最后一条生效

		- CMD命令会被docker run之后的参数替换

	- ENTRYPOINT

		- 指定容器启动过程中需要运行的命令

		- 把docker run命令的参数追加到后面

	- ONBUILD

### 57.1.3. docker compose

- 【背景】

	- 往往一个完整的项目可能很多容器组成，为每个容器挂载网络，指定数据卷会变非常的麻烦，幸好，docker-compose为我们解决了这儿问题

- 【Compose 简介】

	- 是用于定义和运行多容器 Docker 应用程序的工具。

- 【Compose 安装】

	- Linux

		-  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

		- sudo chmod +x /usr/local/bin/docker-compose

		- sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

		- docker-compose --version

- 【示例】

	- nginx容器配置文件

		-  
![image](assets/945b07e741198b17b88836aa6656c4cbf008766b59641e81dfa794c4728f7b7e.png)

	- 关键字含义

		-  
![image](assets/cedad870806c039ea9b45c4e15f052ef3c9808ca86dc0a601075e0bda6b48fa2.png)

	- 通过docker-compose up -d 启动容器 如果有重名的容器记得先删除

		-  
![image](assets/7619056887ac2981d3ebb047ea9c1c9448c316f1eee57e078c1bece3f5561540.png)

- 【常见命令】

	- docker-compose ps

		- 列出所有运行容器

			-  
![image](assets/010d7d17803ab76c2eedbcc8dcab10140e6f2d8aa9837a8a2c825080130b0758.png)

	- logs：查看服务日志输出

		- docker-compose logs

	- port：打印绑定的公共端口，下面命令可以输出 eureka 服务 8761 端口所绑定的公共端口

		- docker-compose port eureka 8761

	- build：构建或者重新构建服务

		- docker-compose build

	- start：启动指定服务已存在的容器

		- docker-compose start eureka

	- stop：停止已运行的服务的容器

		- docker-compose stop eureka

	- rm：删除指定服务的容器

		- docker-compose rm eureka

	- up：构建、启动容器

		- docker-compose up

	- kill：通过发送 SIGKILL 信号来停止指定服务的容器

		- docker-compose kill eureka

	- pull：下载服务镜像

	- scale：设置指定服务运气容器的个数，以 service=num 形式指定

		- docker-compose scale user=3 movie=3

	- run：在一个服务上执行一个命令

		- docker-compose run web bash

- 【docker-compose.yml 属性】

	- version：指定 docker-compose.yml 文件的写法格式

	- services：多个容器集合

	- build：配置构建时，Compose 会利用它自动构建镜像，该值可以是一个路径，也可以是一个对象，用于指定 Dockerfile 参数

		- build: ./dir
---------------
build:
    context: ./dir
    dockerfile: Dockerfile
    args:
        buildno: 1

	- command：覆盖容器启动后默认执行的命令

		- command: bundle exec thin -p 3000
----------------------------------
command: [bundle,exec,thin,-p,3000]

	- dns：配置 dns 服务器，可以是一个值或列表

		- dns: 8.8.8.8
------------
dns:
    - 8.8.8.8
    - 9.9.9.9

	- dns_search：配置 DNS 搜索域，可以是一个值或列表

		- dns_search: example.com
------------------------
dns_search:
    - dc1.example.com
    - dc2.example.com

	- environment：环境变量配置，可以用数组或字典两种方式

		- environment:
    RACK_ENV: development
    SHOW: 'ture'
-------------------------
environment:
    - RACK_ENV=development
    - SHOW=ture

	- env_file：从文件中获取环境变量，可以指定一个文件路径或路径列表，其优先级低于 environment 指定的环境变量

		- env_file: .env
---------------
env_file:
    - ./common.env

	- expose：暴露端口，只将端口暴露给连接的服务，而不暴露给主机

		- expose:
    - "3000"
    - "8000"

	- image：指定服务所使用的镜像

		- image: java

	- network_mode：设置网络模式

		- network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"

	- ports：对外暴露的端口定义，和 expose 对应

		- ports:   # 暴露端口信息  - "宿主机端口:容器暴露端口"
- "8763:8763"
- "8763:8763"

	- links：将指定容器连接到当前连接，可以设置别名，避免ip方式导致的容器重启动态改变的无法连接情况

		- links:    # 指定服务名称:别名 
    - docker-compose-eureka-server:compose-eureka

	- volumes：卷挂载路径

		- volumes:
  - /lib
  - /var

	- logs：日志输出信息

		- --no-color          单色输出，不显示其他颜.
-f, --follow        跟踪日志输出，就是可以实时查看日志
-t, --timestamps    显示时间戳
--tail              从日志的结尾显示，--tail=200

- 【Docker  Compose 其他】

	- 更新容器

		- 当服务的配置发生更改时，可使用 docker-compose up 命令更新配置

		- 此时，Compose 会删除旧容器并创建新容器，新容器会以不同的 IP 地址加入网络，名称保持不变，任何指向旧容起的连接都会被关闭，重新找到新容器并连接上去

	- links

		- 服务之间可以使用服务名称相互访问，links 允许定义一个别名，从而使用该别名访问其它服务

		- version: '2'
services:
    web:
        build: .
        links:
            - "db:database"
    db:
        image: postgres

		- 这样 Web 服务就可以使用 db 或 database 作为 hostname 访问 db 服务了

### 57.1.4. docker参考文档：

- [1.使用Docker构建统一的前端开发环境](https://blog.csdn.net/M2l0ZgSsVc7r69eFdTj/article/details/80650053)

- [2.【前端部署附录一】写给前端的 docker 极简入门](https://juejin.cn/post/7103903128700846088)

	-  
![image](assets/b06ead1b7398b06fdedad818ca8b317de2f8188446ef479241d39d09ff74b476.png)

	-  
![image](assets/7d4363fe03df17f4d2c9fec770b8440cfae3e72f4244bb3d539535dd8254f542.png)

	- 一些基础概念讲解得比较清晰

## 57.2. git github

### 57.2.1. 命令集合

- [github打不开解决方式](https://blog.csdn.net/A_pointer2/article/details/113362994)

  somebody says：今天有人说不知为何最近网络不太正常。这就是年轻人不知节气，不懂时令。每年惊蛰、芒种前后网络都会不太好，需要提前做准备。惊蛰是万物复苏的时候，海里的蛤蟆虾米咸带鱼也开始活动，所以会影响到海底光缆。而芒种又要收麦子又要种晚稻，一收一种，上行流量和下行流量同时激增，必然影响网络访问。
  
  # GitHub Start 
  140.82.113.3      github.com
  140.82.114.20     gist.github.com
  
  151.101.184.133    assets-cdn.github.com
  151.101.184.133    raw.githubusercontent.com
  199.232.28.133     raw.githubusercontent.com 
  151.101.184.133    gist.githubusercontent.com
  151.101.184.133    cloud.githubusercontent.com
  151.101.184.133    camo.githubusercontent.com
  199.232.96.133     avatars.githubusercontent.com
  151.101.184.133    avatars0.githubusercontent.com
  199.232.68.133     avatars0.githubusercontent.com
  199.232.28.133     avatars0.githubusercontent.com 
  199.232.28.133     avatars1.githubusercontent.com
  151.101.184.133    avatars1.githubusercontent.com
  151.101.108.133    avatars1.githubusercontent.com
  151.101.184.133    avatars2.githubusercontent.com
  199.232.28.133     avatars2.githubusercontent.com
  151.101.184.133    avatars3.githubusercontent.com
  199.232.68.133     avatars3.githubusercontent.com
  151.101.184.133    avatars4.githubusercontent.com
  199.232.68.133     avatars4.githubusercontent.com
  151.101.184.133    avatars5.githubusercontent.com
  199.232.68.133     avatars5.githubusercontent.com
  151.101.184.133    avatars6.githubusercontent.com
  199.232.68.133     avatars6.githubusercontent.com
  151.101.184.133    avatars7.githubusercontent.com
  199.232.68.133     avatars7.githubusercontent.com
  151.101.184.133    avatars8.githubusercontent.com
  199.232.68.133     avatars8.githubusercontent.com
  199.232.96.133     avatars9.githubusercontent.com
  199.232.96.133     avatars.githubusercontent.com
  
  # GitHub End
  ps：https://blog.csdn.net/A_pointer2/article/details/113362994
  
- git命令大全

  常用命令大全 我们我们开发时候在工作区，当我们把修改，add之后，修改内容会被提到暂存区，当我们commit 之后修改的内容 会被提到我们本地的仓库（repository）,当我们push之后，会被提到远程仓库（remote） Workspace：工作区 Index / Stage：暂存区 Repository：仓库区（或本地仓库） Remote：远程仓库 一、新建代码库 在当前目录新建一个Git代码库 git init 新建一个目录，将其初始化为Git代码库 git init [project-name] 下载一个项目和它的整个代码历史 git clone [url] 生成ssh git config --global user.name "yk" 添加邮箱 git config --global user.email "youremail@163.com" 生成公钥 生成ssh-keygen -t rsa -C "你的邮箱" 连续回车 ssh-keygen -t rsa 生成公钥 （然后有个C盘的路径，沿着那个路径找到那个文件，把里面的内容粘贴过来，在GitHub上那个ssh，设置秘钥，密码粘进去） 添加到暂存区 添加指定文件到暂存区 git add [file1] [file2] ... 添加指定目录到暂存区，包括子目录 $ git add [dir] 添加当前目录的所有文件到暂存区 $ git add . 添加每个变化前，都会要求确认 对于同一个文件的多处变化，可以实现分次提交 git add -p 删除工作区文件，并且将这次删除放入暂存区 git rm [file1] [file2] ... 改名文件，并且将这个改名放入暂存区 git mv [file-original] [file-renamed] 代码提交 提交暂存区到仓库区 git commit -m [message] 提交暂存区的指定文件到仓库区 git commit [file1] [file2] ... -m [message] 使用一次新的commit，替代上一次提交 如果代码没有任何新变化，则用来改写上一次commit的提交信息 git commit --amend -m [message] 分支 查看所有分支 git branch -a 查看所有远程分支 git branch -r 查看所有本地分支 git branch 新建一个分支，但依然停留在当前分支 git branch [branch-name] 新建一个分支，并切换到该分支 git checkout -b [branch] 切换到指定分支，并更新工作区 git checkout [branch-name] 切换到上一个分支 git checkout - 合并指定分支到当前分支 git merge [branch] 删除本地分支 git branch -d  强制删除本地分支 git branch -D  删除远程分支 git push origin --delete [branch-name] git branch -dr [remote/branch] 新建一个分支，与指定的远程分支建立追踪关系 git branch --track [branch] [remote-branch] git branch -d 删除分支，会在删除前检查merge状态，避免误删没有合并的分支。 git branch -D 是git branch --delete --force的简写，它会强制删除该分支。 如果想要删除远程分支以及追踪分支需使用: git push --origin -delete branch 查看信息 显示有变更的文件 git status 显示当前分支的版本历史 git log 如果嫌输出信息太多，看得眼花缭乱的，可以试试加上--pretty=oneline参数： git log --pretty=oneline 搜索提交历史，根据关键词 $ git log -S [keyword] 显示某个文件的版本历史，包括文件改名 git log --follow [file] git whatchanged [file] 显示过去5次提交 git log -5 --pretty --oneline 显示暂存区和工作区的差异 git diff 显示当前分支的最近几次提交 git reflog 远程同步 上传本地指定分支到远程仓库 git push [remote] [branch] 强行推送当前分支到远程仓库，即使有冲突 git push [remote] --force 推送所有分支到远程仓库 git push [remote] --all 下载远程仓库的所有变动 git fetch [remote] 显示所有远程仓库 git remote -v 增加一个新的远程仓库，并命名 git remote add [shortname] [url] 取回远程仓库的变化，并与本地分支合并 git pull [remote] [branch] 撤销 恢复暂存区的指定文件到工作区 git checkout [file] 恢复暂存区的所有文件到工作区 git checkout . 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变 git reset [file] 重置暂存区与工作区，与上一次commit保持一致 git reset --hard 恢复某个commit的指定文件到暂存区和工作区 git checkout [commit] [file] 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变 git reset [commit] 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致 git reset --hard [commit] git reset --hard 1094a //返回到指定某一版本 Git必须知道当前版本是哪个版本，在Git中，用HEAD表示当前版本，也就是最新的提交1094adb...（注意我的提交ID和你的肯定不一样），上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100。 git reset --hard HEAD^ //返回上一个版本 暂时将未提交的变化移除，稍后再移入 $ git stash $ git stash pop 
  
- git reflog show --date=iso 5.2.0-uos

- git diff ^5.2.0-vpc 5.2.0-uos --stat | grep -v "resources\| built\| .data\| js/all.bundle.js\| zips\| *.json\| yarn*"

- [git config --global --replace-all core.pager "less -F -X"](https://stackoverflow.com/questions/2183900/how-do-i-prevent-git-diff-from-using-a-pager/2183920)

- git add -u <==> git add –update

- [git rm -rf configstore/  删除忽略文件，文件夹中的文件改动](https://www.jianshu.com/p/e5b13480479b)

- git status

	- 如果你使用 git status -s 命令或 git status --short 命令，你将得到一种格式更为紧凑的输出

	  $ git status -s
	   M README
	  MM Rakefile
	  A  lib/git.rb
	  M  lib/simplegit.rb
	  ?? LICENSE.txt
	  新添加的未跟踪文件前面有 ?? 标记，新添加到暂存区中的文件前面有 A 标记，修改过的文件前面有 M 标记。 输出中有两栏，左栏指明了暂存区的状态，右栏指明了工作区的状态。例如，上面的状态报告显示： README 文件在工作区已修改但尚未暂存，而 lib/simplegit.rb 文件已修改且已暂存。 Rakefile 文件已修，暂存后又作了修改，因此该文件的修改中既有已暂存的部分，又有未暂存的部分。
	  
	  
	  
- git checkout --ours {codefiles} 保留当前分支代码

- git checkout --theirs {codefiles} 保留要合并分支代码

- git checkout 'HEAD' built/*

- git log -p --word-diff built/0.js

- 删除项目中的所有.DS_Store。这会跳过不在项目中的 .DS_Store

	- 1.find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch
将 .DS_Store 加入到 .gitignore
2.echo .DS_Store >> ~/.gitignore
更新项目
3.git add --all
4.git commit -m '.DS_Store banished!'

- 只需要删除磁盘上的 .DS_Store: 删除当前目录及其子目录下的所有.DS_Store 文件

	- find . -name '*.DS_Store' -type f -delete

- 禁用或启用自动生成
禁止.DS_store生成：
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

恢复.DS_store生成：恢复.DS_store生成：
defaults delete com.apple.desktopservices DSDontWriteNetworkStores

### 57.2.2. [github 分析网站推荐](https://zhuanlan.zhihu.com/p/107503801)

- https://www.zhihu.com/search?type=content&q=onefetch

### 57.2.3. [SSHkey](https://segmentfault.com/a/1190000013759207)

### 57.2.4. 多个SSHKey配置生效的代码

Host github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github
User zaggerj

Host e.coding.net
HostName e.coding.net
PreferredAuthentications publickey
IdentityFile ~/.ssh/coding.net
User zaggerj

Host 172.16.203.254
HostName 172.16.203.254
PreferredAuthentications publickey
IdentityFile ~/.ssh/gitlab
User zagger

Host gitee.com
HostName gitee.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/gitee
User zagger

### 57.2.5. proxychains git push gitee master 

-  proxychains

### 57.2.6. git 基础

- 工作副本

- 快照

- 仓库

- 工作目录

	- 已跟踪文件

	- 未跟踪文件

- 暂存区

	- stage

- 跟踪新文件 

	- git add file

		- 文件处于已暂存状态

			- 只要在 Changes to be committed 这行下面的，就说明是已暂存状态

		- 该文件的版本将被留存在后续的历史记录中

		- git add 命令使用文件或目录的路径作为参数；如果参数是目录的路径，该命令将递归地跟踪该目录下的所有文件。

- 暂存已修改的文件

	- 出现在 Changes not staged for commit 这行下面，说明已跟踪文件的内容发生了变化，但还没有放到暂存区

	- 要暂存这次更新，需要运行 git add 命令

		- 功能

			- 1. 开始跟踪新文件

			- 2. 把已跟踪的文件放到暂存区

			- 3.  用于合并时把有冲突的文件标记为已解决状态等

		- git add命令的理解：

			- 精确地将内容添加到下一次提交中

	- 假设此时，你想要在 CONTRIBUTING.md 里再加条注释

		-  文件同时出现在暂存区和非暂存区

		- 实际上 Git 只不过暂存了你运行 git add 命令时的版本，而不是你运行git commit时，工作目录中的当前版本

			- 运行了 git add 之后又作了修订的文件，需要重新运行 git add 把最新版本重新暂存起来

- 状态简览

	- git status 命令的输出十分详细，但其用语有些繁琐。

	-  Git 有一个选项可以帮你缩短状态命令的输出，这样可以以简洁的方式查看更改。 如果你使用 git status -s 命令或 git status --short 命令，你将得到一种格式更为紧凑的输出。

		-  输出中有两栏，左栏指明了暂存区的状态，右栏指明了工作区的状态。

		- 新添加的未跟踪文件前面有 ?? 标记

		- 新添加到暂存区中的文件前面有 A 标记

		- 修改过的文件前面有 M 标记，README 文件在工作区已修改但尚未暂存

		-  lib/simplegit.rb 文件已修改且已暂存

		- Rakefile 文件已修，暂存后又作了修改，因此该文件的修改中既有已暂存的部分，又有未暂存的部分。

		- 例子：

			- $ git status -s
 M README
MM Rakefile
A  lib/git.rb
M  lib/simplegit.rb
?? LICENSE.txt

- 忽略文件

	- 一般我们总会有些文件无需纳入 Git 的管理，也不希望它们总出现在未跟踪文件列表

	- 通常都是些自动生成的文件，比如日志文件，或者编译过程中创建的临时文件等

	- .gitignore规范格式

	  文件 .gitignore 的格式规范如下：
	  所有空行或者以 # 开头的行都会被 Git 忽略。
	  
	  可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中。
	  匹配模式可以以（/）开头防止递归。
	  
	  匹配模式可以以（/）结尾指定目录。
	  
	  要忽略指定模式以外的文件或目录，可以在模式前加上叹号（!）取反。
	  所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。 星号（*）匹配零个或多个任意字符；[abc] 匹配任何一个列在方括号中的字符 （这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）； 问号（?）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符， 表示所有在这两个字符范围内的都可以匹配（比如 [0-9] 表示匹配所有 0 到 9 的数字）。 使用两个星号（**）表示匹配任意中间目录，比如 a/**/z 可以匹配 a/z 、 a/b/z 或 a/b/c/z 等。
	  
	  # 忽略所有的 .a 文件
	  *.a
	  
	  # 但跟踪所有的 lib.a，即便你在前面忽略了 .a 文件
	  !lib.a
	  
	  # 只忽略当前目录下的 TODO 文件，而不忽略 subdir/TODO
	  /TODO
	  
	  # 忽略任何目录下名为 build 的文件夹
	  build/
	  
	  # 忽略 doc/notes.txt，但不忽略 doc/server/arch.txt
	  doc/*.txt
	  
	  # 忽略 doc/ 目录及其所有子目录下的 .pdf 文件
	  doc/**/*.pdf
	  Tip | GitHub 有一个十分详细的针对数十种项目及语言的 .gitignore 文件列表， 你可以在 https://github.com/github/gitignore 找到它。
	  Note | 在最简单的情况下，一个仓库可能只根目录下有一个 .gitignore 文件，它递归地应用到整个仓库中。 然而，子目录下也可以有额外的 .gitignore 文件。子目录中的 .gitignore 文件中的规则只作用于它所在的目录中。 （Linux 内核的源码库拥有 206 个 .gitignore 文件。）多个 .gitignore 文件的具体细节超出了本书的范围，更多详情见 man gitignore 。
	  
		- # 忽略所有的 .a 文件
*.a

# 58. 但跟踪所有的 lib.a，即便你在前面忽略了 .a 文件
!lib.a

# 59. 只忽略当前目录下的 TODO 文件，而不忽略 subdir/TODO
/TODO

# 60. 忽略任何目录下名为 build 的文件夹
build/

# 61. 忽略 doc/notes.txt，但不忽略 doc/server/arch.txt
doc/*.txt

# 62. 忽略 doc/ 目录及其所有子目录下的 .pdf 文件
doc/**/*.pdf

		- Tip：GitHub 有一个十分详细的针对数十种项目及语言的 .gitignore 文件列表， 你可以在 https://github.com/github/gitignore 找到它。

		- Note：在最简单的情况下，一个仓库可能只根目录下有一个 .gitignore 文件，它递归地应用到整个仓库中。 然而，子目录下也可以有额外的 .gitignore 文件。子目录中的 .gitignore 文件中的规则只作用于它所在的目录中。 （Linux 内核的源码库拥有 206 个 .gitignore 文件。）

多个 .gitignore 文件的具体细节超出了本书的范围，更多详情见 man gitignore 。

	- 例子：

		- $ cat .gitignore
*.[oa]
*~

			- 第一行告诉 Git 忽略所有以 .o 或 .a 结尾的文件

				- 一般这类对象文件和存档文件都是编译过程中出现的

			- 第二行告诉 Git 忽略所有名字以波浪符（~）结尾的文件

				- 许多文本编辑软件（比如 Emacs）都用这样的文件名保存副本

- 查看已暂存和未暂存的修改

	- git diff 命令

		- git diff通常可能会用它来回答这两个问题：当前做的哪些更新尚未暂存？ 有哪些更新已暂存并准备好下次提交？

		- 虽然 git status 已经通过在相应栏下列出文件名的方式回答了这个问题，但 git diff 能通过文件补丁的格式更加具体地显示哪些行发生了改变。

		- git diff：此命令比较的是工作目录中当前文件和暂存区域快照之间的差异

			-  也就是修改之后还没有暂存起来的变化内容。

		- git diff --staged：这条命令将比对已暂存文件与最后一次提交的文件差异

		- Note：Git Diff 的插件版本
在本书中，我们使用 git diff 来分析文件差异。 但是你也可以使用图形化的工具或外部 diff 工具来比较差异。 可以使用 git difftool 命令来调用 emerge 或 vimdiff 等软件（包括商业软件）输出 diff 的分析结果。 使用 git difftool --tool-help 命令来看你的系统支持哪些 Git Diff 插件。

- 提交更新

	- git commit

		- 确认还有什么已修改或新建的文件还没有 git add 过， 否则提交的时候不会记录这些尚未暂存的变化

			- git commit

			- 这样会启动你选择的文本编辑器来输入提交说明。

			- Note：启动的编辑器是通过 Shell 的环境变量 EDITOR 指定的，一般为 vim 或 emacs。 当然也可以按照 起步 介绍的方式， 使用 git config --global core.editor 命令设置你喜欢的编辑器。

	- git commit -v

		- 更详细的内容修改提示可以用 -v 选项查看，这会将你所作的更改的 diff 输出呈现在编辑器中，以便让你知道本次提交具体作出哪些修改。

	- git commit -m "Story 182: Fix benchmarks for speed"

	- 提交时记录的是放在暂存区域的快照

		- 任何还未暂存文件的仍然保持已修改状态，可以在下次提交时纳入版本管理

		- 每一次运行提交操作，都是对你项目作一次快照，以后可以回到这个状态，或者进行比较。

- 跳过使用暂存区域

	- 给 git commit 加上 -a 选项

		- 提交之前不再需要 git add 文件“CONTRIBUTING.md”了。 这是因为 -a 选项使本次提交包含了所有修改过的文件。 这很方便

- 移除文件

	- 要从 Git 中移除某个文件

		- 必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。

		- 可以用 git rm 命令完成此项工作

			- 并连带从工作目录中删除指定的文件，这样以后就不会出现在未跟踪文件清单中了

		- 如果只是简单地从工作目录中手工删除文件

			- 运行 git status 时就会在 “Changes not staged for commit” 部分（也就是 未暂存清单）看到

		- git rm PROJECTS.md

			- 下一次提交时，该文件就不再纳入版本管理了

		- git rm --cached README

			- 你想让文件保留在磁盘，但是并不想让 Git 继续跟踪。

			- 当你忘记添加 .gitignore 文件，不小心把一个很大的日志文件或一堆 .a 这样的编译生成文件添加到暂存区时

		- git rm log/\*.log

			- 注意到星号 * 之前的反斜杠 \， 因为 Git 有它自己的文件模式扩展匹配方式，所以我们不用 shell 来帮忙展开。 此命令删除 log/ 目录下扩展名为 .log 的所有文件

		- $ git rm \*~

			- 该命令会删除所有名字以 ~ 结尾的文件。

- 移动文件

	-  如果在 Git 中重命名了某个文件，仓库中存储的元数据并不会体现出这是一次改名操作

	- git mv file_from file_to

		- 即便此时查看状态信息，也会明白无误地看到关于重命名操作的说明

		- 其实，运行 git mv 就相当于运行了下面三条命令：

			- $ mv README.md README

			- $ git rm README.md

			- $ git add README

		- 如此分开操作，Git 也会意识到这是一次重命名，所以不管何种方式结果都一样。 

			- 两者唯一的区别是，mv 是一条命令而非三条命令，直接用 git mv 方便得多。 

			- 不过有时候用其他工具批处理重命名的话，要记得在提交前删除旧的文件名，再添加新的文件名。

### 62.1.1. git操作

- 查看提交历史

	- git log 的常用选项

		- 选项	说明

		- -p 按补丁格式显示每个提交引入的差异。

		- --stat 显示每次提交的文件修改统计信息。

		- --shortstat 只显示 --stat 中最后的行数修改添加移除统计。

		- --name-only 仅在提交信息后显示已修改的文件清单。

		- --name-status 显示新增、修改、删除的文件清单。

		- --abbrev-commit 仅显示 SHA-1 校验和所有 40 个字符中的前几个字符。

		- --relative-date 使用较短的相对时间而不是完整格式显示日期（比如“2 weeks ago”）。

		- --graph 在日志旁以 ASCII 图形显示分支与合并历史。

		- --pretty 使用其他格式显示历史提交信息。可用的选项包括 oneline、short、full、fuller 和 format（用来定义自己的格式）。

		- --oneline --pretty=oneline --abbrev-commit 合用的简写。

	- git log

	- git log -p/--patch

		- 显示每次提交所引入的差异

	- git log -p -2

		- 限制显示的日志条目数量

	- git log --stat

		- 附带一系列的总结性选项。 比如你想看到每次提交的简略统计信息

		- 每次提交的下面列出所有被修改过的文件、有多少文件被修改了以及被修改过的文件的哪些行被移除或是添加了。 在每次提交的最后还有一个总结。

	- --pretty

		- 选项可以使用不同于默认格式的方式展示提交历史。 这个选项有一些内建的子选项供你使用

		- 比如 oneline 会将每个提交放在一行显示，在浏览大量的提交时非常有用。 另外还有 short，full 和 fuller 选项，它们展示信息的格式基本一致，但是详尽程度不一

		- git log --pretty=oneline

			- ca82a6dff817ec66f44342007202690a93763949 changed the version number
085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test
a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

		- git log --pretty=format:"%h - %an, %ar : %s"

			- ca82a6d - Scott Chacon, 6 years ago : changed the version number
085bb3b - Scott Chacon, 6 years ago : removed unnecessary test
a11bef0 - Scott Chacon, 6 years ago : first commit

			- git log --pretty=format 常用的选项 列出了 format 接受的常用格式占位符的写法及其代表的意义。

				- 选项	说明

				- %H 提交的完整哈希值

				- %h 提交的简写哈希值

				- %T 树的完整哈希值

				- %t 树的简写哈希值

				- %P 父提交的完整哈希值

				- %p 父提交的简写哈希值

				- %an 作者名字

				- %ae 作者的电子邮件地址

				- %ad 作者修订日期（可以用 --date=选项 来定制格式）

				- %ar 作者修订日期，按多久以前的方式显示

				- %cn 提交者的名字

				- %ce 提交者的电子邮件地址

				- %cd 提交日期

				- %cr 提交日期（距今多长时间）

				- %s 提交说明

	- --graph

		- 	git log --pretty=format:"%h %s" --graph

			- 这个选项添加了一些 ASCII 字符串来形象地展示你的分支、合并历史：

	- -S（俗称“pickaxe”选项，取“用鹤嘴锄在土里捡石头”之意）

		- 它接受一个字符串参数，并且只会显示那些添加或删除了该字符串的提交。

		-  假设你想找出添加或删除了对某一个特定函数的引用的提交，可以调用：

		- $ git log -S function_name

	- path

		-  如果只关心某些文件或者目录的历史提交，可以在 git log 选项的最后指定它们的路径。 因为是放在最后位置上的选项，所以用两个短划线（--）隔开之前的选项和后面限定的路径名。

	- 限制输出长度

		-  -<n> 的选项

			- 其中的 n 可以是任何整数，表示仅显示最近的 n 条提交。 

				- 不过实践中这个选项不是很常用，因为 Git 默认会将所有的输出传送到分页程序中，所以你一次只会看到一页的内容。

		- --since 和 --until 

			- 该命令可用的格式十分丰富——可以是类似 "2008-01-15" 的具体的某一天，也可以是类似 "2 years 1 day 3 minutes ago" 的相对日期。

			- git log --since=2.weeks

			- git log --since="1.day"

		- Note：还可以过滤出匹配指定条件的提交。 用 --author 选项显示指定作者的提交，用 --grep 选项搜索提交说明中的关键字。

		- Note：你可以指定多个 --author 和 --grep 搜索条件，这样会只输出 任意 匹配 --author 模式和 --grep 模式的提交。然而，如果你添加了 --all-match 选项， 则只会输出 所有 匹配 --grep 模式的提交。

		- 限制输出选项

			- -<n> 仅显示最近的 n 条提交。

			- --since, --after 仅显示指定时间之后的提交。

			- --until, --before 仅显示指定时间之前的提交。

			- --author 仅显示作者匹配指定字符串的提交。

			- --committer 仅显示提交者匹配指定字符串的提交。

			- --grep 仅显示提交说明中包含指定字符串的提交。

			- -S 仅显示添加或删除内容匹配指定字符串的提交。

		- 例子：

			- git log --pretty="%h - %s" --author='Junio C Hamano' --since="2008-10-01" \
   --before="2008-11-01" --no-merges -- t/

				- 在 Git 源码库中查看 Junio Hamano 在 2008 年 10 月其间， 除了合并提交之外的哪一个提交修改了测试文件

			- git log --pretty="%h - %s" --author="zagger" --since="2021-04-01" --before="2021-05-01" --no-merges -- js/ 

		- Tip：隐藏合并提交
按照你代码仓库的工作流程，记录中可能有为数不少的合并提交，它们所包含的信息通常并不多。 为了避免显示的合并提交弄乱历史记录，可以为 log 加上 --no-merges 选项。

- 撤销操作

	- git commit --amend

		- 这个命令会将暂存区中的文件提交

			- 如果自上次提交以来你还未做任何修改（例如，在上次提交后马上执行了此命令）， 那么快照会保持不变，而你所修改的只是提交信息。

		- 你提交后发现忘记了暂存某些需要的修改

			- $ git commit -m 'initial commit'
$ git add forgotten_file
$ git commit --amend

			- 最终你只会有一个提交——第二次提交将代替第一次提交的结果。

			- Note：当你在修补最后的提交时，并不是通过用改进后的提交 原位替换 掉旧有提交的方式来修复的， 理解这一点非常重要。从效果上来说，就像是旧有的提交从未存在过一样，它并不会出现在仓库的历史中。
修补提交最明显的价值是可以稍微改进你最后的提交，而不会让“啊，忘了添加一个文件”或者 “小修补，修正笔误”这种提交信息弄乱你的仓库历史。

	- 取消暂存的文件

### 62.1.2. git工具

- [git reset
重置揭秘](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%87%8D%E7%BD%AE%E6%8F%AD%E5%AF%86#_git_reset)

	- 三棵树

	  理解 reset 和 checkout 的最简方法，就是以 Git 的思维框架（将其作为内容管理器）来管理三棵不同的树。 “树” 在我们这里的实际意思是 “文件的集合”，而不是指特定的数据结构。 （在某些情况下索引看起来并不像一棵树，不过我们现在的目的是用简单的方式思考它。）
	  
	  Git 作为一个系统，是以它的一般操作来管理并操纵这三棵树的：
	  
		- HEAD

			- 上一次提交的快照，下一次提交的父结点

			- HEAD 是当前分支引用的指针，它总是指向该分支上的最后一次提交。 这表示 HEAD 将是下一次提交的父结点。

			- 该分支上的最后一次提交 的快照。

		- Index

			- 预期的下一次提交的快照

			- 索引是你的 预期的下一次提交。

			- 我们也会将这个概念引用为 Git 的“暂存区”，这就是当你运行 git commit 时 Git 看起来的样子。

		- Working Directory

			- 沙盒

			- 工作目录会将它们解包为实际的文件以便编辑。 你可以把工作目录当做 沙盒。在你将修改提交到暂存区并记录到历史之前，可以随意更改。

	- 工作流程

		- Git 工作流程是通过操纵这三个区域来以更加连续的状态记录项目快照的

		  ￼
		  
		- 假设我们进入到一个新目录，其中有一个文件。 我们称其为该文件的 v1 版本，将它标记为蓝色。

		-  现在运行 git init，这会创建一个 Git 仓库，其中的 HEAD 引用指向未创建的 master 分支。（？“未创建”是指还没有提交？）

		  ￼
		  
		- 此时，只有工作目录有内容。

		- 现在我们想要提交这个文件，所以用 git add 来获取工作目录中的内容，并将其复制到索引中。

		  ￼
		  
		- 接着运行 git commit，它会

			- 1. 取得索引（Index）中的内容并将它保存为一个永久的快照， 

			- 然后2. 创建一个指向该快照的提交对象，

			- 最后3. 更新 master 来指向本次提交。

			  ￼
			  
		- 此时如果我们运行 git status，会发现没有任何改动，因为现在三棵树完全相同。

		- 现在我们想要对文件进行修改然后提交它。 我们将会经历同样的过程；

		- 首先在工作目录中修改文件。 我们称其为该文件的 v2 版本，并将它标记为红色。

		  ￼
		  
		- 如果现在运行 git status，我们会看到文件显示在 “Changes not staged for commit” 下面并被标记为红色，

		- ！！！因为该条目在索引与工作目录之间存在不同。

		-  接着我们运行 git add 来将它暂存到索引中。

		  ￼
		  
		- 此时，由于索引和 HEAD 不同，

		- 若运行 git status 的话就会看到 “Changes to be committed” 下的该文件变为绿色 ——

		- 也就是说，现在预期的下一次提交与上一次提交不同。 

		- 最后，我们运行 git commit 来完成提交。

		  ￼
		  
		- 现在运行 git status 会没有输出，因为三棵树又变得相同了。

		- 切换分支或克隆的过程也类似。 

		- 当检出一个分支时，

			- ！！！它会修改 HEAD 指向新的分支引用，

			- ！！！将 索引 填充为该次提交的快照， 

			- ！！！然后将 索引 的内容复制到 工作目录 中。

	- 重置的作用

		- 在以下情景中观察 reset 命令会更有意义。

		- 为了演示这些例子，假设我们再次修改了 file.txt 文件并第三次提交它。 现在的历史看起来是这样的：

		  ￼
		  
		- 第 1 步：移动 HEAD（--soft）

			- reset 做的第一件事是移动 HEAD 的指向。

			- reset 移动 HEAD 指向的分支

			-  这意味着如果 HEAD 设置为 master 分支（例如，你正在 master 分支上）， 运行 git reset 9e5e6a4 将会使 master 指向 9e5e6a4。

			  ￼
			  
			- 无论你调用了何种形式的带有一个提交的 reset，它首先都会尝试这样做。 使用 reset --soft，它将仅仅停在那儿。

			- 理解一下发生的事情：它本质上是撤销了上一次 git commit 命令。 当你在运行 git commit 时，Git 会创建一个新的提交，并移动 HEAD 所指向的分支来使其指向该提交。

			-  当你将它 reset 回 HEAD~（HEAD 的父结点）时，其实就是把该分支移动回原来的位置，而不会改变索引和工作目录。

			- 现在你可以更新索引并再次运行 git commit 来完成 git commit --amend 所要做的事情了

		- 第 2 步：更新索引（--mixed）

			- 注意，如果你现在运行 git status 的话，就会看到新的 HEAD 和以绿色标出的它和索引之间的区别。

			- 接下来，reset 会用 HEAD 指向的当前快照的内容来更新索引。

			  ￼
			  
			- 如果指定 --mixed 选项，reset 将会在这时停止。 这也是默认行为

			- 所以如果没有指定任何选项（在本例中只是 git reset HEAD~），这就是命令将会停止的地方。

			- 现在再看一眼上图，理解一下发生的事情：它依然会撤销一上次 提交，但还会 取消暂存 所有的东西。 

			- 于是，我们回滚到了所有 git add 和 git commit 的命令执行之前。

		- 第 3 步：更新工作目录（--hard）

			- reset 要做的的第三件事情就是让工作目录看起来像索引。

			  ￼
			  
			- 你撤销了最后的提交、git add 和 git commit 命令 以及 工作目录中的所有工作。

			- 必须注意，--hard 标记是 reset 命令唯一的危险用法，它也是 Git 会真正地销毁数据的仅有的几个操作之一。 

			- 其他任何形式的 reset 调用都可以轻松撤消，但是 --hard 选项不能，因为它强制覆盖了工作目录中的文件。

			- 在这种特殊情况下，我们的 Git 数据库中的一个提交内还留有该文件的 v3 版本， 我们可以通过 reflog 来找回它。但是若该文件还未提交，Git 仍会覆盖它从而导致无法恢复。

		- 回顾

			- reset 命令会以特定的顺序重写这三棵树，在你指定以下选项时停止：

			- 移动 HEAD 分支的指向 （若指定了 --soft，则到此停止）

			- 使索引看起来像 HEAD （若未指定 --hard，则到此停止）

			- 使工作目录看起来像索引

		- 通过路径来重置

			-  若指定了一个路径，reset 将会跳过第 1 步，并且将它的作用范围限定为指定的文件或文件集合。

			- 因为 HEAD 只是一个指针，你无法让它同时指向两个提交中各自的一部分。 不过索引和工作目录 可以部分更新，所以重置会继续进行第 2、3 步。

			- 假如我们运行 git reset file.txt （这其实是 git reset --mixed HEAD file.txt 的简写形式，因为你既没有指定一个提交的 SHA-1 或分支，也没有指定 --soft 或 --hard），它会：

				- 移动 HEAD 分支的指向 （已跳过）

				- 让索引看起来像 HEAD （到此处停止）

			- 所以它本质上只是将 file.txt 从 HEAD 复制到索引中。

			  ￼
			  
			-  取消暂存文件 的实际效果

			  ￼
			  
				-  如果我们查看该命令的示意图，然后再想想 git add 所做的事，就会发现它们正好相反。

				- 这就是为什么 git status 命令的输出会建议运行此命令来取消暂存一个文件。 

			- 我们可以不让 Git 从 HEAD 拉取数据，而是通过具体指定一个提交来拉取该文件的对应版本。 我们只需运行类似于 git reset eb43bf file.txt 的命令即可。

			  ￼
			  
				- （？？？它其实做了同样的事情，也就是把工作目录中的文件恢复到 v1 版本，运行 git add 添加它， 然后再将它恢复到 v3 版本（只是不用真的过一遍这些步骤）。 如果我们现在运行 git commit，它就会记录一条“将该文件恢复到 v1 版本”的更改， 尽管我们并未在工作目录中真正地再次拥有它。？？？这段话很令人费解，极有可能是翻译错误，引起来歧义）

还有一点同 git add 一样，就是 reset 命令也可以接受一个 --patch 选项来一块一块地取消暂存的内容。 这样你就可以根据选择来取消暂存或恢复内容了。

					- this effectively does the same thing as if we had reverted the content of the file to v1 in the working directory, ran git add on it, then reverted it back to v3 again (without actually going through all those steps). If we run git commit now, it will record a change that reverts that file back to v1, even though we never actually had it in our working directory again.

			- 还有一点同 git add 一样，就是 reset 命令也可以接受一个 --patch 选项来一块一块地取消暂存的内容。 这样你就可以根据选择来取消暂存或恢复内容了。

	- 参考链接：

		- [深入理解git reset 命令](https://www.likecs.com/show-47636.html)

			-  
![image](assets/eb8f90b4bc30da1719f9ee39e7e7a25944dce7d637e2f06db3b6db3561a1d987.png)

			-  
![image](assets/03b6aebca2273b0c75c67122c642e3402c6df216639f9065d5b4f0ae843285e2.png)

		- [git reset详解](https://xw.qq.com/cmsid/20200224A09I2300)

			-  
![image](assets/1f1deb68e52625e79b704aed1de3df7070a62c062eab0a767a3c971e3bf2e959.png)

			-  
![image](assets/84102e9e65dc9c95cc1a047489514fda2f73d7c6811817d1589835446e0ce482.png)

			-  
![image](assets/a470c892fc3f7efeb2988ce6cc0d55393690790adc50b15a61c5111f7b3935f9.png)

			-  
![image](assets/2373048fbdd46bd67123865aa22424716b902cc1d4caa28e6e953a19a014835c.png)

### 62.1.3. git忽略本地修改不提交到远程仓库

- 忽略某文件提交到远程仓库
git update-index --assume-unchanged [file-path]

- 取消忽略某文件提交到远程仓库
git update-index --no-assume-unchanged [file-path]

## 62.2. react

### 62.2.1. jsx

- 在 JSX 语法中，你可以在大括号内放置任何有效的 JavaScript 表达式

  
  在下面的例子中，我们声明了一个名为 name 的变量，然后在 JSX 中使用它，并将它包裹在大括号中：
  
  const name = 'Josh Perez';
  const element = <h1>Hello, {name}</h1>;
  ReactDOM.render(
    element,
    document.getElementById('root')
  );
  
- 在编译之后，JSX 表达式会被转为普通 JavaScript 函数调用，并且对其取值后得到 JavaScript 对象。

  
  也就是说，你可以在 if 语句和 for 循环的代码块中使用 JSX，将 JSX 赋值给变量，把 JSX 当作参数传入，以及从函数中返回 JSX：
  function getGreeting(user) {
    if (user) {
  
      return <h1>Hello, {formatName(user)}!</h1>;  }
  
    return <h1>Hello, Stranger.</h1>;}
  
- JSX 特定属性

	- 你可以通过使用引号，来将属性值指定为字符串字面量：

		- const element = <div tabIndex="0"></div>;

	- 也可以使用大括号，来在属性值中插入一个 JavaScript 表达式：

		- const element = <img src={user.avatarUrl}></img>;

- 元素渲染

	- react对象，描述，元素内容

	- 浏览器DOM

	- React元素

	- 将一个元素渲染为 DOM

	  
	  假设你的 HTML 文件某处有一个 <div>：
	  <div id="root"></div>
	  
	  我们将其称为“根” DOM 节点，因为该节点内的所有内容都将由 React DOM 管理。
	  
	  仅使用 React 构建的应用通常只有单一的根 DOM 节点。如果你在将 React 集成进一个已有应用，那么你可以在应用中包含任意多的独立根 DOM 节点。
	  
	  想要将一个 React 元素渲染到根 DOM 节点中，只需把它们一起传入 ReactDOM.render()：
	  const element = <h1>Hello, world</h1>;
	  ReactDOM.render(element, document.getElementById('root'));
	  
	- 更新已渲染的元素

	  
	  React 元素是不可变对象。一旦被创建，你就无法更改它的子元素或者属性。一个元素就像电影的单帧：它代表了某个特定时刻的 UI。
	  
	  根据我们已有的知识，更新 UI 唯一的方式是创建一个全新的元素，并将其传入 ReactDOM.render()。
	  
	- React 只更新它需要更新的部分

	  React DOM 会将元素和它的子元素与它们之前的状态进行比较，并只会进行必要的更新来使 DOM 达到预期的状态。
	  
- State&生命周期

	- 将函数组件转换成 class 组件

	  ```函数
	  function Clock(props) {
	    return (
	  
	      <div>
	        <h1>Hello, world!</h1>
	        <h2>It is {props.date.toLocaleTimeString()}.</h2>
	      </div>  );
	  }
	  
	  function tick() {
	    ReactDOM.render(
	  
	      <Clock date={new Date()} />,    document.getElementById('root')
	    );
	  }
	  
	  setInterval(tick, 1000);
	  
	  ```
	  ## 第一步；
	  ``` class
	  class Clock extends React.Component {
	    render() {
	      return (
	        <div>
	          <h1>Hello, world!</h1>
	          <h2>It is {this.props.date.toLocaleTimeString()}.</h2>
	        </div>
	      );
	    }
	  }
	  ```
	  
	  ## 第二步
	  
	  让我们来快速概括一下发生了什么和这些方法的调用顺序：
	  当 <Clock /> 被传给 ReactDOM.render()的时候，React 会调用 Clock 组件的构造函数。因为 Clock 需要显示当前的时间，所以它会用一个包含当前时间的对象来初始化 this.state。我们会在之后更新 state。
	  之后 React 会调用组件的 render() 方法。这就是 React 确定该在页面上展示什么的方式。然后 React 更新 DOM 来匹配 Clock 渲染的输出。
	  当 Clock 的输出被插入到 DOM 中后，React 就会调用 ComponentDidMount() 生命周期方法。在这个方法中，Clock 组件向浏览器请求设置一个计时器来每秒调用一次组件的 tick() 方法。
	  浏览器每秒都会调用一次 tick() 方法。 在这方法之中，Clock 组件会通过调用 setState() 来计划进行一次 UI 更新。得益于 setState() 的调用，React 能够知道 state 已经改变了，然后会重新调用 render() 方法来确定页面上该显示什么。这一次，render() 方法中的 this.state.date 就不一样了，如此以来就会渲染输出更新过的时间。React 也会相应的更新 DOM。
	  一旦 Clock 组件从 DOM 中被移除，React 就会调用 componentWillUnmount() 生命周期方法，这样计时器就停止了。
	  
	  
	  
		- 通过以下五步将 Clock 的函数组件转成 class 组件：

		- 创建一个同名的 ES6 class，并且继承于 React.Component。

		- 添加一个空的 render() 方法。

		- 将函数体移动到 render() 方法之中。

		- 在 render() 方法中使用 this.props 替换 props。

		- 删除剩余的空函数声明。

	- 向 class 组件中添加局部的 state

	- 正确地使用 State

		- 不要直接修改 State

		- State 的更新可能是异步的

		- State 的更新会被合并

	- [事件处理](https://www.webhek.com/post/javascript-bind.html)

		- 不同点是你不能通过返回 false 的方式阻止默认行为

		- e 是一个合成事件。React 根据 W3C 规范来定义这些合成事件，所以你不需要担心跨浏览器的兼容性问题。

		- 你必须谨慎对待 JSX 回调函数中的 this，在 JavaScript 中，class 的方法默认不会绑定 this

			- [复习一下bind，bind方法，可以提前绑定this，和参数，返回一个新的方法](https://www.webhek.com/post/javascript-bind.html)

		- 向事件处理程序传递参数

		  
		  在循环中，通常我们会为事件处理函数传递额外的参数。例如，若 id 是你要删除那一行的 ID，以下两种方式都可以向事件处理函数传递参数：
		  <button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
		  <button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
		  
		  上述两种方式是等价的，分别通过箭头函数和 Function.prototype.bind 来实现。
		  
		  在这两种情况下，React 的事件对象 e 会被作为第二个参数传递。如果通过箭头函数的方式，事件对象必须显式的进行传递，而通过 bind 的方式，事件对象以及更多的参数将会被隐式的进行传递。
		  
	- 条件渲染

		- 元素变量

			- 你可以使用变量来储存元素。 它可以帮助你有条件地渲染组件的一部分，而其他的渲染部分并不会因此而改变。

			- 声明一个变量并使用 if 语句进行条件渲染是不错的方式，但有时你可能会想使用更为简洁的语法

		- 与运算符 &&

			- 通过花括号包裹代码，你可以在 JSX 中嵌入任何表达式。这也包括 JavaScript 中的逻辑与 (&&) 运算符。它可以很方便地进行元素的条件渲染。

		- 三目运算符

			- 另一种内联条件渲染的方法是使用 JavaScript 中的三目运算符 condition ? true : false。

		- 阻止组件渲染

			- 在极少数情况下，你可能希望能隐藏组件，即使它已经被其他组件渲染。若要完成此操作，你可以让 render 方法直接返回 null，而不进行任何渲染。

	- 列表&key

		- 渲染多个组件

			- 我们使用 Javascript 中的 map() 方法来遍历 numbers 数组。将数组中的每个元素变成 <li> 标签，最后我们将得到的数组赋值给 listItems

		- 基础列表组件

			- 警告 a key should be provided for list items

		- key

			- key 帮助 React 识别哪些元素改变了，比如被添加或删除。因此你应当给数组中的每一个元素赋予一个确定的标识。

			- 当元素没有确定 id 的时候，万不得已你可以使用元素索引 index 作为 key

			- 如果列表项目的顺序可能会变化，我们不建议使用索引来用作 key 值，因为这样做会导致性能变差，还可能引起组件状态的问题

		- 用 key 提取组件

			- 如果你提取出一个 ListItem 组件，你应该把 key 保留在数组中的这个 <ListItem /> 元素上，而不是放在 ListItem 组件中的 <li> 元素上。

			- 上面这句话的意思是：
应该在循环的组件上使用这个key，而不是在这个li元素上使用。

		- key 只是在兄弟节点之间必须唯一

			- key 会传递信息给 React ，但不会传递给你的组件。如果你的组件中需要使用 key 属性的值，请用其他属性名显式传递这个值

		- 在 JSX 中嵌入 map()

			- JSX 允许在大括号中嵌入任何表达式，所以我们可以内联 map() 返回的结果：

			- function NumberList(props) {

			-   const numbers = props.numbers;

			-   return (

			-     <ul>

			-       {numbers.map((number) =>

			-         <ListItem key={number.toString()}

			-                   value={number} />

			-       )}

			-     </ul>

			-   );

			- }

			- 如果一个 map() 嵌套了太多层级，那可能就是你提取组件的一个好时机。

	- 表单

		- 受控组件

			- 对于受控组件来说，输入的值始终由 React 的 state 驱动

			- 由于在表单元素上设置了 value 属性，因此显示的值将始终为 this.state.value，这使得 React 的 state 成为唯一数据源。由于 handlechange 在每次按键时都会执行并更新 React 的 state，因此显示的值将随着用户输入而更新。

			- <input type="text" value={this.state.value} onChange={this.handleChange} />

		- textarea 标签

		- select 标签

			- 由于 selected 属性的缘故，椰子选项默认被选中。React 并不会使用 selected 属性，而是在根 select 标签上使用 value 属性。这在受控组件中更便捷，因为您只需要在根标签中更新它。

			-  <select value={this.state.value} onChange={this.handleChange}>

			-             <option value="grapefruit">葡萄柚</option>

			-             <option value="lime">酸橙</option>

			-             <option value="coconut">椰子</option>

			-             <option value="mango">芒果</option>

			-           </select>

			- 你可以将数组传递到 value 属性中，以支持在 select 标签中选择多个选项：

			- <select multiple={true} value={['B', 'C']}>

		- 文件 input 标签

			- 因为它的 value 只读，所以它是 React 中的一个非受控组件

		- 处理多个输入

			- 当需要处理多个 input 元素时，我们可以给每个元素添加 name 属性，并让处理函数根据 event.target.name 的值选择要执行的操作。

			- 这里使用了 ES6 计算属性名称的语法更新给定输入名称对应的 state 值：

			- 例如：

			- this.setState({
  [name]: value
});

			- var partialState = {};
partialState[name] = value;
this.setState(partialState);

		- 受控输入空值

			- 在受控组件上指定 value 的 prop 会阻止用户更改输入。如果你指定了 value，但输入仍可编辑，则可能是你意外地将value 设置为 undefined 或 null。

			- 下面的代码演示了这一点。（输入最初被锁定，但在短时间延迟后变为可编辑。）

			- ReactDOM.render(<input value="hi" />, mountNode);

setTimeout(function() {
  ReactDOM.render(<input value={null} />, mountNode);
}, 1000);

		- 受控组件的替代品

			- 使用非受控组件, 这是实现输入表单的另一种方式

		- 成熟的解决方案

			- Formik 是不错的选择。然而，它也是建立在受控组件和管理 state 的基础之上 —— 所以不要忽视学习它们

		- 状态提升

## 62.3. svg

### 62.3.1. stroke

- stroke-dasharray

	- 1. stroke意思是：画短线于，在...上划线

	- 2. stroke-dasharray:用于创建虚线，之所以后面跟的是array的，是因为值其实是数组。请看下面解释

	- stroke-dasharray = '10'

	- stroke-dasharray = '10, 5'

	- stroke-dasharray = '20, 10, 5'

	-  
![image](assets/d10a242f0967b8b720d39c5a9d007f0568b07ee46219eb6954d94c0ad611e2e0.png)

	- stroke-dasharray为一个参数时： 其实是表示虚线长度和每段虚线之间的间距

	- 　　如：stroke-dasharray = '10' 表示：虚线长10，间距10，然后重复 虚线长10，间距10

	- 两个参数或者多个参数时：一个表示长度，一个表示间距

	- 　　如：stroke-dasharray = '10, 5' 表示：虚线长10，间距5，然后重复 虚线长10，间距5

	- 　　如：stroke-dasharray = '20, 10, 5' 表示：虚线长20，间距10，虚线长5，接着是间距20，虚线10，间距5，之后开始如此循环

- 3. stroke-dashoffset： offset：偏移的意思。

	- 这个属性是相对于起始点的偏移，正数偏移x值的时候，相当于往左移动了x个长度单位，负数偏移x的时候，相当于往右移动了x个长度单位。

	- 需要注意的是，不管偏移的方向是哪边，要记得dasharray 是循环的，也就是 虚线-间隔-虚线-间隔。

	- 这个属性要搭配stroke-dashoffset才能看得出来效果，非虚线的话，是无法看出偏移的。

	- 概念有点抽象，来看一个MDN的例子，图中红线段是偏移的距离

	-  
![image](assets/a300c308eaab2b4e55f0885dc201f548aa7f6deb4efedb5ae4db6e8c97b93320.png)

- [地址](https://www.cnblogs.com/daisygogogo/p/11044353.html)

### 62.3.2. 分组 - <g>

- 定义

	- SVG 中的分组你可以理解为 PS 中的图层，一块图层里面通常只会放一下高内聚的图形，这样既方便移动又方便做动画。SVG 中的分组标签就是 g，使用 g 标签包裹的所有子元素都认同为一组。

- 例子

	-  
![image](assets/fa3940a8295226b3d18d59350eb1036dadf273acd95be2f2f7257e89d2691dd2.png)

- 需要注意的是，使用 g 进行分组，并不会改变原有元素的在屏幕上展示的效果。

- 不过，g 标签除了分组，还有另外一个很重要的功能–动画

- 分组动画

	- 在分组重定义动画是直接写在 transform 属性当中的。实际上，每个子标签都可以使用 transform 的相关属性。

	- <g transform="translate(...) scale(...) rotate(...) translate(...) rotate(...)"> ... </g>

	- 每种变换动画之间是通过 空格或逗号 连接的。它的执行顺序是从右到左。为啥呢？实际上可以理解为，这就是几个嵌套的 g 叠在一起。

	-  
![image](assets/52cef88b7c79543173645c593a2376e472b2fe802fa84d5d993290c8c3b2d976.png)

	- [具体可以使用的动画形式和 CSS 动画一模一样，详情可以参考: SVG 动画。](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform)

### 62.3.3. svg形状

- 矩形 <rect>

	- <rect> 标签
<rect> 标签可用来创建矩形，以及矩形的变种。

	- 参数

		- x 属性定义矩形的左侧位置（例如，x="0" 定义矩形到浏览器窗口左侧的距离是 0px）

		- y 属性定义矩形的顶端位置（例如，y="0" 定义矩形到浏览器窗口顶端的距离是 0px）

		- rect 元素的 width 和 height 属性可定义矩形的高度和宽度

		- rx 和 ry 属性可使矩形产生圆角。

		- style 属性用来定义 CSS 属性

		- CSS 的 fill 属性定义矩形的填充颜色（rgb 值、颜色名或者十六进制值）

		- CSS 的 stroke-width 属性定义矩形边框的宽度

		- CSS 的 stroke 属性定义矩形边框的颜色

		- CSS 的 opacity 属性定义整个元素的透明值（合法的范围是：0 - 1）

	- 例子

		- 例子1：

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<rect width="300" height="100"
style="fill:rgb(0,0,255);stroke-width:1;
stroke:rgb(0,0,0)"/>

</svg>

		- 例子2：

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<rect x="20" y="20" width="250" height="250"
style="fill:blue;stroke:pink;stroke-width:5;
fill-opacity:0.1;stroke-opacity:0.9"/>

</svg>

		- 例子3：

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<rect x="20" y="20" width="250" height="250"
style="fill:blue;stroke:pink;stroke-width:5;
opacity:0.9"/>

</svg>

		- 例子4：

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<rect x="20" y="20" rx="20" ry="20" width="250"
height="100" style="fill:red;stroke:black;
stroke-width:5;opacity:0.5"/>

</svg>

- 圆形 <circle>

	- circle> 标签

		- <circle> 标签可用来创建一个圆。

	- 【参数】

		- cx 和 cy 属性定义圆点的 x 和 y 坐标。如果省略 cx 和 cy，圆的中心会被设置为 (0, 0)

r 属性定义圆的半径。

	- 【例子】

		- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<circle cx="100" cy="50" r="40" stroke="black"
stroke-width="2" fill="red"/>

</svg>

- 椭圆 <ellipse>

	- <ellipse> 标签

		- <ellipse> 标签可用来创建椭圆。椭圆与圆很相似。不同之处在于椭圆有不同的 x 和 y 半径，而圆的 x 和 y 半径是相同的。

	- 【参数】

		- cx 属性定义圆点的 x 坐标

		- cy 属性定义圆点的 y 坐标

		- rx 属性定义水平半径

		- ry 属性定义垂直半径

		- style="fill:yellow"

	- 【例子】

		- 例子1

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<ellipse cx="300" cy="150" rx="200" ry="80"
style="fill:rgb(200,100,50);
stroke:rgb(0,0,100);stroke-width:2"/>

</svg>

- 线 <line>

	- <line> 标签

		- <line> 标签用来创建线条。

	- 【参数】

		- x1 属性在 x 轴定义线条的开始

		- y1 属性在 y 轴定义线条的开始

		- x2 属性在 x 轴定义线条的结束

		- y2 属性在 y 轴定义线条的结束

	- 【例子】

		- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<line x1="0" y1="0" x2="300" y2="300"
style="stroke:rgb(99,99,99);stroke-width:2"/>

</svg>

- 折线 <polyline>

	- <polyline> 标签

		- <polyline> 标签用来创建仅包含直线的形状。

	- 【例子】

		- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<polyline points="0,0 0,20 20,20 20,40 40,40 40,60"
style="fill:white;stroke:red;stroke-width:2"/>

</svg>

- 多边形 <polygon>

	- <polygon> 标签

		- <polygon> 标签用来创建含有不少于三个边的图形

	- 【参数】

		- points 属性定义多边形每个角的 x 和 y 坐标

	- 【例子】

		- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<polygon points="220,100 300,210 170,250"
style="fill:#cccccc;
stroke:#000000;stroke-width:1"/>

</svg>

- 路径 - <path>

	- Path

		- path 在 SVG 中的地位应该是比较高的，实际上，利用 path 这个一个标签可以画出任意的图形。path 中 d(data) 属性是用来定义相关线条数据，通常是以 M/m 为起始，代表的就是 move to 的意思。在 path 中，一共可以定义 10 种不同的图形。例如 M/m，L/l。 大家可以注意，每种标识符有两种书写方式，即，大小写。

		- 大写: 参照的是绝对坐标，即，SVG 的右上角

		- 小写: 参照的相对坐标，即，前一个点的坐标。

		- 而在 10 种不同表示符中，又可以分为直线和曲线两种不同的标识符。这里，我们分类来讲解一下。

	- 线型

		- M = moveto

			- M/m

			- 该使用定义起始点的，没啥特殊的作用。

			- <path d="M10 10"/>

			- 表示，以 (10,10) 为起始点。

		- L = lineto

			- L/l

			- 原意是 Line to，用来画线段的。格式和 M/m 差不多：

			- L x y (or l dx dy)

		- H = horizontal lineto

			- H/h

			- 用来画水平线，即，Horizontal。既然方向已经定了，剩下的就是距离，格式很简单：

			- H x (or h dx)

		- V = vertical lineto

			- V/v

			- 用来画竖直线，即，vertical。同上，方向也定了，格式为：

			- V y (or v dy)

			- 看个例子吧：

			- <path d="M10 10 H 90 V 90 H 10 L 10 10"/>

			- 该 path 实际上就是画了一个正方形，宽 = 高 = 90。

				-  
![image](assets/9bc7529f5b8b678734903ecb9e72c742d36279c63f9ae5af1b0a9e06db39a049.png)

	- 曲线

		- 曲线就是 Web 画图中常见的 Bezier Curves（贝塞尔），Arcs，several Bezier curves（很多贝塞尔 - .-）等。

		- C = curveto

			- C/c

			- 这是正统的贝塞尔曲线，需要 4 个参考点，下图应该说比较确切表示了二次贝塞尔所需要的点。所以，C/c 需要定义三个点。

				-  
![image](assets/32f63ba31c97a5597471920ebbab418c167d26b93e0bb6b8413c9d9c1f6b9f87.png)

			- 参数

				- 两个控制点一个终点

			- 基本格式为：

			- C x1 y1, x2 y2, x y (or c dx1 dy1, dx2 dy2, dx dy)

			- 例如：

			- <path d="M10 10 C 20 20, 40 20, 50 10" stroke="black" fill="transparent"/>

		- S = smooth curveto

			- S/s

				- 当一个点某一侧的控制点是它另一侧的控制点的对称（以保持斜率不变），可以使用S命令。简写的贝塞尔曲线命令。

				- 如果S命令跟在一个C命令或者另一个S命令的后面，它的第一个控制点，就会被假设成前一个控制点的对称点。

				- 如果S命令单独使用，前面没有C命令或者另一个S命令，那么它的两个控制点就会被假设为同一个点。

			- 该标识符实际上使用来表示一个反射贝塞尔，即，在原有贝塞尔上再加一段贝塞尔曲线，所以，S/s 一般和 C/c 一起使用。

			- 基本格式为：

			- S x2 y2, x y (or s dx2 dy2, dx dy)

			- 实际样式图为：

				-  
![image](assets/4d1bc627de7a8a669d00f75cbf366d7cfd294356b299b7b44fbdba26903b9771.png)

			- 相当于原有的贝塞尔曲线的最后一段进行反向延长并对称。然后加上新定义的一段限制曲线。

			- 具体实例为：

			- <path d="M10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80" stroke="black" fill="transparent"/>

		- Q = quadratic Bézier curve

			- Q/q

			- 该标识符是用来定义二次(Quadratic)贝塞尔曲线，该曲线相当于上面传统的贝塞尔来说，更加简单，它只需要定义三个点，即可完整一个贝塞尔曲线，具体作图过程如下：

			-  
![image](assets/68c1907bd99497b1e865af441619c0d48490e488914397e3deee5ee6cdaaf2da.png)

			- 参数

				- 一个控制点，一个终点

			- 基本格式为：

			- Q x1 y1, x y (or q dx1 dy1, dx dy)

			- 即为图上点， P1(x1,y1)，P2(x,y)。

			- 起始点为 M 定义的点，例如：

			- <path d="M10 80 Q 95 10 180 80" stroke="black" fill="transparent"/>

		- T = smooth quadratic Bézier curveto

			- T/t

				- 与S命令相似，是Q命令的简写命令。

				- 与S命令相似，T也会通过前一个控制点，推断出一个新的控制点。这意味着，在你的第一个控制点后面，可以只定义终点，就创建出一个相当复杂的曲线。

				- 【需要注意】，T命令前面必须是一个Q命令，或者是另一个T命令，才能达到这种效果。如果T单独使用，那么控制点就会被认为和终点是同一个点，所以画出来的将是一条直线。

			- 该标识符和 S 差不多，也是一个贝塞尔曲线的延长。相当于原曲线的控制点 P1 相当于 end point P2 做对称，然后，只需要定义一个终点即可，即，T/t 只需要定义贝塞尔曲线里面的终点即可：

			- T x y (or t dx dy)

			-  
![image](assets/14de5ca723284ba6e4fef5fcf0cddf49a1ba6943ca5ef142d7c65784ec3de429.png)

			- 简单来说，C/S，Q/T 是两两搭配一起使用的。在使用的时候，千万不要搞混即可。

		- A = elliptical Arc

			- 弧线

			- A/a

			- 该曲线是用来画弧线(Arcs)，而，弧线通常是圆/椭圆的一部分。当，椭圆的两个轴径长相等则为圆，所以，A/a 是按照椭圆作为基准格式

				- A rx ry x-axis-rotation large-arc-flag sweep-flag x y 

				- a rx ry x-axis-rotation large-arc-flag sweep-flag dx dy

			- 参数

				- rx,ry: 代表的就是长轴短轴，没得说。

				- x,y: 代表的是弧长的结束点。开始点就是上一个命令的终点。

				- x-axis-rotation: x 轴的旋转角度。顺时针为正

				- large-arc-flag[0,1]: 表示取大弧还是小弧。因为两点之间的弧长有两部分。

				- sweep-flag[0,1]: 取顺时针的弧，还是逆时针的弧长。参考点是以起始点开始的。

			- 图示

				-  
![image](assets/1c0fbb3d695ded9b130be9c1ec244bfa9ac6993a3515870ab24cbe01fc7ae1e6.png)

			- 【个人理解各个参数】

				- rx和ry就是长短轴，没所谓第一个第二个参数，也就是没有定义长和短，笼统的说法

				- arch的start和end加上rx和ry，就可以决定了椭圆的形状了。

				- 起点和终点决定了弧长的起止点，『上述』形状的椭圆的弧在与两点的关系，椭圆边在两间保持形状的滑动。一共有上下两种镜像的椭圆，随着x-axis-rotation的度数，进行滑动。large-arc-flag取大小弧，sweep-flag取顺时针还是逆时针的分段

	- Z = closepath

		- Z/z

		- 该标识符用来表示 path 的结束，并且将最后一点和 M/m 标识开头的一点连接起来。所以，它不存在什么表示点之类的，格式为：

		- Z (or z)

		- 而上面也可以进行相关的优化，最终的结果为：

		- <path d="M10 10 H 90 V 90 H 10 L 10 10"/>

		- // 使用 Z

		- <path d="M10 10 H 90 V 90 H 10 Z" fill="transparent" stroke="black"/>

### 62.3.4. svg滤镜

- SVG 滤镜用来向形状和文本添加特殊的效果。

- 在 SVG 中，可用的滤镜有：

	- feBlend

	- feColorMatrix

	- feComponentTransfer

	- feComposite

	- feConvolveMatrix

	- feDiffuseLighting

	- feDisplacementMap

	- feFlood

	- feGaussianBlur

	- feImage

	- feMerge

	- feMorphology

	- feOffset

	- feSpecularLighting

	- feTile

	- feTurbulence

	- feDistantLight

	- fePointLight

	- feSpotLight

- 注释：您可以在每个 SVG 元素上使用多个滤镜！

- SVG 高斯模糊

	- 特点

		- 必须在 <defs> 标签中定义 SVG 滤镜。

		- 高斯模糊（Gaussian Blur）

		- <filter> 标签用来定义 SVG 滤镜。

		- <filter> 标签使用必需的 id 属性来定义向图形应用哪个滤镜？

		- <filter> 标签必须嵌套在 <defs> 标签内。

		- <defs> 标签是 definitions 的缩写，它允许对诸如滤镜等特殊元素进行定义。

	- 【例子】

		- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<defs>
<filter id="Gaussian_Blur">
<feGaussianBlur in="SourceGraphic" stdDeviation="3" />
</filter>
</defs>

<ellipse cx="200" cy="150" rx="70" ry="40"
style="fill:#ff0000;stroke:#000000;
stroke-width:2;filter:url(#Gaussian_Blur)"/>

</svg>

	- 例子2

		- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<defs>
<filter id="Gaussian_Blur">
<feGaussianBlur in="SourceGraphic" stdDeviation="20"/>
</filter>
</defs>

<ellipse cx="200" cy="150" rx="70" ry="40"
style="fill:#ff0000;stroke:#000000;
stroke-width:2;filter:url(#Gaussian_Blur)"/>

</svg>

	- 【例子，解释】

		- <filter> 标签的 id 属性可为滤镜定义一个唯一的名称（同一滤镜可被文档中的多个元素使用）

		- filter:url 属性用来把元素链接到滤镜。当链接滤镜 id 时，必须使用 # 字符

		- 滤镜效果是通过 <feGaussianBlur> 标签进行定义的。fe 后缀可用于所有的滤镜

		- <feGaussianBlur> 标签的 stdDeviation 属性可定义模糊的程度

		- in="SourceGraphic" 这个部分定义了由整个图像创建效果

- SVG渐变

	- SVG 渐变必须在 <defs> 标签中进行定义。

	- SVG 渐变

		- 渐变是一种从一种颜色到另一种颜色的平滑过渡。另外，可以把多个颜色的过渡应用到同一个元素上。

	- 在 SVG 中，有两种主要的渐变类型：

		- 线性渐变

		- 放射性渐变

	- 线性渐变

		- <linearGradient> 可用来定义 SVG 的线性渐变。

		- <linearGradient> 标签必须嵌套在 <defs> 的内部。<defs> 标签是 definitions 的缩写，它可对诸如渐变之类的特殊元素进行定义。

		- 线性渐变可被定义为水平、垂直或角形的渐变：

			- 当 y1 和 y2 相等，而 x1 和 x2 不同时，可创建水平渐变

			- 当 x1 和 x2 相等，而 y1 和 y2 不同时，可创建垂直渐变

			- 当 x1 和 x2 不同，且 y1 和 y2 不同时，可创建角形渐变

		- 【例子】

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<defs>
<linearGradient id="orange_red" x1="0%" y1="0%" x2="100%" y2="0%">
<stop offset="0%" style="stop-color:rgb(255,255,0);
stop-opacity:1"/>
<stop offset="100%" style="stop-color:rgb(255,0,0);
stop-opacity:1"/>
</linearGradient>
</defs>

<ellipse cx="200" cy="190" rx="85" ry="55"
style="fill:url(#orange_red)"/>

</svg>

		- 【代码解释】

			- <linearGradient> 标签的 id 属性可为渐变定义一个唯一的名称

			- fill:url(#orange_red) 属性把 ellipse 元素链接到此渐变

			- <linearGradient> 标签的 x1、x2、y1、y2 属性可定义渐变的开始和结束位置

			- 渐变的颜色范围可由两种或多种颜色组成。每种颜色通过一个 <stop> 标签来规定。offset 属性用来定义渐变的开始和结束位置。

		- 【例子】

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<defs>
<linearGradient id="orange_red" x1="0%" y1="0%" x2="0%" y2="100%">
<stop offset="0%" style="stop-color:rgb(255,255,0);
stop-opacity:1"/>
<stop offset="100%" style="stop-color:rgb(255,0,0);
stop-opacity:1"/>
</linearGradient>
</defs>

<ellipse cx="200" cy="190" rx="85" ry="55"
style="fill:url(#orange_red)"/>

</svg>

	- SVG 放射性渐变

		- <radialGradient> 用来定义放射性渐变。

		- <radialGradient> 标签必须嵌套在 <defs> 中。<defs> 标签是 definitions 的缩写，它允许对诸如渐变等特殊元素进行定义。

		- 【例子】

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<defs>
<radialGradient id="grey_blue" cx="50%" cy="50%" r="50%"
fx="50%" fy="50%">
<stop offset="0%" style="stop-color:rgb(200,200,200);
stop-opacity:0"/>
<stop offset="100%" style="stop-color:rgb(0,0,255);
stop-opacity:1"/>
</radialGradient>
</defs>

<ellipse cx="230" cy="200" rx="110" ry="100"
style="fill:url(#grey_blue)"/>

</svg>

		- 【代码解释】

			- <radialGradient> 标签的 id 属性可为渐变定义一个唯一的名称，fill:url(#grey_blue) 属性把 ellipse 元素链接到此渐变，cx、cy 和 r 属性定义外圈，而 fx 和 fy 定义内圈 渐变的颜色范围可由两种或多种颜色组成。每种颜色通过一个 <stop> 标签来规定。offset 属性用来定义渐变的开始和结束位置。

		- 【例子】

			- <?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg width="100%" height="100%" version="1.1"
xmlns="http://www.w3.org/2000/svg">

<defs>
<radialGradient id="grey_blue" cx="20%" cy="40%" r="50%"
fx="50%" fy="50%">
<stop offset="0%" style="stop-color:rgb(200,200,200);
stop-opacity:0"/>
<stop offset="100%" style="stop-color:rgb(0,0,255);
stop-opacity:1"/>
</radialGradient>
</defs>

<ellipse cx="230" cy="200" rx="110" ry="100"
style="fill:url(#grey_blue)"/>

</svg>

	- 各种svg案例

		- [地址](https://www.w3school.com.cn/svg/svg_examples.asp)

- <defs> 标签是 definitions 的缩写，它允许对诸如滤镜等特殊元素进行定义。

- <filter id="Gaussian_Blur">
                    <!-- offsetBlur -->
                    <!-- blur -->
                    <feGaussianBlur in="SourceGraphic" stdDeviation="10" result="blur"/>
                    <!-- offset -->
                    <feOffset in="blur" dx="20" dy="20" result="offsetBlur" />
                    <!-- merge SourceGraphic + offsetBlur -->
                    <feMerge>
                        <feMergeNode in="offsetBlur" />
                        <feMergeNode in="SourceGraphic" />
                    </feMerge>
                </filter>

### 62.3.5. svg clipPath（裁剪）

- 【裁剪定义】

	- SVG中的<clipPath>的元素，专门用来定义剪裁路径。必须设置的属性是id属性，被引用时使用

		- 只保留clipPath中定义的部分

	- 裁剪路径(cliping path)

		-       裁剪路径是由path, text或者基本图形组成的图形。所有在裁剪路径内的图形都可见，所有在裁剪路径外的图形都不可见。

- 【示例】

	- 【例子1】

		- 图示裁剪还没有引用
![image](assets/33ddd31029b0593d9d1d4ef5942bf52e2c884e5899acc0fba9b7adb8ebd4337c.png)

		- 图示裁剪引用
![image](assets/ec549db625add4133e66659f9e65fd21cd7396cf78b3694adfc25db2f9250087.png)

		- 【代码】

			- 下面是一个圆形

<svg height="70" version="1.1" xmlns="http://www.w3.org/2000/svg" >
  <circle cx="25" cy="25" r="25" fill="#34538b" />
</svg>

			- 裁剪

<svg height="70" version="1.1" xmlns="http://www.w3.org/2000/svg" >
  <defs>
      <clipPath id="clipPath1">
        <rect x="0" y="0" width="20" height="20" />
      </clipPath>   
  </defs>
  <circle cx="25" cy="25" r="25" fill="#34538b" clip-path="url(#clipPath1)"/>
</svg>

	- 【例子2】

		-  
![image](assets/9bec1d376b9658c35421cd1c92dbbcb88ab43e9fbdbebeab31ca255d635da7cf.png)

- 【总结】

	-  <clipPath>元素里面除了rect元素, 还可以是circle, ellipse, line, polyline, polygon, ...等等，甚至是text文本

### 62.3.6. svg mask（蒙版|遮罩）

- 【遮罩定义】

	- 遮罩<mask>元素所包含的子元素无须只具有线条性质的元素，可以包含任何可视化元素，甚至是<g>元素。

		- 这些可视化的子元素都必须带上透明度的定义，因为<mask>元素是通过透明度来控制图像与背景的遮罩效果的

		- 蒙版中黑色代表不可见（opacity: 0），白色代表可见（opacity: 100%）

		- 那么黑白之间的灰色代表什么呢？从0%到100%是一个线性的变化，所以黑白中间的灰色会是半透明，而且不同灰度代表不同程度的半透明，越趋近白色可见度越高。

		- 在蒙版中的黑白渐变，应用到彩色图层上就会产生透明度的渐变

	- 遮罩/蒙板(mask)

		- 蒙板是一种容器，它定义了一组图形并将它们作为半透明的媒介，可以用来组合前景对象和背景。

		- 裁剪路径和其他的蒙板一个重要的区别就是：裁剪路径是1位蒙板，也就是说裁剪路径覆盖的对象要么就是全透明(可见的，位于裁剪路径内部)，要么就是全不透明(不可见，位于裁剪路径外部)。而蒙板可以指定不同位置的透明度。

	- 蒙板- mask元素

		-       在SVG中，你可以为渲染的对象指定任何的图形元素或者g元素作为蒙板，来将渲染对象组合到背景中。

		-       蒙板用mask元素定义，使用蒙板的时候只需要在对象的mask属性中引用蒙板就可以了。

		-        mask元素可以包含任何的图形元素和容器元素(例如g)。

		-       蒙板的效果其实大家也比较清楚，基本就是根据蒙板中每个点的颜色和透明度计算出一个最终的透明度，然后在渲染对象的时候，在对象上面罩上这个带有不同透明度的蒙板层，体现出蒙板的遮挡效果。对于渲染对象来说，只有在蒙版内的部分会按照蒙板上点的透明度来渲染，不在蒙板内的部分不显示。

- 【示例】

	- 【例子1-黑白】

		- <svg height="70" style="background:gray" version="1.1" xmlns="http://www.w3.org/2000/svg" >
  <circle cx="25" cy="25" r="25" fill="white"/>
  <circle cx="40" cy="15" r="25" fill="black"/>
</svg>


			-  
![image](assets/91aff59cc8f0a8de52241dd3d1edd1e7c940546d512f87bba7fefb84a57399e7.png)

		- <svg height="70" style="background:gray" version="1.1" xmlns="http://www.w3.org/2000/svg" >
  <mask id="moon-mask">
    <circle cx="25" cy="25" r="25" fill="white"/>
    <circle cx="40" cy="15" r="25" fill="black"/>    
  </mask>
  <circle cx="25" cy="25" r="25" fill="yellow" mask="url(#moon-mask)"/>
</svg>

			-  
![image](assets/eae698ceccaeb9b45d4cb4d3073ed256a96c71b654ac739c2deac96f03c2038a.png)

	- 【例子2-黑白渐变+mask+原色矩形+叠加矩形（其他颜色）】

		- 黑白渐变+mask+红矩形
![image](assets/1c64cecc50c293935ed6e97621308321128416fc5866c752c96237a7159d25da.png)

		- 黑白渐变+mask+红矩形+叠加绿色矩形
![image](assets/ef73eb87553d6d60163f6716ad2b06c6743bff88300d58906a04b7590224ae0b.png)

	- 【例子3】

		- <svg width="8cm" height="3cm" viewBox="0 0 800 300" version="1.1"
     xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <linearGradient id="Gradient" gradientUnits="userSpaceOnUse"
                    x1="0" y1="0" x2="800" y2="0">
      <stop offset="0" stop-color="white" stop-opacity="0" />
      <stop offset="1" stop-color="white" stop-opacity="1" />
    </linearGradient>
    <mask id="Mask" maskUnits="userSpaceOnUse"
          x="0" y="0" width="800" height="300">
      <rect x="0" y="0" width="800" height="300" fill="url(#Gradient)"  />
    </mask>
    <text id="Text" x="400" y="200" 
          font-family="Verdana" font-size="100" text-anchor="middle" >
      Masked text
    </text>
  </defs>

  <!-- 视窗的背景 -->
  <rect x="0" y="0" width="800" height="300" fill="#FF8080" />
  
  <!-- 第一步绘制一个带有蒙板的Text，可以看到蒙板的透明度效果已经应用到字上了.
       第二步是绘制一个不带蒙板的Text，来作为第一步Text的轮廓 -->
  <use xlink:href="#Text" fill="blue" mask="url(#Mask)" />
  <use xlink:href="#Text" fill="none" stroke="black" stroke-width="2" />
</svg>

### 62.3.7. svg 动画

- 【概述】

	- 　　动画实际上就是值关于时间的一个函数。在这个函数中，包含起始值和结束值，经过的时间一般被称为持续时间。动画执行时的曲线就是动画函数。但是，在计算机中，不可能穷尽每一时刻的状态，而是取多个采样点，每个采样点就叫做帧。要让动画流畅显示，一般地需要每秒60帧

	- 　　在SVG中实现动画主要通过SMIL。SVG的动画元素是和SMIL开发组合作开发的。SMIL开发组和SVG开发组合作开发了SMIL动画规范，在规范中制定了一个基本的XML动画特征集合。SVG吸收了SMIL动画规范当中的动画优点，并提供了一些SVG继承实现

	- 　　[注意]SVG动画除了IE浏览器不支持之外，兼容其他主流浏览器

- 【动画元素】

	- SVG动画元素共有4个，包括：<set>、<animate>、<animateTransform>、<animateMotion>

- 【<set>】

	- <set>可以实现基本的延迟功能。就是指：可以在特定时间之后修改某个属性值（也可以是CSS属性值）

	- 例子

		- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <set attributeName="x" attributeType="XML" to="60" begin="2s" />
    </text>
  </g>
</svg>

- 【<animate>】

	- <animate>是基础动画元素，用于实现单属性的动画过渡效果 

	- 例子

		- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate attributeName="x" to="60" begin="0s" dur="2s"  repeatCount="indefinite" />
    </text>
  </g>
</svg>

- 【<animateTransform>】

	- <animateTransform>用于实现transform变换动画效果

	- 例子

		- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animateTransform attributeName="transform" type="scale" from="1" to="1.5" begin="0s" dur="2s"  repeatCount="indefinite" />
    </text>
  </g>
</svg>

- 【<animateMotion>】

	- <animateMotion>可以让SVG各种图形沿着特定的path路径运动

	- 例子

		- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="0" x="0">
      火柴
      <animateMotion path="M 20 20 H 60 V 50 Z" begin="0s" dur="3s" repeatCount="indefinite" />
    </text>
    <path d="M 20 20 H 60 V 50 Z" fill="transparent" stroke="black"></path>
  </g>
</svg>

- 【动画属性】

	- 【attributeName】

		- attributeName表示要变化的元素属性名称

			- ① 可以是元素直接暴露的属性，例如，对应的text元素上的x, y或者font-size;

			- ② 可以是CSS属性。例如，透明度opacity

		- 例子

			- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate attributeName="opacity" to="0" begin="0s" dur="1s"  repeatCount="indefinite" />
    </text>
  </g>
</svg>

	- 【attributeType】

		- attributeType支持三个固定参数：CSS、XML、auto，用来表明attributeName属性值的列表。

			- x、y以及transform属于XML；

			- opacity等CSS属于CSS；

			- auto为默认值，自动判别的意思（实际上是先当成CSS处理，如果发现不认识，直接XML类别处理）。

			- 因此，如果不确信某属性是XML类别还是CSS类别的时候，可以不设置attributeType值，直接让浏览器自己去判断

	- 【from, to, by, values】

		- from  动画的起始值

		- to  指定动画的结束值

		- by 动画的相对变化值

		- values  用分号分隔的一个或多个值，可以看成是动画的多个关键值点

		- from、to、by、values相互之间有制约关系：

			- 　　1、如果动画的起始值与元素的默认值是一样的，from参数可以省略

			- 　　2、如果不考虑values，to、by两个参数至少需要有一个出现。否则没有动画效果。to表示绝对值，by表示相对值。以位移距离为例子，如果from是100, to值为160，则表示移动到160这个位置；如果by值是160，则表示移动到100+160=260这个位置

			- 　　3、如果to、by同时出现，则只识别to

			- 　　4、 当values值设置并能识别时，from、to、by的值都会被忽略

			- 例子

				- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate attributeName="x" values="30;50;30;70;30" dur="2s"  repeatCount="indefinite" />
    </text>
  </g>
</svg>


	- 【时间表示】

		- SVG animation中的时间表示，常见单位有 "h"、"min"、"s"、"ms"。单位含义都是英文单位的缩写。例如h表示小时(hour)

		- 时间值支持小数写法，因此，90s也可以使用1.5min表示。时间值还支持hh:mm:ss这种写法，因此，90s也可以使用01:30表示

		- 如果begin="1.5"没有单位，这里的小数点表示秒，也就是1.5s的意思

	- 【begin、end】

		- begin指动画开始的时间，begin的定义是分号分隔的一组值。

		- 例如，beigin="3s;6s"表示的是3s之后动画走一下，6s时候动画再走一下（如果之前动画没走完，会立即停止从头开始）

		- 所以，如果一次动画时间为3s, 即dur="3s"，同时没有repeatCount属性时候，可以看到动画似乎连续执行了2次

		- begin的单值除了普通value，还有下面这些类别的value

			- offset-value | syncbase-value | event-value | repeat-value | accessKey-value | media-marker-value | wallclock-sync-value | "indefinite"

			- ① offset-value表示偏移值，数值前面有+或-，相对于document的begin值而言。

			- ② syncbase-value基于同步确定的值。语法为：[元素的id].begin/end +/- 时间值。就是说借用其他元素的begin值进行加减运算，这个可以准确实现两个独立元素的动画级联效果

				- 【例子】

					- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate id="x" attributeName="x" to="70" dur="2" fill="freeze"/>
      <animate attributeName="y" begin="x.end" to="60" dur="2" fill="freeze"/>
    </text>
  </g>
</svg>

			- ③ event-value表示与事件相关联的值。类似于PowerPoint动画的“点击执行该动画”。语法是：[元素的id].[事件类型] +/- 时间值

				- 【例子】

					- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <circle id="circle1" cx="15" cy="15" r="15"/>
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate id="x" attributeName="x" begin="circle1.click" to="70" dur="2"/>
    </text>
  </g>
</svg>

				- 点击小球，会触发文字的运动。如果想点击小球2秒后文字才支持，加上偏移时间就可以了——begin="circle1.click+2s"

					- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <circle id="circle1" cx="15" cy="15" r="15"/>
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate id="x" attributeName="x" begin="circle1.click+2s" to="70" dur="2"/>
    </text>
  </g>
</svg>

			- ④ repeat-value指重复N次之后再进行其他运动。语法为：[元素的id].repeat(整数) +/- 时间值

				- 　　[注意]经测试该属性并不生效

				- 【例子】

					- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate id="x" attributeName="x" to="70" dur="2"/>
      <animate attributeName="y" begin="x.repeat(2)" to="70" dur="2" fill="freeze"/>
    </text>
  </g>
</svg>

			- ⑤accessKey-value定义快捷键。即按下某个按键动画开始。语法为：accessKey("character")。character表示快捷键所在的字符

				- 　　[注意]经测试该属性并不生效

				- 【例子】

					- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="30">
      小火柴的蓝色理想
      <animate attributeName="y" begin="accessKey('s')" to="70" dur="2" />
    </text>
  </g>
</svg>

			- ⑥ wallclock-sync-value指真实世界的时钟时间定义。时间语法是基于在ISO8601中定义的语法

			- ⑦ "indefinite"这个字符串值，表示“无限等待”。需要指向该动画元素的超链接(SVG中的a元素)

				- 【例子】

					- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="40">
      小火柴的蓝色理想
      <animate id="animate1" attributeName="x" begin="indefinite" to="70" dur="1" repeatCount="indefinite"/>
    </text>
     <a xlink:href="#animate1">
          <text  y="30" fill="#cd0000" font-size="20">点击</text>
     </a>    
  </g>
</svg>


	- 【dur】

		- dur属性值只有两种：常规时间值 | "indefinite"

		- “常规时间值”就是3s之类的正常值；"indefinite"指动画不执行

	- 【calcMode, keyTimes, keySplines】

		- 这几个参数是控制动画曲线的

		- calcMode属性支持4个值：discrete | linear | paced | spline. 中文意思分别是：“离散”|“线性”|“踏步”|“样条”

		- discrete from值直接跳到to值

		- linear animateMotion元素以外元素的calcMode默认值。动画从头到尾的速率都是一致的

		- paced 通过插值让动画的变化步调平稳均匀。仅支持线性数值区域内的值，这样点之间“距离”的概念才能被计算（如position, width, height等）。如果”paced“指定，任何keyTimes或keySplines值都失效

		- spline 插值定义贝塞尔曲线。spline点的定义在keyTimes属性中，每个时间间隔控制点由keySplines定义

			- keyTimes = “<list>”

			- 　　跟上面提到的<list>类似，都是分号分隔一组值。keyTimes是关键时间点的意思，这里有一些约定的规则：首先，keyTimes值的数目要和values一致，如果是from/to/by动画，keyTimes就必须有两个值。然后对于linear和spline动画，第一个数字要是0, 最后一个是1。 最后，每个连续的时间值必须比它前面的值大或者相等

			- 　　paced模式下，keyTimes会被忽略；keyTimes定义错误，也会被忽略；dur为indefinite也会被忽略

			- keySplines = “<list>”

			- 　　keySplines表示的是与keyTimes相关联的一组贝塞尔控制点（默认0 0 1 1）。每个控制点使用4个浮点值表示：x1 y1 x2 y2. 只有模式是spline时候这个参数才有用，也是分号分隔，值范围0~1，总是比keyTimes少一个值。

			- 　　如果keySplines值不合法或个数不对，是没有动画效果的

		- 【离散值discrete例子】

			- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="40">
      小火柴的蓝色理想
      <animate id="animate1" attributeName="x"  dur="3" values="40;60;80;100" calcMode="discrete" repeatCount="indefinite"/>
    </text>
  </g>
</svg>

		- 【踏步值paces的例子 】

			- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="40">
      小火柴的蓝色理想
      <animate id="animate1" attributeName="x"  dur="3" values="40;60;80;100" calcMode="paced" repeatCount="indefinite"/>
    </text>
  </g>
</svg>

		- 【贝塞尔曲线spline的例子】

			- <svg height="70" xmlns="http://www.w3.org/2000/svg">
  <g> 
    <text font-family="microsoft yahei" font-size="20" y="30" x="40">
      小火柴的蓝色理想
      <animate id="animate1" attributeName="x"  dur="3" values="40;60;100" keyTimes="0; .8; 1" calcMode="spline"  keySplines=".5 0 .5 1; 0 0 1 1" repeatCount="indefinite"/>
    </text>
  </g>
</svg>

	- 【repeatCount, repeatDur】 

		- repeatCount表示动画执行次数，可以是合法数值或者"indefinite"

		- repeatDur定义重复动画的总时间。可以是普通时间值或者"indefinite"

		- <animate attributeName="x" to="60" dur="3s" repeatCount="indefinite" repeatDur="10s" />

		- 上面的代码中，动画只执行完整3个 + 一个1/3个动画。因为repeat总时间是10s

	- 【fill】

		- fill表示动画间隙的填充方式。支持参数有：freeze | remove。其中remove是默认值，表示动画结束直接回到开始的地方。freeze“冻结”表示动画结束后像是被冻住了，元素保持了动画结束之后的状态

	- 【accumulate, additive】

		- accumulate是累积的意思。支持参数有：none | sum。默认值是none，如果值是sum表示动画结束时候的位置作为下次动画的起始位置

		- additive控制动画是否附加。支持参数有：replace | sum。默认值是replace.，如果值是sum表示动画会附加到其他低优先级的动画上

	- 【restart】

		- 　　restart支持的参数有：always | whenNotActive | never.

		- 　　always是默认值，表示总是。whenNotActive表示动画正在进行的时候，是不能重启动画的。never表示动画是一波流

	- 【min、max】

		- 　　min/max表示动画执行最短和最长时间。支持参数为时间值和"media"（媒介元素有效）, max还支持indefinite

- 【API】

	- 　　SVG animation有内置的API可以暂停和启动动画的。语法为：

		- // 暂停

		- svg.pauseAnimations();

		- // 恢复

		- svg.unpauseAnimations()

		- 【例子】

			- <svg height="70" xmlns="http://www.w3.org/2000/svg" id="svg">
  <g id="test">
    <text font-family="microsoft yahei" font-size="20" y="30" x="40">
      小火柴的蓝色理想
      <animate id="animate1" attributeName="x" dur="2" to="80" repeatCount="indefinite" />
    </text>
  </g>
</svg>
<script>
  svg.onclick = function () {
    if (!this.paused) {
      this.paused = true;
      this.pauseAnimations();
    } else {
      this.paused = false;
      this.unpauseAnimations();
    }
  }
</script>


### 62.3.8. SVG 
stroke-dasharray
stroke-dashoffset

- stroke-dasharray

	- 用于创建虚线，之所以后面跟的是array的，是因为值其实是数组

	- 值可以是百分比

- stroke-dashoffset

	- 这个属性是相对于起始点的偏移，正数偏移x值的时候，相当于往左移动了x个长度单位，负数偏移x的时候，相当于往右移动了x个长度单位。

	- 值可以是百分比

- 【案例】

	- 圆圈，一半是亮，一半是间隔

		- stroke-dasharray:'150% 50%'
stroke-dashoffset: '25%'   // 200%是全部周长，(200-150)/2=25%

- 【问题】

	- 解决圆形虚线，起始位置不在右侧中间的文章

		- [文章：svg中的虚线起始点问题地址](https://www.oschina.net/question/5269516_2323312)

	- 手动path画圆的公式

		- [文章：利用SVG的path元素中的A命令绘制圆形地址](https://blog.csdn.net/cdc_csdn/article/details/80473541)

- 【文章】

	- [SVG学习之stroke-dasharray 和 stroke-dashoffset 详解-地址](https://www.cnblogs.com/daisygogogo/p/11044353.html)

### 62.3.9. 参考文档：

- [面试官：你真的会用 SVG 吗? (SVG 应用实战)](https://juejin.cn/post/7103570138154139679)

## 62.4. vuex

### 62.4.1. [一个简单的 store 模式 ](https://cn.vuejs.org/v2/guide/state-management.html#%E7%AE%80%E5%8D%95%E7%8A%B6%E6%80%81%E7%AE%A1%E7%90%86%E8%B5%B7%E6%AD%A5%E4%BD%BF%E7%94%A8)

- 代码

  采用一个简单的 store 模式：
  ``` js
  var store = {
    debug: true,
    state: {
      message: 'Hello!'
    },
    setMessageAction (newValue) {
      if (this.debug) console.log('setMessageAction triggered with', newValue)
      this.state.message = newValue
    },
    clearMessageAction () {
      if (this.debug) console.log('clearMessageAction triggered')
      this.state.message = ''
    }
  }
  ```
  每个实例/组件仍然可以拥有和管理自己的私有状态：
  ```js
  var vmA = new Vue({
    data: {
      privateState: {},
      sharedState: store.state
    }
  })
  
  var vmB = new Vue({
    data: {
      privateState: {},
      sharedState: store.state
    }
  })
  ```
  
### 62.4.2. store：“store”基本上就是一个容器，它包含着你的应用中大部分的状态 (state)。

### 62.4.3. 全局模式使用

- mutation:变更state的方法

	- 提交mutation:store.commit('increment')

	- 读取state：store.state.count

### 62.4.4. Vue 组件中访问 this.$store property

- 你需要为 Vue 实例提供创建好的 store

	- new Vue({
  el: '#app',
  store: store,
})

- 从组件的方法提交一个变更：
methods: {
  increment() {
    this.$store.commit('increment')
    console.log(this.$store.state.count)
  }
}

### 62.4.5. 由于 store 中的状态是响应式的

- 在组件中

	- 调用 store 中的状态简单到仅需要在计算属性中返回即可

	- 触发变化也仅仅是在组件的 methods 中提交 mutation。

### 62.4.6. State

- 单一状态树

	- 状态对象必须是纯粹 (plain) 的

	- 单状态树和模块化并不冲突

- 在 Vue 组件中获得 Vuex 状态

	- 从 store 实例中读取状态最简单的方法就是在计算属性 (opens new window)中返回某个状态

		- // 创建一个 Counter 组件
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return store.state.count
    }
  }
}

	- Vuex 通过 store 选项，提供了一种机制将状态从根组件“注入”到每一个子组件中（需调用 Vue.use(Vuex)）：

		- const app = new Vue({
  el: '#app',
  // 把 store 对象提供给 “store” 选项，这可以把 store 的实例注入所有的子组件
  store,
  components: { Counter },
  template: `
    <div class="app">
      <counter></counter>
    </div>
  `
})

		- 通过在根实例中注册 store 选项，该 store 实例会注入到根组件下的所有子组件中，且子组件能通过 this.$store 访问到。让我们更新下 Counter 的实现

		- const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return this.$store.state.count
    }
  }
}

- mapState 辅助函数

	- // 在单独构建的版本中辅助函数为 Vuex.mapState
import { mapState } from 'vuex'

		- export default {
  computed: mapState({
    // 箭头函数可使代码更简练
    count: state => state.count,
    // 传字符串参数 'count' 等同于 `state => state.count`
    countAlias: 'count',
    // 为了能够使用 `this` 获取局部状态，必须使用常规函数
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}

	- 当映射的计算属性的名称与 state 的子节点名称相同时，我们也可以给 mapState 传一个字符串数组

		- computed: mapState([
  // 映射 this.count 为 store.state.count
  'count'
])

	- 对象展开运算符

		- mapState 函数返回的是一个对象

			- computed: {
  localComputed () { /* ... */ },
  // 使用对象展开运算符将此对象混入到外部对象中
  ...mapState({
    // ...
  })
}

	- 组件仍然保有局部状态

### 62.4.7. Getter

- Vuex 允许我们在 store 中定义“getter”（可以认为是 store 的计算属性）

- 通过属性访问
Getter 会暴露为 store.getters 对象，你可以以属性的形式访问这些值：

store.getters.doneTodos // -> [{ id: 1, text: '...', done: true }]

- 通过让 getter 返回一个函数，来实现给 getter 传参

	- getters: {
  // ...
  getTodoById: (state) => (id) => {
    return state.todos.find(todo => todo.id === id)
  }
}

	- store.getters.getTodoById(2) // -> { id: 2, text: '...', done: false }

	- 注意，getter 在通过方法访问时，每次都会去进行调用，而不会缓存结果。

- mapGetters

### 62.4.8. Mutation

- 更改 Vuex 的 store 中的状态的唯一方法是提交 mutation

- Vuex 中的 mutation 非常类似于事件：每个 mutation 都有一个字符串的 事件类型 (type) 和 一个 回调函数 (handler)

	- const store = new Vuex.Store({
  state: {
    count: 1
  },
  mutations: {
    increment (state) {
      // 变更状态
      state.count++
    }
  }
})

	- store.commit('increment')

	- // ...
mutations: {
  increment (state, n) {
    state.count += n
  }
}

	- store.commit('increment', 10)

	- // ...
mutations: {
  increment (state, payload) {
    state.count += payload.amount
  }
}

	- store.commit('increment', {
  amount: 10
})

	- //对象风格提交
store.commit({
  type: 'increment',
  amount: 10
})

- mapMutations

### 62.4.9. Action

- Action 类似于 mutation，不同在于：
Action 提交的是 mutation，而不是直接变更状态。
Action 可以包含任意异步操作

	- const store = new Vuex.Store({
  state: {
    count: 0
  },
  mutations: {
    increment (state) {
      state.count++
    }
  },
  actions: {
    increment (context) {
      context.commit('increment')
    }
  }
})

- Action 函数接受一个与 store 实例具有相同方法和属性的 context 对象

	- 你可以调用 context.commit 提交一个 mutation，或者通过 context.state 和 context.getters 来获取 state 和 getters。

		- actions: {
  increment ({ commit }) {
    commit('increment')
  }
}

- 分发 Action

	- store.dispatch('increment')

	-  action 内部执行异步操作

		- actions: {
  incrementAsync ({ commit }) {
    setTimeout(() => {
      commit('increment')
    }, 1000)
  }
}

	- 支持同样的载荷方式和对象方式进行分发

		- // 以载荷形式分发
store.dispatch('incrementAsync', {
  amount: 10
})

		- / 以对象形式分发
store.dispatch({
  type: 'incrementAsync',
  amount: 10
})

	- 购物车示例，涉及到调用异步 API 和分发多重 mutation

		- actions: {
  checkout ({ commit, state }, products) {
    // 把当前购物车的物品备份起来
    const savedCartItems = [...state.cart.added]
    // 发出结账请求，然后乐观地清空购物车
    commit(types.CHECKOUT_REQUEST)
    // 购物 API 接受一个成功回调和一个失败回调
    shop.buyProducts(
      products,
      // 成功操作
      () => commit(types.CHECKOUT_SUCCESS),
      // 失败操作
      () => commit(types.CHECKOUT_FAILURE, savedCartItems)
    )
  }
}

	- 在组件中分发 Action

		- import { mapActions } from 'vuex'
export default {
  // ...
  methods: {
    ...mapActions([
      'increment', // 将 `this.increment()` 映射为 `this.$store.dispatch('increment')`

      // `mapActions` 也支持载荷：
      'incrementBy' // 将 `this.incrementBy(amount)` 映射为 `this.$store.dispatch('incrementBy', amount)`
    ]),
    ...mapActions({
      add: 'increment' // 将 `this.add()` 映射为 `this.$store.dispatch('increment')`
    })
  }
}

### 62.4.10. Module

- 由于使用单一状态树，应用的所有状态会集中到一个比较大的对象。当应用变得非常复杂时，store 对象就有可能变得相当臃肿。

- const moduleA = {
  state: () => ({ ... }),
  mutations: { ... },
  actions: { ... },
  getters: { ... }
}

const moduleB = {
  state: () => ({ ... }),
  mutations: { ... },
  actions: { ... }
}

const store = new Vuex.Store({
  modules: {
    a: moduleA,
    b: moduleB
  }
})

store.state.a // -> moduleA 的状态
store.state.b // -> moduleB 的状态

- 模块内的state是局部的？

- 模块内部的 action、mutation 和 getter 是注册在全局命名空间的？

### 62.4.11. [vuex地址](https://vuex.vuejs.org/zh/)

## 62.5. vue2

### 62.5.1. [vuejs](https://blog.csdn.net/zemprogram/article/details/103404763)

- [双向数据绑定：讲得很优秀，有时间可以重点研究下](https://www.w3cplus.com/vue/vue-two-way-binding-object-defineproperty.html)

- [双方数据绑定原理分析：讲得也不错](https://blog.csdn.net/zemprogram/article/details/103404763)

- [手动实现双向数据绑定：一般](https://www.jianshu.com/p/e7ebb1500613)

- [vue原理分析：一般](https://github.com/answershuto/learnVue/blob/master/docs/%E5%93%8D%E5%BA%94%E5%BC%8F%E5%8E%9F%E7%90%86.MarkDown)

- [双向数据绑定：一般](https://developer.aliyun.com/ask/288775)

### 62.5.2. vuex

### 62.5.3. iview ui 

### 62.5.4. element ui

- [遇到一个小坑](https://blog.csdn.net/weixin_34234823/article/details/87974959)

	- [checkbox-group组件响应change事件的时机是延迟到下次DOM更新循环之后执行，以为着，这次的点击，在下一次的点击之后，进行判断，如此反复。](https://blog.csdn.net/a654540233/article/details/107245152/)

	  this.$nextTick(() => {
	            if (this.isGroup) {
	              this.dispatch('ElCheckboxGroup', 'change', [this._checkboxGroup.value]);
	            }
	          });
	  this.$nextTick 将回调延迟到下次DOM更新循环之后执行
	  
	  
	  
- 第二个坑

	- [form组件在进行重置时，需要调用resetFeilds()这个方法，由于form组件是懒加载的（sync）,所以需要把这个方法的调用放在this.nextTick(()=> this.$refs.form.resetFeilds())，否则会一直报错](https://www.jianshu.com/p/ab8deeaac9d4?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

	- 问题：列表中的数据和弹窗中的数据，如何隔离开来。1.弹窗中进行，列表中的原始数据，不动，弹窗中的显示数据用来读取时映射一下。不改动原始数据。如果要改动，需要深拷贝这个变量。

		- 引发了对深拷贝的处理了

			- JSON.parse(JSON.stringify(data))

				- 这个方法可能有限制

				  JSON.stringify() - JavaScript | MDN (mozilla.org)
				  
		- 实现案例1

			- [实现deepClone的方法1](https://blog.csdn.net/Kimser/article/details/106476775)

			  ···
			  // 深拷贝
			   
			  const clone = (obj) => {
			    var o;
			    // 如果  他是对象object的话  , 因为null,object,array  也是'object';
			    if (typeof obj === 'object') {
			      
			      // 如果  他是空的话
			      if (obj === null) {
			        o = null;
			      }
			      else {
			    
			        // 如果  他是数组arr的话
			        if (obj instanceof Array) {
			          o = [];
			          for (var i = 0, len = obj.length; i < len; i++) {
			            o.push(clone(obj[ i ]));
			          }
			        }
			        // 如果  他是对象object的话
			        else {
			          o = {};
			          for (var j in obj) {
			            o[ j ] = clone(obj[ j ]);
			          }
			        }
			        
			      }
			    }
			    else {
			      o = obj;
			    }
			    return o;
			  };
			   
			  ···
			  
		- 实现案例2

			- [实现deepClone的方法](https://www.jianshu.com/p/2e1768040ecb)

			  ···
			  function deepCopy(obj,cache = []){
			        // 如果为普通数据类型，则直接返回，完成拷贝
			        if (obj===null || typeof obj !== "object"){
			            return obj
			        }
			          // cache用来储存原始值和对应拷贝数据，在递归调用deepCopy函数时，如果本次拷贝的原始值在之前已经拷贝了，则直接返回储存中的copy值，这样的话就不用再循环复制本次原始值里面的每一项了。
			          // 还有一个更为重要的作用，假如原始值里面嵌套两个引用地址相同的对象，使用cache可以保证拷贝出来的copy值里面两个对象的引用地址也相同。
			          // 如果find查找的是一个空数组，则不会执行
			        const hit = find(cache,c=>c.original===obj)
			        if(hit){
			            return hit.copy
			        }
			        // 定义拷贝的数据类型
			        const copy = Array.isArray(obj) ? [] : {}
			        // 用来记录拷贝的原始值和copy值
			        cache.push[{
			            original:obj,
			            copy
			        }]
			        // 递归调用深拷贝函数，拷贝对象中的每一个值
			        Object.keys(obj).forEach(key=>{
			            copy[key]=deepCopy(obj[key],cache)
			        })
			        return copy
			      }
			  ···
			  
				-  const hit1 = find(cache,c=>c.original===obj)

- 封装dialog时

	- [从父组件传递dialog开启和关闭的属性like：modalShow，
这种情况下，在dialog关闭时，必须要干一件事情，让父组件知道弹窗是关闭了的，不然下次无法开启。也就是子组件必须要改父组件的值时，该如何实现？](https://blog.csdn.net/weixin_43972992/article/details/103344158)

		- iview中：父组件中用v-model，传递打开和关闭变量到子组件，然后再modal组件关闭时，触发input事件，传递false给变量：简化 => v-model + $emit("input", false)

		- element ui中：父组件中使用:visible.sync="xxShow",子组件触发update:var，传递false过去，简化：=> var.sync + $emit("update:var, false)

- el-tree 中节点的元素的class都是tree-item

### 62.5.5. swiper

### 62.5.6. [Vue Router](https://router.vuejs.org/zh/guide/advanced/navigation-guards.html#%E5%85%A8%E5%B1%80%E5%89%8D%E7%BD%AE%E5%AE%88%E5%8D%AB)

### 62.5.7. vue修改第三方库样式时不生效

- [地址](https://arrow.blog.csdn.net/article/details/107062781)

- 样式穿透不同写法

	-  
![image](assets/1b2f6f31dc18d7a8571033dd963dd4ef3661fda96082fa9944c399ae3e3594bd.png)

### 62.5.8. 这15个Vue自定义指令，让你的项目开发爽到爆

- [地址](https://zhuanlan.zhihu.com/p/108308393)

### 62.5.9. vue自定义指令写法

- Vue.directive('formValidate', {
    bind: function (el, binding, vnode) {
        vnode.componentInstance['formValidator'] = new AsyncValidator(vnode.componentInstance.rules);
    },
    update: function (el, binding, vnode) {
        vnode.componentInstance['formValidator'].validate(vnode.componentInstance.model, (errors) => {
            binding.value(!errors, errors);
        });
    }
});

- vnode.componentInstance

	- 指令所在的组件实例

- vnode.componentInstance.model

	- 指令所在元素的model属性

### 62.5.10. （几乎）完美实现 el-table 列宽自适应

- [地址](https://juejin.cn/post/6865844599613718536)

### 62.5.11. 插槽

- [官方文档](https://cn.vuejs.org/v2/guide/components-slots.html)

### 62.5.12. 参考链接：

- [1.vue-自定义指令拖动el-dialog](https://juejin.cn/post/7103696591176859661)

- [2.vue2的响应式原理介绍——Object.defineProperty](https://juejin.cn/post/7103764386220769311)

- [3.25个 Vue 技巧,学了这么久才知道还能这么用](https://juejin.cn/post/7098688018663342111)

- [4.vue权限文章](https://juejin.cn/post/7103488625781768222)

- [5.前端配置化真香～上班又多了60%的摸🐟时间](https://juejin.cn/post/7098211898990002207)

## 62.6. angularjs

### 62.6.1. 模块

angularjs 诞生于 2009 年，那时候前端还没有模块化的标准，angularjs 在API层面探索了模块的概念。一个模块由任意个服务组成

- 服务

	- 生命周期

	  angularjs 文档里面并无生命周期的概念，这里为了方便理解，对不同服务按照可访问性的时间顺序划分为不同的声明周期
	  
		- app生命周期

			- 配置阶段

				- 在app启动之时，在创建service之前，它会配置和实例化所有的provider，我们把这个叫做app生命周期的配置阶段，在这个阶段，service还不可使用，因为他们还未创建。

				- 一旦配置阶段完成，那么所有的provider变为不可用，创建service的进程开始启动，这个阶段被叫做app生命周期的运行阶段。

				- Constant“配方”在配置阶段是可用的

			- 运行阶段

		- 初始化前

		- 初始化后

			- 实例化前

			- 实例化后

	- 类型

	  在 angularjs 模块里面一切都是服务，只是表象不同而已，表象不同是因为它们的使用时机不同，然后不同的服务对封装的需求不同。
	  
		- provider

		- service

		- factory

			- AngularJS中的服务其实就是提供一种方式抽取共用类库

				- 服务是controller 之间的胶水， 因为service 在angular中是单例的。每个服务都只有一个实例，它相当于就是一个中介，我们可以在两个控制器中都注入这个服务，然后通过这个服务来传递一些数据。

		- constant

		- value

		- decorator

			- 装饰器
![image](assets/9a9e05b9787a6d9b9efdab7b36c8b3173814bf0b06b2de963ae3be220d2ff749.png)

			- ngModelDirective

				- 例子：这里delegate为什么是数组？ctrls为什么是数组，就要看ngModelDirective了
![image](assets/397892c658c2804c686da64937139c5ee5a6177445c999b61c58e4a932a3a1a7.png)

					- 原理1：ngModelDirective
![image](assets/12e0f1c5f3459379ed58604d572a4841afa61ab8b82c080c5fc5548017d056a4.png)

					- 原理2：Form

						- [地址](https://www.cnblogs.com/whitewolf/p/3560418.html)

						- formControl
![image](assets/28e4ac9cd27a8af102b90af2b1110a8d910982e2bdd4ea1ea44285a91525aa31.png)

- 指令、控制器

  指令和控制器本身不是服务，但它们被处理的方式和服务是一样的，除此之外，angularjs 为它们提供了额外的支持，比如：指令会被编译，控制器会被初始化并和 Scope 一起工作。
  
	- ngModel

		- ngModelCtrl

			- $setViewValue方法

				- 例子1
![image](assets/019c77823521116b477b5cb0bd4915e2de8f909c552a9945db70240b5f399bba.png)

				- 参数

					- value:string

						- value参数是我们想要赋值给ngModel实例的实际值

				- 方法描述

					- 这个方法会更新控制器上本地的$viewValue，然后将值传递给每一个$parser函数（包括验证器）

					- 当值被解析，且$parser流水线中所有的函数都调用完成后，值会被赋给$modelValue属性，并且传递给指令中ng-model

		- $parsers

			- 每当控件从 DOM 中读取值时，要以管道的形式执行的函数数组。依次调用每个函数，将值传递给下一个函数。最后一个返回值用于填充模型。用于消毒/转换值以及验证。对于验证，解析器应该使用 $setValidity ()更新有效性状态，并为无效值返回未定义的值。

				- Array of functions to execute, as a pipeline, whenever the control reads value from the DOM. Each function is called, in turn, passing the value through to the next. The last return value is used to populate the model. Used to sanitize / convert the value as well as validation. For validation, the parsers should update the validity state using $setValidity(), and return undefined for invalid values.

		- $formaters

			- 当模型值发生变化时，要以管道的形式执行的函数数组。依次调用每个函数，将值传递给下一个函数。用于格式化/转换控件和验证中显示的值。

				- Array of functions to execute, as a pipeline, whenever the model value changes. Each function is called, in turn, passing the value through to the next. Used to format / convert values for display in the control and validation.

- 钩子

	- config

		- config方法

			- 在模块加载阶段，对模块进行自定义配置

			- 在模块上添加的服务，指定等，实际上都是在config阶段配置的。

			- config 运行时，只能访问 provider, constant

			- 作用：对provider进行配置

		- 例子合集

			- 例子1
![image](assets/099f2a756b3149b89ad3d53299a6291e09dd0fda60dc4921a0268768d2a797fe.png)

			- 例子2
![image](assets/6ed9de121f4961eb0a0d4db9289992f5a3aa79b691fd295776c5aab7ed92f83b.png)

			- 例子3
![image](assets/66378b59fd9142085aabc273799e92a28cf89fc89c8fed842d6a33bccc402aa7.png)

			- 例子4
![image](assets/3baf40ad20e7f8f43a60659985cc9e53c19c96efa5f12ed7aa2d5b92fd29a93d.png)

			- 例子5
![image](assets/55a93c423107ff17d4de9814f77e236ce6341faaba1e53472567d5063a131f23.png)

			- 例子6
![image](assets/e204e1bb63cc665990ab07afac08a878c8a688e741d03cfc5e76090011120af7.png)

			- 例子7
![image](assets/a4bfd71d5db18edc7b0582e4f9278591e8f24417f4382ac90d3839a7ba84f5e3.png)

			- 例子8
![image](assets/871b6eca3500e462e3cbc33913be3b87fb3c17b2f351551b95ac06d0532213e2.png)

	- run

		- run方法

			- 是应用中最先执行的方法，类似于main方法，run方法只会在angular启动的时候运行一次，定义全局的数据或逻辑，对全局作用域起作用，$rootScope上内容在多个控制器之间可以共享。例如，注册一个全局的事件监听器。每次路由发生变化时候，都执行一个函数来验证用户的权限。

			- run 运行时，各个服务已经实例化完毕，可以任意使用，除了 provider,

			- 作用：

			- run方法用于初始化全局的数据，仅对全局作用域起作用。

			- 所有服务可以使用了。

			- 做一些初始化的事情

		- 例子合集

			- 例子1
![image](assets/9d9828375a12a2a51b8ddf31261093f0f5ff34b99b55804b1f6f6cf9433a5fe7.png)

			- 例子2
![image](assets/71f0151405b57d382a602cb855b35bfccbd6cc15c1f334f31c865464a1866a15.png)

			- 例子3
![image](assets/6806b36a6a02c4bab3a8783fa91d24bd195b673dbd652a5bf1e91320e1e16f60.png)

			- 例子4
![image](assets/d705895ef79631754b4ccec2141eb2452b45a2d88507d8d5950e1a5aaca5a2dc.png)

			- 例子5
![image](assets/911656e6692550cd3e8bcc9a895c53205f69a717c364473aeab0ce65c4d3791d.png)

			- 例子6
![image](assets/0a10d1e1ddc9d23c50d74548764c1b40fdb9734c5db99ff776f68a500c67161e.png)

	- 执行顺序

		- 执行顺序不同:config先执行，run后执行。另外，ng启动阶段是 config-->run-->compile/link

### 62.6.2. 依赖注入

依赖注入，也可以理解为：注入依赖。
这里的依赖指服务。
谁需要注入依赖？每个服务可以任意注入其它依赖，所有依赖的服务实例化后，才会实例化当前服务

- 服务初始化前 provider only

- 服务初始化后 provider except

### 62.6.3. 模板

- 表达式

	- 任意可以求值的js表达式

	- 过滤器

- 字符串插值

  {{ value }}
  
- HTML

### 62.6.4. 控制器

控制器的角色定位有点尴尬，它能做 Scope 做不到的事情，也能做 Scope 能做的事情。
控制器，如同其名字一样，它做的事情是控制，也就是行为。作为一个函数，除了行为，它还能借机做一些其它的事情，这就看具体使用场景了。

- 数据载体

- 行为函数载体

- 默认行为载体

- 默认数据载体

- 服务消费者

### 62.6.5. Scope

Scope 是 angularjs 的核心，从 API 层面看，Scope 负责的主要是数据，但它也可以附带行为，这和控制器是有一定的功能重叠的。
一个方法是挂在控制器上好一些，还是挂在 Scope 上好一些？没有标准答案，我想这也是控制器、Scope二者功能重叠的一方面原因吧。
Scope 持有父 Scope 的引用，也持有所有子 Scope 的引用，所以从 Scope 的视角来看，页面上所有的 Scope 构成了一棵 Scope 树，每个 Scope 被一个控制器包围起来，它们有自己的数据和行为

- 数据载体

- 行为函数载体

- 监测数据

- 响应数据变化

- 树形

- 隔离

### 62.6.6. 指令

指令系统的完善为 angularjs 提供了各种开箱即用的功能，如：双向绑定，表单校验，事件绑定，循环等等。

- 操作DOM

- 绑定事件

- 数据交互

- 封装

### 62.6.7. 过滤器

- 数据转换

- 数据筛选

### 62.6.8. 函数

- 对象拷贝：angular.copy(), angular.extend()

- 类型检测：angular.is*()

- 包装为类 jQuery 对象：angular.element()

- 异步启动：angular.bootstrap()

### 62.6.9. 内置服务

- $http

- $q

- $timeout/$interval

- $window/$document/$location

- $compile/$interpolate/$parse

### 62.6.10. 内置指令

- 数据绑定：ng-model/ng-bind/ng-value

- 渲染，可见性：ng-if/ng-show/ng-hide

- 表单元素状态：ng-checked/ng-readonly/ng-selected

- 样式：ng-class/ng-style

- 表单默认：input/select/form/textarea

- 事件：ng-click/ng-mouse*/ng-key*

- ng-switch/ng-repeat/ng-options

- ng-app

### 62.6.11. ngResources

### 62.6.12. ngRoute

### 62.6.13. 5种方法创建服务
![image](assets/91eb73afc1cf5f11e60d3a1e715a88c8e69597dd4201e1e1c0ab11c8bc3ab7a7.png)

### 62.6.14. angular.bootstrap()

- 手动初始化
Angular中也提供了手动绑定的api——bootstrap，它的使用方式如下：

angular.bootstrap(element, [modules], [config]);

### 62.6.15. angular.module("ng");

- 一个参数

	- 调用这个方法时如果只传递一个参数，就可以用它来引用模块。例如，可以通过以下代码来引用myApp模块

	- 这个方法相当于AngularJS模块的getter方法，用来获取对模块的引用。
接下来，就可以在angular.module('myApp')返回的对象上创建我们的应用了。

	- 用来获取对模块的引用

- 两个参数

	- 第二个参数是一个空数组，这个空数组是为了指定在此module中需要用到哪些其他的modules。

	- 现在，我们定义另一个module

	- angular.module('myApp.services', [])

### 62.6.16. 问题

- ng-if同ng-show和ng-hide指令最本质的区别

	- 怪异的ng-if内部的ng-mode问题

		- 现象

			- 1. 直接使用字符串

				-  将创造一个新的data ，即使在父作用域中存在具有相同名称的模型。

				- 直接使用 字符串 作为ng-model的变量，父作用域获取不到。

					- 参考链接

						- [地址](https://www.jb51.cc/angularjs/149094.html)

					- 解决方法：

						- 在父作用域中定义对象，使用对象作为ng-model的变量。

						- "config.validateCode"> </div>

			- 2. 使用点符号的表达式

				- 让 JS 查找范围的原型链

				- 因此，如果它在当前作用域中找不到该值，它将尝试在父作用域中寻找该值，以此类推。

			- 总结：上面1，2是字符串和表达式的区别？

		- 当一个元素被ng-if从DOM中移除，同它关联的作用域也会被销毁。而且当它重新加入DOM中时，会通过原型继承从它的父作用域生成一个新的作用域。
这样会导致，在 ng-if 中用基本变量绑定 ng-model ，并在外层 div 中把此 model 绑定给另一个显示区域，内层改变时，外层不会同步改变，因为此时已经是两个变量了。

			- <p>{{name}}</p>
<div ng-if="true">
<input type="text" ng-model="name" />
</div>


		- 所以遇到ng-model外部有ng-if时，需要进行使用let models = $scope.m = {},避免问题出现

		- 参考链接

			- stackoverflow

				- [地址](https://stackoverflow.com/questions/19177732/what-is-the-difference-between-ng-if-and-ng-show-ng-hide)

					- If ngModel is used within ngIf to bind to a JavaScript primitive defined in the parent scope, any modifications made to the variable within the child scope will not affect the value in the parent scope, e.g.

						- 如果在 ngIf 中使用 ngModel 绑定到父作用域中定义的 JavaScript 原语，那么对子作用域中的变量所做的任何修改都不会影响父作用域中的值

						-  
![image](assets/aaf79d23da4b32f6583f9ed18a6a85ea7b4bc96d030f8de43176db9ae17b00c7.png)

		- 【解决方案】：

			- hack1：使用ng-show代替ng-if(该方法简单有效)

			- hack2:   在绑定值时添加$parent标识

			- 比如：原来是$scope.canClcik=true；   ng-if="canClick"

			- $scope创建一个子对象obj,如$scope.obj.canClcik=true;   ng-if="obj.canClick"即可生效。

	- 它不是通过CSS显示或隐藏DOM节点，而是真正生成或移除节点。

		- 例子1 ：正确使用ng-if和ng-show - april吖～ - 博客园 (cnblogs.com)

			- [文章地址](https://www.cnblogs.com/iceseal/p/4077417.html)

			- 理解：按钮组，也就是btn-group，如果仔细观察的话，会发现一个按钮组的第一个和最后一个按钮分别是有圆角的，仅仅隐藏，其中最后一个，第二个按钮是没有圆角的，因为样式还是作用在隐藏中的第三个元素中了。

		- 文章二：What is the difference between ng-if and ng-show/ng-hide

			- [地址](https://stackoverflow.com/questions/19177732/what-is-the-difference-between-ng-if-and-ng-show-ng-hide angularjs - What is the difference between ng-if and ng-show/ng-hide - Stack Overflow)

### 62.6.17. angularjs中的$parse,$eval,$compile

- [地址](https://blog.csdn.net/qq_27870421/article/details/102627557)

- [地址2](https://www.jb51.net/article/95328.htm)

- context上下文

	- 控制器就相当于一个上下文的容器，真正的上下文其实是$scope,

	- 如果没有声明控制器，他的上下文容器就是ng-app了，那么他真正的上下文就是$rootScope，这个时候他就会寻找$rootScope有没有test。

	- 基本上和this非常相似

- $parse

	- 代码片段

		- var getter = $parse('user.name');
var setter = getter.assign;
var context = {user:{name:'angular'}};
var locals = {user:{name:'local'}};
 
expect(getter(context)).toEqual('angular');
setter(context, 'newValue');
expect(context.user.name).toEqual('newValue');
expect(getter(context, locals)).toEqual('local');

			- getter和setter就是大家所熟知的get方法和set方法了

			- context和locals仅仅是json对象而已，目的就是模拟上下文关系

			- getter(context)).toEqual('angular') //实际上就是 $parse('user.name')(context)

				- 1.获取当前的表达式user.name
2.获取当前的上下文对象{user:{name:'angular'}}
3.在上下文对象中寻找表达式的值，最终获得“angular“这个字符串

			- setter(context, 'newValue');//实际上就是 $parse('user.name').assign(context, 'newValue')
expect(context.user.name).toEqual('newValue');//测试数据上下文的值是否被改变

				- 这里的setter方法其实是改变值的方法

				- 1. 获取当前的表达式user.name
2.获取当前的上下文对象{user:{name:'angular'}}
3.改变表达式中的值，将上下文对象变成{user:{name:'newValue'}}

			- 于是上下文对象发生了改变，重新用getter方法去获取表达式的时候，上下文已经从{user:{name:'angular'}} --> {user:{name:'newValue'}},最后获取的表达式的值自然就是“newValue”了，

			- expect(getter(context, locals)).toEqual('local');//实际上就是$parse('user.name')(context, locals)

- $eval

	- $eval: function(expr, locals) {
    return $parse(expr)(this, locals);
   },

	- 只能算是$parse的另一种写法而已

- $compile

	- 其实和$parse很像。但是他是解析一段html代码的，他的功能就是将死模板变成活模板，也是指令的核心服务。

	- $compile('死模板')(上下文对象)，这样就将死模板编程了活模板，你就可以对这段活的html代码做操作了，例如增加到当前节点

	- 但是在指令中的compile属性，它会返回两个函数pre-link和post-link

第一个执行的是pre-link，它对于同一个指令的遍历顺序是从父节点到子节点的遍历，在这个阶段，dom节点还没有稳定下来，无法做一些绑定事件的操作，但是我们可以在这里进行一些初始化数据的处理。

第二个执行的是post-link，也就是我们常说的link函数，他是从子节点到父节点遍历的，在这个阶段，DOM节点已经稳定下来了，我们一般会在这里进行很多的操作。

- 【示例】

	-  
![image](assets/201edc0b51f30b997e6bdd23e154dd89c31e50f612f7c7ea1364c3581df9b745.png)

	- $watch监听函数listener，第一个参数为listener function，第二个参数change handler
![image](assets/b92df866ec141e7b7b58a6331938f5bcde51073e1857f4881327412ea2dbc38a.png)

### 62.6.18. 文章：angularjs中ui插件ui-bootstrap中的modal模态弹出源码分析

- [地址](https://www.jianshu.com/p/51d5c372e018)

- scope.$eval('$dismiss()')

	- 关闭当前弹窗

- [文章：浅谈angular-ui-bootstrap-modal这个骚东西](https://my.oschina.net/u/3492622/blog/1509975)

	- 【查看源码】

		- modalScope作用域上的$close，$dismiss
![image](assets/fcd4269a78e6422344c7b2f86b0454e9e502b4505d3d76dc16d72d90d39e85ff.png)

		- $modalStack服务dismiss方法
![image](assets/11e57767ac331c9a6f5040de6e039b042fc35cdb124259240f75dd54aff90221.png)

	- 【示例】

		-  
![image](assets/b24d6443eac28e4e86d1685d431fe692be7092742d21ab53e81b612ce56ede5d.png)

	- 【示例2】

		-  
![image](assets/f14644f1bcc2befb147db1f3ec402b38159a10fad8f6fb4fc3b6759dd7c40450.png)

### 62.6.19. angularjs $compile服务及$scope.$eval实现html动态模板解析

- $eval

	- $scope.$eval:angularjs $scope内置方法和$parse()服务一样，用解析字符串变量
例子：$scope.html='nihao';$scope.html2='html'  $scope.$eval('html2') //返回'nihao'*   

- $compile

	- $compile:angularjs内置的服务，接受一个需要编译字符串参数，变生成一个function，function要求传入一个scope,
 - 并通过此scope编译当前字符串模板
 - 例子：
 - $scope.html="<div ng-click='doSomeThing()'></div>"
 - var func=$compile(html);
 - var innerHtml=func($scope)//通过当前$scope编译字符串
 - 简写就是:var innerHtml=$compile(html)($scope);

	- 例子

		- js
![image](assets/a1de023496deac5eb1299fd35da730964c1c6d61b321f415eca575acc0b5bce3.png)

		- html
![image](assets/221c4aef0ec3d963f5ecff90e3d7448016ee30ebc7815cc25ab94a08e75d6e56.png)

### 62.6.20. 如何衡量一个人的 AngularJS 水平？

- 基础

	- 1. ng-if跟ng-show/hide的区别有哪些？

		- 第一点区别是，ng-if 在后面表达式为 true 的时候才创建这个 dom 节点，ng-show 是初始时就创建了，用 display:block 和 display:none 来控制显示和不显示。

		- 第二点区别是，ng-if 会（隐式地）产生新作用域，ng-switch 、 ng-include 等会动态创建一块界面的也是如此。

	- 2. ng-repeat迭代数组的时候，如果数组中有相同值，会有什么问题，如何解决？

		- 会提示 Duplicates in a repeater are not allowed. 加 track by $index 可解决。当然，也可以 trace by 任何一个普通的值，只要能唯一性标识数组中的每一项即可（建立 dom 和数据之间的关联）。

		- 目前遇到一个特殊情况，id是不可靠的，id可以忽而uuid，忽而数字id

			- 采用track by (item.id + $index)

	- 3. ng-click中写的表达式，能使用JS原生对象上的方法，比如Math.max之类的吗？为什么？

		- 不可以。只要是在页面中，就不能直接调用原生的 JS 方法，因为这些并不存在于与页面对应的 Controller 的 $scope 中。除非在 $scope 中添加了这个函数：

		- $scope.parseInt = function(x){
    return parseInt(x);
}

		- 执行时如$scope.Math.max

	- 4. {{now | 'yyyy-MM-dd'}}这种表达式里面，竖线和后面的参数通过什么方式可以自定义？

		- 定义方式：

		- app.filter('过滤器名称',function(){
    return function(需要过滤的对象, 过滤器参数1, 过滤器参数2, ...){
        //...做一些事情   
        return 处理后的对象;
    }
});

		- 使用方式有两种，一种是直接在页面里：

		- <p>{{now | date : 'yyyy-MM-dd'}}</p>

		- 一种是在 js 里面用：

		- // $filter('过滤器名称')(需要过滤的对象, 参数1, 参数2,...)
$filter('date')(now, 'yyyy-MM-dd hh:mm:ss');

	- 5. factory和service，provider是什么关系？

		- factory 把 service 的方法和数据放在一个对象里，并返回这个对象；service 通过构造函数方式创建 service，返回一个实例化对象；provider 创建一个可通过 config 配置的 service。

		- 从底层实现上来看，service 调用了 factory，返回其实例；factory 调用了 provider，将其定义的内容放在 $get 中返回。factory 和 service 功能类似，只不过 factory 是普通 function，可以返回任何东西（return 的都可以被访问，所以那些私有变量怎么写你懂的）；service 是构造器，可以不返回（绑定到 this 的都可以被访问）；provider 是加强版 factory，返回一个可配置的 factory。

- 深度

	- 1. angular的数据绑定采用什么机制？详述原理

		- 脏检查机制。

		- Angular 在 scope 模型上设置了一个监听队列，用来监听数据变化并更新 view 。每次绑定一个东西到 view 上时 AngularJS 就会往 $watch 队列里插入一条 $watch，用来检测它监视的 model 里是否有变化的东西。当浏览器接收到可以被 angular context 处理的事件时，$digest 循环就会触发，遍历所有的 $watch，最后更新 dom。

			- 举个栗子：
<button ng-click="val=val+1">increase 1</button>

			- click 时会产生一次更新的操作（至少触发两次 $digest 循环）:

			- 按下按钮

			- 浏览器接收到一个事件，进入到 angular context

			- $digest 循环开始执行，查询每个 $watch 是否变化

			- 由于监视 $scope.val 的 $watch 报告了变化，因此强制再执行一次 $digest 循环

			- 新的 $digest 循环未检测到变化

			- 浏览器拿回控制器，更新 $scope.val 新值对应的 dom

		- $digest 循环的上限是 10 次（超过 10次后抛出一个异常，防止无限循环）。

	- 2. 两个平级界面块a和b，如果a中触发一个事件，有哪些方式能让b知道，详述原理

		- 这个问题换一种说法就是，如何在平级界面模块间进行通信。有两种方法，一种是共用服务，一种是基于事件。

			- a. 共用服务

				- 在 Angular 中，通过 factory 可以生成一个单例对象，在需要通信的模块 a 和 b 中注入这个对象即可。

			- b. 基于事件

				- 这个又分两种方式

					- 第一种是借助父 controller。

						- 在子 controller 中向父 controller 触发（$emit）一个事件，然后在父 controller 中监听（$on）事件，再广播（$broadcast）给子 controller ，这样通过事件携带的参数，实现了数据经过父 controller，在同级 controller 之间传播。

					- 第二种是借助 $rootScope。

						- 每个 Angular 应用默认有一个根作用域 $rootScope， 根作用域位于最顶层，从它往下挂着各级作用域。所以，如果子控制器直接使用 $rootScope 广播和接收事件，那么就可实现同级之间的通信。

	- 3. 一个angular应用应当如何良好地分层？

		- 分两个方面讲

			- a. 目录结构的划分

				- 对于小型项目，可以按照文件类型组织，比如

					- css
js
  controllers
  models
  services
  filters
templates 

				- 但是对于规模较大的项目，最好按业务模块划分，比如

					- css
modules
  account
    controllers
    models
    services
    filters
    templates
  disk
    controllers
    models
    services
    filters
    templates

					- modules 下最好再有一个 common 目录来存放公共的东西。

			- b. 逻辑代码的划分

				- 作为一个 MVVM 框架，Angular 应用本身就应该按照 模型，视图模型（控制器），视图来划分。

				- 这里逻辑代码的拆分，主要是指尽量让 controller 这一层很薄。提取共用的逻辑到 service 中 （比如后台数据的请求，数据的共享和缓存，基于事件的模块间通信等），提取共用的界面操作到 directive 中（比如将日期选择、分页等封装成组件等），提取共用的格式化操作到 filter 中等等。

				- 在复杂的应用中，也可以为实体建立对应的构造函数，比如硬盘（Disk）模块，可能有列表、新建、详情这样几个视图，并分别对应的有 controller，那么可以建一个 Disk 构造函数，里面完成数据的增删改查和验证操作，有跟 Disk 相关的 controller，就注入 Disk 构造器并生成一个实例，这个实例就具备了增删改查和验证方法。这样既层次分明，又实现了复用（让 controller 层更薄了）。

	- 4. angular应用常用哪些路由库，各自的区别是什么？

		- Angular1.x 中常用 ngRoute 和 ui.router，还有一种为 Angular2 设计的 new router（面向组件）。后面那个没在实际项目中用过，就不讲了。

		- 无论是 ngRoute 还是 ui.router，作为框架额外的附加功能，都必须以 模块依赖 的形式被引入。

		- 两者区别是：

			- ngRoute 模块是 Angular 自带的路由模块，而 ui.router 模块是基于 ngRoute模块开发的第三方模块。

			- ui.router 是基于 state （状态）的， ngRoute 是基于 url 的，ui.router模块具有更强大的功能，主要体现在视图的嵌套方面。

			- 使用 ui.router 能够定义有明确父子关系的路由，并通过 ui-view 指令将子路由模版插入到父路由模板的 <div ui-view></div>  中去，从而实现视图嵌套。而在 ngRoute 中不能这样定义，如果同时在父子视图中 使用了 <div ng-view></div> 会陷入死循环。

	- 5. 如果通过angular的directive规划一套全组件化体系，可能遇到哪些挑战？

		- 能想到的一点是，组件如何与外界进行数据的交互，以及如何通过简单的配置就能使用吧。

	- 6. 分属不同团队进行开发的angular应用，如果要做整合，可能会遇到哪些问题，如何解决？

		- 可能会遇到不同模块之间的冲突。比如一个团队所有的开发在 moduleA 下进行，另一团队开发的代码在 moduleB 下：

		- angular.module('myApp.moduleA', [])
    .factory('serviceA', function(){
        ...
    })

angular.module('myApp.moduleB', [])
    .factory('serviceA', function(){
        ...
    })    

angular.module('myApp', ['myApp.moduleA', 'myApp.moduleB'])

			- 会导致两个 module 下面的 serviceA 发生了覆盖。

貌似在 Angular1.x 中并没有很好的解决办法，所以最好在前期进行统一规划，做好约定，严格按照约定开发，每个开发人员只写特定区块代码。

	- 7. angular的缺点有哪些？

		- a. 强约束

			- 导致学习成本较高，对前端不友好。

			- 但遵守 AngularJS 的约定时，生产力会很高，对 Java 程序员友好。

		- b. 不利于 SEO

			- 因为所有内容都是动态获取并渲染生成的，搜索引擎没法爬取。

			- 一种解决办法是，对于正常用户的访问，服务器响应 AngularJS 应用的内容；对于搜索引擎的访问，则响应专门针对 SEO 的HTML页面。

		- c. 性能问题

			- 作为 MVVM 框架，因为实现了数据的双向绑定，对于大数组、复杂对象会存在性能问题。

			- 可以用来 优化 Angular 应用的性能 的办法：

				- 减少监控项（比如对不会变化的数据采用单向绑定）

				- 主动设置索引（指定 track by，简单类型默认用自身当索引，对象默认使用 $$hashKey，比如改为track by item.id）

				- 降低渲染数据量（比如分页，或者每次取一小部分数据，根据需要再取）

				- 数据扁平化（比如对于树状结构，使用扁平化结构，构建一个 map 和树状数据，对树操作时，由于跟扁平数据同一引用，树状数据变更会同步到原始的扁平数据）

		- d. 移动端

	- 8. 如何看待angular 1.2中引入的controller as 语法？

		- 在 angular 1.2 以前，在 view 上的任何绑定都是直接绑定在 $scope 上的。使用 controllerAs，不需要再注入 $scope，controller 变成了一个很简单的 javascript 对象（POJO），一个更纯粹的 ViewModel。

			- 从源码实现上来看，controllerAs 语法只是把 controller 这个对象的实例用 as 别名在 $scope 上创建了一个属性。

				- if (directive.controllerAs) {
    locals.$scope[directive.controllerAs] = controllerInstance;
}

			- 但是这样做，除了上面提到的使 controller 更加 POJO 外，还可以避免遇到 AngularJS 作用域相关的一个坑（就是上文中 ng-if 产生一级作用域的坑，其实也是 javascript 原型链继承中值类型继承的坑。因为使用 controllerAs 的话 view 上所有字段都绑定在一个引用的属性上，比如 vm.xx，所以坑不再存在）。

			- 不过不引入 $scope 会出现的一个问题是，导致 $emit、 $broadcast、 $on、$watch 等 $scope 下的方法无法使用。这些跟事件相关的操作可以封装起来统一处理，或者在单个 controller 中引入 $scope，特殊对待。

	- 9. 详述angular的“依赖注入”

		- AngularJS 是通过构造函数的参数名字来推断依赖服务名称的，通过 toString() 来找到这个定义的 function 对应的字符串，然后用正则解析出其中的参数（依赖项），再去依赖映射中取到对应的依赖，实例化之后传入。

		- 因为 AngularJS 的 injector 是假设函数的参数名就是依赖的名字，然后去查找依赖项，那如果像下面这样简单注入依赖，代码压缩后（参数被重命名了），就无法查找到依赖项了。

			- function myCtrl = ($scope, $http){
    ...
}

		- 所以，通常会使用下面两种方式注入依赖（对依赖添加的顺序有要求）。

			- 数组注释法：

				- myApp.controller('myCtrl', ['$scope', '$http', function($scope, $http){
    ...
}])

			- 显式 $inject ：

				- myApp.controller('myCtrl', myCtrl);
function myCtrl = ($scope, $http){
    ...
}
myCtrl.$inject = ['$scope', '$http'];

		- 对于一个 DI 容器，必须具备三个要素：依赖项的注册，依赖关系的声明和对象的获取。在 AngularJS 中，module 和 $provide 都可以提供依赖项的注册；内置的 injector 可以获取对象（自动完成依赖注入）；依赖关系的声明，就是上面的那两种方式。

	- 10.  如何看待angular 2……

### 62.6.21. AngularJS 的自定义指令

- 1. 通用的功能，和业务无关的组件，比如某些只读的 input 输入框点击后选中所有内容，一般做法是绑定一个 ng-click="doFun()",然后在doFunc 中选中 input，封装一个directive后，就可以在input上使用属性 xxx-click-select，代码可读性增高，同时又耦合了；

- 2. 需要操作 DOM 的地方，建议封装一个directive去做；

- 3. 使用了一个第三方的组件（例如jQuery插件），又没有ng的封装版本，有时候需要自己封装directive去调用第三方组件；

- 4. 业务中一些模块需要多个地方使用，最后封装成一个directive，把调用输入参数定义好，这样在使用的地方就可以如1一样很简单的调用；

- 5. 其实如果想用可以随时使用自定义 directive，就比如 ng-include="'tasks.item.html'"， 就可以封装成一个 Element的 Directive，这样调用的时候就可以很优雅的使用 <tasks-item></tasks-item> ，这样使代码更可读更简洁，当然寻找代码变得费劲了，需要先找到 tasks-item Directive，才能找到对应的模板，只要代码结构组织好，封装directive的人经验丰富，对于调用者来说其实不需要关心细节。

### 62.6.22. angularjs 优化点：
![image](assets/0b5817a69618459618d5ef0734a84d9d6da75284f0a6b66c8fca8daafd3d62ce.svg)

- 1.之前写过的不好用的指令，进行优化

- 2.有些不好维护的代码，about界面，显示问题，激活界面显示问题，跟翻译相关的

- 3.表格方面，既有表格方式，又有瓦片方式，如何封装。

### 62.6.23. angularjs 其中一个项目例子

- [地址](https://github.com/yyhsong/iAngularJS)

	- [博客地址](https://blog.csdn.net/hwhsong/article/details/54345868)

- [例子2地址](https://github.com/taobataoma/meanTorrent/tree/master/modules/medals/client/controllers)

- [angularjs-imageupload-directive例子](https://github.com/Mischi/angularjs-imageupload-directive/blob/master/public/javascripts/imageupload.js)

### 62.6.24. angularjs中 factory，service，provoder区别

- [地址1](https://segmentfault.com/a/1190000004602085)

### 62.6.25. angularjs中的一个异常行为，弹窗关闭时，可能概率性报错

- Dismiss angular modal on URL change - errors in console

- 报错内容为：

	-  
![image](assets/f61e2c022576618526d996ebca9510d94fec773c6ef5e6c6b14f7397ce23ea70.png)

- ui-bootstrap-custom-tpls-0.11.0.js文件中$modalStack.close = function (modalInstance, result) {
        var modalWindow = openedWindows.get(modalInstance).value;
        if (modalWindow) {
          modalWindow.deferred.resolve(result);
          removeModalWindow(modalInstance);
        }
      };

	- openedWindows.get(modalInstance)可能找不到，因为之前可能已经关闭过弹窗了

- 状态

	- 暂时没有很好的解决办法

- stackoverflow解决了这个问题，但是很麻烦

	- [文章地址](https://stackoverflow.com/questions/21768778/angular-ui-bootstrap-scope-modalinstance-close-causes-cannot-read-property-v/22334609)

	- [文章地址2](https://stackoverflow.com/questions/22286457/dismiss-angular-modal-on-url-change-errors-in-console)

	- [代码地址](http://plnkr.co/edit/daf8dP?p=info&preview)

### 62.6.26. 目前来看，angularjs最大提升的办法就是看angularjs源码了

- [angularjs源码博客地址](https://blog.csdn.net/WuLex/article/details/79696425)

- [angularjs源码文件ng地址](https://github.com/angular/angular.js/tree/master/src/ng)

- [angularjs源码directive地址](https://github.com/angular/angular.js/tree/master/src/ng/directive)

- [跟我读AngularJs的源代码](https://blog.csdn.net/WuLex/article/details/79696425?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522164619041216780366553850%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=164619041216780366553850&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-79696425.pc_search_result_cache&utm_term=angularjs+%E6%BA%90%E7%A0%81&spm=1018.2226.3001.4187)

- [zagger写文章：angularjs源码阅读-1-模块加载器](https://blog.csdn.net/sleepy_wolf/article/details/123206527?spm=1001.2014.3001.5502)

- [zagger写文章：angularjs源码阅读-2-加载模块](https://editor.csdn.net/md?not_checkout=1&articleId=123225341)

- angularjs执行流程：

  bindJQuery();

  publishExternalAPI(angular);

  jqLite(document).ready(function() {
    angularInit(document, bootstrap);
  });

	- bindjQuery：
判断是否引入jquery，
如果没有就用内置的jQlite

	- publishExternalAPI

		- setupModuleLoader
利用ensure函数，实现
angular.module = module(name, require,configFn) {...}

			- 当调用angular.module()返回
moduleInstance = 
{
  _invokeQueue,
  requires,
  provider,
  service,
  controller,
  ...
}
注：所以你才能够链式调用
angular.module(xx)
.controller(xx)
但是controller，service之类的api调用了之后，并不是立即执行了，而是把参数放入到_invokeQueure数组中，此数组在angularInit时，调用bootstrap -> createInjector -> loadModules -> 取出之前存入的相关参数执行，具体文字会分析

			- 最后返回：
instanceInjector = {
     annotate,
     get,
     has,
     invoke,
     instantiate,
}

		- 挂载辅助api到全局对象angular上：bootstrap，toJson，bind。forEach等等

		- 将ngLocale挂在到angular的维护的模块数组中

		- 将ng挂在到angular的维护的模块数组中

	- angularInit

		- 通过ng-app=“xxx”，取出moduleName

			- bootstrap(appElement,[module])

				- createInjector

					- providerCache

					- providerInjector

					- instanceCache

					- instanceInjector

### 62.6.27. 参考链接：

- [1. 浅谈AngularJS的$parse服务](https://blog.csdn.net/inuyasha1121/article/details/79655286)

### 62.6.28. angularjs源码

- $setViewValue

  /**
     * @ngdoc method
     * @name ngModel.NgModelController#$setViewValue
     *
     * @description
     * Update the view value.
     *
     * This method should be called when the view value changes, typically from within a DOM event handler.
     * For example {@link ng.directive:input input} and
     * {@link ng.directive:select select} directives call it.
     *
     * It will update the $viewValue, then pass this value through each of the functions in `$parsers`,
     * which includes any validators. The value that comes out of this `$parsers` pipeline, be applied to
     * `$modelValue` and the **expression** specified in the `ng-model` attribute.
     *
     * Lastly, all the registered change listeners, in the `$viewChangeListeners` list, are called.
     *
     * Note that calling this function does not trigger a `$digest`.
     *
     * @param {string} value Value from the view.
     */
    this.$setViewValue = function(value) {
      this.$viewValue = value;
  
      // change to dirty
      if (this.$pristine) {
        this.$dirty = true;
        this.$pristine = false;
        $animate.removeClass($element, PRISTINE_CLASS);
        $animate.addClass($element, DIRTY_CLASS);
        parentForm.$setDirty();
      }
  
      forEach(this.$parsers, function(fn) {
        value = fn(value);
      });
  
      if (this.$modelValue !== value) {
        this.$modelValue = value;
        ngModelSet($scope, value);
        forEach(this.$viewChangeListeners, function(listener) {
          try {
            listener();
          } catch(e) {
            $exceptionHandler(e);
          }
        });
      }
    };
  
	- 步骤

		- 1. It will update the $viewValue

			- this.$viewValue = value;

		- 2. then pass this value through each of the functions in `$parsers`

			- forEach(this.$parsers, function(fn) {
      value = fn(value);
    });

		- 3. The value that comes out of this `$parsers` pipeline, be applied to
   * `$modelValue` 

			- this.$modelValue = value;

		- 4. and the **expression** specified in the `ng-model` attribute

			- ngModelSet($scope, value);

		- 5. Lastly, all the registered change listeners, in the `$viewChangeListeners` list, are called.

			- forEach(this.$viewChangeListeners, function(listener) {
        try {
          listener();
        } catch(e) {
          $exceptionHandler(e);
        }
      });

				- 源码：$viewChangeListeners使用方法
var ngChangeDirective = valueFn({
  require: 'ngModel',
  link: function(scope, element, attr, ctrl) {
    ctrl.$viewChangeListeners.push(function() {
      scope.$eval(attr.ngChange);
    });
  }
});

	- 要点

		- This method should be called when the view value changes, typically from within a DOM event handler.
   * For example {@link ng.directive:input input} and
   * {@link ng.directive:select select} directives call it.

			- 这个方法用于自定义指令，在使用自定义事件的回调中，用来更新viewValue

		- Note that calling this function does not trigger a `$digest`.

			- 用于自定义指令，在使用自定义事件的回调中，需要手动调用$digest

	- 场景

		-  
![image](assets/402c71bce0912849761ceb37216943463beccb057aac82658042a4d87e6b9cbb.png)

- $render

  var ctrl = this;
  
    $scope.$watch(function ngModelWatch() {
      var value = ngModelGet($scope);
  
      // if scope model value and ngModel value are out of sync
      if (ctrl.$modelValue !== value) {
  
        var formatters = ctrl.$formatters,
            idx = formatters.length;
  
        ctrl.$modelValue = value;
        while(idx--) {
          value = formatters[idx](value);
        }
  
        if (ctrl.$viewValue !== value) {
          ctrl.$viewValue = value;
          ctrl.$render();
        }
      }
  
      return value;
    });
  
	- 1. 获取到最新的ngModel的值

		- var value = ngModelGet($scope);

	- 2. 同步$modelValue为最新的值

		- ctrl.$modelValue = value;

	- 3. 将最新的值传入到$formatters的pipeline中

		- while(idx--) {
        value = formatters[idx](value);
      }


	- 4.用经过$formatters的pipeline中转换了的最新的值去同步$viewValue 

		- if (ctrl.$viewValue !== value) {
        ctrl.$viewValue = value;
        ctrl.$render();
      }

	- 5.调用$render方法

- $setValidity方法

  var requiredDirective = function() {
    return {
      require: '?ngModel',
      link: function(scope, elm, attr, ctrl) {
        if (!ctrl) return;
        attr.required = true; // force truthy in case we are on non input element
  
        var validator = function(value) {
          if (attr.required && ctrl.$isEmpty(value)) {
            ctrl.$setValidity('required', false);
            return;
          } else {
            ctrl.$setValidity('required', true);
            return value;
          }
        };
  
        ctrl.$formatters.push(validator);
        ctrl.$parsers.unshift(validator);
  
        attr.$observe('required', function() {
          validator(ctrl.$viewValue);
        });
      }
    };
  };
  
	- 验证相关的代码适合放在$formatters（push）和$parsers（unshift）中

- $parse服务

	- $parse服务的注释

	  /**
	   * @ngdoc service
	   * @name $parse
	   * @kind function
	   *
	   * @description
	   *
	   * Converts Angular {@link guide/expression expression} into a function.
	   *
	   * ```js
	   *   var getter = $parse('user.name');
	   *   var setter = getter.assign;
	   *   var context = {user:{name:'angular'}};
	   *   var locals = {user:{name:'local'}};
	   *
	   *   expect(getter(context)).toEqual('angular');
	   *   setter(context, 'newValue');
	   *   expect(context.user.name).toEqual('newValue');
	   *   expect(getter(context, locals)).toEqual('local');
	   * ```
	   *
	   *
	   * @param {string} expression String expression to compile.
	   * @returns {function(context, locals)} a function which represents the compiled expression:
	   *
	   *    * `context` – `{object}` – an object against which any expressions embedded in the strings
	   *      are evaluated against (typically a scope object).
	   *    * `locals` – `{object=}` – local variables context object, useful for overriding values in
	   *      `context`.
	   *
	   *    The returned function also has the following properties:
	   *      * `literal` – `{boolean}` – whether the expression's top-level node is a JavaScript
	   *        literal.
	   *      * `constant` – `{boolean}` – whether the expression is made entirely of JavaScript
	   *        constant literals.
	   *      * `assign` – `{?function(context, value)}` – if the expression is assignable, this will be
	   *        set to a function to change its value on the given context.
	   *
	   */
	  
		- 描述：将angular的表达式转换为一个方法

		- 使用方法：
 *   var getter = $parse('user.name');
 *   var setter = getter.assign;
 *   var context = {user:{name:'angular'}};
 *   var locals = {user:{name:'local'}};
 *   测试
 *   expect(getter(context)).toEqual('angular');
 *   setter(context, 'newValue');
 *   expect(context.user.name).toEqual('newValue');
 *   expect(getter(context, locals)).toEqual('local');

		- 参数：
* @param {string} expression String expression to compile.
 * @returns {function(context, locals)} a function which represents the compiled expression:
 *
 *    * `context` – `{object}` – an object against which any expressions embedded in the strings
 *      are evaluated against (typically a scope object).
 *    * `locals` – `{object=}` – local variables context object, useful for overriding values in
 *      `context`.
 *
 *    The returned function also has the following properties:
 *      * `literal` – `{boolean}` – whether the expression's top-level node is a JavaScript
 *        literal. 表达式是否是js字面量
 *      * `constant` – `{boolean}` – whether the expression is made entirely of JavaScript
 *        constant literals. 表达式是否完全由 JavaScript 常量文字组成。
 *      * `assign` – `{?function(context, value)}` – if the expression is assignable, this will be
 *        set to a function to change its value on the given context.  如果表达式是可赋值的，这将被设置为一个函数来改变它在给定上下文中的值。

			- 翻译一下：
参数：即将被编译的字符串表达式
返回：一个表示编译过表达式的函数，这个函数包含几个属性，其中assign属性，如果表达式是可以赋值的，这个属性被设置为一个函数，用来改变在给定上下文中的值

- $eval服务

	- 源码：

		-  
![image](assets/f5ad347fb828c016c03de62f8138508349ac4865169bd6089a977181591587e6.png)

	- 描述

		-  @description
       * Executes the `expression` on the current scope and returns the result. Any exceptions in
       * the expression are propagated (uncaught). This is useful when evaluating Angular
       * expressions.

			- 在当前作用域上执行“表达式”并返回结果。表达式中的任何异常都会传播（未捕获）。这在评估 Angular 表达式时很有用。

	- 用法

		- var scope = ng.$rootScope.Scope();
scope.a = 1;
scope.b = 2;
expect(scope.$eval('a+b')).toEqual(3);
expect(scope.$eval(function(scope){ return scope.a + scope.b; })).toEqual(3);

	- 参数

		- * @param {(string|function())=} expression An angular expression to be executed.
       *  要执行的angular表达式
       *    - `string`: execute using the rules as defined in  {@link guide/expression expression}.
       *    - `function(scope)`: execute the function with the current `scope` parameter.
       *
       * @param {(object)=} locals Local variables object, useful for overriding values in scope.局部变量对象，用于覆盖范围内的值。
       * @returns {*} The result of evaluating the expression.计算表达式的结果。

- $evalAsync服务

	-  
![image](assets/3d507c38484078a9c8d4860e2d1a50dc940c9ee7b5580d41253bfda90652766b.png)

- $injector服务

- 几个方法的调用顺序

	- bindJQuery();

		- 如果你引入了jQuery库就调用你引用的，没有引用则使用angular内部的一个轻量级的jQuery（jqLite）：
angular.element = jqLite

	- publishExternalAPI(angular);

		- setModuleLoader方法：
利用ensure函数实现了：
angular.module = module(name, requires, configFn)

			- 当调用angular.module()返回
moduleInstance = 
{
   _invokeQueue:xx,
   reuqires: xx,
   provider: xx,
   service: xx,
   controller: xx, 
   ...
}
注意：
1. 链式调用angular.module(xx).controller(xx)
2..controller,.service之类的方法调用时，并不是立即执行。而且先把参数放入到_invokeQueues数组中，此数组在angularInit时，调用bootstrap - > createInjector -> loadModules -> 取出之前存入的相关参数执行，


			- 最后返回：
instanceInjector = {
  annotate: 
  get: 
  has:
  invoke:
  instantitate:
}

		- 挂载辅助api到angular上，如：
bootstrap，toJson，bind，forEach等等

		- 将ngLocale挂载到angular.module上

		- 将ng挂载到angular.module上

	- angularInit方法:
jqLite(document).ready(function() {
    angularInit(document, bootstrap);
  });

		- 作用：
通过ng-app="xx"，取出moduleName

		- bootstrap方法：
bootstrap(appElement, module ? [module] : []);

			- doBootstrap方法

				- createInjector方法：
var injector = createInjector(modules);

					- 调用的地方

						- createInternalInjector(providerCache, function() {
            throw $injectorMinErr('unpr', "Unknown provider: {0}", path.join(' <- '));
          })),

					- 其他属性或者方法

						- providerCache属性

						- providerInjector属性

						- instanceCache属性

						- instanceInjector属性

					- 返回

						- instanceInjector对象

					- createInternalInjector方法

						- getService方法

						- invoke方法

						- instantiate方法

						- 返回：
{
      invoke: invoke,
      instantiate: instantiate,
      get: getService,
      annotate: annotate,
      has: function(name) {
        return providerCache.hasOwnProperty(name + providerSuffix) || cache.hasOwnProperty(name);
      }
    };

		- annotate方法
全局定义

### 62.6.29. 双向数据绑定

-  
![image](assets/bd913f5adaae9bde8ca93d67e7d685995502753b11545ba5f50131e41c1e9004.png)

- 如何判断数据是否发生变化
![image](assets/8b16502ff429aa6ab6e3fda7772d02b12033a29446f724fc2e3398bd94d32b10.png)

- 双向数据绑定原理示意图
![image](assets/a43400cf14daa5713b37614007b0d168bd2f4f9d4e94d4c8daecd07b19ce3e6f.png)

-  
![image](assets/623b58977b438704e56c17f38782c404571c47b2201a3fe6a0f3dc2b55af6f75.png)

### 62.6.30. 依赖注入

- 参数名称只能是依赖本身的名称
![image](assets/8d75b299af7f88852b0f84935a1ea4e2f9af6b36d594d6ceae065b0844610fe6.png)

- 依赖注入实现原理

### 62.6.31. 自定义指令

- 等号
![image](assets/09b23a3e47e7fdfd892d610ff452aa3cbf5f1728e2d5f1dd5a2e1db5cb6e939e.png)

- @
![image](assets/682fc2d400efefd793d42b910e4e5cf1397e914ce2ddfdf3e3b543d622a18532.png)

- 创建指令方法和配置
![image](assets/ed84773cda0ba81de62e05a6680c2401eff9bd264e7596194edc5ebd2ddb2821.png)

- 上补充
![image](assets/999895ea69f1c6ef46f48aa010aafd9b4277e10da068efc5e64dbbe9bd1f6f7c.png)

- 总结
![image](assets/255489c9d64127c4255881768558c5502ae6947273714e5eaeeaeb2ddc3910d8.png)

### 62.6.32. 设计原则

- 7大设计原则
![image](assets/0e1dad7025efe7f0cf3e667a820ed90d1ddee64b63a8a19a09e6fa19cf358c02.png)

	- KISS
![image](assets/dd4e55f6679198d69dad2f7f9377944fec86d17a8ce5bb280a407d24bdf718c7.png)

	- 高内聚低耦合
![image](assets/43cf5e337f0bc83ae62f2ff1d06a1ec41d76975cf0f5bf5279608f261194ec38.png)

## 62.7. call,apply,bind

### 62.7.1. 【call】

- 概念

	- 是函数的方法

- 特点

	- 可以函数调用

	- 可以改变this的指向

- 例子

	- let dog = {
    name: '旺旺',
    sayName: function () {
        console.log('我是', this.name)
    },
    eat: function (food1, food2) {
        console.log('我喜欢吃', food1 + food2)
    }
}
let cat = {
    name: '喵喵'
}

function fun() {
    console.log(this.name)
}
// call可以调用函数，call可以改变函数中this的指向
fun.call(cat)
dog.sayName() // 我是旺旺
dog.sayName.call(cat) // 我是喵喵
dog.eat("骨头")
dog.eat.call(cat, "鱼", "肉") // 传递参数依次传递
dog.eat.apply(cat, ["鱼", "肉"]) // 传递参数，数组的方式
let bindFun = dog.eat.bind(cat, '鱼', '肉') // 传递参数，跟call一样，bind不会调用函数,会返回一个函数，然后来调用
bindFun();

- [一个很纠结的掘金博客文章，可以看一下](https://juejin.cn/post/6999781802923524132?utm_source=gold_browser_extension#comment)

	- Function.prototype.call.call(my, this, "Hello")

- [另一个掘金的文档，关于call方法的实现](https://juejin.cn/post/6978744007601946654)

### 62.7.2. 【bind】

- 【定义】

	- bind()方法创建一个新的函数, 当被调用时，将其this关键字设置为提供的值，在调用新函数时，在任何提供之前提供一个给定的参数序列。

- 【特点】

	- bind返回的函数，需要手动调用下

- 【例子】

	-     var a ={
        name : "Cherry",
        fn : function (a,b) {
            console.log( a + b)
        }
    }

    var b = a.fn;
    b.bind(a,1,2)()           // 3

### 62.7.3. 【文章集合】

- [this、apply、call、bind](https://juejin.cn/post/6844903496253177863)

	-     var a = {
        name : "Cherry",

        func1: function () {
            console.log(this.name)
        },

        func2: function () {
            setTimeout(  function () {
                this.func1()
            }.bind(a)(),100);
        }

    };

    a.func2()            // Cherry

		-     var a = {
        name : "Cherry",

        func1: function () {
            console.log(this.name)
        },

        func2: function () {
            setTimeout(  function () {
                this.func1()
            }.bind(a),100);
        }

    };

    a.func2()            // Cherry

		- xx.bind(a)返回函数
xx.bind(a)()调用了函数了

- [JS中的bind()方法](https://blog.csdn.net/qlwangcong518/article/details/86261597)

## 62.8. http

### 62.8.1. HTTP 请求方法:

- 理解：

	- 可以这样理解，HTTP 就好比一个对象参数，里面有 Method ，代表 HTTP 的请求方法，用来告诉服务器，客户端访问你的 url 的目的是什么，是获取信息，上传数据还是删除信息。通常用到的最多就是 GET 和 POST 。

	- OPTIONS 是为客户端提供一种查询 URL 地址中有哪些可用的访问方式的方法。

	- PS: 留给思考，这个 OPTIONS 的使用场景是什么呢？

- POST 和 PUT 的区别：

	- POST：POST的数据，服务器必须保证数据被完整的保存，并且不允许出现重复的 POST 数据提交。通常在 HTML 中通过表单来提交数据。

	- PUT： PUT 允许客户端提交重复的数据，当提交重复的数据时，会用新提交的数据覆盖掉服务器已有的数据。

	- PS: 这里推荐一本我读过的书籍 《图解HTTP》写的很不错，图文并茂，简单易懂，值得阅读。

- 方法Get Post

- get / post / restful 规范

### 62.8.2. http请求的过程

- HTTP是怎么在服务端走的

	- 看下面我画的一张图，这是服务器端程序、Web 服务器、客户端之间的关系
![image](assets/6018936aa9628c12b728503d2571a3d3e6bdc53c944883924b52a05f4dd7a608.png)

- 上图是主流的模式，Web 服务器仅起到桥梁的作用，即将浏览器的 HTTP 请求解码，转换成服务器端程序能够识别的接口调用方式，然后服务器端程序会将生成的返回封装成 HTTP Response ，并返回给用户。

	- 1. 注意：在服务端，用户发的请求，如果是为了获取静态资源的话，一般是不经过服务器端程序的，直接通过服务端的缓存机制，返回资源给用户，比如 Nginx 的静态资源缓存。不走服务端程序，会大大提高响应速度。

	- 2. 注意：服务端一般都是在公司的内网，外网是无法访问的，发起 HTTP 请求，其实大多数情况下都是先通过 Nginx 进行反向代理，同时也是负责流量转发，将不同的请求转发给内网特定的服务器。

### 62.8.3. http协议 / OSI七层模型 / TCP-IP五层模型

- TCP分析 / 三次握手 / 四次握手

### 62.8.4. DNS分析

### 62.8.5. Header

### 62.8.6. http状态码的意义

- 状态码

	- 常用状态码
![image](assets/2175262b7c306ddd6af1b90f3c21a6b196d1cfcbe2e37f906ef010036a861eef.png)

- 在 web 编程中，状态码是非常重要的事情。

- 目的：

	- 是为了让开发人员和用户知道服务器是正常处理了请求还是出现了错误。了解目的，对于我们去了解状态码为什么会这样分，是非常必要的事情，至少心里不那么感觉到陌生了。

- 而在状态码中，有一个系列非常重要，那就是 3XX 系列。

	- 301 ，302 的区别

		- 302 临时重定向

			- 临时重定向，意识是当服务端关闭的时候，客户端发起 url 请求，是不能成功的。它还需要向服务端发起请求，让服务端重定向到目标网址，也就是返回 location ，然后再转到目标网址。

		- PS: 思考一下，为什么会有 302 ？

		- 301 永久重定向

			- 永久重定向，是即使服务端关闭了，浏览器端发起 url 请求，也可以不经过服务端而直接转到目标网址。除非清理缓存，否则以后再次访问都是直接访问另一个地址。

	- 重定向和永久重定向

		- 为了避免给网站的SEO造成不良影响，也为了给用户带来良好的访问体验，我们应该采用一些特别说明来告诉搜索引擎——“它们实际上是同一个页面”。当然，不仅仅是为了SEO，对于一个优秀的站点而言，每一个网页也都应该对应一个唯一的网址。

		- 简言之，就是当用户浏览器或搜索引擎访问某个旧的网址时，服务器告诉浏览器或搜索引擎，“该网页已经搬家了，新家的地址是……，请使用新地址来访问该网页”。

		- 永久重定向就表示该网址已经搬迁到一个永久居住的“新家”

		- 临时重定向就表示该网址搬迁到了一个临时居住的“公寓

		- [文章地址](https://blog.csdn.net/weixin_33940102/article/details/92204682)

### 62.8.7. http头部信息

### 62.8.8. cookie状态管理

- session / cookie / localStorage / sessionStorage

### 62.8.9. https

### 62.8.10. 文章集合

- [为什么XMLHTTPRequest不能跨域请求资源](https://juejin.cn/post/6999854437930008590?utm_source=gold_browser_extension)

### 62.8.11. [文章：通过讲故事搞定前端网络知识](https://juejin.cn/post/6844903773588963342)

### 62.8.12. 前置基础知识

- URI vs URL

	- URI：Uniform Resource Identifier

		- 百度百科：在电脑术语中，统一资源标识符（Uniform Resource Identifier，URI)是一个用于标识某一互联网资源名称的字符串。 该种标识允许用户对任何（包括本地和互联网）的资源通过特定的协议进行交互操作。

	- URL：uniform resource locator

		- 百度百科：统一资源定位系统（uniform resource locator;URL）是因特网的万维网服务程序上用于指定信息位置的表示方法。它最初是由蒂姆·伯纳斯·李发明用来作为万维网的地址。现在它已经被万维网联盟编制为互联网标准RFC1738。

	- [文章：HTTP 协议中 URI 和 URL 有什么区别？](https://www.zhihu.com/question/21950864)

### 62.8.13. Socket

- 概念

	- Socket 在汉语中是指孔或插座的意识，顾名思义，插上了就可以通信了。Socket 一开始是作为 BSD UNIX 的进程通信机制，然后逐渐成为主流操作系统共同遵守的网络编程标准。

	- Socket 是什么

		- Socket 是一个通信链的句柄，可以用来实现不同虚拟机或不同计算机之间的通信，也可以实现相同主机内的不同进程之间的通讯。

	- Socket 的组成

		- Socket = IP 地址 + 端口 + 协议

- IP 地址 + 端口 + 协议 组成一个唯一标识，用来标识一个通信链路。

- 可以看到，Socket 其实是对 TCP/IP 进行了高度封装，屏蔽了很多网络细节。这样可以使开发者更好地进行网络编程。其实就是我们写个高度封装内部细节的函数，通过传参来完成指定的行为。

- 可以这么说，所有的 TCP/UDP 等编程，基本都是按照 Socket 协议标准来进行编程的，换句话说，Socket 是一套标准，就好比 DOM ，所有语言都可以按照 DOM 的接口标准来实现自己的逻辑。

- Socket 有自己的原语，开发者可以按照 Socket 的原语在不同语言下的实现方式来进行网络编程。

- WebSocket与Socket的关系

	- Socket其实并不是一个协议，而是为了方便使用TCP或UDP而抽象出来的一层，是位于应用层和传输控制层之间的一组接口。

	- Socket是应用层与TCP/IP协议族通信的中间软件抽象层，它是一组接口。

	- 在设计模式中，Socket其实就是一个门面模式，它把复杂的TCP/IP协议族隐藏在Socket接口后面，对用户来说，一组简单的接口就是全部，让Socket去组织数据，以符合指定的协议。

	- 当两台主机通信时，必须通过Socket连接，Socket则利用TCP/IP协议建立TCP连接。

	- TCP连接则更依靠于底层的IP协议，IP协议的连接则依赖于链路层等更低层次。WebSocket则是一个典型的应用层协议。Socket是传输控制层协议，WebSocket是应用层协议。

- [文章：WebSocket和Socket的区别](https://www.jianshu.com/p/59b5594ffbb0/)

	- 容易搞混的就是，网络中的Socket

	- 通常所说的Socket API，是指操作系统中（也可能不是操作系统）提供的对于传输层（TCP/UDP）抽象的接口。

	- 现行的Socket API大致都是遵循了BSD Socket规范（包括Windows）。

	- 这里称规范其实不太准确，规范其实是POSIX，但BSD Unix中对于Socket的实现被广为使用，所以成为了实际的规范。

	- 如果你要使用HTTP来构建服务，那么就不需要关心Socket，如果你想基于TCP/IP来构建服务，那么Socket可能就是你会接触到的API。

		- 在TCP/IP网络中HTTP的位置
![image](assets/3deb4b6cc81d50e845eaa4da79ed4f8a41a8d5914a22ba253a71868895de1ab0.png)

		- 从上图中可以看到，HTTP是基于传输层的TCP协议的，而Socket API也是，所以只是从使用上说，可以认为Socket和HTTP类似（但一个是成文的互联网协议，一个是一直沿用的一种编程概念），是对于传输层协议的另一种直接使用，因为按照设计，网络对用户的接口都应该在应用层。

- socket图示
![image](assets/817e09d0687b00e58bbf18f424f8e2f4a365c96206291d6802ca0163db27a2a1.png)

- 有了端口之后，我们就能定位到网络中的进程，然后进行数据通信了。但是不同的协议的数据结构不同，也就是要做不同的操作，直接操作网络传过来的数据比较复杂，这件事应该操作系统来封装一下。所以 POSIX 就定义了 socket 的标准 api，我们通过这些 api 就可以很方便的操作不同协议的数据。

- socket 的 api 分为服务端和客户端两方面：

	- 服务端：bind、listen、accept、read、write、close

	- 客户端：connet、write、read、close

	- 图示
![image](assets/013c58058b450d71b8d8c14e44ee0443e1d65ffac1b845c077f92ad008850994.png)

	- POSIX 的思想是一切皆文件，所以网络通信的 socket 的 api 也设计成了 read、write 的形式。

	- 服务端通过 listen 来把进程绑定到端口，客户端连接上服务端的某个端口，通过网络把数据传输到该端口，之后进行数据的读写。

	- 各种语言都对 socket api 做了封装，Node.js 也不例外。

	- [socket之nodejs的例子：](http://nodejs.cn/api/net.html#net_net_createconnection)

		- server代码

			-  
![image](assets/daa13feee807eaade135bc099e67c24fb3b40819550d33a8991b6f5557ac8ea2.png)

				- server输出
![image](assets/8f9f66cb6277d6bec3113be08357dae26040e38eb3e961e094687072088d3810.png)

		- client代码

			-  
![image](assets/21d09aaf2f6b0c885330674f4d0f538c5de13a7d6f1fd7549a2d9a0bbcb20b38.png)

				- client输出
![image](assets/9a7376eab9041dc6cbd1eba669ced5744c0af7e03a72caa3c3e118c211c000b7.png)

### 62.8.14. WebSocket

- 概念

	- 这是 HTML5 定义的一种新的标准协议，实现了浏览器与服务器的全双工通信。我们可以将 WebSocket 理解为 Web + Socket ，它是一种双工通信。

	- WebSocket同HTTP一样也是应用层的协议，但是它是一种双向通信协议，是建立在TCP之上的。

	- 什么是双工通信？

		- 就是在同一时刻，我既可以扮演通信双方的发送方，也可以扮演通信双方的接收方。

- 为什么会出现 WebSocket

	- 在 WebSocket 出来之前，前端的 Web 通信基本就靠 HTTP ，但是 HTTP ( 1 或者 2 ) 请求本身有一些缺陷，比如：

	- 首部信息冗余，每次发送请求，都要携带大量冗余信息。

	- 不能实现双工通信。

	- 所以在这个技术背景下，WebSocket 技术出现了，弥补了 HTTP 的缺陷。但是我们又不能不用 HTTP ，因为已经用的场景太多了，所以就综合了一下，让 WebSocket 协议是在 HTTP 协议之上的。这样就可以做到平稳过渡到新的通信协议上了。

- WebSocket 的通信原理

	- WebSocket 是建立在 HTTP 之上的，也就意味着你要建立 WebSocket 的话，需要走一次 HTTP ，走完后，你的 WebSocket 就建立起长连接了。然后只要不是主动断开的，就会保持好客户端和服务端之间的连接，不会使其断开。当有数据传输的时候，会直接进行传输，不再发起 HTTP 请求。

	- 前端使用 WebSocket 很简单，就那么几个 API ，可自行去查看。但是我们要清楚每个 API 究竟发生了什么事情，只有理解了背后的那些真相，我们才算是真正理解了 WebSocket 。

- WebSocket和http的关系

	- 图示
![image](assets/c3cb9fed57c8d89ddc69671df74d2f119a64bd641f1161c4dcf3e4a2a1f25ea6.png)

	- 首先Websocket是基于HTTP协议的，或者说借用了HTTP的协议来完成一部分握手。

		- 在握手阶段是一样的

	- 看个典型的Websocket握手（借用Wikipedia的。。）

		- GET /chat HTTP/1.1
Host: server.example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw==
Sec-WebSocket-Protocol: chat, superchat
Sec-WebSocket-Version: 13
Origin: http://example.com

		- 熟悉HTTP的童鞋可能发现了，这段类似HTTP协议的握手请求中，多了几个东西。

			- 1. 

				- Upgrade: websocket

				- Connection: Upgrade

				- 这个就是Websocket的核心了，告诉Apache、Nginx等服务器：注意啦，窝发起的是Websocket协议，快点帮我找到对应的助理处理~不是那个老土的HTTP。

			- 2.

				- Sec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw==

					- 首先，Sec-WebSocket-Key 是一个Base64 encode的值，这个是浏览器随机生成的，告诉服务器：泥煤，不要忽悠窝，我要验证尼是不是真的是Websocket助理。

				- Sec-WebSocket-Protocol: chat, superchat

					- 然后，Sec_WebSocket-Protocol 是一个用户定义的字符串，用来区分同URL下，不同的服务所需要的协议。简单理解：今晚我要服务A，别搞错啦~

				- Sec-WebSocket-Version: 13

					- 最后，Sec-WebSocket-Version 是告诉服务器所使用的Websocket Draft（协议版本），在最初的时候，Websocket协议还在 Draft 阶段，各种奇奇怪怪的协议都有，而且还有很多期奇奇怪怪不同的东西，什么Firefox和Chrome用的不是一个版本之类的，当初Websocket协议太多可是一个大难题。。不过现在还好，已经定下来啦~大家都使用的一个东西~ 脱水：服务员，我要的是13岁的噢

	- 服务器会返回下列东西，表示已经接受到请求， 成功建立Websocket啦！

		- HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=
Sec-WebSocket-Protocol: chat

		- 这里开始就是HTTP最后负责的区域了，告诉客户，我已经成功切换协议啦~
Upgrade: websocket
Connection: Upgrade

		- 依然是固定的，告诉客户端即将升级的是Websocket协议，而不是mozillasocket，lurnarsocket或者shitsocket。

		- 然后，Sec-WebSocket-Accept 这个则是经过服务器确认，并且加密过后的 Sec-WebSocket-Key。服务器：好啦好啦，知道啦，给你看我的ID CARD来证明行了吧。。后面的，Sec-WebSocket-Protocol 则是表示最终使用的协议。

	- WebSocket 看成是 HTTP 协议为了支持长连接所打的一个大补丁，它和 HTTP 有一些共性，是为了解决 HTTP 本身无法解决的某些问题而做出的一个改良设计。

	- 在以前 HTTP 协议中所谓的 keep-alive connection 是指在一次 TCP 连接中完成多个 HTTP 请求，但是对每个请求仍然要单独发 header；

	- 所谓的 polling 是指从客户端（一般就是浏览器）不断主动的向服务器发 HTTP 请求查询是否有新数据。

	- WebSocket 解决的第一个问题是

		- 通过第一个 HTTP request 建立了 TCP 连接之后，之后的交换数据都不需要再发 HTTP request了，使得这个长连接变成了一个真.长连接。

		- 但是不需要发送 HTTP header就能交换数据显然和原有的 HTTP 协议是有区别的，所以它需要对服务器和客户端都进行升级才能实现。

		- 在此基础上 WebSocket 还是一个双通道的连接，在同一个 TCP 连接上既可以发也可以收信息。此外还有 multiplexing 功能，几个不同的 URI 可以复用同一个 WebSocket 连接。这些都是原来的 HTTP 不能做到的。

	- 技术细节

		- WebSocket 可能进入某种半死不活的状态

			- 原有网络世界的一些缺陷性设计。上面所说的 WebSocket 真.长连接虽然解决了服务器和客户端两边的问题，但坑爹的是网络应用除了服务器和客户端之外，另一个巨大的存在是中间的网络链路。一个 HTTP/WebSocket 连接往往要经过无数的路由，防火墙。你以为你的数据是在一个“连接”中发送的，实际上它要跨越千山万水，经过无数次转发，过滤，才能最终抵达终点。在这过程中，中间节点的处理方法很可能会让你意想不到。

			- 这些坑爹的中间节点可能会认为一份连接在一段时间内没有数据发送就等于失效，它们会自作主张的切断这些连接。在这种情况下，不论服务器还是客户端都不会收到任何提示，它们只会一厢情愿的以为彼此间的红线还在，徒劳地一边又一边地发送抵达不了彼岸的信息。而计算机网络协议栈的实现中又会有一层套一层的缓存，除非填满这些缓存，你的程序根本不会发现任何错误。这样，本来一个美好的 WebSocket 长连接，就可能在毫不知情的情况下进入了半死不活状态

			- WebSocket 的设计者们也早已想过。就是让服务器和客户端能够发送 Ping/Pong Frame（RFC 6455 - The WebSocket Protocol）。这种 Frame 是一种特殊的数据包，它只包含一些元数据而不需要真正的 Data Payload，可以在不影响 Application 的情况下维持住中间网络的连接状态。

	- [文章:WebSocket 是什么原理？为什么可以实现持久连接？](https://www.zhihu.com/question/20215561)

- WebSocket 优点

	- 支持推送功能，服务端可以向客户端推送数据。

	- 减少通信量，一方面是 WebSocket 的首部信息很小，另一方面是不需要频繁进行 HTTP 连接了，可以进行持久连接。

- 这里推荐一篇文章，写的挺不错，可以看看：

	- [WebSocket 是什么原理？为什么可以实现持久连接？](https://www.zhihu.com/question/20215561)

### 62.8.15. C/S 和 B/S 架构

- 对于前端工程师来说，还是要去了解一下 web 架构的发展演变的，提到发展演变，不得不说一下 C/S 和 B/S 架构。

- C/S

	- C/S ，即 Client/Server ，当前网络编程的主流架构模型。 Clent 是客户端的意识，S 是 服务端的意识。

- B/S

	- 即 Browser/Server ，是使用 Web 浏览器作为客户端的应用软件。

- 从上面介绍我们可以推断出，C/S 中的 C 有很多，比如 APP ，桌面应用等。但是 B/S 中的 B 只特指浏览器。

- B/S 结构与 C/S 结构相比，有什么区别或者说有什么优势呢？

	- 优点

		- 第一： 最显而易见的就是，B/S 部署升级快，无需应用程序更新，因为 B/S 系统的所有应用程序都是部署在服务器上的，不需要更新客户端软件。所以很多 APP 内都内嵌 H5 ，Hybrid 。 因为不需要审核，可以直接发布。为什么不需要审核呢，是因为前端的跨域限制，JS 是无法获取设备其他信息的，不需要担心安全问题，也就不用审核了。

		- 第二： 跨平台，因为操作系统都支持 Web 浏览器，所以只需要在浏览器中运行就好了。

	- 缺点

		- 安全性要求高，B/S 架构是建立在广域网上的，面向所有用户。通过 url 就可以访问服务器端资源，所以安全性要求要比 C/S 要高。

## 62.9. class

### 62.9.1. class语法
![image](assets/55b2a48d9cf46525ac7801ad3dc390924fe30dffaec7dbdf86b951e77301380a.png)

- 语法糖
![image](assets/c2c921d4789e4475e8f01a68fd061ccd88bc47cceb7f0bdee30a39913f00b098.png)

### 62.9.2. 构造函数
![image](assets/591442461232b1dbcfd0802aebada46af353ca308bf5f85a8c20454a4f464409.png)

## 62.10. es6语法

### 62.10.1. 解构赋值

- 对象的解构

	- 参考链接：

		- [如何在 JavaScript 中让代码更加精简](https://juejin.cn/post/7103540921609748510)

	- 对象的属性则是无序的，所以对象的解构赋值简单理解是等号的左边和右边的结构相同

		- let {name,age} = {name:"swr",age:28}

	- 对象的解构赋值是根据key值进行匹配

		- // 这里可以看出，左侧的name和右侧的name，是互相匹配的key值

		- // 而左侧的name匹配完成后，再赋值给真正需要赋值的Name

		- let { name:Name,age } = { name:'swr',age:28 }

	- 变量已经被声明了呢？

		- let name,age

		- // 需要用圆括号，包裹起来

		- ({name,age} = {name:"swr",age:28})

	- 变量能否也设置默认值？

		- let {name="swr",age} = {age:28}

		- // 这里规则和数组的解构赋值一样，当name = undefined时，则会使用默认值

		- console.log(a) // {name:"swr",age:28}

		- let [a] = [{name:"swr",age:28}]

		- let { length } = "hello swr"
console.log(length) // 9

		- function ajax({method,url,type='params'}){
    console.log(method) // 'get'
    console.log(url) // '/'
    console.log(type) // 'params'
}
ajax({method:"get",url:"/"})

- 数组的解构

	- let arr = [,1,2]
let [a='我是默认值',b,c] = arr

- 定义

	- 对象的解构赋值用于从一个对象取值，相当于将目标对象自身的所有可遍历的（enumerable）、但尚未被读取的属性，分配到指定的对象上面。所有的键和它们的值，都会拷贝到新对象上面。

- 要求

	- 由于解构赋值要求等号右边是一个对象，所以如果等号右边是undefined或null，就会报错，因为它们无法转为对象。

	- 解构赋值必须是最后一个参数，否则会报错。

	- 注意，解构赋值的拷贝是浅拷贝，即如果一个键的值是复合类型的值（数组、对象、函数）、那么解构赋值拷贝的是这个值的引用，而不是这个值的副本

	- 扩展运算符的解构赋值，不能复制继承自原型对象的属性。

	- 如果使用解构赋值，扩展运算符后面必须是一个变量名，而不能是一个解构赋值表达式，所以上面代码引入了中间变量newObj，如果写成下面这样会报错。

let { x, ...{ y, z } } = o;

	- 上面代码中，变量x是单纯的解构赋值，所以可以读取对象o继承的属性；变量y和z是扩展运算符的解构赋值，只能读取对象o自身的属性，所以变量z可以赋值成功，变量y取不到值。

		- const o = Object.create({ x: 1, y: 2 });
o.z = 3;
let { x, ...newObj } = o;
let { y, z } = newObj;
x // 1
y // undefined
z // 3

			- Object.create

				- 语法
Object.create(proto，[propertiesObject])
参数
proto
新创建对象的原型对象。
propertiesObject
可选。需要传入一个对象，该对象的属性类型参照Object.defineProperties()的第二个参数。如果该参数被指定且不为 undefined，该传入对象的自有可枚举属性(即其自身定义的属性，而不是其原型链上的枚举属性)将为新创建的对象添加指定的属性值和对应的属性描述符。
返回值
一个新对象，带着指定的原型对象和属性。

### 62.10.2. 扩展运算符

- 数组的拼接

	- let a = [0,1,2]
let b = [3,4,5]

		- let c = a.concat(b)

	- let d = [...a,...b]

- 取数组中最大的值

	- 以前

		- function max(...args){
    return Math.max.apply(null,args)
}
console.log(max(1,2,3,4,5,6)) // 6

	- 现在

		- //现在我们用扩展运算符看看
function max(...args){
    return Math.max(...args) // 把args [1,2,3,4,5,6]展开为1,2,3,4,5,6
}
console.log(max(1,2,3,4,5,6)) // 6

- 把argument转为数组

	- function max(){
    console.log(arguments) // { '0': 1, '1': 2, '2': 3, '3': 4, '4': 5, '5': 6 }
    let arr = [...arguments]
    console.log(arr) // [1,2,3,4,5,6]
}
max(1,2,3,4,5,6)

- 扩展运算符不能把伪数组转为数组
（除了有迭代器iterator的伪数组，如arguments）

	- let likeArr = { "0":1,"1":2,"length":2 }
let arr = [...likeArr] 
// 报错 TypeError: likeArr is not iterable

	- 可以用Array.from把伪数组转为数组

	- let likeArr = { "0":1,"1":2,"length":2 }
let arr = Array.from(likeArr)
console.log(arr) // [1,2]

- 对象也可以使用扩展运算符

	- 以前

		- // 以往我们这样合并对象
let name = { name:"alai" }
let age = { age:21 }
let person = {}
Object.assign(person,name,age)
console.log(person) // { name: 'alai', age: 21 }

	- 使用扩展运算符

		- let name = { name:"alai" }
let age = { age:21}
let person = {...name,...age}
console.log(person) // { name: 'alai', age: 21 }

	- 对象扩展运算符为浅拷贝

	- 深拷贝

		- function deepCopy(obj) {
  if(obj === null) return null
  if(typeof obj !== 'object') return obj
  if(obj instanceof RegExp) return new RegExp(obj)
  if(obj instanceof Date) return new Date(obj)
  let newObj = new obj.constructor
  for(let key in obj){
    newObj[key] = deepCopy(obj[key])
  }
  return newObj
}

- 数组进行克隆一份，互不影响

	- let a = [0,1,2,3]
let b = [...a]
b.push(4)
console.log(a) // [0,1,2,3]
console.log(b) // [0,1,2,3,4]

- 给函数传不确定参数数量

	- function sum(...args){ // 使用...扩展运算符
    console.log(args) // [ 1, 2, 3, 4, 5, 6 ] args是一个数组
    return eval(args.join('+'))
}
console.log(sum(1,2,3,4,5,6)) // 21

	- 正确的写法 扩展运算符只能放在最后一个参数

		- function sum(a,b,...args){
    console.log(a) // 1
    console.log(b) // 2
    console.log(args) // [ 3, 4, 5, 6 ]
}
sum(1,2,3,4,5,6)

- 定义

	- 对象的扩展运算符（...）用于取出参数对象的所有可遍历属性，拷贝到当前对象之中。

		- let z = { a: 3, b: 4 };
let n = { ...z };
n // { a: 3, b: 4 

- 要求

	- 由于数组是特殊的对象，所以对象的扩展运算符也可以用于数组。

		- let foo = { ...['a', 'b', 'c'] };
foo
// {0: "a", 1: "b", 2: "c"}


	- 如果扩展运算符后面是一个空对象，则没有任何效果。

		- {...{}, a: 1}
// { a: 1 }

	- 如果扩展运算符后面不是对象，则会自动将其转为对象。

		- // 等同于 {...Object(1)}
{...1} // {}

	- 由于该对象没有自身属性，所以返回一个空对象。

		- // 等同于 {...Object(true)}
{...true} // {}

// 等同于 {...Object(undefined)}
{...undefined} // {}

// 等同于 {...Object(null)}
{...null} // {}

	- 如果扩展运算符后面是字符串，它会自动转成一个类似数组的对象，因此返回的不是空对象。

		- {...'hello'}
// {0: "h", 1: "e", 2: "l", 3: "l", 4: "o"}

	- 对象的扩展运算符等同于使用Object.assign()方法。

		- let aClone = { ...a };
// 等同于
let aClone = Object.assign({}, a);

	- 扩展运算符可以用于合并两个对象。

		- let ab = { ...a, ...b };
// 等同于
let ab = Object.assign({}, a, b);

### 62.10.3. [地址](https://www.cnblogs.com/code-duck/p/13413880.html)

## 62.11. DOM

### 62.11.1. 节点

### 62.11.2. html属性和dom属性的不同

### 62.11.3. Node.textContent，Element.innerText区别

- [地址](https://juejin.cn/post/6932762351108096007)

### 62.11.4. 访问

### 62.11.5. 事件

### 62.11.6. DOM API

- 增、删、改、查、移动

- 属性操作

- 样式操作

### 62.11.7. 参考文档：

- [1.三张图讲清DOM的那点事儿](https://juejin.cn/post/7103692308582760484)

	- 节点类型

		- //element.nodeType 返回值以及对应含义：

		- 1：元素节点

		- 2：属性节点

		- 3：文本节点（包括空格和换行）

		- 8：注释节点

		- 9：文档节点

	- DOM集合与节点列表

		-  
![image](assets/3f0a8a480ecd408f2e50d550193d11a6cd20c6565d4e837c35d17de81429ef90.png)

	- DOM操作

		-  
![image](assets/47a5b5228a82fd0ddf0954dbbb28e5e3c50f207f8fbc752acea95470b70cf5fd.png)

	- 事件

		-  
![image](assets/a2496b73b0e97a372945db321f9b44124e5a21fcffbaf1d9ec016c39c38b080e.png)

## 62.12. JavaScript

### 62.12.1. 基础知识

- es6方法

	- [find方法 ](https://www.runoob.com/jsref/jsref-find.html)

		-  const hit1 = find(cache,c=>c.original===obj)

	- es6对象扩展

- DOM API

	- 增、删、改、查、移动

	- 属性操作

	- 样式操作

- BOM API

	- window

	- navigator

	- screen

	- history

	- location

- event

	- event object

	- [bubbling/capturing](https://blog.csdn.net/qq_38128179/article/details/86293394)

	  事件冒泡
	  前面提到事件委托的原理是DOM元素的事件冒泡，那么事件冒泡是什么呢？
	  
	  一个事件触发后，会在子元素和父元素之间传播（propagation）。这种传播分成三个阶段
	  
	  如上图所示，事件传播分成三个阶段：
	  ￼
	  捕获阶段：从window对象传导到目标节点（上层传到底层）称为“捕获阶段”（capture phase），捕获阶段不会响应任何事件；
	  目标阶段：在目标节点上触发，称为“目标阶段”
	  冒泡阶段：从目标节点传导回window对象（从底层传回上层），称为“冒泡阶段”（bubbling phase）。事件代理即是利用事件冒泡的机制把里层所需要响应的事件绑定到外层；
	  ps:https://blog.csdn.net/qq_38128179/article/details/86293394
	  
	- delegation

	  JavaScript事件代理（事件委托）
	  基本概念
	  事件代理（Event Delegation），又称之为事件委托。是JavaScript中常用绑定事件的常用技巧。顾名思义，“事件代理”即是把原本需要绑定在子元素的响应事件（click、keydown......）委托给父元素，让父元素担当事件监听的职务。事件代理的原理是DOM元素的事件冒泡。
	  
	  举个通俗的例子
	  
	  比如一个宿舍的同学同时快递到了，一种方法就是他们一个个去领取，还有一种方法就是把这件事情委托给宿舍长，让一个人出去拿好所有快递，然后再根据收件人一 一分发给每个宿舍同学；
	  
	  在这里，取快递就是一个事件，每个同学指的是需要响应事件的 DOM 元素，而出去统一领取快递的宿舍长就是代理的元素，所以真正绑定事件的是这个元素，按照收件人分发快递的过程就是在事件执行中，需要判断当前响应的事件应该匹配到被代理（真实需要事件响应的）元素中的哪一个或者哪几个。
	  ps:https://blog.csdn.net/qq_38128179/article/details/86293394
	  
	  事件委托的优点
	  【1】可以大量节省内存占用，减少事件注册，比如在ul上代理所有li的click事件就非常棒
	  
	  <ul id="list">
	    <li>item 1</li>
	    <li>item 2</li>
	    <li>item 3</li>
	    ......
	    <li>item n</li>
	  </ul>
	  // ...... 代表中间还有未知数个 li
	  如上面代码所示，如果给每个li列表项都绑定一个函数，那对内存的消耗是非常大的，因此较好的解决办法就是将li元素的点击事件绑定到它的父元素ul身上，执行事件的时候再去匹配判断目标元素。
	  
	  【2】可以实现当新增子对象时无需再次对其绑定（动态绑定事件）
	  
	  假设上述的例子中列表项li就几个，我们给每个列表项都绑定了事件；
	  
	  在很多时候，我们需要通过 AJAX 或者用户操作动态的增加或者删除列表项li元素，那么在每一次改变的时候都需要重新给新增的元素绑定事件，给即将删去的元素解绑事件；
	  
	  如果用了事件委托就没有这种麻烦了，因为事件是绑定在父层的，和目标元素的增减是没有关系的，执行到目标元素是在真正响应执行事件函数的过程中去匹配的；所以使用事件在动态绑定事件的情况下是可以减少很多重复工作的。
	  
	  基本实现
	  【1】JavaScript原生实现事件委托
	  
	  比如我们有这样的一个 HTML 片段：
	  
	  <ul id="myLinks">
	    <li id="goSomewhere">Go somewhere</li>
	    <li id="doSomething">Do something</li>
	    <li id="sayHi">Say hi</li>
	  </ul>
	  按照传统的做法，需要像下面这样为它们添加 3 个事 件处理程序
	  
	      var item1 = document.getElementById("goSomewhere");
	      var item2 = document.getElementById("doSomething");
	      var item3 = document.getElementById("sayHi");
	   
	      item1.onclick = function() {
	        location.href = "http://www.baidu.com";
	      };
	      item2.onclick = function() {
	        document.title = "事件委托";
	      };
	      item3.onclick = function() {
	        alert("hi");
	      };
	  如果在一个复杂的 Web 应用程序中，对所有可单击的元素都采用这种方式，那么结果就会有数不 清的代码用于添加事件处理程序。此时，可以利用事件委托技术解决这个问题。使用事件委托，只需在 DOM 树中尽量最高的层次上添加一个事件处理程序，如下面的例子所示
	  
	      var item1 = document.getElementById("goSomewhere");
	      var item2 = document.getElementById("doSomething");
	      var item3 = document.getElementById("sayHi");
	   
	      document.addEventListener("click", function (event) {
	        var target = event.target;
	        switch (target.id) {
	          case "doSomething":
	            document.title = "事件委托";
	            break;
	          case "goSomewhere":
	            location.href = "http://www.baidu.com";
	            break;
	          case "sayHi": alert("hi");
	            break;
	        }
	      })
	  【2】jQuery事件delegate()实现事件委托
	  
	  delegate() 方法为指定的元素（属于被选元素的子元素）添加一个或多个事件处理程序，并规定当这些事件发生时运行的函数。
	  
	  格式：$(selector).delegate(childSelector, event, data, function)
	  
	  参数	描述
	  childSelector	必需，规定要附加事件处理程序的一个或多个子元素。
	  event	
	  必需，规定附加到元素的一个或多个事件。由空格分隔多个事件值。必须是有效的事件。
	  
	  data	可选，规定传递到函数的额外数据。
	  function	必需，规定当事件发生时运行的函数。
	  <!DOCTYPE html>
	  <html>
	   
	  <head>
	    <meta charset="utf-8">
	    <script src="http://lib.sinaapp.com/js/jquery/2.0.2/jquery-2.0.2.min.js"></script>
	  </head>
	   
	  <body>
	    <ul id="myLinks">
	      <li id="goSomewhere">Go somewhere</li>
	      <li id="doSomething">Do something</li>
	      <li id="sayHi">Say hi</li>
	    </ul>
	   
	    <script>
	      $(document).ready(function () {
	        $("#myLinks").delegate("#goSomewhere", "click", function () {
	          location.href = "http://www.baidu.com";
	        });
	      });
	    </script>
	   
	  </body>
	   
	  </html>
	  使用事件委托注意事项
	  使用“事件委托”时，并不是说把事件委托给的元素越靠近顶层就越好。事件冒泡的过程也需要耗时，越靠近顶层，事件的”事件传播链”越长，也就越耗时。如果DOM嵌套结构很深，事件冒泡通过大量祖先元素会导致性能损失。
	  ps:https://blog.csdn.net/qq_38128179/article/details/86293394
	  
	- 同步任务

	- 异步任务

		- 任务队列

			- 宏任务

				- 1. script (可以理解为外层同步代码，作为入口 )   2. setTimeout/setInterval

			- 微任务

				- 1.Promise 2. nextTick

			- 执行顺序 是 微任务 先输出 在输出 宏任务

	- 执行栈

- ajax

	- 基础

		- ajax

			- xhr四部曲

				- [地址](https://juejin.cn/post/6998321572972855309)

				- 原生js

					- get请求

						- 代码

							- ```javascript
function getAjax(url) {
    let xhr = new XMLHttpRequest()
    xhr.open("get", url, true)
    xhr.onload = function () {
        console.log(xhr)
        console.log(xhr.responseText)
    }
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            console.log(xhr.responseText)
        }
    }
    xhr.send(null);
}
getAjax("https://172.16.200.222/8081/thor/uaa/ad-server");
```

						- 带参数

							- 发送一个带有参数的 get 请求

							- var xhr = new XMLHttpRequest

							- 直接在请求地址后面拼接参数，? 开始，key=value 的形式，多个参数之间以 & 分割 

							- xhr.open('get', '/ajax?name=Jack&age=18')

							- xhr.onload = function () { console.log( xhr.responseText ) }

							- xhr.send()

					- post请求

						- 带参数的思路

							- 发送一个带有参数的 post 请求

							- var xhr = new XMLHttpRequest

							- 不需要在请求地址后面拼接任何内容

							- xhr.open('post', '/ajax')

							- xhr.onload = function () { console.log( xhr.responseText ) }

							- post 方式携带参数是直接写在 xhr.send() 后面的 () 里面

							- 自己收集数据 key=value

							- 自己设置请求头

							- xhr.setRequestHeadr('content-type', 'application/x-www-form-urlencoded')

							- FormData 收集数据 

							- 什么都不需要，只要使用 FormData 收集数据就可以了

							- var fd = new FormData(DOM)

							- 在发送请求的时候只要把 fd 带过去就行了

						- 代码1-自己收集参数

						  ```
						  var xhr = new XMLHttpRequest()
						  xhr.open('post', '/ajax')
						  xhr.onload = function () {
						    console.log(xhr.responseText)
						  }
						  xhr.setRequestHeadr('content-type', 'application/x-www-form-urlencoded')
						  xhr.send('key=value&key=value')
						  ```
						  
						- 代码2-formdata收集参数

						  ```
						  var fd = new FormData(document.querySelector('form'))
						  var xhr = new XMLHttpRequest()
						  xhr.open('post', '/ajax')
						  xhr.onload = function () {
						    console.log(xhr.responseText)
						  }
						  xhr.send(fd)
						  ```
						  
				- jq

					- $.get

						- 思路

							- $.get 几个参数，怎么使用

							- 地址

							- 参数 key=value 或者 { name: 'Jack' }

							- 成功的回调函数

							- 预期后台返回的数据类型

							- text ： 什么都不做，直接给你结果

							- json ： 必定会执行一步 JSON.parse()

					- $.post

						- 思路

							- $.post 几个参数，怎么使用

							- 地址

							- 参数 key=value 或者 { name: 'Jack' }， 不能发送 FormData

							- 成功的回调函数

							- 预期后台返回的数据类型

					- $.ajax

						- 思路

							- $.ajax 几个参数，怎么使用

							- 就是配置项 options 

							- url： 请求地址

							- method/type: 请求方式

							- data： 携带参数

							- dataType： 后台返回的数据类型天

							- success： 成功的回掉

							- error： 失败的回调

							- contentType: 发送 FormData 的时候使用的

							- processData： 发送 FormData 的时候使用的

					- JSONP

						- 思路

							- $.ajax 怎么发送 jsonp 请求

							- dataType 必须是 jsonp

							- 方式必须是 get

							- jsonp： 根据后台来决定

			- XHR兼容性

			- GET POST

			- 异步

			- 状态监控

			- 跨域

		- XHR兼容性

		- GET POST

		- 异步

		- 状态监控

		- 跨域

	- fetch

		- [MDN地址](https://developer.mozilla.org/zh-CN/docs/Web/API/Fetch_API/Using_Fetch)

			- 好像并没有具体说明fetch使用的技术到底是什么？
还有原理到底是什么？

	- axios

	- ajax/fetch/axios之间关系

		- 图示
![image](assets/ebe3f3d59dcf2e49ce6f41e070725f86a68f6fc1f893247734f8baa492a56379.png)

			- Ajax 是一种代表异步 JavaScript + XML 的模型（技术合集），所以 Fetch 也是 Ajax 的一个子集

			- 在之前，我们常说的 Ajax 默认是指以 XHR 为核心的技术合集，而在有了 Fetch 之后，Ajax 不再单单指 XHR 了，我们将以 XHR 为核心的 Ajax 技术称作传统 Ajax。

			- Axios 属于传统 Ajax（XHR）的子集，因为它是基于 XHR 进行的封装。

### js高级理论知识

- 基础总结深入

	- 数据类型

	  1. 分类(2大类)

	    * 基本(值)类型

	      * Number: 任意数值

	      * String: 任意文本

	      * Boolean: true/false

	      * undefined: undefined

	      * null: null

	    * 对象(引用)类型

	      * Object: 一般对象类型

	      * Array: 特别的对象类型(下标/内部数据有序)

	      * Function: 特别的对象类型(可执行)

	  2. 判断

	    * typeof:

	      * 可以区别: 数值, 字符串, 布尔值, undefined, function

	      * 不能区别: null与对象, 一般对象与数组

	    * instanceof

	      * 专门用来判断对象数据的类型: Object, Array与Function

	    * ===

	      * 可以判断: undefined和null
		- 1. 分类

		- 2. 判断

		- 相关问题

		  1. undefined与null的区别?

		    * undefined代表变量没有赋值

		    * null: 代表变量赋值了, 只是值为null

		  2. 什么时候将变量赋值为null?

		    * 初始化赋值: 将要作为引用变量使用, 但对象还没有确定

		    * 结束时: 将变量指向的对象成为垃圾对象

		  3. 理解变量类型与数据类型?

		    * js的变量本身是没有类型的, 变量的类型实际上是变量内存中数据的类型

		    * 变量类型:

		      * 基本类型: 保存基本类型数据的变量

		      * 引用类型: 保存对象地址值的变量

		    * 数据对象

		      * 基本类型

		      * 对象类型
			- 1. undefined与null的区别?

			- 2. 什么时候将变量赋值为null?

			- 3. 严格区别变量类型与数据类型?

	- 数据, 变量与内存

	  1. 什么是数据?

	    * 存储于内存中代表特定信息的'东东', 本质就是0101二进制

	    * 具有可读和可传递的基本特性

	    * 万物(一切)皆数据, 函数也是数据

	    * 程序中所有操作的目标: 数据

	      * 算术运算

	      * 逻辑运算

	      * 赋值

	      * 调用函数传参

	      ...

	  2. 什么是内存?

	    * 内存条通电后产生的存储空间(临时的)

	    * 产生和死亡: 内存条(集成电路板)==>通电==>产生一定容量的存储空间==>存储各种数据==>断电==>内存全部消失

	    * 内存的空间是临时的, 而硬盘的空间是持久的

	    * 分配内存: 声明变量和函数或创建对象时, JS引擎会自动为此分配一定大小的内存来存放对应的数据

	    * 释放内存: 清空内存中的数据, 标识内存可以再分配使用(内存不释放就不能复用)

	      * 自动释放: 栈空间的局部变量

	      * 垃圾回调器回调: 堆空间的垃圾对象

	    * 一块内存包含2个数据

	      * 内部存储的数据(一般数据/地址数据)

	      * 内存地址值数据

	    * 内存分类

	      * 栈: 全局变量, 局部变量 (空间较小)

	      * 堆: 对象 (空间较大)

	  3. 什么是变量?

	    * 值可以变化的量, 由变量名与变量值组成

	    * 一个变量对应一块小内存, 变量名用来查找到内存, 变量值就是内存中保存的内容

	  4. 内存,数据, 变量三者之间的关系

	    * 内存是一个容器, 用来存储程序运行需要操作的数据

	    * 变量是内存的标识, 我们通过变量找到对应的内存, 进而操作(读/写)内存中的数据
		- 1. 什么是数据?

		- 2. 什么是内存?

			-  
![image](assets/b82530c7ae5dfc2041f7aa70e249a7ccb193070877f2308c5edb8648b763557d.png)

		- 3. 什么是变量?

		- 4. 内存,数据, 变量三者之间的关系

		- 相关问题

		  1. 问题1: var a = xxx, a内存中到底保存的是什么?

		    * xxx是一个基本数据

		    * xxx是一个对象

		    * xxx是一个变量

		  

		  2. 关于引用变量赋值问题

		    * 2个引用变量指向同一个对象, 通过一个引用变量修改对象内部数据, 另一个引用变量也看得见

		    * 2个引用变量指向同一个对象,让一个引用变量指向另一个对象, 另一个引用变量还是指向原来的对象

		  

		  3. 问题: 在js调用函数时传递变量参数时, 是值传递还是引用传递?

		    * 只有值传递, 没有引用传递, 传递的都是变量的值, 只是这个值可能是基本数据, 也可能是地址(引用)数据

		    *  如果后一种看成是引用传递, 那就值传递和引用传递都可以有

		  

		  4. 问题: JS引擎如何管理内存?

		    1. 内存生命周期

		      1). 分配需要的内存

		      2). 使用分配到的内存

		      3). 不需要时将其释放/归还

		    2. 释放内存

		      * 为执行函数分配的栈空间内存: 函数执行完自动释放

		      * 存储对象的堆空间内存: 当内存没有引用指向时, 对象成为垃圾对象, 垃圾回收器后面就会回收释放此内存
			- 关于赋值与内存的问题?

			- 关于引用变量赋值问题?

			- 关于数据传递问题?

			- JS引擎如何管理内存?

	- 对象

	  1. 什么是对象?

	    * 代表现实中的某个事物, 是该事物在编程中的抽象

	    * 多个数据的集合体(封装体)

	    * 用于保存多个数据的容器

	  2. 为什么要用对象?

	    * 便于对多个数据进行统一管理

	  3. 对象的组成

	    * 属性

	      * 代表现实事物的状态数据

	      * 由属性名和属性值组成

	      * 属性名都是字符串类型, 属性值是任意类型

	    * 方法

	      * 代表现实事物的行为数据

	      * 是特别的属性==>属性值是函数

	  4. 如何访问对象内部数据?

	    * .属性名: 编码简单, 但有时不能用

	    * ['属性名']: 编码麻烦, 但通用

	  
		- 1. 什么是对象?

		- 2. 为什么要用对象?

		- 3. 对象的组成

		- 4. 如何访问对象内部数据?

		- 相关问题

		  什么时候必须使用['属性名']的方式访问对象内部数据?

		    * 属性名不是合法的标识名

		    * 属性名不确定
			- 什么时候必须使用['属性名']的方式?

	- 函数

	  1. 什么是函数?

	    * 具有特定功能的n条语句的封装体

	    * 只有函数是可执行的, 其它类型的数据是不可执行的

	    * 函数也是对象

	  2. 为什么要用函数?

	    * 提高代码复用

	    * 便于阅读和交流

	  3. 如何定义函数?

	    * 函数声明

	    * 表达式

	  4. 调用(执行)函数

	    * test()

	    * new test()

	    * obj.test()

	    * test.call/apply(obj)
		- 1. 什么是函数?

		- 2. 为什么要用函数?

		- 3. 如何定义函数?

		- 4. 如何调用(执行)函数?

		- 5. 回调函数

		  1. 什么函数才是回调函数?

		    * 你定义的

		    * 你没有直接调用

		    * 但最终它执行了(在特定条件或时刻)

		  2. 常见的回调函数?

		    * DOM事件函数

		    * 定时器函数

		  

		    * ajax回调函数(后面学)

		    * 生命周期回调函数(后面学)
			- 1. 什么函数才是回调函数?

			- 2. 常见的回调函数?

		- 6. IIEF

		  1. 理解

		    * 全称: Immediately-Invoked Function Expression 立即调用函数表达式

		    * 别名: 匿名函数自调用

		  2. 作用

		    * 隐藏内部实现

		    * 不污染外部命名空间
			- 1. 理解

			- 2. 作用

		- 7. 函数中的this

		  function Person(color) {

		    // console.log(this)

		    this.color = color;

		    this.getColor = function () {

		      // console.log(this)

		      return this.color;

		    };

		    this.setColor = function (color) {

		     // console.log(this)

		      this.color = color;

		    };

		  }

		  

		  Person("red"); //this是谁?

		  

		  var p = new Person("yello"); //this是谁?

		  

		  p.getColor(); //this是谁?

		  

		  var obj = {};

		  p.setColor.call(obj, "black"); //this是谁?

		  

		  var test = p.setColor;

		  test(); //this是谁?

		  

		  function fun1() {

		    function fun2() {

		      console.log(this);

		    }

		  

		    fun2(); //this是谁?

		  }

		  fun1();
- 函数高级

	- 原型与原型链

		- 原型(prototype)

		  1. 函数的prototype属性(图)

		    * 每个函数都有一个prototype属性, 它默认指向一个Object空对象(即称为: 原型对象)

		    * 原型对象中有一个属性constructor, 它指向函数对象

		  2. 给原型对象添加属性(一般都是方法)

		    * 作用: 函数的所有实例对象自动拥有原型中的属性(方法)
			- 1. 函数的protype属性

				-  
![image](assets/9ea9bce2cc25a91b023a842172c8e35e7c63056d4c9d549af5bfbca91130c5ad.png)

			- 2. 给原型对象添加属性(一般都是方法)

		- 显式原型与隐式原型

		  1. 每个函数function都有一个prototype，即显式原型

		  2. 每个实例对象都有一个__proto__，可称为隐式原型

		  3. 对象的隐式原型的值为其对应构造函数的显式原型的值

		  4. 内存结构(图)

		  5. 总结:

		    * 函数的prototype属性: 在定义函数时自动添加的, 默认值是一个空Object对象

		    * 对象的__proto__属性: 创建对象时自动添加的, 默认值为构造函数的prototype属性值

		    * 程序员能直接操作显式原型, 但不能直接操作隐式原型(ES6之前)
			-  
![image](assets/e8b5c53e5a47b54a9f06bdbb01492bc5d3561d1dc9747f5e77b2d446362848bc.png)

		- 原型链

			- 1. 原型链

			  1. 原型链(图解)

			    * 访问一个对象的属性时，

			      * 先在自身属性中查找，找到返回

			      * 如果没有, 再沿着__proto__这条链向上查找, 找到返回

			      * 如果最终没找到, 返回undefined

			    * 别名: 隐式原型链

			    * 作用: 查找对象的属性(方法)

			  2. 构造函数/原型/实体对象的关系(图解)

			  3. 构造函数/原型/实体对象的关系2(图解)
				-  
![image](assets/0d6b9ab170f7b1637de55e6a572d3eaea2fe68ba4b3ed4a4b0ade26aa9d8c538.png)

			- 2. 构造函数/原型/实例对象的关系(图解)

				- var o1 = new Object();
var o2 = {};

				-  
![image](assets/b7d5b9991ba8dfc683584ece66e7c28341652fc06b531bab428f4be745fe4030.png)

			- 3. 构造函数/原型/实例对象的关系2(图解)

				- function Foo(){  }

				-  
![image](assets/f88baefc063b83fa603371cefd50a8ca438c8b9e3d7559e91ab5f44e1ad1bdee.png)

			- 4. 原型继承

				- 构造函数的实例对象自动拥有构造函数原型对象的属性(方法)

				- 利用的就是原型链

			- 5. 原型属性问题

			  1. 读取对象的属性值时: 会自动到原型链中查找

			  2. 设置对象的属性值时: 不会查找原型链, 如果当前对象中没有此属性, 直接添加此属性并设置其值

			  3. 方法一般定义在原型中, 属性一般通过构造函数定义在对象本身上
		- 探索instanceof

		  1. instanceof是如何判断的?

		    * 表达式: A instanceof B

		    * 如果B函数的显式原型对象在A对象的原型链上, 返回true, 否则返回false

		  2. Function是通过new自己产生的实例
			- 案例1

				- function Foo() {  }
var f1 = new Foo();
console.log(f1 instanceof Foo);
console.log(f1 instanceof Object);

				-  
![image](assets/d40d210e94738d75f0891a70c864d01684b411f5c8c57cffee6bf5a8b96f8936.png)

			- 案例2

				- console.log(Object instanceof Function);
console.log(Object instanceof Object);
console.log(Function instanceof Function);
console.log(Function instanceof Object);

function Foo() {}
console.log(Object instanceof  Foo);

				-  
![image](assets/c7b6ea12284706f1e4ee4a4168e5248597b228a884288508b54cc879ccccc134.png)

		- 面试题

		  /*

		    测试题1

		     */

		    var A = function() {

		  

		    }

		    A.prototype.n = 1

		  

		    var b = new A()

		  

		    A.prototype = {

		      n: 2,

		      m: 3

		    }

		  

		    var c = new A()

		    console.log(b.n, b.m, c.n, c.m)

		  

		  

		    /*

		     测试题2

		     */

		    var F = function(){};

		    Object.prototype.a = function(){

		      console.log('a()')

		    };

		    Function.prototype.b = function(){

		      console.log('b()')

		    };

		    var f = new F();

		    f.a()

		    f.b()

		    F.a()

		    F.b()
	- 执行上下文与执行上下文栈

		- 变量提升与函数提升

		  1. 变量声明提升

		    * 通过var定义(声明)的变量, 在定义语句之前就可以访问到

		    * 值: undefined

		  2. 函数声明提升

		    * 通过function声明的函数, 在之前就可以直接调用

		    * 值: 函数定义(对象)

		  3. 问题: 变量提升和函数提升是如何产生的?
		- 执行上下文

		  1. 代码分类(位置)

		    * 全局代码

		    * 函数代码

		  2. 全局执行上下文

		    * 在执行全局代码前将window确定为全局执行上下文

		    * 对全局数据进行预处理

		      * var定义的全局变量==>undefined, 添加为window的属性

		      * function声明的全局函数==>赋值(fun), 添加为window的方法

		      * this==>赋值(window)

		    * 开始执行全局代码

		  3. 函数执行上下文

		    * 在调用函数, 准备执行函数体之前, 创建对应的函数执行上下文对象

		    * 对局部数据进行预处理

		      * 形参变量==>赋值(实参)==>添加为执行上下文的属性

		      * arguments==>赋值(实参列表), 添加为执行上下文的属性

		      * var定义的局部变量==>undefined, 添加为执行上下文的属性

		      * function声明的函数 ==>赋值(fun), 添加为执行上下文的方法

		      * this==>赋值(调用函数的对象)

		    * 开始执行函数体代码
			- 1. 代码分类(位置)

			- 2. 全局执行上下文

			- 3. 函数执行上下文

		- 执行上下文栈

			- 理解

			  1. 在全局代码执行前, JS引擎就会创建一个栈来存储管理所有的执行上下文对象

			  2. 在全局执行上下文(window)确定后, 将其添加到栈中(压栈)

			  3. 在函数执行上下文创建后, 将其添加到栈中(压栈)

			  4. 在当前函数执行完后,将栈顶的对象移除(出栈)

			  5. 当所有的代码执行完后, 栈中只剩下window
			- 流程分析

			   var a = 10

			    var bar = function (x) {

			      var b = 5

			      foo(x + b)              

			    }

			    var foo = function (y) {

			      var c = 5

			      console.log(a + c + y)

			    }

			    bar(10)                   
				-  
![image](assets/ef498657d7f84e2ac6360105f1859d6fde755b09a977c678bd171cfe47124b9d.png)

				-  
![image](assets/7f67de13704fdbdc6a7ec67a35644dfe66298be6299ef2b092ecd28f0eb73bf3.png)

				-  
![image](assets/3b47b8f4faefb891a03e4d40bf07921800d857f9458eb23adebf2e607f36882d.png)

		- 面试题

		   /*

		    测试题1: 

		    */

		    function a() {}

		    var a;

		    console.log(typeof a)

		  

		  

		    /*

		    测试题2: 

		     */

		    if (!(b in window)) {

		      var b = 1;

		    }

		    console.log(b)

		  

		    /*

		    测试题3: 

		     */

		    var c = 1

		    function c(c) {

		      console.log(c)

		      var c = 3

		    }

		    c(2)
	- 作用域与作用域链

		- 作用域

		  1. 理解

		    * 就是一块"地盘", 一个代码段所在的区域

		    * 它是静态的(相对于上下文对象), 在编写代码时就确定了

		  2. 分类

		    * 全局作用域

		    * 函数作用域

		    * 没有块作用域(ES6有了)

		  3. 作用

		    * 隔离变量，不同作用域下同名变量不会有冲突
			-  
![image](assets/a69eab7eea49fe0056cac0686f9fe688e3abf11325898ccf4f82cb9cbf39a71b.png)

		- 作用域与执行上下文

		  1. 区别1

		    * 全局作用域之外，每个函数都会创建自己的作用域，作用域在函数定义时就已经确定了。而不是在函数调用时

		    * 全局执行上下文环境是在全局作用域确定之后, js代码马上执行之前创建

		    * 函数执行上下文环境是在调用函数时, 函数体代码执行之前创建

		  2. 区别2

		    * 作用域是静态的, 只要函数定义好了就一直存在, 且不会再变化

		    * 上下文环境是动态的, 调用函数时创建, 函数调用结束时上下文环境就会被释放

		  3. 联系

		    * 上下文环境(对象)是从属于所在的作用域

		    * 全局上下文环境==>全局作用域

		    * 函数上下文环境==>对应的函数使用域
			-  
![image](assets/a16294ff2316a8d81eb42c314b4bf8fe087d27ad0b107e637870f28f51d0d4dc.png)

		- 作用域链

		  1. 理解

		    * 多个上下级关系的作用域形成的链, 它的方向是从下向上的(从内到外)

		    * 查找变量时就是沿着作用域链来查找的

		  2. 查找一个变量的查找规则

		    * 在当前作用域下的执行上下文中查找对应的属性, 如果有直接返回, 否则进入2

		    * 在上一级作用域的执行上下文中查找对应的属性, 如果有直接返回, 否则进入3

		    * 再次执行2的相同操作, 直到全局作用域, 如果还找不到就抛出找不到的异常
			-  
![image](assets/e64299a51ed99ca2c202b526ffb5c40e59d375f1259cf5ead5a495fe49783473.png)

			  	var a = 2;

			      function fn1() {

			          var b = 3;

			          function fn2() {

			              var c = 4;

			              console.log(c);

			              console.log(b);

			              console.log(a);

			              console.log(d);

			          }

			          fn2();

			      }

			      fn1();
		- 面试题

			- 面试题1

			    var x = 10;

			    function fn() {

			      console.log(x);

			    }

			    function show(f) {

			      var x = 20;

			      f();

			    }

			    show(fn);
			- 面试题2

			    var fn = function () {

			      console.log(fn)

			    }

			    fn()

			  

			    var obj = {

			      fn2: function () {

			        console.log(fn2)

			      }

			    }

			    obj.fn2()
	- 闭包

		- 引子实例

		  <!DOCTYPE html>

		  <html lang="en">

		  <head>

		      <meta charset="UTF-8">

		      <title>Title</title>

		      <script type="text/javascript">

		            /*

		  需求: 点击某个按钮, 提示"点击的是第n个按钮"

		           */

		      </script>

		  </head>

		  <body>

		      <button>测试1</button>

		      <button>测试2</button>

		      <button>测试3</button>

		  </body>

		  

		  </html>
		- 理解闭包

		  1. 如何产生闭包?

		    * 当一个嵌套的内部(子)函数引用了嵌套的外部(父)函数的变量(函数)时, 就产生了闭包

		  2. 闭包到底是什么?

		    * 使用chrome调试查看

		    * 理解一: 闭包是嵌套的内部函数(绝大部分人)

		    * 理解二: 包含被引用变量(函数)的对象(极少数人)

		    * 注意: 闭包存在于嵌套的内部函数中

		  3. 产生闭包的条件?

		    * 函数嵌套

		    * 内部函数引用了外部函数的数据(变量/函数)
		- 常见的闭包

		  1. 将函数作为另一个函数的返回值

		  2. 将函数作为实参传递给另一个函数调用
		- 闭包的作用

		  1. 使用函数内部的变量在函数执行完后, 仍然存活在内存中(延长了局部变量的生命周期)

		  2. 让函数外部可以操作(读写)到函数内部的数据(变量/函数)

		  

		  问题:

		    1. 函数执行完后, 函数内部声明的局部变量是否还存在?

		    2. 在函数外部能直接访问函数内部的局部变量吗?
		- 闭包的生命周期

		  1. 产生: 在嵌套内部函数定义执行完时就产生了(不是在调用)

		  2. 死亡: 在嵌套的内部函数成为垃圾对象时

		  

		  

		  <script type="text/javascript">

		    function fun1() {

		      //问题2: 此时闭包产生了吗? 

		      var a = 3;

		  

		      function fun2() {

		        a++;

		        console.log(a);

		      }

		  

		      return fun2;

		    }

		    //问题1: 此时闭包产生了吗?   

		    var f = fun1();

		    //问题3: 此时闭包释放了吗?  

		    f();

		    f();

		    //问题4: 此时闭包释放回收了吗?   

		    //问题5: 如何让闭包释放回收呢?

		  </script>
		- 闭包的应用: 自定义JS模块

		  闭包的应用 : 定义JS模块

		    * 具有特定功能的js文件

		    * 将所有的数据和功能都封装在一个函数内部(私有的)

		    * 只向外暴露一个包信n个方法的对象或函数

		    * 模块的使用者, 只需要通过模块暴露的对象调用方法来实现对应的功能
		- 闭包的缺点及解决

		  1. 缺点

		    * 函数执行完后, 函数内的局部变量没有释放, 占用内存时间会变长

		    * 容易造成内存泄露

		  2. 解决

		    * 能不用闭包就不用

		    * 及时释放
		- 面试题

			- 面试题一

			  //代码片段一

			  var name = "The Window";

			  var object = {

			      name : "My Object",

			      getNameFunc : function(){

			          return function(){

			              return this.name;

			          };

			      }

			  };

			  alert(object.getNameFunc()());  //?

			  

			  

			  //代码片段二

			  var name2 = "The Window";

			  var object2 = {

			      name2 : "My Object",

			      getNameFunc : function(){

			          var that = this;

			          return function(){

			              return that.name2;

			          };

			      }

			  };

			  alert(object2.getNameFunc()()); //?

			  

			  

			  
			- 面试题二

			    function fun(n,o) {

			          console.log(o)

			          return {

			              fun:function(m){

			                  return fun(m,n);

			              }

			          };

			      }

			      var a = fun(0);  a.fun(1);  a.fun(2);  a.fun(3);//undefined,?,?,?

			      var b = fun(0).fun(1).fun(2).fun(3);//undefined,?,?,?

			      var c = fun(0).fun(1);  c.fun(2);  c.fun(3);//undefined,?,?,?
- 面向对象高级

	- 对象创建模式

		- Object构造函数模式

		  方式1: Object构造函数模式

		    * 套路: 先创建空Object对象, 再动态添加属性/方法

		    * 适用场景: 起始时不确定对象内部数据

		    * 问题: 语句太多
		- 对象字面量模式

		  方式2: 对象字面量模式

		    * 套路: 使用{}创建对象, 同时指定属性/方法

		    * 适用场景: 起始时对象内部数据是确定的

		    * 问题: 如果创建多个对象, 有重复代码
		- 工厂模式

		  方式3: 工厂模式

		    * 套路: 通过工厂函数动态创建对象并返回

		    * 适用场景: 需要创建多个对象

		    * 问题: 对象没有一个具体的类型, 都是Object类型
		- 自定义构造函数模式

		  方式4: 自定义构造函数模式

		    * 套路: 自定义构造函数, 通过new创建对象

		    * 适用场景: 需要创建多个类型确定的对象

		    * 问题: 每个对象都有相同的数据, 浪费内存
		- 构造函数+原型的组合模式

		  方式5: 构造函数+原型的组合模式

		    * 套路: 自定义构造函数, 属性在函数中初始化, 方法添加到原型上

		    * 适用场景: 需要创建多个类型确定的对象
	- 继承模式

		- 原型链继承

		  方式1: 原型链继承

		    1. 套路

		      1. 定义父类型构造函数

		      2. 给父类型的原型添加方法

		      3. 定义子类型的构造函数

		      4. 创建父类型的对象赋值给子类型的原型

		      5. 将子类型原型的构造属性设置为子类型

		      6. 给子类型原型添加方法

		      7. 创建子类型的对象: 可以调用父类型的方法

		    2. 关键

		      1. 子类型的原型为父类型的一个实例对象
			-  
![image](assets/6914c5ee4a73cbef7c58bde588e29bd1406c0a34fc97f4f7d2ce674ed0aa07d6.png)

		- 借用构造函数继承

		  方式2: 借用构造函数继承(假的)

		  1. 套路:

		    1. 定义父类型构造函数

		    2. 定义子类型构造函数

		    3. 在子类型构造函数中调用父类型构造

		  2. 关键:

		    1. 在子类型构造函数中通用super()调用父类型构造函数
		- 组合继承

		  方式3: 原型链+借用构造函数的组合继承

		  1. 利用原型链实现对父类型对象的方法继承

		  2. 利用super()借用父类型构建函数初始化相同属性
- 线程机制与事件机制

	- 进程与线程

		- 进程(process)

			- 程序的一次执行, 它占有一片独有的内存空间

			- 可以通过windows任务管理器查看进程

		- 线程(thread)

			- 是进程内的一个独立执行单元

			- 是程序执行的一个完整流程

			-  是CPU的最小的调度单元

		- 图解

			-  
![image](assets/46548a8fcc449918df224c995a2e69ae125282301e6993202df7f63ce293fa7a.png)

		- 相关知识

			- 应用程序必须运行在某个进程的某个线程上

			- 一个进程中至少有一个运行的线程: 主线程,  进程启动后自动创建

			- 一个进程中也可以同时运行多个线程, 我们会说程序是多线程运行的

			- 一个进程内的数据可以供其中的多个线程直接共享

			- 多个进程之间的数据是不能直接共享的

			- 线程池(thread pool): 保存多个线程对象的容器, 实现线程对象的反复利用

		- 相关问题

			- 何为多进程与多线程?

				- 多进程运行: 一应用程序可以同时启动多个实例运行

				- 多线程: 在一个进程内, 同时有多个线程运行

			- 比较单线程与多线程?

				- 多线程

					- 优点

						- 能有效提升CPU的利用率

					- 缺点

						- 创建多线程开销

						- 线程间切换开销

						- 死锁与状态同步问题

				- 单线程

					- 优点

						- 顺序编程简单易懂

					- 缺点

						- 效率低

			- JS是单线程还是多线程?

				- js是单线程运行的

				- 但使用H5中的 Web Workers可以多线程运行

			- 浏览器运行是单线程还是多线程?

				- 都是多线程运行的

			- 浏览器运行是单进程还是多进程?

				- 有的是单进程

					- firefox

					- 老版IE

				- 有的是多进程

					- chrome

					- 新版IE

				- 如何查看浏览器是否是多进程运行的呢?

					- 任务管理器-->进程

	- 浏览器内核

		- 支撑浏览器运行的最核心的程序

		- 不同的浏览器可能不一样

			- Chrome, Safari : webkit

			- firefox : Gecko

			- IE	: Trident

			- 360,搜狗等国内浏览器: Trident + webkit

		- 内核由很多模块组成

			- js引擎模块 : 负责js程序的编译与运行

			- html,css文档解析模块 : 负责页面文本的解析

			- DOM/CSS模块 : 负责dom/css在内存中的相关处理 

			- 布局和渲染模块 : 负责页面的布局和效果的绘制(内存中的对象)

			- ......

			- 定时器模块 : 负责定时器的管理

			- DOM事件响应模块 : 负责事件的管理

			- 网络请求模块 : 负责ajax请求

	- 定时器引发的思考

	  1. 定时器真是定时执行的吗?

	    * 定时器并不能保证真正定时执行

	    * 一般会延迟一丁点(可以接受), 也有可能延迟很长时间(不能接受)

	  2. 定时器回调函数是在分线程执行的吗?

	    * 在主线程执行的, js是单线程的

	  3. 定时器是如何实现的?

	    * 事件循环模型(后面讲)
		- 1. 定时器真是定时执行的吗?

		- 2. 定时器回调函数是在哪个线程执行的?

		- 3. 定时器是如何实现的?

	- JS是单线程执行的

	  1. 如何证明js执行是单线程的?

	    * setTimeout()的回调函数是在主线程执行的

	    * 定时器回调函数只有在运行栈中的代码全部执行完后才有可能执行

	  2. 为什么js要用单线程模式, 而不用多线程模式?

	    * JavaScript的单线程，与它的用途有关。

	    * 作为浏览器脚本语言，JavaScript的主要用途是与用户互动，以及操作DOM。

	    * 这决定了它只能是单线程，否则会带来很复杂的同步问题

	  

	  3. 代码的分类:

	    * 初始化代码

	    * 回调代码

	  4. js引擎执行代码的基本流程

	    * 先执行初始化代码: 包含一些特别的代码

	      * 设置定时器

	      * 绑定监听

	      * 发送ajax请求

	    * 后面在某个时刻才会执行回调代码
		- 1. 如何证明js执行是单线程的?

		- 2. 为什么js要用单线程模式, 而不用多线程模式?

		- 3. 代码的分类

		- 4. js引擎执行代码的基本流程

	- 浏览器的事件循环(轮询)模型

	  1. 所有代码分类

	    * 初始化执行代码: 包含绑定dom事件监听, 设置定时器, 发送ajax请求的代码

	    * 回调执行代码: 处理回调逻辑

	  2. js引擎执行代码的基本流程:

	    * 初始化代码===>回调代码

	  3. 模型的2个重要组成部分:

	    * 事件管理模块

	    * 回调队列

	  4. 模型的运转流程

	    * 执行初始化代码, 将事件回调函数交给对应模块管理

	    * 当事件发生时, 管理模块会将回调函数及其数据添加到回调列队中

	    * 只有当初始化代码执行完后(可能要一定时间), 才会遍历读取回调队列中的回调函数执行
		- 模型原理图

			-  
![image](assets/b53ad402947b3258f11dc6750722b9cb5e4a83ecfd25aef289c8e83b3bbfec2a.png)

		- 相关重要概念

		  1. 执行栈

		       execution stack

		       所有的代码都是在此空间中执行的

		   2. 浏览器内核

		       browser core

		       js引擎模块(在主线程处理)

		       其它模块(在主/分线程处理)

		   3. 任务队列(callback queue)

		       task queue

		   4. 消息队列(callback queue)

		       message queue

		   5. 事件队列(callback queue)

		       event queue

		   6. 事件轮询

		       event loop

		       从任务队列中循环取出回调函数放入执行栈中处理(一个接一个)

		   7. 事件驱动模型

		       event-driven interaction model

		   8. 请求响应模型

		       request-response model
			- 1. 执行栈

				- execution stack

				- 所有的代码都是在此空间中执行的

			- 2. 浏览器内核

				- browser core

				- js引擎模块(在主线程处理)

				- 其它模块(在主/分线程处理)

			- 3. 任务队列

				- task queue

			- 4. 消息队列

				- message queue

			- 5. 事件队列

				- event queue

			- 6. 事件轮询

				- event loop

				- 从任务队列中循环取出回调函数放入执行栈中处理(一个接一个)

			- 7. 事件驱动模型

				- event-driven interaction model

			- 8. 请求响应模型

				- request-response model

		- 执行流程

	- H5 Web Workers(多线程)

		- 介绍

			- Web Workers 是 HTML5 提供的一个javascript多线程解决方案

			- 我们可以将一些大计算量的代码交由web Worker运行而不冻结用户界面

			- 但是子线程完全受主线程控制，且不得操作DOM。
所以，这个新标准并没有改变JavaScript单线程的本质

		- 使用

			- 创建在分线程执行的js文件

			  var onmessage =function (event){ //不能用函数声明

			      console.log('onMessage()22');

			      var upper = event.data.toUpperCase();//通过event.data获得发送来的数据

			      postMessage( upper );//将获取到的数据发送会主线程

			  }
			- 在主线程中的js中发消息并设置回调

			  //创建一个Worker对象并向它传递将在新线程中执行的脚本的URL

			  var worker = new Worker("worker.js");  

			  //接收worker传过来的数据函数

			  worker.onmessage = function (event) {     

			      console.log(event.data);             

			  };

			  //向worker发送数据

			  worker.postMessage("hello world");    
		- 图解

			-  
![image](assets/9b8fe6697e866afa0b7b68a485c1783bdf1ee8c9b4a335bbe933403a320dc486.png)

		- 应用练习

		  编程实现斐波那契数列（Fibonacci sequence）的计算

		  F（0）=0，F（1）=1，..... F（n）=F(n-1)+F(n-2)
			- 直接在主线程

			  var fibonacci =function(n) {

			      return n <2 ? n : fibonacci(n -1) + fibonacci(n -2);

			  };

			  console.log(fibonacci(48));
			- 使用Worker在分线程

				- 主线程

				  var worker = new Worker('worker2.js');

				  worker.addEventListener('message', function (event) {

				      var timer2 = new Date().getTime();

				      console.log('结果：' + event.data, '时间:' + timer2, '用时：' + ( timer2 - timer ));

				  }, false);

				  

				  var timer = new Date().getTime();

				  console.log('开始计算: ', '时间:' + timer);

				  setTimeout(function () {

				      console.log('定时器函数在计算数列时执行了', '时间:' + new Date().getTime());

				  }, 1000);

				  

				  worker.postMessage(40);

				  console.log('我在计算数列的时候执行了', '时间:' + new Date().getTime());
				- 分线程

				  var fibonacci =function(n) {

				      return n <2 ? n : fibonacci(n -1) + fibonacci(n -2);

				  };

				  

				  var onmessage = function(event) {

				      var n = parseInt(event.data, 10);

				      postMessage(fibonacci(n));

				  };
		- 不足

		  1. 慢

		  1. 不能跨域加载JS

		  2. worker内代码不能访问DOM(更新UI)

		  3. 不是每个浏览器都支持这个新特性
### ES6+

- es6方法

	- [find方法 ](https://www.runoob.com/jsref/jsref-find.html)

		-  const hit1 = find(cache,c=>c.original===obj)

	- es6对象扩展

- class语法糖

- var let const 变量提升和初始化提升，值是否可变，是否有块级作用域

	- 变量提升、初始化提升

		- 找声明：var a
       function foo(){
         //函数里代码找声明时不看，调用时再看
         var a
         alert(a）
         a=2
       }
看代码：a=1
       foo.call()//调用了，看函数代码

			- 1.var 声明提升到函数或者作用域的顶端，
2.并初始化为undefined
3.赋值为1

	- 值是否可变

	- var 声明的"创建、初始化和赋值"过程

		- var有变量提升，有初始化提升，值可变

		- let有变量提升，没有初始化提升，值可变

		- const有变量提升，没有初始化提升，值不可变，但如果是定义对象，则属性可变

	- 暂时性死区问题说明：其实let和const是有变量提升的，但是没有初始化提升

		- var name = '林三心'

function fn () {
  console.log(name)
  let name = 'sunshin_lin'
}
fn() // Cannot access 'name' before initialization


	- 块级作用域解决问题：

		- for(var i = 0; i < 5; i++) {
  setTimeout(() => {
    console.log(i)
  })
} // 5 5 5 5 5


for(let i = 0; i < 5; i++) {
  setTimeout(() => {
    console.log(i)
  })
} // 0 1 2 3 4


			- let 声明和赋值在块级作用域
声明了n次i
![image](assets/13fba11468519d282ec847bf15dddcc3183cb3e597e1566107932afc6f3c0016.png)

				- for中let属于块级作用域的
![image](assets/1e072a89419b64c60a25c3a5c72290586a9b1650f84689e1811c5ad9949c4349.png)

	- [地址](https://www.cnblogs.com/echolun/p/10584703.html)

- Object.getOwnPropertyNames()

	- returns an array containing all the names of the own properties of the object passed as argument, including non-enumerable properties. It does not consider inherited properties.

	- Object.getOwnPropertyNames()返回一个数组，其中包含作为参数传递的对象自身属性的所有名称，包括不可枚举的属性。 它不考虑继承的属性。

### 其他概念

- js数据类型&包装对象&内置对象

	- 字符串方法

	- 数组方法

	- 对象方法

- 运算符操作

	- js位运算

		- [js中的位运算](https://segmentfault.com/a/1190000013607145)

		- [js 按位异或](https://www.cnblogs.com/yf2196717/p/14738360.html)

		- [【JS】832- 位运算符在 JS 中的妙用](https://cloud.tencent.com/developer/article/1772165?from=15425)

			- 取反

				- 例子

					- // 1 反码二进制表示为 11111111 11111111 11111111 11111110

					- // 由于第一位（符号位）是1，所以这个数是负数。JavaScript 内部采用补码形式表示负数，即需要将这个数减去 1，再去一次反，然后加上负号才能得到这个负数对应的十进制数值

					- // 1 的反码减一表示为 11111111 11111111 11111111 11111101

					- // 取反             00000000 00000000 00000000 00000010

					- // 表示为 -2

					- console.log(~1) // -2

		- [位运算符&移位运算符](https://cloud.tencent.com/developer/article/1393886?from=15425)

		- 二进制原码（true  form）

			- 原码(true form)是一种计算机中对数字的二进制定点表示方法。原码表示法在数值前面增加了一位符号位（即最高位为符号位）：正数该位为0，负数该位为1（0有两种表示：+0和-0），其余位表示数值的大小。

		- [深入理解原码，反码，补码的原理（模，同余）](https://www.cnblogs.com/zhxmdefj/p/10902322.html)
![image](assets/28e3036368c3a722e38da6184a2834c43fed2c8b5434eb1cb78d2f5782015de0.svg)

- 原型

	- [知乎文章：说说原型（prototype）、原型链和原型继承](https://zhuanlan.zhihu.com/p/35790971)

	- [廖雪峰的官方网站：原型继承](https://www.liaoxuefeng.com/wiki/1022910821149312/1023021997355072)

- 继承

- 作用域

	- es6之前

		- 两个作用域

			- 全局作用域

			- 函数内部作用域

				- 函数可以限制变量的作用域
![image](assets/84f46909ff30bf93e2d45a46828f1e8549b27772f35b6cbb71042ab4a38f55df.png)

		- 特点

			- for循环内部，对象，{}等内部是没有作用域

			- 全局范围范围内，使用var定义的变量都是全局变量

	- es6之后

		- {}内部作用域也就称为块级作用域

		- 特点

			- 使用let定义的变量只能在大括号{}内部有效

				- 比如循环内部，if内部，包括单独的{}内，是块级元素

				- [for循环内联声明，只在循环中可见，也算是块级作用域中的声明](https://blog.csdn.net/leo_franklin/article/details/112391939)
![image](assets/744cd2ff307137cd415b467504288fe82ef4394df7ed4c34ca9c04f98fce1895.png)

					- 外部声明方式：我们在外部用let声明key，也不用IIFE来创建作用域，那么结果就是key并没有自己独立的作用域
![image](assets/8f8bcd2d49e13bd46cae8759bef5ccc276b2532f82e05386212f3b8802a36b77.png)

						- 效果：
![image](assets/822f6d26fffc8a21943076d8a3c2acbb165d40be5222dae14e69143679018e08.png)

					- 内联声明：在for循环中要想let产生自己的块级作用域，需要使用内联声明。
![image](assets/d118c190ea3cde7b099cae6b9aafde45b0fa7c4813bd222017642138f892f121.png)

						- 子主题 1
![image](assets/5e546a22849a2ee531b98973c64050e1d02e52f801575c6335dc618ffcd1c7e4.png)

			- {}内部作用域也就称为块级作用域，但是对象的{}内部仍然是没有作用域的.

- 作用域链

- 执行上下文

- call / apply / bind

- 闭包

- this

	- 箭头函数this问题

		- 【理论1】

			- 箭头函数的this指向定义时外部作用域内的this指向，
普通函数的this指向调用时根据上下文取确认.

				- 所以也可以说箭头函数是没有this的

		- 【理论2】

			- 箭头函数需要记着这句话：“箭头函数中没有 this 绑定，必须通过查找作用域链来决定其值，如果箭头函数被非箭头函数包含，则 this 绑定的是最近一层非箭头函数的 this，否则，this 为 undefined”。

	- [地址](https://www.jianshu.com/p/b62ca176417a)

	- es5的this

		- this 永远指向最后调用它的那个对象。

	- 函数的所有者和调用者

		- 【理论1】

			- 1、arguments.callee 返回当前运行的函数
2、arguments.callee.length 形参
3、arguments.length 实参

4、*.caller 返回当前函数的上下文也就是函数调用者

			- 函数的所有者，也就是this代表的对象
1,一般情况 o.function( this 这里的this就是指o)
2,function.call(o)
apply(o) 让o去调用function 所有o也就是所有者

			- 【例子】

				- function test(){
   alert(arguments.callee.length)// 0
   alert(arguments.length) //1
   alert(arguments.callee);// 就是这个函数
   alert(test.caller); // a
}
function a(){
   test("sss");
}
a();

		- 【理论2】

			- 函数的调用者指的是【函数被调用的域（可以理解函数本身）】，Function 对象的caller属性是对当前函数的函数的引用。如果该函数是从JavaScript程序的顶层调用的，caller的值为null。
函数的所有者指的是【调用这个函数的对象】。 

			- [【例子】](https://blog.csdn.net/zsc2014030403015/article/details/53862529)

	- 函数调用的方法一共有 4 种

		- 作为一个函数调用

			- 这样一个最简单的函数，不属于任何一个对象，就是一个函数，这样的情况在 JavaScript 的在浏览器中的非严格模式默认是属于全局对象 window 的，在严格模式，就是 undefined。 
但这是一个全局的函数，很容易产生命名冲突，所以不建议这样使用。

		- 函数作为方法调用

			- 更多的情况是将函数作为对象的方法使用，我们一直记住的那句话“this 永远指向最后调用它的那个对象”，所以在 fn 中的 this 就是指向 a 的。

		- 使用构造函数调用函数

			- 如果函数调用前使用了 new 关键字, 则是调用了构造函数。
这看起来就像创建了新的函数，但实际上 JavaScript 函数是重新创建的对象

			- new的过程

				- 1.创建一个空对象 obj;
2.将新创建的空对象的隐式原型指向其构造函数的显示原型。
3.使用 call 改变 this 的指向
4.如果无返回值或者返回一个非对象值，则将 obj 返回作为新对象；如果返回值是一个新对象的话那么直接直接返回该对象。

		- 作为函数方法调用函数（call、apply）

			- 在 JavaScript 中, 函数是对象。

			- JavaScript 函数有它的属性和方法。call() 和 apply() 是预定义的函数方法。 两个方法可用于调用函数，两个方法的第一个参数必须是对象本身

			- 在 JavaScript 严格模式(strict mode)下, 在调用函数时第一个参数会成为 this 的值， 即使该参数不是一个对象。在 JavaScript 非严格模式(non-strict mode)下, 如果第一个参数的值是 null 或 undefined, 它将使用全局对象替代。

		- 总结

			- 1.这个简单一点的理解可以理解为“匿名函数的 this 永远指向 window”，

			- 2.你可以这样想，还是那句话this 永远指向最后调用它的那个对象，那么我们就来找最后调用匿名函数的对象，这就很尴尬了，因为匿名函数名字啊，笑哭，所以我们是没有办法被其他对象调用匿名函数的。

			- 3.所以说 匿名函数的 this 永远指向 window。

			- 4.如果这个时候你要问，那匿名函数都是怎么定义的，首先，我们通常写的匿名函数都是自执行的，就是在匿名函数后面加 () 让其自执行。

			- 5.其次就是虽然匿名函数不能被其他对象调用，但是可以被其他函数调用啊，比如例 7 中的 setTimeout。

- 立即执行函数表达式

- new

- 深浅拷贝

- 浏览器的多线程和js引擎的单线程

- 正则

	- [一个讲得挺好的正则-掘金文章](https://juejin.cn/post/6999768570570178596?utm_source=gold_browser_extension)

	- [正则讲得很好的官网地址](http://www.regexlab.com/zh/regref.htm)

	- [另外一个正则讲得可以的地方](https://www.jb51.net/article/110516.htm)

- 文件同步异步加载

- 前端界面优化，大量数据，列表展示时，采用无尽滚动。

	- [地址1](https://www.cnblogs.com/wwhhq/p/8169029.html)

		- 无限滚动就是一般常见的触底加载，滚动到页面底部加载更多数据，但是当数据量上来之后，达到千万数量级别，浏览器没法承载这么多的节点渲染，肯定会卡顿甚至崩溃，这个时候就可以使用虚拟列表，通过计算滚动视窗，每次只渲染可见屏幕部分节点，超出屏幕的不可见范围用内填充 padding 代替，对于浏览器来说无论你滚动到什么位置，渲染的都是屏幕范围内的节点，这样就不会有性能负担了。

	- [实现方式地址2](https://www.jianshu.com/p/20faf7007860)

	- [不要使用无限滚动](https://zhuanlan.zhihu.com/p/82817958)

- 无尽滚动

	- [原理解释文档地址](https://juejin.cn/post/6844903463629881351)

	- [github-demo地址](https://github.com/GoogleChromeLabs/ui-element-samples/tree/gh-pages/infinite-scroller)

	- [貌似无尽滚动官方地址](https://developers.google.com/web/updates/2016/07/infinite-scroller)

	- 图示：可以展示出无尽滚动的原理到底是啥样子的
![image](assets/be31cfff50147fab569ab7a15b4b1010daad46c0942b539fd24a4690f6f40e1a.gif)

- 下载实现方式

  前端接受后端文件流并下载的几种方法: https://www.jianshu.com/p/8ef2c7b8b46c 前端js下载后端文件的两种方式总结: https://blog.csdn.net/u013944583/article/details/106856175/ 
  
  https://www.cnblogs.com/lalalagq/p/10250640.html
  
	- window.open(url)/window.location.href=url（后台提供静态目录和文件路径，get请求）

	- 创建a标签 href=url download=filename a.click()（返回文件流response-type: application/octet-stream;charset=UTF-8 ）

	- 上述对比第一种方式，通过 onprogress 捕获下载进度（界面通过显示进度条来提升体验）；通过 readystatechange 监听下载完后并可以做其它的事情；

- 防抖和节流

	- 防抖：用户触发事件过于频繁，只要最后一次事件的操作

		- 错误姿势

			- // 貌似只做到了500ms之后做事情，操作事件次数并没有减少
let last;
    $scope.doFilter = function(e){
        last = e.timeStamp;
        setTimeout(function () {
            if(last - e.timeStamp == 0){
                refresh();
            }
        }, 500)
    };

		- 正确姿势

			- let lastTimer = null;
    $scope.doFilter = function () {
        if (lastTimer !== null) {
            clearTimeout(lastTimer);
        }
        lastTimer = setTimeout(function () {
            refresh();
        }, 500);
    };

			- // 自定义防抖函数
// 算法思路：500ms后执行一次事件回调，500ms以内重复调用，都是覆盖了上一次的调用（重置了）。停止覆盖，之后500ms后，才有机会执行一次回调
    function myDebounce(fn, delay) {
        let t = null;
        return function () {
            if (t !== null) {
                clearTimeout(t);
            }
            t = setTimeout(() => {
                fn.call(this);
            }, delay);
        };
    }
    $scope.doFilter = myDebounce(function () {
        refresh();
    }, 500);

			- 【正确理解】：

				- 个人理解 函数防抖就是法师发技能的时候要读条，技能读条没完再按技能就会重新读条。

				- 规定时间内，会打断上一次的计时执行，重新计时，然后执行一次

	- 节流：控制执行次数，针对比较耗性能的操作
防抖：只执行最后一次

		- // 自定义节流
// 算法思路：500ms执行一次事件回调，500ms之内的调用，直接过滤了，或者说都进不来。控制频率
    function myThrottle(fn, delay) {
        let flag = true;
        return function () {
            if (flag) {
                setTimeout(() => {
                    fn.call(this);
                    flag = true;
                }, 500);
            }
            flag = false;
        };
    }
    window.onscroll = myThrottle(function () {
        console.log('事件触发了！');
    }, 500);

		- 【正确理解】

			- 个人理解 函数节流就是fps游戏的射速，就算一直按着鼠标射击，也只会在规定射速内射出子弹。

			- 规定时间内，无法进入计时，规定时间之外，才能重新进入计时

	- 另外一种实现方式

		- [地址](https://juejin.cn/post/6844903669389885453#heading-3)

	- 参考链接：

		- [防抖和节流有什么区别，分别用于什么场景](https://juejin.cn/post/7103332413077454855)

			- 防抖

				- 在指定时间内，重复操作都会防止上一次，指定时间之外，才会执行最后一次

					- function debounce(fn, delay = 200) {
  let timer = 0
  return function() {
    // 如果这个函数已经被触发了
    if(timer){
      clearTimeout(timer)
    }
    timer = setTimeout(() => {
      fn.apply(this, arguments); // 透传 this和参数
      timer = 0
    },delay)
  }
}


			- 节流

				- 但是我是需要在过程中进行触发回调，但是又不需要那么的频繁；这时候就使用节流函数，每隔一定的时间进项触发就好了！

					- // 节流函数
function throttle(fn, delay = 200) {
  let  timer = 0
  return function () {
    if(timer){
      return
    }
    timer.setTimeout(() =>{
      fn.apply(this, arguments); // 透传 this和参数
      timer = 0
    },delay)
  }
}


			- 区别

				-  
![image](assets/516b5565a848df7f146a19392d2ae213c162ff2c16b1e377003eb8eb7eda8f14.png)

- 通配符转正则字符串

- mockjs和http-mock-middleware

  动态后端代理 在前端开发阶段，有 mock 数据支持就够了，在前后端联调过程中，后端服务器的数据更真实，mock 数据反而不那么重要了。因此在必要的时候将数据代理到后端服务器就显得很有必要了。 http-mock-middleware 主要通过 X-Mock-Proxy 头来判断是否需要代理，下面使用 axios 库演示如何使用 localStorage 控制动态代理： const axios = require("axios"); axios.interceptors.request.use(function(config){ if(process.env.NODE_ENV === "development") { let mockHeader = localStorage.proxyUrl; if(mockHeader) { config.headers = config.headers || {}; config.headers["X-Mock-Proxy"] = mockHeader; } } // other code return config; }); 使用上面的代码，开发时不设置 localStorage.proxyUrl 使用假数据，联调时设置 localStorage.proxyUrl 指向后端服务器使用真数据。 注意：X-Mock-Proxy 的值是一个 url, 因为 http-mock-middleware 无法确定你的服务器是不是 https。通常你需要只设置为 http://host:port/ 就可以了 ￼ 这里的代码没有生效...并没有更新 .data里面的json文件啊, 这里的代码有在本地跑假数据的时候用到了. ￼ 是因为如下的代码: 因为http和https的问题, 这里不管加不加代理,不管是不是远程办公还是公司办公,都走的下面的代码,远程办公的话,会加上下面的agent配置 ￼ 这里的代码,target拼了一个https上去 secure:false取消掉了证书提醒的问题 ￼ 解读这里的代码:如下方 ￼ 翻译中的继承关系 ￼ 
  
- 游离 HEAD所对应的单独处理

  
      ￼
  
  
      ￼
  
  此时游离HEAD的时候,分支名获取的是一个commitid
  
      ￼
  
  
- 手写mock数据代码

  mock //billStatistics mock am.api.billStatistics.exec = function(data,cb){ setTimeout(function(){ cb({ "code": -1, "message": "success", "ts": 1473156708276, "content": { "customerSummary":{//客数汇总 "maleCount": 0, "femaleCount": 0, "specifiedCount": 0, "unspecifiedCount": 0, "specifiedMaleCount": 0, "unspecifiedMaleCount": 0, "specifiedFemaleCount": 0, "unspecifiedFemaleCount": 0, }, "perfSummary":{//业绩汇总 "servicePerf": 0.0, "productPerf": 0.0, "newCardPerf": 0.0, "rechargePerf": 0.0, "comboCardPerf": 0.0, "annualCardPerf": 0.0 }, "categorySummary":[//分项业绩汇总 { "serviceMajorCategoryName": "洗剪吹", "serviceMajorCategoryPerf": 0.0 }, { "serviceMajorCategoryName": "烫染焗", "serviceMajorCategoryPerf": 0.0 } ], "incomeSummary":{//收入汇总 "cash": 0.0,//现金 "pos": 0.0,//银联 "memCardPay": 0.0,//储值卡——会员卡 "memCardPresentPay":0.0,//储值卡赠送金支付 "comboCardPay": 0.0,//疗程卡 "comboCardPresentPay":0.0,//疗程卡赠送支付 "otherBillingPay": 0.0//其他支付 } } }) }) } 
  
- await async axios

	- async 标记当前函数是异步函数，内部支持 await 等待异步执行。返回值是 Promise 实例。

	- 所以你这样封装之后，外面使用封装后的函数时仍然需要 async/await。这样做有没有意义要看你怎么封装。一般来说，封装要发挥作用，至少要处理常见错误、提取真实数据，等。类似问题中这样不封装也罢。

- [二进制文件上传](https://cloud.tencent.com/developer/article/1684142?from=information.detail.js%E4%BA%8C%E8%BF%9B%E5%88%B6%E6%96%87%E4%BB%B6%E4%B8%8A%E4%BC%A0)

  ￼
  
	- 图片处理相关

	  /**
	   * 媒体流转base64数据
	   * @param {stream} videoStream 媒体流
	   * @returns base64编码
	   */
	  export const canvasToDataURL = (videoStream) => {
	    if (typeof videoStream !== "object") return "";
	    // 创建画布
	    let canvas = document.createElement("canvas");
	    canvas.width = videoStream.videoWidth;
	    canvas.height = videoStream.videoHeight;
	    // 画布绘制
	    var ctx = canvas.getContext("2d");
	    ctx.drawImage(videoStream, 0, 0, canvas.width, canvas.height);
	    // 绘制信息
	    var linearGradient = ctx.createLinearGradient(0, 0, 300, 0);
	    linearGradient.addColorStop("0", "#40E0D0");
	    linearGradient.addColorStop("0.5", "#FF8C00");
	    linearGradient.addColorStop("1.0", "#f7797d");
	    ctx.font = "35px FZShuTi";
	    ctx.fillStyle = linearGradient;
	    ctx.fillText("Face-Api 简单使用", 20, 50);
	    return canvas.toDataURL();
	  };
	  
	  /**
	   * base64字符串转二进制文件
	   * @param {String} base64Date base64字符串
	   * @returns Blob文件对象
	   */
	  export const base64ToBlob = (base64Date) => {
	    let byteString = atob(base64Date.split(",")[1]);
	    let mimeString = base64Date.split(",")[0].split(":")[1].split(";")[0];
	    let ab = new ArrayBuffer(byteString.length);
	    let ia = new Uint8Array(ab);
	    for (let i = 0; i < byteString.length; i++) {
	      ia[i] = byteString.charCodeAt(i);
	    }
	    return new Blob([ab], {
	      type: mimeString,
	    });
	  };
	  
	  /**
	   * 图片文件转base64
	   * @param {Object} img 图片
	   * @param {function} callback 回调函数
	   */
	  export const fileToBase64 = (img, callback) => {
	    const reader = new FileReader();
	    reader.addEventListener("load", () => callback(reader.result));
	    reader.readAsDataURL(img);
	  };
	  
	  /**
	   * 保存base64字符串到文件下载 通过构建a链接方式
	   * @param {String} data Base64字符串
	   * @param {String} fileName 保存文件名
	   */
	  export const saveBase64ToFileObjectURL = (data, fileName) => {
	    // 创建隐藏的可下载链接
	    let eleLink = document.createElement("a");
	    eleLink.download = fileName;
	    eleLink.style.display = "none";
	    eleLink.href = URL.createObjectURL(base64ToBlob(data));
	    // 触发点击
	    document.body.appendChild(eleLink);
	    eleLink.click();
	    // 然后移除
	    document.body.removeChild(eleLink);
	  };
	  
		- 方法和案例

			- [区分 window.URL.createObjectURL() 和 FileReader.readAsDataURL()](https://blog.csdn.net/huoren_no1/article/details/108335827)

			- [Blob、File、FileReader 和 Data URL](https://blog.csdn.net/huangpb123/article/details/104178336?utm_medium=distribute.pc_relevant.none-task-blog-title-5&spm=1001.2101.3001.4242)

			- [上传图片 将图片转成二进制传递给后台](https://blog.csdn.net/qq_33771698/article/details/104041017)

			- [vue图片转换为二进制模拟表单传给后台](https://blog.csdn.net/lyc2786161648/article/details/84285146?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-2.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-2.control)

			- data:text/html;charset=utf-8;charset=gbk,您好

				- 你好

			- data:text/html;charset=utf-8;base64,5L2g5aW9

				- 你好

			- 图片上传和显示

				- 只知道url地址，如何读取图片，然后，canvas转为base64，然后转为file对象

					- [
function getImgToBase64(url,callback){//将图片转换为Base64
  var canvas = document.createElement('canvas'),
    ctx = canvas.getContext('2d'),
    img = new Image;
  img.crossOrigin = 'Anonymous';
  img.onload = function(){
    canvas.height = img.height;
    canvas.width = img.width;
    ctx.drawImage(img,0,0);
    var dataURL = canvas.toDataURL('image/png');
    callback(dataURL);
    canvas = null;
  };
  img.src = url;
](https://blog.csdn.net/namechenfl/article/details/94737383)

				- url地址转base64图片

					- 知道url地址
用img读取img数据，然后用canvas.toDataURL转为dataURL

						-     function dataURLtoFile(dataurl, filename) {//将base64转换为文件
        var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
            bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
        while(n--){
            u8arr[n] = bstr.charCodeAt(n);
        }
        return new File([u8arr], filename, {type:mime});
    }

						- getImgToBase64('img/test.png',function(data){
　　　var myFile = dataURLtoFile(data,'testimgtestimgtestimg');
　　　console.log(myFile);
});

			- 发送二进制文件到后端

				- FormData 对象的使用：
1.用一些键值对来模拟一系列表单控件：即把form中所有表单元素的name与value组装成
一个queryString
2. 异步上传二进制文件。

				-   var formData = new FormData();
    // 将文件转二进制
    *****注意2******
    formData.append('upload', file.files[0]);

		- 编码

	- 文件上传方式

	- 概念和方法

		- [几种常见编码总结](https://blog.csdn.net/liluo_2951121599/article/details/81661630?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control)

		- 概念

			- ArrayBuffer

			- [chartAt/charCodeAt/fromCharCode](https://www.runoob.com/jsref/jsref-charcodeat.html)

			- window.createObjectURL

			- canvas.drawImage

			- new File()

			- new Blob()

			- new FileReader

				- [fileReader.readAsDataURL](https://blog.csdn.net/qq_33771698/article/details/104041017)

			- new Image()

			- Uint8Array

			- atob,btoa

			- canvas.toDataURL

			- [dataurl](https://www.cnblogs.com/tianma3798/p/13582175.html)

			  https://www.cnblogs.com/tianma3798/p/13582105.html 
			  
			  
			  Data URL格式
			  
			  Data URI 的格式
			  
			  data:[<mime type>][;charset=<charset>][;base64],<encoded data>
			  
			  第一部分是 data: 协议头，它标识这个内容为一个 data URI 资源。
			  
			  
			  第二部分是 MIME 类型，表示这串内容的展现方式，比如：text/plain，则以文本类型展示，image/jpeg，以 jpeg 图片形式展示，同样，客户端也会以这个 MIME 类型来解析数据。
			  
			  
			  第三部分是编码设置，默认编码是 charset=US-ASCII, 即数据部分的每个字符都会自动编码为 %xx，关于编码的测试，可以在浏览器地址框输入分别输入下面两串内容，查看效果：
			  
			  ￼
			  // output: ä½ å¥½ -> 使用默认的编码展示，故乱码
			  data:text/html,你好  
			  // output: 你好 -> 使用 UTF-8 展示
			  data:text/html;charset=UTF-8,你好 
			  // output: 浣犲ソ -> 使用 gbk 展示（浏览器默认编码 UTF-8，故乱码）
			  data:text/html;charset=gbk,你好 
			  // output: 你好 -> UTF-8 编码，内容先使用 base64 解码，然后展示
			  data:text/html;charset=UTF-8;base64,5L2g5aW9 
			  ￼
			  
			  第四部分是 base64 编码设定，这是一个可选项，base64 编码中仅包含 0-9,a-z,A-Z,+,/,=，其中 = 是用来编码补白的。
			  
			  
			  最后一部分为这个 Data URI 承载的内容，它可以是纯文本编写的内容，也可以是经过 base64编码 的内容。
			  
			  
			  很多时候我们使用 data URI 来呈现一些较长的内容，如一串二进制数据编码、图片等，采用 base64 编码可以让内容变得更加简短。而对图片来说，在 gzip 压缩之后，base64 图片实际上比原图 gzip 压缩要大，体积增加大约为三分之一，所以使用的时候需要权衡。
			  
			  
			  参考: http://www.cnblogs.com/hustskyking/p/data-uri.html
			  
			  
			     /**
			       * base64  to blob二进制
			       */
			      function dataURItoBlob(dataURI) {
			          var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]; // mime类型
			          var byteString = atob(dataURI.split(',')[1]); //base64 解码
			          var arrayBuffer = new ArrayBuffer(byteString.length); //创建缓冲数组
			          var intArray = new Uint8Array(arrayBuffer); //创建视图
			  
			          for (var i = 0; i < byteString.length; i++) {
			              intArray[i] = byteString.charCodeAt(i);
			          }
			          return new Blob([intArray], {type: mimeString});
			      }
			  
			      /**
			       * 
			       * blob二进制 to base64
			       **/
			      function blobToDataURI(blob, callback) {
			          var reader = new FileReader();
			          reader.onload = function (e) {
			              callback(e.target.result);
			          }
			          reader.readAsDataURL(blob);
			      }
			  
			  
			  
				- [JS 实现blob与base64互转](https://www.cnblogs.com/dcb3688/p/4608062.html)

- js 二进制数组

	- [推荐阅读地址](https://blog.csdn.net/qq_38128179/article/details/106012003)

	- 概念理解

		- ArrayBuffer
TypedArray
![image](assets/6155d4d5b287d41a73bd06585342c4f85821c3219adf705c16ec0c1ab6c0d544.png)

		- 这种数据类型占据的字节数
![image](assets/2b129094cb0c7bb18482a4d6bc943caa8efaa540550272d4252b34c157c69c9e.png)

	- ArrayBuffer和blob

		-  
![image](assets/dcb5d835b70815438e0257b7363e8ab52562131732af301def3ddced0986c3a5.png)

- 密码相关的代码

	- crypto.subtle

		- [地址](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/importKey)

		- 代码

		  /**
		   * 字符串加密
		   * 此处鸣谢张垚、王川
		   */
		  function encryptStr (str) {
		      str = encodeURI(str);
		      const strBuf = new Uint8Array(str.split("").map(x => x.charCodeAt(0)));
		      const ivBuf = new Uint8Array(16);
		      crypto.getRandomValues(ivBuf);
		      const algorithm = { name: 'AES-CBC', iv: ivBuf };
		      const key = new Uint8Array([168, 134, 114, 247, 83, 133, 77, 235, 174, 252, 207, 35, 241, 57, 67, 74, 148, 231, 218, 186, 6, 174, 120, 211, 227, 93, 38, 253, 81, 157, 158, 197]);
		      return crypto.subtle.importKey('raw', key, algorithm, false, ['encrypt']).then(function (cryptoKey) {
		          return crypto.subtle.encrypt(algorithm, cryptoKey, strBuf);
		      }).then(function (encrypted) {
		          return { iv: u82hex(ivBuf), str: u82hex(new Uint8Array(encrypted)) };
		      });
		  }
		  function u82hex (u8) {
		      return Array.from(u8).map(a => (a < 16 ? '0' : '') + a.toString(16)).join("");
		  }
		  function encryptData (data) {
		      /*
		      let src = JSON.parse(JSON.stringify(data));
		      let keys = Object.keys(src);
		      let promises = [];
		      keys.forEach(key => {
		          promises.push(encryptStr(src[key]));
		      });
		      return Promise.all(promises).then((arr) => {
		          arr.forEach((val, i) => {
		              src[keys[i]] = val;
		          })
		          return src;
		      });
		      */
		  
		      return encryptStr(JSON.stringify(data));
		  }
		  
		  module.exports = {
		      encryptStr,
		      encryptData
		  };
		  
		  
	- AES五种加密模式（CBC、ECB、CTR、OCF、CFB）

		- [地址](https://www.cnblogs.com/starwolf/p/3365834.html)

- window.location.hostname与 window.location.host 区别

	- /**
 * window.location.hostname  不带端口号
 * window.location.host 带
 */

- 简单拖拽

	- vue dom部分

	  <div class="drag-list">
	        <div
	          class="drag-item"
	          v-for="(item, index) in list"
	          :key="index"
	          :class="{
	            'drag-start-item': dragId === item.id,
	            'drag-enter-item': dragEnterId === item.id,
	          }"
	          draggable="true"
	          @drag="onDrag"
	          @dragstart="onDragstart($event, item)"
	          @dragend="onDragend"
	          @dragover="onDragover"
	          @dragenter="onDragenter($event, item)"
	          @dragleave="onDragleave"
	          @drop="onDrop"
	        >
	          <div class="drag-item-content">
	            <div class="item-icon"><img :src='item.img'></div>
	             <div class="item-name">{{ item.title }}</div>
	          </div>
	        </div>
	      </div>
	  
	  
	  
	- vue js逻辑部分

	  onDrag (event) {},
	      onDragstart (event, item) {
	        this.dragId = item.id
	        this.dragEnterId = null
	      },
	      onDragend (event) {
	        this.dragId = null
	        this.dragEnterId = null
	      },
	      onDragover (event) {
	        event.preventDefault()
	      },
	      onDragenter (event, item) {
	        this.dragEnterId = item.id
	      },
	      onDragleave (event) {},
	      onDrop (event) {
	        event.preventDefault()
	  
	        let drag = null
	        let dragIndex = null
	        let targetIndex = null
	  
	        this.list.forEach((item, index) => {
	          if (item.id === this.dragId) {
	            drag = item
	            dragIndex = index
	          }
	          if (item.id === this.dragEnterId) {
	            targetIndex = index
	          }
	        })
	        if (dragIndex === targetIndex) {
	          console.warn('起始与结束相同.')
	          return
	        }
	  
	        // 放下的位置大于等于目标宽带一半, 放到目标后面
	        // 否则放到目标前面
	        if (event.offsetX >= event.target.getBoundingClientRect().width / 2) {
	          targetIndex++
	        }
	  
	        // 先从原数组移除拖拽项
	        this.list.splice(dragIndex, 1)
	  
	        // 如果拖拽项原本处于目标项左侧, 移除拖拽项会出目标位置造成影响
	        if (dragIndex < targetIndex) {
	          targetIndex--
	        }
	  
	        // 把拖拽项插入到新位置
	        this.list.splice(targetIndex, 0, drag)
	      },
	  
	  
	  
	- 理解

		- 原生拖拽实现：拖着目标元素在页面任意位置

			-  
![image](assets/3f23686d57970a7b7b70b06438e4a63484b18bb12518ff1484ff9e72f82fb34e.png)

		- HTML5元素拖拽drag与拖放drop

			-  
![image](assets/d474edb8f970ee1ebb27d34ea110c3a810023a9472e939b1068d7660d81967d9.png)

			-  
![image](assets/99e077b61c5422abcd8bf670e2ed44e703cadb421d71c9bf60a8c176d990c19b.png)

			-  
![image](assets/cd97533dc4b7435e84a65ea02c90f2a35f099dadae860cd06897024aff297472.png)

			-  
![image](assets/d78371fba3476d250e63add1837564166d3f531551f2419060ec4b9911904c4d.png)

			-  
![image](assets/c27a68ee2f9a568da3d3b930db33e4195f6466890ff44c94d5a9a02af5f206f8.png)

			-  
![image](assets/9327a93bacc956e203c628a0852b31979e48b3edd7b17169f963a565ea146e73.png)

			-  
![image](assets/d6242ea6222768e8635d84452c420b6deca6b6ef5ee37b3a40fecc858b044e91.png)

		- javascript中的offsetWidth、clientWidth、innerWidth及相关属性方法

			-  
![image](assets/791de0feda1fd9016a98cd82a7bc18363fe3d6b05d215d46008cf9e182b18281.png)

	- [地址](https://blog.csdn.net/weixin_41910848/article/details/82218243)

- angularjs和vue对比

	-  
![image](assets/e2ebca0d2fbf27612c09e0a35045d6a0792a4b8c97ef98e983ac1001b2118be2.png)

- 如何判断是否为日期

	- function isDate(str) {
    var reg = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;
    if (!reg.test(str)) return false
    var r = str.match(reg);
    var d = new Date(r[1], r[2]-1, r[3])
    return d.getFullYear() == r[1] && d.getMonth() == r[2] -1 && d.getDate() == r[3]
}
console.log(isDate("2022-10-01"))

- V8 JS 代码的运行流程
![image](assets/23117f1b6085f592c2aefb4e56ec4ff9a9ee89a7ff0dce8252cce87c7c5bd9c2.png)

### promise

- Promise.resolve等价于下面的写法

- 有时需要将现有对象转为 Promise 对象，Promise.resolve方法就起到这个作用。

- Promise.resolve('foo')

- // 等价于

- new Promise(resolve => resolve('foo'))

- [文章：JavaScript 中如何实现并发控制？](https://mp.weixin.qq.com/s?__biz=MzI2MjcxNTQ0Nw==&mid=2247490704&idx=1&sn=18976b9c9fe2456172c394f1d9cae88b&scene=21#wechat_redirect)

- promise的多次调用

	- then 方法可以被同一个 promise 调用多次

	- 当 promise 成功执行时，所有 onFulfilled 需按照其注册顺序依次回调

	- 当 promise 被拒绝执行时，所有的 onRejected 需按照其注册顺序依次回调

- promise的返回

	- then 方法必须返回一个 promise 对象 注3

	- promise2 = promise1.then(onFulfilled, onRejected);

	- 如果 onFulfilled 或者 onRejected 返回一个值 x ，则运行下面的 Promise 解决过程：[[Resolve]](promise2, x)

	- 如果 onFulfilled 或者 onRejected 抛出一个异常 e ，则 promise2 必须拒绝执行，并返回拒因 e

	- 如果 onFulfilled 不是函数且 promise1 成功执行， promise2 必须成功执行并返回相同的值

	- 如果 onRejected 不是函数且 promise1 拒绝执行， promise2 必须拒绝执行并返回相同的据因

	- 译者注： 理解上面的“返回”部分非常重要，即：不论 promise1 被 reject 还是被 resolve 时 promise2 都会被 resolve，只有出现异常时才会被 rejected。

- promise的解决过程

	- Promise 解决过程 是一个抽象的操作，其需输入一个 promise 和一个值，我们表示为 [[Resolve]](promise, x)，如果 x 有 then 方法且看上去像一个 Promise ，解决程序即尝试使 promise 接受 x 的状态；否则其用 x 的值来执行 promise 。

	- 这种 thenable 的特性使得 Promise 的实现更具有通用性：只要其暴露出一个遵循 Promise/A+ 协议的 then 方法即可；这同时也使遵循 Promise/A+ 规范的实现可以与那些不太规范但可用的实现能良好共存。

	- 运行 [[Resolve]](promise, x) 需遵循以下步骤：

		- 2.3.1 x 与 promise 相等

			- 如果 promise 和 x 指向同一对象，以 TypeError 为据因拒绝执行 promise

		- 2.3.2 x 为 Promise

			- 如果 x 为 Promise ，则使 promise 接受 x 的状态:注4

			- 如果 x 处于等待态， promise 需保持为等待态直至 x 被执行或拒绝

			- 如果 x 处于执行态，用相同的值执行 promise

			- 如果 x 处于拒绝态，用相同的据因拒绝 promise

		- 2.3.3 x 为对象或函数

			- 如果 x 为对象或者函数：

			- 把 x.then 赋值给 then注5

			- 如果取 x.then 的值时抛出错误 e ，则以 e 为据因拒绝 promise

			- 如果then是函数，将x作为函数的作用域this调用之。传递两个回调函数作为参数，第一个参数叫做resolvePromise，第二个参数叫做rejectPromise:

			- 如果 resolvePromise 以值 y 为参数被调用，则运行 [[Resolve]](promise, y)

			- 如果 rejectPromise 以据因 r 为参数被调用，则以据因 r 拒绝 promise

			- 如果 resolvePromise 和 rejectPromise 均被调用，或者被同一参数调用了多次，则优先采用首次调用并忽略剩下的调用

			- 如果调用then方法抛出了异常e：

			- 如果 resolvePromise 或 rejectPromise 已经被调用，则忽略之

			- 否则以 e 为据因拒绝 promise

			- 如果 then 不是函数，以 x 为参数执行 promise

		- 2.3.4 x 不为对象或函数

			- 如果 x 不为对象或者函数，以 x 为参数执行 promise

				- If x is not an object or function, fulfill promise with x.

				- 执行promise 意思： fulfill promise

			- 如果一个 promise 被一个循环的 thenable 链中的对象解决，而 [[Resolve]](promise, thenable) 的递归性质又使得其被再次调用，根据上述的算法将会陷入无限递归之中。算法虽不强制要求，但也鼓励施者检测这样的递归是否存在，若检测到存在则以一个可识别的 TypeError 为据因来拒绝 promise。注6

- 【示例】

	- onRejected 不是函数并且p1是rejected，p2就是rejected
![image](assets/41be88016beecd0230bea4f9ec152060504b8be25489e4faefd67c8586e106e7.png)

## flex

### [官网地址](https://www.w3.org/TR/css-flexbox-1/)

### flex布局Flexible布局，弹性布局
![image](assets/81b2f6527e42ef40564440eeec27e4f1eaea9c7014da48dd245d7e1e1c205fb3.png)

- flex:flex container 以block-level形式存在
inline-flex:flex-container以inline-level形式存在

### flex container上的属性
![image](assets/62a484c887f5a098fcbc904a53ce1ca580e24d5149a2d23a6df9d83063b8ffa5.png)

- flex items 默认都是沿着main axis主轴从main start 开始往 main end方向排布

	- main axis

	- main start

	- main end

- 模型
![image](assets/c4551cb6632573997d223ce24e8e563b0299219a846f0498a6360238dea7c966.png)

- flex-direction

	- 决定了items在主轴的排列顺序，从哪个方向开始排

		- 从哪个方向，什么顺序排列

	- row(默认)

		- main-start在左，mian-end在右

	- row-reverse

		- main-start在右，mian-end在左

		- reverse是reverse了主轴的方向

	- column

	- column-reverse

	- 图示
![image](assets/f6dc2cd3b2ed873c9092c394adb41f8ad6d6b9890e3fe53f0443974ce7c9748f.png)

- justify-content

	- 决定了items在主轴上的对齐方式

		- 空隙如何放置

	- flex-start（默认）

	- flex-end

	- space-between

	- space-around

	- space-evenly

	- 图示
![image](assets/48ec4060423727ca7dcf12842e99f8938ce119a8d57f6b8b5019e4e254fa614f.png)

- align-items：单行，交叉轴

	- cross axis 永远跟main axis 垂直，要么向下，要么向右

	- 决定了items在交叉轴cross axis上的对齐方式

	- stretch（默认）

		- 当flex items 在cross axis方向的size为auto时，自动拉伸至填充flex container

	- flex-start

	- flex-end

	- center

	- baseline

	- 图示，size要么是高，要么是宽
![image](assets/2809652cab325c86e8f5b8690d914abd052081e66286ebdd54f174911d38bfbc.png)

		- 例子，交叉轴方向的size是高度
![image](assets/ccab5c3bfa6a339f9921c763af9674c9b6886a420493490ef9da82018ec4b456.png)

			- 现象
![image](assets/6de3547f821e9d0b4ae03396b17db320dce4309d16f2c949155231ebd58556c1.png)

		- 例子,交叉轴方向的size是宽度
![image](assets/aafe81e26cf70156dbf614151ce6edc3f8325b8ee48346f3fbec7ba28218ea95.png)

			- 现象
![image](assets/8aaea34eabb69bc18c62757cb01fab17cc16ec7e8bd133c461db00929a05a284.png)

- flex-wrap

	- flex-wrap决定了flex container是单行还是多行

	- nowrap

		- 例子中，flex container总长度是500px
每个flex item长度设置为100px，
现在把flex item的个数从原来的4个变成现在的7个，flex-wrap:nowrap保持不变，看效果

			- 现象：自动收缩，平分宽度
![image](assets/4250f53fd6cd8df5e8a4f5de6d3125c1a845395331d5e30d459e29a2761d66be.png)

				- 不想这个效果，该如何办？存疑！！！

	- wrap

		- 现象
![image](assets/f89cdc2ab4bf3e4564f038930ebda08612d8eaaeb46ef5b6082c3e3948f9f0c1.png)

			- 朝着交叉轴的方向换行的，从上往下换行
![image](assets/de3865570a9cfe0b08ca8990dff677edefb8bccd50b4f40145c3e3d4128a96b3.png)

	- wrap-reverse

		- 现象
![image](assets/9e3819e3a920c58fbee5b0701d72dfbdc846d86a9e8d23d36e4e6a03300cd6d4.png)

		- 跟交叉轴方向，相反

	- 图示
![image](assets/e28469d3bf24de4f6eba273451ab3586c1e9c4464d32ac4e35b7258dc7ffd4f3.png)

- flex-flow

	- 是flex-direction和flex-wrap的简写

	- 图示
![image](assets/74a404ca013a2537fcb5fcfbf7909c91182109b50ef6d35bf0dbfa1e9927e8c7.png)

- align-content：多行，交叉轴
跟flex-wrap:wrap配合使用

	- 决定了多行flex items在cross axis上的对齐方式

	- stretch（默认）

		- 拉伸，验证交叉的size拉伸

			- 例子：交叉轴是从上到下，高度
![image](assets/fa73de5e7ffa21925066eae2e82c9212e5a8d6c691ded08947f2f9590a5c5b41.png)

				- 现象
![image](assets/d9b6a94bb4eefbe2321ce5cba658faf189a8bc64eb2d959e0e5526fa37e8248b.png)

	- flex-start

		- 例子
![image](assets/aa73fea582eef6b244e86a4ed9dbf78b8b978b8578eace9031baa605756e6e0a.png)

			- 现象：沿着cross start对齐，尽量挨着cross start
![image](assets/15ad36a2fb7f0d01d8f82e756cd04f4c05a1eb774336ee5f97fd027acf92dd4f.png)

	- flex-end

		- 现象
![image](assets/da3cfc471c74aca613a6eec1df91656e044de3126c67b071efeacf05df5d16ea.png)

	- center

		- 现象
![image](assets/788fe82fd819978c0757ad6941258f73bd7889502e47cd9f294a897a0fe95edd.png)

	- space-between两端对齐

		- 现象
![image](assets/58e7257a3d5639387fe455f639ec130d0026d70e706eee08de1fec8dab0f14aa.png)

	- space-evenly

		- 现象
![image](assets/7b5d7762ce006b00c52daeec7b5cf15e8166fda27e67007b05e73508f5fc3175.png)

	- space-around

		- 现象
![image](assets/0c7bd32bd4f03f31637a1294347d1baa5c31ecf2ae207c053212061db065190a.png)

	- 图示
![image](assets/6e5cf8ab57e487b53c0aa407cf6ddbf12c7882ada01d6e0f400be671d3ef0fff.png)

		- 图示2
![image](assets/e3e82f26be08dc339d373a62e820fa240e0ecef5bfd6dfb694cd7b2d55e54586.png)

- 总结：看到align是针对cross轴
![image](assets/84a1cbb2bd855be88f167761b30282d3dd66d4dc7728a8b08f38289f3219c2ab.png)

### flex item上的属性
![image](assets/5f1a3495534d25471ba27513be1aa783137653ff36025971b1e7e082e6ceac63.png)

- order

	- 决定了flex items的排布顺序

		- 例子：2是1，其他都是0
![image](assets/a1b8ae2ae231df306b2ac73a222b334882f09a7e4daca12fae7dd24c96aa5668.png)

			- 现象
![image](assets/6e21508e9e5bbf22be169b19a59c6de7b425452c182cb5a9491e95077b5ab218.png)

		- 例子：2是1，4是-1，其他是0
![image](assets/ca1c27ef99d4c341f8d2d2a576e3bf39e92495a1e44c3c6f8e4578ab46db0151.png)

			- 现象
![image](assets/b9f34cb805ff840567c440e12b9133ee09f5ce714e42a9a5fa1dd2c7fa558c8c.png)

	- 图示
![image](assets/e8bee3e22ad7fc1edd6a0794d19c7d830b90a54529ddd18f1f63d5e268d12f49.png)

- align-self

	- 例子：flex container 设置align-items:center,子元素3 flex item设置align-self:flex-end
![image](assets/ffd161c966da699b610cdc0940ab7a2a4a16e6ba94d4069e0a9cfecec8ad0250.png)

		- 现象
![image](assets/a2899720abc78851a5118b787d2e2a9e134fe513c83d3ba5540064f59aa5716c.png)

	- 例子
![image](assets/c934c7c01b06533ed3795cfbd445af28aa111b2bcee16d3580974e8bcf0462dc.png)

		- 现象
![image](assets/d2f5cd7e1fddbf968180b481fbdb4018fcc824337b6005327934547670bdea2c.png)

	- 图示
![image](assets/646ddcc15f11f5da20bdd0ca9e7fa7e3c275a6288d7f5c5ba9862fe6cf2d09cb.png)

- flex-grow

	- 决定了flex items 如何扩展

		- 自己变大

		- 瓜分剩余空间的比例

	- 当flex container在main axis方向上有剩余size时，flex-grow属性才会有效

		- size是宽度或者高度

		- 图例：在主轴上的宽度是有剩余的时候，flex-grow有效。
![image](assets/6d05ae3b50452feaac6325c962652c79011a9c98af556f3b9536be56de14efae.png)

	- 例子：1,2,3设置flex-grow:1
扩展比例是1:1:1，大家都是1/3
![image](assets/423c36b9a9fd059c46770c4ece50340a5d49f12e60e51674c4384dfb1651894b.png)

		- 现象
![image](assets/f1745d97f2d6eefe6fdf42f964328609d6c0583f2ad84457dd970d7cdee12ec7.png)

	- 例子，比例：1:2:2，剩余200，1扩展40，2扩展80，3扩展80
![image](assets/14ad382b651f72acb41d5d1d60472539cc5e4b08ad7cd33a2e1fbb16b2c95d6a.png)

		- 现象
![image](assets/806afc432144baaf3a8eff2668c160aa5a30cab9030ba97ded71ca6b4055f06d.png)

	- 例子：三个宽度各不一样，100，150，200，剩余50，比例还是1:2:2
![image](assets/793008a8f1ce0b89354059d7cf952219dd8ad411a6f2e98a380ba6bd0f8d8abf.png)

		- 现象
![image](assets/0b2acf6094039bca5586a7e51dfcfb2954d47aced793e91d6c4d144d65c49ba9.png)

	- 例子：三个宽度都一样，flex-grow都是0.2
![image](assets/22d5798e4353a891063d11fa313c87af39af80529af85651220ff7076653612c.png)

		- 现象
![image](assets/04f2c1b9cf78de908ff50c06cc89a13b1d810e2fa146bf9f5f7b4f92c5fb37c1.png)

	- 例子：0.2:0.2:0.8
![image](assets/5ae88b2cc6a47a55f6bc8857f913996df59dbeee807852ef94e10aba9077b1ff.png)

		- 现象
![image](assets/6cdddd3afdd759f6e2c91d89de08477ae42ed3c8eae5c54d8f8992a437ed2df1.png)

	- 图示：flex-grow扩展的宽度不能超过max-width或者max-height
![image](assets/f4f4b84c6ef6b78b56bdf433248cf7baa60a858dce95044ea36d7149ecd95582.png)

	- 总结：flex-grow加起来的值，超过1，按照比例分配，如果小于，直接按照剩余乘以比例

- flex-shrink

	- 决定了flex items 如何收缩

	- 当flex items 在main axis方向上超过了 flex container的size，flex-shrink属性才会有效

	- 前端应该是flex-wrap:no-wrap

	- 例子：7个100，容器500

		- 现象
![image](assets/fe5969e0f5dd4e46a18eb51b479a23bfdb8e6a13d276579097a6eded97e3d11c.png)

	- 例子：6个100，flex-shrink:1,600-500超出100，1:1:1:1:1:1，100/6
![image](assets/6a7746aef63acb1d146def1c5634c6eae36eaa5d565139dd6fffc6212b008fe7.png)

		- 现象
![image](assets/222d03e43da2de27b9ec55c18505826783f57830c7f251c506850fe62374c1a7.png)

	- 例子：
![image](assets/5c9a66cf394dd326c35ad219cecf430b7518b5ff89999ef7bf530aa38e588959.png)

		- 现象：超出了
![image](assets/71fb3ea1d8174c93632a1c12facd629a549f40b90272fba6098b1026afa869ef.png)

	- 例子110:1,120:2,130:3...
![image](assets/d38a1cbbfb2097eea3e3a5aac3edd2b15bea29422f845c7b3fd9c3de7f7a0f78.png)

		- 现象
![image](assets/5630b2a4ebc1eb94c095ae8e4a81f2669c5b88e6272dbd38531229e3581ac5da.png)

	- 总结：110+120+130+140+150+160=810
810-500=310，超出了310
收缩比例：flex-shrink * item的size(宽度或者高度)，收缩比例分别为：110*1，120*2。。。。
310*（110*1）/ (总比例相加)

		- 例子
![image](assets/244e0bb53d7f27564a99ae45204ff59892601fd0d408b9b355f73f06d35aa315.png)

	- 图示：
![image](assets/a2a5591c1a05b61ff8dabb783f80733e4564c3be1655e8622f1a676402c223eb.png)

- flex-basis

	- 图示：flex-basic到底是高度还是宽度取决于主轴
![image](assets/b1cc76add658ed64732da0bc9ef5601bdaafc1d611a31bac3992fb8a58511589.png)

	- auto

		- 现象
![image](assets/93a072e93a9b457fcd44baca1c6e6a3ed48c21c03488b0115aee069d916e2c2a.png)

	- content

		- 现象
![image](assets/93a072e93a9b457fcd44baca1c6e6a3ed48c21c03488b0115aee069d916e2c2a.png)

	- 固定值

		- 优先级
![image](assets/3c933e97d2acf4cbf7626fa82b70a72d435d3503067e34974584b1b9fc035315.png)

	- 百度翻译
![image](assets/5cfd342207c58ff27906ef9683152a48c3ef0bb631dd7a16e993d9d0adbb5362.png)

	- 例子
![image](assets/1b3fdd6e6ec7aefe6cae530251147f0b7287267c6e976b607fdf319381998e96.png)

		- 现象：平分
![image](assets/8bd61094257583bf971b9111a3b8742d77a3033f24426ec4c99f986b9f1dbdd4.png)

- flex
![image](assets/f20c524f9ee7969a704ede8b7e478a94c71e17a8d571c7b1c10379100ec2019e.png)

### 三个默认值会影响默认行为

- align-content默认值stretch

	- stretch和size（width，height值为auto时）会产生效果，写死宽度和高度是，拉伸不动了

- flex-grow默认值是0，不扩展

- flex-frink默认值是1，默认按照原始尺寸收缩

## css css3

### 层叠规则

### 选择器

### 排版

- position

- display

- 盒子模型

- float

- flex

### 绘制

### 动画

### points

- css画三角

- css一行文字，多行文字 垂直居中

	- 单行文本溢出隐藏：

		- overflow: hidden;

	- 单行文本溢出隐藏显示省略号

		- white-space: nowrap;
overflow: hidden;
text-overflow: ellipsis;

	- 多行文本溢出隐藏显示省略号

		- text-overflow: -o-ellipsis-lastline;
overflow: hidden;
text-overflow: ellipsis;
display: -webkit-box;
-webkit-line-clamp: 3;
-webkit-box-orient: vertical;

		- 多行文本溢出隐藏时，-webkit-line-clamp: 3; 把3改成几就显示几行。灵活多变

- [box-shadow](https://developer.mozilla.org/zh-CN/docs/Web/CSS/box-shadow)

### [地址](https://lhammer.cn/You-need-to-know-css/#/zh-cn/inner-rounding)

## html html5

### html

### 语义化

### dom

### 2D 3D

### 本地存储

### svg

## shortcut

### 记事本

### interview

### oseasy

### work

### mgj

### 数据结构

### 算法

### 常见设计模式

### 增加代码检查

### 包管理工具

### other side

### mockjs

### mongodb

### vscode

### macos

### git bash

### bash

### server side

### 快捷方式速记

### software design

### 拖拽

- TODO：手撸一个拖拽的demo

### ajax，xhr

### 文件上传

### 工作计划

### 文档集合

## navigator

### 导航-按照细分分类
规则：
1. 只包含分类名称
2. 不包含具体内容
3. 分类进行链接

### html

### css

- flex

- css

### js

- dom

- es6

- standard

- 闭包

- call,apply,bind

### front-end skills

- tcp/ip

- http

- https

- git

- 字符编码问题

- 计算机网络

- 计算机基础知识

### front-end frames

- angularjs

- vue2

- vuex

- react

- 微信小程序

- svg

- electron

### font-end tool

- webpack

### back end

- nodejs

- docker

- linux

- ssh端口转发

- doker

	- kvm

		- 作为一项虚拟化技术已经集成到linux内核中了，可以认为linux内核本身就是一个HyperVisor,这也是KVM名称的含义，因此该技术只能在Linux服务器上使用

		- for Kernel_based virtual machine

			- QEMU-KVM

	- VMware

		- 重量级隔离环境
![image](assets/92980AF4-72B8-42E5-B36C-39B5AB07374D.png)

	- docker

		- 轻量级隔离环境
![image](assets/761d7dce2ee45704cd416df9338faee7facc1cd7fe9824bf677ac577edd7bb10.png)

	- docker概念

		- 容器技术
![image](assets/A2F34911-8313-49D0-87B4-9E4CA97E03C9.png)

## front-end

### navigator

### shortcut

