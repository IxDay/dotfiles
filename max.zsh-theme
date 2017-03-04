d_blue () {
    echo "%{\e[0;34m%}"
}

d_venv () {
    local env=$(virtualenv_prompt_info)
    if [ ! -z "$env" ]; then
        echo "| %{\e[0;31m%}${env:1:-1} $(d_blue)" 
    fi
}

d_git () {
    ZSH_THEME_GIT_PROMPT_PREFIX=""
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    local git=$(git_prompt_info)
    if [ ! -z "$git" ]; then
        echo "%{\e[0;36m%} $git $(d_blue)|"
    fi
}

d_name () {
    #echo "%{\e[0;36m%}%n%{\e[1;34m%}@%m$(d_blue)"
    echo "%{\e[0;36m%}%n$(d_blue)"
}

d_path () {
    echo "%{\e[0;33m%}%d$(d_blue)"
}

d_date () {
    echo "%{\e[0;32m%}%D{"%I:%M"}$(d_blue)"
}

PROMPT=\
$'$(d_blue)┌──( $(d_name) )──( $(d_path) )\n'\
$'$(d_blue)└──($(d_git) $(d_date) $(d_venv))──> %{\e[0;97m%}'

if ps $PPID | grep mc; then
    PROMPT="-> "
fi
