echo "Get current version"
dir=circus.robocalc.robosim.textual.repository/target/repository/
remote=/shared/storage/cs/www/robostar/robotool/robosim-textual/
url=ahm504@sftp.york.ac.uk
file=$(ls $dir/features | grep -m 1 jar)
version=${file#*_}
version=${version%.jar}

# Use the branch name to choose the name of the branch. This assumes
# no branch of name 'update' will ever be used.
if [[ $WERCKER_GIT_BRANCH = master ]];
then
  update=update
else
  update=$WERCKER_GIT_BRANCH
fi

if [[ $version = *[!\ ]* ]]; 
then 
  echo "Current version:" $version;
  echo "Branch:" $WERCKER_GIT_BRANCH;
  dest=${update}_${version}
  echo "Target dir:" $dest;
  rm -rf tmp
  mkdir tmp && cd tmp
  mkdir $dest
  cp -r ../$dir/* $dest
  ln -s $dest $update
  rsync -a -e "ssh" -rtzh . $url:$remote
  exit $?;
else
  echo "Couldn't find current version"
  exit 1;
fi
