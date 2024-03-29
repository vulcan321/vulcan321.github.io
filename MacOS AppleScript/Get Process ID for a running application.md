
  
## sysctl

```cpp
    struct kinfo_proc *result, *ptr; 
    int name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 }; 
    size_t length, i; 
    result = NULL; 
    length = 0; 

    if (sysctl((int *)name,(sizeof(name)/sizeof(*name)) - 1, NULL, &length, NULL, 0) == -1) 
        return 0;

    if ((result = (kinfo_proc *)malloc(length)) == NULL) 
        return 0;

    if (sysctl((int *)name, (sizeof(name)/sizeof(*name)) - 1, result, &length, NULL, 0) == -1) 
    {
        free(result);
        return 0;
    }

    for (i = 0, ptr = result; (i < (length/sizeof(kinfo_proc)); ++i, ++ptr) 
    { 
        // ptr->kp_proc.p_pid contains the pid 
        // ptr->kp_proc.p_comm contains the name 
        pid_t iCurrentPid = ptr->kp_proc.p_pid;
        if (strncmp(processName, ptr->kp_proc.p_comm, MAXCOMLEN) == 0)  
        {
            free(sProcesses);
            return iCurrentPid;
        }
    } 

    free(result);
```

## "/proc"
```cpp
QDirIterator it("/proc", QDirIterator::Subdirectories)
while (it.hasNext())
{
    it.next();
    QFileInfo child = it.fileInfo();

    if (child.fileName() == ".." || child.fileName() == ".")
    continue;

    ...
}
```
## "pgrep"
```cpp
QProcess process;
QString pgm("pgrep");
QStringList args = QStringList() << "appName";
process.start(pgm, args);
process.waitForReadyRead();
if(!process.readAllStandardOutput().isEmpty()) 
     // the app running
```

## EnumProcessModules "pgrep"
```cpp
unsigned int System::getProcessIdsByProcessName(const char* processName, QStringList &listOfPids)
{
    // Clear content of returned list of PIDS
    listOfPids.clear();
 
#if defined(Q_OS_WIN)
    // Get the list of process identifiers.
    DWORD aProcesses[1024], cbNeeded, cProcesses;
    unsigned int i;
 
    if (!EnumProcesses(aProcesses, sizeof(aProcesses), &cbNeeded))
    {
        return 0;
    }
 
    // Calculate how many process identifiers were returned.
    cProcesses = cbNeeded / sizeof(DWORD);
 
    // Search for a matching name for each process
    for (i = 0; i < cProcesses; i++)
    {
        if (aProcesses[i] != 0)
        {
            char szProcessName[MAX_PATH] = {0};
 
            DWORD processID = aProcesses[i];
 
            // Get a handle to the process.
            HANDLE hProcess = OpenProcess( PROCESS_QUERY_INFORMATION |
                PROCESS_VM_READ,
                FALSE, processID);
 
            // Get the process name
            if (NULL != hProcess)
            {
                HMODULE hMod;
                DWORD cbNeeded;
 
                if (EnumProcessModules(hProcess, &hMod, sizeof(hMod), &cbNeeded))
                {
                    GetModuleBaseNameA(hProcess, hMod, szProcessName, sizeof(szProcessName)/sizeof(char));
                }
                // Release the handle to the process.
                CloseHandle(hProcess);
 
                if (*szProcessName != 0 && strcmp(processName, szProcessName) == 0)
                {
                    listOfPids.append(QString::number(processID));
                }
            }
        }
    }
 
    return listOfPids.count();
 
#else
 
    // Run pgrep, which looks through the currently running processses and lists the process IDs
    // which match the selection criteria to stdout.
    QProcess process;
    process.start("pgrep",  QStringList() << processName);
    process.waitForReadyRead();
 
    QByteArray bytes = process.readAllStandardOutput();
 
    process.terminate();
    process.waitForFinished();
    process.kill();
 
    // Output is something like "2472\n2323" for multiple instances
    if (bytes.isEmpty())
        return 0;
 
    // Remove trailing CR
    if (bytes.endsWith("\n"))
        bytes.resize(bytes.size() - 1);
 
    listOfPids = QString(bytes).split("\n");
    return listOfPids.count();
 
#endif
}
```