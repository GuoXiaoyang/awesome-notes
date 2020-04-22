#!/usr/bin/env sh

LIZARD_DEPLOY_TAG_NAME=release-1.0.0-112233
LIZARD_FLOW=lizard-flow
# lizard-flow
# 标记部署分支
# 参数为 COMMIT_HASH
tag_release_branch() {
  info "发布完成，标记部署分支"
  set +x
  local COMMIT_REVISION="$1"
  local TAG_NAME="$LIZARD_FLOW-$LIZARD_DEPLOY_TAG_NAME"
  cd "$PROJECT_ROOT"
  git checkout -f "$COMMIT_REVISION"
  if ! git show-ref -q "$TAG_NAME"; then
    git tag "$TAG_NAME"
    git push origin "$TAG_NAME" -q
  fi
}

tag_release_branch $(git log -1 --format="%h")