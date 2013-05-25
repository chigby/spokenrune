serve:
	jekyll serve --watch

deploy-test:
	jekyll build
	rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrunetest

deploy-production:
	@status=$$(git status --porcelain); \
        if test "x$${status}" = x; then \
	    jekyll build; \
            rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrune ; \
        else \
            echo Working directory is dirty >&2; \
        fi

.PHONY: server deploy-production deploy-test
