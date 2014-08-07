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

    # With './', '../', '~/', '//' started, complete as file name.
    # './', '../', '~/', '//'を打ち込まれたら、ファイルとして補完
    # 実際には２文字目以降の/を指定されるまで、$curに値が入らないし、
    # $COMP_CWORDも進まない。
    case "${cur:1:1}" in
        "." | "/" | "~" )
            _filedir
            return 0
            ;;
    esac

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
            --env )
                COMPREPLY=($(compgen -W "local production testing" -- "${cur}"))
                return 0
                ;;
            # Complete files list for "--*path" option names.
            # "path"で終了するロングオプションには、ファイルリストで補完
            --*path )
                _filedir
                return 0
                ;;
            # Complete directories for "--*dir" option names.
            # "dir"で終了するロングオプションは、ディレクトリ名の補完
            --*dir )
                _filedir -d
                return 0
                ;;
            # Complete database connection
            # データベース接続名の補完
            --database )
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
        artisan_options=$(php artisan "${comm}" --no-ansi --help | awk -e '/^Usage:$/ { usage=1; next; } usage==1 { usage=0; o=0; for (i=1;NF>=i;i++) { if ($i ~ /[\[\|]--\w+\[?=/) { wd=gensub(/^\[(.+\|)?--(\w+)\[?=.*$/, "\\2", 1, $i); witheq[++o]="--" wd; print "--" wd "="  } } } /^ --/ { if ($1=="--env") { print "--env=" } else { mch=0; for (i=1;o>=i;i++) { if (witheq[i]==$1) { mch=1 } } if (mch==0) { print $1 } } } $2 ~/^\(/ { gsub(/[\(\)]/, "", $2); gsub(/\|/, " -", $2); print $2}')
        # Without tailing space when completed.
        # 保管後に挿入される空白を入れないようにする
        compopt -o nospace
    else
        # Complete Artisan command names.
        # Artisanコマンド名の補完
        artisan_options=$(php artisan --no-ansi | awk '/^  [\-a-z]+/ { if ($1=="--env") print "--env="; else print $1 }; $2 ~/^-/ { gsub(/\|/, " -", $2); print $2 }')
    fi

    COMPREPLY=($(compgen -W "${artisan_options}" -- "${cur}"))

    __ltrim_colon_completions "$cur"

    return 0
}

complete -F _artisan_module artisan
