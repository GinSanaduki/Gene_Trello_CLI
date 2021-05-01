#!/usr/bin/gawk -f
# Scrape_03.awk
# gawk -f Scrape_03.awk

BEGIN{
	FS = "\t";
	cnt = 0;
	print ":";
}

ENDFILE{
	cnt++;
}

(cnt == 0){
	Arrays[$1] = $2;
	next;
}

{
	ExistCheck = Arrays[$2];
	if(ExistCheck == ""){
		print "trello add-list -b \"DB_PM1\" -l \""$2"\"";
		Arrays[$2] = "DUMMY";
	}
	
	if(Arrays[$2] == "DUMMY"){
		Lists = $2;
	} else {
		Lists = Arrays[$2];
	}
	
	print "trello move-card \""$3"\" \""Lists"\" -p bottom";
	
}

