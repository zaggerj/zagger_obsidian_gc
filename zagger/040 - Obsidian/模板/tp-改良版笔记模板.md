<%-* const noteName = await tp.system.prompt("给这个笔记定一个名字 ", tp.date.now("YYYY-MM-DD")) -%>
<%-* await tp.file.rename(noteName) -%>
<%-* const name = tp.file.title -%>
<%-* const dailyReg = /日记|(\d+(?:年)?)?((年|月|日)|-|\/|\.)?(\d+(?:月)?)?-?(\d+(?:日)?|\d+(号)?)/ -%>
<%-* const jsReg = /nodejs|electron|typescript|vue|webAssembly|webpack|worker|小程序|css|js|事件循环|前端|二进制/ -%>
<%-* const lowReg = /bash|linux|nginx|jenkins|docker|服务器/ -%>
<%-* const currentFolder = tp.file.folder() -%>
<%-* const matchDaily = name.match(dailyReg) -%>
<%-* console.log(':', matchDaily) -%>
<%-* if (matchDaily) {  -%>
<%-tp.file.include("[[tp-每日日记模板]]")-%>
<%-* } else { -%>
<%-tp.file.include("[[tp-改良长青笔记模板]]")-%>
<%-* } -%>


