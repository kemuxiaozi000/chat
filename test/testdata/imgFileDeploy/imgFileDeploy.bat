@echo off

rem イメージファイルパス
set img_path=img\
rem イメージファイルを配置するパス
set deploy_path=img\repairCase\

cd %~dp0

echo === バッチ処理開始 ===
rem イメージファイルが配置されているフォルダを検索する
IF EXIST %img_path% ( 
rem 
rem フォルダを削除
  rmdir %img_path% /S /Q
)

rem イメージファイル配置
for /f %%a in (repairCaseId.dat) do (
  md %deploy_path%%%a
  copy img-1.jpg %deploy_path%%%a\ >nul
  copy img-2.jpg %deploy_path%%%a\ >nul
  copy img-3.jpg %deploy_path%%%a\ >nul
  copy img-4.jpg %deploy_path%%%a\ >nul
  copy img-5.jpg %deploy_path%%%a\ >nul
)
echo === バッチ処理終了 ===
pause:
