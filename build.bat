rm "Tower Defense.love"
moonc .
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -x\.git -afzip "Tower Defense"
mv "Tower Defense.zip" "Tower Defense.love"
love "Tower Defense.love"