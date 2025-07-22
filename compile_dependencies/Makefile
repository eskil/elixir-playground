all:
	mix xref graph
	mix clean && mix compile --verbose --no-all-warnings
	# This shows that client_one.ex depends on lib/c3.ex
	mix xref graph --source lib/client_one.ex --sink lib/c3.ex
