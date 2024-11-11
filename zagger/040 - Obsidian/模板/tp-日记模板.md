---
‚‚±‚<%*
    // 参考文档：https://www.bilibili.com/read/cv23768479/
    let today = new Date();
    //预输出变量
    let taskListStr = "";

    //日记文件名格式（定义成你自己日记文件名的格式，替换其中的变量）
    //yyyy = 年份（例如：2023）
    //m    = 自适应位数月份（例如：3、10）
    //mm   = 两位数月份（例如：03、10）
    //d    = 自适应位数日期（例如：3、10）
    //dd   = 两位数日期（例如：03、10）
    let dailyFileFormat = "日记：yyyy年MM月DD日";

    //时间段
    const timeRegionArray = [
        "00:00|04:59|凌晨",
        "05:00|08:29|早晨",
        "08:30|11:59|上午",
        "12:00|13:59|中午",‚‚‚‚‚‚
        "14:00|17:29|下午",
        "17:30|23:59|晚上",
    ];
    //每日任务清单，预输入固定的每日任务
    let taskArray = [
        "07:05|🌞起床",
        "07:10|💩拉粑粑",
        "07:25|🪥喝一杯水，洗漱",
        "07:30|🍵**泡茶**",
        "12:00|🍴吃午饭",
        "12:25|👀眼保健操",
        "12:30|💤午睡",
        "21:30|📚晚上学习",
        "10:15|💆按摩",
        "23:50|🌙洗漱，早睡",
    ];
    //周常任务清单
    let weekTaskArray = [{},[],[],[],[],[],[],[]];
    //想把任务加在周几，数字就填几
    // 周一：周计划
    weekTaskArray[1].push("10:30|周报整理");
    weekTaskArray[1].push("16:30|周报发布");
    // 周二：开发计划
    weekTaskArray[2].push("8:30|禅道日报检查");
    weekTaskArray[4].push("09:00|🍗禅道日报检查");
    weekTaskArray[5].push("17:00|📰**下周周计划规划**");
    weekTaskArray[6].push("10:00|📞**打扫清洁**");
    weekTaskArray[7].push("19:00|🧹*学习梳理*");
    //周常任务添加
    taskArray.push.apply(taskArray,weekTaskArray[(today.getDay() == 0 ? 7 : today.getDay())]);

    //月任务清单
    let monthTaskArray = [{},[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
    //想把任务加在每月几号，数字就填几
    monthTaskArray[15].push("17:00|🗒💴发工资咯~");
    monthTaskArray[20].push("22:00|🗒🛩️季度考核任务检视");
    //月任务添加
    taskArray.push.apply(taskArray,monthTaskArray[today.getDate()]);

    //排期计划文件名（不能和其他文件重名）
    const planFile = tp.file.find_tfile("排期计划");
    //生成日程后排期计划内当天的任务是否删除(true=删除，false=不删除)
    // 如果你希望创建后保留排期计划中设置的任务 planFileRemoveFlg = false
    const planFileRemoveFlg = true;
    //排期计划中未指定精确时间的任务应该在哪个时间点
    // planDefaultTaskTime的值中时钟和分钟必须是两位数。
    const planDefaultTaskTime = "09:00";

    //动态任务，需要独立判断
    //昨天日期
    let yesterdayDate = new Date(today);
    yesterdayDate.setDate(today.getDate() - 1);

    // 昨天日记文件名
    let fullFileName = formatDailyFileName(yesterdayDate,dailyFileFormat);

    const file = tp.file.find_tfile(fullFileName);
    // 如果昨天的日程中我完成了跑步任务，那么今天就生成散步任务，否则生成跑步任务。 
    if(file != null){
        const content = await app.vault.cachedRead(file);
        const contentStr = content.toString();
        // 隔一天跑步散步
        if(contentStr.contains("- [x] 20:30 👟跑步")){
            taskArray.push("20:30|👞散步");
        }else{
            taskArray.push("20:30|👟跑步");
        }
    }

    //排期计划检索
    let planTask = "";
    if(planFile != null){
        const content = await app.vault.cachedRead(planFile);
        //分行
        const lineArray = content.split("\n");
        const dateTitle = today.getFullYear()+"年"+(today.getMonth()+1)+"月"+today.getDate()+"日";
        let modifyLabel = [];
        for(var i = 0;i < lineArray.length;i++){
            const nowLine = lineArray[i];
            if(nowLine.startsWith("## " + dateTitle)){
                modifyLabel.push(nowLine);
                //循环这天标签下的任务
                for(var j = 1;j < lineArray.length - i;j++){
                    let lineTask = lineArray[i+j];
                    //碰到空白行和#开头则退出循环
                    if(lineTask.length <= 0 || lineTask.startsWith("## ")){
                        break;
                    }
                    //如果没有冒号，表示未设置时间，默认设置planDefaultTaskTime
                    if(lineTask.indexOf(":") == -1){
                        lineTask = lineTask.replace("- [ ]","- [ ] " + planDefaultTaskTime);
                    }
                    //加入任务
                    taskArray.push(lineTask.replace("- [ ] ","").replace(" ","|"));
                    //加入原文到待修改
                    modifyLabel.push(lineArray[i+j]);
                }
            }
        }

        let modifyContent = content;
        for(var i = 0;i < modifyLabel.length;i++){
            modifyContent = modifyContent.replace(modifyLabel[i] + "\n","");
            modifyContent = modifyContent.replace(modifyLabel[i],"");
        }
        //删除排期计划中这次生成任务的日期组
        if(planFileRemoveFlg){
            app.vault.modify(planFile,modifyContent);
        }
    }


    //---------汇总任务数据---------\\
    //任意日期，判断用不到，因为每日清单只对一天的时间处理（后面有个空格，用于Date格式识别）
    const placeholderDate = "2000-09-05 ";
    //根据时间对任务排序
    taskArray.sort(function(task1,task2) {
        let task1Time = new Date(placeholderDate + task1.split("|")[0]);
        let task2Time = new Date(placeholderDate + task2.split("|")[0]);
        return task1Time > task2Time ? 1 : -1;
    });
    //遍历不同的时间段，生成任务清单
    for(var i = 0;i < timeRegionArray.length;i++){
        const nowTimeRegion = timeRegionArray[i].split("|");
        const nowTimeRegionStartDate = new Date(placeholderDate + nowTimeRegion[0])
        const nowTimeRegionEndDate = new Date(placeholderDate + nowTimeRegion[1])
        //在任务清单中寻找当前时间段的任务
        let nowTimeRegionTaskArray = taskArray.filter(task => {
            let taskTime = new Date(placeholderDate + task.split("|")[0]);
            return (taskTime >= nowTimeRegionStartDate && taskTime <= nowTimeRegionEndDate);
        });
        if(nowTimeRegionTaskArray.length > 0){
            taskListStr += ("### " + nowTimeRegion[2] + "\n");
            for(var j = 0;j < nowTimeRegionTaskArray.length;j++){
                taskListStr += ("- [ ] " + nowTimeRegionTaskArray[j].replace("|"," ") + "\n");
            }
        }
    }

    //文件名日期格式化
    function formatDailyFileName(date,format){
        const dateYear = date.getFullYear();
        const dateMonth = date.getMonth() + 1;
        const dateDate = date.getDate();
        return format
            .replace("yyyy",dateYear)
            .replace("mm",dateMonth < 10 ? '0' + dateMonth : dateMonth)
            .replace("MM",dateMonth < 10 ? '0' + dateMonth : dateMonth)
            .replace("m",dateMonth)
            .replace("dd",dateDate < 10 ? '0' + dateDate : dateDate)
            .replace("DD",dateDate < 10 ? '0' + dateDate : dateDate)
            .replace("d",dateDate)
    }
-%>
---
create: <% tp.file.creation_date () %>
tag: 日记,#todo/日常
---
<% taskListStr %>
```dataviewjs
//【今日工作】获取

//日报文件名格式（定义成你自己的格式，替换其中的变量）
//yyyy = 年份（例如：2023）
//m    = 自适应位数月份（例如：3、10）
//mm   = 两位数月份（例如：03、10）
//d    = 自适应位数日期（例如：3、10）
//dd   = 两位数日期（例如：03、10）
let dailyWorkFileFormat = "日报：yyyy年MM月DD日";
//日报文件夹目录
let dailyWorkFilePath = "记事本/工作/工作记录/日报";


//获取当天日报
const fileToday = new Date(dv.current().create);
const file = dv.page(dailyWorkFilePath + "/" + formatDailyFileName(fileToday,dailyWorkFileFormat));
if(file != null){
    dv.header("3","今日工作")
    dv.taskList(file.file.tasks,false)
}
//文件名日期格式化
function formatDailyFileName(date,format){
    const dateYear = date.getFullYear();
    const dateMonth = date.getMonth() + 1;
    const dateDate = date.getDate();
    return format
        .replace("yyyy",dateYear)
        .replace("mm",dateMonth < 10 ? '0' + dateMonth : dateMonth)
        .replace("MM",dateMonth < 10 ? '0' + dateMonth : dateMonth)
        .replace("m",dateMonth)
        .replace("dd",dateDate < 10 ? '0' + dateDate : dateDate)
        .replace("DD",dateDate < 10 ? '0' + dateDate : dateDate)
        .replace("d",dateDate)
}
```
```dataviewjs
//【今日文章】获取
// 今日文章会显示当天创建的文件在这个列表中，但是只会读取元数据中带有create字段且值为当天的数据 例如文件元数据是这样的
//获取当天创建的文件
const fileToday = new Date(dv.current().create);
const todayFileArray = dv.pages().where(file => {
    const fileDate = new Date(file.file.cday);
    return (fileDate.getDate() == fileToday.getDate() && fileDate.getMonth() == fileToday.getMonth() && fileDate.getFullYear() && fileToday.getFullYear());
})

if(todayFileArray.length > 0){
    dv.header("3","今日文章")
}
for(var i = 0;i<todayFileArray.length;i++){
    dv.el("li","[[ " + todayFileArray[i].file.path + "|"+todayFileArray[i].file.name+" ]]\n");
}
```
### 0.1.1. 结语
结束了{{DATE:yyyy年MMMD日}}。