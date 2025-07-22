# Ensure ~/dotfiles/bin is included in PATH
if [ -d "$HOME/dotfiles/bin" ]; then
  export PATH="$HOME/dotfiles/bin:$PATH"
fi