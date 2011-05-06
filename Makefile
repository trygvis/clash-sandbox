all:

.PHONY: clean import

clean:
	@echo Cleaning cruft
	@rm -f $(wildcard *.o) work-obj93.cf counter1_tb
	@$(MAKE) import

import:
	ghdl -i `find . -name \*.vhd` `find . -name \*.vhdl`

counter1_tb: counter1_tb.vhd $(wildcard vhdl/Counter1.counterTop/*.vhdl)
	ghdl -m $@
	ghdl -r $@ --vcd=$@.vcd --stop-time=1us
