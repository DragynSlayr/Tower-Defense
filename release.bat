call build.bat
cp "Tower Defense.love" "./../build/Tower Defense.love"
cd ./../build
mv "Tower Defense.love" TD.love
cp ../love.exe love.exe
copy /b love.exe + TD.love TD.exe
mv TD.exe "Tower Defense.exe"
mv TD.love "./../release/Mac/Tower Defense.love"
rm love.exe
cp * ./../release/Windows
cd ./../release
set path="C:\Program Files\WinRAR\";%path%
winrar a -r -afzip "Tower Defense"
cd "./../Tower Defense"