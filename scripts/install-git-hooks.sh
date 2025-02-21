HOOKS=(
  pre-push
)

for hook in "${HOOKS[@]}"; do
  mv ./scripts/git/$hook .git/hooks/$hook
  chmod +x .git/hooks/$hook
done

echo "installed git hooks"