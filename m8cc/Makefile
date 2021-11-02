ifeq ($(OS),Windows_NT)
CCOPY = copy
CMAKE = make
CDEL = del /Q
S = \\
else
CCOPY = cp
CDEL = rm -f
CMAKE = make
S = /
endif

LIBRARIES = kernel xsprites

.PHONY: all 

all: 
	make -C ..$(S)libraries
	$(CCOPY) ..$(S)libraries$(S)runtime.rb .

	


