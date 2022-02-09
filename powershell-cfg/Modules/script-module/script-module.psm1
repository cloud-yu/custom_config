$DataPath = $((Get-Item $MyInvocation.MyCommand.ScriptBlock.Module.ModuleBase).FullName)
$Script:SavedFile = Join-Path $DataPath "saved.db"
$Script:ISO = [System.Text.Encoding]::GetEncoding('iso-8859-1')
$Script:UTF8 = [System.Text.Encoding]::UTF8

function Get-PipUpdateAll {
    [CmdletBinding()]
    param (

    )
    begin {
        $outdate = pip list -o
        Write-Output $outdate
    }
    process {
        $needupdate = $outdate[2..$outdate.Length]
        foreach ($item in $needupdate) {
            $output = $item.split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
            Write-Host ("update: {0} {1} -> {2}" -f $output) -ForegroundColor:Green -BackgroundColor:Black
            pip install -U $output[0]
        }
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
        [string]$Passwd,
        [switch]$Save
    )

    if ([String]::IsNullOrEmpty($Passwd)) {
        if ([System.IO.File]::Exists($SavedFile)) {
            $saved = $UTF8.GetString($([System.IO.File]::ReadAllBytes($SavedFile)))
            $Passwd = ConvertFrom-SecureString -AsPlainText (ConvertTo-SecureString -String $saved)
        }
        else {
            Write-Host "saved file not exist, please provied password with -Passwd parameter" -ForegroundColor:Red -BackgroundColor:Black
            return
        }
    }

    $Body = @{
        username = $Username
        password = [System.Convert]::ToBase64String($UTF8.GetBytes($Passwd))
        submit   = 'submit'
    }
    $resp = Invoke-RestMethod -Method Post -Uri $Uri -Body $Body
    $res = $UTF8.GetString($ISO.GetBytes($resp))

    $res
    if ($save -and $res.Contains('yuyun&')) {
        $Secstr = ConvertFrom-SecureString $(ConvertTo-SecureString -AsPlainText $Passwd)
        Write-Verbose "Save SecureString:\n$Secstr"
        $bytes = $UTF8.GetBytes($Secstr)
        [System.IO.File]::WriteAllBytes($SavedFile, $bytes)
    }
}

function SetProxy {
    param (
        $url
    )

    if ([String]::IsNullOrEmpty($url)) {
        Write-Verbose "no url specified, use default proxy url http://127.0.0.1:10809`nor you can use -url parameter change default proxy url"
        $url = 'http://127.0.0.1:10809'
    }
    Set-Content -Path Env:HTTP_PROXY -Value $url
    Set-Content -Path Env:HTTPS_PROXY -Value $url
}

function DelProxy {
    Set-Content -Path Env:HTTP_PROXY -Value ''
    Set-Content -Path Env:HTTPS_PROXY -Value ''
}

function DisplayInBytes {
    [CmdletBinding()]
    param (
        $filesize
    )
    $unit = "B", "KB", "MB", "GB", "TB", "PB"
    $index = 0
    while ($filesize -ge 1KB) {
        $filesize = $filesize / 1KB
        $index++
    }
    "{0:N1} {1}" -f $filesize, $unit[$index]
}
