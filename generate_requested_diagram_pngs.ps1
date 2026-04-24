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

function New-DiamondPath {
    param(
        [float]$CenterX,
        [float]$CenterY,
        [float]$Width,
        [float]$Height
    )

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $points = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new([float]$CenterX, [float]($CenterY - $Height / 2)),
        [System.Drawing.PointF]::new([float]($CenterX + $Width / 2), [float]$CenterY),
        [System.Drawing.PointF]::new([float]$CenterX, [float]($CenterY + $Height / 2)),
        [System.Drawing.PointF]::new([float]($CenterX - $Width / 2), [float]$CenterY)
    )
    $path.AddPolygon($points)
    return $path
}

function New-Canvas {
    param(
        [int]$Width = 1800,
        [int]$Height = 1080
    )

    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $graphics.Clear((New-Color "#07111A"))

    $bgBrush1 = New-Object System.Drawing.SolidBrush((New-Color "#15384A" 38))
    $bgBrush2 = New-Object System.Drawing.SolidBrush((New-Color "#62D2A2" 20))
    $graphics.FillEllipse($bgBrush1, -120, -80, 460, 330)
    $graphics.FillEllipse($bgBrush2, 1260, 700, 460, 320)
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

    $folder = Split-Path -Parent $Path
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }

    $Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $Graphics.Dispose()
    $Bitmap.Dispose()
}

function Draw-Title {
    param(
        $Graphics,
        [string]$Title,
        [string]$Subtitle
    )

    $titleFont = New-Object System.Drawing.Font("Segoe UI", 27, [System.Drawing.FontStyle]::Bold)
    $subFont = New-Object System.Drawing.Font("Segoe UI", 12.5, [System.Drawing.FontStyle]::Regular)
    $titleBrush = New-Object System.Drawing.SolidBrush((New-Color "#F3F8FF"))
    $subBrush = New-Object System.Drawing.SolidBrush((New-Color "#AEC4D8"))
    $Graphics.DrawString($Title, $titleFont, $titleBrush, 48, 34)
    $Graphics.DrawString($Subtitle, $subFont, $subBrush, 50, 80)
    $titleFont.Dispose()
    $subFont.Dispose()
    $titleBrush.Dispose()
    $subBrush.Dispose()
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
        [int]$Radius = 22,
        [float]$TitleFontSize = 16,
        [float]$BodyFontSize = 9.5
    )

    $path = New-RoundedPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $fillBrush = New-Object System.Drawing.SolidBrush($FillColor)
    $borderPen = New-Object System.Drawing.Pen($BorderColor, 2)
    $titleBrush = New-Object System.Drawing.SolidBrush($TitleColor)
    $bodyBrush = New-Object System.Drawing.SolidBrush($BodyColor)
    $titleFont = New-Object System.Drawing.Font("Segoe UI", $TitleFontSize, [System.Drawing.FontStyle]::Bold)
    $bodyFont = New-Object System.Drawing.Font("Segoe UI", $BodyFontSize, [System.Drawing.FontStyle]::Regular)
    $center = New-Object System.Drawing.StringFormat
    $center.Alignment = [System.Drawing.StringAlignment]::Center
    $center.LineAlignment = [System.Drawing.StringAlignment]::Near

    $Graphics.FillPath($fillBrush, $path)
    $Graphics.DrawPath($borderPen, $path)

    $titleRect = [System.Drawing.RectangleF]::new(
        [float]($X + 14),
        [float]($Y + 12),
        [float]($Width - 28),
        [float]36
    )
    $Graphics.DrawString($Title, $titleFont, $titleBrush, $titleRect, $center)

    if ($Body) {
        $bodyRect = [System.Drawing.RectangleF]::new(
            [float]($X + 16),
            [float]($Y + 46),
            [float]($Width - 32),
            [float]($Height - 54)
        )
        $Graphics.DrawString($Body, $bodyFont, $bodyBrush, $bodyRect)
    }

    $fillBrush.Dispose()
    $borderPen.Dispose()
    $titleBrush.Dispose()
    $bodyBrush.Dispose()
    $titleFont.Dispose()
    $bodyFont.Dispose()
    $center.Dispose()
    $path.Dispose()
}

function Draw-Diamond {
    param(
        $Graphics,
        [float]$CenterX,
        [float]$CenterY,
        [float]$Width,
        [float]$Height,
        [string]$Text,
        [System.Drawing.Color]$FillColor,
        [System.Drawing.Color]$BorderColor
    )

    $path = New-DiamondPath -CenterX $CenterX -CenterY $CenterY -Width $Width -Height $Height
    $fillBrush = New-Object System.Drawing.SolidBrush($FillColor)
    $pen = New-Object System.Drawing.Pen($BorderColor, 2)
    $font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush((New-Color "#F3F8FF"))
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = [System.Drawing.RectangleF]::new([float]($CenterX - $Width / 2), [float]($CenterY - $Height / 2), [float]$Width, [float]$Height)

    $Graphics.FillPath($fillBrush, $path)
    $Graphics.DrawPath($pen, $path)
    $Graphics.DrawString($Text, $font, $brush, $rect, $format)

    $fillBrush.Dispose()
    $pen.Dispose()
    $font.Dispose()
    $brush.Dispose()
    $format.Dispose()
    $path.Dispose()
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
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
    $Graphics.DrawLine($pen, $X1, $Y1, $X2, $Y2)
    $pen.Dispose()
}

function Draw-Line {
    param(
        $Graphics,
        [float]$X1,
        [float]$Y1,
        [float]$X2,
        [float]$Y2,
        [System.Drawing.Color]$Color,
        [float]$Width = 3,
        [bool]$Dashed = $false
    )

    $pen = New-Object System.Drawing.Pen($Color, $Width)
    if ($Dashed) {
        $pen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
    }
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
        [float]$FontSize = 11,
        [string]$ColorHex = "#9FDDBD"
    )

    $font = New-Object System.Drawing.Font("Segoe UI", $FontSize, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush((New-Color $ColorHex))
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = [System.Drawing.RectangleF]::new([float]$X, [float]$Y, [float]$Width, [float]$Height)
    $Graphics.DrawString($Text, $font, $brush, $rect, $format)
    $font.Dispose()
    $brush.Dispose()
    $format.Dispose()
}

function Draw-HLArchitecture {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]

    Draw-Title -Graphics $g -Title "High Level Architecture Diagram" -Subtitle "Healthcare chatbot architecture across client, presentation, application, and data layers"

    Draw-RoundedBox -Graphics $g -X 70 -Y 165 -Width 250 -Height 720 -Title "Client Layer" -FillColor (New-Color "#0E1828" 214) -BorderColor (New-Color "#2D4560") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 395 -Y 165 -Width 340 -Height 720 -Title "Presentation Layer" -FillColor (New-Color "#0E1828" 214) -BorderColor (New-Color "#2D4560") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 810 -Y 165 -Width 340 -Height 720 -Title "Application Layer" -FillColor (New-Color "#0E1828" 214) -BorderColor (New-Color "#2D4560") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1225 -Y 165 -Width 500 -Height 720 -Title "Data Layer" -FillColor (New-Color "#0E1828" 214) -BorderColor (New-Color "#2D4560") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")

    $titleColor = New-Color "#F3F8FF"
    $bodyColor = New-Color "#B5C7D9"
    Draw-RoundedBox -Graphics $g -X 100 -Y 285 -Width 190 -Height 115 -Title "CLI User" -Body "Uses terminal commands to ask healthcare queries." -FillColor (New-Color "#16273C" 245) -BorderColor (New-Color "#5E87B5") -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 100 -Y 575 -Width 190 -Height 115 -Title "Web User" -Body "Uses the website and chatbot panel in the browser." -FillColor (New-Color "#16273C" 245) -BorderColor (New-Color "#5E87B5") -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 470 -Y 255 -Width 190 -Height 130 -Title "CLI Interface" -Body "Reads input and prints responses." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 470 -Y 540 -Width 190 -Height 155 -Title "Web Interface" -Body "Dark-theme website with floating button and clickable commands." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 885 -Y 260 -Width 190 -Height 130 -Title "Python Server" -Body "Serves pages and APIs." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 885 -Y 545 -Width 190 -Height 155 -Title "Chatbot Engine" -Body "Matches keywords and phrases to predefined responses." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor $titleColor -BodyColor $bodyColor

    Draw-RoundedBox -Graphics $g -X 1310 -Y 260 -Width 330 -Height 145 -Title "Command Catalogue" -Body "Healthcare commands, prompts, keywords, phrases, and responses." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 1310 -Y 545 -Width 330 -Height 145 -Title "Static Assets" -Body "HTML, CSS, and JavaScript files for the website." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor $titleColor -BodyColor $bodyColor

    Draw-Arrow -Graphics $g -X1 290 -Y1 342 -X2 470 -Y2 320 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 290 -Y1 632 -X2 470 -Y2 620 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 660 -Y1 320 -X2 885 -Y2 620 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 660 -Y1 620 -X2 885 -Y2 325 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1075 -Y1 325 -X2 1310 -Y2 332 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 1075 -Y1 620 -X2 1310 -Y2 617 -Color (New-Color "#F3C06D")

    Draw-Label -Graphics $g -Text "CLI query" -X 330 -Y 295 -Width 120 -Height 24
    Draw-Label -Graphics $g -Text "Web request" -X 330 -Y 602 -Width 120 -Height 24
    Draw-Label -Graphics $g -Text "API call" -X 690 -Y 430 -Width 110 -Height 24
    Draw-Label -Graphics $g -Text "Command lookup" -X 1145 -Y 300 -Width 150 -Height 24
    Draw-Label -Graphics $g -Text "Asset load" -X 1170 -Y 585 -Width 120 -Height 24

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-HLProcessFlow {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]
    Draw-Title -Graphics $g -Title "High Level Process Flow Diagram" -Subtitle "Top-level lifecycle from user query to healthcare response"

    $fill = New-Color "#12324A" 248
    $border = New-Color "#61A7FF"
    $titleColor = New-Color "#F3F8FF"
    $bodyColor = New-Color "#B5C7D9"

    Draw-RoundedBox -Graphics $g -X 680 -Y 150 -Width 380 -Height 88 -Title "1. Start" -Body "Healthcare assistant is ready to accept a user query." -FillColor $fill -BorderColor $border -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 680 -Y 290 -Width 380 -Height 88 -Title "2. User Submits Query" -Body "The query comes from the CLI or the website chatbot." -FillColor $fill -BorderColor $border -TitleColor $titleColor -BodyColor $bodyColor
    Draw-Diamond -Graphics $g -CenterX 870 -CenterY 475 -Width 260 -Height 150 -Text "Input Channel?" -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2")
    Draw-RoundedBox -Graphics $g -X 260 -Y 580 -Width 320 -Height 98 -Title "3A. CLI Path" -Body "The terminal app forwards the message to the chatbot engine." -FillColor $fill -BorderColor $border -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 1160 -Y 580 -Width 320 -Height 98 -Title "3B. Web Path" -Body "The website sends the message through the Python server." -FillColor $fill -BorderColor $border -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 680 -Y 730 -Width 380 -Height 96 -Title "4. Match Request" -Body "The chatbot engine checks the command catalogue and prepares a response." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor $titleColor -BodyColor $bodyColor
    Draw-RoundedBox -Graphics $g -X 680 -Y 875 -Width 380 -Height 92 -Title "5. Send Response" -Body "The chosen healthcare response is returned and shown to the user." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor $titleColor -BodyColor $bodyColor

    Draw-Arrow -Graphics $g -X1 870 -Y1 238 -X2 870 -Y2 290 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 870 -Y1 378 -X2 870 -Y2 400 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 790 -Y1 535 -X2 580 -Y2 620 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 950 -Y1 535 -X2 1160 -Y2 620 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 580 -Y1 678 -X2 680 -Y2 778 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 1160 -Y1 678 -X2 1060 -Y2 778 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 870 -Y1 826 -X2 870 -Y2 875 -Color (New-Color "#F3C06D")

    Draw-Label -Graphics $g -Text "CLI" -X 610 -Y 545 -Width 60 -Height 24
    Draw-Label -Graphics $g -Text "Website" -X 1060 -Y 545 -Width 90 -Height 24

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-HLProcessProcessFlow {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]
    Draw-Title -Graphics $g -Title "High Level Process Process Flow Diagram" -Subtitle "End-to-end request and information movement across system layers"

    Draw-RoundedBox -Graphics $g -X 130 -Y 300 -Width 220 -Height 120 -Title "User" -Body "Initiates a healthcare query." -FillColor (New-Color "#16273C" 245) -BorderColor (New-Color "#5E87B5") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 460 -Y 300 -Width 260 -Height 120 -Title "Interface Layer" -Body "CLI or website captures the user request." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 840 -Y 300 -Width 260 -Height 120 -Title "Processing Layer" -Body "Server and chatbot engine interpret the request." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1220 -Y 300 -Width 320 -Height 120 -Title "Information Source" -Body "Command catalogue provides healthcare response text." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")

    Draw-Arrow -Graphics $g -X1 350 -Y1 360 -X2 460 -Y2 360 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 720 -Y1 360 -X2 840 -Y2 360 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1100 -Y1 360 -X2 1220 -Y2 360 -Color (New-Color "#F3C06D")

    Draw-RoundedBox -Graphics $g -X 1220 -Y 530 -Width 320 -Height 120 -Title "Prepared Reply" -Body "A suitable response is selected and sent back through the layers." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 840 -Y 530 -Width 260 -Height 120 -Title "Processed Result" -Body "Matching logic returns a healthcare answer." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 460 -Y 530 -Width 260 -Height 120 -Title "Displayed Response" -Body "The interface shows the final answer." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 130 -Y 530 -Width 220 -Height 120 -Title "User Receives Reply" -Body "The interaction completes or continues." -FillColor (New-Color "#16273C" 245) -BorderColor (New-Color "#5E87B5") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")

    Draw-Arrow -Graphics $g -X1 1220 -Y1 470 -X2 1100 -Y2 590 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 840 -Y1 590 -X2 720 -Y2 590 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 460 -Y1 590 -X2 350 -Y2 590 -Color (New-Color "#8EC9FF")

    Draw-Label -Graphics $g -Text "Request Flow" -X 735 -Y 315 -Width 110 -Height 24
    Draw-Label -Graphics $g -Text "Response Flow" -X 730 -Y 550 -Width 120 -Height 24 -ColorHex "#F3C06D"

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-LLModuleDiagram {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]
    Draw-Title -Graphics $g -Title "Low Level Module Diagram" -Subtitle "Detailed file-level modules used in the healthcare chatbot implementation"

    Draw-RoundedBox -Graphics $g -X 220 -Y 220 -Width 250 -Height 130 -Title "cli_chatbot.py" -Body "Terminal loop, sample prompts, exit handling, response printing." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 650 -Y 220 -Width 310 -Height 150 -Title "healthcare_bot.py" -Body "Constants, command list, normalization, scoring, quick command generation, and chatbot_reply()." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 220 -Y 510 -Width 250 -Height 150 -Title "app.py" -Body "ThreadingHTTPServer, request handler, static file serving, API routes." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 650 -Y 510 -Width 310 -Height 150 -Title "static/script.js" -Body "Chat open-close logic, fetch requests, command rendering, message appending." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1120 -Y 380 -Width 260 -Height 130 -Title "static/index.html" -Body "Website sections, chat panel, command grid, input form." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1120 -Y 570 -Width 260 -Height 130 -Title "static/style.css" -Body "Dark theme, layout, right-side floating chatbot, responsive rules." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")

    Draw-Arrow -Graphics $g -X1 470 -Y1 285 -X2 650 -Y2 285 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 470 -Y1 585 -X2 650 -Y2 585 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 805 -Y1 370 -X2 805 -Y2 510 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 960 -Y1 585 -X2 1120 -Y2 445 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 960 -Y1 620 -X2 1120 -Y2 635 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 470 -Y1 585 -X2 470 -Y2 350 -Color (New-Color "#8EC9FF")

    Draw-Label -Graphics $g -Text "Function call" -X 510 -Y 250 -Width 120 -Height 24
    Draw-Label -Graphics $g -Text "API use" -X 520 -Y 550 -Width 90 -Height 24
    Draw-Label -Graphics $g -Text "Frontend resources" -X 975 -Y 505 -Width 145 -Height 24 -ColorHex "#F3C06D"

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-LLSequenceWebChat {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]
    Draw-Title -Graphics $g -Title "Low Level Sequence Diagram for Web Chat" -Subtitle "Browser chat message path through script.js, app.py, and healthcare_bot.py"

    $participants = @(
        @{ Name = "User"; X = 170 },
        @{ Name = "script.js"; X = 510 },
        @{ Name = "app.py"; X = 900 },
        @{ Name = "healthcare_bot.py"; X = 1310 }
    )

    foreach ($p in $participants) {
        Draw-RoundedBox -Graphics $g -X ($p.X - 110) -Y 160 -Width 220 -Height 70 -Title $p.Name -Body "" -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 18 -TitleFontSize 14
        Draw-Line -Graphics $g -X1 $p.X -Y1 230 -X2 $p.X -Y2 940 -Color (New-Color "#496785") -Width 2.5 -Dashed $true
    }

    Draw-Arrow -Graphics $g -X1 170 -Y1 300 -X2 510 -Y2 300 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 510 -Y1 390 -X2 900 -Y2 390 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 900 -Y1 480 -X2 1310 -Y2 480 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1310 -Y1 570 -X2 900 -Y2 570 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 900 -Y1 660 -X2 510 -Y2 660 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 510 -Y1 750 -X2 170 -Y2 750 -Color (New-Color "#F3C06D")

    Draw-RoundedBox -Graphics $g -X 220 -Y 262 -Width 250 -Height 54 -Title "Enter Query" -Body "" -FillColor (New-Color "#16273C" 245) -BorderColor (New-Color "#5E87B5") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 16 -TitleFontSize 12
    Draw-RoundedBox -Graphics $g -X 560 -Y 352 -Width 290 -Height 54 -Title "POST /api/chat" -Body "" -FillColor (New-Color "#173429" 245) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 16 -TitleFontSize 12
    Draw-RoundedBox -Graphics $g -X 950 -Y 442 -Width 310 -Height 54 -Title "Run chatbot_reply()" -Body "" -FillColor (New-Color "#173429" 245) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 16 -TitleFontSize 12
    Draw-RoundedBox -Graphics $g -X 950 -Y 532 -Width 310 -Height 54 -Title "Return Reply" -Body "" -FillColor (New-Color "#3A2811" 245) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 16 -TitleFontSize 12
    Draw-RoundedBox -Graphics $g -X 560 -Y 622 -Width 290 -Height 54 -Title "Send JSON Response" -Body "" -FillColor (New-Color "#3A2811" 245) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 16 -TitleFontSize 12
    Draw-RoundedBox -Graphics $g -X 220 -Y 712 -Width 250 -Height 54 -Title "Render Bot Message" -Body "" -FillColor (New-Color "#16273C" 245) -BorderColor (New-Color "#5E87B5") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9") -Radius 16 -TitleFontSize 12

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-LLComponentRelationship {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]
    Draw-Title -Graphics $g -Title "Low Level Component Relationship Diagram" -Subtitle "Detailed relationships among handler, engine, CLI, frontend, and command data"

    Draw-RoundedBox -Graphics $g -X 150 -Y 250 -Width 280 -Height 150 -Title "CLIChatbot" -Body "run_cli() reads terminal input and invokes the bot engine." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 760 -Y 210 -Width 320 -Height 190 -Title "ChatbotEngine" -Body "chatbot_reply(), get_quick_commands(), _normalize_text(), _score_command(), _help_response(), _build_response()" -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 150 -Y 590 -Width 300 -Height 180 -Title "HealthcareRequestHandler" -Body "_send_json(), _send_file(), do_GET(), do_POST(), log_message()" -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 760 -Y 590 -Width 320 -Height 170 -Title "FrontendChat" -Body "toggleChat(), appendMessage(), sendMessage(), renderCommandButtons(), initializeChat()" -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1320 -Y 400 -Width 280 -Height 160 -Title "Command Data" -Body "COMMANDS list and keyword-phrase response metadata." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")

    Draw-Arrow -Graphics $g -X1 430 -Y1 325 -X2 760 -Y2 305 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 450 -Y1 675 -X2 760 -Y2 675 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 1080 -Y1 305 -X2 1320 -Y2 455 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1080 -Y1 675 -X2 1320 -Y2 505 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 910 -Y1 590 -X2 910 -Y2 400 -Color (New-Color "#83E0B8")

    Draw-Label -Graphics $g -Text "uses" -X 560 -Y 280 -Width 80 -Height 22
    Draw-Label -Graphics $g -Text "calls" -X 560 -Y 648 -Width 80 -Height 22
    Draw-Label -Graphics $g -Text "reads metadata" -X 1135 -Y 365 -Width 140 -Height 22
    Draw-Label -Graphics $g -Text "renders response" -X 1130 -Y 610 -Width 150 -Height 22 -ColorHex "#F3C06D"

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

function Draw-LLDetailedState {
    param([string]$Path)
    $canvas = New-Canvas
    $bmp = $canvas[0]
    $g = $canvas[1]
    Draw-Title -Graphics $g -Title "Low Level Detailed State Diagram" -Subtitle "Client-side state transitions for the website chatbot panel"

    Draw-RoundedBox -Graphics $g -X 120 -Y 450 -Width 210 -Height 90 -Title "Panel Closed" -Body "Default state when page loads." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 450 -Y 280 -Width 240 -Height 90 -Title "Panel Open" -Body "Chat panel is visible." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 830 -Y 200 -Width 260 -Height 90 -Title "Commands Loading" -Body "GET /api/commands is requested." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1240 -Y 300 -Width 280 -Height 90 -Title "Waiting For Input" -Body "User can type or click a command button." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 1240 -Y 560 -Width 280 -Height 90 -Title "Sending Request" -Body "POST /api/chat is in progress." -FillColor (New-Color "#3A2811" 248) -BorderColor (New-Color "#F0B35D") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 830 -Y 700 -Width 260 -Height 90 -Title "Response Displayed" -Body "Bot message is appended in the panel." -FillColor (New-Color "#173429" 248) -BorderColor (New-Color "#62D2A2") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")
    Draw-RoundedBox -Graphics $g -X 450 -Y 760 -Width 240 -Height 90 -Title "Close Requested" -Body "Close button or Escape key is used." -FillColor (New-Color "#12324A" 248) -BorderColor (New-Color "#61A7FF") -TitleColor (New-Color "#F3F8FF") -BodyColor (New-Color "#B5C7D9")

    Draw-Arrow -Graphics $g -X1 330 -Y1 495 -X2 450 -Y2 325 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 690 -Y1 325 -X2 830 -Y2 245 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1090 -Y1 245 -X2 1240 -Y2 345 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 1380 -Y1 390 -X2 1380 -Y2 560 -Color (New-Color "#F3C06D")
    Draw-Arrow -Graphics $g -X1 1240 -Y1 650 -X2 1090 -Y2 745 -Color (New-Color "#83E0B8")
    Draw-Arrow -Graphics $g -X1 830 -Y1 790 -X2 690 -Y2 805 -Color (New-Color "#8EC9FF")
    Draw-Arrow -Graphics $g -X1 450 -Y1 805 -X2 330 -Y2 540 -Color (New-Color "#8EC9FF")

    Draw-Label -Graphics $g -Text "open panel" -X 340 -Y 390 -Width 100 -Height 22
    Draw-Label -Graphics $g -Text "initialize" -X 720 -Y 265 -Width 100 -Height 22
    Draw-Label -Graphics $g -Text "commands ready" -X 1080 -Y 270 -Width 150 -Height 22
    Draw-Label -Graphics $g -Text "submit" -X 1400 -Y 470 -Width 80 -Height 22 -ColorHex "#F3C06D"
    Draw-Label -Graphics $g -Text "show reply" -X 1130 -Y 680 -Width 100 -Height 22
    Draw-Label -Graphics $g -Text "close panel" -X 710 -Y 785 -Width 100 -Height 22

    Save-Canvas -Bitmap $bmp -Graphics $g -Path $Path
}

$outputFolder = Join-Path $PSScriptRoot "requested_diagram_pngs"

Draw-HLArchitecture -Path (Join-Path $outputFolder "high_level_architecture_diagram.png")
Draw-HLProcessFlow -Path (Join-Path $outputFolder "high_level_process_flow_diagram.png")
Draw-HLProcessProcessFlow -Path (Join-Path $outputFolder "high_level_process_process_flow_diagram.png")
Draw-LLModuleDiagram -Path (Join-Path $outputFolder "low_level_module_diagram.png")
Draw-LLSequenceWebChat -Path (Join-Path $outputFolder "low_level_sequence_diagram_for_web_chat.png")
Draw-LLComponentRelationship -Path (Join-Path $outputFolder "low_level_component_relationship_diagram.png")
Draw-LLDetailedState -Path (Join-Path $outputFolder "low_level_detailed_state_diagram.png")

Write-Output "Generated requested PNG diagrams in $outputFolder"
