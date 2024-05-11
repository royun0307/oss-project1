#! /bin/bash

if [ $# -ne 3 ]
then
	echo "usage: $0 file1 file2 file3"
	exit 1
fi
stop="N"
 echo "************OSS1 - Project1************"
 echo "*       StudentID : 12191630          *"
 echo "*       Name : Beongchul Yun          *"
 echo "***************************************"
until [ "$stop" = "Y" ]
do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in"
	echo "players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in mateches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv"
	echo "& matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE (1~7):" choice

	case "$choice" in
	1)
		read -p "Do you want to get the Heung-Min Son's data? (y/n):" con
		if [ $con == "y" ]
		then 
			cat $2 | awk -F, '$1=="Heung-Min Son" {printf("Team:%s,Appearance:%d, Goal:%d,Assist:%d\n\n",$4,$6,$7,$8)}'
		fi;;
	2)
		read -p "What do you wnat to get the team data of legue_position[1~20]:" position
		Team=$(cat $1 | awk -v position=$position -F, '$6==position {print $1}')
		Winning_rate=$(cat $1 | awk -v position=$position -F, '$6==position {print $2/($2+$3+$4)}')
		echo "$position" $Team $Winning_rate
		;;
	3)
		read -p "Do you want to know Top-3 attendance data? (y/n):" con
		if [ $con == "y" ]
		then
			echo "***Top-3 Attendance Match***"
			echo ""
			for K in 1 2 3
			do
				cat $3 | sort -t "," -n -r -k 2 | awk -v n=$K -F, 'NR==n {printf("%s vs %s (%s)\n%d %s\n",$3,$4,$1,$2,$7)}'
				echo ""
			done
		fi;;
	4)
		 read -p "Do you want to get each team's ranking and the highest-scoreing player? (y/n):" con
                if [ $con == "y" ]
                then
                        echo ""
			for K in $(seq 1 20)
                        do
				Team=$(cat $1 | awk -v k=$K -F, '$6==k {print $1}')
				echo $K $Team
				cat $2 | sort -t "," -n -r -k 7 | awk -F, -v team="$Team" '$4==team {print $1, $7}' | head -n 1 
                                echo ""
                        done
                fi;;

	5)
		 read -p "Do you want to modify the format of date? (y/n):" con
                if [ $con == "y" ]
                then
                       cat $3 | awk -F, 'NR>1 {print $1}' | sed -E 's/([A-Za-z]{3}) ([0-9]{2}) ([0-9]{4}) - ([0-9]*)/\3\/\1\/\2 \4/' |sed -e 's/Jen/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Apr/04/g' -e 's/May/05/g' -e 's/Jun/06/g' -e 's/Jul/07/g' -e 's/Aug/08/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -e 's/Nov/11/g' -e 's/Dec/12/g' | head -n 10
                fi;;

	6)
		for K in $(seq 1 10)
		do	
			for I in 0 10
			do
				n=$((K + I))
				Team=$(cat $1 | awk -v n=$n -F, 'NR==n+1 {printf("%s",$1)}')
				printf '%2d) ' "$n"
				printf '%-25s' "$Team"
			done
			echo ""
		done
		echo ""
		read -p "Enter your team number:" num
		n=$((num + 1))
		Team=$(cat $1 | awk -v n=$n -F, 'NR==n {print $1}')
		Dif=$(cat $3 | awk -v team="$Team" -F, '$3==team {print $5-$6}' | sort -n -r -k 1 | head -n 1)
		cat $3 | awk -v team="$Team" -F, '$3==team {{printf("%s,%s,%d,%s,%d,",$1,$3,$5,$4,$6)}{print $5-$6}}' | awk -v dif=$Dif -F, '$6==dif {printf("%s\n%s %d vs %d %s\n\n",$1,$2,$3,$5,$4)}'	
		echo ""
		;;

	7)
		echo "Bye!"
		stop="Y" ;;

	*)
		echo "Error: Invalid option. Please enter your CHOICE in 1~7";;

	esac
done
exit 0
