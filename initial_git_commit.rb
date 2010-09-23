# Set up git repository
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
*~
*.LCK
*_flymake.*
\#*
.\#*
.bundle
.DS_Store
.svn
config/*.sphinx.conf
coverage
db/*.bkp
db/deep_test*
db/*.sqlite3
db/*sphinx
log/test
log/*.log
log/*.pid
log/culerity_page_errors
public/system
public/p/*
public/culerity_page_errors
public/javascripts/all.js
public/stylesheets/all.css
public/images/upload
public/data
vendor/bundle
test/log
tmp
END

git :init
git :add => '.'
git :commit => "-m 'initial commit'"
