

show-db:
	duckdb dev.duckdb -c "select * from $(T);"


demo:
	echo "this is demo