#!/bin/bash
# エラーが発生するとスクリプトを終了
set -e

#remove a potentially pre-existing server.pid for rails
#railsのpidが存在している場合は削除する
rm -f /myapp/tmp/pids/server.pid

#Then exec the containers main process
#DockerfileのCMDで渡されたコマンド（Railsのサーバー起動）を実行
exec "$@"
