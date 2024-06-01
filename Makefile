test:
	python3 kat_test.py | tee run1.log
	cat run1.log kat/kat1.txt | grep -v '#' | sort | uniq -c -w 64
	
clean:
	$(RM) -f *.pyc *.cprof */*.pyc *.rsp *.log
	$(RM) -rf __pycache__ */__pycache__

