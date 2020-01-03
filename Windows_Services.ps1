param(
    $option #stop or start
    ,$svcName
)

if($option -eq "stop")
{ $check = "stopped" }
elseif($option -eq "start")
{ $check = "running" } 

Get-Service | Where-Object{ $_.Name -like "$svcName" } | ForEach-Object{ 
    if($_.Status -ne $check)
    {
        sc.exe $option $_

        for($x=0;$x -lt 10;$x++)
        {
            $getStatus = Get-Service $_.Name
            if($getStatus.Status -eq $check)
            { 
                $getStatus
                Break
            }
            else
            { Start-Sleep -Seconds 3 }
        }

        if($x -eq 10)
        { 
            Write-Host "Unable to $option service"
            Exit 3
        }
    }
    else
    { $_ }
}