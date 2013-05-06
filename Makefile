serve:
	jekyll serve --watch

deploy-test:
	jekyll build
	rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrunetest

deploy-production:
	jekyll build
	rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrune
