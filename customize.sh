#  c:stomize.sh 脚本说明
#
# 脚本功能：
# 1. 打印自定义安装过程的开始信息。
# 2. 检查设备架构，并根据架构类型打印相应信息或终止安装。
# 3. 检查 Android API 版本，确保版本在支持范围内，否则终.安装。
# 4. 设置指定文件和目录的权限。
# 5. 打印自定义安装过程的完成信息。
#
# 脚本详细说明：
# - ui_print: 用于在安装过程中打印信息到控制台。
# - case "$ARCH" in ... esac: 检查设备架构，支持 "arm", "arm64", "x86", "x64" 四种架构。
# - abort: 用于终止安装过程并打印错.信息。
# - if [ "$API" -lt 23 ]; then ... fi: 检查 Android API 版本，要求版本不低于 23。
# - set_perm: 设置单个文件的权限。
# - set_perm_recursive: 递归设置目录及其内容的权限。

ui_print "欢迎使用本前置模块"
ui_print "作者：@LIghtJUNction"
ui_print "github：https://github.com/LIghtJUNction/RootManage-Module-Model/blob/UniCron"

mkdir -p $MODPATH/system/bin
mkdir -p $MODPATH/webroot/spool
mkdir -p $MODPATH/webroot/etc

set_perm_recursive $MODPATH 0 0 0777 0777
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755

set_perm_recursive $MODPATH/webroot/spool 0 0 0755 0644
set_perm_recursive $MODPATH/webroot/etc 0 0 0755 0644


ui_print "- 检测 root 管理器类型"

if [ -d "/data/adb/magisk" ]; then
    ui_print "- 检测到 Magisk"
    touch "$MODPATH/magisk"
elif [ "$KSU" = "true" ]; then
    ui_print "- 检测到 KernelSU"
    touch "$MODPATH/ksu"
elif [ "$APATCH" = "true" ]; then
    ui_print "- 检测到 APU"
    touch "$MODPATH/apu"
else
    ui_print "- 未检测到支持的 root 管理器"
    abort "- 请先安装支持的 root 管理器"
fi

# 检查版本
if { [ "$KSU" = "true" ] && [ "$KSU_VER_CODE" -ge 11981 ]; } || 
	{ [ "$APATCH" = "true" ] && [ "$APATCH_VER_CODE" -ge 10927 ]; }; then
    ui_print "- 恭喜,当前版本可用action.sh"
else
    ui_print "- 当前版本/管理器不支持action.sh"
    ui_print "- 功能不完整!"
fi
