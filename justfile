default:
  just --list

alias d := dev
alias v := version

# Version control
# Automatically detect version information from git
# Falls back to timestamp if not in a git repository
version := if `git rev-parse --git-dir 2>/dev/null; echo $?` == "0" {
    `git describe --tags --always --dirty 2>/dev/null || echo "dev"`
} else {
    `date -u '+%Y%m%d-%H%M%S'`
}
git_commit := `git rev-parse --short HEAD 2>/dev/null || echo "unknown"`
git_branch := `git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"`
build_time := `date -u '+%Y-%m-%d_%H:%M:%S'`
build_by := `whoami`

[group('dev')]
dev :
    pnpm dev

[group('bump')]
bump package="":
    nix flake update {{package}}

[doc('Version Information')]
version:
    @echo "Version:    {{version}}"
    @echo "Commit:     {{git_commit}}"
    @echo "Branch:     {{git_branch}}"
    @echo "Built:      {{build_time}}"
    @echo "Built by:   {{build_by}}"

