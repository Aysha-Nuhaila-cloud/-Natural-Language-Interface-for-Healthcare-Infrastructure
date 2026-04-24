Add-Type -AssemblyName System.Drawing

function New-Color {
    param(
        [string]$Hex,
        [int]$Alpha = 255
    )

    $clean = $Hex.TrimStart("#")
    $r = [Convert]::ToInt32($clean.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($clean.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($clean.Substring(4, 2), 16)
    return [System.Drawing.Color]::FromArgb($Alpha, $r, $g, $b)
}

function New-RoundedPath {
    param(
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius
    )

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = $Radius * 2

    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-RoundedBox {
    param(
        $Graphics,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [string]$Title,
        [string]$Body = "",
        [System.Drawing.Color]$FillColor,
        [System.Drawing.Color]$BorderColor,
        [System.Drawing.Color]$TitleColor,
        [System.Drawing.Color]$BodyColor,
        [int]$Radius = 24
    )

    $path = New-RoundedPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $fillBrush = New-Object System.Drawing.SolidBrush($FillColor)
    $borderPen = New-Object System.Drawing.Pen($BorderColor, 2)
    $titleBrush = New-Object System.Drawing.SolidBrush($TitleColor)
    $bodyBrush = New-Object System.Drawing.SolidBrush($BodyColor)
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 17, [System.Drawing.FontStyle]::Bold)
    $bodyFont = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Near

    $Graphics.FillPath($fillBrush, $path)
    $Graphics.DrawPath($borderPen, $path)

    $titleRect = [System.Drawing.RectangleF]::new(
        [float]($X + 15),
        [float]($Y + 14),
        [float]($Width - 30),
        [float]38
    )
    $Graphics.DrawString($Title, $titleFont, $titleBrush, $titleRect, $sf)

    if ($Body) {
        $bodyRect = [System.Drawing.RectangleF]::new(
            [float]($X + 18),
            [float]($Y + 52),
            [float]($Width - 36),
            [float]($Height - 60)
        )
        $Graphics.DrawString($Body, $bodyFont, $bodyBrush, $bodyRect)
    }

    $titleFont.Dispose()
    $bodyFont.Dispose()
    $fillBrush.Dispose()
    $borderPen.Dispose()
    $titleBrush.Dispose()
    $bodyBrush.Dispose()
    $sf.Dispose()
    $path.Dispose()
}

function Draw-Section {
    param(
        $Graphics,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [string]$Title
    )

    $fill = New-Color "#0E1828" 212
    $border = New-Color "#2F4A68" 255
    Draw-RoundedBox -Graphics $Graphics -X $X -Y $Y -Width $Width -Height $Height `
        -Title $Title -Body "" -FillColor $fill -BorderColor $border `
        -TitleColor (New-Color "#EAF4FF") -BodyColor (New-Color "#AFC4D9") -Radius 28
}

function Draw-Arrow {
    param(
        $Graphics,
        [float]$X1,
        [float]$Y1,
        [float]$X2,
        [float]$Y2,
        [System.Drawing.Color]$Color,
        [float]$Width = 4
    )

    $pen = New-Object System.Drawing.Pen($Color, $Width)
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::RoundAnchor
    $Graphics.DrawLine($pen, $X1, $Y1, $X2, $Y2)
    $pen.Dispose()
}

function Draw-Label {
    param(
        $Graphics,
        [string]$Text,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$FontSize = 13
    )

    $font = New-Object System.Drawing.Font("Segoe UI", $FontSize, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush((New-Color "#9FDDBD"))
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = [System.Drawing.RectangleF]::new(
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height
    )
    $Graphics.DrawString($Text, $font, $brush, $rect, $format)
    $font.Dispose()
    $brush.Dispose()
    $format.Dispose()
}

function Draw-Title {
    param(
        $Graphics,
        [string]$Text,
        [string]$Subtitle
    )

    $titleFont = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
    $subFont = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Regular)
    $titleBrush = New-Object System.Drawing.SolidBrush((New-Color "#F3F8FF"))
    $subBrush = New-Object System.Drawing.SolidBrush((New-Color "#AFC4D9"))
    $Graphics.DrawString($Text, $titleFont, $titleBrush, 55, 36)
    $Graphics.DrawString($Subtitle, $subFont, $subBrush, 58, 82)
    $titleFont.Dispose()
    $subFont.Dispose()
    $titleBrush.Dispose()
    $subBrush.Dispose()
}

function New-Canvas {
    param(
        [int]$Width,
        [int]$Height
    )

    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $graphics.Clear((New-Color "#07111A"))

    $bgBrush1 = New-Object System.Drawing.SolidBrush((New-Color "#123E52" 42))
    $bgBrush2 = New-Object System.Drawing.SolidBrush((New-Color "#62D2A2" 22))
    $graphics.FillEllipse($bgBrush1, -100, -60, 420, 300)
    $graphics.FillEllipse($bgBrush2, 1180, 720, 500, 360)
    $bgBrush1.Dispose()
    $bgBrush2.Dispose()

    return @($bitmap, $graphics)
}

function Save-Canvas {
    param(
        $Bitmap,
        $Graphics,
        [string]$Path
    )

    $directory = Split-Path -Parent $Path
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory | Out-Null
    }

    $Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $Graphics.Dispose()
    $Bitmap.Dispose()
}

function Draw-HLDImage {
    param([string]$Path)

    $canvas = New-Canvas -Width 1800 -Height 1080
    $bmp = $canvas[0]
    $g = $canvas[1]

    Draw-Title -Graphics $g `
        -Text "High Level Design - Healthcare Chatbot" `
        -Subtitle "Architecture view for CLI, website, server, chatbot engine, and data layer"

    Draw-Section -Graphics $g -X 60 -Y 150 -Width 270 -Height 760 -Title "Client Side"
    Draw-Section -Graphics $g -X 410 -Y 150 -Width 360 -Height 760 -Title "Presentation Layer"
    Draw-Section -Graphics $g -X 850 -Y 150 -Width 360 -Height 760 -Title "Application Layer"
    Draw-Section -Graphics $g -X 1290 -Y 150 -Width 450 -Height 760 -Title "Data Layer"

    $nodeFill = New-Color "#14263A" 245
    $nodeBorder = New-Color "#4B6B91"
    $titleColor = New-Color "#F3F8FF"
    $bodyColor = New-Color "#B5C7D9"

    Draw-RoundedBox -Graphics $g -X 90 -Y 270 -Width 210 -Height 120 `
        -Title "CLI User" -Body "Uses terminal commands to interact with the chatbot." `
        -FillColor $nodeFill -BorderColor $nodeBorder -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 90 -Y 560 -Width 210 -Height 120 `
        -Title "Web User" -Body "Uses the website and floating chat panel in the browser." `
        -FillColor $nodeFill -BorderColor $nodeBorder -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 470 -Y 245 -Width 240 -Height 145 `
        -Title "CLI Application" -Body "Reads console input and prints healthcare responses." `
        -FillColor (New-Color "#103047" 250) -BorderColor (New-Color "#61A7FF") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 470 -Y 535 -Width 240 -Height 170 `
        -Title "Healthcare Website" -Body "Dark-theme interface with hero section, floating chatbot button, and clickable command buttons." `
        -FillColor (New-Color "#103047" 250) -BorderColor (New-Color "#61A7FF") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 910 -Y 280 -Width 240 -Height 145 `
        -Title "Python Web Server" -Body "Serves web pages and exposes /api/commands and /api/chat endpoints." `
        -FillColor (New-Color "#173429" 250) -BorderColor (New-Color "#62D2A2") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 910 -Y 540 -Width 240 -Height 165 `
        -Title "Chatbot Engine" -Body "Normalizes text, matches phrases and keywords, and returns predefined healthcare responses." `
        -FillColor (New-Color "#173429" 250) -BorderColor (New-Color "#62D2A2") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 1350 -Y 265 -Width 330 -Height 150 `
        -Title "Command Catalogue" -Body "In-memory list of healthcare commands, keywords, phrases, and responses." `
        -FillColor (New-Color "#3A2811" 245) -BorderColor (New-Color "#F0B35D") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 1350 -Y 535 -Width 330 -Height 150 `
        -Title "Static Web Assets" -Body "HTML, CSS, and JavaScript files used to render the website and chatbot UI." `
        -FillColor (New-Color "#3A2811" 245) -BorderColor (New-Color "#F0B35D") `
        -TitleColor $titleColor -BodyColor $bodyColor

    $arrowColor = New-Color "#8EC9FF"
    $greenArrow = New-Color "#83E0B8"
    $goldArrow = New-Color "#F3C06D"

    Draw-Arrow -Graphics $g -X1 300 -Y1 330 -X2 470 -Y2 318 -Color $arrowColor
    Draw-Arrow -Graphics $g -X1 300 -Y1 620 -X2 470 -Y2 620 -Color $arrowColor
    Draw-Arrow -Graphics $g -X1 710 -Y1 620 -X2 910 -Y2 352 -Color $greenArrow
    Draw-Arrow -Graphics $g -X1 710 -Y1 318 -X2 910 -Y2 620 -Color $greenArrow
    Draw-Arrow -Graphics $g -X1 1150 -Y1 620 -X2 1350 -Y2 340 -Color $goldArrow
    Draw-Arrow -Graphics $g -X1 1150 -Y1 352 -X2 1350 -Y2 610 -Color $goldArrow
    Draw-Arrow -Graphics $g -X1 710 -Y1 318 -X2 910 -Y2 318 -Color $greenArrow
    Draw-Arrow -Graphics $g -X1 710 -Y1 620 -X2 910 -Y2 620 -Color $greenArrow

    Draw-Label -Graphics $g -Text "CLI Query Flow" -X 330 -Y 286 -Width 140 -Height 26
    Draw-Label -Graphics $g -Text "Web Request Flow" -X 320 -Y 595 -Width 160 -Height 26
    Draw-Label -Graphics $g -Text "Command Data Lookup" -X 1160 -Y 315 -Width 190 -Height 26
    Draw-Label -Graphics $g -Text "Asset Delivery" -X 1188 -Y 584 -Width 132 -Height 26

    Draw-RoundedBox -Graphics $g -X 470 -Y 765 -Width 680 -Height 110 `
        -Title "High-Level Summary" `
        -Body "The presentation layer collects the healthcare query, the application layer processes the request through the chatbot engine, and the data layer provides command definitions or static website resources." `
        -FillColor (New-Color "#0D2233" 238) -BorderColor (New-Color "#4E719A") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-LLDImage {
    param([string]$Path)

    $canvas = New-Canvas -Width 1800 -Height 1180
    $bmp = $canvas[0]
    $g = $canvas[1]

    Draw-Title -Graphics $g `
        -Text "Low Level Design - Healthcare Chatbot" `
        -Subtitle "Detailed module interactions, API handling, and keyword matching workflow"

    Draw-Section -Graphics $g -X 55 -Y 150 -Width 780 -Height 960 -Title "Module Interaction View"
    Draw-Section -Graphics $g -X 905 -Y 150 -Width 840 -Height 960 -Title "Detailed Processing Flow"

    $fillA = New-Color "#133149" 248
    $fillB = New-Color "#163528" 248
    $fillC = New-Color "#3A2811" 248
    $borderA = New-Color "#61A7FF"
    $borderB = New-Color "#62D2A2"
    $borderC = New-Color "#F0B35D"
    $titleColor = New-Color "#F3F8FF"
    $bodyColor = New-Color "#B5C7D9"

    Draw-RoundedBox -Graphics $g -X 115 -Y 260 -Width 260 -Height 140 `
        -Title "cli_chatbot.py" `
        -Body "Starts the terminal loop, checks exit keywords, and prints bot replies." `
        -FillColor $fillA -BorderColor $borderA -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 455 -Y 240 -Width 290 -Height 180 `
        -Title "healthcare_bot.py" `
        -Body "Contains constants, command definitions, normalization logic, scoring logic, quick command generation, and chatbot_reply()." `
        -FillColor $fillB -BorderColor $borderB -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 115 -Y 530 -Width 260 -Height 155 `
        -Title "app.py" `
        -Body "Handles HTTP GET and POST routes, serves static files, and calls the chatbot engine." `
        -FillColor $fillA -BorderColor $borderA -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 455 -Y 520 -Width 290 -Height 175 `
        -Title "script.js" `
        -Body "Loads commands, opens and closes the chat panel, sends fetch requests, and renders chat messages." `
        -FillColor $fillA -BorderColor $borderA -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 115 -Y 820 -Width 260 -Height 150 `
        -Title "index.html" `
        -Body "Defines the landing page, chatbot structure, command grid, and input form." `
        -FillColor $fillC -BorderColor $borderC -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 455 -Y 820 -Width 290 -Height 150 `
        -Title "style.css" `
        -Body "Applies dark theme, floating chat button, layout, and responsive design behavior." `
        -FillColor $fillC -BorderColor $borderC -TitleColor $titleColor -BodyColor $bodyColor

    Draw-Arrow -Graphics $g -X1 375 -Y1 330 -X2 455 -Y2 330 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 245 -Y1 530 -X2 245 -Y2 400 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 375 -Y1 605 -X2 455 -Y2 605 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 600 -Y1 420 -X2 600 -Y2 520 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 245 -Y1 820 -X2 245 -Y2 685 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 600 -Y1 820 -X2 600 -Y2 695 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 260 -Y1 900 -X2 455 -Y2 900 -Color (New-Color "#F3C06D")

    Draw-Label -Graphics $g -Text "Function call" -X 388 -Y 301 -Width 88 -Height 24 -FontSize 11
    Draw-Label -Graphics $g -Text "HTTP route handling" -X 360 -Y 576 -Width 150 -Height 24 -FontSize 11
    Draw-Label -Graphics $g -Text "UI logic" -X 620 -Y 448 -Width 90 -Height 24 -FontSize 11

    $stepFill = New-Color "#0F2736" 248
    $stepBorder = New-Color "#4E90B8"
    $stepTitle = New-Color "#F3F8FF"
    $stepBody = New-Color "#C0D1E1"

    Draw-RoundedBox -Graphics $g -X 970 -Y 225 -Width 270 -Height 95 `
        -Title "1. Receive Input" `
        -Body "Query comes from text box, button click, or CLI." `
        -FillColor $stepFill -BorderColor $stepBorder -TitleColor $stepTitle -BodyColor $stepBody -Radius 20

    Draw-RoundedBox -Graphics $g -X 970 -Y 360 -Width 270 -Height 95 `
        -Title "2. Normalize Text" `
        -Body "Lowercase conversion, punctuation removal, and space cleanup." `
        -FillColor $stepFill -BorderColor $stepBorder -TitleColor $stepTitle -BodyColor $stepBody -Radius 20

    Draw-RoundedBox -Graphics $g -X 970 -Y 495 -Width 270 -Height 95 `
        -Title "3. Phrase Match" `
        -Body "Check exact phrase and contained phrase matches first." `
        -FillColor $stepFill -BorderColor $stepBorder -TitleColor $stepTitle -BodyColor $stepBody -Radius 20

    Draw-RoundedBox -Graphics $g -X 970 -Y 630 -Width 270 -Height 95 `
        -Title "4. Keyword Match" `
        -Body "Compare words and substrings against command keywords." `
        -FillColor $stepFill -BorderColor $stepBorder -TitleColor $stepTitle -BodyColor $stepBody -Radius 20

    Draw-RoundedBox -Graphics $g -X 970 -Y 765 -Width 270 -Height 95 `
        -Title "5. Score Commands" `
        -Body "Assign relevance points and track the best scoring command." `
        -FillColor $stepFill -BorderColor $stepBorder -TitleColor $stepTitle -BodyColor $stepBody -Radius 20

    Draw-RoundedBox -Graphics $g -X 1365 -Y 360 -Width 290 -Height 120 `
        -Title "6. Best Match?" `
        -Body "If best score is greater than zero, prepare the mapped healthcare response." `
        -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") `
        -TitleColor $stepTitle -BodyColor $stepBody -Radius 22

    Draw-RoundedBox -Graphics $g -X 1365 -Y 560 -Width 290 -Height 120 `
        -Title "7. Return Response" `
        -Body "Send reply JSON to the website or print the text in the CLI." `
        -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") `
        -TitleColor $stepTitle -BodyColor $stepBody -Radius 22

    Draw-RoundedBox -Graphics $g -X 1365 -Y 760 -Width 290 -Height 120 `
        -Title "Fallback Path" `
        -Body "If there is no match, respond with guidance and suggest supported commands." `
        -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") `
        -TitleColor $stepTitle -BodyColor $stepBody -Radius 22

    Draw-Arrow -Graphics $g -X1 1105 -Y1 320 -X2 1105 -Y2 360 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 1105 -Y1 455 -X2 1105 -Y2 495 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 1105 -Y1 590 -X2 1105 -Y2 630 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 1105 -Y1 725 -X2 1105 -Y2 765 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 1240 -Y1 812 -X2 1365 -Y2 815 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 1240 -Y1 545 -X2 1365 -Y2 420 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1510 -Y1 480 -X2 1510 -Y2 560 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1510 -Y1 680 -X2 1510 -Y2 760 -Color (New-Color "#F3C06D")

    Draw-Label -Graphics $g -Text "Yes" -X 1260 -Y 465 -Width 60 -Height 24 -FontSize 11
    Draw-Label -Graphics $g -Text "No" -X 1480 -Y 710 -Width 60 -Height 24 -FontSize 11

    Draw-RoundedBox -Graphics $g -X 970 -Y 920 -Width 685 -Height 125 `
        -Title "Implementation Notes" `
        -Body "The low-level design shows how the frontend, request handler, and chatbot engine collaborate. The response path is deterministic because matching relies on fixed keywords, phrases, and predefined healthcare text stored in memory." `
        -FillColor (New-Color "#0D2233" 238) -BorderColor (New-Color "#4E719A") `
        -TitleColor $titleColor -BodyColor $bodyColor

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

$outputDir = Join-Path $PSScriptRoot "design_images"
Draw-HLDImage -Path (Join-Path $outputDir "high_level_design.png")
Draw-LLDImage -Path (Join-Path $outputDir "low_level_design.png")
Write-Output "Generated design images in $outputDir"
