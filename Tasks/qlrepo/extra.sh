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
CollectedRepo=(2) ##示例：CollectedRepo=(2 4 6)
## 2. 是否安装依赖和安装依赖包的名称设置
dependencies="no" ##yes为安装，no为不安装
package_name="canvas png-js date-fns axios crypto-js ts-md5 tslib @types/node dotenv typescript fs require tslib"

#------ 编号区 ------#
:<<\EOF
一、集成仓库（Collected Repositories)
2-Faker2
3-Faker3
4-Faker4



#------ 代码区 ------#
# 🌱拉取仓库
CR2(){
   ql repo https://github.com/shufflewzc/faker2.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}
CR3(){
    ql repo https://github.com/shufflewzc/faker3.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}
CR4(){
    ql repo https://github.com/shufflewzc/faker4.git "jd_|jx_|gua_|jddj_|jdCookie" "activity|backUp" "^jd[^_]|USER|function|utils|sendNotify|ZooFaker_Necklace.js|JDJRValidator_|sign_graphics_validate|ql|JDSignValidator|magic|depend|h5sts" "main"
}

for i in ${CollectedRepo[@]}; do
    CR$i
    sleep 10
done


# 📦依赖
install_dependencies_normal(){
    for i in $@; do
        case $i in
            canvas)
                cd /ql/scripts
                if [[ "$(echo $(npm ls $i) | grep ERR)" != "" ]]; then
                    npm uninstall $i
                fi
                if [[ "$(npm ls $i)" =~ (empty) ]]; then
                    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i $i --prefix /ql/scripts --build-from-source
                fi
                ;;
            *)
                if [[ "$(npm ls $i)" =~ $i ]]; then
                    npm uninstall $i
                elif [[ "$(echo $(npm ls $i -g) | grep ERR)" != "" ]]; then
                    npm uninstall $i -g
                fi
                if [[ "$(npm ls $i -g)" =~ (empty) ]]; then
                    [[ $i = "typescript" ]] && npm i $i -g --force || npm i $i -g
                fi
                ;;
        esac
    done
}

install_dependencies_force(){
    for i in $@; do
        case $i in
            canvas)
                cd /ql/scripts
                if [[ "$(npm ls $i)" =~ $i && "$(echo $(npm ls $i) | grep ERR)" != "" ]]; then
                    npm uninstall $i
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                fi
                if [[ "$(npm ls $i)" =~ (empty) ]]; then
                    apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev && npm i $i --prefix /ql/scripts --build-from-source --force
                fi
                ;;
            *)
                cd /ql/scripts
                if [[ "$(npm ls $i)" =~ $i ]]; then
                    npm uninstall $i
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                elif [[ "$(npm ls $i -g)" =~ $i && "$(echo $(npm ls $i -g) | grep ERR)" != "" ]]; then
                    npm uninstall $i -g
                    rm -rf /ql/scripts/node_modules/$i
                    rm -rf /usr/local/lib/node_modules/lodash/*
                fi
                if [[ "$(npm ls $i -g)" =~ (empty) ]]; then
                    npm i $i -g --force
                fi
                ;;
        esac
    done
}

install_dependencies_all(){
    install_dependencies_normal $package_name
    for i in $package_name; do
        install_dependencies_force $i
    done
}

if [ "$dependencies" = "yes" ]; then
    install_dependencies_all &
fi