if [ $CI_XCODEBUILD_ACTION = 'archive' ]
then
    echo "Uploading Symbols To Firebase"
    # Add your path to the GoogleService-Info.plist & add in your app name.
    # upload-symbols script can be copied from your firebase crashlytics frameowkr directory
    ./upload-symbols -gsp ../SmartReceipts/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs/SmartReceipts.app.dSYM
fi