result = sys.msgbox("ntScrubber Starting!", "ntScrubber", MB_TYPEOKCANCEL, MB_ICONEXCLAMATION)
if result == "cancel" then
      print("User Cancelled")
      sys.msgbox("ntScrubber Cancelled!", "ntScrubber", MB_TYPEOK, MB_ICONEXCLAMATION)
      os.exit(1)
end

os_ver = sys.os()
spool_processor_dir = "w32x86"
if string.match(os_ver.processor, "x32") then
   spool_processor_dir = "w32x86"
   print("Detected x32 OS")
else
   if string.match(os_ver.processor, "x64") then
      spool_processor_dir = "x64"
      print("Detected x64 OS")
   else
      print("Unsupported OS")
      os.exit(1)
   end
end

device_enumerator_list = 
{
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1102",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1104",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1106",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1102w",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P_1102w",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1104w",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1106w",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_P1566",
  "USBPRINT\\Hewlett-PackardHP_LaserJet_Professional_1606dn",
  "USBSTOR\\CdRom&Ven_HP&Prod_Smart_Install&Rev_1.0",
  "USB\\Vid_03f0&Pid_002a",
  "USB\\Vid_03f0&Pid_032a",  
  "USB\\Vid_03f0&Pid_092a",  
  "USB\\Vid_03f0&Pid_0a2a",
  "USB\\Vid_03f0&Pid_102a",
}

printer_driver_list = 
{
  "HP LaserJet Professional P1102",
  "HP LaserJet Professional P1104",
  "HP LaserJet Professional P1106",

  "HP LaserJet Professional P1102w",
  "HP LaserJet Professional P 1102w",
  "HP LaserJet Professional P1104w",
  "HP LaserJet Professional P1106w",

  "HP LaserJet Professional P1566",

  "HP LaserJet Professional 1606dn",
}

print_processor_list = 
{
  "HP1100PrintProc",
}

print_monitor_list = 
{
  "HP1100LM",
}

oem_inf_section_list = 
{
  "HP1100",
  "HP1600",
}

filepath_cleanup_list =
{
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100EC.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100SD.CHM", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100SD.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100SD.SDD", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100SU.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100SU.ENT", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100SU.VER", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1600SD.CHM", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1600SD.SDD", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100GC.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\3\\HP1100PP.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),

  string.format("%s\\spool\\drivers\\%s\\HP1100EC.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100SD.CHM", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100SD.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100SD.SDD", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100SU.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100SU.ENT", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100SU.VER", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1600SD.CHM", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1600SD.SDD", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100GC.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\HP1100PP.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),

  string.format("%s\\spool\\prtprocs\\%s\\HP1100PP.DLL", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),

  string.format("%s\\HP1100EC.DLL", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100SD.CHM", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100SD.DLL", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100SD.SDD", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100SU.DLL", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100SU.ENT", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100SU.VER", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1600SD.CHM", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1600SD.SDD", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100GC.DLL", sys.folderpath(CSIDL_SYSTEM)),
  string.format("%s\\HP1100PP.DLL", sys.folderpath(CSIDL_SYSTEM)),

  string.format("%s\\system32\\HP1100LM.DLL", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\HP1100SM.EXE", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\HP1100SMs.DLL", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\HPSIsvcP1100.exe", sys.folderpath(CSIDL_WINDOWS)),

  string.format("%s\\mvtcpui.ini", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\mvhlewsi.dll", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\mvtcpmon.dll", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\mvtcpui.dll", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\mvusbews.dll", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\slp32.dll", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\slp64.dll", sys.folderpath(CSIDL_WINDOWS)),
  string.format("%s\\system32\\slpconf.xml", sys.folderpath(CSIDL_WINDOWS)),

  string.format("%s\\system32\\drivers\\mvusbews.sys", sys.folderpath(CSIDL_WINDOWS)),
}

folderpath_cleanup_list =
{
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La4EA1", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La4C21", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La8DA0", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La9ECF", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La3ECC", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La5ECD", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_LaECE2", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),
  string.format("%s\\spool\\drivers\\%s\\Hewlett_PackardHP_La89A6", sys.folderpath(CSIDL_SYSTEM), spool_processor_dir),

  string.format("%s\\HP\\HP LaserJet P1100 Series", sys.folderpath(CSIDL_PROGRAM_FILES)),
}

registry_cleanup_list =
{
  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1102",
  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1104",
  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1106",

  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1102w",
  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P 1102w",
  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1104w",
  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1106w",

  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1566",

  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1606dn",

  HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Print\\Printers\\HP LaserJet Professional P1606dn",

  HKEY_CURRENT_USER,  "SOFTWARE\\Hewlett-Packard\\HPLJ1100 SM",
}


--
-- turn on verbose messaging
--
verbose(true)


--
-- Uninstall HP LaserJet Professional P1100 Series Software
--
print(string.format("Attempt to run HP LaserJet P1100 Series Software Uninstaller"))
commandline = string.format("%s\\HP\\HP LaserJet P1100 Series\\UnInstall.exe", sys.folderpath(CSIDL_PROGRAM_FILES))
print(string.format("Running P1100 Series Software Uninstaller = %s", commandline))
if (sys.exist(commandline)) then
   proc.execute(commandline)
   print(string.format("Waiting for UnInstall.exe to complete..."))
   while (proc.pid("UnInstall.exe") > 0) do
      sys.wait(1000)      
   end
else
   print(string.format("  **Could not find %s", commandline))
end


--
-- Stop HPSIP1100Service
--
print("Stopping HPSIP1100Service")
if service.stop("HPSIP1100Service", 15000) == 0 then
  print("  **Failed to stop HPSIP1100Service**")
end

--
-- Delete HPSIP1100Service
--
print("Deleting HPSIP1100Service")
if service.delete("HPSIP1100Service") == 0 then
  print("  **Failed to delete HPSIP1100Service**")
end


--
-- Stop Spooler
--
print("Stopping spooler")
if service.stop("spooler", 15000) == 0 then
  print("  **Failed to stop spooler**")
end

--
-- Uninstall Driver Package
--
infpath = string.format("%s\\HP\\HP LaserJet P1100 Series\\HP1100.INF", sys.folderpath(CSIDL_PROGRAM_FILES))
print(string.format("Attempt to Uninstall Driver Package for: %s", infpath))
if device.dpuninst(infpath) == 0 then
  print(string.format("  **Failed to uninstall driver package**"))
end


--
-- Remove Device(s) 
--
function func_remove_devices(enumName)
  print(string.format("Removing devices with enumerator = %s", enumName))
  if device.pnpremove(enumName, true, true) == 0 then
    print("  **Failed to remove all devices**")
  end
end

i=1
while (i <= #device_enumerator_list) do
  func_remove_devices(device_enumerator_list[i])
  i = i + 1
end


--
-- Remove any dangling OEM INFs
--
function oeminf_files(filename, status)
  if (status == 0) then
    i=1
    while (i <= #oem_inf_section_list) do
      if (device.infisvalid(filename, oem_inf_section_list[i]) == 1) then
        print(string.format("Removing device INF file = %s", filename))
        if (device.infremove(filename, oem_inf_section_list[i]) == 0) then
          print("  **Failed to remove device INF file**")
        end
      end
      i = i + 1
    end
  end

  return 1
end

print(string.format("Attempting to remove any dangling OEM INFs"))
wininfdir = string.format("%s\\inf",sys.windir())
sys.forfiles(wininfdir, "oem*.inf", 0, oeminf_files)


--
-- Start Spooler
--
print("Starting spooler")
if service.start("spooler", 15000) == 0 then
  print("  **Failed to start spooler**")
end


--
-- Remove Printer(s)
--
function func_remove_printers(driverName)
  print(string.format("Removing printers using driver = %s", driverName))
  if printer.removeprinters(driverName) == 0 then
    print("  **Failed to remove all printers**")
  end
end

i=1
while (i <= #printer_driver_list) do
  func_remove_printers(printer_driver_list[i])
  i = i + 1
end


--
-- Remove Printer Driver(s)
--
function func_remove_drivers(driverName)
  print(string.format("Removing printer driver = %s", driverName))
  if printer.removedrivers(driverName) == 0 then
    print("  **Failed to remove printer driver**")
  end
end

i=1
while (i <= #printer_driver_list) do
  func_remove_drivers(printer_driver_list[i])
  i = i + 1
end


--
-- Remove Print Processor(s)
--
function func_remove_processors(processorName)
  print(string.format("Removing print processor = %s", processorName))
  if printer.removeprintprocessors(processorName) == 0 then
    print("  **Failed to remove print processor**")
  end
end

i=1
while (i <= #print_processor_list) do
  func_remove_processors(print_processor_list[i])
  i = i + 1
end


--
-- Remove Print Monitor(s)
--
function func_remove_monitors(monitorName)
  print(string.format("Removing monitor = %s", monitorName))
  if printer.removemonitors(monitorName) == 0 then
    print("  **Failed to remove monitor**")
  end
end

i=1
while (i <= #print_monitor_list) do
  func_remove_monitors(print_monitor_list[i])
  i = i + 1
end


--
-- Stop Spooler
--
print("Stopping spooler")
if service.stop("spooler", 15000) == 0 then
  print("  **Failed to stop spooler**")
end


--
-- Cleanup files in list filepath list
--
i=1
while (i <= (#filepath_cleanup_list)) do
  fullpath = filepath_cleanup_list[i]
  print(string.format("Removing file path = %s", fullpath))
  sys.del(fullpath)
  i = i + 1
end


--
-- Cleanup folderpath directorys in list
--
i=1
while (i <= (#folderpath_cleanup_list)) do
  fullpath = folderpath_cleanup_list[i]
  print(string.format("Removing directory tree = %s", fullpath))
  sys.deltree(fullpath)
  i = i + 1
end


--
-- Cleanup registry key paths in list
--
i=1
while (i <= (#registry_cleanup_list-1)) do
  key = registry_cleanup_list[i]
  keypath = tostring(registry_cleanup_list[i+1])
  print(string.format("Removing registry key = %s\\%s", reg.strhkey(key), keypath))
  reg.deletetree(key, keypath)
  i = i + 2
end


--
-- Start Spooler
--
print("Starting spooler")
if service.start("spooler", 15000) == 0 then
  print("  **Failed to start spooler**")
end


--
-- Notify complete
--
result = sys.msgbox("ntScrubber Completed!\n\nReboot is required.", "ntScrubber", MB_TYPEOKCANCEL, MB_ICONEXCLAMATION)
if result == "ok" then
   sys.shutdown(10, false, true)
end

