TESTS=test001 test002 test003 test004 test005 test006 test007 test008 test009 test010 test011 test012 test013 test014 test015 test016 test017 test018 test019 test020 test021 test022 test023 test027 test028 my_test001 my_test002 my_test003 my_test004 my_test005 my_test006 sevas_test001 sevas_test002
INTERPRETER_TESTS=

.PHONY: check $(TESTS) $(INTERPRETER_TESTS)

check: $(TESTS) $(INTERPRETER_TESTS)

$(TESTS): %: %.expr
	cat $@.input | ../rc.native -i $< > $@.log && diff $@.log orig/$@.log
	cat $@.input | ../rc.native -s $< > $@.log && diff $@.log orig/$@.log
	RC_RUNTIME=../runtime ../rc.native -o  $< && cat $@.input | ./$@ > $@.log && diff $@.log orig/$@.log

$(INTERPRETER_TESTS): %: %.expr
	cat $@.input | ../rc.native -i $< > $@.log && diff $@.log orig/$@.log
	cat $@.input | ../rc.native -s $< > $@.log && diff $@.log orig/$@.log

clean:
	rm -f my_test*.log test*.log *.s *~ $(TESTS)
