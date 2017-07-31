rm "Tower Defense.love"
call compile.bat
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -x\.git -x\*.bat -x\*.moon -x\*.py -x\changes.txt -afzip "Tower Defense"
mv "Tower Defense.zip" "Tower Defense.love"