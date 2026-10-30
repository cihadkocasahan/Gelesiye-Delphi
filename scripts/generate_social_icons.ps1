Add-Type -AssemblyName System.Drawing

function Create-RoundedIcon {
    param(
        [string]$Path,
        [int]$Size,
        [System.Drawing.Color]$BgColor,
        [string]$Text,
        [string]$FontName = "Segoe UI",
        [float]$FontSize = 12,
        [bool]$IsBold = $true
    )

    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.Clear([System.Drawing.Color]::Transparent)

    $brush = New-Object System.Drawing.SolidBrush $BgColor
    $rect = New-Object System.Drawing.Rectangle 1, 1, ($Size - 2), ($Size - 2)
    $g.FillEllipse($brush, $rect)

    $fontStyle = if ($IsBold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
    $font = New-Object System.Drawing.Font $FontName, $FontSize, $fontStyle
    $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $textRect = New-Object System.Drawing.RectangleF 0, 0, $Size, $Size
    $g.DrawString($Text, $font, $textBrush, $textRect, $sf)

    $g.Dispose()
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$iconDir = "D:\Gelesiye\assets\icons"

# WhatsApp (Green with phone/chat symbol)
Create-RoundedIcon -Path "$iconDir\whatsapp_24.png" -Size 24 -BgColor ([System.Drawing.Color]::FromArgb(37, 211, 102)) -Text [char]0x2706 -FontSize 11
Create-RoundedIcon -Path "$iconDir\whatsapp_32.png" -Size 32 -BgColor ([System.Drawing.Color]::FromArgb(37, 211, 102)) -Text [char]0x2706 -FontSize 15

# LinkedIn (Blue with "in")
Create-RoundedIcon -Path "$iconDir\linkedin_24.png" -Size 24 -BgColor ([System.Drawing.Color]::FromArgb(10, 102, 194)) -Text "in" -FontSize 9.5
Create-RoundedIcon -Path "$iconDir\linkedin_32.png" -Size 32 -BgColor ([System.Drawing.Color]::FromArgb(10, 102, 194)) -Text "in" -FontSize 13

# GitHub (Dark with "GH")
Create-RoundedIcon -Path "$iconDir\github_24.png" -Size 24 -BgColor ([System.Drawing.Color]::FromArgb(36, 41, 46)) -Text "GH" -FontSize 8 -FontName "Segoe UI Black"
Create-RoundedIcon -Path "$iconDir\github_32.png" -Size 32 -BgColor ([System.Drawing.Color]::FromArgb(36, 41, 46)) -Text "GH" -FontSize 10.5 -FontName "Segoe UI Black"

Write-Host "Social icons successfully generated in $iconDir"
