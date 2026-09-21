Add-Type -AssemblyName System.Drawing

$dir = "C:\Users\MODEMS\Documents\Default Project\web-dialer"
$src = Join-Path $dir "icon-src.jpg"
$img = [System.Drawing.Bitmap]::FromFile($src)
$Wi = $img.Width; $Hi = $img.Height

# Строго-синие пиксели трубки -> ограничивающий прямоугольник
$minx=$Wi; $miny=$Hi; $maxx=-1; $maxy=-1
for ($y=0; $y -lt $Hi; $y++){
  for ($x=0; $x -lt $Wi; $x++){
    $c=$img.GetPixel($x,$y)
    if ($c.B -gt ($c.R + 25) -and $c.B -gt 110){
      if ($x -lt $minx){$minx=$x}; if ($x -gt $maxx){$maxx=$x}
      if ($y -lt $miny){$miny=$y}; if ($y -gt $maxy){$maxy=$y}
    }
  }
}
$gw = $maxx - $minx + 1; $gh = $maxy - $miny + 1
Write-Output ("glyph bbox: {0}x{1}+{2}+{3}" -f $gw, $gh, $minx, $miny)

$M = 14   # запас по краям графики, px (до масштабирования)
$bx = [Math]::Max(0, $minx - $M); $by = [Math]::Max(0, $miny - $M)
$bw = [Math]::Min($Wi - $bx, $gw + 2*$M); $bh = [Math]::Min($Hi - $by, $gh + 2*$M)

function New-Icon($size, $path) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.Clear([System.Drawing.Color]::White)

    # трубка занимает ~78% плитки
    $target = [int]($size * 0.78)
    $scale = $target / [Math]::Max($bw, $bh)
    $dw = [int]($bw * $scale); $dh = [int]($bh * $scale)
    $dx = [int](($size - $dw) / 2); $dy = [int](($size - $dh) / 2)
    $srcRect = New-Object System.Drawing.Rectangle($bx, $by, $bw, $bh)
    $dstRect = New-Object System.Drawing.Rectangle($dx, $dy, $dw, $dh)
    $g.DrawImage($img, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output ("created: " + $path + " (" + $size + "px)")
}

New-Icon 512 (Join-Path $dir "icon-512.png")
New-Icon 192 (Join-Path $dir "icon-192.png")
$img.Dispose()