#!/usr/bin/env bash

## 本脚本搬运并模仿 liuqitoday
dir_config=/ql/data/config
dir_script=/ql/data/scripts
dir_repo=/ql/data/repo
config_shell_path=$dir_config/config.sh
extra_shell_path=$dir_config/extra.sh
code_shell_path=$dir_config/code.sh
task_before_shell_path=$dir_config/task_before.sh
bot_json=$dir_config/bot.json
# 定义 gitfix.sh 路径
git_shell_path=$dir_config/gitfix.sh


# 控制是否执行变量
read -p "是否执行全部操作，输入 1 即可执行全部，输入 0 则跳出，回车默认和其他可进行选择性操作，建议初次配置输入 1：" all
if [ "${all}" = 1 ]; then
    echo "将执行全部操作"
elif [ "${all}" = 0 ]; then
    exit 0
else
    read -p "config.sh 操作（替换或下载选项为 y，不替换为 n，回车为替换）请输入：" Rconfig
    Rconfig=${Rconfig:-'y'}
    read -p "extra.sh 操作（替换或下载选项为 a，修改设置区设置为 b，添加到定时任务为 c，立即执行一次为 d，全部不执行为 n，回车全部执行 | 示例：acd）请输入：" extra
    extra=${extra:-'abcd'}
    read -p "code.sh 操作（替换或下载选项为 a，修改默认调用日志设置为 b，添加到定时任务为 c，全部不执行为 n，回车全部执行 | 示例：ac）请输入：" code
    code=${code:-'abcd'}
    read -p "task_before.sh 操作（替换或下载选项为 y，不替换为 n，回车为替换）请输入：" Rbefore
    Rbefore=${Rbefore:-'y'}
    #read -p "bot 操作（跳过为 0，添加 task:ql bot 选项为 1，添加后设置并运行为 2，回车等同 0）请输入:" bot
    #bot=${bot:-'0'}
    read -p "config.sample.sh 操作（跳过为 0，添加 task:自动更新模板 选项为 1，添加后运行一次为 2，回车等同 2）请输入：" sample
    sample=${sample:-'2'}
fi


# 检查域名连通性
check_url() {
    HTTP_CODE=$(curl -o /dev/null --connect-timeout 3 -s -w "%{http_code}" $1)
    if [ $HTTP_CODE -eq 200 ]; then
        return 0
    else
        return 1
    fi
}


# 获取有效 config.sh 链接
get_valid_config() {
    config_list=(https://git.metauniverse-cn.com/https://raw.githubusercontent.com/yanyuwangluo/VIP/main/Conf/Qinglong/config.sample.sh)
    for url in ${config_list[@]}; do
        check_url $url
        if [ $? = 0 ]; then
            valid_url=$url
            echo "使用链接 $url"
            break
        fi
    done
}
# 下载 config.sh
dl_config_shell() {
    if [ ! -a "$config_shell_path" ]; then
        touch $config_shell_path
    fi
    curl -sL --connect-timeout 3 $valid_url > $config_shell_path
    cp $config_shell_path $dir_config/config.sh
    # 判断是否下载成功
    config_size=$(ls -l $config_shell_path | awk '{print $5}')
    if (( $(echo "${config_size} < 100" | bc -l) )); then
        echo "config.sh 下载失败"
        exit 0
    fi
}
if [ "${Rconfig}" = 'y' -o "${all}" = 1 ]; then
    get_valid_config && dl_config_shell
else
    echo "已为您跳过替换 config.sh"
fi


# 获取有效 extra.sh 链接
get_valid_extra() {
    extra_list=(https://git.metauniverse-cn.com/https://raw.githubusercontent.com/yanyuwangluo/VIP/main/Tasks/qlrepo/extra.sh)
    for url in ${extra_list[@]}; do
        check_url $url
        if [ $? = 0 ]; then
            valid_url=$url
            echo "使用链接 $url"
            break
        fi
    done
}
# 下载 extra.sh
dl_extra_shell() {
    if [ ! -a "$extra_shell_path" ]; then
        touch $extra_shell_path
    fi
    curl -sL --connect-timeout 3 $valid_url > $extra_shell_path
    cp $extra_shell_path $dir_config/extra.sh
    # 判断是否下载成功
    extra_size=$(ls -l $extra_shell_path | awk '{print $5}')
    if (( $(echo "${extra_size} < 100" | bc -l) )); then
        echo "extra.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $extra_shell_path
}
# extra.sh 设置区设置
set_default_extra() {   
    echo -e "一、集成仓库 Shufflewzc-Faker2"
    read -p "直接回车拉取Faker2助力池版仓库，输入3回车拉取Faker3纯净仓库,输入4回车拉取Faker4简洁仓库" CollectedRepo
    CollectedRepo=${CollectedRepo:-"2"}
    sed -i "s/CollectedRepo=(4)/CollectedRepo=(${CollectedRepo})/g" $extra_shell_path
}
# 将 ql extra 添加到定时任务
add_ql_extra() {
    if [ "$(grep -c "ql\ extra" /ql/data/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:ql extra"
    else
        echo "开始添加 task:ql extra"
        # 获取token
        token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"初始化任务","command":"ql extra","schedule":"15 0-23/4 * * *"}' --compressed 'http://127.0.0.1:5600/api/crons?t=1697961933000'
    fi
}
# 运行一次 ql extra
run_ql_extra() {
    ql extra
    sleep 5
}
if [ "${all}" = 1 ]; then
    get_valid_extra && dl_extra_shell && set_default_extra && add_ql_extra && run_ql_extra
elif [ "${extra}" = 'n' ]; then
    echo "已为您跳过操作 extra.sh"
else
    if [[ ${extra} =~ 'a' ]]; then
        get_valid_extra && dl_extra_shell
    fi
    if [[ ${extra} =~ 'b' ]]; then
        set_default_extra
    fi
    if [[ ${extra} =~ 'c' ]]; then
        add_ql_extra
    fi
    if [[ ${extra} =~ 'd' ]]; then
        run_ql_extra
    fi
fi

# 获取有效 gitfix.sh 链接
get_valid_git() {
    git_list=(https://git.metauniverse-cn.com/https://raw.githubusercontent.com/yanyuwangluo/VIP/main/Scripts/sh/gitfix.sh)
    for url in ${git_list[@]}; do
        check_url $url
        if [ $? = 0 ]; then
            valid_url=$url
            echo "使用链接 $url"
            break
        fi
    done
}

# 下载 gitfix.sh
dl_git_shell() {
    if [ ! -f "$git_shell_path" ]; then
        touch $git_shell_path
    fi
    curl -sL --connect-timeout 3 $valid_url > $git_shell_path
    cp $git_shell_path $dir_config/gitfix.sh
    # 判断是否下载成功
    git_size=$(ls -l $git_shell_path | awk '{print $5}')
    if (( $(echo "${git_size} < 100" | bc -l) )); then
        echo "gitfix.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $git_shell_path
}

read -p "回车继续执行github连接修复：" Rgit
Rgit=${Rgit:-'y'}

if [ "${Rgit}" = 'y' -o "${all}" = 1 ]; then
    get_valid_git && dl_git_shell
    echo "开始执行拉库修复"
    bash $git_shell_path
else
    echo "已为您跳过操作"
fi

add_task_git() {
    if [ "$(grep -c "gitfix.sh" /ql/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:gitfix.sh"
    else
        echo "开始添加 task:gitfix.sh"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"更新Git仓库","command":"bash /ql/config/gitfix.sh","schedule":"*/30 * * * *"}' --compressed 'http://127.0.0.1:5700/api/crons?t=1627380635389'
    fi
}


# 获取有效 code.sh 链接
get_valid_code() {
    code_list=(https://raw.githubusercontent.com/yanyuwangluo/VIP/main/Scripts/sh/Helpcode2.8/code.sh)
    for url in ${code_list[@]}; do
        check_url $url
        if [ $? = 0 ]; then
            valid_url=$url
            echo "使用链接 $url"
            break
        fi
    done
}
# 下载 code.sh
dl_code_shell() {
    if [ ! -a "$code_shell_path" ]; then
        touch $code_shell_path
    fi
    curl -sL --connect-timeout 3 $valid_url > $code_shell_path
    cp $code_shell_path $dir_config/code.sh
    # 判断是否下载成功
    code_size=$(ls -l $code_shell_path | awk '{print $5}')
    if (( $(echo "${code_size} < 100" | bc -l) )); then
        echo "code.sh 下载失败"
        exit 0
    fi
    # 授权
    chmod 755 $code_shell_path
}
# code.sh 预设仓库及默认调用仓库设置
set_default_code() {
    echo -e "## 将\"repo=\$repo1\"改成\"repo=\$repo2\"或其他，以默认调用其他仓库脚本日志\nrepo1='panghu999_jd_scripts' #预设的 panghu999 仓库\nrepo2='JDHelloWorld_jd_scripts' #预设的 JDHelloWorld 仓库\nrepo3='he1pu_JDHelp' #预设的 he1pu 仓库\nrepo4='shufflewzc_faker2' #预设的 faker 仓库\nrepo6='Aaron-lv_sync_jd_scripts' #预设的 Aaron-lv 仓库\nrepoA='yuannian1112_jd_scripts' #预设的 yuannian1112 仓库\nrepo=\$repo1 #默认调用 panghu999 仓库脚本日志"
    read -p "回车直接配置Faker2仓库内部助力，输入1回车则配置Faker3纯净仓库内部助力:" repoNum
    repoNum=${repoNum:-'4'}
    sed -i "s/repo=\$repo[0-9]/repo=\$repo${repoNum}/g" $code_shell_path
    if [ "${repoNum}" = 'A' ]; then
        sed -i "/^repo7=/a\repoA='yuannian1112_jd_scripts'" $code_shell_path
    fi
}
# 将 task code.sh 添加到定时任务
add_task_code() {
    if [ "$(grep -c "code.sh" /ql/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:task code.sh"
    else
        echo "开始添加 task:task code.sh"
        # 获取token
        token=$(cat /ql/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"格式化更新助力码","command":"task /ql/config/code.sh","schedule":"*/10 * * * *"}' --compressed 'http://127.0.0.1:5600/api/crons?t=1697961933000'
    fi
}
if [ "${all}" = 1 ]; then
    get_valid_code && dl_code_shell && set_default_code && add_task_code
elif [ "${code}" = 'n' ]; then
    echo "已为您跳过操作 code.sh"
else
    if [[ ${code} =~ 'a' ]]; then
        get_valid_code && dl_code_shell
    fi
    if [[ ${code} =~ 'b' ]]; then
        set_default_code
    fi
    if [[ ${code} =~ 'c' ]]; then
        add_task_code
    fi
fi


# 获取有效 task_before.sh 链接
get_valid_task_before() {
    task_before_list=(https://git.metauniverse-cn.com/https://raw.githubusercontent.com/yanyuwangluo/VIP/main/Scripts/sh/Helpcode2.8/task_before.sh)
    for url in ${task_before_list[@]}; do
        check_url $url
        if [ $? = 0 ]; then
            valid_url=$url
            echo "使用链接 $url"
            break
        fi
    done
}
# 下载 task_before.sh
dl_task_before_shell() {
    if [ ! -a "$task_before_shell_path" ]; then
        touch $task_before_shell_path
    fi
    curl -sL --connect-timeout 3 $valid_url > $task_before_shell_path
    cp $task_before_shell_path $dir_config/task_before.sh
    # 判断是否下载成功
    task_before_size=$(ls -l $task_before_shell_path | awk '{print $5}')
    if (( $(echo "${task_before_size} < 100" | bc -l) )); then
        echo "task_before.sh 下载失败"
        exit 0
    fi
}
if [ "${Rbefore}" = 'y' -o "${all}" = 1 ]; then
    get_valid_task_before && dl_task_before_shell
else
    echo "已为您跳过替换 task_before.sh"
fi


# 添加定时任务 自动更新模板
add_curl_sample() {
    if [ "$(grep -c "config.sample.sh" /ql/data/config/crontab.list)" != 0 ]; then
        echo "您的任务列表中已存在 task:自动更新模板"
    else
        echo "开始添加 task:curl config.sample.sh"
        # 获取token
        token=$(cat /ql/data/config/auth.json | jq --raw-output .token)
        curl -s -H 'Accept: application/json' -H "Authorization: Bearer $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept-Language: zh-CN,zh;q=0.9' --data-binary '{"name":"自动更新模板","command":"curl -L https://git.metauniverse-cn.com/https://raw.githubusercontent.com/yanyuwangluo/VIP/main/Conf/Qinglong/config.sample.sh -o /ql/data/sample/config.sample.sh && cp -rf /ql/data/sample/config.sample.sh /ql/config","schedule":"45 6,18 * * *"}' --compressed 'http://127.0.0.1:5600/api/crons?t=1697961933000'
    fi
}
run_curl_sample() {
    curl -sL $valid_url -o /ql/sample/config.sample.sh && cp -rf /ql/sample/config.sample.sh /ql/config
}
if [ "${all}" = 1 ]; then
    get_valid_config && add_curl_sample && run_curl_sample
else
    case ${sample} in
        0)  echo "已为您跳过自动更新模板"
        ;;
        1)  get_valid_config && add_curl_sample
        ;;
        2)  get_valid_config && add_curl_sample && run_curl_sample
    esac    
fi


# 提示配置结束
echo -e "\n配置到此结束，您是否成功了呢？"
