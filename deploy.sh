#!/bin/bash

# Solution: https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
if [ ! -f .env ]
then
  export $(cat .env | xargs)
fi

set -a && source .env && set +a

selected_message() {
	echo "$1 was selected"
}

deploy() {
	host=$1

	case $host in
		1)
			selected_message $host
			rsync -av --delete $PRODUCTION_USERNAME@$PRODUCTION_IP:$PRODUCTION_PATH $TEST_PATH
			exit()
			;;
		2)
			selected_message $host
			rsync -av --delete $TEST_PATH $PRODUCTION_USERNAME@$PRODUCTION_IP:$PRODUCTION_PATH
			;;
		*) 
			echo "Invalid option"
			;;
	esac
}

PS3="Deploy to: "
select hosts in prod_to_test test_to_prod; do

case $hosts in
	prod_to_test)
		deploy 1
		break
		;;
	test_to_prod)
		deploy 2
		break
		;;
	*)
		echo "Invalid option"
		;;
	esac
done