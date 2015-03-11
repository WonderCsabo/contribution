SOURCES_DIR=src/main/java

echo "Testing Checkstyle started"

cat projects-to-test-on.properties | while read line; do 

    [[ "$line" == \#* ]] && continue # Skip lines with comments
    [[ -z "$line" ]] && continue     # Skip empty lines
    
    REPO_NAME=`echo $line | cut -d '=' -f 1`
    REPO_URL=`echo $line | cut -d '=' -f 2`
    
    REPO_SOURCES_DIR=$SOURCES_DIR/$REPO_NAME
    
    if [ -d "$REPO_SOURCES_DIR" ]; then
      echo "Pulling repository '$REPO_NAME' ..."
      cd $REPO_SOURCES_DIR
      git pull
      cd -
      echo -e "Pulling repository '$REPO_NAME' - completed\n"
    else
      echo "Cloning repository '$REPO_NAME' ..."
      git clone $REPO_URL $REPO_SOURCES_DIR
      echo -e "Cloning repository '$REPO_NAME' - completed\n"
    fi

done

mvn --batch-mode clean

echo "Running Checkstyle on $SOURCES_DIR ..."
mvn --batch-mode site "$@"
echo "Running Checkstyle on $SOURCES_DIR - finished"

echo "Testing Checkstyle finished"

echo "linking report to index.html"
mv target/site/index.html target/site/index_.html
ln -s checkstyle.html target/site/index.html 

echo "Done."