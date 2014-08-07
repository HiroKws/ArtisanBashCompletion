Artisan-Bash completion
=======================

Bash completion code for Laravel Artisan command line tool to complete code.

Bash用のLaravel Artisanコマンドラインツールの補完スクリプトです。

#### Install（インストール）

First of all, define alias for artisan command in your .bashrc, like this :

~~~
alian='php artisan --ansi'
~~~

Next, if you didn't install "bash-completion" package, so please install it.

Then simply, just copy code from artisan.sh into your .bashrc or .bash_profile or something else it will be include. This is the simplest way.

Or, place the directory for include completion codes, like /usr/share/bash-completion/ or /etc/bash_completion.d/. (I never try this way. But maybe it works also. :P)

**Notion:** If you use alter alias name for 'php artisan', so just change last line it combine alias and bash function.

~~~
complete -F _artisan_module Your-Alias-Name-Here
~~~

先ず、最初に別名を定義してください。通常、.bashrcか.bash_profileの中で定義します。

~~~
alian='php artisan --ansi'
~~~

もし、多くのlinuxコマンドの補完を行う、"bash-completion"をまだインストールしていないければ、先にインストールしてください。

このパッケージをインストールする簡単な方法は、.bashrcや.bash_profileに、artisan.shのコードをコピペすることです。もしくは、/usr/share/bash-completion/とか、/etc/bash_completion.d/へファイルをコピーしてください。私は試していませんが、多分動作するでしょう。:P

**注意：** もし、artisan以外の別名を使用するときは、一番最後のコードを変更してください。

~~~
complete -F _artisan_module <お好きな別名をここに指定します>
~~~

#### Usage（使用法）

If only type 'artisan', then hit \<tab\>\<tab\>, it will show all Artisan commands and options.

'artisan'と入力し、タブを２回叩くと、Artisanコマンドと使用できるオプションを全部表示します。

~~~
$ artisan \<tab\>\<tab\>

--ansi                     asset:publish              key:generate               queue:restart
--env=                     auth:clear-reminders       list                       queue:retry
--help                     auth:reminders-controller  migrate                    queue:subscribe
--no-ansi                  auth:reminders-table       migrate:install            queue:work
--no-interaction           cache:clear                migrate:make               routes
--quiet                    changes                    migrate:publish            serve
--verbose                  clear-compiled             migrate:refresh            session:table
--version                  command:make               migrate:reset              tail
-V                         config:publish             migrate:rollback           tinker
-h                         controller:make            optimize                   up
-n                         db:seed                    queue:failed               view:publish
-q                         down                       queue:failed-table         workbench
-v                         dump-autoload              queue:flush
-vv                        env                        queue:forget
-vvv                       help                       queue:listen
~~~

Type a part of commmands or option, then hit a \<tab\> key and/or more, so it will be completed or list fewer command.

コマンドの一部を入力し\<tab\>キーを一回ないし２回叩くと、コマンド名が補完されるか、絞りこまれたリストが表示されます。

~~~
$ artisan -\<tab\>\<tab\>

--ansi            --no-ansi         --verbose         -h                -v
--env=            --no-interaction  --version         -n                -vv
--help            --quiet           -V                -q                -vvv

$ artisan mig\<tab\>

$ artisan migrate\<tab\>\<tab\>

migrate           migrate:make      migrate:refresh   migrate:rollback
migrate:install   migrate:publish   migrate:reset

$ artisan migrate:\<tab\>\<tab\>

install   make      publish   refresh   reset     rollback

$ artisan migrate:i\<tab\>

$ artisan migrate:install
~~~

After specified an Artisan command name, hit some \<tab\>s. So show list of options of the Artisan command.

Artisanコマンド名を指定した後に、\<tab\>を数回叩くと、そのArtisanコマンドのオプションを表示します。

~~~
$ artisan migrate:install\<tab\>\<tab\>

$ artisan migrate:install -\<tab\>\<tab\>

--ansi            --help            --quiet           -V                -q                -vvv
--database=       --no-ansi         --verbose         -h                -v
--env=            --no-interaction  --version         -n                -vv
~~~

And show lists and complete it finally.

絞り込みながら、最終的には補完します。

~~~
$ artisan migrate:install --no\<tab\>

$ artisan migrate:install --no-\<tab\>

--no-ansi         --no-interaction

$ artisan migrate:install --no-a\<tab\>

$ artisan migrate:install --no-ansi
~~~

For some long options, this will take more special completion.

いくつかのロングオプション形式には、特別な補完を行います。

For "--env=" option, it complete environment names.

"--env="オプションには、環境名を補完します。

~~~
$ artisan migrate --env=\<tab\>\<tab\>

local       production  testing
~~~

As above list showed, default values are "local production testing". If you want your environment, set "$LARAVEL_ENVIRONMENT_WORDS".

上記のリストの通り、デフォルトでは"local production testing"が補完対象です。自分の環境名を設定したい場合は、"$LARAVEL_ENVIRONMENT_WORDS"を指定してください。

~~~
# temporary（一時的）
LARAVEL_ENVIRONMENT_WORDS="development staging onservice"

# Normally, define in .bashrc/.bash_profile（通常、Bash設定ファイルの中で宣言)
export LARAVEL_ENVIRONMENT_WORDS="development staging onservice"
~~~

For a longopt tailed with "path", for instance "--path=", "--super-path=", etc., complete filename from current directory(project root).

例えば、"--path="を始め、"--super-path="のように、"path"で終わるロングオプションは、カレントディレクトリ（プロジェクトルート）からのファイル名を補完します。

~~~
$ artisan migrate --path=\<tab\>\<tab\>

.gitattributes  app/            bootstrap/      composer.lock   public/         vendor/
.gitignore      artisan         composer.json   phpunit.xml     server.php

$ artisan migrate --path=ap\<tab\>

$ artisan migrate --path=app/\<tab\>\<tab\>

commands/    controllers/ filters.php  models/      start/       tests/
config/      database/    lang/        routes.php   storage/     views/
~~~

As same as "path", the long options tailed with "dir", they will be completed as directory names.

"path"と同じように、"dir"で終わるロングオプションに対しては、ディレクトリ名で補完します。

~~~
$ artisan ide-helper:models --dir=\<tab\>\<tab\>

app/         bootstrap/   public/      vendor/
~~~

For "--database=" option, off course database connection names will be completed.

"--database="オプションでは、データベース接続名が補完されます。

~~~
$ artisan migrate --database=\<tab\>\<tab\>

mysql   pgsql   sqlite  sqlsrv
~~~

Database connection names will be collected from "database.php" files under project root recursively. So if you use this name without configuring database, may make an error. (Maybe normally, it will be ignore.)

データベース名は、プロジェクトルート下の"database.php"という名前のファイルを再帰的にチェックして収集します。そのため、この名前をデータベースの設定以外で使用していると、エラーが発生する可能性があります。（通常、Bashの補完中のエラーは無視されます。）

And anywhere, you can use "//", "./", "../", "~/" for completion of file names.

いつでも、"//", "./", "../", "~/"を使用すれば、ファイル名の補完が使用できます。

~~~
# Absolute file path from root directory.
# ルートディレクトリからの絶対パス
$ artisan dummy-command-name //\<tab\>\<tab\>

# Relative path from current directory(projecto root).
# カレントディレクトリーからの相対パス
$ artisan dummy-command-name ./\<tab\>\<tab\>

# Parent directory of project root.
# プロジェクトの親ディレクトリーからの相対パス
$ artisan dummy-command-name ../\<tab\>\<tab\>

# Relative path from your home directory.
# ホームディレクトリーからの相対パス
$ artisan dummy-command-name ~/\<tab\>\<tab\>
~~~

#### Limitaion（制限）

This completion works in a directory with artisan php file. It means in your Laravel project root directory only. So it don't work like this : 'php /home/MyUsername/MyProject/artisan'

この補完は、artisan phpファイルの存在するディレクトリーが、カレントディレクトリーの場合のみ動作します。つまり、Laravelプロジェクトのルートディレクトリーの中だけで動作します。`php /home/MyUsername/MyProject/artisan`のように、カレントディレクトリー以外のartisanコマンドラインを動作させようとする場合は、働きません。

Sorry for my poor English writing.

Fave Hun...oh Have fun!!
