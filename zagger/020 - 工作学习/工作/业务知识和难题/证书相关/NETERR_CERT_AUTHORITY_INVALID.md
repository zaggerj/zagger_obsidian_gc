---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# NET::ERR_CERT_AUTHORITY_INVALID

- 错误类型：浏览器错误

- 错误名称：证书颁发机构无效

- 英文名称：NET::ERR_CERT_AUTHORITY_INVALID

- 错误描述：
	顾名思义，当您的浏览器无法验证您网站的SSL证书的有效性时，就会出现此问题。如果您尚未设置证书或为您的网站使用HTTP（不推荐），则不应遇到此错误。

- 错误变体：
```
NET::ERR_CERT_AUTHORITY_INVALID
NET::ERR_CERT_COMMON_NAME_INVALID
NET::ERR_CERT_WEAK_SIGNATURE_ALGORITHM
NET::ERR_CERTIFICATE_TRANSPARENCY_REQUIRED
NET::ERR_CERT_DATE_INVALID
SSL CERTIFICATE ERROR
```

即使您的网站上[安装了SSL证书](https://www.wbolt.com/how-to-install-ssl-certificate.html)，网站访客也可能会遇到NET::ERR_CERT_AUTHORITY_INVALID错误。尽管名称令人生畏，但无效的证书颁发机构错误并不是您应该恐慌的事情。

简而言之，您的浏览器无法识别您的证书的有效性。为了让您“安全”，它会显示此错误，因此您知道发生了一些可疑的事情。但是，作为站长，您可以采取很多措施来解决问题。

在本教程中，我们将讨论错误消息的含义，以及它在不同浏览器中的报错信息。然后我们将教您如何通过涵盖所有可能的原因来修复NET::ERR_CERT_AUTHORITY_INVALID错误。

1. [NET::ERR_CERT_AUTHORITY_INVALID错误是什么](https://www.wbolt.com/neterr-cert-authority-invalid.html#what-the-neterr_cert_authority_invalid-error-is)
2. [NET::ERR_CERT_AUTHORITY_INVALID错误的不同变体](https://www.wbolt.com/neterr-cert-authority-invalid.html#neterr_cert_authority_invalid-error-variations)
3. [如何修复NET::ERR_CERT_AUTHORITY_INVALID错误](https://www.wbolt.com/neterr-cert-authority-invalid.html#how-to-fix-the-neterr_cert_authority_invalid-error-9-methods)


  
In my case this worked:  
就我而言，这奏效了：

Clean the old certificate and generate a new trusted one. Run the commands listed below:  
清理旧证书并生成新的受信任证书。运行下面列出的命令：

1. dotnet dev-certs https --clean  
2. dotnet dev-certs https --trust 


# 参考链接
1. [如何修复NET::ERR_CERT_AUTHORITY_INVALID：10个成熟的解决方案 - 掘金 (juejin.cn)](https://juejin.cn/post/7130590833715183624?searchId=20230801091937F8A8B15248867E3EDA1F)
2. [如何修复NET::ERR_CERT_AUTHORITY_INVALID错误 - 闪电博 (wbolt.com)](https://www.wbolt.com/neterr-cert-authority-invalid.html)
3. [c# - net::ERR_CERT_AUTHORITY_INVALID in ASP.NET Core - Stack Overflow --- C# - ASP.NET Core 中的 net：：ERR_CERT_AUTHORITY_INVALID - 堆栈溢出](https://stackoverflow.com/questions/63796566/neterr-cert-authority-invalid-in-asp-net-core)
4. [NET::ERR_CERT_DATE_INVALID | Joe Blogs](https://joeblogs.technology/2021/11/neterr_cert_date_invalid/)
5. [修复 NET::ERR_CERT_AUTHORITY_INVALID 错误的 9 种方法_迹忆客 (jiyik.com)](https://www.jiyik.com/tm/xwzj/network_551.html)
6. [(54条消息) Chrome访问https页面显示ERR_CERT_INVALID，且无法跳过继续访问 本地证书过期处理_chrome证书过期怎么办_东湖高新第一会所掌门人的博客-CSDN博客](https://blog.csdn.net/qq_42359718/article/details/109033560)
7. [(54条消息) 使用自签名SSL证书配置HTTPS，解决浏览器提示不安全警告_iis 自签名证书 不安全_Coding_Zhu的博客-CSDN博客](https://blog.csdn.net/Coding_Zhu/article/details/70262677)