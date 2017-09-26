# https://github.com/blinks zsh theme

# 位于git工作区显示±
function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo "%{%F{blue}%}±%{%f%k%b%}"
  else
    echo ' '
  fi
}

# 显示本机IP地址
function _ip_addr() {
    echo $(ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
}

# This theme works with both the "dark" and "light" variants of the
# Solarized color schema.  Set the SOLARIZED_THEME variable to one of
# these two values to choose.  If you don't specify, we'll assume you're
# using the "dark" variant.

# 设置背景色
case ${SOLARIZED_THEME:-dark} in
    light) bkg=white;;
    *)     bkg=black;;
esac

# git_prompt_info在~/.oh-my-zsh/lib/git.zsh
# 这是git提示符前缀
ZSH_THEME_GIT_PROMPT_PREFIX=" [%{%B%F{blue}%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%k%b%K{${bkg}}%B%F{green}%}]"
# 这是git提示符后缀
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%k%b%B%F{green}%}]"
# 这是修改标志
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}*%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# 第一行为空行
# 第二行格式为"用户名(%n)@主机名(%m) IP地址$(_ip_addr) 当前文件夹(%~) [当前分支 修改标志]"
# 第三行格式为"工作区标志 # 输入命令"
#PROMPT='%{%f%k%b%}
#%{%K{${bkg}}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} $(_ip_addr) %{%b%F{yellow}%K{${bkg}}%}%~%{%B%F{green}%}$(git_prompt_info)%E%{%f%k%b%}
#%{%K{${bkg}}%}$(_prompt_char)%{%K{${bkg}}%} %#%{%f%k%b%} '
PROMPT='%{%f%k%b%}
%{%B%F{red}%}%n%{%B%F{blue}%}@%{%B%F{black}%}%m %{%B%F{blue}%}$(_ip_addr) %{%b%F{yellow}%}%~%{%B%F{green}%}$(git_prompt_info)%E%{%f%k%b%}
$(_prompt_char) %#%{%f%k%b%} '

# 显示当前session执行的命令个数
RPROMPT='!%{%B%F{cyan}%}%!%{%f%k%b%}'
