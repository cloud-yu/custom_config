# User profile
##
#Set encoding
# $OutputEncoding : terminal display encoding (终端显示编码)
# [Console]::OutputEncoding : pipline/stream saved encoding （文本管道流编码）
# $OutputEncoding 和 【Console]::OutputEncoding不一致时，使用 >/>>管道输出至文件时，
# 会出现编码错误，如$OutputEncoding默认为utf8，[Console]::OutputEncoding跟随系统，默认gb2312
# 在终端使用 echo "中文测试" > test.txt 命令写文件，文件内容为utf8编码，保存编码为gb2312，
# 默认打开会出现乱码
##
# [System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)
$OutputEncoding = [System.Console]::OutputEncoding

## create alias
## you can use New-Alias / Set-Alias to set an alias.
## diffrence between two commands: when set an alias with exsiting name, Set-Alias will replace it without notification
## New-Alias will give a notification and keep the old alias.
## so use New-Alias when u want creat a new alias, use Set-Alias to modify an alias.
New-Alias -Name vim -Value "C:\Program Files\Sublime Text\sublime_text.exe"

## create variable
New-Variable -Name ONEDRIVE -Value "${HOME}\OneDrive"

##Create function
<#
function Get-PipUpdateAll {
    [CmdletBinding()]
    param (

    )
    begin {
        $outdate = pip list -o
        Write-Output $outdate
    }
    process {
        $outdate | Select-Object -Skip 2 | ForEach-Object -Begin {} -Process { $output = $_.split(' ', [System.StringSplitOptions]::RemoveEmptyEntries) }, { Write-Output ("update: {0} {1} -> {2}" -f $output) }, { pip install -U $($output[0]) } -End {}
    }
    end {
        Write-Output "update done."
    }
}

function Start-Fhlogin {
    [CmdletBinding()]
    param (
        $Uri = 'http://10.101.18.1:8008/portal.cgi',
        $Username = 'yuyun',
        $Passwd = '0211004565Fh'
    )

    $Body = @{
        username = $Username
        password = [System.Convert]::ToBase64String([System.Text.Encoding]::utf8.GetBytes($Passwd))
        submit   = 'submit'
    }
    $resp = Invoke-RestMethod -Method Post -Uri $Uri -Body $Body
    $ISO = [System.Text.Encoding]::GetEncoding('iso-8859-1')
    $UTF8 = [System.Text.Encoding]::UTF8
    Write-Host $UTF8.GetString($ISO.GetBytes($resp))
}
#>
##Set default Location and HOME/~ variables

# $HomeDirectory = "E:\Users\yuyun"
##Set HOME variable force
# Set-Variable HOME $HomeDirectory -Force
##Set ~ shortcut
# (Get-PSProvider 'FileSystem').Home = $HOME
# Set-Location $HOME

##set exec policy
# Set-ExecutionPolicy Unrestricted

##Disable the audio beep when user pressed backspace in the powershell console
Set-PSReadLineOption -BellStyle None

##Powershell support autoload module when using cmdlets from an installed module after version 3.0
# Prepare
# Install-Module posh-git, oh-my-posh, Terminal-Icons

function loadModule {
    [CmdletBinding()]
    param (
        [string[]]$ModuleColletion
    )

    begin {
        Write-Verbose "Load modules...."
    }

    process {
        foreach ($curModule in $ModuleColletion) {
            Write-Verbose "load $curModule..."
            Import-Module $curModule 2>&1 | Out-Null
            if (-not $?) {
                Install-Module $curModule
                Import-Module $curModule
            }
        }
    }

    end {
        Write-Verbose "Load modules done"
    }
}

loadModule -ModuleColletion Az.Tools.Predictor, script-module, Terminal-Icons
# Import-Module posh-git
# # Import-Module oh-my-posh
# Import-Module Az.Tools.Predictor
# Import-Module script-module
# Import-Module Terminal-Icons
# Import-Module syntax-highlighting


# $ConfigPath = Split-Path $PROFILE.CurrentUserAllHosts -Parent
# Update-FormatData -PrependPath (Join-Path -Path $ConfigPath -ChildPath "FileInfo.Format.ps1xml")
# Set-PoshPrompt (Join-Path -Path $ConfigPath -ChildPath ".mytheme.p10k.rainbow.json")
# Set-PoshPrompt powerlevel10k_rainbow   # old version,deprecated
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression
oh-my-posh completion powershell | Out-String | Invoke-Expression

$PSReadLineOptions = @{
    PredictionSource              = "HistoryAndPlugin"
    PredictionViewStyle           = "InlineView"
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    ShowToolTips                  = $true
    Colors                        = @{
        Command            = $PSStyle.Foreground.Blue
        Number             = $PSStyle.Foreground.BrightBlue
        Member             = $PSStyle.Foreground.Magenta
        Operator           = $PSStyle.Foreground.white
        Type               = $PSStyle.Foreground.BrightRed
        Variable           = $PSStyle.Foreground.BrightYellow
        Parameter          = $PSStyle.Foreground.BrightGreen
        ContinuationPrompt = $PSStyle.Foreground.White
        Default            = $PSStyle.Foreground.BrightWhite
        Emphasis           = $PSStyle.Foreground.BrightMagenta
        Error              = $PSStyle.Foreground.BrightRed
        Selection          = $PSStyle.Foreground.Black + $PSStyle.Background.White
        Comment            = $PSStyle.Foreground.Cyan
        Keyword            = $PSStyle.Foreground.BrightRed
        String             = $PSStyle.Foreground.White
        InlinePrediction   = $PSStyle.Foreground.BrightBlack
    }
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Chord Tab -Function Complete  # 设置 tab 键补全
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete  # 设置 ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Ctrl+e" -Function EndOfHistory  # 设置ctrl+e 停止历史记录补全
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo  # 设置 ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward  # 设置向上键位搜索历史记录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward  #设置下键位前向搜索历史记录
Set-PSReadLineKeyHandler -Key Alt+d -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f `
    -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
    -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::ShellForwardWord($key, $arg)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
    }
}

# 启用 winget tab 补全功能
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# Personlize console
$Host.UI.RawUI.WindowTitle = "Windows Powershell " + $Host.Version.Major;
Write-Host -ForegroundColor Green ("`n`t`t`t Welcome to Windows Powershell {0}`n`n" -f $host.Version.Major)
