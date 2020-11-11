
function contains_path() {
    IFS=":" read -ra arr <<< "$PATH"
    for i in "${arr[@]}"; do
        [[ $i = $1 ]] && return 0
    done

    return 1
}

function append_path() {
    contains_path $1 || {
        [[ -z $PATH ]] && PATH="$1" || PATH="$PATH:$1"
    }
}


function prepend_path() {
    contains_path $1 || {
        [[ -z $PATH ]] && PATH="$1" || PATH="$1:$PATH"
    }
}


function main() {
    # save default path and clear path variable
    local system_path="$PATH"
    PATH=

    # if local_bin is defined then add all folders to path
    [[ -d "$LOCAL_BIN" ]] && {
        for dir in $LOCAL_BIN/* $LOCAL_BIN; do
            [[ -d $dir ]] &&  prepend_path $dir
        done
    }

    append_path "$HOME/.config/git/bin"
    append_path "$HOME/.cargo/bin"


    # adding system path back
    IFS=":" read -ra arr <<< "$system_path"
    for i in "${arr[@]}"; do
        append_path "$i"
    done

    export PATH=$PATH
}

main

unset contains_path
unset prepend_path
unset append_path
unset main

