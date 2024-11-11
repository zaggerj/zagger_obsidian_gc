---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
如果你同时使用 stylelint 和 Prettier，并且 Prettier 删除了 HTML 行内样式的分号，但你希望保留分号，可以使用以下步骤进行配置：

配置 stylelint：

确保你已经按照前面提到的步骤安装了 stylelint 和相关插件。
在项目根目录下的 .stylelintrc.json 文件中添加以下规则：
json
Copy
{
  "extends": "stylelint-config-recommended",
  "rules": {
    "declaration-block-trailing-semicolon": "always",
    "at-rule-no-unknown": null
  }
}
```

这里我们除了添加了 `declaration-block-trailing-semicolon` 规则来强制要求行内样式的声明块末尾加上分号，还添加了 `"at-rule-no-unknown": null` 规则，以便在处理 Prettier 的一些特殊规则时避免冲突。

配置 Prettier：

在项目根目录下的 .prettierrc 文件中添加以下配置：
json
Copy
{
  "overrides": [
    {
      "files": "*.html",
      "options": {
        "htmlWhitespaceSensitivity": "ignore"
      }
    }
  ]
}
```

通过设置 `"htmlWhitespaceSensitivity": "ignore"`，Prettier 将忽略 HTML 文件中的空格敏感性，以保留行内样式的分号。
现在，当你运行 stylelint 来检查 HTML 文件中的样式时，它将强制要求行内样式的声明块末尾加上分号。同时，Prettier 将保留 HTML 文件中的行内样式分号而不去除它。

确保你的编辑器中安装了适当的 stylelint 和 Prettier 插件，并将它们配置为在保存文件时自动运行以保持代码风格的一致性。