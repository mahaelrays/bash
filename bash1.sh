#!/bin/bash
shopt -s extglob
#################--------------create--------------------#####################
CreateDB()
{
	read -p "enter database name : "	dbCreate;
	if [	! -d "$dbCreate" ]; then
		mkdir $dbCreate;
		echo "database created";
	else
		echo "database exist";
	fi
}
#################--------------rename--------------------#####################
RenameDB()
{
	read -p "enter database name : " dbname;
	if [ -d "$dbname" ]; then
		read -p "enter  new database name : " newdbname;
			if [ ! -d "$newdbname" ];then
				mv $dbname $newdbname;
			else
				echo "database already exist choose another name plz";
			fi

	else
		echo " database not exist";
	fi

}
#################--------------delete--------------------#####################
DeleteDB()
{
	read -p "enter database name : "	dbDelete ;
			if [  -d "$dbDelete" ];then
			  rm -R $dbDelete;
				echo " database delete";
			else
				echo " database not exist";
			fi
}
#################--------------createT--------------#####################
CreateT()
{
	read -p "enter table name : " tablename;
	filename=$tablename".txt";
	echo $filename;
	if [ ! -f "$filename" ];then
		touch  $tablename".txt";
		indexRule=0;
		arrRule=();
		read -p "enter number of table columns  : " tablecolums;
		for (( i = 0; i < $tablecolums; i++ ));
		do
			echo "choose column datatype:";
			select choice in int string primary_key
			do
			case $choice in
				int	)
					#printf "int:" >> $tablename".txt";
					arrRule[$indexRule]="int:";
					indexRule=$(($indexRule+1));
					break;;
				string	)
					#printf "string:" >> $tablename".txt";
					arrRule[$indexRule]="string:";
					indexRule=$(($indexRule+1));
					break;;

				primary_key	)
					#printf "string:" >> $tablename".txt";
					arrRule[$indexRule]="primary_key:";
					indexRule=$(($indexRule+1));
					break;;

					esac
				done
			read -p "enter column name:" columnName;
			#printf $columnName":" >> $tablename".txt";
			arrRule[$indexRule]="$columnName:";
			indexRule=$(($indexRule+1));


		done
		x='';
		for i in "${arrRule[@]}"
					 do
						x=$x$i;

					done
		echo $x>>$filename;
	else
		echo "table already exist choose another table";
	fi
}
#################--------------Drop_table--------------#####################
DropT()
{
	read -p "enter table name : " tablename;
	filename=$tablename".txt";
	if [  -f "$filename" ];then
		rm $filename;
		echo "table deleted";
	else
		echo "table not exist";
	fi
}
#################----------validationINT---------#######################
validationINT()
{
	read -p "enter the value of   : " value;
	if [[ $value	==	'' ]]; then
		echo "error in this data";
		exit;
	elif [[  $pk==${arrcolumName[$count]} ]]; then
			pkvalue=$value;
			validationPrimaryKey $thisIndexPk $filename $pkvalue
	fi
	case $value in
		+([0-9])	)
			arrResult[$index]="int:$value:" ;
			index=$(($index+1));

				;;
		* )
			echo "error in enter data ";
			exit
			;;
	esac

}
#################----------validationString---------#######################
validationString()
{
	read -p "enter the value of  : " value;
	if [[ $value	==	'' ]]; then
		echo "error in this data";
		exit;
	elif [[  $pk==${arrcolumName[$count]} ]]; then
			pkvalue=$value;
			validationPrimaryKey $thisIndexPk $filename $pkvalue
	fi
	case $value in
	+([[:alnum:]])	)
		arrResult[$index]="string:$value:" ;
		pkvalue=$value;
		index=$(($index+1));

			;;
	* )
		echo "error in enter data ";
		exit
		;;
	esac

}
#################----------validationPrimaryKey---------#######################
validationPrimaryKey()
{

		while read line
		do
			primaryResult=$( echo $line | cut -d ':' -f $thisIndexPk);
			#echo $primaryResult;
			if [[ $primaryResult == $pkvalue ]]; then
				echo "this data is exist";
				exit;
			fi
		done <$filename
}
#################---------------select----------------###################
SelectT()
{
	read -p "enter table name : " tablename;
	filename=$tablename".txt";
	if [  -f "$filename" ];then
		echo "choose from menu:"
		select choice in select_all select_specific_column select_where_condition aggregiate_function
		do
			case $choice in
		select_all	)
       awk '{print NR,$0}' $filename
			break
		;;
		select_specific_column )
			echo $(head -1 $filename)
		  read -p "enter the column you want to select $columnNum" value;
			awk -F: '{print $'$value'}' $filename;
			# echo $rowNum;
			break
		;;

		select_where_condition )

		echo "*****************************"
		select choice in selectall_undercondition  selectsomecol_undercondition
		do
			case $choice in

		selectall_undercondition )
			echo $(head -1 $filename)
			read -p "enter the column you want to select : " col;
			# echo $col;
			awk -F: '{print $'$col'}'  $filename
			read -p "enter the value " value;
			awk -F":" '$'$col' == '$value' { print $0 }' $filename
			break
		;;
			selectsomecol_undercondition )
				echo $(head -1 $filename)
				read -p "enter the numer of column you want to select : " numcol;

				for (( i = 0; i < $numcol; i++ )); do
					read -p "enter the column you want to select" variableCol;
					arrVariableCol[$i]=$variableCol;
				done

				read -p "enter the column you want do condition about it : " colCondition;
				read -p "enter the value equal this column : " valueCondition;
				colmNum=$( awk -F: '{if(NR==1)print (NF-1)}' $filename);

				for (( i = 1 ; i <= $colmNum; i++ )); do
					colmcondition=$(head -1 $filename | cut -d ':' -f $i );
					arrcolumNameCondition[$(($i-1))]=$colmcondition;
				done
				k=0;

				for (( i = 0; i < $colmNum; i++ )); do
					for j in "${arrVariableCol[@]}"
					 do
						if [[ ${arrcolumNameCondition[$i]} == $j ]]; then
							fieldNum[$k] = $i;
						fi
						if [[ $colCondition == ${arrcolumNameCondition[$i]} ]]; then
							colConditionNum=$i;
						fi
					done

				done
				x='';
				for i in "${fieldNum[@]}"
							 do
								x=$x' $'$i;

							done
							awk -F: {if('$'$colConditionNum==$valueCondition)print ($x)} $filename
		  break
		;;

		esac
		done
    echo "*****************************"

		break
		;;

		aggregiate_function )

		cat $filename
		read -p "enter the column $columnNum" columnNum;
		echo $columnNum;
		select choice in sum average  count
		do
			case $choice in
		sum	)
			# echo "sum"
			awk '{ sum += $'$columnNum' } END { print  "sum: " sum }' $filename
			break
		;;
		average)
			# echo "avg"
			awk '{ sum += $'$columnNum' } END { print "Average: " sum/ (NR-1) }' $filename
			break
		;;
		count)
		  # echo "count"
		  awk 'END { print "count: " NR-1 }' $filename
		exit;
		;;

		esac
		done

		break
		;;

		esac
		done

	else
		echo "table not exist";
	fi
}
#################--------------insert_into_table--------------################
InsertT()
{
	read -p "enter table name : " tablename;
	filename=$tablename".txt";
	if [  -f "$filename" ];then
		index=0;
		arrResult=();

	colmNum=$( awk -F: '{if(NR==1)print (NF-1)}' $filename);
	indexName=0;
	count=0;
	for (( i = 1 , j=0; i <= $colmNum; j++ , i+=2 )); do
		colmDataType=$(head -1 $filename | cut -d ':' -f $i );
		if [[ $colmDataType == 'primary_key' ]]; then
			arrcolum[$j]=$colmDataType;
			indexName=$(($indexName+2));
			colmName=$(head -1 $filename | cut -d ':' -f $indexName );
			arrcolumName[$j]=$colmName;
			pk=$colmName;
		#	pkIndex=$indexName;
		else
			arrcolum[$j]=$colmDataType;
			indexName=$(($indexName+2));
			colmName=$(head -1 $filename | cut -d ':' -f $indexName );
			arrcolumName[$j]=$colmName;

		fi

	done
	pkIndex=0;
	for i in "${arrcolum[@]}"
	 do
		if [[ $i==$pk  ]]; then
			thisIndexPk=$pkIndex;
		fi
		pkIndex=$(($pkIndex+1));
	done

		for i in "${arrcolum[@]}"
			do

			   case $i in
					 	int	)

							echo ${arrcolumName[$count]};
					 		validationINT $pk ${arrcolumName[$count]} $filename


						;;
						string	)
							echo ${arrcolumName[$count]};
							validationString $pk ${arrcolumName[$count]} $filename


						;;
						primary_key	)
						arrResult[$index]="	:	:" ;
						index=$(($index+1));

						;;

					esac
					count=$(($count+1));
			done
				x='';
				for i in "${arrResult[@]}"
							 do
								x=$x$i;

							done
				echo $x>>$filename;


	else
		echo "table not exist";
	fi
}

#################--------------delete_from_table--------------#####################

DeleteT()
{
	read -p "enter table name : " tablename;
	filename=$tablename".txt";
	if [  -f "$filename" ];then
			cat $filename;
			read -p "enter the column you want to select " col;
  		# echo $col;
  		awk -F: '{print $'$col'}'  $filename
  		read -p "enter the value " val;

  		row=$(awk -F":" '$'$col' == '$val' { print $0 }' $filename)
      echo $row

			v=''$row''d
			echo $v;
			sed -i "/$row/d" $filename;
			echo "column deleted successfully";

	else
		echo "table not exist";
	fi
}

#################--------------use_database--------------#####################
UseDB()
{
			read -p "enter database name : " dbname;
			if [ -d "$dbname" ]; then
				cd $dbname
				echo "Database changed";
				echo "choose from menu:"
				select choice in create_table drop_table update_table delete_from_table select_from_table insert_into_table
				do
					case $choice in
			 	create_table	)
					CreateT
					break
				;;
				drop_table)
					DropT
					break
				;;
				update_table) echo "update"
				exit;
				;;
				delete_from_table)
				DeleteT
				break
				;;
				select_from_table)
					SelectT
					break;
				;;
				insert_into_table)
					InsertT
					break;
				;;

				esac
				done
			else
				echo "database not exist";
			fi
}
#################--------------MENU--------------------#####################
echo "choose from menu:"
select choice in create_datebase rename_database delete_database use_database end
do
case $choice in
create_datebase )
	CreateDB
	break
;;
rename_database )
	RenameDB
	break
;;
delete_database  )
	DeleteDB
	break
;;
use_database  )
	UseDB
	break
;;
end	)
	echo "exit from program";
	exit;
;;

* )
exit;

;;

esac
done
