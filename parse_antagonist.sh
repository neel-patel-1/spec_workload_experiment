#!/bin/bash

source shared.sh
a_f=antagonist_output/antagonist_log.txt
grep PAGEWRKR_1_Batch_Perf $a_f |\
	gawk -f <(cat - <<-'_EOF_'
BEGIN{
	dur=0;
	ops=0;
}
{
	match($4, /[0-9]+/, tmp)
	dur+=tmp[0]
	match($3, /[0-9]+/, tmp)
	ops+=tmp[0]
}
END{
	printf("avg_page_ops/ms:%f\n", ops/dur);
}
		
_EOF_
)
