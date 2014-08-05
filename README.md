Artisan-Bash completion
=======================

Bash completion code for Laravel Artisan command line tool to complete code.

#### Install（インストール）

First of all, define alias for artisan command in your .bashrc, like this :

~~~
alian='php artisan --ansi'
~~~

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

簡単な方法は、.bashrcや.bash_profileに、artisan.shのコードをコピペすることです。もしくは、/usr/share/bash-completion/とか、/etc/bash_completion.d/へファイルをコピーしてください。私は試していませんが、多分動作するでしょう。:P

**注意：** もし、artisan以外の別名を使用するときは、一番最後のコードを変更してください。

~~~
complete -F _artisan_module <お好きな別名をここに指定します>
~~~


#### Limitaion（制限）

This completion works in a directory with artisan php file. It means in your Laravel project root directory only. So it don't work like this : 'php /home/MyUsername/MyProject/artisan'

この補完は、artisan phpファイルの存在するディレクトリーが、カレントディレクトリーの場合のみ動作します。つまり、Laravelプロジェクトのルートディレクトリーの中だけで動作します。`php /home/MyUsername/MyProject/artisan`のように、カレントディレクトリー以外のartisanコマンドラインを動作させようとする場合は、働きません。

Fave Hun...oh Have fun!!
