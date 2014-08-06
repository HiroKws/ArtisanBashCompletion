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

    local cur prev artisan_options token

    # Ignore ':' and '-' from $COMP_WORDBREAKS then take last entered string.
    # 単語区切りの文字から':'と'-'を除外し、最後の入力文字列を取得する
    _get_comp_words_by_ref -n ':-' cur prev

    COMPREPLY=()

    # Completion for "--option=" type option.
    # "--option="タイプのオプション対応
    if [ "${cur}" = "=" ] || [ "${prev}" = "=" ]
    then
        if [ "${cur}" = "=" ]
        then
            token="${prev}"
            cur=""
        else
            token="${COMP_WORDS[$COMP_CWORD-2]}"
        fi

        case "${token}" in
            # Please change completions for "--env=" option freely.
            # "-env="に対する候補、お好きなものに変更してください
            "--env" )
            COMPREPLY=($(compgen -W "local production testing" -- "${cur}"))
            return 0
            ;;
            # Complete files list for "--path=".
            # "--path"には、ファイルリストを候補にする
            "--path" )
            _filedir
            return 0
            ;;
            # Complete directories
            # ディレクトリ名の補完
            "--dir" | "--resources" )
            _filedir -d
            return 0
            ;;
            # Complete database connection
            # データベース接続名の補完
            "--database" )
            local databases=$(find . -name "database.php" | xargs -i php -r "\$db=include '{}'; if (key_exists('connections', \$db)) {foreach(\$db['connections'] as \$key=>\$data) echo \$key.' ';}" | tr ' ' "\n" | sort | uniq)
            COMPREPLY=($(compgen -W "${databases}" -- "${cur}"))
            return 0;
            ;;
        esac
    fi

    # For command options.
    # コマンドのオプション。
    if ( [ $COMP_CWORD -ge 4 ] && [ "${COMP_WORDS[2]}" = ":" ] ) ||
       ( [ $COMP_CWORD -ge 2 ] && [ "${COMP_WORDS[2]}" != ":" ] )
    then
        if [ "${COMP_WORDS[2]}" = ":" ]
        then
            comm="${COMP_WORDS[1]}:${COMP_WORDS[3]}"
        else
            comm="${COMP_WORDS[1]}"
        fi
        artisan_options=$(php artisan "${comm}" --no-ansi --help | awk -e '/^ --/ { print $1 } $2 ~/^\(/ { gsub(/[\(\)]/, "", $2); gsub(/\|/, " -", $2); print $2}')
    else
        # Complete Artisan command names.
        # Artisanコマンド名の補完
        artisan_options=$(php artisan --no-ansi | awk '/^  [\-a-z]+/ { print $1 }; $2 ~/^-/ { gsub(/\|/, " -", $2); print $2 }')
    fi

    COMPREPLY=($(compgen -W "${artisan_options}" -- "${cur}"))

    __ltrim_colon_completions "$cur"

    return 0
}

complete -F _artisan_module artisan
