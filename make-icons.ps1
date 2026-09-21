Add-Type -AssemblyName System.Drawing

$dir = "C:\Users\MODEMS\Documents\Default Project\web-dialer"

function New-Icon($size, $path) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::FromArgb(255, 22, 115, 255))   # #1673FF

    $S = [double]$size
    # Трубка (телефонная, правильной ориентацией: наушник слева-сверху, микрофон справа-снизу)
    $w = 0.105 * $S                                        # толщина обводки
    $pen = New-Object System.Drawing.Pen([System.Drawing.Brushes]::White, $w)
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    # Наушник (верхнее «ухо» трубки)
    $g.DrawEllipse($pen, 0.175*$S, 0.07*$S, 0.29*$S, 0.40*$S)
    # Микрофон (нижний конец трубки)
    $g.DrawEllipse($pen, 0.535*$S, 0.53*$S, 0.29*$S, 0.40*$S)
    # Дуга-ручка трубки
    $g.DrawLine($pen, 0.415*$S, 0.425*$S, 0.585*$S, 0.575*$S)

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $pen.Dispose()
    Write-Output ("created: " + $path + " (" + $size + "px)")
}

New-Icon 512 (Join-Path $dir "icon-512.png")
New-Icon 192 (Join-Path $dir "icon-192.png")