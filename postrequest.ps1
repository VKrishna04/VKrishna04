# Load .env file
$envFile = Join-Path -Path $PSScriptRoot -ChildPath ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^([^=]+)=(.*)$") {
            $name = $Matches[1].Trim()
            $value = $Matches[2].Trim()
            $Env:$name = $value
        }
    }
} else {
    Write-Warning "The .env file was not found."
}

# Get the GitHub token from the environment variable
$githubToken = $Env:GITHUB_TOKEN

# Check if the token is available
if (-not $githubToken) {
    Write-Error "GitHub token not found in environment variables. Please set the GITHUB_TOKEN environment variable."
    exit 1
}

$headers = @{
    "Accept" = "application/vnd.github.v3+json"
    "Authorization" = "Bearer $githubToken"
    "Content-Type" = "application/json"
}

$body = @{
    event_type = "create-project"
    client_payload = @{
        project_name = "test-project"
    }
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.github.com/repos/$Env:GITHUB_USERNAME/$Env:GITHUB_REPO/dispatches" -Method Post -Headers $headers -Body $body
