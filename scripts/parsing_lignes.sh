(echo "{"; cat ../data/lignes/lignes.html | sed -e 's/<\/li>/\n/g' | grep href | sed -e 's/lign/\nlign/' | grep lign | perl -e 'while(<>) {
	s/lign_id=(\d+)">([^<]+).*/"\1":"\2",/; print;}'; echo "}") >> ../data/lignes/parsed.json")
