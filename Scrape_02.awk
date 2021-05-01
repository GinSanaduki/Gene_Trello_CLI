#!/bin/sh
# Scrape_02.awk
# gawk -f Scrape_02.awk

BEGIN{
	FS = "\t";
}

($1 == "LIST"){
	Lis = $2;
	Lis_Done = Lis;
	sub(/^Do_/,"Done_",Lis_Done);
	next;
}

{
	print Lis"\t"Lis_Done"\t"$2"\t"$3;
}

