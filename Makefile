# Makefile to build 'cpufetch's executable.
# Needs Makefile.cpufetch.build as helper makefile for platform-dependent build
# settings and rules.
ifneq ($(wildcard cpufetch_asm/.),)
$(info ++++ info: Assembly modules found! Using local cache)
else
$(warning Missing prerequisites: cpufetch_asm. See https://github.com/Xemorph/cpufetch-asm)
$(warning You can't compile cpufetch without it's assembly modules, please acquire them)
$(error Aborting compilation)
endif

lib.name = cpufetch

# common sources
common.sources = src/common/main.c src/common/cpu.c src/common/udev.c src/common/printer.c src/common/getopt.c src/common/args.c src/common/global.c

ifneq ($(OS),Windows_NT)
	arch := $(shell uname -m)
	ifeq ($(arch), $(filter $(arch), x86_64 amd64 i686))
		SRC_DIR = src/x86/
		class.sources = $(SRC_DIR)cpuid.c $(SRC_DIR)apic.c $(SRC_DIR)uarch.c
		shared.sources = cpufetch_asm/src/cpuid_asm.unx.asm
	else ifeq ($(arch), $(filter $(arch), ppc64le ppc64 ppcle ppc))
		SRC_DIR = src/ppc/
		class.sources = 
	else ifeq ($(arch), $(filter $(arch), arm aarch64_be aarch64 arm64 armv8b armv8l armv7l armv6l))
		SRC_DIR = src/arm/
		class.sources = 
	else
		# Error lines should not be tabulated because Makefile complains about it
$(warning Unsupported arch detected: $(arch). See https://github.com/Dr-Noob/cpufetch#1-support)
$(warning If your architecture is supported but the compilation fails, please open an issue in https://github.com/Dr-Noob/cpufetch/issues)
$(error Aborting compilation)
	endif
else
	SRC_DIR = src/x86/
	class.sources = $(SRC_DIR)cpuid.c $(SRC_DIR)apic.c $(SRC_DIR)uarch.c
	shared.sources = cpufetch_asm/src/cpuid_asm.win.asm
endif

# include Makefile.build from submodule directory './'
CPUFETCH_DIR=./
include $(CPUFETCH_DIR)/Makefile.cpufetch.build