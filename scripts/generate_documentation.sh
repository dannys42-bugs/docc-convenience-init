#!/bin/sh
set -e
OUTPUT_DIR=$(git rev-parse --show-toplevel)/docs
PROJECT=SomeLibrary
HOSTING_BASE_PATH=pages/dsung42-bugs/docc-convenience-init

old_branch=$(git branch --show-current)

if [[ $(git status --porcelain --untracked-files=no | wc -l) -gt 0 ]]; then
    echo "ERROR: Must commit changed files before generating documentation"
    exit 1
fi

### Make sure we go back to main branch on any failures.
function restore_branch {
    echo "Going back to main branch"
    git checkout "${old_branch}"
}
trap restore_branch EXIT
###


do_push=0

while [ $# -ge 1 ]; do
    case "$1" in
        push|-p)
            do_push=1
            ;;
        *)
            echo "$0 [-p|push] - to push to github"
            exit 1
    esac
    shift
done


swift package clean

git checkout documentation
git merge main -m "Merge main"

swift package \
    --allow-writing-to-directory "${OUTPUT_DIR}" \
    generate-documentation --target "${PROJECT}" \
    --transform-for-static-hosting \
    --disable-indexing \
    --hosting-base-path "${HOSTING_BASE_PATH}" \
    --output-path "${OUTPUT_DIR}"

git add "${OUTPUT_DIR}"
git commit -a -m "Update documentation"

if [ "${do_push}" == "1" ]; then
    git push origin documentation
fi

git checkout "${old_branch}"
