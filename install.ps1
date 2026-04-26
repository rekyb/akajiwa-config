$ErrorActionPreference = "Stop"

$ScriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ClaudeHome   = Join-Path $env:USERPROFILE ".claude"
$SkillsDir    = Join-Path $ClaudeHome "skills"
$MemoryDir    = Join-Path $ClaudeHome "memory"
$TemplatesDir = Join-Path $ClaudeHome "templates"
$SettingsFile = Join-Path $ClaudeHome "settings.json"
$ConfigPathFile = Join-Path $ClaudeHome ".akajiwa-config-path"

Write-Host "Reky Claude Code Config - Installer"
Write-Host "======================================="
Write-Host ""

# 1. Create directories
New-Item -ItemType Directory -Force -Path $SkillsDir    | Out-Null
New-Item -ItemType Directory -Force -Path $MemoryDir    | Out-Null
New-Item -ItemType Directory -Force -Path $TemplatesDir | Out-Null

# 2. Save config repo path
Set-Content -Path $ConfigPathFile -Value $ScriptDir -Encoding utf8
Write-Host "Config path saved: $ScriptDir"

# 3. Merge CLAUDE.md
$ClaudeMdPath = Join-Path $ClaudeHome "CLAUDE.md"
if (Test-Path $ClaudeMdPath) {
    $existing = Get-Content $ClaudeMdPath -Raw -Encoding utf8
    if ($existing -match "Akajiwa") {
        Write-Host "CLAUDE.md: already configured"
    } else {
        $newContent = Get-Content (Join-Path $ScriptDir "CLAUDE.md") -Raw -Encoding utf8
        Add-Content -Path $ClaudeMdPath -Value "`n$newContent" -Encoding utf8
        Write-Host "CLAUDE.md: merged"
    }
} else {
    Copy-Item (Join-Path $ScriptDir "CLAUDE.md") $ClaudeMdPath
    Write-Host "CLAUDE.md: created"
}

# 4. Copy project template
Copy-Item (Join-Path $ScriptDir "templates\project-claude.md") (Join-Path $TemplatesDir "project-claude.md") -Force
Write-Host "Template: project-claude.md installed"

# 5. Symlink skills (junction for directories on Windows)
$SkillsSource = Join-Path $ScriptDir "skills"
Get-ChildItem $SkillsSource -Directory | ForEach-Object {
    $skillName = $_.Name
    $target = Join-Path $SkillsDir $skillName
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    New-Item -ItemType Junction -Path $target -Target $_.FullName | Out-Null
    Write-Host "Skill: $skillName linked"
}

# 6. Merge settings.json
$newHooks = @{
    PreToolUse = @(@{
        matcher = "Bash"
        hooks = @(@{ type = "command"; command = "echo RTK reminder: prefix terminal commands with rtk" })
    })
}

if (Test-Path $SettingsFile) {
    $raw = Get-Content $SettingsFile -Raw -Encoding utf8
    $existing = $raw | ConvertFrom-Json

    if (-not $existing.PSObject.Properties['hooks']) {
        $existing | Add-Member -NotePropertyName hooks -NotePropertyValue ([PSCustomObject]@{})
    }

    foreach ($hookType in $newHooks.Keys) {
        if (-not $existing.hooks.PSObject.Properties[$hookType]) {
            $existing.hooks | Add-Member -NotePropertyName $hookType -NotePropertyValue $newHooks[$hookType]
        }
    }

    $existing | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding utf8
    Write-Host "settings.json: hooks merged"
} else {
    @{ hooks = $newHooks } | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding utf8
    Write-Host "settings.json: created"
}

# 7. Memory files
$memoryMd     = Join-Path $MemoryDir "memory.md"
$featuresIdx  = Join-Path $MemoryDir "features-index.md"

if (-not (Test-Path $memoryMd)) {
    Copy-Item (Join-Path $ScriptDir "memory\memory.md") $memoryMd
    Write-Host "memory/memory.md: created"
} else {
    Write-Host "memory/memory.md: already exists, skipping"
}

if (-not (Test-Path $featuresIdx)) {
    Copy-Item (Join-Path $ScriptDir "memory\features-index.md") $featuresIdx
    Write-Host "memory/features-index.md: created"
} else {
    Write-Host "memory/features-index.md: already exists, skipping"
}

# 8. Install RTK
function Install-RTK {
    if (Get-Command rtk -ErrorAction SilentlyContinue) {
        $ver = & rtk --version 2>$null
        Write-Host "RTK: already installed ($ver)"
        return
    }

    Write-Host "RTK: fetching latest version..."

    try {
        $release = Invoke-RestMethod "https://api.github.com/repos/rtk-ai/rtk/releases/latest" -UseBasicParsing
        $version = $release.tag_name
    } catch {
        Write-Host "RTK: could not reach GitHub"
        Write-Host "     Install manually: https://github.com/rtk-ai/rtk/releases"
        return
    }

    $is64 = [System.Environment]::Is64BitOperatingSystem
    $arch = if ($is64) { "x86_64" } else { "i686" }
    $binaryName = "rtk-${arch}-pc-windows-msvc.exe"
    $url = "https://github.com/rtk-ai/rtk/releases/download/$version/$binaryName"

    $rtkDir  = "C:\tools\rtk"
    $rtkPath = Join-Path $rtkDir "rtk.exe"
    New-Item -ItemType Directory -Force -Path $rtkDir | Out-Null

    Write-Host "RTK: downloading $version ($arch)..."

    try {
        Invoke-WebRequest -Uri $url -OutFile $rtkPath -UseBasicParsing
    } catch {
        Write-Host "RTK: download failed"
        Write-Host "     Install manually: https://github.com/rtk-ai/rtk/releases"
        return
    }

    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$rtkDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$rtkDir", "User")
        $env:Path = "$env:Path;$rtkDir"
        Write-Host "RTK: added $rtkDir to user PATH"
    }

    Write-Host "RTK: installed ($version)"
}

Install-RTK

Write-Host ""
Write-Host "======================================="
Write-Host "Installation complete."
Write-Host ""
Write-Host "Commands available:"
Write-Host "  Heavy (Opus recommended):"
Write-Host "    /xplan         Plan a feature before building"
Write-Host "    /xdesign       UI/UX design brief"
Write-Host "    /xreview       Code or design review"
Write-Host ""
Write-Host "  Light (Sonnet / Haiku):"
Write-Host "    /xvibe-fe      Fast iteration - frontend"
Write-Host "    /xvibe-be      Fast iteration - backend"
Write-Host "    /xvibe-design  Fast iteration - design"
Write-Host "    /xqa           Playwright test plan"
Write-Host "    /xinit         Set up project config"
Write-Host "    /xretro        Session retrospective (auto on session end)"
Write-Host "    /xreflect      Promote patterns to global config"
Write-Host "    /update-memory Push project memory"
Write-Host "    /get-memory    Pull latest shared memory"

# Check optional co-op skills
$coopSkills = @(
    @{ name = "frontend-dev-guidelines"; desc = "/xvibe-fe - React/TypeScript component guidance" }
    @{ name = "frontend-design-pro";     desc = "/xvibe-fe - distinctive visual treatment" }
    @{ name = "debugging";               desc = "/xvibe-fe /xvibe-be - systematic debugging" }
    @{ name = "databases";               desc = "/xvibe-be - MongoDB and Mongoose guidance" }
    @{ name = "backend-development";     desc = "/xvibe-be - service layer and API architecture" }
    @{ name = "ui-ux-pro-max";           desc = "/xvibe-design - full UI/UX design intelligence" }
    @{ name = "aesthetic";               desc = "/xvibe-design - opinionated visual beauty" }
    @{ name = "web-design-guidelines";   desc = "/xvibe-design - UI guideline validation" }
)

$missingCoops = $coopSkills | Where-Object { -not (Test-Path (Join-Path $SkillsDir $_.name)) }

Write-Host ""
if ($missingCoops.Count -eq 0) {
    Write-Host "All optional co-op skills found."
} else {
    Write-Host "Optional co-op skills not found (your config works without them):"
    foreach ($skill in $missingCoops) {
        Write-Host "  $($skill.name)  ->  $($skill.desc)"
    }
}
