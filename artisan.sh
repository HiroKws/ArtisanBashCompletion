# Laravel Artisan commands completion with bash.
# Bash用のArtisanコマンド補完

# Copyright holding by Hirohisa Kawase at 2015
# Released on MIT license.

_get_artisan_dir()
{
    wd=$(pwd)

    until [ -f "${wd}/artisan" ]
    do
        wd=${wd%/*}
        if [ -z $wd ]
        then
            break
        fi
    done

    echo $wd
}

_artisan_module()
{
    artisan=$(_get_artisan_dir)
    artisan="${artisan}/artisan"
    
    if [ ! -f $artisan ]
    then
        COMPREPLY=()
        return 0;
    fi

    local cur prev artisan_options token env

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
            # You can set your environment tokens on $LARAVEL_ENVIRONMENT_WORDS.
            # "--env="に対する候補、$LARAVEL_ENVIRONMENT_WORDS変数に自分の環境名を設定できます。
            --env )
                if [ -n "${LARAVEL_ENVIRONMENT_WORDS}" ]
                then
                    env="${LARAVEL_ENVIRONMENT_WORDS}"
                else
                    env="local production testing"
                fi
                COMPREPLY=($(compgen -W "${env}" -- "${cur}"))
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
        artisan_options=$(php $artisan "${comm}" --no-ansi --help | awk -e '/^Usage:$/ { usage=1; next; } usage==1 { usage=0; o=0; for (i=1;NF>=i;i++) { if ($i ~ /[\[\|]--\w+\[?=/) { wd=gensub(/^\[(.+\|)?--(\w+)\[?=.*$/, "\\2", 1, $i); witheq[++o]="--" wd; print "--" wd "="  } } } /^ --/ { if ($1=="--env") { print "--env=" } else { mch=0; for (i=1;o>=i;i++) { if (witheq[i]==$1) { mch=1 } } if (mch==0) { print $1 } } } $2 ~/^\(/ { gsub(/[\(\)]/, "", $2); gsub(/\|/, " -", $2); print $2}')
        # For forbidden display options. You can set them into LARAVEL_NO_DISPLAY_OPTIONS environment variable.
        # ex) LARAVEL_NO_DISPLAY_OPTIONS="-v -vv -vvv --ansi"
        # LARAVEL_NO_DISPLAY_OPTIONSで指定されたオプションを表示しない。
        # 例： LARAVEL_NO_DISPLAY_OPTIONS="-v -vv -vvv --ansi"
        if [ -n "${LARAVEL_NO_DISPLAY_OPTIONS}" ]
        then
            artisan_options=$(echo "${artisan_options}" | tr ' ' "\n" | awk -v no_disp="${LARAVEL_NO_DISPLAY_OPTIONS}" -e 'BEGIN { n=split( no_disp, temp); for(i=1; i<=n; i++){forbidden[temp[i]]=1;}} ! forbidden[$0]++ {print $0}')
        fi
        # Without tailing space when completed.
        # 補完後に挿入される空白を入れないようにする
        compopt -o nospace
    else
        # Complete Artisan command names.
        # Artisanコマンド名の補完
        artisan_options=$(php $artisan --no-ansi | awk '/^[[:blank:]]+[\-a-z]+/ { if ($1=="--env") print "--env="; else print $1 }; $2 ~/^-/ { gsub(/\|/, " -", $2); print $2 }')
    fi

    COMPREPLY=($(compgen -W "${artisan_options}" -- "${cur}"))

    __ltrim_colon_completions "$cur"

    return 0
}

complete -F _artisan_module artisan
