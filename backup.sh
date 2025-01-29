#!/bin/bash

# Confere se os argumentos estão corretos
# Se o número de argumentos estiver errado ( $# != 2) retorna uma mensagem de erro e cancela a operação.
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# Isso confere se o argumento 1 e o argumento 2 são caminhos válidos.
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

targetDirectory=$1 
destinationDirectory=$2

echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

currentTS=$(date +%s)

backupFileName="backup-[$currentTS].tar.gz"

origAbsPath=$(pwd)

cd "$destinationDirectory" || { echo "Failed to change directory to $destinationDirectory"; exit 1; }
destDirAbsPath=$(pwd)


cd "$targetDirectory" || { echo "Failed to change directory to $targetDirectory"; exit 1; }

yesterdayTS=$((currentTS - 86400))

declare -a toBackup

for file in $(ls) 
do

  if ((`date -r $file +%s` > $yesterdayTS))
  then
    toBackup+=("$file")

  fi
done

tar -czvf $backupFileName ${toBackup[@]}

mv $backupFileName $destDirAbsPath

