$ErrorActionPreference = 'Stop'

& codex plugin marketplace add Kuu44/kuu-orchestration
if ($LASTEXITCODE -ne 0) { throw "Marketplace installation failed with exit code $LASTEXITCODE." }

& codex plugin add kuu-orchestration@kuu-orchestration
if ($LASTEXITCODE -ne 0) { throw "Plugin installation failed with exit code $LASTEXITCODE." }
