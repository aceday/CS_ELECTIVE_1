@echo off
cls
REM create a script that accepts a number
REM then determines its range:
REM 1-100
REM 101-200
REM 201-300

REM START PROGRAM

set /p number=Enter a number: 

:scale_num
  REM Theres 4 conditions
  if %number% geq 1 if %number% leq 100 (
      echo The number is in the range 1-100
  ) else if %number% geq 101 if %number% leq 200 (
      echo The number is in the range 101-200
  ) else if %number% geq 201 if %number% leq 300 (
      echo The number is in the range 201-300
  ) else (
      echo The number is outside the range 1-300
  )
  goto end
goto scale_num

:end
pause

REM END PROGRAM