---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
# sessionStorage应用场景
> 应用场景：在需要重新打开子页面时，通过sessionStorage来传递数据，并且需要在关闭窗口时，销毁sessionStorage。
> 特点：sessionStorage如果缓存数据，跟打开之前的数据在对应上，比较严格：比方说，用户门户场景，每次缓存的数据，包含场景数据，还有当前登录的账号的用户信息；vnc打开子页面，每次sessionStorage缓存了接口返回的refresh_token；
> 问题：


refresh_token:
1. 首次打开，只传通过url传递过来的token
2. 刷新，使用上次缓存的/8081/api/instances/connection接口返回的refresh_token，作为下次传递/8081/api/instances/connection的refresh_token，
3. 分享给别人使用，一定没有refresh_token，token只能使用一次，会报错。
4. token配合refresh_token使用，token失效了，但是refresh_token有效也是可以使用的。

git config --local core.autocrlf false

git config --local core.safecrlf false