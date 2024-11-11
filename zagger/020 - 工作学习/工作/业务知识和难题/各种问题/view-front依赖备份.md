---
tags: 工作/业务问题
created: 2023-11-03T22:29
updated: 2023-11-13T19:27
---
# 1. view-front依赖备份

```json
　　{

　　"name": "view-front",

　　"version": "5.5.0",

　　"private": true,

　　"scripts": {

　　  "serve": "vue-cli-service serve",

　　  "build": "vue-cli-service build",

　　  "lint": "vue-cli-service lint",

　　  "prepare": "husky install"

　　},

　　"dependencies": {

　　  "@riophae/vue-treeselect": "^0.4.0",

　　  "axios": "^0.18.0",

　　  "cache-loader": "^4.1.0",

　　  "clone-deep": "^4.0.1",

　　  "driver.js": "^0.9.8",

　　  "echarts": "^4.5.0",

　　  "element-ui": "2.14.1",

　　  "intro.js": "^6.0.0",

　　  "jquery": "^2.2.4",

　　  "moment": "^2.24.0",

　　  "sass": "^1.56.1",

　　  "sass-loader": "10.x",

　　  "utf-8": "^2.0.0",

　　  "uuid": "^9.0.0",

　　  "view-design": "^4.4.0",

　　  "vue": "^2.6.7",

　　  "vue-aspect-ratio": "^0.1.1",

　　  "vue-i18n": "^8.14.0",

　　  "vue-router": "^3.0.2",

　　  "vuex": "^3.4.0"

　　},

　　"devDependencies": {

　　  "@vue/cli-plugin-babel": "^3.4.0",

　　  "@vue/cli-plugin-eslint": "^3.4.0",

　　  "@vue/cli-service": "^3.4.0",

　　  "babel-eslint": "^10.0.1",

　　  "babel-loader": "^9.1.2",

　　  "babel-plugin-component": "^1.1.1",

　　  "eslint": "^7.32.0",

　　  "eslint-config-standard": "^16.0.3",

　　  "eslint-plugin-import": "^2.25.2",

　　  "eslint-plugin-node": "^11.1.0",

　　  "eslint-plugin-promise": "^5.1.1",

　　  "eslint-plugin-vue": "^8.0.3",

　　  "husky": "^6.0.0",

　　  "less": "^3.9.0",

　　  "less-loader": "^4.1.0",

　　  "lint-staged": "^11.2.6",

　　  "mockjs": "^1.0.1-beta3",

　　  "page-lifecycle": "^0.1.2",

　　  "postcss-html": "^1.5.0",

　　  "stylelint": "^14.16.1",

　　  "stylelint-config-clean-order": "^5.0.0",

　　  "stylelint-config-prettier": "^9.0.5",

　　  "stylelint-config-standard": "^28.0.0",

　　  "stylelint-config-standard-vue": "^1.0.0",

　　  "svg-sprite-loader": "^6.0.9",

　　  "vue-cli-plugin-windicss": "~1.1.6",

　　  "vue-template-compiler": "^2.6.7"

　　},

　　"postcss": {

　　  "plugins": {

　　    "autoprefixer": {}

　　  }

　　},

　　"browserslist": \[

　　  "\> 1%",

　　  "last 2 versions",

　　  "not ie \<= 8"

　　\],

　　"lint-staged": {

　　  "\*.js": "eslint --cache --fix",

　　  "\*.vue": "stylelint --quiet",

　　  "\*.css": "stylelint --fix"

　　}

　　}

```