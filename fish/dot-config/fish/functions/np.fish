function np
    echo "Existing direcotories / catagories under posts:"
    ls -D content/posts
    echo ""
    read -P "Enter path and file for the article to create, relative from the posts directory: " article
    hugo new content content/posts/$article
end
