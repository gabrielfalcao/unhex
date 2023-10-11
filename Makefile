INSTALL_PATH		:=$(HOME)/usr/libexec
UNHEX_NAME		:=unhex
UNHEX_VERSION		:=$(shell cargo run -- --version | awk '{ print $$NF }')
UNHEX_DEBUG_EXEC	:=target/debug/$(UNHEX_NAME)
UNHEX_RELEASE_EXEC	:=target/release/$(UNHEX_NAME)
UNHEX_EXEC		:=$(UNHEX_DEBUG_EXEC)
UNHEX_RUN		:=$(UNHEX_DEBUG_EXEC)
UNHEX_RUN		:=cargo run --bin $(UNHEX_NAME) --

all: test debug release

$(INSTALL_PATH):
	mkdir -p $@

$(UNHEX_RELEASE_EXEC): $(INSTALL_PATH)
	cargo build --release

$(UNHEX_DEBUG_EXEC): $(INSTALL_PATH)
	cargo build

release: check fix | $(UNHEX_RELEASE_EXEC)
	install $(UNHEX_RELEASE_EXEC) $(INSTALL_PATH)/$(UNHEX_NAME)-$(UNHEX_VERSION)
	install $(UNHEX_RELEASE_EXEC) $(INSTALL_PATH)

debug:  $(UNHEX_DEBUG_EXEC)
	install $(UNHEX_DEBUG_EXEC) $(INSTALL_PATH)/$(UNHEX_NAME)-$(UNHEX_VERSION)
	install $(UNHEX_DEBUG_EXEC) $(INSTALL_PATH)

clean: cls
	@rm -rf target

cleanx:
	@rm -rf $(UNHEX_DEBUG_EXEC)
	@rm -rf $(UNHEX_RELEASE_EXEC)

cls:
	-@reset || tput reset

fix:
	cargo fix

fmt:
	rustfmt --edition 2021 src/*.rs

check:
	cargo check --all-targets

build test: check
	cargo $@

tls.pem:
	openssl s_client -connect github.com:443 -showcerts | sed -n -e '/-.BEGIN/,/-.END/ p' > $@

run: tls.pem
	dd if=/dev/urandom of=/dev/stdout count=8 bs=9 | xxd -p | tr -d '[:space:]' | $(UNHEX_RUN)
	$(UNHEX_RUN) $$(openssl x509 -text -noout -in tls.pem | grep -i 'Subject.Key.Identifier.' -C 1 | tail -1 | tr -d '[:space:]:')


.PHONY: all clean cls release debug fix fmt check build test
