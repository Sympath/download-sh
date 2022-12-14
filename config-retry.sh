#!/bin/bash
# name 百度云盘最外层目录名
# cookie 登陆cookie
while read line; do
    eval "$line"
done <config
# 2. 切换进根目录
cd repo
echo '1. 切换进根目录完成'
# 3. 生成配置文件
mkdir config
echo "
// let courseIds = ('${courseIds}').split(',');
module.exports = {
    cookies: "${cookie}",
    courseIds: '${courseIds}',
    bdypDir: '${name}',
}" >config/cjs-index.js
echo "
import path from 'path';
// import nodeApi from '../utils/node-api.js';
// let configObj = nodeApi.getFileExportObjInDir('/Users/wzyan/Documents/selfspace/ffmpeg-download/config/3')
let ctx = require.context('../currentConfig/', false, /\.js$/);
const modules = {}
for (const key of ctx.keys()) {
    // key 是 相对src的相对路径   module 是 模块导出对象  es6的话要在default上取值
    let module = ctx(key);
    const name = path.relative('', key).split('.')[0]
    modules[name] = module.default;
}
// 配置 2
export const bdypDir = '${name}' // 在百度云盘上对应的文件夹名称
export default modules
" >config/index.js
echo '2. 生成配置文件完成'
# 安装依赖
npm run install-linux
echo '3. 安装依赖完成'
# 启动
echo '4. 启动 ======'
npm run run
echo '下载课件目录完成 ====== 执行视频下载任务完成'

# echo '5.1 生成静态资源目录完成'
# npm run build
# npm run build2
# echo '5.2 生成下载脚本完成'
# npm run build
# npm run build3
# echo '5.3 开始执行脚本'
# npm run build4-linux
# echo '5.4 所有课程下载完成'
