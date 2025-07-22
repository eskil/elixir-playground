all:
	mix xref graph
	mix clean && mix compile --verbose --no-all-warnings
	mix xref graph --source lib/c3.ex --sink lib/c3.ex
