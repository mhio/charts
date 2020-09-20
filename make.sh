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

CHARTS="gogs"
###

run_build_repo_index(){
  set -x
  helm repo update
  for chart in $CHARTS; do
    cd gogs
    helm package .
    cd ..
  done
  git checkout gh-pages
  for chart in $CHARTS; do
    ls -l $chart/*.tgz
  done
  helm repo index . --url https://mhio.github.io/charts
  local_versions=$(cat index.yaml | yq '.entries.gogs[].version' -r)
  for chart in $CHARTS; do
    git add "$chart/"
  done
  git commit . -m 'make.sh add releases and build index'
  git push
  echo "gh page pushed at $(date)"
  git checkout charts
  while sleep 15; do
    remote_versions=$(curl -s https://mhio.github.io/charts/index.yaml | yq '.entries.gogs[].version' -r)
    if [[ "$remote_versions" == "$local_versions" ]]; then
      echo "gh page updated around $(date)"
      break
    fi
  done
  set +x
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

