#!/usr/bin/env bash
#-----------------------------------------------------------------------
# Prog:     pylintr.sh
# Version:  0.1.0
# Desc:     This script walks down a project tree searching for all .py
#           files and runs pylint over each file, using the default 
#           pylint config file and stores the report to the defined 
#           ${OUTPUT} location.
#
#           Once complete, a scoring summary is printed for each file.
#
# UPDATES:
# 11.01.19  J. Berendt  Written.
#-----------------------------------------------------------------------

OUTPUT="./pylintr_results"
EXT=".txt"
SUMMARY="${OUTPUT}/summary.txt"


# TEST FOR OUTPUT DIRECTORY
if [ ! -d ${OUTPUT} ]; then
    echo
    echo Creating output directory ...
    mkdir ${OUTPUT}
else
    echo
    echo Removing current results ...
    rm ${OUTPUT}/*${EXT}
fi

# RUN PYLINT OVER ALL *.PY FILES
for f in $( /usr/bin/find . -name "*.py" ); do
    base=$( basename ${f} )
    if [[ ${base} =~ ^[a-z]+\.py ]]; then
        echo Processing: ${f}
        outname=$( echo ${base} | sed s/.py// )${EXT}
        pylint ${f} > "${OUTPUT}/${outname}"
    fi
done

echo Done.
echo

# READ EACH REPORT AND EXTRACT SUMMARY
echo Pylint Summary: > ${SUMMARY}
echo ------------------------ >> ${SUMMARY}
for f in ${OUTPUT}/*; do
    if [ ${f} != ${SUMMARY} ]; then
        score=$( cat ${f} | grep -Eo "^Your.*\s\(" | grep -Eo "([0-9]+\.[0-9]+\/[0-9]+)" )
        echo $( basename ${f} ): ${score} >> ${SUMMARY}
    fi
done
echo ------------------------ >> ${SUMMARY}

# PRINT SUMMARY
cat ${SUMMARY}
echo
