cd api-server
call npm i
cd ..\web-server
call npm i
cd ../gateway-server
call git submodule init
call git submodule update
cd ..\sample-configs\pm-demo
call copy-files
cd ..\..\gateway-server
call npm i
call slc start
call slc ctl set-size 1 1
cd ..\api-server
call slc start
call slc ctl set-size 2 1
cd ..\web-server
call node .
