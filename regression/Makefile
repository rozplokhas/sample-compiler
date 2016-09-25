ALLTESTS=test001 test002 test003 test004 test005 test006
ITESTS=test007 test008

.PHONY: check $(ALLTESTS) $(ITESTS)
check: $(ALLTESTS) $(ITESTS)

$(ALLTESTS): %: %.expr %.input orig/%.log
	../src/rc.byte $@.expr && cat $@.input | ./$@ > $@.log && diff $@.log orig/$@.log
	cat $@.input | ../src/rc.byte -i $@.expr > $@.log && diff $@.log orig/$@.log

$(ITESTS): %: %.expr %.input orig/%.log
	cat $@.input | ../src/rc.byte -i $@.expr > $@.log && diff $@.log orig/$@.log

clean:
	rm *.log *.s *~
