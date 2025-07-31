#!/bin/bash
dnf -y install bc &> /dev/null
# 工作流循环配置工作器 （未启用）
# function continue_or_no(){
#     read -ep "是否继续运行进行其他服务设置(yes|no):" yon
#     if [ $yon == yes ]
#     then
#         continue
#     elif [ $yon == no ]
#     then
#         exit 0
#     else
#         echo "请输入yes|no:"
#     fi
# }

# 内置绘表器
function draw_table(){
tbc7="╭";tbc9="╮";
tbc1="╰";tbc3="╯";
tbx0="╳";
# 样式
style="$1"
case $style in
	# 1 2 3 4 5 6 7 8 9 10       11      12      13       14      15      16
	# 1 2 3 4 5 6 7 8 9 txt_empt top_row mid_row btm_row left_col mid_col right_col 
	-0)  tbs="                ";;
	-1)  tbs="└┴┘├┼┤┌┬┐ ───│││";;
	-2)  tbs="└─┘│┼│┌─┐ ───│││";;
	-3)  tbs="╚╩╝╠╬╣╔╦╗ ═══║║║";;
	-4)  tbs="╚═╝║╬║╔═╗ ═══║║║";;
	-5)  tbs="╙╨╜╟╫╢╓╥╖ ───║║║";;
	-6)  tbs="╘╧╛╞╪╡╒╤╕ ═══│││";;
	-7)  tbs="└┴┘├┼┤┌┬┐ ─ ─│ │";;
	-8)  tbs="└─┘│┼│┌─┐ ─ ─│ │";;
	-9)  tbs="╚╩╝╠╬╣╔╦╗ ═ ═║ ║";;
	-10) tbs="╚═╝║╬║╔═╗ ═ ═║ ║";;
	-11) tbs="╙╨╜╟╫╢╓╥╖ ─ ─║ ║";;
	-12) tbs="╘╧╛╞╪╡╒╤╕ ═ ═│ │";;
	-13) tbs="╘╧╛╞╪╡╒╤╕ ═ ═│ │";;
	-14) tbs="╚╩╝╠╬╣╔╦╗ ───│││";;
	-15) tbs="+++++++++ ---|||";;
	"%"*) tbs="${style/"%"/}";;
	-h*|--h*)
		echo -e '
 [  ---   HELP  ---  ]
\t command : draw_table.sh [style] [colors] < <file >
\t    pipo : echo -e A\\tB\\na\\tb | draw_table.sh [style] [colors]
\t [style] : input 16 characters
\t           1~9 is Num. keypad as table,10 is not used
\t           11~13 are left,middle,right in a row
\t           14~16 are left,middle,right in a column
\t
\t         -0  :                
\t         -1  :└┴┘├┼┤┌┬┐ ───│││         -9  :╚╩╝╠╬╣╔╦╗ ═ ═║ ║
\t         -2  :└─┘│┼│┌─┐ ───│││         -10 :╚═╝║╬║╔═╗ ═ ═║ ║
\t         -3  :╚╩╝╠╬╣╔╦╗ ═══║║║         -11 :╙╨╜╟╫╢╓╥╖ ─ ─║ ║
\t         -4  :╚═╝║╬║╔═╗ ═══║║║         -12 :╘╧╛╞╪╡╒╤╕ ═ ═│ │
\t         -5  :╙╨╜╟╫╢╓╥╖ ───║║║         -13 :╘╧╛╞╪╡╒╤╕ ═ ═│ │
\t         -6  :╘╧╛╞╪╡╒╤╕ ═══│││         -14 :╚╩╝╠╬╣╔╦╗ ───│││
\t         -7  :└┴┘├┼┤┌┬┐ ─ ─│ │         -15 :+++++++++ ---|||
\t         -8  :└─┘│┼│┌─┐ ─ ─│ │
\t
\t [colors]: input a list,like "-3,-4,-8" sames "-green,-yellow,-white"
\t           It set color,table cross ,font ,middle. Or \\033[xxm .
\t           And support custom color set  every characters of sytle
\t           Like "\\033[30m,-red,-yellow,,,,,,,,,,,,," sum 16.
\t
\t          -1|-black         -5|-blue
\t          -2|-red           -6|-purple
\t          -3|-green         -7|-cyan
\t          -4|-yellow        -8|-white
		'
		exit
		;;
esac
tbs="${tbs:-"+++++++++,---|||"}"
 
# 颜色
color="$2"
case $color in
	1) ;;
	2) ;;
	3) ;;
	"-"*|"\033"*)
		# 3位数标,词
		colors="$color"
		;;
	"%"*) :
		# 全自定义
		colors="${color/"%"/}"
		;;
esac
colors="${colors:-"-4,-8,-4"}"
 
# 主体
awk -F '\t' \
	-v table_s="$tbs" \
	-v color_s="$colors" \
	'BEGIN{
	}{
		for(i=1;i<=NF;i++){
			# 每列最大长度
			cols_len[i]=cols_len[i]<length($i)?length($i):cols_len[i]
			# 每行每列值
			rows[NR][i]=$i
		}
		# 前后行状态
		if(NR==1){
			befor=0
		}else if(1==2){
			after=0
		}
		rows[NR][0] = befor "," NF
		befor=NF
	}END{
		# 颜色表
		color_sum = split(color_s,clr_id,",")
		if(color_sum==3){
			# 简易自定义模式
			for(i=1;i<=3;i++){
				if(color_s~"-"){
					clr_id[i] = color_var(clr_id[i])
				}else if(colors~"\033["){
					clr_id[i] = cclr_id[i]
				}
			}
			# 组建色表
			for(i=1;i<=16;i++){
				if(i<10){
					colors[i] = clr_id[1]
				}else if(i==10){
					colors[i] = clr_id[2]
				}else if(i>10){
					colors[i] = clr_id[3]
				}
			}
		}else if(color_sum==16){
			# 全自定义模式
			for(i=1;i<=16;i++){
				if(color_s~"-"){
					clr_id[i] = color_var(clr_id[i])
				}else if(colors~"\033["){
					clr_id[i] = cclr_id[i]
				}
				#colors[i] = clr_id[i]
			}
		}
		#split(color_s,colors,",")
		clr_end = "\033[0m"
			clr_font = colors[10]
			#clr_cross = colrs[2]
			#clr_blank = colors[3]
		# 制表符二维表并着色
		for(i=1;i<=length(table_s);i++){
			if(colors[i]=="")
				tbs[i] = substr(table_s,i,1)
			else
				tbs[i] = colors[i] substr(table_s,i,1) clr_end
			fi
		}
		# 绘制上边框
		top_line=line_val("top")
		# 绘制文本行
		# 绘制分隔行
		mid_line=line_val("mid")
		# 绘制下边框
		btm_line=line_val("btm")
		# 行最大总长度
		line_len_sum=0
		for(i=1;i<=length(cols_len);i++){
			line_len_sum=line_len_sum + cols_len[i] + 2
		}
		line_len_sum=line_len_sum + length(cols_len) - 1
		# 所有表格线预存（提高效率）
		title_top = line_val("title_top")
		top = line_val("top")
		title_mid = line_val("title_mid")
		title_btm_mid = line_val("title_btm_mid")
		title_top_mid = line_val("title_top_mid")
		mid = line_val("mid")
		title_btm = line_val("title_btm")
		btm = line_val("btm")
		# 绘制表格 2
		line_rows_sum=length(rows)
		for(i=1;i<=line_rows_sum;i++){
			# 状态值
			split(rows[i][0],status,",")
			befors=int(status[1])
			nows=int(status[2])
			if(i==1 && befors==0){
				# 首行时
				if(nows<=1){
					# 单列
					print title_top
					print line_val("title_txt",rows[i][1],line_len_sum)
				
				}else if(nows>=2){
					# 多列
					print top
					print line_val("txt",rows[i])
				
				}	
			}else if(befors<=1){
				# 前一行为单列时
				if(nows<=1){
					# 单列
					print title_mid
					print line_val("title_txt",rows[i][1],line_len_sum)
				}else if(nows>=2){
					# 多列
					print title_btm_mid
					print line_val("txt",rows[i])
				}
			
			}else if(befors>=2){
				# 前一行为多列时
				if(nows<=1){
					# 单列
					print title_top_mid
					print line_val("title_txt",rows[i][1],line_len_sum)
				}else if(nows>=2){
					# 多列
					print mid
					print line_val("txt",rows[i])
				}
			}
			# 表格底边
			if(i==line_rows_sum && nows<=1){
				# 尾行单列时
				print title_btm
			}else if(i==line_rows_sum && nows>=2){
				# 尾行多列时
				print btm
			}
		}
	}
	function color_var(  color){
		# 颜色
		#local color=$1
		#case $color in
		if(color=="-1" ||color=="-black"){
			n=30
		}else if(color=="-2" || color=="-red"){
			n=31
		}else if(color=="-3" || color=="-green"){
			n=32
		}else if(color=="-4" || color=="-yellow"){
			n=33
		}else if(color=="-5" || color=="-blue"){
			n=34
		}else if(color=="-6" || color=="-purple"){
			n=35
		}else if(color=="-7" || color=="-cyan"){
			n=36
		}else if(color=="-8" || color=="-white"){
			n=37
		}else if(color=="-0" || color=="-reset"){
			n=0
		}else{
			n=0
		}
		return "\033[" n "m"
	}
	function line_val(   part,   txt,  cell_lens,  cell_len,  line,  i){
		# 更新本次行标
		if(part=="top"){
			tbs_l=tbs[7]
			tbs_m=tbs[8]
			tbs_r=tbs[9]
			tbs_b=tbs[11]
		}else if(part=="mid"){
			tbs_l=tbs[4]
			tbs_m=tbs[5]
			tbs_r=tbs[6]
			tbs_b=tbs[12]
		}else if(part=="txt"){
			tbs_l=tbs[14] tbs[10]
			tbs_m=tbs[10] tbs[15] tbs[10]
			tbs_r=tbs[10] tbs[16]
			tbs_b=tbs[10]
		}else if(part=="btm"){
			tbs_l=tbs[1]
			tbs_m=tbs[2]
			tbs_r=tbs[3]
			tbs_b=tbs[13]
		}else if(part=="title_top"){
			tbs_l=tbs[7]
			tbs_m=tbs[11]
			tbs_r=tbs[9]
			tbs_b=tbs[11]			
		}else if(part=="title_top_mid"){
			tbs_l=tbs[4]
			tbs_m=tbs[2]
			tbs_r=tbs[6]
			tbs_b=tbs[12]			
		}else if(part=="title_mid"){
			tbs_l=tbs[4]
			tbs_m=tbs[12]
			tbs_r=tbs[6]
			tbs_b=tbs[12]			
		}else if(part=="title_txt"){
			tbs_l=tbs[14]
			tbs_m=tbs[15]
			tbs_r=tbs[16]
			tbs_b=tbs[10]			
		}else if(part=="title_btm"){
			tbs_l=tbs[1]
			tbs_m=tbs[13]
			tbs_r=tbs[3]
			tbs_b=tbs[13]			
		}else if(part=="title_btm_mid"){
			tbs_l=tbs[4]
			tbs_m=tbs[8]
			tbs_r=tbs[6]
			tbs_b=tbs[12]			
		}
		# 制表符着色
		#	tbs_l = clr_cross tbs_l clr_end
		#	tbs_m = clr_cross tbs_m clr_end
		#	tbs_r = clr_cross tbs_r clr_end
		#	tbs_b = clr_blank tbs_b clr_end
		# title行只有一列文本
		if(part=="title_txt"){
			cols_count=1
		}else{
			cols_count=length(cols_len)
		}
		line_tail=""
		for(i=1;i<=cols_count;i++){
			# 定义当前单元格内容，长度
			if(part=="txt"){
				cell_tail=txt[i]
				cols_len_new=cols_len[i]-length(cell_tail)
			}else if(part=="title_txt"){
				# 单列居中
				cell_tail=txt
				cols_len_new = ( cell_lens - length(cell_tail) ) / 2
				cols_len_fix = ( cell_lens - length(cell_tail) ) % 2
				#print cols_len_new,cols_len_fix
			}else{
				cell_tail = ""
				cols_len_new = cols_len[i] + 2
			}
			# 单元格文本着色
			cell_tail = clr_font cell_tail clr_end
			# 单元格内空白补全
			if(part=="title_txt"){
				# 单列
				#cols_len_new=cols_len_new/2
				for(cell_len=1;cell_len<=cols_len_new;cell_len++){
					cell_tail= tbs_b cell_tail tbs_b
				}
				# 单列非偶长度补全
				if(cols_len_fix==1){
					cell_tail = cell_tail " "
				}
			}else{
				# 多列
				for(cell_len=1;cell_len<=cols_len_new;cell_len++){
					cell_tail=cell_tail tbs_b
				}
			}
			# 首格
			if(i==1){
				line_tail=line_tail cell_tail
			}else{
				# 中格
				line_tail=line_tail tbs_m cell_tail
			}
			# 尾格
			if(i==cols_count){
				line_tail=line_tail tbs_r
			}	
		}
		# 返回行
		return tbs_l line_tail
	}
	' 
}
# 检查服务启动状态函数 要匹配检测的内容 服务前输的内容
function check_service_status(){
echo "检查服务开启状态"
if ss -atunp | grep -q $1  #查看端口是否开启
then
	echo -e "\e[32;2m${2}服务启动成功\e[0m"
else
	echo -e "\e[31m${2}服务启动失败,请自行检查相关配置文件\e[0m"
fi
}

# 向上取整器 小数
function ceil(){
floor=$(echo "scale=0;$1/1" | bc -l)
add=$(awk -v num1=$floor -v num2=$1 'BEGIN{print(num1<num2)?"1":"0"}')
echo $(expr $floor + $add)
}

# 倒计时器 事件内容 几秒后
function countdown(){
echo -e "\e[1;36m${2}秒后$1\e[0m"
for i in $(seq $2 -1 1) 
do 
	echo $i
	sleep 1
done
}

# 输入错误!(红色高亮)输出器 
function error_printer(){
echo -e "\e[1;31m输入错误! \e[0m"
}

# 颜色输出器 颜色 输出内容 
function color_printer(){
case $1 in 
r)echo -e "\e[31m$2\e[0m";;
g)echo -e "\e[32m$2\e[0m";;
y)echo -e "\e[33m$2\e[0m";;
h)echo -e "\e[1m$2\e[0m";;
t)echo -e "\e[5m$2\e[0m";;
esac
}

# mysql命令行操作器 SQL语句 要操作的数据库(可选) 
function mysql_operate(){
mysql -uroot -e "$1" $2
if [ $? -eq 0 ];then
	color_printer g "${1} 命令执行成功"
else
	color_printer r "${1} 命令执行失败"
fi
}

# mysql命令行操作返回值器 SQL语句 要操作的数据库(可选) 
function mysql_operate_return(){
transer=$(mysql -uroot -e "$1" $2)
if [ $? -eq 0 ];then
	echo $transer
else
	color_printer r "${1} 命令执行失败"
fi
}


# 端口扫描器 ip port (返回echo $?的值)
function port_scanner(){
nc -n -w2 -z $1 $2
echo $?
}

# 字符串元素计数器 字符串 返回元素个数 有问题
function string_counter(){
counter=0
for i in $1;do
let counter+=1
done
echo $counter
}

# 行号搜索器 搜索行唯一存在的内容 搜索文件 返回内容行号
function nu_searcher(){
cat -n $2|egrep "$1"|awk '{print $1}'
}


# 更改网卡配置 直接调用
function change_ip(){
    color_printer t 尝试开始修改网卡配置,请确保nmcli配置文件已加载并启用,并关注输出内容!
    touch tmp
    echo -e "IPaddress" > tmp
    ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2,$NF}' >> tmp
    echo "DNS" >> tmp
    dns=`awk 'NR>1{print $2}' /etc/resolv.conf`
    echo $dns >> tmp
    echo "Router" >> tmp
    router=`route -n | awk 'NR>2{print $2}' | egrep -v "0.0.0.0"`
    echo $router >> tmp
	echo "当前已启用参数相关配置:"
    draw_table -1 < tmp
    rm -rf tmp

    read -ep "请输入网卡名(NIC)选择网卡:" NIC
    NIC=/etc/NetworkManager/system-connections/$NIC.nmconnection
    cat $NIC | egrep "^id|interface-name|address|dns|method|ipv4|ipv6|connection"
    echo -e "\n接下来请根据提示,输入对应的配置,子网掩码/24暂不可改 \e[33m如果不需要更改请按下回车,如果需要删除(子网卡不支持)请输入clean\e[0m\n"

    read -ep "请输入网卡获取网络方法(auto|manual|disabled):" method
	if [ -z "$method" ] ;then
        echo "保持`awk '/method/{print;exit}' $NIC`"
    elif [ -n "$method" ] ;then
        delete_num=`awk '/method/{print NR;exit}' $NIC`
        if [ "$method" == 'clean' ] ;then
            echo "method暂不支持删除选项"
			echo "保持默认`awk '/method/{print;exit}' $NIC`"
		else
			sed -i ''$delete_num's/'$(awk -F= '/method/{print $2;exit}' $NIC)'/'$method'/g' $NIC
			echo "修改完成`awk '/method/{print;exit}' $NIC`"
        fi
	else
		error_printer
    fi

    address=();read -ep "请输入完整IPv4地址(若有多个子网 输入时请以空格分隔):" -a address
    if [ ${#address[*]} -eq 0 ] ;then
        echo "保持`awk '/address/{print}' $NIC`"
    elif [ ${#address[*]} -eq 1 ] ;then
        delete_num=`awk '/address/{print NR}' $NIC`
        if [ ${address[0]} == 'clean' ] ;then
			echo "删除`awk 'NR='$delete_num'{print}' $NIC`"
            sed -i ''$delete_num'd' $NIC
		else
			sed -i ''$delete_num's/'$(awk -F= '/address/{print $2}' $NIC|awk -F/ '{print $1}')'/'${address[0]}'/g' $NIC
			echo "修改完成`awk '/address/{print}' $NIC`"
        fi
    else
		delete_num=`awk '/address/{print NR}' $NIC`
		if [ -n "$delete_num" ]
		then
			sed -i ''$delete_num'd' $NIC
			for i in `seq ${#address[*]} -1 1`
			do
					sed -i ''$(($delete_num-1))'a address'$i'='${address[$i-1]}'/24' $NIC
			done
		else
			delete_num=`awk '/method/{print NR;exit}' $NIC`
			for i in `seq ${#address[*]} -1 1`
			do
					sed -i ''$delete_num'a address'$i'='${address[$i-1]}'/24' $NIC
			done
		fi
		echo -e "修改完成\n`awk '/address[0-9]/{print}' $NIC`"
    fi

	read -ep "请输入完整网关地址(仅一个):" router
	if [ -z "$router" ] ;then
        echo "保持`awk -F, '/address/{print $2}' $NIC`"
    elif [ -n "$router" ] ;then
        delete_num=`awk '/address/{print NR}' $NIC`
        if [ "$router" == 'clean' ] ;then
			echo "删除网关`awk -F, '/address/{print $2}' $NIC`"
			sed -i ''$delete_num's/,'$(awk -F, '/address/{print $2}' $NIC)'//g' $NIC
		elif [ -n  "$(awk -F, '/address/{print $2}' $NIC)" ];then
			sed -i ''$delete_num's/'$(awk -F, '/address/{print $2}' $NIC)'/'$router'/g' $NIC
			echo "修改完成`awk '/address/{print}' $NIC`"
		else
			sed -i ''$delete_num's/\/24/\/24,'$router'/g' $NIC
			echo "修改完成1`awk '/address/{print}' $NIC`"
        fi
	else
		error_printer
    fi

	read -ep "请输入一个或多个DNS地址(以英文;分隔):" dns
	if [ -z "$dns" ] ;then
        echo "保持`awk '/dns=/{print}' $NIC`"
    elif [ -n "$dns" ] ;then
		delete_num=`awk '/dns=/{print NR}' $NIC`
        if [ "$dns" == 'clean' ] ;then
			echo "删除DNS`awk '/dns=/{print $2}' $NIC`"
			sed -i ''$delete_num'd' $NIC
		elif [ -n "$(egrep "dns=" $NIC)" ];then
			sed -i ''$delete_num's/'$(awk -F= '/dns=/{print $2}' $NIC)'/'$dns'/' $NIC
		else
			sed -i ''$(awk '/address/{print NR}' $NIC |tail -1)'a dns='$dns'' $NIC
			echo "修改完成`awk '/dns=/{print}' $NIC`"
        fi
	else
		error_printer
    fi

	echo -e "\e[32;1m已完成各项网卡配置修改,以下是当前网卡参数:\e[0m"
	cat $NIC | egrep "^id|interface-name|address|dns|method|ipv4|ipv6|connection"
	echo "是否需要载入该网卡配置？	yes:现在载入 | no:不载入,可手动检查一下配置文件后再自行手动载入"
	read -ep "请输入:" bool
	case $bool in
	yes)
		echo -e "\e[33;5m现在载入网卡配置,若更改了IP,请注意远程连接重连\e[0m"
		nmcli c reload
		nmcli c up $(echo $NIC|awk -F. '{print $1}'|awk -F/ '{print $NF}')
	;;
	no)
		echo -e "\e[33;5m取消载入网卡配置,请不要忘记手动载入,若更改了IP,请注意远程连接重连\e[0m"
		echo "vim /etc/NetworkManager/system-connections/"
	;;
	*)echo -e "\e[33;5m输入信息无效\n默认取消载入网卡配置,请不要忘记手动载入,若更改了IP,请注意远程连接重连\e[0m";;
	esac
}

# 开启路由转发 目前只能自动开 需要手动关 (优化方向,检测当前状态,进行开启或关闭)
function open_ip_forward(){
    sysctl -w net.ipv4.ip_forward=1
    echo -e "\e[32;1m临时IP转发已开启\e[0m"
	echo -e "如需关闭,请执行:\nsysctl -w net.ipv4.ip_forward=0"
}

# DHCP设置器 输入选项
function DHCP_SET(){
# DHCP配置文件基础设置
dhcp_server_baseconfig(){
touch tmp
cat > tmp <<EOF
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

log-facility local7;

EOF
}

case $1 in 
1)
# dhcp基础
    dnf -y install dhcp-server 
    echo "应该已经完成dhcp-server安装了"
    echo -e "\e[33m开始更改主配置文件,请按提示输入,不需要的输入回车\e[0m"
    read -ep "请输入DHCP分配的网段(不能为空192.168.50.0):" ip_segment
    read -ep "请输入DHCP分配的地址池(地址池用空格分开起止网段,如果只有一个地址就写一个,不能为空):" ip_range
    read -ep "请输入DHCP分配的dns(多个按顺序用 , 分隔):" dns
    read -ep "请输入DHCP分配的网关:" router

	touch tmp
	# 开始写入
	dhcp_server_baseconfig
	echo "subnet $ip_segment netmask 255.255.255.0 {" >> tmp
	echo -e "\trange $ip_range;" >> tmp
	if [ -n "$dns" ];then
		echo -e "\toption domain-name-servers $dns;" >> tmp
	fi
	if [ -n "$router" ];then
		echo -e "\toption routers $router;" >> tmp
	fi
	echo "}" >> tmp
	sed -i '5r tmp' /etc/dhcp/dhcpd.conf
	# 写入完成
	rm -rf tmp
    systemctl restart dhcpd
    echo "检查服务开启状态"
    if ss -aunp | grep -q dhcp  #查看端口是否开启
    then
        echo -e "\e[32;2mDHCP服务启动成功\n作用网关:$ip_segment\n地址池:$ip_range\nDNS:$dns\n网关:$router\n\e[0m"
    else
        color_printer r DHCP服务启动失败,请自行检查相关配置文件
    fi
;;
2)
# dhcp保留地址池 需要有基础服务
    dnf -y install dhcp-server 
    echo "应该已经完成dhcp-server安装了"
    color_printer y 开始更改主配置文件,请按提示输入
	echo "当前流程存在数量对应校验,但也请保证输入的每个元素的准确性"
	while :
	do
		macs=()
		ips=()
		read -ep "请输入客户机MAC地址  (若有多个请用 空格 分隔):" -a macs
		read -ep "请输入客户机保留的IP地址(请和上方输入一一对应):" -a ips
		if [ ${#macs[*]} -ne  ${#ips[*]} ];then
			echo -e "两次输入元素个数不一致!/n请重新输入!"
		elif [ ${#macs[*]} -eq  ${#ips[*]} ];then
			echo "通过数量对应校验";break
		fi
	done
	# 开始写入
	dhcp_server_baseconfig
	if [ ${#macs[*]} -eq  1 ];then
		echo -e "host fantasia {\n  hardware ethernet ${macs[0]};\n  fixed-address ${ips[0]};\n}" >> tmp
	else
		for i in $(seq  ${#macs[*]});do
			echo -e "host fantasia$((i-1)) {\n  hardware ethernet ${macs[$i-1]};\n  fixed-address ${ips[$i-1]};\n}" >> tmp
		done
	fi
	cat tmp >> /etc/dhcp/dhcpd.conf
	# 写入完成
	rm -rf tmp
    systemctl restart dhcpd
    echo "检查服务开启状态"
    if ss -aunp | grep -q dhcp  #查看端口是否开启
    then
        echo -e "\e[32;1mDHCP服务保留地址配置写入并启动成功\n\e[0m"
    else
        echo "DHCP服务启动失败,请自行检查相关配置文件"
    fi
;;
3)
# dhcp超级作用域
	echo -e "\e[36m开始配置DHCP超级作用域\e[0m"
	dnf -y install dhcp-server 
    echo "应该已经完成dhcp-server安装了"
	echo -e "首先添加超级作用域,开始配置子网卡,即将进入修改网卡配置流程,\e[32;1m推荐提前配置好子网卡防止出现问题\e[0m"
	echo -e "配置示例:\n[ipv4]\nmethod=manual\naddress1=192.168.150.101/24\naddress2=192.168.160.101/24"
	read -ep "是否进入网卡配置修改(set_ens)流程(yes|no):" bool
	case $bool in 
	yes)
		echo "为保证流程正常进行,请确保输入正确,并在网卡配置流程最后选择自动重启网卡!"
		change_ip
		echo "修改网卡配置流程结束,开始DHCP服务配置"
	;;
	no)echo "跳过子网卡配置,请确保子网卡配置无误,开始DHCP服务配置";;
	esac
	open_ip_forward
	echo "抽取子网卡IP:"
	read -ep "请输入有子网卡的网卡名(NIC):" NIC
	routers=($(ip a|grep $NIC|awk 'NR>1{print $2}'|awk -F/ '{print $1}'))
	segments=($(ip a|grep $NIC|awk 'NR>1{print $2}'|awk -F/ '{print $1}'|awk -F. '{printf "%d.%d.%d.0\n",$1,$2,$3}'))
	echo -e "\e[32m抽取完成\e[0m获取地址池范围,并开始写入配置文件"
	# 开始写入
	dhcp_server_baseconfig
	echo "shared-network public {" >> tmp
	for i in $(seq 0 $((${#segments[@]}-1)))
	do
		echo -e "\tsubnet ${segments[$i]} netmask 255.255.255.0{" >> tmp
		read -ep "${segments[$i]}网段对应地址池范围(空格分隔):" range
		echo -e "\trange $range;" >> tmp
		echo -e "\toption routers ${routers[$i]};}" >> tmp
	done
	echo "}" >> tmp
	cat tmp >> /etc/dhcp/dhcpd.conf
	# 写入完成
	rm -rf tmp
    systemctl restart dhcpd
    echo "检查服务开启状态"
    if ss -aunp | grep -q dhcp  #查看端口是否开启
    then
        echo -e "\e[32;1mDHCP服务超级作用域配置写入并启动成功\n\e[0m"
    else
        echo "DHCP服务启动失败,请自行检查相关配置文件"
    fi
;;
4)
# dhcp中继服务 需要配合基础dhcp和手动修改
	echo "当前主要提供的是DHCP中继服务器服务配置,DHCP服务器配置可使用1选项做基础配置再手动添加额外的地址池"
	echo "在正式配置DHCP中继服务前,你需要明确知悉自己需要配置几张网卡,并且已添加网卡并启用相关配置(ip a可查)"
	read -ep "需要配置几个网段的中继服务(请输入一个整数):" times
	read -ep "是否进入网卡配置(set_ens)流程?(yes|no)" bool
	case $bool in 
	yes)
		echo "为保证流程正常进行,请确保输入正确,并在网卡配置流程最后选择自动重启网卡!"
		for i in $(seq $times)
		do
			change_ip
		done
		echo "修改网卡配置流程结束,开始DHCP中继服务配置"
	;;
	no)echo "跳过子网卡配置,请确保子网卡配置无误,开始DHCP中继服务配置";;
	esac
	dnf -y install dhcp-relay
	read -ep "请输入你的DHCP服务器IP地址:" DHCP_IP
	dhcrelay $DHCP_IP
	    echo "检查服务开启状态"
    if ss -aunp | grep -q dhcrelay  #查看端口是否开启
    then
        echo -e "\e[32;1mDHCP中继服务启动成功\n\e[0m"
    else
        echo "DHCP中继服务启动失败,请自行检查相关配置文件"
    fi
;;
*)error_printer;;
esac
}

# DNS设置 输入选项
function DNS_SET(){
case $1 in
1)
# 基础DNS
echo "开始基础DNS服务器配置"
echo "安装Berkeley Internet Name Daemon : 伯克利互联网域名服务(bind)"
dnf -y install bind
echo "开始修改主配置文件"
ipv4num=$(cat -n /etc/named.conf | egrep "listen-on port 53 { 127.0.0.1; };" | awk '{print $1}')
ipv6num=$((ipv4num+1))
querynum=$(cat -n /etc/named.conf | egrep "allow-query     { localhost; };" | awk '{print $1}')
sed -i ''$ipv4num's/127.0.0.1/any/g' /etc/named.conf
echo "监听所有ipv4网段"
sed -i ''$ipv6num's/::1/none/g' /etc/named.conf
echo "关闭ipv6网段"
sed -i ''$querynum's/localhost/any/g' /etc/named.conf
echo "允许所有请求"
color_printer g 主配置文件修改完成
echo "开始修改区域配置文件"
read -ep '需要1个还是2个正向记录文件(几个1+2级域名):' cnum
if [ "$cnum" -eq 1 ]
then
	sed -i '23,34d' /etc/named.rfc1912.zones
	sed -i '28,33d' /etc/named.rfc1912.zones
	read -ep '请输入二级+一级域名:' domainname
	read -ep '请输入倒序网段(50.168.192):' domainnameip
	sed -i '17s/localhost.localdomain/'$domainname'/g' /etc/named.rfc1912.zones
	sed -i '23s/1.0.0.127/'$domainnameip'/g' /etc/named.rfc1912.zones
	color_printer g 区域配置文件修改完毕!

	domainnameip=$(ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2}' | awk -F/ '{print $1}' | awk -F. -v seg="$(echo "${domainnameip}"|awk -F. '{print $3"."$2"."$1}')" '$1"."$2"."$3 == seg {print $1"."$2"."$3"."$4}')

	echo "开始修改资源记录(数据)文件"
	echo "注意下面的内容一定不能输错!"
	read -ep '请输入所有的(只要3级域名)3级域名(空格分隔):' -a domainname3
	read -ep '请输入所有的完整IP地址(需要与上方完全对应,同样空格分隔):' -a allip
	sed -i '2c @	IN SOA	'"$domainname"'. rname.invalid. (' /var/named/named.localhost
	sed -i '10d' /var/named/named.localhost
	sed -i '8s/@/dns.'"$domainname"'./g' /var/named/named.localhost
	sed -i '9c dns\tA\t'"$domainnameip"'' /var/named/named.localhost
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '9a '"${domainname3[$i]}"'\tA\t'"${allip[$i]}"'' /var/named/named.localhost
	done

	sed -i '2c @	IN SOA	'"$domainname"'. rname.invalid. (' /var/named/named.loopback
	sed -i '9,11d' /var/named/named.loopback
	sed -i '8s/@/dns.'"$domainname"'./g' /var/named/named.loopback
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '8a '"$(echo "${allip[$i]}" | awk -F. '{print $NF}')"'\tPTR\t'"${domainname3[$i]}.$domainname."'' /var/named/named.loopback
	done

elif [ "$cnum" -eq 2 ]
then
	sed -i '40,45d' /etc/named.rfc1912.zones
	sed -i '29,34d' /etc/named.rfc1912.zones
	read -ep '请输入二级+一级域名(两个用空格分开):' -a domainname
	read -ep '请输入倒序网段(50.168.192):' domainnameip
	sed -i '17s/localhost.localdomain/'"${domainname[0]}"'/g' /etc/named.rfc1912.zones
	sed -i '23s/localhost/'"${domainname[1]}"'/g' /etc/named.rfc1912.zones
	sed -i '25s/named.localhost/named1.localhost/g' /etc/named.rfc1912.zones
	sed -i '29s/1.0.0.127/'$domainnameip'/g' /etc/named.rfc1912.zones
	color_printer g 区域配置文件修改完毕!
	\cp -a /var/named/named.localhost /var/named/named1.localhost 
	
	domainnameip=$(ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2}' | awk -F/ '{print $1}' | awk -F. -v seg="$(echo "${domainnameip}"|awk -F. '{print $1"."$2"."$3}')" '$1"."$2"."$3 == seg {print $1"."$2"."$3"."$4}')

	echo "开始配置第1个资源记录文件,请按要求输入"
	echo "注意下面的内容一定不能输错!"
	read -ep '请输入所有的(只要3级域名)3级域名(空格分隔):' -a domainname3
	read -ep '请输入所有的完整IP地址(需要与上方完全对应,同样空格分隔):' -a allip
	sed -i '2c @	IN SOA	'"${domainname[0]}"'. rname.invalid. (' /var/named/named.localhost
	sed -i '10d' /var/named/named.localhost
	sed -i '8s/@/dns.'"${domainname[0]}"'./g' /var/named/named.localhost
	sed -i '9c dns\tA\t'"$domainnameip"'' /var/named/named.localhost
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '9a '"${domainname3[$i]}"'\tA\t'"${allip[$i]}"'' /var/named/named.localhost
	done

	sed -i '2c @	IN SOA	'"${domainname[0]}"'. rname.invalid. (' /var/named/named.loopback
	sed -i '9,11d' /var/named/named.loopback
	sed -i '8s/@/dns.'"${domainname[0]}"'./g' /var/named/named.loopback
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '8a '"$(echo "${allip[$i]}" | awk -F. '{print $NF}')"'\tPTR\t'"${domainname3[$i]}.${domainname[0]}."'' /var/named/named.loopback
	done

	echo "开始配置第2个资源记录文件,请按要求输入"
	echo "注意下面的内容一定不能输错!"
	read -ep '请输入所有的3级域名(空格分隔):' -a domainname3
	read -ep '请输入所有的完整IP地址(需要与上方完全对应,同样空格分隔):' -a allip
	sed -i '2c @	IN SOA	'"${domainname[1]}"'. rname.invalid. (' /var/named/named1.localhost
	sed -i '10d' /var/named/named1.localhost
	sed -i '8s/@/dns.'"${domainname[1]}"'./g' /var/named/named1.localhost
	sed -i '9c dns\tA\t'"$domainnameip"$'' /var/named/named1.localhost
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '9a '"${domainname3[$i]}"'\tA\t'"${allip[$i]}"'' /var/named/named1.localhost
	done

	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '8a '"$(echo "${allip[$i]}" | awk -F. '{print $NF}')"'\tPTR\t'"${domainname3[$i]}.${domainname[1]}."'' /var/named/named.loopback
	done

else
	error_printer
fi
echo -e "\e[32m解析记录文件修改完毕!\e[0m"
echo "启动服务"
systemctl restart named

check_service_status named DNS
;;
2)
# DNS主从
	read -ep "请输入选项，当前主机要配置的是主服务器还是从服务器((master|m|)(slave|s)):" m_s
	case $m_s in 
	master|m)
	echo "开始DNS主服务器配置"
	echo "安装Berkeley Internet Name Daemon : 伯克利互联网域名服务(bind)"
	dnf -y install bind
	echo "开始修改主配置文件"
	ipv4num=$(cat -n /etc/named.conf | egrep "listen-on port 53 { 127.0.0.1; };" | awk '{print $1}')
	ipv6num=$((ipv4num+1))
	querynum=$(cat -n /etc/named.conf | egrep "allow-query     { localhost; };" | awk '{print $1}')
	sed -i ''$ipv4num's/127.0.0.1/any/g' /etc/named.conf
	echo "监听所有ipv4网段"
	sed -i ''$ipv6num's/::1/none/g' /etc/named.conf
	echo "关闭ipv6网段"
	sed -i ''$querynum's/localhost/any/g' /etc/named.conf
	echo "允许所有请求"
	color_printer g 主配置文件修改完成

	echo "开始修改区域配置文件"
	sed -i '23,34d' /etc/named.rfc1912.zones
	sed -i '28,33d' /etc/named.rfc1912.zones
	read -ep '请输入二级+一级域名:' domainname
	read -ep '请输入倒序网段(50.168.192):' domainnameip
	read -ep '请输入从服务器IP地址(192.168.50.100):' slaveip
	sed -i '17s/localhost.localdomain/'$domainname'/g' /etc/named.rfc1912.zones
	sed -i '23s/1.0.0.127/'$domainnameip'/g' /etc/named.rfc1912.zones
	sed -i '20s/none/'$slaveip'/g' /etc/named.rfc1912.zones
	sed -i '26s/none/'$slaveip'/g' /etc/named.rfc1912.zones
	sed -i '20a also-notify {'$slaveip'; };' /etc/named.rfc1912.zones
	sed -i '21s/^/\t/' /etc/named.rfc1912.zones
	sed -i '27a also-notify {'$slaveip'; };' /etc/named.rfc1912.zones
	sed -i '28s/^/\t/' /etc/named.rfc1912.zones
	color_printer g 区域配置文件修改完毕!

	domainnameip=$(ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2}' | awk -F/ '{print $1}' | awk -F. -v seg="$(echo "${domainnameip}"|awk -F. '{print $3"."$2"."$1}')" '$1"."$2"."$3 == seg {print $1"."$2"."$3"."$4}')

	echo "开始修改资源记录(数据)文件"
	echo "注意下面的内容一定不能输错!"
	read -ep '请输入所有的(只要3级域名)3级域名(空格分隔):' -a domainname3
	read -ep '请输入所有的完整IP地址(需要与上方完全对应,同样空格分隔):' -a allip
	sed -i '2c @	IN SOA	'"$domainname"'. rname.invalid. (' /var/named/named.localhost
	sed -i '10d' /var/named/named.localhost
	sed -i '8s/@/dns.'"$domainname"'./g' /var/named/named.localhost
	sed -i '9c dns\tA\t'"$domainnameip"'' /var/named/named.localhost
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '9a '"${domainname3[$i]}"'\tA\t'"${allip[$i]}"'' /var/named/named.localhost
	done

	sed -i '2c @	IN SOA	'"$domainname"'. rname.invalid. (' /var/named/named.loopback
	sed -i '9,11d' /var/named/named.loopback
	sed -i '8s/@/dns.'"$domainname"'./g' /var/named/named.loopback
	for i in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '8a '"$(echo "${allip[$i]}" | awk -F. '{print $NF}')"'\tPTR\t'"${domainname3[$i]}.$domainname."'' /var/named/named.loopback
	done
	color_printer g 解析记录文件修改完毕!
	echo "启动服务"
	systemctl restart named

	check_service_status named DNS主服务器
	;;
	slave|s)
	echo "开始DNS从服务器配置"
	echo "安装Berkeley Internet Name Daemon : 伯克利互联网域名服务(bind)"
	dnf -y install bind
	echo "开始修改主配置文件"
	ipv4num=$(cat -n /etc/named.conf | egrep "listen-on port 53 { 127.0.0.1; };" | awk '{print $1}')
	ipv6num=$((ipv4num+1))
	querynum=$(cat -n /etc/named.conf | egrep "allow-query     { localhost; };" | awk '{print $1}')
	sed -i ''$ipv4num's/127.0.0.1/any/g' /etc/named.conf
	echo "监听所有ipv4网段"
	sed -i ''$ipv6num's/::1/none/g' /etc/named.conf
	echo "关闭ipv6网段"
	sed -i ''$querynum's/localhost/any/g' /etc/named.conf
	echo "允许所有请求"
	color_printer g 主配置文件修改完成

	echo "开始修改区域配置文件"
	sed -i '17,45d' /etc/named.rfc1912.zones
	read -ep '请输入二级+一级域名:' domainname
	read -ep '请输入倒序网段(50.168.192):' domainnameip
	read -ep '请输入主服务器IP地址(192.168.50.100):' masterip
	echo -e "zone \"$domainname\" IN {\n\ttype slave;\n\tmasters {$masterip; };\n\tmasterfile-format text;\n\tfile \"slaves/named.localhost\";\n};\n " >> /etc/named.rfc1912.zones
	echo -e "zone \"$domainnameip.in-addr.arpa\" IN {\n\ttype slave;\n\tmasters {$masterip; };\n\tmasterfile-format text;\n\tfile \"slaves/named.loopback\";\n}; " >> /etc/named.rfc1912.zones
	color_printer g 区域配置文件修改完毕!
	systemctl restart named

	check_service_status named DNS从服务器
	;;
	*)error_printer;;
	esac
;;
3)
# DNS缓存服务器
echo "开始DNS缓存服务配置"
dnf -y install dnsmasq
read -ep "请输入主DNS服务器的IP:" dnsip
sed -i '66d' /etc/dnsmasq.conf
sed -i '65a server='$dnsip'' /etc/dnsmasq.conf
sed -i '108s/lo/ens160/g' /etc/dnsmasq.conf
sed -i '575d' /etc/dnsmasq.conf
sed -i '574a cache-size=15000' /etc/dnsmasq.conf
systemctl restart dnsmasq 

check_service_status dnsmasq DNS缓存
;;
4)
# DNS智能解析
echo "开始DNS智能解析服务器配置"
echo "安装Berkeley Internet Name Daemon : 伯克利互联网域名服务(bind)"
dnf -y install bind
echo "开始修改主配置文件"
ipv4num=$(cat -n /etc/named.conf | egrep "listen-on port 53 { 127.0.0.1; };" | awk '{print $1}')
ipv6num=$((ipv4num+1))
querynum=$(cat -n /etc/named.conf | egrep "allow-query     { localhost; };" | awk '{print $1}')
sed -i ''$ipv4num's/127.0.0.1/any/g' /etc/named.conf
echo "监听所有ipv4网段"
sed -i ''$ipv6num's/::1/none/g' /etc/named.conf
echo "关闭ipv6网段"
sed -i ''$querynum's/localhost/any/g' /etc/named.conf
echo "允许所有请求"
sed -i '57d' /etc/named.conf
sed -i '52,56d' /etc/named.conf
echo "删除默认的区域配置文件"
read -ep "请输入DNS智能解析作用于的两个网段(空格分隔,例192.168.51.0 192.168.15.0):" -a segment
cat <<EOF  >> /etc/named.conf
view lan{
	match-clients{${segment[0]}/24;};
    zone "." IN {
        type hint;
        file "named.ca";
    };
    include "/etc/lan.zones";
};
view wan{
    match-clients{${segment[1]}/24;};
    zone "." IN {
        type hint;
        file "named.ca";
    };
    include "/etc/wan.zones";
};
EOF
color_printer g 主配置文件修改完成

read -ep "请输入需要分离解析的域名(二级+一级域名,例reeskysui.xyz):" dn
cat <<EOF >> /etc/lan.zones
zone "$dn" IN {
    type master;
    file "lan.localhost";
    allow-update {none;};
};
zone "$(echo ${segment[0]} | awk -F. '{print $3"."$2"."$1}').in-addr.arpa" IN {
    type master;
    file "lan.loopback";
    allow-update {none;};
};
EOF
cat <<EOF >> /etc/wan.zones
zone "$dn" IN {
    type master;
    file "wan.localhost";
    allow-update {none;};
};
zone "$(echo ${segment[1]} | awk -F. '{print $3"."$2"."$1}')2.in-addr.arpa" IN {
    type master;
    file "wan.loopback";
    allow-update {none;};
};
EOF
color_printer g 区域配置文件修改完毕!

\cp -a /var/named/named.localhost /var/named/lan.localhost
\cp -a /var/named/named.localhost /var/named/wan.localhost
\cp -a /var/named/named.loopback /var/named/lan.loopback
\cp -a /var/named/named.loopback /var/named/wan.loopback

for i in  0 1
do
	if [ "$i" -eq 0 ];then
		array=(/var/named/lan.localhost /var/named/lan.loopback)
	elif [ "$i" -eq 1 ];then
		array=(/var/named/wan.localhost /var/named/wan.loopback)
	fi
	echo "开始修改${segment[$i]}资源记录(数据)文件:${array[*]}"
	echo "注意下面的内容一定不能输错!"
	read -ep '请输入所有的(只要3级域名)3级域名(空格分隔):' -a domainname3
	read -ep '请输入所有的完整IP地址(需要与上方完全对应,同样空格分隔):' -a allip

	domainnameip=$(ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2}' | awk -F/ '{print $1}' | awk -F. -v seg="$(echo "${segment[$i]}"|awk -F. '{print $1"."$2"."$3}')" '$1"."$2"."$3 == seg {print $1"."$2"."$3"."$4}')

	sed -i '2c @	IN SOA	'"$dn"'. rname.invalid. (' ${array[0]}
	sed -i '10d' ${array[0]}
	sed -i '8s/@/dns.'"$dn"'./g' ${array[0]}
	sed -i '9c dns\tA\t'"$domainnameip"'' ${array[0]}
	for j in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '9a '"${domainname3[$j]}"'\tA\t'"${allip[$j]}"'' ${array[0]}
	done

	sed -i '2c @	IN SOA	'"$dn"'. rname.invalid. (' ${array[1]}
	sed -i '9,11d' ${array[1]}
	sed -i '8s/@/dns.'"$dn"'./g' ${array[1]}
	for j in $(seq 0 "$((${#domainname3[@]}-1))")
	do
		sed -i '8a '"$(echo "${allip[$j]}" | awk -F. '{print $NF}')"'\tPTR\t'"${domainname3[$j ]}.$dn."'' ${array[1]}
	done
done
color_printer g 解析记录文件修改完毕!

echo "启动DNS智能解析服务"
systemctl restart named
check_service_status named DNS智能解析
;;
*)error_printer;;
esac
}


# SSH免密互通配置 需要每台都运行
function SSH_SET(){
# ssh免密互通配置 需要每台都运行
countdown ",开始自动化配置ssh免密登录,本流程主要为了实现局域网内虚拟机免密互通,注意需要所有虚拟机均需运行,才可免密互通" 5
#安装所需环境
dnf -y install sshpass
# 生成密钥对
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
IPS=()
VLAN=192.168.50
# 手动输入局域网内的IP范围（可包含本机）
read -p "局域网内需要设置的的IP网段(例192.168.50):"  VLAN

# 扫描局域网内的IP
IPS=$(nmap -sn $VLAN.0/24 | grep 'Nmap scan report' | awk '{print $5}')
# 分发本地公钥到其他主机
for IP in $IPS
do
	sshpass -p '' ssh -o StrictHostKeyChecking=no root@$IP
	sshpass -p '123456' ssh-copy-id -i /root/.ssh/id_rsa.pub root@$IP
done
systemctl restart sshd

color_printer r !!!绝对不要在一个终端上重复运行多次ssh免密功能,会导致终端进入多层ssh!!!
}

# FTP设置 输入选项
function FTP_SET(){
countdown "开始安装vsftpd" 3
dnf -y install vsftpd
case $1 in 
1)
echo "进入配置ftp本地用户工作流"
echo "1.创建本地用户"
read -ep "请输入本地用户名称:" parameter1
read -ep "请输入本地用户家目录(共享目录位置/share):" parameter2
read -ep "请输入${parameter1}用户密码:" parameter3
useradd -d "$parameter2" -s /sbin/nologin  "$parameter1"
echo "$parameter3" | passwd --stdin $parameter1

echo "2.检查nologin的shell类型是否已添加到shells文件中"
if cat /etc/shells | grep -q /sbin/nologin
then
	echo "已添加,进行下一步"
else
	echo "未添加,自动添加"
	echo "/sbin/nologin" >> /etc/shells
	echo "自动添加完成,进行下一步"
fi

echo "3.禁锢用户家目录,允许读写权限"
sed -i '100s/#//' /etc/vsftpd/vsftpd.conf
sed -i '100a allow_writeable_chroot=YES' /etc/vsftpd/vsftpd.conf

echo "配置修改完成,尝试启动服务"
systemctl restart vsftpd
check_service_status vsftpd vsftpd本地用户配置及
;;
2)
echo 进入配置ftp"匿名用户工作流"
echo "开启匿名用户模式"
sed -i '12s/NO/YES/' /etc/vsftpd/vsftpd.conf
echo "设置上传权限"
sed -i '28s/#//' /etc/vsftpd/vsftpd.conf
echo "设置创建目录权限"
sed -i '32s/#//' /etc/vsftpd/vsftpd.conf
echo "设置上传后文件或创建目录后的默认权限,设置其他写入权限"
sed -i '22a anon_umask=022\nanon_other_write_enable=YES' /etc/vsftpd/vsftpd.conf
echo "增设目录权限"
setfacl -m u:ftp:rwx /var/ftp/pub

echo "配置修改完成,尝试启动服务"
systemctl restart vsftpd
check_service_status vsftpd vsftpd匿名用户配置及
echo -e "注意:\n匿名用户用户名:ftp|anonymous\n密码不校验\n工作目录:/var/ftp\n另外要保证SELinux关闭\n匿名用户不可以拥有ftp根目录的写权限但可以拥有pub下的多有权限"
;;
3)
echo "进入配置ftp虚拟用户工作流"
echo "1.创建本地代理用户"
read -ep "请输入代理用户名称:" parameter1
read -ep "请输入代理用户家目录(共享目录位置/share):" parameter2
useradd -d "$parameter2" -s /sbin/nologin  "$parameter1"

echo "2.创建下级目录,工作空间=$parameter2"
read -ep "请输入下级目录名称(多个用空格分隔不需要加/):" parameter_dirs
if [ -z "$parameter_dirs" ]
then
echo "无下级目录"
else
	for i in $parameter_dirs
	do
		echo "创建目录$parameter2/$i"
		mkdir "$parameter2/$i"
	done
fi
echo "修改目录权限"
chmod 755 "$parameter2"
chown -R $parameter1:$parameter1 $parameter2

echo "3.创建虚拟用户"
dnf -y install libdb-utils
touch /etc/vsftpd/user.list
mkdir /etc/vsftpd/virtual_config
counter=0
while :
do
	 let counter+=1
	echo "♻️循环获取虚拟用户账密,当用户名输入为空时停止,当前是第${counter}个虚拟用户"
	read -ep "请输入虚拟用户名称:" virtualname
	read -ep "请输入虚拟用户密码:" virtualpasswd
	if [ -z $virtualname ]
	then
		break
	else
		echo "$virtualname" >> /etc/vsftpd/user.list
		echo "$virtualpasswd" >> /etc/vsftpd/user.list
		echo -e "已向/etc/vsftpd/user.list中写入\n$virtualname\n$virtualpasswd"
		touch /etc/vsftpd/virtual_config/$virtualname
	fi
done
echo "虚拟用户创建结束,转换数据库文件user.db"
db_load -T -t hash -f /etc/vsftpd/user.list /etc/vsftpd/user.db
chmod 600 /etc/vsftpd/user.*
echo "修改pam校验文件"
sed -i '2,8d' /etc/pam.d/vsftpd
echo -e "\tauth    required pam_userdb.so  db=/etc/vsftpd/user\n\taccount required pam_userdb.so  db=/etc/vsftpd/user" >> /etc/pam.d/vsftpd

echo "4.设置虚拟用户权限"
echo "所有虚拟用户默认拥有下载权限"
color_printer r "注意用户名顺序可能不一致"
for i in /etc/vsftpd/virtual_config/*
do
	echo "虚拟用户$(echo $i|awk -F/ '{print $NF}')权限设置"
    # #能上传文件
	read -ep "是否需要上传权限y|n:" yon
	if [ "$yon" == y ];then echo "anon_upload_enable=YES" >> $i;fi
	# #能创建文件夹
	read -ep "是否需要创建文件夹权限y|n:" yon
	if [ "$yon" == y ];then echo "anon_mkdir_write_enable=YES" >> $i;fi
    # #其他写入权限，如：改名、删除
	read -ep "是否需要其他写入权限y|n:" yon
	if [ "$yon" == y ];then echo "anon_other_write_enable=YES" >> $i;fi
    # #设置此用户的默认登录点，shares目录是最大的目录，里面可以设置子目录
	read -ep "修改默认登录点为(不需要则留空回车即可,只写子目录不需要加/):" dir
	if [ -n "$dir" ];then 
		echo "local_root=$parameter2/$dir" >> $i
	fi
done

echo "5.修改主配置文件"
echo "anon_umask=022
guest_enable=YES
guest_username=$parameter1
chroot_local_user=YES
allow_writeable_chroot=YES
user_config_dir=/etc/vsftpd/virtual_config
" >> /etc/vsftpd/vsftpd.conf
read -ep "请输入被动模式获取的最小和最大端口(最小最大空格分隔40000 50000,若不需要留空回车↩︎跳过):" -a min_max_port
if [ -z "$min_max_port" ]
then 
	echo "不设置被动模式端口范围"
else
	echo "pasv_min_port=${min_max_port[0]}" >> /etc/vsftpd/vsftpd.conf
	echo "pasv_max_port=${min_max_port[1]}"	>> /etc/vsftpd/vsftpd.conf
fi

echo "配置修改完成,尝试启动服务"
systemctl restart vsftpd
check_service_status vsftpd vsftpd虚拟用户配置及
;;
*)error_printer;;
esac
}


# NFS设置 直接调用
function NFS_SET(){
dnf -y install rpcbind nfs-utils
read -ep "请输入要共享的目录路径(绝对路径,多个用空格分隔):" dirs
for i in $dirs
do
	echo "请根据下方提示输入 ${i} 目录所共享的相关设置" 
	read -ep "请输入共享目录所共享IP或网段(网段需要加掩码/24):" ips
	read -ep "请输入共享目录访问权限(ro|rw):" ro_w
	read -ep "请输入共享目录同步选项(sync|asyns):" sync
	read -ep "请输入共享目录用户映射选项(root_squash|no_root_squash|all_squash):" squash
	if [ "$squash" == "all_squash" ]
	then
		echo -e "USERLIST\nusername\tuid\tgid\n$(cat /etc/passwd|awk -F: '{print $1"\t"$3"\t"$4}')" | draw_table -1
		read -ep "请根据上表输入共享目录映射用户uid:" anonuid
		read -ep "请根据上表输入共享目录映射用户gid:" anongid
		echo "$i $ips($ro_w,$sync,$squash,anonuid=$anonuid,anongid=$anongid)" >> /etc/exports
	else
		echo "$i $ips($ro_w,$sync,$squash)" >> /etc/exports
	fi
	[ ! -d  "$i" ] && mkdir -p $i
done
echo "配置完成,尝试重启NFS相关服务"
systemctl restart rpcbind
systemctl restart nfs-server

check_service_status rpcbind RPC-NFS
}

# Rsync配置 需要libs文件中的inotify
function RSYNC_SET(){
echo "进入rsync服务配置工作流"
echo -e "\e[31m注意:\n\e[33m本服务需要本机和目标主机ssh免密,若没有配置过ssh免密可能导致,工作流结尾出现未知错误\e[0m"
dnf -y install gcc gcc-c++ rsync
cd ./libs/inotify-tools-3.14/
./configure
make && make install
if [ "$(echo $?)" == 0 ]
then 
	color_printer g minotify-tools安装成功
	cd /root/
	read -ep "请输入需要实时同步的目录绝对路径:" rsync_dir
	read -ep "请输入需要实时同步到的备份目录绝对路径(IP:/dir):" rsync_todir
	read -ep "是否需要完全同步y|n:" yon1
	read -ep "是否需要保留原文件夹(只保留子文件)y|n:" yon2
	[ "$yon1" == "y" ] && yon1=--delete || yon1=""
	[ "$yon2" == "y" ] && yon2=/ || yon2=""

	echo -e "#!/bin/bash\n. /etc/profile\n. ~/.bash_profile\n" > rsync.bak
	echo -e "inotifywait -mrq -e create,delete,modify $rsync_dir | while read events\ndo" >> rsync.bak
	echo -e "\trsync -avz $yon1 $rsync_dir$yon2 root@$rsync_todir &> /dev/null\ndone" >> rsync.bak

	chmod +x rsync.bak
	echo "nohup /root/rsync.bak &" >> /etc/rc.local
	chmod +x /etc/rc.d/rc.local

	echo "已自动添加开机自启,若不需要可以自行删除/etc/rc.local中的nohup /root/rsync.bak &行"
	color_printer r "即将启动实时同步脚本,在开启前请先确认目标主机安装好rsync服务,按下回车继续"
	read null

	nohup /root/rsync.bak &> /dev/null &

	echo "检查服务开启状态"
	if ps aux | grep rsync.bak | grep -v grep
	then
		echo -e "\e[32;2m实时同步脚本启动成功\e[0m"
	else
		color_printer r 实时同步脚本启动失败,请自行检查相关配置文件
	fi
else
	color_printer r inotify-tools安装失败
	echo "工作流中断,请自行检查安装情况及相关文件"
fi
}


# APACHE  wordpress项目部署器 (后续补设置器)
function APACHE_SET(){
echo "APACHE - wordpress项目部署器"
echo "安装apache"
dnf -y install httpd php php-mysqli php-pdo
echo "自动创建wordpress目录,路径写到存放wordpress目录的路径即可"
read -ep "请输入需要部署wordpress项目的目录绝对路径:" pdir
\cp -a ./libs/wordpress-6.6.2-zh_CN.tar.gz $pdir
cd $dir
tar -zxf wordpress-6.6.2-zh_CN.tar.gz
[ -e "./wordpress" ]&&rm -rf wordpress-6.6.2-zh_CN.tar.gz
if mysql_operate "show databases;"|grep wordpress
then
	color_printer g wordpress数据库已存在
else
	read -ep "是否需要向MySQL中添加wordpress数据库:" bool
	[ "$bool" == "y" ]&&mysql_operate "create database wordpress;"
fi
read -ep "是否需要向MySQL中添加独立的wordpress(localhost)数据库用户:" bool
if [ "$bool" == "y" ];then
	read -ep "请输入MySQL用户名:" un
	read -ep "请输入MySQL用户密码:" up
	mysql_operate "create user '$un'@'localhost' identified by '$up'"
fi
color_printer g 相关配置完成,请自行启动相关服务,自动列出输入路径下的内容
ls $pdir
cd ~
}

# NGINX 设置器
function NGINX_SET(){
echo "目前该部分功能还为添加,等待作者更新"
}

# TOMCAT依赖解决和mypress项目部署器 (后续补设置器)
function TOMCAT_SET(){
echo "tomcat mysql-connector依赖解决和mypress项目部署器"
echo "安装tomcat"
dnf -y install tomcat
\cp -a ./libs/mysql-connector-java-5.1.24.jar /usr/share/tomcat/lib/
sed -i '17s/tomcat/root/' /lib/systemd/system/tomcat.service
echo "自动创建mypress目录,路径写到存放mypress目录的路径即可"
read -ep "请输入需要部署mypress项目的目录绝对路径:" pdir
\cp -a ./libs/mypress.war $pdir
cd $dir
unip mypress.war -d ./mypress/
[ -e "./mypress" ]&&rm -rf mypress.war

if mysql_operate "show databases;"|grep mypress
then
	color_printer g mypress数据库已存在
else
	read -ep "是否需要向MySQL中添加mypress数据库:" bool
	[ "$bool" == "y" ]&&mysql_operate "create database mypress;"
fi
read -ep "是否需要向MySQL中添加独立的mypress(localhost)数据库用户:" bool
if [ "$bool" == "y" ];then
	read -ep "请输入MySQL用户名:" un
	read -ep "请输入MySQL用户密码:" up
	mysql_operate "create user '$un'@'localhost' identified by '$up'"
fi
color_printer g 相关配置完成,请自行启动相关服务,自动列出输入路径下的内容
ls $pdir
cd ~
}


# MySQL设置 输入选项
function MYSQL_SET(){
# MySQL延迟同步 输入bool
function delay_set(){
if [ "$1" == "y" ]
then
	read -ep "请输入延迟同步时长(s):" delaytime
	mysql_operate "CHANGE MASTER TO MASTER_DELAY=$delaytime;"
	echo "完成延迟时长设置,可以在用 mysql -uroot -e 'show slave status\G;' | grep SQL_Delay: 查看延迟设置"
fi
}
# MySQL半同步设置 bool m|s
function semi_set(){
if [ "$1" == "y" ]
then
	if [ "$2" == "m" ]
	then
	sed -i '22a
	plugin_load_add = "semisync_master.so"
	rpl_semi_sync_master_enabled = 1
	rpl_semi_sync_master_timeout = 10000' /etc/my.cnf.d/mariadb-server.cnf
	elif [ "$2" == "m" ]
	then
	sed -i '22a
	plugin_load_add = "semisync_slave.so"
	rpl_semi_sync_slave_enabled = 1' /etc/my.cnf.d/mariadb-server.cnf
	fi
fi
}

echo "您已进去MySQL服务配置工作流,开始安装MySQL服务"
dnf -y install mariadb mariadb-server
case $1 in
1)
echo -e "主从结构可以搭配出多种结构,目前可配置:\n1.基础主-从\n2.一主多从(从-主-从)\n3.级联复制(主-从(主)-从)\n4.互为主从(主(从)-从(主))\
\n5.双活数据中心(主-从-主)\n另外在本部分的配置中还可以选择,是否开启延迟同步和半同步复制,但并不清楚兼容性如何,请谨慎选择!"
read -ep "请选择需要服务的对应序号:" num
case $num in
	1)
	# MySQL主从
	echo "您已选择配置基础主从结构MySQL服务,该结构需要两台主机,请将脚本在这两台主机上分别运行并选择不同的角色"
	read -ep "请输入当前主机角色(m|s):" mos
	if [ "$mos" == "m" ]
	then
		echo "当前主机角色选择为主"
		read -ep "是否需要设置半同步复制(y|n):" semi
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=1' /etc/my.cnf.d/mariadb-server.cnf
		semi_set $semi $mos
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		echo "创建数据库同步用户"
		read -ep "请输入自定义同步用户名:" sync_un
		read -ep "请输入自定义同步用户密码:" sync_pd
		mysql_operate "grant replication slave on *.* to '$sync_un'@'%' identified by '$sync_pd';"
		logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
		logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
		echo -e "请记录当前主服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n接下来,请在从服务器上运行脚本并按照提示信息输入对应内容"
		if [ "$semi" == "y" ]
		then
			echo "查看半同步状态"
			mysql_operate "show status like 'Rpl_semi_sync_master_status';"
		fi
	elif [ "$mos" == "s" ]
	then
		echo "当前主机角色选择为从"
		read -ep "是否需要设置延迟同步(y|n):" delay
		read -ep "是否需要设置半同步复制(y|n):" semi
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=2' /etc/my.cnf.d/mariadb-server.cnf
		semi_set $semi $mos
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		read -ep "请输入在主服务器定义的同步用户名:" sync_un
		read -ep "请输入在主服务器定义的同步用户密码:" sync_pd
		read -ep "请输入主服务器上提供的二进制文件名:" sync_bin
		read -ep "请输入主服务器上提供的偏移量:" sync_pos
		read -ep "请输入主服务器IP:" sync_ip
		mysql_operate "change master to master_host='$sync_ip',master_user='$sync_un',master_password='$sync_pd',master_log_file='$sync_bin',master_log_pos=$sync_pos;"
		delay_set $delay
		mysql_operate "start slave;"
		if mysql -uroot  -e "show slave status\G;" | egrep "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"
		then
			color_printer g IO线程和SQL线程启动成功,MySQL主从搭建完成
		else
			color_printer r IO线程和SQL线程启动失败,MySQL主从搭建失败
		fi
		if [ "$semi" == "y" ]
		then
			echo "查看半同步状态"
			mysql_operate "show status like 'Rpl_semi_sync_master_status';"
		fi
	else
		error_printer
	fi
	;;
	2)
	# MySQL一主多从
	echo "您已选择配置一主多从(从-主-从)结构MySQL服务,该结构最少需要3台主机(仅1台主,从可以多个不限数量),请将脚本在每台主机上分别运行并选择对应角色"
	read -ep "请输入当前主机角色(m|s):" mos
	if [ "$mos" == "m" ]
	then
		echo "当前主机角色选择为主"
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=1' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		echo "创建数据库同步用户"
		read -ep "请输入自定义同步用户名:" sync_un
		read -ep "请输入自定义同步用户密码:" sync_pd
		mysql_operate "grant replication slave on *.* to '$sync_un'@'%' identified by '$sync_pd';"
		logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
		logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
		echo -e "请记录当前主服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n接下来,请在从服务器上运行脚本并按照提示信息输入对应内容"
	elif [ "$mos" == "s" ]
	then
		echo "当前主机角色选择为从"
		read -ep "当前主机是第几台从主机:" slave_num
		let slave_num+=1
		read -ep "是否需要设置延迟同步(y|n):" delay
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id='$slave_num'' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		read -ep "请输入在主服务器定义的同步用户名:" sync_un
		read -ep "请输入在主服务器定义的同步用户密码:" sync_pd
		read -ep "请输入主服务器上提供的二进制文件名:" sync_bin
		read -ep "请输入主服务器上提供的偏移量:" sync_pos
		read -ep "请输入主服务器IP:" sync_ip
		mysql_operate "change master to master_host='$sync_ip',master_user='$sync_un',master_password='$sync_pd',master_log_file='$sync_bin',master_log_pos=$sync_pos;"
		delay_set $delay
		mysql_operate "start slave;"
		if mysql -uroot  -e "show slave status\G;" | egrep "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"
		then
			color_printer g IO线程和SQL线程启动成功,MySQL主从搭建完成
		else
			color_printer r IO线程和SQL线程启动失败,MySQL主从搭建失败
		fi
	else
		error_printer
	fi
	;;
	3)
	# MySQL主从从
	echo "您已选择配置级联复制(主-从(主)-从)结构MySQL服务,该结构最少需要3台主机(仅1台主,从可以多个不限数量),请将脚本在每台主机上分别运行并选择对应角色"
	read -ep "请输入当前主机角色(m|s):" mos
	if [ "$mos" == "m" ]
	then
		echo "当前主机角色选择为主"
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=1' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		echo "创建数据库同步用户"
		read -ep "请输入自定义同步用户名:" sync_un
		read -ep "请输入自定义同步用户密码:" sync_pd
		mysql_operate "grant replication slave on *.* to '$sync_un'@'%' identified by '$sync_pd';"
		logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
		logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
		echo -e "请记录当前主服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n接下来,请在从服务器上运行脚本并按照提示信息输入对应内容"
	elif [ "$mos" == "s" ]
	then
		echo "当前主机角色选择为从"
		read -ep "当前主机是第几台从主机:" slave_num
		let slave_id=$slave_num+1
		read -ep "当前主机是否需要作为主服务器使用(y|n):" bool

		read -ep "是否需要设置延迟同步(y|n):" delay
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id='$slave_id'' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		read -ep "请输入在主服务器定义的同步用户名:" sync_un
		read -ep "请输入在主服务器定义的同步用户密码:" sync_pd
		read -ep "请输入主服务器上提供的二进制文件名:" sync_bin
		read -ep "请输入主服务器上提供的偏移量:" sync_pos
		read -ep "请输入这台从主机的主服务器IP:" sync_ip
		mysql_operate "change master to master_host='$sync_ip',master_user='$sync_un',master_password='$sync_pd',master_log_file='$sync_bin',master_log_pos=$sync_pos;"
		delay_set $delay
		mysql_operate "start slave;"
		if mysql -uroot  -e "show slave status\G;" | egrep "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"
		then
			color_printer g IO线程和SQL线程启动成功,MySQL主从搭建完成
		else
			color_printer r IO线程和SQL线程启动失败,MySQL主从搭建失败
		fi
		if [ "$bool" == "y" ];then
			mysql_operate "grant replication slave on *.* to '$sync_un$slave_num'@'%' identified by '$sync_pd';"
			logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
			logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
			echo -e "请记录当前主(从)服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n同步用户名:$sync_un$slave_num\n同步用户密码:$sync_pd\n接下来,请在从服务器上运行脚本并按照提示信息输入对应内容"
		fi
	else
		error_printer
	fi
	;;
	4)
	# MySQL主主
	echo "您已选择配置互为主从(主(从)-从(主))结构MySQL服务,该结构需要2台主机,请将脚本在每台主机上分别运行"
	read -ep "请输入当前是第几台主机(1|2):" mos
	if [ "$mos" == "1" ]
	then
		echo "开始第一台主机配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=1' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '22a auto-increment-increment=2\nauto-increment-offset=1' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		echo "创建数据库同步用户"
		read -ep "请输入自定义同步用户名(syncer1)(不可重复):" sync_un
		read -ep "请输入自定义同步用户密码:" sync_pd
		mysql_operate "grant replication slave on *.* to '$sync_un'@'%' identified by '$sync_pd';"
		logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
		logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
		echo -e "请记录当前主服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n接下来,请在另一台主机上运行脚本并按照提示信息输入对应内容"

		color_printer y "请在第2台电脑运行完前面第一阶段后,再按下面提示输入"
		read -ep "请输入第2台主服务器定义的同步用户名(syncer2):" sync_un
		read -ep "请输入第2台主服务器定义的同步用户密码:" sync_pd
		read -ep "请输入第2台服务器上提供的二进制文件名:" sync_bin
		read -ep "请输入第2台服务器上提供的偏移量:" sync_pos
		read -ep "请输入第2台服务器的主服务器IP:" sync_ip
		# 设置器
		mysql_operate "change master to master_host='$sync_ip',master_user='$sync_un',master_password='$sync_pd',master_log_file='$sync_bin',master_log_pos=$sync_pos;"
		# 检查器
		if mysql -uroot  -e "show slave status\G;" | egrep "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"
		then
			color_printer g IO线程和SQL线程启动成功,MySQL主从搭建完成
		else
			color_printer r IO线程和SQL线程启动失败,MySQL主从搭建失败
		fi
		echo "若两台主机均显示主从搭建成功,则说明主主搭建成功"
	elif [ "$mos" == "2" ]
	then
		echo "开始第二台主机配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=2' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '22a auto-increment-increment=2\nauto-increment-offset=2' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		echo "创建数据库同步用户"
		read -ep "请输入自定义同步用户名(syncer2)(不可重复):" sync_un
		read -ep "请输入自定义同步用户密码:" sync_pd
		mysql_operate "grant replication slave on *.* to '$sync_un'@'%' identified by '$sync_pd';"
		logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
		logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
		echo -e "请记录当前主服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n接下来,请在另一台主机上运行脚本并按照提示信息输入对应内容"

		color_printer y "请在第1台电脑运行完前面第一阶段后,再按下面提示输入"
		read -ep "请输入第1台主服务器定义的同步用户名(syncer1):" sync_un
		read -ep "请输入第1台主服务器定义的同步用户密码:" sync_pd
		read -ep "请输入第1台服务器上提供的二进制文件名:" sync_bin
		read -ep "请输入第1台服务器上提供的偏移量:" sync_pos
		read -ep "请输入第1台服务器的主服务器IP:" sync_ip
		# 设置器
		mysql_operate "change master to master_host='$sync_ip',master_user='$sync_un',master_password='$sync_pd',master_log_file='$sync_bin',master_log_pos=$sync_pos;"
		# 检查器
		if mysql -uroot  -e "show slave status\G;" | egrep "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"
		then
			color_printer g IO线程和SQL线程启动成功,MySQL主从搭建完成
		else
			color_printer r IO线程和SQL线程启动失败,MySQL主从搭建失败
		fi
		echo "若两台主机均显示主从搭建成功,则说明主主搭建成功"
	else
		error_printer
	fi
	;;
	5)
	# MySQL双活数据中心(主主从)
	echo "您已选择配置双活数据中心(主主从)结构MySQL服务,该结构需要3台主机,请将脚本在每台主机上分别运行并选择对应角色"
	read -ep "请输入当前主机角色(m|s):" mos
	if [ "$mos" == "m" ]
	then
		echo "当前主机角色选择为主"
		read -ep "当前主机是第几台主-主机:" slave_num

		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id='$slave_num'' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		echo "创建数据库同步用户"
		read -ep "请输入自定义同步用户名(syncer)(不可重复):" sync_un
		read -ep "请输入自定义同步用户密码:" sync_pd
		mysql_operate "grant replication slave on *.* to '$sync_un'@'%' identified by '$sync_pd';"
		logfile=$(mysql_operate_return "show master status;"|awk '{print $5}')
		logpos=$(mysql_operate_return "show master status;"|awk '{print $6}')
		echo -e "请记录当前主服务器的\n二进制日志文件名:\n$logfile\n二进制文件偏移量:\n$logpos\n接下来,请在从服务器上运行脚本并按照提示信息输入对应内容"
	elif [ "$mos" == "s" ]
	then
		echo "当前主机角色选择为从"
		read -ep "是否需要设置延迟同步(y|n):" delay
		echo "开始配置服务"
		sed -i '20a log-bin=mysql-bin' /etc/my.cnf.d/mariadb-server.cnf
		sed -i '21a server-id=3' /etc/my.cnf.d/mariadb-server.cnf
		echo "配置修改完成,启动服务"
		systemctl restart mariadb
		check_service_status mariadbd MySQL
		color_printer y "下面输入两台主服务器的相关内容,每行的第一第二位(即每列)输入信息对应的主机要一致"
		read -ep "请输入两台主服务器定义的同步用户名():" -a sync_un
		read -ep "请输入两台主服务器定义的同步用户密码:" -a sync_pd
		read -ep "请输入两台主服务器上提供的二进制文件名:" -a sync_bin
		read -ep "请输入两台主服务器上提供的偏移量:" -a sync_pos
		read -ep "请输入两台主服务器IP:" -a sync_ip
		for i in 0 1
		do
			let num=$i+1
			mysql_operate "change master 'master$num' to master_host='${sync_ip[$i]}',master_user='${sync_un[$i]}',master_password='${sync_pd[$i]}',master_log_file='${sync_bin[$i]}',master_log_pos=${sync_pos[$i]};"
			
			mysql_operate "start slave 'master$num';"
			if mysql -uroot  -e "show slave 'master$num' status\G;" | egrep "Slave_IO_Running: Yes|Slave_SQL_Running: Yes"
			then
				color_printer g IO线程和SQL线程启动成功,MySQL主从搭建完成
			else
				color_printer r IO线程和SQL线程启动失败,MySQL主从搭建失败
			fi
		done
		delay_set $delay

	else
		error_printer
	fi
	;;
	*)
	error_printer
	;;
esac
;;
2)
# MySQL MGC
echo "开始配置MGC同步复制集群,安装galera插件"
dnf -y install mariadb-server-galera
read -ep "请输入要搭建MGC同步复制节点的所有IP(,分隔):" nodes
sed -i '28,34s/#//g' /etc/my.cnf.d/mariadb-server.cnf
sed -i '29c wsrep_provider=/usr/lib64/galera/libgalera_smm.so' /etc/my.cnf.d/mariadb-server.cnf
sed -i '30c wsrep_cluster_address="gcomm://'$nodes'"' /etc/my.cnf.d/mariadb-server.cnf
echo "相关配置已修改完成,请在其他MGC集群节点主机上运行脚本"
echo "自动扫描MGC集群节点端口"
for i in $(echo $nodes|sed 's/,/ /g')
do
	result=$(port_scanner $i 4567)
	[ "$result" -eq 0 ]&&break
done
if [ "$result" -eq 0 ];then
	systemctl start mariadb
else
	galera_new_cluster
fi
if ss -atnp|grep 3306 && ss -atnp|grep 4567
then
	color_printer g MGC集群服务启动成功
	echo "wrep集群状态"
	mysql -uroot -e "show status like '%wsrep%';" | egrep "wsrep_cluster_size|wsrep_connected"
else
	color_printer r MGC集群服务启动失败
fi

;;
3)
# MySQL中间件
echo "进入MySQL中间件配置工作流"
color_printer r "注意中间件配置需要局域网先有MySQL相关服务(主从从)"
countdown 安装maxscale中间件 3
dnf -y install ./libs/maxscale-24.02.5-1.rhel.9.x86_64.rpm
read -ep "请输入MySQL服务器完整IP地址(空格分隔,以从从主顺序):" ips
sed -i '114,117d' /etc/maxscale.cnf
sed -i '82,88d' /etc/maxscale.cnf
sed -i '21,24d' /etc/maxscale.cnf
counter=0
for i in $ips
do
let counter+=1
done
# echo $counter=
for i in $ips;do
sed -i '20a [server'$counter']\ntype=server\naddress='$i'\nport=3306' /etc/maxscale.cnf

let counter-=1
done
modify_num=$(nu_searcher "\[MariaDB-Monitor\]" /etc/maxscale.cnf)
server_num=$((modify_num+3))
user_num=$((modify_num+4))
passwd_num=$((modify_num+5))
interval_num=$((modify_num+6))
servers=server1
counter=0
for i in $ips
do
let counter+=1
done
for i in $(seq 2 $counter);do
servers=$servers,server$i
done
read -ep "请输入同步用户名:" username
read -ep "请输入同步用户名密码:" userpasswd
# read -ep "请输入监控间隔(s):" interval
sed -i ''$server_num'c servers='$servers'' /etc/maxscale.cnf
sed -i ''$user_num'c user='$username'' /etc/maxscale.cnf
sed -i ''$passwd_num'c password='$userpasswd'' /etc/maxscale.cnf
# sed -i ''$interval_num'c monitor_interval='$interval'' /etc/maxscale.cnf
modify_num=$(nu_searcher "\[Read-Write-Service\]" /etc/maxscale.cnf)
server_num=$((modify_num+3))
user_num=$((modify_num+4))
passwd_num=$((modify_num+5))
sed -i ''$server_num'c server='$servers'' /etc/maxscale.cnf
sed -i ''$user_num'c user='$username'' /etc/maxscale.cnf
sed -i ''$passwd_num'c password='$userpasswd'' /etc/maxscale.cnf
systemctl restart maxscale
check_service_status maxscale MySQL中间件
maxctrl list servers
echo "输入后方命令链接中间件:mysql -hmaxscale -P4006 -u$username -p$userpasswd"
;;
*)error_printer;;
esac
}

# redis设置 输入选项
function REDIS_SET(){
case $1 in
1)echo "暂时感觉没必要写,自行修改吧";;
2)
# redis主从从
echo "进入Redis主从从配置工作流"
echo "默认配置Redis主从从结构"
read -ep "请问3个实例需要部署在几台主机上(1|3):" num
echo "开始安装相关服务"
dnf -y install redis
echo "服务安装完成,开始配置相关文件"
if [ "$num" -eq 1 ] 
then
	read -ep "请输入本机IP(192.168.50.10):" ip
    read -ep "请输入主Redis实例端口:" master_port
    read -ep "请输入从Redis实例端口(空格分隔):" slave_ports
	read -ep "请输入相关配置(以及日志)文件存放位置的绝对路径(空目录/data):" path 
    for i in $master_port $slave_ports
	do
		mkdir -p $path/$i
		\cp -a /etc/redis/redis.conf $path/$i
		\cp -a /etc/redis/sentinel.conf $path/$i
	done
	for i in $path/*
	do
		port=$(echo $i|awk -F/ '{print $NF}')
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' $i/redis.conf
		sed -i '94s/yes/no/' $i/redis.conf
		sed -i '98s/6379/'$port'/' $i/redis.conf
		sed -i '259s/no/yes/' $i/redis.conf
		sed -i '291s:/var/run/redis_6379\.pid:'$i'/redis_'$port'\.pid:' $i/redis.conf
		sed -i '304s:/var/log/redis/redis\.log:'$i'/redis_'$port'\.log:' $i/redis.conf
		sed -i '456s:/var/lib/redis:'$i':' $i/redis.conf
		sed -i '1254s/no/yes/' $i/redis.conf
	done
	for i in $slave_ports;do 
		sed -i '479s:<masterip> <masterport>:'$ip' '$master_port':' $path/$i/redis.conf
		sed -i '479s:# ::' $path/$i/redis.conf
	done
	for i in $path/*
	do 
		redis-server $i/redis.conf
	done
	color_printer g 已启动Redis主从从服务
	echo -e "可以使用以下命令连接Redis数据库进行测试:\nredis-cli -h $ip \ninfo replication"

elif [ "$num" -eq 3 ] 
then 
	color_printer y 注意多台主机配置主从从,所有主机都需要运行
	read -ep "请输入本机IP(192.168.x.x):" ip
	read -ep "请问当前主机是主还是从?(m/s):" mos
    read -ep "请输入主Redis服务的IP:" master
	if [ "$mos" == "m" ]
	then
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' /etc/redis/redis.conf
		sed -i '94s/yes/no/' /etc/redis/redis.conf
		sed -i '259s/no/yes/' /etc/redis/redis.conf
		sed -i '1254s/no/yes/' /etc/redis/redis.conf
		systemctl restart redis
		echo "主服务启动成功"
	elif [ "$mos" == s ]
	then
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' /etc/redis/redis.conf
		sed -i '94s/yes/no/' /etc/redis/redis.conf
		sed -i '259s/no/yes/' /etc/redis/redis.conf
		sed -i '1254s/no/yes/' /etc/redis/redis.conf
		sed -i '479s:<masterip> <masterport>:'$master' 6379:' /etc/redis/redis.conf
		sed -i '479s:# ::' /etc/redis/redis.conf
		systemctl restart redis
		echo "从服务启动成功"
	fi
else
error_printer
fi
;;
3)
# redis哨兵
echo "进入Redis 哨兵配置工作流"
echo "默认配置Redis主从从结构"
read -ep "请问3个实例需要部署在几台主机上(1|3):" num
echo "开始安装相关服务"
dnf -y install redis
echo "服务安装完成,开始配置相关文件"
if [ "$num" -eq 1 ] 
then
	read -ep "请输入本机IP(192.168.50.10):" ip
    read -ep "请输入主Redis实例端口:" master_port
    read -ep "请输入从Redis实例端口(空格分隔):" slave_ports
	read -ep "请输入相关配置(以及日志)文件存放位置的绝对路径(空目录/data):" path 
    for i in $master_port $slave_ports
	do
		[ ! -e "$path" ] && mkdir -p $path/$i
		\cp -a /etc/redis/redis.conf $path/$i
		\cp -a /etc/redis/sentinel.conf $path/$i
	done
	for i in $path/*
	do
		port=$(echo $i|awk -F/ '{print $NF}')
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' $i/redis.conf
		sed -i '94s/yes/no/' $i/redis.conf
		sed -i '98s/6379/'$port'/' $i/redis.conf
		sed -i '259s/no/yes/' $i/redis.conf
		sed -i '291s:/var/run/redis_6379\.pid:'$i'/redis_'$port'\.pid:' $i/redis.conf
		sed -i '304s:/var/log/redis/redis\.log:'$i'/redis_'$port'\.log:' $i/redis.conf
		sed -i '456s:/var/lib/redis:'$i':' $i/redis.conf
		sed -i '1254s/no/yes/' $i/redis.conf
	done
	for i in $slave_ports;do 
		sed -i '479s:<masterip> <masterport>:'$ip' '$master_port':' $path/$i/redis.conf
		sed -i '479s:# ::' $path/$i/redis.conf
	done
	for i in $path/*
	do 
		redis-server $i/redis.conf
	done
	echo "已启动Redis主从从服务,开始配置Sentinel"
	for i in $path/*
	do
		port=$(echo $i|awk -F/ '{print $NF}')
		sed -i '21s/26379/2'$port'/' $i/sentinel.conf
		sed -i '26s/no/yes/' $i/sentinel.conf
		sed -i '31s:/var/run/redis-sentinel.pid:'$i'/redis-sentinel_'$port'.pid:' $i/sentinel.conf
		sed -i '36s:/var/log/redis/sentinel.log:'$i'/sentinel_'$port'.log:' $i/sentinel.conf
		sed -i '62s:/tmp:'$i':' $i/sentinel.conf
		# sed -i '67s:# ::' $i/sentinel.conf
		sed -i '84s:127.0.0.1 6379 2:'$ip' '$master_port' 2:' $i/sentinel.conf
	done
	for i in $path/*;do redis-sentinel $i/sentinel.conf;done
	echo "已启动Redis哨兵"
	echo "可以运行下方命令进入哨兵节点:"
	echo -e "redis-cli -h $ip -p 2$port\ninfo sentinel"
elif [ "$num" -eq 3 ] 
then 
	color_printer y 注意多台主机配置主从从哨兵结构会有两个阶段,需要3台主机同时进行完1阶段后,再进行第二个部分,请注意相关提示信息
	read -ep "请输入本机IP(192.168.x.x):" ip
	read -ep "请问当前主机是主还是从?(m/s):" mos
    read -ep "请输入主Redis服务的IP:" master
	if [ "$mos" == "m" ]
	then
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' /etc/redis/redis.conf
		sed -i '94s/yes/no/' /etc/redis/redis.conf
		sed -i '259s/no/yes/' /etc/redis/redis.conf
		sed -i '1254s/no/yes/' /etc/redis/redis.conf
		systemctl restart redis
		echo "主服务启动成功"
		read -ep "请确保其他所有主机从服务启动成功,输入任意键继续:"  continue
		if [ -n "$continue" ]
		then
			sed -i '84s:127.0.0.1 6379 2:'$master' 6379 2:' /etc/redis/sentinel.conf
		fi
		systemctl restart redis-sentinel
		echo "已启动Redis哨兵"
		echo "可以运行下方命令进入哨兵节点:"
		echo -e "redis-cli -h $ip -p 26379\ninfo sentinel"
	elif [ "$mos" == s ]
	then
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' /etc/redis/redis.conf
		sed -i '94s/yes/no/' /etc/redis/redis.conf
		sed -i '259s/no/yes/' /etc/redis/redis.conf
		sed -i '1254s/no/yes/' /etc/redis/redis.conf
		sed -i '479s:<masterip> <masterport>:'$master' 6379:' /etc/redis/redis.conf
		sed -i '479s:# ::' /etc/redis/redis.conf
		systemctl restart redis
		echo "从服务启动成功"
		read -ep "请确保其他所有主机服务启动成功,输入任意键继续:"  continue
		if [ -n "$continue" ]
		then
			sed -i '84s:127.0.0.1 6379 2:'$master' 6379 2:' /etc/redis/sentinel.conf
		fi
		systemctl restart redis-sentinel
		echo "已启动Redis哨兵"
		echo "可以运行下方命令进入哨兵节点:"
		echo -e "redis-cli -h $ip -p 26379\ninfo sentinel"
	fi
else
error_printer
fi
;;
4)
# redis集群
echo "进入Redis集群配置工作流"
read -ep "是否继续配置集群(非集群中第一台运行过的主机)y|n:" yon
if [ "$yon" == "y" ]
then
	read -ep "请输入本机是配置的第几台主机:" sec
	read -ep "请输入redis服务实例总数和节点数(6 3):" -a parameter
	read -ep "请输入要在本机上部署的实例个数(请保证个主机上实例个数均等)(2):" num
	
	instance=$((${parameter[0]}/${parameter[1]}))
	echo -e "Redis服务配置\n实例数:\t${parameter[0]}\n节点数:\t${parameter[1]}\n每节点对应实例数:\t${instance}\n1主$((instance-1))从*${parameter[1]}"

	echo "开始安装相关服务"
	dnf -y install redis
	echo "服务安装完成,开始配置相关文件"
	read -ep "请输入相关配置(以及日志)文件存放位置的绝对路径(空目录/data):" path 
	for i in $(seq 6374 $((6379+num-1)))
	do
		mkdir -p $path/$i
		\cp -a /etc/redis/redis.conf $path/$i
	done
	for i in $path/*
	do
		port=$(echo $i|awk -F/ '{print $NF}')
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' $i/redis.conf
		sed -i '94s/yes/no/' $i/redis.conf
		sed -i '98s/6379/'$port'/' $i/redis.conf
		sed -i '259s/no/yes/' $i/redis.conf
		sed -i '291s:/var/run/redis_6379\.pid:'$i'/redis_'$port'\.pid:' $i/redis.conf
		sed -i '304s:/var/log/redis/redis\.log:'$i'/redis_'$port'\.log:' $i/redis.conf
		sed -i '456s:/var/lib/redis:'$i':' $i/redis.conf
		sed -i '1254s/no/yes/' $i/redis.conf
		sed -i '1387s/# //' $i/redis.conf
		sed -i '1395s/# //' $i/redis.conf
		sed -i '1395s/nodes-6379\.conf/nodes-'$port'\.conf/' $i/redis.conf
		sed -i '1401s/# //' $i/redis.conf
	done
	for i in $path/*
	do
		redis-server $i/redis.conf
	done

	if [ "${parameter[0]}" -eq "$((num*sec))" ] 
	then
		tmp_ip=$(ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2}' | awk -F/ 'NR==1{print $1}')
		echo "本机ip为:$tmp_ip"
		cmd="redis-cli --cluster create --cluster-replicas $((instance-1))"
		for i in $(seq 6379 $((6379+num-1)))
		do
			cmd="${cmd} $tmp_ip:$i"
		done
		read -ep "请输入前$((sec-1))台主机的IP(空格分隔192.168.50.101 192.168.50.102):" tmp_ip
		for j in $tmp_ip
		do
			for i in $(seq 6379 $((6379+num-1)))
			do
				cmd="$cmd $j:$i"
			done
		done
		echo -e "${num}个实例全部配置完成,请输入以下命令开启机器:\n$cmd" 
	else
		echo "当前主机Redis实例已配置完成,请检查端口并在其他主机继续完成配置"
	fi


elif [ "$yon" == "n" ]
then
	read -ep "请输入redis服务实例总数和节点数(6 3):" -a parameter
	instance=$((${parameter[0]}/${parameter[1]}))
	echo -e "Redis服务配置\n实例数:\t\t${parameter[0]}\n节点数:\t\t${parameter[1]}\n每节点对应实例数:\t${instance}\n1主$((instance-1))从*${parameter[1]}"

	read -ep "请输入要在本机上部署的实例个数(2):" num

	echo "开始安装相关服务"
	dnf -y install redis
	echo "服务安装完成,开始配置相关文件"
	read -ep "请输入相关配置(以及日志)文件存放位置的绝对路径(空目录/data):" path 
	for i in $(seq 6374 $((6374+num-1)))
	do
		mkdir -p $path/$i
		\cp -a /etc/redis/redis.conf $path/$i
	done
	for i in $path/*
	do
		port=$(echo $i|awk -F/ '{print $NF}')
		sed -i '75s/127\.0\.0\.1 -::1/0\.0\.0\.0/' $i/redis.conf
		sed -i '94s/yes/no/' $i/redis.conf
		sed -i '98s/6379/'$port'/' $i/redis.conf
		sed -i '259s/no/yes/' $i/redis.conf
		sed -i '291s:/var/run/redis_6379\.pid:'$i'/redis_'$port'\.pid:' $i/redis.conf
		sed -i '304s:/var/log/redis/redis\.log:'$i'/redis_'$port'\.log:' $i/redis.conf
		sed -i '456s:/var/lib/redis:'$i':' $i/redis.conf
		sed -i '1254s/no/yes/' $i/redis.conf
		sed -i '1387s/# //' $i/redis.conf
		sed -i '1395s/# //' $i/redis.conf
		sed -i '1395s/nodes-6379\.conf/nodes-'$port'\.conf/' $i/redis.conf
		sed -i '1401s/# //' $i/redis.conf
	done
	for i in $path/*
	do
		redis-server $i/redis.conf
	done

	if [ "${parameter[0]}" -eq "$num" ] 
	then
		tmp_ip=$(ip a | egrep "^ *inet.*ens[0-9]+" | awk '{print $2}' | awk -F/ 'NR==1{print $1}')
		cmd="redis-cli --cluster create --cluster-replicas $((instance-1))"
		for i in $(seq 6379 $((6379+num-1)))
		do
			cmd="${cmd} $tmp_ip:$i"
		done
		echo -e "${num}个实例全部配置完成,请输入以下命令开启机器:\n$cmd" 
	else
		echo "当前主机Redis实例已配置完成,请检查端口并在其他主机继续完成配置"
	fi
else
error_printer
fi
;;
*)error_printer;;
esac
}

# extmail设置 直接调用
function MAIL_SET(){
echo "进入邮件服务配置工作流,自动化部署extmail项目"
echo "防止未安装数据库,先尝试安装MySQL并启动服务"
dnf -y install mariadb mariadb-server telnet
systemctl start mariadb

mysql < ./libs/extmail-r9/extmail-r9.sql
mysql < ./libs/extmail-r9/extman-1.1/docs/init.sql

echo "配置 POSTFIX 支持虚拟域(MTA,集成MDAmailbox)"
dnf -y install postfix postfix-mysql
\cp -a ./libs/extmail-r9/extman-1.1/docs/mysql_virtual_*  /etc/postfix
read -ep "请输入代理名称(例:vmail):" daili
read -ep "请输入代理uid(2000):" uid
read -ep "请输入代理家目录(/home/vmail):" jiamulu
useradd  -u $uid  -s  /sbin/nologin  -d $jiamulu  $daili

sed -i '132c inet_interfaces = all' /etc/postfix/main.cf
sed -i '135s/^/#/g' /etc/postfix/main.cf

echo "virtual_mailbox_base=$jiamulu
virtual_uid_maps=static:$uid
virtual_gid_maps=static:$uid" >>  /etc/postfix/main.cf

echo "virtual_alias_maps=mysql:/etc/postfix/mysql_virtual_alias_maps.cf
virtual_mailbox_domains=mysql:/etc/postfix/mysql_virtual_domains_maps.cf
virtual_mailbox_maps=mysql:/etc/postfix/mysql_virtual_mailbox_maps.cf" >> /etc/postfix/main.cf

systemctl restart postfix
check_service_status :25 postfix 

echo "配置 MRA(dovecot)"
dnf -y install dovecot dovecot-mysql
sed -i "24c mail_location = maildir:$jiamulu/%d/%n/Maildir" /etc/dovecot/conf.d/10-mail.conf
sed -i "178c first_valid_uid = $uid" /etc/dovecot/conf.d/10-mail.conf
sed -i '123s/#//g' /etc/dovecot/conf.d/10-auth.conf
cp -a /usr/share/doc/dovecot/example-config/dovecot-sql.conf.ext /etc/dovecot/
sed -i '32c driver = mysql' /etc/dovecot/dovecot-sql.conf.ext
sed -i "71c connect = host=localhost dbname=extmail user=extmail password=extmail" /etc/dovecot/dovecot-sql.conf.ext
sed -i '81s/#//g' /etc/dovecot/dovecot-sql.conf.ext
sed -i '110s/#//g' /etc/dovecot/dovecot-sql.conf.ext
sed -i '111s/#//g' /etc/dovecot/dovecot-sql.conf.ext
sed -i "112c FROM mailbox WHERE username = '%u' and domain = '%d'" /etc/dovecot/dovecot-sql.conf.ext
sed -i "128c user_query = SELECT maildir, $uid AS uid, $uid AS gid FROM mailbox WHERE username = '%u'" /etc/dovecot/dovecot-sql.conf.ext
systemctl restart dovecot

check_service_status dovecot dovecot

echo "配置web界面(apche)"
dnf -y install httpd

echo "检测虚拟主机配置文件是否存在"
read -p "请输入mail服务的三级域(默认extmail.org)(例:mail):" yuming
if [ -e  "/etc/httpd/conf.d/httpd-vhosts.conf" ]
then
echo "httpd服务虚拟主机配置文件存在,直接追加extmail.org域名虚拟主机(默认基于域名)"
echo "<VirtualHost *:80>
		ServerName $yuming.extmail.org
		DocumentRoot /var/www/extsuite/extmail/html/
		ScriptAlias /extmail/cgi /var/www/extsuite/extmail/cgi
		Alias /extmail /var/www/extsuite/extmail/html
		ScriptAlias /extman/cgi /var/www/extsuite/extman/cgi
		Alias /extman /var/www/extsuite/extman/html
		SuexecUserGroup $daili $daili
</VirtualHost>"  >>  /etc/httpd/conf.d/httpd-vhosts.conf

else
echo "httpd服务虚拟主机配置文件不存在,生成文件(默认基于域名)"
cp -a /usr/share/doc/httpd-core/httpd-vhosts.conf /etc/httpd/conf.d
sed  -i  '23,38d' /etc/httpd/conf.d/httpd-vhosts.conf
echo "<VirtualHost *:80>
			ServerName $yuming.extmail.org
			DocumentRoot /var/www/extsuite/extmail/html/
			ScriptAlias /extmail/cgi /var/www/extsuite/extmail/cgi
			Alias /extmail /var/www/extsuite/extmail/html
			ScriptAlias /extman/cgi /var/www/extsuite/extman/cgi
			Alias /extman /var/www/extsuite/extman/html
			SuexecUserGroup $daili $daili
</VirtualHost>"  >>  /etc/httpd/conf.d/httpd-vhosts.conf
fi



echo "apche虚拟主机部署项目"
mkdir  /var/www/extsuite
\cp -a ./libs/extmail-r9/extmail-1.2/  /var/www/extsuite/extmail
\cp -a ./libs/extmail-r9/extman-1.1/  /var/www/extsuite/extman

chown -R $daili:$daili  /var/www/extsuite/extmail/cgi
\cp -a /var/www/extsuite/extmail/webmail.cf.default  /var/www/extsuite/extmail/webmail.cf
sed -i "127c SYS_MAILDIR_BASE = $jiamulu" /var/www/extsuite/extmail/webmail.cf
sed -i "139c SYS_MYSQL_USER = extmail" /var/www/extsuite/extmail/webmail.cf
sed -i "140c SYS_MYSQL_PASS = extmail" /var/www/extsuite/extmail/webmail.cf

chown -R $daili:$daili /var/www/extsuite/extman/cgi
\cp -a  /var/www/extsuite/extman/webman.cf.default /var/www/extsuite/extman/webman.cf
sed -i "12c SYS_MAILDIR_BASE = $jiamulu" /var/www/extsuite/extman/webman.cf
sed -i '18c SYS_SESS_DIR = /tmp/' /var/www/extsuite/extman/webman.cf
sed -i '21c SYS_CAPTCHA_ON = 0' /var/www/extsuite/extman/webman.cf

echo "安装缺少的项目依赖(perl开发的)"
dnf -y install perl-CGI perl-core perl-Unix-Syslog perl-DBD-MySQL rrdtool-perl
sed -i '1c #!/usr/bin/perl -w' /var/www/extsuite/extmail/cgi/index.cgi

dnf -y install s-nail
echo "发送测试邮件,自动生成邮件目录"
echo "这是一封测试邮件" | mail -s "Test" postmaster@extmail.org
sleep 2
if [ -d "$jiamulu/extmail.org/postmaster/Maildir/" ]
then
	color_printer g 目录存在,测试成功
else
	color_printer r "目录未生成,配置可能出现未知问题,可以尝试查看相关日志: vim /var/log/maillog"
fi
echo "项目部署完毕,重启Apache"
systemctl restart httpd
check_service_status httpd Apache
}


# 主函数
clear
echo -e "Comprehensive Service Workflow
It is assumed that you have completed the basic configuration of the network services.
If you need to set it up, use BasicSettings Workflow to set it up.
▽ Enter the name of the following service to be configured ▽" | draw_table -1

echo -e "set_ens\tip_forward\tDHCP\tDNS\tSSH(nokey)\tFTP\tNFS\nRSYNC\tapache\tnginx(no)\ttomcat\tmysql\tredis\tmail" | draw_table -1

echo -e "\e[33m温馨提示:当前脚本鲁棒性不佳,请关注提示内容,输入预期的合理值!\e[0m"
echo -e "脚本设计:明关\nScriptDesigner:reeskysui"
read -ep "请选择需要配置的服务：" chioce

case $chioce in
set_ens)change_ip;;
ip_forward)open_ip_forward;;
DHCP|dhcp)
echo "温馨提示该部分内容暂时不支持运行多次或在一台机器上交替搭建,会导致配置文件出现重复配置"
echo "进入DHCP服务配置工作流"
echo -e "请选择搭建的DHCP服务类型:\n1.基础DHCP服务\n2.DHCP保留地址池\n3.超级作用域\n4.DHCP中继服务器" 
read -ep "请输入序号:" dhcp_chioce
DHCP_SET $dhcp_chioce
;;
DNS|dns)
echo "温馨提示该部分内容暂时不支持运行多次或在一台机器上交替搭建,会导致配置文件出现重复配置"
echo -e "请选择搭建的DNS服务类型:\n1.基础(主)DNS服务\n2.DNS主从服务器\n3.DNS缓存服务器\n4.智能DNS服务器" 
read -ep "请输入序号:" dns_chioce
DNS_SET $dns_chioce
;;
SSH|ssh)SSH_SET;;
FTP|ftp)
echo "进入VSFTP服务配置工作流"
echo -e "请选择VSFTP服务配置用户类型:\n1.本地用户\n2.匿名用户\n3.虚拟用户" 
read -ep "请输入序号:" ftp_chioce
FTP_SET	$ftp_chioce
echo "客户端需要安装ftp才能连接"
;;
NFS|nfs)
echo "进入NFS服务配置工作流"
echo -e "\e[31m注意:\n\e[33m客户端需要安装rpcbind nfs-utils才能连接nfs共享文件\e[0m"
NFS_SET
echo -e "查看服务器共享点:\nshowmount -e 服务器端ip"
;;
RSYNC|rsync)RSYNC_SET;;
apache)APACHE_SET;;
nginx)NGINX_SET;;
tomcat)TOMCAT_SET;;
mysql)
echo "温馨提示该部分内容暂时不支持运行多次或在一台机器上交替搭建,会导致配置文件出现重复配置"
echo "该部分流程涉及多台主机配置,目前脚本还没有远程操作的能力,所以还请到对应主机上运行相关内容!"
echo -e "请选择搭建的MySQL服务类型:\n1.主从结构-异步数据库\n2.MGC同步数据库集群\n3.中间件反向代理(读写分离)" 
read -ep "请输入序号:" mysql_chioce
MYSQL_SET $mysql_chioce
;;
redis)
echo "温馨提示该部分内容暂时不支持运行多次或在一台机器上交替搭建,会导致配置文件出现重复配置"
echo -e "请选择搭建的Redis服务类型:\n1.Redis持久化\n2.Redis主从配置\n3.Redis Sentinel\n4.Redis Cluster" 
read -ep "请输入序号:" redis_chioce
REDIS_SET $redis_chioce
;;
mail)
echo "温馨提示该部分内容暂时不支持运行多次或在一台机器上交替搭建,会导致配置文件出现重复配置"
echo -e "邮件服务的内容是基于extmail部署的,配置基本是默认的,可设置的范围不大"
color_printer r 需要注意如果本机需要部署,除了extmail.org以外的虚拟主机,需要先行搭建其他的虚拟主机
MAIL_SET
color_printer r "注意要使用客户端网页,需要先发一封测试文件给 postmaster@extmail.org"
echo -e "相关内容如下:\n后台用户:root@extmail.org\n后台密码:extmail*123*\n前端用户:postmaster\n密码:extmail\n"
;;
*)error_printer;;
esac