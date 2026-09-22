Add-Type -AssemblyName System.Drawing
$src = [System.Drawing.Image]::FromFile('c:\Users\User\Desktop\vision\background.png')
$w = $src.Width
$h = $src.Height
Write-Host "Source: $w x $h"
$cropH = [int]($h * 0.70)
$dst = New-Object System.Drawing.Bitmap($w, $cropH)
$g = [System.Drawing.Graphics]::FromImage($dst)
$srcRect = New-Object System.Drawing.Rectangle(0, 0, $w, $cropH)
$dstRect = New-Object System.Drawing.Rectangle(0, 0, $w, $cropH)
$g.DrawImage($src, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$dst.Save('c:\Users\User\Desktop\vision\sail_text.png')
$dst.Dispose()
$src.Dispose()
Write-Host "Saved sail_text.png ($w x $cropH)"
