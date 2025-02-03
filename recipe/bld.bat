@echo on

mkdir build
cd build

cmake -LAH -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_UNITY_BUILD=ON -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 ^
    -DCMAKE_MESSAGE_LOG_LEVEL=STATUS ^
    -DQT_NO_MSVC_MIN_VERSION_CHECK=ON ^
    -DQT_DEFAULT_MEDIA_BACKEND=ffmpeg ^
    ..
if %ERRORLEVEL% neq 0 exit 1

cmake --build . --target install --config Release
if %ERRORLEVEL% neq 0 exit 1

:: unversioned exes must avoid clobbering the qt5 packages, but versioned dlls still need to be in PATH
xcopy /y /s %LIBRARY_PREFIX%\lib\qt6\bin\*.dll %LIBRARY_PREFIX%\bin
if %ERRORLEVEL% neq 0 exit 1
