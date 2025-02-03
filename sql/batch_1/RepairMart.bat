@echo off
@echo Rebuilding RepairMart
for %%G in (*.sql) do sqlcmd -S LENOVO-T490\SQLEXPRESS -d RepairMart -E -i "%%G"
PAUSE