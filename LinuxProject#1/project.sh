Chose_Read_First=0 #checks if the user had chosen read input first
NumOfLines=0 
Lines=() # Lines of the text given by the user
CategoryExist=0 #checks if the category entered by the user exists or not
CategoryExistt=0 #same as above
Categories=() #where categories are stored in 
index=0 #to find the index of the chosen category
indexx=0 #same reason above
Saved=0 #if the user saved the dataset or not
while [ "$Option" != "e" ]
do
echo "                                        "
echo "r) Read a dataset from a file"
echo "p) print the names of the features"
echo "l) encode a feature using label encoding"
echo "o) encode a feature using one-hot encoding"
echo "m) apply MinMax scalling" 
echo "s) save the processed dataset"
echo "e) Exit"
echo "Enter your choice"
echo "                                        "

read Option

case $Option in

r) echo "Enter the name of the file"

read FileName

if [ -e "$FileName" ]
then
FileContents=$(cat "$FileName")
while read -r line 
do

Lines+=("$line")
NumOfLines=$((NumOfLines + 1))
echo "$line"
done <<< "$FileContents"


# Count the number of words in the line
linee=$(echo "${Lines[0]}" | tr ";" " ")
word_count=$(echo "$linee" | wc -w) #How many words are in a line

for ((i = 0; i < $word_count; i++))
do
Categories+=($(echo "${Lines[0]}" | tr ';' ' '))
done 

Chose_Read_First=1

else 
echo "The file does not exist"
fi

;;

p)
#"printing"
#Doneee

if [ $Chose_Read_First -eq 0 ] 
then 
echo "You must read a dataset file first"

else
for ((i = 0; i < $NumOfLines; i++))
do
echo "${Lines[i]}"
done 

fi
;;

# --------------------------------------------------------------------------

l)
#label Encoding"

if [ $Chose_Read_First -eq 0 ] 
then 
echo "You must read a dataset file first"

else

echo "Please input the name of the categorical feature for label encoding"
read Input_Categorical

#Checking if the categorical input exists
for ((i = 0; i < $word_count; i++)) 
  do
     if [ "${Categories[i]}" = "$Input_Categorical" ]
     then
     	index=$((i + 1))  
  	CategoryExist=1
  fi
  done 
#Displaying result to the user
if [ $CategoryExist = 0 ]
then
echo "Wrong category!"
  

elif [ $CategoryExist = 1 ]
then
truncate -s 0 test.txt # to empty the file
for ((i = 1; i < $NumOfLines; i++))
do
    Word=($(echo "${Lines[i]}" | cut -d ';' -f $index))
    WordInLine[i]="$Word"
    echo "${WordInLine[i]}" >> test.txt

done

#append the unique values to unique.txt
sort test.txt | uniq -i  > unique.txt

#reading from the file and storing in an array
readarray -t Variables < unique.txt
size=$(wc -l < unique.txt)

for ((i =0 ; i < size; i++)) 
do

z=${Variables[i]}
echo "$z = $i"
 
done

for ((i = 1; i < NumOfLines; i++)) 
do

kelme=($(echo "${Lines[i]}" | cut -d ';' -f $index))

for ((j = 0; j < $size; j++)) 
do

if [ "${Variables[j]}" = "$kelme" ] 
then

Lines[i]=$(echo "${Lines[i]}" | sed 's/'$kelme'/'$j'/g')

fi

done
done

echo "Label encoding done.."
 
fi
fi

;;

#---------------------------------------------------------------------------

o)
#"one hot encoding"

if [ $Chose_Read_First -eq 0 ] 
then 
echo "You must read a dataset file first"
else

echo "Enter the feature to be encoded ( One hot Encoding)"
read F

for ((i = 0; i < $word_count; i++)) 
  do
     if [ "${Categories[i]}" = "$F" ]
     then
     	indexxx=$((i + 1))
  	CategoryExistt=1
  fi
  done 
#Displaying result to the user
if [ $CategoryExistt = 0 ]
then
echo "Feature does not exist!"

elif [ $CategoryExistt = 1 ]
then

truncate -s 0 tst.txt # to empty the file
for ((i = 1; i < $NumOfLines; i++))
do
    jubran=($(echo "${Lines[i]}" | cut -d ';' -f $indexxx))
    WordinLine[i]="$jubran"
    echo "${WordinLine[i]}" >> tst.txt

done

#append the unique values to unique.txt
sort tst.txt | uniq -i  > unique1.txt

#reading from the file and storing in an array
readarray -t Variable < unique1.txt
size1=$(wc -l < unique1.txt)

#to delete the word chosen from the user and it's values
for (( i=0 ; i<$NumOfLines ; i++))
do
IFS=';' read -ra words <<< "${Lines[i]}"

# Delete the (category chosen from the user) from the array
unset words[$indexxx-1]

# Join the array back into a string
Lines[i]=$(IFS=';'; echo "${words[*]}")
Lines[i]="${Lines[i]}"';'
done

#to concatinate the values to the first line
for ((i=0 ; i<$size1 ; i++))
do
if [ "$i" -eq 0 ]
then 
Lines[0]=${Lines[0]}${Variable[i]}
else
Lines[0]=${Lines[0]}";"${Variable[i]}
fi
done
Lines[0]=${Lines[0]}";"

readarray -t array < tst.txt

for ((i=0 ; i<$NumOfLines ; i++))
do
for ((j=0 ; j<$size1 ; j++))
do
if [ ${array[i]} = ${Variable[j]} ]
then
Lines[i+1]=${Lines[i+1]}"1;"
else
Lines[i+1]=${Lines[i+1]}"0;"
fi
done
done


echo "One hot encoding done.."

fi
fi

;;

#---------------------------------------------------------------------------

m)
#"minimizing"

if [ $Chose_Read_First -eq 0 ] 
then 
echo "You must read a dataset file first"

else

echo "Provide the name feature to be scaled"
read feature

    for ((i = 0; i < $word_count; i++)) 
 	 do
    	 if [ "${Categories[i]}" = "$feature" ]
    	 then
     		indexx=$((i + 1))
     fi
     done
     
	mota8ayer=($(echo "${Lines[1]}" | cut -d ';' -f $indexx))

  # Test if the variable is an integer using expr
  if expr "$mota8ayer" : '^[0-9]*$' >/dev/null
  then
    
    for ((i = 0; i < $word_count; i++)) 
  do
     if [ "${Categories[i]}" = "$feature" ]
     then
     	indexx=$((i + 1))
     	MaxValue=($(echo "${Lines[1]}" | cut -d ';' -f $indexx ))
     	MinValue=($(echo "${Lines[1]}" | cut -d ';' -f $indexx ))
     	
     	    for ((j = 0; j < $NumOfLines; j++)) do
     if [ $(echo "${Lines[j]}" | cut -d ';' -f $indexx ) -gt $MaxValue ]
     	    then 
     	MaxValue=($(echo "${Lines[j]}" | cut -d ';' -f $indexx ))
     	
      elif [ $(echo "${Lines[j]}" | cut -d ';' -f $indexx ) -lt $MinValue ]
     	then
     	MinValue=($(echo "${Lines[j]}" | cut -d ';' -f $indexx ))
     	
     	fi
  done 
  fi
  done #End of for loop
  echo "MaxValue = $MaxValue"
  echo "MinValue = $MinValue"
    for ((i = 1; i < $NumOfLines; i++))
    do
    
    Value=($(echo "${Lines[i]}" | cut -d';' -f $indexx))
    
    num1=$(($Value-$MinValue))
    num2=$(($MaxValue-$MinValue))
    NewValue=$(echo "scale=2; $num1/$num2" | bc) #math expressions
    
    #echo "$Value"
    #echo "$NewValue"
    
    Lines[i]=$(echo "${Lines[i]}" | sed 's/'$Value'/'$NewValue'/g')
    
    echo "${Lines[i]}"
    
    done
    
    else 
    echo "this feature is categorical feature and must be encoded first"
    fi
	fi # if the user had checked the read first

;;

s)
#echo "saving"

if [ $Chose_Read_First -eq 0 ] 
then 
echo "You must read a dataset file first"

else

echo "PLease enter the filename to save the processed dataset into"
read AfterFile

for ((i=0 ;i<$NumOfLines ; i++))
do

echo ${Lines[i]} >> $AfterFile

done

Saved=1

fi

;;

e)

if [ $Saved -eq 0 ]
then

echo "You have not saved the dataset!"
echo "Exit without saving? (Answer yes/no)"
read op

if [ $op = "no" ]
then

echo "PLease enter the filename to save the processed dataset into"
read AfterFile

for ((i=0 ;i<$NumOfLines ; i++))
do

echo ${Lines[i]} >> $AfterFile

done
echo "Saved --> $AfterFile"
Saved=1
fi

else 
echo "Thanks for using our program"
fi

;;
*)
echo "Invalid Option.Try the given ones"
;;
esac
done
