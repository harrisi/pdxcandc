HOOKS=(
  pre-push
)

for hook in "${HOOKS[@]}"; do
  cp ./scripts/git/$hook .git/hooks/$hook
  chmod +x .git/hooks/$hook
done

echo "installed git hooks"