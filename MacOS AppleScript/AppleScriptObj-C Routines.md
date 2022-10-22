AppleScriptObj-C Routines

AppleScriptObjective-C (also called: AppleScriptObj-C or ASOC) is the dynamic fusion of the AppleScript and Objective-C languages, providing access within scripts to the classes and methods of the core Cocoa frameworks of macOS, while also possessing the ability to query and command applications throughout macOS via Apple Events.

For its 20th anniversary debut in OS X Mavericks, AppleScript gained a long-sought ability: an import command — dramatically extending the scope and power of this unique language.

A new AppleScript construct called the “use statement” imports the terminology and functionality of AppleScript Libraries and scriptable Applications through a simple single-line declaration placed at the top of a script, such as:
```applescript
    use application "Finder"
    use script "My AppleScript Text Library"
    use framework "Foundation"
```

The handlers, scriptable objects, properties, and terminology of AppleScript Libraries and scriptable applications imported via a “use statement,” are automatically available globally throughout the hosting script, no longer requiring numerous “tell statements” or “tell blocks” to be compiled and executed. Scripts taking advantage of the “use statement” are more streamlined and clearer than similar scripts not implementing this new construct.

In addition, AppleScript Libraries written in AppleScript/Objective-C, can incorporate “use” statements to import Cocoa frameworks, such as MapKit, EventKit, and WebKit.

AppleScript/Objective-C is available to all scripts, not just library scripts. To use an Objective-C framework in your script, you must specify it with a use statement, such as: use framework "Foundation"

use AppleScript version "2.4" -- Yosemite (10.10) or later use framework "Foundation" use scripting additions
```applescript
use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions
```
Here’s a short video demonstrating the use of AppleScriptObj-C to sort a list on names:

 Your browser does not support the video tag.

Important AppleScriptObj-C Constructs

Here are rules to follow when writing AppleScriptObj-C.

1) Identify Cocoa classes and enumerations as belonging to the current application.
```applescript
current application's ClassName

	set anEnumeration to current application's enumerationName
	current application's ClassName's methodName:anEnumeration
    set aResult to ¬
    current application's ClassName's methodName:aValue parameter:aValue
```

2) Cocoa methods are separated from their parameter values by colons, and are shown to belong to their parent class.
```applescript
    set aResult to ¬
    current application's ClassName's methodName:aValue parameter:aValue
```

3) When retrieving the value of a Cocoa property, the property name is written ending with open/close parens ()
```applescript
    set aValue to CocoaObject's propertyName()

```

4) When setting the value of a Cocoa Object's property, no ending parens are included. Optionally the property may be used as a method by placing the term set before its capitalized version, followed by a colon and the new value.
```applescript
    set CocoaObject's propertyName to aValue
    CocoaObject's setPropertyName:aValue
```
Hre are some supporting reference links:

[EverdayAppleScriptObjC by Shane Stanely](http://macosautomation.com/applescript/apps/index.html)

[Mac Automation Scripting Guide](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/index.html#//apple_ref/doc/uid/TP40016239-CH56-SW1)

[AppleScript release notes](https://developer.apple.com/library/archive/releasenotes/AppleScript/RN-AppleScript/RN-10_10/RN-10_10.html)

Strings

AppleScriptObj-C provides access to the [NSString class](https://developer.apple.com/documentation/foundation/nsstring?language=objc) of the Foundation frameworks, containing methods for easily manipulating text strings, even those used as paths representing the location of disk items.

The following routines use methods and properties of the NSString class to simplify common text manipulations that are more difficult to perform using the AppleScript language alone.

Converting to Objective-C and Back

There is a typical process for manipulating AppleScript text strings using the NSString class methods and properties of the Frameworks framework. AppleScript text strings are first converted to Objective-C text objects, manipulated using Cocoa class methods and properties, and the result is then coerced back into an AppleScript text string.

```applescript
    set cocoaString to ¬
    current application's NSString's stringWithString:"Happy Birthday"
    -- do something with the cocoa string
    -- return the result coerced to an AppleScript string
    return (cocoaString as text)
```

 01-02  In order to process the provided text, it must be first converted into an Objective-C text object using the stringWithString method.

 07  After manipulating the Objective-C text object, the final text object is returned as an AppleScript text string by using the “as text” coercion.

The following examples use the described procedure to perform common text manipulations.

Change Case

The native AppleScript language does not offer built-in methods for converting the case of text strings. AppleScriptObj-C can be used to access the NSString methods and properties to change the case of text.

```applescript
on changeCaseOfText(sourceText, caseIndicator)
    set the sourceString to ¬
    current application's NSString's stringWithString:sourceText
    -- apply the indicated transformation to the Cocoa string
    if the caseIndicator is 0 then
    -- optional: localizedUppercaseString
    set the adjustedString to sourceString's uppercaseString()
    else if the caseIndicator is 1 then
    -- optional: localizedLowercaseString
    set the adjustedString to sourceString's lowercaseString()
    else
    -- optional: localizedCapitalizedString
    set the adjustedString to sourceString's capitalizedString()
    end if
    -- convert from Cocoa string to AppleScript string
    return (adjustedString as text)
end changeCaseOfText
```
Trim Whitespace

Here a routine for removing tabs, spaces, and paragraph returns from the beginning and end of a provided text string. Use the **whitespaceCharacterSet** property to remove only tabs and spaces, but not line feeds and returns.

Replace Text in String

Here’s a routine for finding and replacing a text string from within larger strings.

```applescript
on replaceStringInString(sourceText, searchString, replacementString)
    set aString to current application's NSString's stringWithString:sourceText
    set resultString to ¬
    aString's stringByReplacingOccurrencesOfString:searchString withString:replacementString
    return resultString as text
end replaceStringInString
```
Base Name of a File

The NSString class contains methods and properties that are designed to manipulate POSIX file paths that indicated the location of disk items.

In the following example, the base name (file name without file extension) is returned from a passed file reference.

```applescript
on basenameFromFileReference(aReference)
    -- get the POSIX path of the file reference
    set aPath to the POSIX path of aReference
    -- convert to a Cocoa string
    set cocoaString to ¬
    current application's NSString's stringWithString:aPath
    -- get the last path item
    set fileName to cocoaString's lastPathComponent()
    -- remove the file extension
    set baseName to fileName's stringByDeletingPathExtension()
    -- return as AppleScript string
    return baseName as text
end basenameFromFileReference
```
Container of a File

The NSString class contains methods and properties that are designed to manipulate POSIX file paths that indicated the location of disk items.

In the following example, an alias reference to the containing folder of a passed file reference is returned.

```applescript
on containingFolderFromFileReference(aReference)
    -- get the POSIX path of the file reference
    set aPath to the POSIX path of aReference
    -- convert to a Cocoa string
    set cocoaString to ¬
    current application's NSString's stringWithString:aPath
    -- remove the last path item
    set parentPath to cocoaString's stringByDeletingLastPathComponent()
    -- append closing slash and convert POSIX path to alias
    return ((parentPath as text) & "/") as POSIX file as alias
end containingFolderFromFileReference
```
POSIX Path of Item

This routine will return a POSIX path for the designated file reference. Accepts: aliases, file URLs, POSIX files, and relative paths
 
```applescript
on returnPOSIXPathForItem(itemReference)
    (* This routine attempts to return a clean full POSIX path reference *)
    -- check class of input
    if the class of itemReference is alias then
        set itemReference to the POSIX path of itemReference
    else if the class of itemReference is «class furl» then
        set itemReference to the POSIX path of itemReference
    else if class of itemReference is string then
        if itemReference begins with "'" and ¬
            itemReference ends with "'" then
            -- remove single quotes
            set itemReference to text 2 thru -2 of itemReference
        end if
        if itemReference begins with "~" then
            set CocoaString to ¬
            current application's NSString's stringWithString:itemReference
            set itemReference to ¬
            (CocoaString's stringByExpandingTildeInPath()) as text
        end if
        set itemReference to POSIX path of itemReference
    end if
    return itemReference
end returnPOSIXPathForItem
```
Derive Path for File in Specified Folder

This routine is very useful when you are creating new files in a specific folder. The routine will check to see if a file with the provided name already exists, and if it does, generate a unique numerically incremented version. For example, if the file named "Report.txt" is already in the target folder, the routine will return a path for the new file with the incremented name "Report-1.txt"

Derive Path for New File in Specified Folder
 
```applescript 
on derivePathForNewFileInSpecifiedFolder(targetDirectory,documentTitleToUse, documentExtensionToUse)
    set targetFolderPath to the POSIX path of targetDirectory
    if targetFolderPath does not end with "/" then settargetFolderPath to targetFolderPath & "/"
    set documentBaseNamePath to targetFolderPath &documentTitleToUse
    set documentFullPath to documentBaseNamePath & "." &documentExtensionToUse
    set aFileManager to current application's NSFileManager'sdefaultManager()
    set incrementIndex to 0
    repeat while (aFileManager's fileExistsAtPath:documentFullPath)
    set incrementIndex to incrementIndex + 1
    set documentFullPath to ¬
    documentBaseNamePath & "-" & incrementIndex & "." & documentExtensionToUse
end derivePathForNewFileInSpecifiedFolder
```
Number to Formatted Currency String

This routine will convert the passed number into a formatted currency string using the current locale.

Number to Formatted Currency String
 
```applescript 
on convertNumberToCurrencyValueString(thisNumber)
    --> returns comma delimited, rounded, localized currency value
    --> e.g.: (9128 = $9,128.00) (9978.2485 = $9,128.25)
    set currencyStyle to current application's NSNumberFormatterCurrencyStyle
    set resultingText to ¬
    current application's NSNumberFormatter's localizedStringFromNumber:thisNumber numberStyle:currencyStyle
    return (resultingText as text)
end convertNumberToCurrencyValueString
```

Number to Percentage Value String

This routine will convert a decimal value into a percentage value string.


Number to Percentage Value String
 
```applescript
on convertNumberToPercentageValueString(thisNumber)
    --> returns comma delimited, rounded, localized percentage value, e.g.: (0.2345 = 23%) (0.2375 = 24%)
    set percentstyle to ¬
    current application's NSNumberFormatterPercentStyle
    set resultingText to ¬
    current application's NSNumberFormatter's localizedStringFromNumber:thisNumber numberStyle:percentstyle
    return (resultingText as text)
end convertNumberToPercentageValueString
```
Number to Words

This routine converts the passed number into a phrase. For example, 12345678 becomes twelve million three hundred forty-five thousand six hundred seventy-eight.

Number to Words
 
```applescript
01		on convertNumberToWords(thisNumber)
02		 --> returns a numeric value in words, e.g: (23 = “twenty-three”) (23.75 = “twenty-three point seven five”)
03		 set numberStyle to current application's NSNumberFormatterSpellOutStyle
04		 set resultingText to ¬
05		 current application's NSNumberFormatter's localizedStringFromNumber:thisNumber numberStyle:numberStyle
06		 return (resultingText as text)
07		end convertNumberToWords
```
Number to Decimal String

This routine will return a decimal string from the provided numeric value. You can indicate a specific decimal length for the resulting value. In addition, the numeric value will automatically be rounded during the process of adding decimals.

Number to Decimal String
 
```applescript 
on convertNumberToDecimalString(theNumber, theNumberOfDecimalPlaces)
    set theFormatter to current application's NSNumberFormatter's new()
    set theFormatter's minimumFractionDigits to theNumberOfDecimalPlaces
    set theFormatter's maximumFractionDigits to theNumberOfDecimalPlaces
    set theFormattedNumber to theFormatter's stringFromNumber:theNumber
    return (theFormattedNumber as text)
end convertNumberToDecimalString
```
Number to Ordinal String

Creates an ordinal string based upon the provided number. For example, 23 derives 23rd.

Number to Ordinal String
 
```applescript
on numberToOrdinalString(thisNumber)
    set theFormatter to current application's NSNumberFormatter's new()
    set thisNumberStyle to ¬
    current application's NSNumberFormatterOrdinalStyle
    tell theFormatter to set its numberStyle to thisNumberStyle
    return (theFormatter's stringFromNumber:thisNumber) as text
end numberToOrdinalString
```
Number to String

This routine converts the passed number to a string. Especially useful for converting scientific notation to “normal” numbers. For example, 1.23456789E+9 becomes 1234567890.

List from String

This routine divides a string into a list of components based upon the indicated delimiter.

Break String into Components
```applescript
on getItemsFromDelimitedString(thisString, thisDelimiter)
    set thisString to ¬
    current application's NSString's stringWithString:thisString
    set theseStrings to ¬
    thisString's componentsSeparatedByString:thisDelimiter
    return theseStrings as list
end getItemsFromDelimitedString
```
List to String

This routine combines the elements of a list into a delimited string.

Break String into Components
 
```applescript  
on getItemsFromDelimitedString(thisString, thisDelimiter)
    set thisString to ¬
    current application's NSString's stringWithString:thisString
    set theseStrings to ¬
    thisString's componentsSeparatedByString:thisDelimiter
    return theseStrings as list
end getItemsFromDelimitedString
```
Percent Encode the String

This routine will percent encode all non-alphanumeric characters in a string. For example, a space will replaced with %20.

Percent Encode String
 
```applescript  
on encodeUsingPercentEncoding(sourceText)
    -- create a Cocoa string from the passed AppleScript string
    set sourceString to ¬
    current application's NSString's stringWithString:sourceText
    -- indicate the allowed characters that do not get encoded
    set allowedCharacterSet to ¬
    current application's NSCharacterSet's alphanumericCharacterSet
    -- apply the indicated transformation to the Cooca string
    set adjustedString to ¬
    sourceString's stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet
    -- convert from Cocoa string to AppleScript string
    return (adjustedString as text)
end encodeUsingPercentEncoding
``` 
Decode Percent Encoded String

This routine will replace percent encoding in a string with corresponding characters.

Decode Percent Encoded String
 
```applescript 
on decodePercentEncoding(sourceText)
    -- create a Cocoa string from the passed AppleScript string
    set sourceString to ¬
    current application's NSString's stringWithString:sourceString
    -- apply the indicated transformation to the Cooca string
    set adjustedString to ¬
    sourceString's stringByRemovingPercentEncoding()
    -- coerce from Cocoa string to AppleScript string
    return (adjustedString as text)
end decodePercentEncoding
```
Arrays

Here are series of routines for manipulating lists (arrays).

Sort List

Here’s a routine for alphabetically sorting a list.

Sort List
 
```applescript
on sortListOfStrings(theList)
    -- convert list to Cocoa array
    set theArray to ¬
    current application's NSArray's arrayWithArray:theList
    -- sort the array using a specific function
    set theArray to ¬
    theArray's sortedArrayUsingSelector:"localizedStandardCompare:"
    -- return the sorted array as an AppleScript list
    return theArray as list
end sortListOfStrings
```

Insert Item in List

This routine inserts an item in the provided list at the indicated position. The first position is 1 not 0.


Insert Item in List
 
```applescript
on insertItemInList(anItem, theIndex, theList)
    -- create an editable array from the list
    set theArray to ¬
    current application's NSMutableArray's arrayWithArray:theList
    -- insert item at position. Index of first postion is 1 not 0
    theArray's insertObject:anItem atIndex:(theIndex - 1)
    -- return Cocoa array as an AppleScript list
    return theArray as list
end insertItemInList
```
Remove Item from List

This routine removes all occurrences of an indicated item from the provided list.

Remove Item from List
 
```applescript
on deleteOccurencesOfItemFromList(anItem, theList)
    -- create an editable Cocoa array
    set theArray to ¬
    current application's NSMutableArray's arrayWithArray:theList
    -- remove the item from the array
    theArray's removeObject:anItem
    -- return the array as an AppleScript list
    return theArray as list
end deleteOccurencesOfItemFromList
```
Index of First Occurence in List

This routine returns the index of the first occurence of an item in a list. If item is not in the list, then 0 is returned.

Index of First Occurence in List
 
```applescript
on indexOfItemInList(aValue, theList)
    -- convert list to Cocoa array
    set theArray to ¬
    current application's NSArray's arrayWithArray:theList
    -- get the index of the first occurence of the item
    set theIndex to (theArray's indexOfObject:aValue)
    -- check the class of the result
    if class of theIndex is real then
    return 0
    else
    -- return the index adjusted for AppleScript
    return (theIndex + 1)
    end if
end indexOfItemInList
```
Remove Items at Indexes

This routine will remove the items at the provided indexes.


Delete List Items at Indexes
 
```applescript 
on deleteListItemsAtIndexes(theIndexes, theList)
    -- create an editable array
    set theArray to ¬
    current application's NSMutableArray's arrayWithArray:theList
    -- create an empty index set
    set theSet to ¬
    current application's NSMutableIndexSet's indexSet()
    -- add the index matches to the set
    repeat with anIndex in theIndexes
    (theSet's addIndex:(anIndex - 1))
    end repeat
    -- remove matched items
    theArray's removeObjectsAtIndexes:theSet
    -- return the edited array as list
    return theArray as list
end deleteListItemsAtIndexes
```
Records

Routines for manipulating records.

New Record from Lists

Turn a list of keys and a list of corresponding values into an AppleScript record.

Convert Lists to Record
 
```applescript
on recordFromLabelsAndValues(theseLabels, theseValues)
	-- create a Cocoa dictionary using lists of keys and values
	set theResult to ¬
		current application's NSDictionary's dictionaryWithObjects:theseValues forKeys:theseLabels
	-- return the resulting dictionary as an AppleScript record
	return theResult as record
end recordFromLabelsAndValues
```
Property Lists

Routines for manipulating standard property lists (plist).

Here is a simple sample property list file ([DOWNLOAD](http://cmddconf.com/bootcamp/Sample.plist.zip)) containing a single key/value pair.

Example Property List
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>City</key>
        <string>San Francisco</string>
    </dict>
</plist>
</div>
```
Edit Value of Existing Key

Here is an example script showing how to edit the value of the specified key in the property list. NOTE: the sub-routine in this example is written in Cocoa format with the values for the function and parameters following colon (":") characters:

```applescript
use framework "Foundation"
use scripting additions

-- READ THE CONTENTS AN EXISTING PROPERTY LIST INTO EDITABLE DICTIONARY
set pListFilePath to "~/Desktop/Sample.plist"
set pListFilePath to ¬
	current application's NSString's stringWithString:pListFilePath
set pListFilePath to pListFilePath's stringByExpandingTildeInPath()
set sourceDictionary to ¬
	current application's NSMutableDictionary's dictionaryWithContentsOfFile:pListFilePath
-- EDIT THE VALUE OF AN EXISTING KEY/VALUE PAIR
sourceDictionary's setObject:"Seattle" forKey:"City"
-- WRITE EDITED DICTIONARY BACK TO PROPERTY LIST
its storeRecord:sourceDictionary inPath:pListFilePath

-- THE SUB-ROUTINE IN COCOA FORMAT
on storeRecord:theRecord inPath:thePath
	set thePath to ¬
		current application's NSString's stringWithString:thePath
	set thePath to ¬
		thePath's stringByExpandingTildeInPath()
	set savingFormat to current application's NSPropertyListBinaryFormat_v1_0
	set theData to ¬
		current application's NSPropertyListSerialization's dataWithPropertyList:theRecord format:savingFormat options:0 |error|:(missing value)
	theData's writeToFile:thePath atomically:true
	log result -- so we can see if it saved
end storeRecord:inPath:
```

FYI: here’s a basic routine for retrieving the value of a property list element:
```applescript
use framework "Foundation"
use scripting additions

-- DERIVE A COMPLETE POSIX PATH TO PROPERTY LIST
set pListFilePath to "~/Desktop/Sample.plist"
set pListFilePath to ¬
	current application's NSString's stringWithString:pListFilePath
set pListFilePath to ¬
	pListFilePath's stringByExpandingTildeInPath()
set pListURL to ¬
	current application's NSURL's fileURLWithPath:pListFilePath isDirectory:false
-- READ THE PROPERTY LIST INTO MEMORY
set sourceDictionary to ¬
	current application's NSDictionary's dictionaryWithContentsOfURL:pListURL |error|:(missing value)
-- GET VALUE FOR ELEMENT
set aValue to (sourceDictionary's objectForKey:"City") as text
```
Here’s an example of creating a property list containing multiple elements, each of which is an array:

```applescript
set firstElementList to {1, 3, 4, 7, 9}
set secondElementList to {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
set theRecord to my recordFromLabelsAndValues({"firstElement", "secondElement"}, {firstElementList, secondElementList})
set thePath to "~/Desktop/Multiple-Element.plist"
my writeAsPropertyList(theRecord, thePath)

on recordFromLabelsAndValues(theseLabels, theseValues)
	-- create a Cocoa dictionary using lists of keys and values
	set theResult to ¬
		current application's NSDictionary's dictionaryWithObjects:theseValues forKeys:theseLabels
	-- return the resulting dictionary as an AppleScript record
	return theResult as record
end recordFromLabelsAndValues

on writeAsPropertyList(theRecord, thePath)
	set thePath to current application's NSString's stringWithString:thePath
	set thePath to thePath's stringByExpandingTildeInPath()
	set savingFormat to ¬
		current application's NSPropertyListBinaryFormat_v1_0
	set theData to ¬
		current application's NSPropertyListSerialization's dataWithPropertyList:theRecord format:savingFormat options:0 |error|:(missing value)
	theData's writeToFile:thePath atomically:true
	return result -- so we can see if it saved
end writeAsPropertyList
```

The resulting property list:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>firstElement</key>
        <array>
            <integer>1</integer>
            <integer>3</integer>
            <integer>4</integer>
            <integer>7</integer>
            <integer>9</integer>
        </array>
        <key>secondElement</key>
        <array>
            <string>Monday</string>
            <string>Tuesday</string>
            <string>Wednesday</string>
            <string>Thursday</string>
            <string>Friday</string>
            <string>Saturday</string>
            <string>Sunday</string>
        </array>
    </dict>
</plist>
```
Bookmarks

Routine for generating a minimal bookmark to a file. This routine returns bookmark data that can later be resolved into a URL object for a file even if the user moves or renames it (if the volume format on which the file resides supports doing so).

```applescript
on getBookmarkDataFor:aPath
	if class of aPath is not string then
		set aPath to the POSIX path of aPath
	else
		set aPath to current application's NSString's stringWithString:aPath
		set aPath to aPath's stringByExpandingTildeInPath()
	end if
	set theURL to current application's NSURL's fileURLWithPath:aPath
	set bookmarkData to ¬
		theURL's bookmarkDataWithOptions:0 includingResourceValuesForKeys:{} relativeToURL:(missing value) |error|:(missing value)
	return bookmarkData
end getBookmarkDataFor
```