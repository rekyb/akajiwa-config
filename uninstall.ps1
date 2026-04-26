$ClaudeHome  = Join-Path $env:USERPROFILE ".claude"
$SkillsDir   = Join-Path $ClaudeHome "skills"
$ConfigPathFile = Join-Path $ClaudeHome ".akajiwa-config-path"

Write-Host "Reky Claude Code Config - Uninstaller"
Write-Host "========================================="
Write-Host ""

$skills = @("xplan","xdesign","xreview","xvibe-fe","xvibe-be","xvibe-design","xqa","xinit","xretro","xreflect","update-memory","get-memory")

foreach ($skill in $skills) {
    $target = Join-Path $SkillsDir $skill
    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
        Write-Host "Removed: $skill"
    }
}

if (Test-Path $ConfigPathFile) {
    Remove-Item $ConfigPathFile -Force
    Write-Host "Removed: config path file"
}

Write-Host ""
Write-Host "Done."
Write-Host "CLAUDE.md, settings.json hooks, and memory files were not removed."
Write-Host "Remove them manually if needed:"
Write-Host "  $ClaudeHome\CLAUDE.md"
Write-Host "  $ClaudeHome\memory\"
Write-Host "  $ClaudeHome\settings.json (remove Stop and PreToolUse hooks)"
