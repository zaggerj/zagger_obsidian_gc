---
created: 2023-11-03T22:29
updated: 2023-11-06T12:24
---
## 参考链接
1. [AngularJS 如何使用Mocha测试AngularJS代码|极客教程 (geek-docs.com)](https://geek-docs.com/angularjs/angularjs-ask-answer/510_angularjs_how_do_i_test_angularjs_code_using_mocha.html)
2. [AngularJS单元测试——karma+mocha配置及实例-CSDN博客](https://blog.csdn.net/u014291497/article/details/50373703)
3. [Mocha - the fun, simple, flexible JavaScript test framework (mochajs.org)](https://mochajs.org/)
4. [Mocha中文网 - 有趣、简单、灵活的javascript测试框架 (mochajs.cn)](https://mochajs.cn/)
5. [前端新手使用karma+mocha+chai+sinon 进行angularjs 单元测试-CSDN博客](https://blog.csdn.net/chrissata/article/details/78493012)
6. [Chai (chaijs.com)](https://www.chaijs.com/)
7. [Sinon.JS - Standalone test fakes, spies, stubs and mocks for JavaScript. Works with any unit testing framework. (sinonjs.org)](https://sinonjs.org/)
8. 解决全局变量找不到$问题![[Pasted image 20231016181108.png]]
9. angularjs模块加载问题，模块的依赖可能是异步的，找不到异步的服务，报错![[Pasted image 20231016181133.png]]
10. ![[Pasted image 20231016181257.png]]
11. 测试代码
```js
/* eslint-disable no-undef */

// why：angular-mocks 直接依赖

import '@src/libs/angular/angular'

import '@src/libs/angular/angular-mocks'

  

import '@src/libs/jquery-3.5.1'

import '@src/vdi/bootstrap'

import '@src/vdoi/main'

import '@src/vdoi/desktop'

import '@src/vdoi/terminal'

  

import '@src/voi/terminal/controller.clients.all'

import '@src/voi/terminal/controller.clients.utilities'

  

const { module, inject } = angular.mock

  

describe('初始化检测', function () {

  it('ngMock 应正确加载', () => {

    expect(module).not.toBeUndefined()

    expect(inject).not.toBeUndefined()

  })

})

  

describe('ClientListCtrl', function () {

  beforeEach(module('ng'))

  beforeEach(module('i18n'))

  beforeEach(module('smartApp'))

  beforeEach(module('tml.class'))

  beforeEach(module('tml.virtual'))

  beforeEach(module('terminal.common'))

  beforeEach(module('terminal.deploy'))

  beforeEach(module('terminal.more'))

  beforeEach(module('terminal.utilities'))

  beforeEach(module('tml.terminal'))

  beforeEach(module('tml'))

  

  let $ctrl, $scope

  

  beforeEach(inject(function (_$controller_, _$rootScope_) {

    global.$$$storage = {

      getSessionStorage(str) {

        return JSON.stringify(str)

      }

    }

    $scope = _$rootScope_.$new()

    $ctrl = _$controller_('ClientListCtrl', {

      $scope,

      $modal: {},

      $interval: {},

      $filter: {},

      $http: {},

      uihelper: {},

      networkUtils: {},

      i18n: {},

      voiApi: {},

      clientStatus: {},

      $location: {},

      $q: {},

      timeoutLoop: {},

      authoredSrv: {}

    })

  }))

  

  it('终端类型需要被正确格式化', () => {

    console.log($scope)

  })

})
```