#!/usr/bin/env bash
## Mod: Build20210825V2
## 添加你需要重启自动执行的任意命令，比如 ql repo
## 安装node依赖使用 pnpm install -g xxx xxx（Build 20210728-002 及以上版本的 code.sh，可忽略）
## 安装python依赖使用 pip3 install xxx（Build 20210728-002 及以上版本的 code.sh，可忽略）


#------ 说明区 ------#
## 1. 拉取仓库
### （1）定时任务→添加定时→命令【ql extra】→定时规则【15 0-23/4 * * *】→运行
### （2）若运行过 1custom 一键脚本，点击运行即可
### （3）推荐配置：如下。自行在设置区填写编号


#------ 设置区 ------#
## 1. 拉取仓库编号设置，默认 Faker2 仓库
CollectedRepo=(4) ##示例：CollectedRepo=(2 4 6)
## 2. 是否安装依赖和安装依赖包的名称设置
dependencies="no" ##yes为安装，no为不安装

#------ 编号区 ------#
:<<\EOF
一、集成仓库（Collected Repositories)
2-JDHelloWorld
3-he1pu
4-Faker2
5-Faker3
6-yuannian1112
二、其他仓库（Other Repositories）
1-passerby-b
2-curtinlv
3-smiek2221
4-cdle
5-ZCY01
6-whyour/hundun
7-moposmall
8-Ariszy (Zhiyi-N)
9-photonmang
10-jiulan
12-star261
13-Wenmoux
14-Tsukasa007
EOF
2-Faker2
3-Faker3
4-Faker4
#------ 代码区 ------#
# 🌱拉取仓库
CR2(){
    ql repo https://github.com/shufflewzc/faker3.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}
CR3(){
    ql repo https://github.com/he1pu/JDHelp.git "jd_|jx_|getJDCookie" "Coupon|update" "^jd[^_]|USER|^sign|^ZooFaker|utils"
}
CR4(){
   ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}
CR5(){
CR3(){
    ql repo https://github.com/shufflewzc/faker3.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}
CR6(){
    ql repo https://github.com/yuannian1112/jd_scripts.git "jd_|jx_|getJDCookie" "activity|backUp" "^jd[^_]|USER|utils"
CR4(){
    ql repo https://github.com/shufflewzc/faker4.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}
for i in ${CollectedRepo[@]}; do
    CR$i
    sleep 10
done
OR1(){
    ql repo https://github.com/passerby-b/JDDJ.git "jddj_" "scf_test_event|jddj_fruit_code.js|jddj_getck.js|jd_|jddj_cookie"
}
OR2(){
    ql repo https://github.com/curtinlv/JD-Script.git "jd_"
}
OR3(){
    ql repo https://github.com/smiek2221/scripts.git "jd_|gua_" "" "^MovementFaker|^JDJRValidator|^ZooFaker|^sign"
}
OR4(){
    ql repo https://github.com/cdle/xdd.git "jd_" "disposable|expired|jdc"
}
OR5(){
    ql repo https://github.com/ZCY01/daily_scripts.git "jd_"
}
OR6(){
    ql repo https://github.com/whyour/hundun.git "quanx" "tokens|caiyun|didi|donate|fold|Env"
}
OR7(){
    ql repo https://github.com/moposmall/Script.git "Me"
}
OR8(){
    ql repo https://github.com/Ariszy/Private-Script.git "JD"
}
OR9(){
    ql repo https://github.com/photonmang/quantumultX.git "JDscripts"
}
OR10(){
    ql repo https://github.com/jiulan/platypus.git "jd_|jx_" "" "overdue" "main"
}
OR11(){
    ql repo https://github.com/panghu999/panghu.git "jd_"
}
OR12(){
    ql repo https://github.com/star261/jd.git "jd_|star" "" "code" "main"
}
OR13(){
    ql repo https://github.com/Wenmoux/scripts.git "other|jd" "" "" "wen"
}
OR14(){
    ql repo https://github.com/Tsukasa007/my_script.git "jd_|jx_" "jdCookie|USER_AGENTS|sendNotify|backup" "" "master"
}
for i in ${OtherRepo[@]}; do
    OR$i
    sleep 5
done


# 🍪Ninja
update_Ninja_normal(){
    cd /ql/ninja/backend && git checkout . && git pull
    pnpm install && pm2 start
    cp sendNotify.js /ql/scripts/sendNotify.js
}

check_Ninja_normal(){
    NOWTIME=$(date +%Y-%m-%d-%H-%M-%S)
    i=0
    while ((i<=0)); do
        echo "扫描 Ninja 是否在线"
        ps -fe|grep ninja|grep -v grep
        if [ $? -ne 0 ]; then
            i=0
            echo $NOWTIME" 扫描结束！Ninja 掉线了不用担心马上重启！"
            cd /ql
            ps -ef|grep ninja|grep -v grep|awk '{print $1}'|xargs kill -9
            cd /ql/ninja/backend
            pnpm install
            pm2 start
            ps -fe|grep Daemon |grep -v grep 
            if [ $? -ne 1 ]; then
                i=1
                echo $NOWTIME" Ninja 重启完成！"
                curl "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage?chat_id=$TG_USER_ID&text=Ninja 已重启完成"
            fi
        else
            i=1
            echo $NOWTIME" 扫描结束！Ninja 还在！"
        fi
    done
}

if [ "$Ninja" = "up" ]; then
    update_Ninja_normal &
elif [ "$Ninja" = "on" ]; then
    check_Ninja_normal
fi
