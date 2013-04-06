serve:
	jekyll --auto --serve

deploy-test:
	jekyll
	rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrunetest

deploy-production:
	jekyll
	rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrune
