$ErrorActionPreference = 'Stop'
$specUrl = 'https://github.com/jvictornascimento/pabelis-quickclock-flutter/tree/main/specs/001-quickclock'
$milestone = 'QuickClock PWA Local - Spec 001'
$repositories = @{
  'pabelis-quickclock-front' = @{1='T05,T25';2='T05';3='T09';4='T10';5='T09,T12';6='T11,T16,T17';7='T13';8='T15';9='T19,T20,T21,T22';10='T23,T24';11='T06,T07,T08,T32'}
  'pabelis-quickclock-backend' = @{6='T14';7='T12,T16';8='T18,T19,T20,T21,T23,T24';9='T06,T07,T08,T27,T32'}
}
foreach ($name in $repositories.Keys) {
  $repo = "jvictornascimento/$name"
  $milestones = gh api "repos/$repo/milestones?state=all&per_page=100" | ConvertFrom-Json
  if ($LASTEXITCODE -ne 0) { throw "Cannot read milestones: $repo" }
  if (-not ($milestones | Where-Object title -eq $milestone)) {
    gh api "repos/$repo/milestones" -f "title=$milestone" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Cannot create milestone: $repo" }
  }
  foreach ($number in $repositories[$name].Keys | Sort-Object) {
    $issue = gh issue view $number --repo $repo --json title,body | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) { throw "Cannot read issue: $repo#$number" }
    $tasks = $repositories[$name][$number]
    $title = $issue.title
    $body = $issue.body -replace '(?s)\n## Spec 001 alignment.*$', ''
    if (($name -eq 'pabelis-quickclock-front' -and $number -in 1,11) -or ($name -eq 'pabelis-quickclock-backend' -and $number -eq 9)) {
      $title = if ($name -eq 'pabelis-quickclock-front' -and $number -eq 1) {'story: create typed React foundation and app metadata'} else {'story: prepare local Docker and ZeroTier access'}
      $body = @"
## Context
QuickClock runs on the owner's PC. React, Spring Boot and PostgreSQL use local containers. The phone connects through the private ZeroTier IP using Safari.

## Scope
- Follow tasks $tasks from Spec 001.
- Keep the frontend and API on the same HTTP origin.
- No login, friendly DNS, service worker or cloud deployment in this delivery.
- Do not expose database ports publicly or store personal data in Git.

## Acceptance Criteria
- For foundation work: strict TypeScript, repeatable build, real API states and app icons/manifest.
- For infrastructure work: local Compose, persistent database, private ingress and restart checks.
- Document commands and verify the checks relevant to the mapped tasks.
- Safari home screen behavior requires a real phone check; do not claim it based on desktop tests.
"@
    }
    $body += @"

## Spec 001 alignment
Source of truth: $specUrl
Tasks: $tasks

Approved delivery: local Docker on the PC and HTTP/private IP via ZeroTier. No login, DNS or service worker. Saving requires API availability; errors must not appear as successful writes.

Approved business rules: keep historical period prices; full payments only; simple reversal returns the source to pending without reversal history. Cards have closing/due dates. Edit one installment or all unpaid installments; preserve paid installments and avoid duplicate expenses/income.

Use a feature branch per task or cohesive group, scoped Conventional Commits in simple English, tests and linked PRs. Complete all original acceptance criteria that remain compatible with this scope before closing the issue. Incomplete integrations stay open.
"@
    $bodyFile = [System.IO.Path]::GetTempFileName()
    try {
      [System.IO.File]::WriteAllText($bodyFile, $body, [System.Text.UTF8Encoding]::new($false))
      gh issue edit $number --repo $repo --title $title --body-file $bodyFile --milestone $milestone
      if ($LASTEXITCODE -ne 0) { throw "Cannot update issue: $repo#$number" }
    } finally { Remove-Item -LiteralPath $bodyFile }
  }
}
