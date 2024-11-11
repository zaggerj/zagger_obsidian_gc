---
tags: 工作/业务问题
created: 2023-11-03T22:29
updated: 2023-11-13T19:27
---
# vue样式问题

　　1\. scoped 配合 /deep/ \>\>\> ::/deep/，想修改element-ui某个深层元素

　　2\. 没有scoped就不需要上述选择器，直接使用普通选择器

　　不同的less_babel版本意味着不同的

　　**1./deep/**

　　在vue3.0之前可使用

　　**2.::v-deep**

　　在vue3.0及后使用，替代/deep/

　　::v-deep .el-input {

　　width: 60px;

　　}

　　**3.**

　　只作用于css，对于less和scss不起作用，如果是less和scss的话需要用到/deep/或::v-deep

　　**4.其他解决方式；**

　　1）将 scoped 移除，或者新建一个没有 scoped 的 style（一个.vue文件允许多个style）

　　\<style type="text/css"\>

　　.el-radio-button\_\_inner {

　　width: 158px;

　　}

　　\</style\>
