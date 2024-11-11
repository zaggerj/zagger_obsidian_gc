# $branches = Get-Content "$PSScriptRoot/branches.json" | ConvertFrom-Json

function Set-UTF8
{
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
}

function Show-Notification
{
    param (
        [string]$Title,
        [string]$Body
    )

    Add-Type -AssemblyName System.Windows.Forms
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon

    $path = (Get-Process -id $pid).Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)

    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info

    $balloon.BalloonTipText = $Body
    $balloon.BalloonTipTitle = $Title

    $balloon.Visible = $true
    $balloon.ShowBalloonTip(6000)

    # pwsh 有 bug，注册不上这个事件，powershell 正常
    [void](Register-ObjectEvent -InputObject $balloon -EventName MouseClick -SourceIdentifier officeBalloon -Action {
            $global:balloon.Dispose()
            Unregister-Event -SourceIdentifier officeBalloon 
            Remove-Variable -Scope Global -Name balloon
        })
}

<#
    .SYNOPSIS
        平平仄仄
#>
function Update-NGConsole
{
    param (
        [switch]$Rebuild,
        [switch]$Clean,
        [switch]$NoCheck,
        [string]$Upload,
        [string]$SSHPort,
        [switch]$VPC,
        [switch]$Commit
    )
    Trap
    {
        Write-Host -ForegroundColor Red "😅 出现错误，请检查脚本执行路径！"
        break
    }

    if (Test-Path "package.json")
    {
        Write-Host -ForegroundColor Yellow "🤡 你处于子目录中，执行路径错误！"
        return
    }
    $beforeBuilds = @{}
    $beforeBuilds['console-fe-vue'] = 'pnpm build:comp'
    $beforeBuilds['console-fe-vnc'] = 'yarn build'
    $beforeBuilds['spice-web-client'] = 'yarn build;yarn deploy'
    $beforeBuilds['new-vdi-client'] = 'yarn build;yarn deploy'

    $repos = @{}
    $repos['console-fe'] = "pnpm build" 
    if (!$VPC)
    { 
        $repos['view-front'] = "pnpm build" 
    }

    $afterBuilds = @{}

    $dest = "ngconsole"

    $actualBuilds = @()
    if (!$NoCheck)
    {
        foreach ($repo in ($repos.Keys + $beforeBuilds.Keys + $afterBuilds.Keys))
        {
            $current = Join-Path -Path $PWD -ChildPath $repo
            Write-Host -ForegroundColor Cyan "🉑 预检：$current"
            if (!(Test-Path -Path $current))
            { continue 
            } 
            $actualBuilds += $repo
            Push-Location $current
            if (Confirm-Clean)
            {
                # 注意分支命名规范 upstream-lhq{-s1...}
                $upstream_orig = git branch --show-current
                $upstream = $upstream_orig -replace "-lhq.*", ""
                Write-Host -ForegroundColor Green "$upstream ==Merge==> $upstream_orig"
                git pull --no-rebase origin $upstream
                if (!$?)
                { throw "代码拉取故障" 
                }
                if (-not (Confirm-Clean))
                {
                    Write-Host -ForegroundColor Red "😅 存在冲突 $current !"
                    return
                }
            } else
            {
                Write-Host -ForegroundColor Red "🤣👉 无法更新 $current，你有未提交的代码!"
                return
            }
            Pop-Location
        }
    }
    
    # 构建任务提交
    if ($Rebuild)
    {
        # 确保产物目录干净，但又不影响“仅上传”功能
        Write-Host -ForegroundColor Gray "🌚 清理目标目录"
        Push-Location $dest
        git restore .
        git clean -fd
        git pull

        git branch
        Pop-Location

        # 常规 build 前
        Write-Host -ForegroundColor Gray "🌘 开始前置构建 "
        $beforeBuilds.Keys | % -Parallel {
            if (Test-Path $_)
            {
                Write-Host "Building: $_"
                Push-Location $_
                iex ($using:beforeBuilds)[$_]
            }
        } | Out-Null

        # 常规 build
        Write-Host -ForegroundColor Gray "🌗 开始主体构建"
        $repos.Keys | % -Parallel {
            if (Test-Path $_)
            {
                Push-Location $_
                $build = ($using:repos)[$_]
                if ($build)
                {
                    Write-Host "Building: $_"
                    iex $build
                }
            }
        } | Out-Null

        # 常规 build 后
        Write-Host -ForegroundColor Gray "🌖 开始后置构建 "
        $afterBuilds.Keys | % -Parallel {
            if (Test-Path $_)
            {
                Write-Host "Building: $_"
                Push-Location $_
                iex ($using:afterBuilds)[$_]
            }
        } | Out-Null
        Write-Host "`n🌝 构建完成" -ForegroundColor Green
    }

    # 其他操作
    if (Test-Path 'ngconsole')
    {
        Push-Location 'ngconsole'
        if ($Upload)
        {
            Write-Host "🚛 上传到 ${Upload}" -ForegroundColor Green
            $backup = "../rsync-backups/$(Get-Date -Format yyyyMMddhhmm)" 
            $cmd = "rsync -avhCzp --del --exclude '.*' --exclude node_modules --exclude t --exclude dist --exclude zips . ${Upload}:/var/www/html"
            # $cmd = "rsync -avhCz --del -b --backup-dir=${backup} --exclude '.*' --exclude node_modules --exclude t --exclude dist --exclude zips . ${Upload}:/var/www/html"
            if ($SSHPort)
            { $cmd += " -e 'ssh -p ${SSHPort}'" 
            }
            bash -c $cmd
        }
        # Commit 必须要 Check
        if ($Commit -and !$NoCheck)
        {
            Write-Host "✍️  提交到 Gitlab"
            git add .
            git commit -nm "Rebuild $($actualBuilds -join ', ') at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            # 脚本开始时拉取过
            git push
            if (!$?)
            { throw "自动 Commit 失败！" 
            }
        }
        Pop-Location
    }
    if ((Test-Path 'console-fe') -and $Clean)
    {
        Push-Location 'console-fe'
        Write-Host "🧹 清理构建文件" -ForegroundColor Green
        git restore js/libs .mock
        Pop-Location
    }
    Write-Host -ForegroundColor Green "🎉 所有任务均已完成！"
}

# 获取从某个 hash 开始的 diff 文件，包括输入的 hash
function Get-DiffFiles($hash)
{
    $flist = git diff "$hash^.." --name-status | awk -e '/^[RAM]/{print $NF}'
    if (!$?)
    { throw "缺少必要的命令: git 或 awk" 
    }
    return $flist
}

# 根据 hash 打补丁包
function Compress-NGPatch
{
    param (
        [Parameter(Mandatory)]
        [string]$Hash,
        [string]$Extract,
        [switch]$Upload,
        [switch]$Open
    )
    Trap
    {
        Write-Host -ForegroundColor Red "缺少需要的命令: git"
        break
    }

    $flist = (Get-DiffFiles -hash $Hash).Where( { $_ -notmatch ".map|.sh|.zip|ignore" })
    $zipName = "$(Get-Date -Format "yyyy-MM-dd").tgz"
    git archive --format=tar.gz -o $zipName HEAD $flist
    if (!$?)
    {
        throw 'git archive 失败！'
    }
    if ($open)
    {
        Start-Process $zipName
    }
    if ($Extract -and (Test-Path $Extract))
    {
        $html = Join-Path $Extract "html"
        # 此处不要用 windows 自带的，会乱码
        wsl tar -xf $zipName -C $html
        if (!$?)
        {
            throw 'tar 解压失败！'
        }
        Push-Location $Extract
        Remove-Item -ErrorAction SilentlyContinue 'filelist'
        foreach ($f in $flist)
        {
            "/var/www/html/$f" | Out-File -Append 'filelist'
        }
        if ($Upload)
        {
            Pop-Location
            # scp -r $Extract/* Cloud_r00t@172.16.65.145:"~/553-patch-mmc-10.9.1-tspace"
            scp -r $Extract/* root@172.16.65.146:"/root/lin/patcher/553-patch-mmc-10.9.1-tspace"
        }
    }
}

function Start-Dev
{
    param (
        [switch]$VPC,
        [switch]$Restart,
        [switch]$Stop,
        [switch]$Install,
        [switch]$Old
    )
    $parent = Split-Path -Leaf $PWD
    if ($Stop -or $Restart)
    {
        $jobs = Get-Job | Where-Object Name -match $parent
        Write-Host -ForegroundColor Green "正在停止 $($jobs.Length) 个任务"
        $jobs | Stop-Job
        $jobs | Remove-Job
        Write-Host -ForegroundColor Blue "已停止任务"
        if ($Stop)
        { return 
        }
    }
    $existVue = Get-Job -State Running | Where-Object Name -match "view"
    # 端口冲突，不能多起
    if ($existVue)
    {
        Write-Host -ForegroundColor Yellow "view-front 已终止并重新启动为 $parent"
        $existVue | Stop-Job
        $existVue | Remove-Job
    }
    # 可以启动多个 ng，但每个目录仅限一个
    $existNG = Get-Job -State Running | Where-Object Name -EQ "$($parent)_console-fe"
    if ($existNG)
    { $startNG = $false 
    } else
    { $startNG = $true 
    }
    
    $cmds = @{}
    $cmds["view-front"] = 'pnpm', 'serve'
    if ($Old)
    { $cmds["ngconsole"] = 'pnpm', 'start' 
    } else
    { $cmds["console-fe"] = 'pnpm', 'start' 
    }

    foreach ($dir in (Get-ChildItem -Directory $PWD))
    {
        if (!$startNG -and ($dir.Name -eq "console-fe"))
        {
            Write-Host -ForegroundColor Blue "跳过 $($dir.Name) 启动"
            continue
        }
        Push-Location $dir
        if (('console-fe', 'view-front' -contains $dir.Name) -and ($Install -or !(Test-Path "node_modules")))
        {
            Write-Host -ForegroundColor Green "正在为 $dir 安装依赖"
            pnpm i
            if (!$?)
            { throw '依赖安装失败！' 
            }
        }
        Pop-Location
        if ($cmds.ContainsKey($dir.Name))
        {
            $null = (Start-Job -WorkingDirectory $dir -ScriptBlock {
                    param($cmds, $dir)
                    Remove-Item -ErrorAction SilentlyContinue "../$dir.log"
                    Invoke-Expression -Command "$($cmds[$dir]) 2>&1 >> ../$dir.log"
                } -Name "${parent}_$($dir.Name)" -ArgumentList $cmds, $dir.Name)
        }
    }
    Get-Job -State Running | Select-Object Name
}

function Update-MMC
{
    [CmdletBinding()]
    param (
        [string]
        $Remote,
        [switch]
        $Release = $false,
        [switch]
        $NoClean = $false,
        [switch]
        $OEM = $false
    )
    $cwd = $pwd
    Trap
    {
        Write-Host -ForegroundColor Red "构建失败！"
        Set-Location $cwd
        break
    }
    if (!(Test-Path lerna.json))
    {
        Write-Host -ForegroundColor Red "错误路径！"
        return
    }
    Write-Host -ForegroundColor Magenta "🚀 信创多媒体自动构建与发布脚本`n"
    Set-Location .\packages\teacher-ui\
    yarn build
    if (!$?)
    { throw "teach-ui 构建失败！" 
    }
    Set-Location ..\common-electron
    if (!$?)
    { throw "common-electron 构建失败！" 
    }
    yarn build

    # 远程，启动！
    if ($Remote)
    {
        scp .\dist\linux-unpacked\resources\app.asar "${Remote}:~/Desktop"
        ssh -t $Remote "sudo mv -f ~/Desktop/app.asar /opt/mmc-server/bin/electron/resources/"
    }

    # 发包
    if ($Release)
    { Robocopy.exe .\dist\linux-unpacked\resources \\172.20.4.46\06测试共享\xufan app.asar /xo /z 
    }
    if ($OEM)
    { Copy-Item .\dist\linux-unpacked\resources\app.asar  $cwd 
    }

    Set-Location $cwd

    # 清理
    if (!$NoClean)
    {
        git restore .\packages\common-electron\teacher-ui\
        git clean -fd .\packages\common-electron\teacher-ui\
    }
}

function Get-DevPorts
{
    Trap
    {
        Write-Host -ForegroundColor Red "进程没有完全启动"
    }
    $logs = 'console-fe.log', 'view-front.log'
    if (Test-Path 'console-fe.log')
    {
        (Select-String '\sloopback.+localhost:\d{4}' $logs[0])[0]
    }
    if (Test-Path 'view-front.log')
    {
        (Select-String "\sLocal.+:\d{4}" $logs[1])[0]
    }
}

function Get-CommitTime
{
    param (
        [string]$Message = '补丁'
    )
    return "$(Get-Date -Format "yyyy-MM-dd HH:mm") $Message"
}

function Confirm-Clean
{
    return [bool](-not (git status --porcelain))
}

# 展示所有仓库状态
function Show-RepoStatus
{
    $res = Get-ChildItem -Directory . | % -Parallel {
        if (Test-Path "$_/.git")
        {
            if (Test-Path "$_/pnpm-lock.yaml")
            { $pkgm = 'pnpm' 
            } elseif (Test-Path "$_/yarn.lock")
            { $pkgm = 'yarn' 
            } else
            { $pkgm = 'npm' 
            }

            # return 只影响执行流程，scriptblock 结果取决于打印的字符串或Object
            [PSCustomObject]@{
                仓库名 = $_.Name;
                分支  = (git -C $_.Name branch --show-current);
                依赖  = (Test-Path "$_/node_modules");
                未提交 = [bool](git -C $_.Name status --porcelain);
                包管理 = $pkgm
            }
        }
    }
    $res | Format-Table -AutoSize
}

# 更新所有仓库依赖
function Update-Deps
{
    Get-ChildItem -Directory . | % -Parallel {
        Set-Location $_.Name
        if ((Test-Path 'package.json') -and (Test-Path '.git'))
        {
            if (Test-Path 'pnpm-lock.yaml')
            {
                pnpm i
                git restore pnpm-lock.yaml
            } elseif (Test-Path 'yarn.lock')
            {
                yarn
                git restore yarn.lock
            } else
            {
                npm i
            }
        }
    }
}

function Set-Version
{
    param (
        [string]$Version
    )
    $branches.Keys() | ForEach-Object
}
