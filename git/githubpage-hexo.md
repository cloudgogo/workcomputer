# 使用githubpage加hexo实现博客系统

## 环境要求
1. git 
2. nodejs

## 步骤
1. 安装环境
2. 安装hexo
3. git将本地推送至远端
4. github中域名映射cname
5. 修改主题
6. 添加RSS
7. 添加评论
8. 开始blog

## come on baby,follow me!!
1. 安装环境
    + 安装git 
    > 下载安装,无注意事项    
    + 安装nodejs
        - `LTS`是长期支持版,`current`为当前最新版
        - `Custom Setup`这步选择`add to path`,自动配置path
    > 使用nodejs时请注意使用管理员打开`bash`或`cmd`客户端
2. 安装hexo
    - 安装 `npm i -g hexo` 或 `npm install hexo-cli -g`(官方)
    - 查看版本 ` hexo -v`   
    ```shell
    Administrator@PC-ThinkPadT430 MINGW64 /c/users/Administrator/Desktop/blog/gaoxiangyun.github.io     (master)
    $ npm i -g hexo
    C:\Users\Administrator\AppData\Roaming\npm\hexo ->     C:\Users\Administrator\AppData\Roaming\npm\node_modules\hexo\bin\hexo
    npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.1.3     (node_modules\hexo\node_modules\fsevents):
    npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.1.3: wanted     {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})
    
    + hexo@3.5.0
    added 116 packages and updated 1 package in 25.448s
    
    Administrator@PC-ThinkPadT430 MINGW64 /c/users/Administrator/Desktop/blog/gaoxiangyun.github.io     (master)
    $ hexo -v
    hexo-cli: 1.0.4
    os: Windows_NT 6.1.7601 win32 x64
    http_parser: 2.7.0
    node: 8.9.3
    v8: 6.1.534.48
    uv: 1.15.0
    zlib: 1.2.11
    ares: 1.10.1-DEV
    modules: 57
    nghttp2: 1.25.0
    openssl: 1.0.2n
    icu: 59.1
    unicode: 9.0
    cldr: 31.0.1
    tz: 2017b
    
    ```
    - 初始话hexo
    我在使用hexo时发现按照教程的命令无法使用,揣测是hexo的版本导致不匹配的问题,通过查看当前版本为hexo3,使用命令不一样   
    > 初始化    
    > 在指定目录初始化一个hexo博客
    ```
    hexo init <menu>
    ```
    >启动
    ```
    hexo server
    ```

3. 上传github
    - 首先安装hexo的扩展
    ```
    npm install hexo-deployer-git --save
    ```
    配置Deployment

    同样在_config.yml文件中，找到Deployment，然后按照如下修改：
    ```
    deploy:
      type: git
      repo: git@github.com:yourname/yourname.github.io.git
      branch: master
    ```
    like me
    ```
    deploy:
      type: git
      repo: git@second.github.com:gaoxiangyun/gaoxiangyun.github.io.git 
      branch: master
    ```
    - hexo使用(simple)    
    1. 写博客
    ```
    hexo new post "article title"
    ```
    > 这时候在我的 电脑的目录下 F:\hexo\source\ _posts 将会看到 article title.md 文件
    2. 用MarDown编辑器打开就可以编辑文章了。文章编辑好之后，运行生成、部署命令：
    ```
    hexo g   // 生成
    hexo d   // 部署
    ```
    或
    ```
    hexo d -g #在部署前先生成
    ```

    ```
    hexo g = hexo generate  #生成
    hexo s = hexo server  #启动本地预览
    hexo d = hexo deploy  #远程部署
    
    hexo n "文章标题" = hexo new "文章标题"  #新建一篇博文

    hexo s -g  #等同先输入hexo g，再输入hexo s
    hexo d -g  #等同先输入hexo g，再输入hexo d
    ```

    出现问题请使用
    ```
    hexo clean
    hexo d -g
    ```

4. 在source文件夹中加入CNAME 解析文件 
5. 修改主题
   下载对应的主题并查看他们的文档
   请查看[http://theme-next.iissnan.com/](http://theme-next.iissnan.com/)