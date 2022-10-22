```
Usage: open [-e] [-t] [-f] [-W] [-R] [-n] [-g] [-h] [-s <partial SDK name>][-b <bundle identifier>] [-a <application>] [-u URL] [filenames] [--args arguments]
Help: Open opens files from a shell.
      By default, opens each file using the default application for that file.  
      If the file is in the form of a URL, the file will be opened as a URL.
Options: 
      -a                    Opens with the specified application.
      -b                    Opens with the specified application bundle identifier.
      -e                    Opens with TextEdit.
      -t                    Opens with default text editor.
      -f                    Reads input from standard input and opens with TextEdit.
      -F  --fresh           Launches the app fresh, that is, without restoring windows. Saved persistent state is lost, excluding Untitled documents.
      -R, --reveal          Selects in the Finder instead of opening.
      -W, --wait-apps       Blocks until the used applications are closed (even if they were already running).
          --args            All remaining arguments are passed in argv to the application's main() function instead of opened.
      -n, --new             Open a new instance of the application even if one is already running.
      -j, --hide            Launches the app hidden.
      -g, --background      Does not bring the application to the foreground.
      -h, --header          Searches header file locations for headers matching the given filenames, and opens them.
      -s                    For -h, the SDK to use; if supplied, only SDKs whose names contain the argument value are searched.
                            Otherwise the highest versioned SDK in each platform is used.
      -u, --url URL         Open this URL, even if it matches exactly a filepath
      -i, --stdin  PATH     Launches the application with stdin connected to PATH; defaults to /dev/null
      -o, --stdout PATH     Launches the application with /dev/stdout connected to PATH; 
          --stderr PATH     Launches the application with /dev/stderr connected to PATH to
          --env    VAR      Add an enviroment variable to the launched process, where VAR is formatted AAA=foo or just AAA for a null string value.
```