#!/bin/sh
# Scrape_01.awk
# gawk -f Scrape_01.awk

/^\* /{
	split($0,Arrays,"-");
	ID = Arrays[length(Arrays) - 1];
	Name = Arrays[length(Arrays)];
	ID_Cut = substr(ID, 3, length(ID) - 3);
	Name_Cut = substr(Name, 2, length(Name) - 1);
	print "CARD\t"ID_Cut"\t"Name_Cut;
	delete Arrays;
}

/\[4m/{
	split($0,Arrays," > ");
	print "LIST\t"substr(Arrays[length(Arrays)], 1, length(Arrays[length(Arrays)]) - 5);
	delete Arrays;
}

