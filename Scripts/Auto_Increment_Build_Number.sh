#!/bin/sh

#######################################################################################################################
# give the build a build number A.B.C.D
# A - major release (on app store)
# B - minor release (on app store)
# C - sprint release
# D - adhoc release (daily release)
#######################################################################################################################
plist="${WORKSPACE}/SampleTest/SampleTest-Info.plist"
#dir=$(dirname "$plist")

BUILDNUM_PREFIX=`echo $(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$plist")| cut -d . -f1 -f2 -f3`
echo BUILDNUM_PREFIX is $BUILDNUM_PREFIX

BUILDNUM=`echo $(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$plist")| awk -F '.' '{print $4}'`
echo BUILDNUM is $BUILDNUM

if [ -z "$BUILDNUM" ]; then
echo "No build number in $plist"
exit 1
fi

BUILDNUM=$(expr $BUILDNUM + 1)
BUILDNUM_NEW="$BUILDNUM_PREFIX.$BUILDNUM"
echo BUILDNUM_NEW is $BUILDNUM_NEW

git checkout master

git pull https://username:password@github.com/sumantar/JenkinsTest.git master


/usr/libexec/Plistbuddy -c "Set CFBundleVersion $BUILDNUM_NEW" "$plist"
agvtool new-marketing-version $BUILDNUM_NEW
echo "Incremented build number to $BUILDNUM_NEW"

git add .
git commit -a -m "Auto increment of build number"
git push https://username:password@github.com/sumantar/JenkinsTest.git master

git fetch
git push https://username:password@github.com/sumantar/JenkinsTest.git master
