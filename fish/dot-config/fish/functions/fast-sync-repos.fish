function fast-sync-repos
    cat ~/.gitrepos | xargs -I@ -P (nproc) fish -c 'sync-repo @'
end
