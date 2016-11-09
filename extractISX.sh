#!/bin/sh
################################################################################
#  Description to be added soon                                                #
#                                                                              #
################################################################################


vPathToISX=${1}
#This will be used to extract a single object from the ISX file
vJob=${2}

fUsage() {
    echo "extractISX.sh <full path to ISX file> [job name]"
    exit 1
}

fCheckStatus() {
    if [[ ${1} -ne 0 ]] ; then
        echo "There has been an error with ${2}"
        exit ${1}
    fi
}

if [[ $# -eq 0 || $# -gt 3 ]] ; then
    fUsage
else
    vDirToISX=$( dirname ${vPathToISX} )
    vISXFile=$( basename ${vPathToISX} )
    vCurrentDir=$( pwd )
fi

cd ${vDirToISX}
    fCheckStatus $? "cd ${vDirToISX}"

unzip ${vISXFile}
    fCheckStatus $? "unzip ${vISXFile}"

# For our purposes we do not want the ISX once processed, so we remove it
# Comment out as necessary
rm -f ${vISXFile}
    fCheckStatus $? "rm -f ${vISXFile}"
    
mv META-INF/IS-MANIFEST.MF ./IS-MANIFEST.MF
    fCheckStatus $? "mv META-INF/IS-MANIFEST.MF ./IS-MANIFEST.MF"

find . -type f -regextype posix-egrep -regex '.*tbd|.*pjb|.*qjb|.*pst' |
    while read vProcessFile ; do
        #Just the job name like pxjExtractCustomerAddress
        vJobName=$( basename ${vProcessFile} | sed 's/\.\(pjb\|qjb\|pst\|tbd\)$//' )
        
        vOutputManifest="./META-INF/IS-MANIFEST.MF"
        
        head -2 ./IS-MANIFEST.MF > ${vOutputManifest}
        cat ./IS-MANIFEST.MF | sed -n -e '/<entries name="'${JobName}'"/,/  <\/entries>/ p' >> ${vOutputManifest}
        tail -1 ./IS-MANIFEST.MF >> ${vOutputManifest}
        
        zip ${vJobName}.isx "${vProcessFile}" "${vOutputManifest}"
    done

exit 0
        
