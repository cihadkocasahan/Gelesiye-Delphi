# ==============================================================================
# Gelesiye - Modern Icon Generator (PowerShell + System.Drawing)
# Generates 24x24, 32x32 PNG action icons and multi-res gelesiye.ico
# ==============================================================================

Add-Type -AssemblyName System.Drawing

$outDir = "d:\Gelesiye\assets\icons"
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

function New-Canvas([int]$size) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)
    return @{ Bitmap = $bmp; Graphics = $g; Size = $size }
}

function Save-Icon([hashtable]$canvas, [string]$name) {
    $path = Join-Path $outDir "$name.png"
    $canvas.Bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $canvas.Graphics.Dispose()
    $canvas.Bitmap.Dispose()
}

# --- 1. Cari Ekle (Mavi kart + Yeil Art) ---
function Draw-CariEkle([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # User silhouette (Navy Blue)
    $brushUser = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 136, 229))
    $g.FillEllipse($brushUser, 7 * $scale, 3 * $scale, 12 * $scale, 12 * $scale) # Head
    $g.FillPie($brushUser, 2 * $scale, 14 * $scale, 22 * $scale, 20 * $scale, 180, 180) # Body
    $brushUser.Dispose()

    # Green Plus Badge
    $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 46, 125, 50))
    $g.FillEllipse($badgeBrush, 17 * $scale, 17 * $scale, 14 * $scale, 14 * $scale)
    $badgeBrush.Dispose()

    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1.5, 2.2 * $scale))
    $g.DrawLine($penWhite, 24 * $scale, 20 * $scale, 24 * $scale, 28 * $scale)
    $g.DrawLine($penWhite, 20 * $scale, 24 * $scale, 28 * $scale, 24 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 2. Cari Dzenle (Mavi kart + Sar/Turuncu Kalem) ---
function Draw-CariDuzenle([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # User silhouette (Blue)
    $brushUser = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 136, 229))
    $g.FillEllipse($brushUser, 7 * $scale, 3 * $scale, 12 * $scale, 12 * $scale)
    $g.FillPie($brushUser, 2 * $scale, 14 * $scale, 22 * $scale, 20 * $scale, 180, 180)
    $brushUser.Dispose()

    # Pencil Badge (Orange)
    $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 239, 108, 0))
    $g.FillEllipse($badgeBrush, 17 * $scale, 17 * $scale, 14 * $scale, 14 * $scale)
    $badgeBrush.Dispose()

    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1.5, 2.0 * $scale))
    $g.DrawLine($penWhite, 21 * $scale, 27 * $scale, 27 * $scale, 21 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 3. Cari Sil (Mavi kart + Krmz arp) ---
function Draw-CariSil([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # User silhouette
    $brushUser = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 144, 156))
    $g.FillEllipse($brushUser, 7 * $scale, 3 * $scale, 12 * $scale, 12 * $scale)
    $g.FillPie($brushUser, 2 * $scale, 14 * $scale, 22 * $scale, 20 * $scale, 180, 180)
    $brushUser.Dispose()

    # Red Cross Badge
    $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 211, 47, 47))
    $g.FillEllipse($badgeBrush, 17 * $scale, 17 * $scale, 14 * $scale, 14 * $scale)
    $badgeBrush.Dispose()

    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [Math]::Max(1.5, 2.2 * $scale))
    $g.DrawLine($penWhite, 21 * $scale, 21 * $scale, 27 * $scale, 27 * $scale)
    $g.DrawLine($penWhite, 27 * $scale, 21 * $scale, 21 * $scale, 27 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 4. Cari Hareketler (Cari Defteri / Fatura Sayfas) ---
function Draw-Hareketler([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Document body
    $brushDoc = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 247, 250))
    $penBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 21, 101, 192), 2 * $scale)
    $g.FillRectangle($brushDoc, 5 * $scale, 3 * $scale, 22 * $scale, 26 * $scale)
    $g.DrawRectangle($penBorder, 5 * $scale, 3 * $scale, 22 * $scale, 26 * $scale)
    $brushDoc.Dispose()
    $penBorder.Dispose()

    # Horizontal ledger lines
    $penLine1 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 198, 40, 40), 1.8 * $scale) # Red Bor line
    $penLine2 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 46, 125, 50), 1.8 * $scale) # Green Alacak line
    $penLine3 = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 66, 66, 66), 1.8 * $scale) # Dark line
    $g.DrawLine($penLine3, 9 * $scale, 8 * $scale, 23 * $scale, 8 * $scale)
    $g.DrawLine($penLine1, 9 * $scale, 13 * $scale, 23 * $scale, 13 * $scale)
    $g.DrawLine($penLine2, 9 * $scale, 18 * $scale, 23 * $scale, 18 * $scale)
    $g.DrawLine($penLine3, 9 * $scale, 23 * $scale, 18 * $scale, 23 * $scale)
    $penLine1.Dispose()
    $penLine2.Dispose()
    $penLine3.Dispose()

    return $c
}

# --- 5. Bor Dekontu (F5 - Krmz [+] Fatura / Bor Girii) ---
function Draw-BorcDekontu([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Red circular background
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 211, 47, 47))
    $g.FillEllipse($brush, 2 * $scale, 2 * $scale, 28 * $scale, 28 * $scale)
    $brush.Dispose()

    # White Plus sign and TL symbol
    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 3 * $scale)
    $g.DrawLine($penWhite, 16 * $scale, 8 * $scale, 16 * $scale, 24 * $scale)
    $g.DrawLine($penWhite, 8 * $scale, 16 * $scale, 24 * $scale, 16 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 6. Tahsilat (F6 - Yeil [-] Nakit Girii / Tahsilat) ---
function Draw-Tahsilat([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Green circular background
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 46, 125, 50))
    $g.FillEllipse($brush, 2 * $scale, 2 * $scale, 28 * $scale, 28 * $scale)
    $brush.Dispose()

    # White Minus sign (bortan dm / tahsilat)
    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 3.5 * $scale)
    $g.DrawLine($penWhite, 8 * $scale, 16 * $scale, 24 * $scale, 16 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 7. Alacak Dekontu (F7 - Turuncu [-] Alacak Girii) ---
function Draw-AlacakDekontu([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Orange background
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 239, 108, 0))
    $g.FillEllipse($brush, 2 * $scale, 2 * $scale, 28 * $scale, 28 * $scale)
    $brush.Dispose()

    # White tag/receipt symbol
    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2.5 * $scale)
    $g.DrawRectangle($penWhite, 9 * $scale, 8 * $scale, 14 * $scale, 16 * $scale)
    $g.DrawLine($penWhite, 12 * $scale, 16 * $scale, 20 * $scale, 16 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 8. deme (F8 - Lacivert/Mavi [+] Kasa k / deme) ---
function Draw-Odeme([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Blue background
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 21, 101, 192))
    $g.FillEllipse($brush, 2 * $scale, 2 * $scale, 28 * $scale, 28 * $scale)
    $brush.Dispose()

    # Upward payment arrow
    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2.8 * $scale)
    $g.DrawLine($penWhite, 16 * $scale, 23 * $scale, 16 * $scale, 9 * $scale)
    $g.DrawLine($penWhite, 10 * $scale, 15 * $scale, 16 * $scale, 9 * $scale)
    $g.DrawLine($penWhite, 22 * $scale, 15 * $scale, 16 * $scale, 9 * $scale)
    $penWhite.Dispose()

    return $c
}

# --- 9. Yazdr / Rapor ---
function Draw-Yazdir([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Printer body
    $brushPrinter = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 69, 90, 100))
    $g.FillRectangle($brushPrinter, 5 * $scale, 11 * $scale, 22 * $scale, 12 * $scale)
    $brushPrinter.Dispose()

    # Paper top
    $brushPaper = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 236, 239, 241))
    $g.FillRectangle($brushPaper, 9 * $scale, 3 * $scale, 14 * $scale, 9 * $scale)
    $brushPaper.Dispose()

    # Paper bottom (printed sheet)
    $brushSheet = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $penSheet = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 176, 190, 197), 1 * $scale)
    $g.FillRectangle($brushSheet, 9 * $scale, 17 * $scale, 14 * $scale, 11 * $scale)
    $g.DrawRectangle($penSheet, 9 * $scale, 17 * $scale, 14 * $scale, 11 * $scale)
    $brushSheet.Dispose()
    $penSheet.Dispose()

    return $c
}

# --- 10. Topla / Hesap Makinesi / Sigma ---
function Draw-Toplam([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Calculator body
    $brushCalc = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 55, 71, 79))
    $g.FillRectangle($brushCalc, 6 * $scale, 3 * $scale, 20 * $scale, 26 * $scale)
    $brushCalc.Dispose()

    # Display (Teal/Green)
    $brushDisp = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 128, 203, 196))
    $g.FillRectangle($brushDisp, 9 * $scale, 6 * $scale, 14 * $scale, 6 * $scale)
    $brushDisp.Dispose()

    # Grid buttons
    $brushBtn = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 207, 216, 220))
    foreach ($row in 0..2) {
        foreach ($col in 0..2) {
            $g.FillRectangle($brushBtn, (9 + $col * 5) * $scale, (14 + $row * 4) * $scale, 3.5 * $scale, 2.5 * $scale)
        }
    }
    $brushBtn.Dispose()

    return $c
}

# --- 11. Firma / Bina ---
function Draw-Firma([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Office building
    $brushBldg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 41, 98, 255))
    $g.FillRectangle($brushBldg, 7 * $scale, 5 * $scale, 18 * $scale, 24 * $scale)
    $brushBldg.Dispose()

    # Windows
    $brushWin = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 227, 242, 253))
    foreach ($r in 0..3) {
        $g.FillRectangle($brushWin, 10 * $scale, (8 + $r * 4.5) * $scale, 3.5 * $scale, 3 * $scale)
        $g.FillRectangle($brushWin, 18.5 * $scale, (8 + $r * 4.5) * $scale, 3.5 * $scale, 3 * $scale)
    }
    $brushWin.Dispose()

    return $c
}

# --- 12. Devir (Dnen Oklar / Yl Sonu) ---
function Draw-Devir([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Purple circle background
    $brushBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 123, 31, 162))
    $g.FillEllipse($brushBg, 2 * $scale, 2 * $scale, 28 * $scale, 28 * $scale)
    $brushBg.Dispose()

    # Circular refresh arrows (White)
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2.5 * $scale)
    $g.DrawArc($pen, 7 * $scale, 7 * $scale, 18 * $scale, 18 * $scale, 30, 260)
    $pen.Dispose()

    # Arrowhead
    $brushWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $pts = @(
        [System.Drawing.PointF]::new(23 * $scale, 13 * $scale),
        [System.Drawing.PointF]::new(26 * $scale, 7 * $scale),
        [System.Drawing.PointF]::new(19 * $scale, 7 * $scale)
    )
    $g.FillPolygon($brushWhite, $pts)
    $brushWhite.Dispose()

    return $c
}

# --- 13. Kaydet (Disket / Onay) ---
function Draw-Kaydet([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    # Blue Floppy Disk
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 25, 118, 210))
    $g.FillRectangle($brush, 4 * $scale, 4 * $scale, 24 * $scale, 24 * $scale)
    $brush.Dispose()

    # White label
    $brushLabel = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillRectangle($brushLabel, 8 * $scale, 4 * $scale, 16 * $scale, 10 * $scale)
    $brushLabel.Dispose()

    return $c
}

# --- 14. Vazge (arp / Geri) ---
function Draw-Vazgec([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 144, 156))
    $g.FillEllipse($brush, 3 * $scale, 3 * $scale, 26 * $scale, 26 * $scale)
    $brush.Dispose()

    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2.8 * $scale)
    $g.DrawLine($pen, 10 * $scale, 10 * $scale, 22 * $scale, 22 * $scale)
    $g.DrawLine($pen, 22 * $scale, 10 * $scale, 10 * $scale, 22 * $scale)
    $pen.Dispose()

    return $c
}

# --- 15. nceki Cari (<) ---
function Draw-Onceki([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 55, 71, 79))
    $pts = @(
        [System.Drawing.PointF]::new(22 * $scale, 6 * $scale),
        [System.Drawing.PointF]::new(10 * $scale, 16 * $scale),
        [System.Drawing.PointF]::new(22 * $scale, 26 * $scale)
    )
    $g.FillPolygon($brush, $pts)
    $brush.Dispose()

    return $c
}

# --- 16. Sonraki Cari (>) ---
function Draw-Sonraki([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 55, 71, 79))
    $pts = @(
        [System.Drawing.PointF]::new(10 * $scale, 6 * $scale),
        [System.Drawing.PointF]::new(22 * $scale, 16 * $scale),
        [System.Drawing.PointF]::new(10 * $scale, 26 * $scale)
    )
    $g.FillPolygon($brush, $pts)
    $brush.Dispose()

    return $c
}

# --- 17. E-Posta ---
function Draw-Eposta([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = $s / 32.0

    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 2, 119, 189))
    $g.FillRectangle($brush, 4 * $scale, 7 * $scale, 24 * $scale, 18 * $scale)
    $brush.Dispose()

    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 1.8 * $scale)
    $g.DrawLine($pen, 4 * $scale, 7 * $scale, 16 * $scale, 17 * $scale)
    $g.DrawLine($pen, 28 * $scale, 7 * $scale, 16 * $scale, 17 * $scale)
    $pen.Dispose()

    return $c
}

# --- 18. Ana Uygulama İkonu (Gelesiye Logo & Muhasebe Defteri) ---
function Draw-GelesiyeApp([int]$s) {
    $c = New-Canvas $s
    $g = $c.Graphics
    $scale = [float]($s / 32.0)

    # Rich Gradient / Rounded Badge
    $brushBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 21, 101, 192))
    $g.FillRectangle($brushBg, [float](2 * $scale), [float](2 * $scale), [float](28 * $scale), [float](28 * $scale))
    $brushBg.Dispose()

    # Gold Coin / Seal Accent
    $brushGold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 179, 0))
    $g.FillEllipse($brushGold, [float](16 * $scale), [float](16 * $scale), [float](13 * $scale), [float](13 * $scale))
    $brushGold.Dispose()

    # White Letter 'G' for Gelesiye
    $fontSize = [Math]::Max(7.0, [float](14.0 * $scale))
    $font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
    $brushWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF([float](2 * $scale), [float](2 * $scale), [float](28 * $scale), [float](28 * $scale))
    $g.DrawString("G", $font, $brushWhite, $rect, $sf)
    $brushWhite.Dispose()
    $font.Dispose()
    $sf.Dispose()

    return $c
}

# --- ICO Dosyası Oluşturucu (Multi-resolution: 256, 128, 48, 32, 16) ---
function Create-IcoFile([string]$destIcoPath) {
    $sizes = @(256, 128, 48, 32, 16)
    $images = @()

    foreach ($sz in $sizes) {
        $c = Draw-GelesiyeApp $sz
        $ms = New-Object System.IO.MemoryStream
        $c.Bitmap.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
        $bytes = $ms.ToArray()
        $images += @{ Size = $sz; Bytes = $bytes }
        $c.Graphics.Dispose()
        $c.Bitmap.Dispose()
        $ms.Dispose()
    }

    $fs = [System.IO.File]::Create($destIcoPath)
    $bw = New-Object System.IO.BinaryWriter($fs)

    # ICO Header: 0, 1 (ICO type), count
    $bw.Write([uint16]0)
    $bw.Write([uint16]1)
    $bw.Write([uint16]$images.Count)

    [uint32]$currentOffset = [uint32](6 + ($images.Count * 16))

    # Directory Entries
    foreach ($img in $images) {
        $w = if ($img.Size -ge 256) { [byte]0 } else { [byte]$img.Size }
        $h = if ($img.Size -ge 256) { [byte]0 } else { [byte]$img.Size }
        $bw.Write([byte]$w)
        $bw.Write([byte]$h)
        $bw.Write([byte]0) # Color palette count
        $bw.Write([byte]0) # Reserved
        $bw.Write([uint16]1) # Color planes
        $bw.Write([uint16]32) # Bits per pixel
        $bw.Write([uint32]$img.Bytes.Length)
        $bw.Write([uint32]$currentOffset)
        $currentOffset = [uint32]($currentOffset + $img.Bytes.Length)
    }

    # Image PNG Data
    foreach ($img in $images) {
        $bw.Write($img.Bytes)
    }

    $bw.Close()
    $fs.Close()
    Write-Output "Created: $destIcoPath"
}

# Render all icons in 24x24 and 32x32
Write-Output "Rendering Gelesiye Action Icons..."

$renderList = @(
    @{ Name = "cari_ekle"; Draw = { param($s) Draw-CariEkle $s } },
    @{ Name = "cari_duzenle"; Draw = { param($s) Draw-CariDuzenle $s } },
    @{ Name = "cari_sil"; Draw = { param($s) Draw-CariSil $s } },
    @{ Name = "hareketler"; Draw = { param($s) Draw-Hareketler $s } },
    @{ Name = "borc_dekontu"; Draw = { param($s) Draw-BorcDekontu $s } },
    @{ Name = "tahsilat"; Draw = { param($s) Draw-Tahsilat $s } },
    @{ Name = "alacak_dekontu"; Draw = { param($s) Draw-AlacakDekontu $s } },
    @{ Name = "odeme"; Draw = { param($s) Draw-Odeme $s } },
    @{ Name = "yazdir"; Draw = { param($s) Draw-Yazdir $s } },
    @{ Name = "toplam"; Draw = { param($s) Draw-Toplam $s } },
    @{ Name = "firma"; Draw = { param($s) Draw-Firma $s } },
    @{ Name = "devir"; Draw = { param($s) Draw-Devir $s } },
    @{ Name = "kaydet"; Draw = { param($s) Draw-Kaydet $s } },
    @{ Name = "vazgec"; Draw = { param($s) Draw-Vazgec $s } },
    @{ Name = "onceki"; Draw = { param($s) Draw-Onceki $s } },
    @{ Name = "sonraki"; Draw = { param($s) Draw-Sonraki $s } },
    @{ Name = "eposta"; Draw = { param($s) Draw-Eposta $s } },
    @{ Name = "gelesiye_app"; Draw = { param($s) Draw-GelesiyeApp $s } }
)

foreach ($item in $renderList) {
    # 24x24 (Toolbar / Button standard)
    $c24 = & $item.Draw 24
    Save-Icon $c24 "$($item.Name)_24"

    # 32x32 (Large Button / High DPI)
    $c32 = & $item.Draw 32
    Save-Icon $c32 "$($item.Name)_32"
}

# Generate ICO file
Create-IcoFile (Join-Path $outDir "gelesiye.ico")

Write-Output "[OK] All icons generated successfully in $outDir"
