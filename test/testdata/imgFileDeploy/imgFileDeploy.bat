@echo off

rem �C���[�W�t�@�C���p�X
set img_path=img\
rem �C���[�W�t�@�C����z�u����p�X
set deploy_path=img\repairCase\

cd %~dp0

echo === �o�b�`�����J�n ===
rem �C���[�W�t�@�C�����z�u����Ă���t�H���_����������
IF EXIST %img_path% ( 
rem 
rem �t�H���_���폜
  rmdir %img_path% /S /Q
)

rem �C���[�W�t�@�C���z�u
for /f %%a in (repairCaseId.dat) do (
  md %deploy_path%%%a
  copy img-1.jpg %deploy_path%%%a\ >nul
  copy img-2.jpg %deploy_path%%%a\ >nul
  copy img-3.jpg %deploy_path%%%a\ >nul
  copy img-4.jpg %deploy_path%%%a\ >nul
  copy img-5.jpg %deploy_path%%%a\ >nul
)
echo === �o�b�`�����I�� ===
pause:
