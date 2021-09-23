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
        $Passwd = 'Fh0211004565'
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
