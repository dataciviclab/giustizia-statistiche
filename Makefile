TOOLKIT = toolkit

DATASETS := $(shell find datasets -name dataset.yml 2>/dev/null | sort)

.PHONY: check run run-all clean registry help

check:
	@for f in $(DATASETS); do \
		echo "→ $$f"; \
		$(TOOLKIT) run preflight --config "$$f" > /dev/null 2>&1 || exit 1; \
	done
	@echo "✅ All configs valid"

run:
	$(TOOLKIT) run

run-all:
	@find datasets -name dataset.yml | sort > .tmp_batch.txt; \
	TOOLKIT_ALLOW_SCRIPT_SOURCE=1 $(TOOLKIT) run --batch .tmp_batch.txt; \
	rm -f .tmp_batch.txt

clean:
	rm -rf out/data/_runs out/data/probe out/data/raw out/data/clean out/data/mart out/data/cross .tmp/ .tmp_batch.txt

registry:
	$(TOOLKIT) registry build --prefix giustizia-statistiche

help:
	@grep -E '^[a-zA-Z_-]+:' Makefile | sort
