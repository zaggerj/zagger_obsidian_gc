---
created: 2023-11-06T08:20
updated: 2023-11-06T08:20
---
# #Linux #network 参考文档
[5分钟学会查看Linux端口占用情况_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1M94y157Dy/?spm_id_from=333.1007.tianma.8-3-29.click&vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
[5分钟学会Linux的ps命令_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1dN4y1r7y5/?vd_source=af94dc11f0a1751ebb3c2090844ad9f6)
1.  命令 netstat -tlunp | head 
	1. Network statistics 网络统计
	2. ![[Pasted image 20231101222739.png]]
	3. 不加 -n，local address 服务器名称加端口或者 foreign address ip 地址加协议
	4. ![[Pasted image 20231101224153.png]]
	5. 加 -n，使用 ip 加端口的方式来进行地址的描述
	6. ![[Pasted image 20231101224223.png]]
	7. 加 l 仅展示监听（Listen）状态的程序，排除 ESTABLISH 和 CLOSE
	8. ![[Pasted image 20231101224724.png]]
	9. 参数 t 和 u，分别代表查看 tcp 和 udp 协议
	10. ![[Pasted image 20231101224930.png]]
	11. 参数-p，该程序的程序名称（program name）和 PID（program id） ![[Pasted image 20231101225012.png]]
	12. 使用 netstat -luntp | grep java
	13. ![[Pasted image 20231101225236.png]]
	14. 使用 ps -p 18391 -f 
	15. -e 是显示全部，所以这里不需要
	16. ![[Pasted image 20231101225422.png]]
	17. Find . -name "demo-0\.\0-SNAP*""
	18. ![[Pasted image 20231101225551.png]]
2. 命令 ps -ef
	1. Processes snapshot 进程快照
	2. 直接 ps，展示的是当前控制台下属于当前用户的进程
	3. -f ps -f 显示当前系统完整输出![[Pasted image 20231101225956.png]]
	4. Ps -e == ps -A 
	5. ![[Pasted image 20231101230036.png]]
	6. Ps -aux | head -n 10
	7. ![[Pasted image 20231101230109.png]]
	8. 一种是系统原本格式，一种是 BSD 格式，
	9. VSZ == virtual Memory size 虚拟内存大小
	10. RSS == Resident set size  占用物理内存大小
	11. AUX
	12. ![[Pasted image 20231101230406.png]]
	13. -x 是对 au 的补充
	14. ![[Pasted image 20231101230440.png]]
	15. ![[Pasted image 20231101230457.png]]
	16. ![[Pasted image 20231101230556.png]]
	17. Ps -U wen -f 打印 wen 用户的
	18. Ps -u BSD 风格
	19. U 该用户直接进程，u 显示子进程
 ![[Pasted image 20231101230857.png]]
 BSD 风格 ![[Pasted image 20231101231016.png]]