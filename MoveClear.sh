#!/bin/sh
# MoveClear.sh
# sh MoveClear.sh

which trello > /dev/null 2>&1
test $? -ne 0 && echo "trello Binary IS NOT FOUND." && exit 99
which gawk > /dev/null 2>&1
test $? -ne 0 && echo "gawk IS NOT FOUND." && exit 99

trello show-lists -b "DB_PM1" | \
tail -n +2 | \
awk '/./' | \
sed -e 's/ (ID: /\t/' | \
awk '{print substr($0,1,length($0) - 1);}' | \
cat > tempLists.tsv

trello show-cards -b "DB_PM1" | \
gawk -f Scrape_01.awk | \
gawk -f Scrape_02.awk | \
egrep '_OK$' | \
cat > tempMoveTarget.tsv

test -z tempLists.tsv && echo "List IS NOT FOUND." && exit 1
test -z tempMoveTarget.tsv && echo "Card IS NOT FOUND." && exit 2

gawk -f Scrape_03.awk tempLists.tsv tempMoveTarget.tsv | \
sh

exit 0

