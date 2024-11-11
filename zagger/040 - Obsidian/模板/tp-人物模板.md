---

<%-\*
var cleanTitle = tp.user.getTitleSnippet(tp.file.title)
var title = `${cleanTitle}`;
await tp.file.rename(`${title}`);

let filetype = await tp.system.suggester(["亲人", "其他"], ["亲人", "其他"], false, "Which template do you want to use?") 
if (filetype === "亲人") { 
myFilePath = "/010 - 人员管理/家人/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else if (filetype === "其他") { 
myFilePath = "/010 - 人员管理/人脉/" +  `${title}`;
await tp.file.move(`${myFilePath}`);
} else { 
tp.file.cursor(1)
}

-%>

alias:
tags: <% tp.system.suggester(["亲人", "朋友", "同学", "同事", "网友"], ["人脉/亲人", "人脉/朋友", "人脉/同学", "人脉/同事", "人脉/网友"]) %>
birthday:
cdate: <% tp.file.creation_date() %>
uid: <% tp.date.now("YYYYMMDDHHmmss") %>
cssclass:

---

# 1. 基本信息

姓名:: <% `${title}` %>
性别:: <% tp.system.suggester(["男", "女"], ["男", "女"]) %>
年龄:: `$= let date = moment(dv.current().birthday.toString(),"yyyy-MM-DD"); let today = moment().startOf('day'); today.diff(date,"years")`岁
家乡::
手机：`=(this.phone)`
如何认识的::
人物描述::
照片::
