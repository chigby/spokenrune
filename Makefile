clean:
	rm -rf _site/*

serve: clean
	jekyll serve --watch

build: clean
	jekyll build

test: build push-test

deploy: build push-production

push-test:
	rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrunetest

push-production:
	@status=$$(git status --porcelain); \
        if test "x$${status}" = x; then \
            rsync -rtz --chmod=ugo=rwX --delete _site/ chigby@nullsurface.com:~/webapps/spokenrune ; \
        else \
            echo Working directory is dirty >&2; \
        fi

.PHONY: server deploy-production deploy-test
