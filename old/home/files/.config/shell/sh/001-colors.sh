if tput setaf 1 &> /dev/null; then
    CL_RED="$(tput setaf 1)"
    CL_GREEN="$(tput setaf 2)"
    CL_YELLOW="$(tput setaf 3)"
    CL_BLUE="$(tput setaf 4)"
    CL_MAGENTA="$(tput setaf 5)"
    CL_CYAN="$(tput setaf 6)"
    CL_WHITE="$(tput setaf 7)"
    CL_BLACK="$(tput setaf 8)"
    CL_BOLD="$(tput bold)"
    CL_RESET="$(tput sgr0)"
else
    CL_RED="\u001b[31m"
    CL_GREEN="\u001b[32m"
    CL_YELLOW="\u001b[33m"
    CL_BLUE="\u001b[34m"
    CL_MAGENTA="\u001b[35m"
    CL_CYAN="\u001b[36m"
    CL_WHITE="\u001b[37m"
    CL_BLACK="\u001b[38m"
    CL_BOLD=""
    CL_RESET="\033[m"
fi

function esc_color()
{
    echo "\[$1\]"
}
