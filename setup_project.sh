#!/bin/bash
# the students  attendance tracker - setup_project.sh


echo "THE STUDENTS ATTANDANCE TRACKER"
echo " ---------------------------"
echo ""

read -p "Enter project name : " NAME

if [ -z "$NAME" ]; then
echo "project name can't be empty"
exit 1
fi

echo ""
DIR="attendance_tracker_${NAME}"
echo "this project will be created in the :$DIR"

echo ""

cleanup() {
echo "";
echo " interrupted! CLEAN UP....";

if [  -d "$DIR" ]; then
tar -czf "${DIR}_archive.tar.gz"  "$DIR" 2>/dev/null;
rm -rf "$DIR";
echo "archive created :${DIR}_archive.tar.gz";
echo "have cleaned up the incomplete directory";

fi;

echo "";
echo "the script terminated.your work is now saved";
exit

}
trap cleanup SIGINT

mkdir -p "$DIR/"
echo " created : $DIR/"

mkdir -p "$DIR/Helpers/"
echo "successfully created:$DIR/Helpers/"
mkdir -p "$DIR/reports"
echo "successfully created:$DIR/reports"
echo ""

if [ -f "attendance_checker.py" ]; then
        cp "attendance_checker.py" "$DIR/"
        echo " is copied: attendance_checker.py"

else
        echo " error:attendance_checker.py not found"
        exit 1
fi


if [ -f "Helpers/assets.csv" ]; then 
        cp "Helpers/assets.csv" "$DIR/Helpers/"
        echo "successfully copied:assets.csv"

else 
        echo "error:assets.csv is not found"
        exit 1

fi




        if [ -f "Helpers/config.json" ]; then
                cp "Helpers/config.json" "$DIR/Helpers/"
                echo "is copied :config.json"

        else
            echo " error: config.json is not found"
                exit 1

        fi

        if [ -f "reports/reports.log" ]; then
                cp "reports/reports.log" "$DIR/reports/"
                echo " is copied: reports.log"
        else
                touch "$DIR/reports/reports.log"
                echo " is created empty: reports.log"
        fi

        echo ""


        if [ -f "$DIR/Helpers/config.json" ]; then
                echo "the current attendance threasholds :"

                grep -E '"warning"|"failure"' "$DIR/Helpers/config.json"

                                                echo ""

                read -p "do you want to update threasholds?(y/n): " UPDATE_CHOICE

                if  [[ "$UPDATE_CHOICE" == "y" || "$UPDATE_CHOICE" == "Y" ]]; then
                        echo ""

                        read -p "enter the new Warning threashold [75]: " NEW_WARNING
                        NEW_WARNING=${NEW_WARNING:-75}

                read -p "enter the new failure threashold [50]:" NEW_FAILURE
        NEW_FAILURE=${NEW_FAILURE:-50}

        if ! [[ "$NEW_WARNING" =~ ^[0-9]+$ ]]; then
        echo "Invalid warning threashold.Using default 75."
        NEW_WARNING=75
        fi
        if ! [[ "$NEW_FAILURE" =~ ^[0-9]+$ ]]; then
        echo "Invalid failure threashold. Using default 50."
        NEW_FAILURE=50
        fi

        echo ""
        echo "updating the config.json...."
sed -i "s/\"warning\": [0-9]*/\"warning\": $NEW_WARNING/" "$DIR/Helpers/config.json"
sed -i "s/\"failure\": [0-9]*/\"failure\": $NEW_FAILURE/" "$DIR/Helpers/config.json"
 
echo " updated:warning = $NEW_WARNING%, failure = $NEW_FAILURE%"
echo ""

echo "the new threasholds:"
grep -E '"warning"|"failure"' "$DIR/Helpers/config.json"

else
        echo " keeping the default threasholds"
                fi
fi

echo " checking the python3 installation ...."

if command -v python3 &> /dev/null; then
        python_version=$(python3 --version 2>&1)
        echo " python3 is installed:$python_version"

else
        echo "WARNING:python3 is not installed"
        echo " attendance checker requires pyrhon3 to run "
        echo " install it with : sudo apt install python3"
  fi

        echo ""
echo " SETUP COMPLETED"
echo ""
echo ""

echo "the project location:"
echo "$(pwd)/$DIR"
echo ""
echo "Files created:"
echo " |__attendance_checker.py"
echo " |__Helpers/"
echo " |    |__assets.csv"
echo " |    |__config.json"
echo " |__reports"
echo "      |__reports.log"
echo ""
echo " the directory structure:"
echo ""

if command -v tree &> /dev/null; then
        tree "$DIR"
else
        ls -la "$DIR"
        echo ""
        ls -la "$DIR"/Helpers | sed 's/^/ /'
        echo ""
        ls -la "$DIR/reports" | sed 's/^/ /'

        fi
echo ""
        echo ""

        echo " to run the attendance checker :"
        echo "cd $DIR"
        echo "python3 attendance_checker.py"
        echo ""
        echo " to test the ctrl+c archive features:"
        echo "run this script again and press ctrl+c"

        echo ""                                                                                                                                   

