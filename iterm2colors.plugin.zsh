# iterm2colors
#
# Apply color schemes within iterm2
#
# Future ideas:
# - Categorize into light, dark, colorful, ....
# - Include files straight from http://iterm2colorschemes.com/ (submodule?)
#   - aka https://github.com/mbadolato/iTerm2-Color-Schemes

_iterm2colors_defs_path=$(dirname $0)/colorschemes

_iterm2colors_default="Jackie Brown"

# uncomment to set the terminal color by default
# _iterm2colors_apply(${_iterm2colors_default})
_iterm2colors_current=${_iterm2colors_default}

function _iterm2colors_apply_random() {
  local presets
  local random_color_preset
  presets=(${_iterm2colors_defs_path}/*)
  : $RANDOM # zsh isn't evaluating this on its own for some reason
  random_color_preset=$(basename "${presets[RANDOM % ${#presets[@]}]}")
  if _iterm2colors_apply $random_color_preset; then
    _iterm2colors_default="$random_color_preset"
    echo "$random_color_preset"
  fi
}

function _iterm2colors_apply () {
  # TODO: Move this check to the top; error out or do nothing if it's not iterm
  if [[ "$TERM_PROGRAM" = "iTerm.app" ]] && \
     [[ $_iterm2colors_current != "$*" ]]; then
    __iterm2colors_apply "$1"
  fi
}

function _iterm2colors_reapply() {
  __iterm2colors_apply $_iterm2colors_current
}

function __iterm2colors_apply () {
  if [[ "$TERM_PROGRAM" = "iTerm.app" ]]; then
    if [[ -f "$_iterm2colors_defs_path/$*" ]]; then
      # echo "Applying theme $*";
      source "$_iterm2colors_defs_path/$*"
      _iterm2colors_current="$*"
    else
      echo "Unknown color theme: $*"
      return 1
    fi
  fi
}

compdef '_files -W "$_iterm2colors_defs_path"' _iterm2colors_apply

alias ac=_iterm2colors_apply
alias acl='echo $_iterm2colors_current'
alias acr=_iterm2colors_apply_random
