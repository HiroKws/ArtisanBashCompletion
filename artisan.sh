# Laravel Artisan commands completion with bash.
# Bash用のArtisanコマンド補完

# Copyright holding by Hirohisa Kawase at 2014.
# Released on MIT license.

_artisan_module()
{
    if [ ! -f artisan ]
    then
        COMPREPLY=()
        return 0;
    fi

    local cur prev artisan_options

    # Ignore ':' and '-' from $COMP_WORDBREAKS then take last entered string.
    # 単語区切りの文字から':'と'-'を除外し、最後の入力文字列を取得する
    _get_comp_words_by_ref -n ':-' cur prev

    COMPREPLY=()

    # Get commands and options
    # コマンド、サブコマンド、オプションの取得
    artisan_options=$(php artisan --no-ansi | awk '/^  [\-a-z]+/ { print $1 }; $2 ~/^-/ { gsub(/\|/, " -", $2); print $2 }')

    # For command options. If not want it, delete 'if' block.
    # コマンドのオプション。必要ない場合は、if〜fiブロック間を削除する
    if [ "${COMP_WORDS[2]}" = ":" ] && [ $COMP_CWORD -ge 4 ] ||
        [ "${COMP_WORDS[2]}" != ":" ] && [ $COMP_CWORD -ge 2 ]
    then
        if [ "${COMP_WORDS[2]}" = ":" ]
        then
            comm="${COMP_WORDS[1]}:${COMP_WORDS[3]}"
        else
            comm="${COMP_WORDS[1]}"
        fi
        artisan_options=$(php artisan "${comm}" --no-ansi --help | awk -e '/^ --/ { print $1 } $2 ~/^\(/ { gsub(/[\(\)]/, "", $2); gsub(/\|/, " -", $2); print $2}')
    fi

    COMPREPLY=($(compgen -W "${artisan_options}" -- "${cur}"))

    __ltrim_colon_completions "$cur"

    return 0
}

complete -F _artisan_module artisan
