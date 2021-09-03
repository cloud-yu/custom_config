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
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)
$OutputEncoding = [System.Console]::OutputEncoding

##reate alias
# New-Alias -Name pip -Value pip

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

if ( -not $(Get-Module -ListAvailable -Name posh-git)) {
    Install-Module posh-git -Scope CurrentUser
}

if ( -not $(Get-Module -ListAvailable -Name oh-my-posh)) {
    Install-Module oh-my-posh -Scope CurrentUser
}

##Powershell support autoload module when using cmdlets from an installed module after version 3.0
# Import-Module posh-git
# Import-Module oh-my-posh

$PSReadLineOptions = @{
    PredictionSource              = "History"
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    Colors                        = @{
        Command            = [System.ConsoleColor]::Cyan
        Number             = [System.ConsoleColor]::DarkGreen
        Member             = [System.ConsoleColor]::DarkMagenta
        Operator           = [System.ConsoleColor]::Gray
        Type               = [System.ConsoleColor]::DarkRed
        Variable           = [System.ConsoleColor]::DarkYellow
        Parameter          = [System.ConsoleColor]::DarkGreen
        ContinuationPrompt = [System.ConsoleColor]::Gray
        Default            = [System.ConsoleColor]::White
        Emphasis           = [System.ConsoleColor]::DarkMagenta
        Error              = [System.ConsoleColor]::DarkRed
        Selection          = [System.ConsoleColor]::Gray
        Comment            = [System.ConsoleColor]::DarkCyan
        Keyword            = [System.ConsoleColor]::DarkRed
        String             = [System.ConsoleColor]::DarkGray
        InlinePrediction   = [System.ConsoleColor]::DarkGray
    }
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Key Tab -Function Complete  # 设置 tab 键补全
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete  # 设置 ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo  # 设置 ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward  # 设置向上键位搜索历史记录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward  #设置下键位前向搜索历史记录

Set-PoshPrompt Paradox

# Personlize console
$Host.UI.RawUI.WindowTitle = "Windows Powershell " + $Host.Version.Major;
Write-Host -ForegroundColor Green ("`n`t`t`t Welcome to Windows Powershell {0}`n`n" -f $host.Version.Major)
