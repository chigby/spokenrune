sitedir       = output

produser   = chigby
prodhost   = nullsurface.com
proddir    = ~/webapps/spokenrune

testuser   = $(produser)
testhost   = $(prodhost)
testdir    = ~/webapps/spokenrunetest

switches = -rtz --chmod=ugo=rwX --delete

clean:
	rm -rf $(sitedir)/*

serve: clean
	jekyll serve --watch

build: clean
	nanoc

test: build push-test

deploy: pristine build push-production

push-test:
	rsync $(switches) $(sitedir)/ $(testuser)@$(testhost):$(testdir)

push-production:
	rsync $(switches) $(sitedir)/ $(produser)@$(prodhost):$(proddir)

pristine:
	@status=$$(git status --porcelain); \
        if test "x$${status}" = x; then \
            echo Repository status pristine, continuing. >&2; \
        else \
            echo Working directory is dirty >&2; \
	    exit 1; \
        fi

.PHONY: clean
