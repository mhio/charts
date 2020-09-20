#!/bin/sh

set -ue

rundir=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")
canonical="$rundir/$(basename -- "$0")"

if [ -n "${1:-}" ]; then
  cmd=$1
  shift
else
  cmd=build
fi

cd "$rundir"

###

run_build_repo_index(){
  helm package gogs/ -u
  git checkout gh-pages
  helm repo index . --url https://mhio.github.io/helm3
  git commit index.yaml -m 'build index'
  git checkout charts
}


###

run_help(){
  echo "Commands:"
  awk '/  ".*"/{ print "  "substr($1,2,length($1)-3) }' make.sh
}
set +x
case $cmd in
  "build")                  run_build_repo_index "$@";;

  '-h'|'--help'|'h'|'help') run_help;;
  *)                        $cmd "$@";;
esac

