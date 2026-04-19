# Objective-C Fundamentals - NSXMLParser

[Manning](https://www.codeproject.com/script/Membership/View.aspx?mid=36560)



A Chapter excerpt from Objective-C Fundamentals

<table><tbody><tr><td><img height="188" alt="image002.jpg" src="https://www.codeproject.com/KB/books/NSXMLParser/image002.jpg"></td><td><a href="http://www.manning.com/fairbairn/">Objective-C Fundamentals</a><br><em>Developing iPhone &amp; iPad Apps</em><p>By Christopher K. Fairbairn, Johannes Fahrenkrug, and Collin Ruffenach</p><p><em>Apple provides a class called NSXMLParser to iPhone developers. Developers use this class when parsing XML. This article from <a href="http://www.manning.com/fairbairn/">Objective-C Fundamentals</a> shows that NSXMLParser provides delegate methods that handle every point of parsing for both XML- and DTD-based documents.</em></p><p>To save 40% on your next purchase use Promotional Code code40project when you check out at <a href="http://www.manning.com">www.manning.com</a>.</p><p><a href="https://www.codeproject.com/articles/248883/objective-c-fundamentals-nsxmlparser#Related">You may also be interested in…</a></p></td></tr></tbody></table>

Apple provides a class called NSXMLParser to iPhone developers. Developers use this class when parsing XML. Several open source alternatives to NSXMLParser are available and used by many developers, but we are going to look at the delegate methods of the standard Cocoa XML Parser.

There is no <NSXMLParser> protocol; you will receive no warning if you do not declare this in the header of the application you are creating. NSXMLParser is a fringe design class that follows the principles of protocol design but doesn’t explicitly define a protocol. An NSXMLParser object has a parameter called delegate, which needs to be defined. Whatever object is defined as the delegate has the option of implementing a collection of 20 different delegate methods. NSXMLParser provides delegate methods that handle every point of parsing for both XML- and DTD-based documents.

XML is a type of file that can hold data in a very structured manner. As a quick introduction, XML uses the syntax of HTML to create unique data structures. An example of an XML element that describes a person is shown in listing 1.

### Listing 1 An Author in XML

```xml
<Author>
    <name>Collin Ruffenach</name>
    <age>23</age>
    <gender>male</gender>
    <Books>
           <Book>
                  <title>Objective C for the iPhone</title>
                  <year>2010</year>
                  <level>intermediate</level>
              </Book>
    </Books>
</Author>
```

XML is a very common means of getting data from online sources such as Twitter. XML is also used to facilitate the data required to run your specific iPhone project. iPhone development relies heavily on PLISTS. These files are really just XML.

DTD stands for Document Type Definition. This is a document that would describe the structure of the XML that you are going to work with. The document type definition for the XML in version 7.4.3.1 would be:

```
<!ELEMENT Author (name, age, gender, books_list(book*))>
<!ELEMENT name (#PCDATA)>
<!ELEMENT age (#PCDATA)>
<!ELEMENT gender (#PCDATA)>
<!ELEMENT Book (title, year, level)>
<!ELEMENT title (#PCDATA)>
<!ELEMENT year (#PCDATA)>
<!ELEMENT level (#PCDATA)>
```

For some applications, examining the structure of the XML they are receiving will change the manner in which the application parses. In this case, we say that the XML will contain an element called Author. An Author will be defined by a name, age, and gender, which will be simple strings. An author will also have a list of Book elements. A Book is defined by a title year and level that are all simple strings. This ensures that the NSXMLParser knows what to do.

The majority of the time when you parse XML, you will be aware of its structure when writing your parser class. For these instances, you will not need to investigate the XML feeds DTD. An example of this would be the Twitter XML feed for a timeline. We will assume we know the XML structure for our XML and only implement the parsing functions of the NSXMLParser delegate to parse the Author XML we have already looked at.

## Parsing an author with NSXMLParser delegate

The first step when implementing NSXMLParser is to create a class that will contain the parser object and implement its delegate methods. Let’s create a new view-based project called Parser\_Project and create a new NSObject subclass called Parser. The only instance variables we are going to declare for the Parser class is an NSXMLParser and an NSMutableString to help. Make Parser.h look like the following.

```objectivec
#import <Foundation/Foundation.h>
 
@interface Parser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *parser;
    NSMutableString *element;
}
 
@end
```

We are going to need to have an XML file to parse. You can take the XML in listing 2 and place it in a regular text file. Save the file as Sample.xml and add it into the project. This will give us a local XML file that we can reference to parse.

Now we need to fill in Parser.m. Parser.m will contain an initialize and the implementation of the three most common NSXMLParser Delegate methods. Let’s start with the initializer method and add the code shown in listing 2 into XMLParser.m.

### Listing 2 Parser.m Initializer

```objectivec
-init {
   if(self == [super init]) {
          parser = [[NSXMLParser alloc]
initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
pathForResource:@"Sample" ofType: @"xml"]]];
          [parser setDelegate:self];
          [parser parse];
   }      
   return self;
}
```

Here we are going to initialize our NSXMLParser parser using a file URL pointing to our Sample.xml file that we imported into our project earlier. NSURL is a large class with all sorts of initializers. In this case, we are telling it that we will be providing a path to a file URL, or a local resource. With that done, we tell the NSXMLParser that this class will be the delegate of the parser and, finally, we tell the NSXMLParser we are ready to parse by sending the parse exam.

Once the parse method is called on the NSXMLParser, the parser will begin to call its delegate methods. The parser reads down an XML file much like Latin/English characters are read: left to right, top to bottom. While there are many delegate methods, we will be focusing on three of them.

```objectivec
§  - (void)parser:(NSXMLParser
*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString
*)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary
*)attributeDict
```

While this method has a lot of parameters passed into it, it is actually quite simple for our purposes. This method is called when an element is seen starting. This means that any element (between <>) that does not have a /. In this method we will first print the element we see starting and we will clear our NSMutableString element. You will see upon implementing the new methods that we use the element variable as a string that we add to as delegate methods are called. The element variable is meant to hold the value of only one XML element. So, when a new element is started, we make sure to clear it out. Fill out the following, shown in listing 3, for this delegate method.

### Listing 3 NSXMLParser Methods

```objectivec
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary
*)attributeDict {

NSLog(@"Started
Element %@", elementName);
      element = [NSMutableString
string];

}

§  - (void)parser:(NSXMLParser
*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
```

This method is called when an element is seen ending. This means when an element has a / this method will be called. When this method is called out NSMutableString element variable will be complete. We will simply print out the value we have seen (see listing 4).

### Listing 4 NSXMLParser Methods

```objectivec
- (void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName {

      NSLog(@"Found an element named: %@ with a
value of: %@", elementName, element);

}

§  - (void)parser:(NSXMLParser
*)parser foundCharacters:(NSString *)string
```

This method is called when the parser sees anything between an element’s beginning and ending. We will use this entry point as a way to collect all the characters that are between an element; this is done by calling the appendString method on our NSMutableString. By doing this every time, this method is called; by the time the didEndElement method is called, the NSMutablrString will be complete. In this method, we first make sure that we have initialized our NSMutableString element and then we append the string we are provided, shown in listing 5.

### Listing 5 NSXMLParser Methods

```objectivec
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string 

 if(element == nil)

        element = [[NSMutableString
alloc] init];

 [element appendString:string];

}
```

Now all that is left to do is create an instance of our Parser and see it go. Go to Parser\_ProjectAppDelegate.m and add the code shown in listing 6 into the already existing method.

### Listing 6 Initializing the Parser

```objectivec
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWith Options:(NSDictionary *)launchOptions {    

    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

   Parser *parser = [[Parser alloc] init];

   return YES;
}
```

If you run the application and bring up the terminal window (shift + apple + r), the output shown in listing 7 should be generated.

### Listing 7 Parser Output

```objectivec
Parser_Project[57815:207] Started Element Author
Parser_Project[57815:207] Started Element name
Parser_Project[57815:207] Found an element named: name with a
value of: Collin Ruffenach
Parser_Project[57815:207] Started Element age
Parser_Project[57815:207] Found an element named: age with a
value of: 23
Parser_Project[57815:207] Started Element gender
Parser_Project[57815:207] Found an element named: gender with a
value of: male
Parser_Project[57815:207] Started Element Books
Parser_Project[57815:207] Started Element Book
Parser_Project[57815:207] Started Element title
Parser_Project[57815:207] Found an element named: title with a
value of: Objective C for the iPhone
Parser_Project[57815:207] Started Element year
Parser_Project[57815:207] Found an element named: year with a
value of: 2010
Parser_Project[57815:207] Started Element level
Parser_Project[57815:207] Found an element named: level with a
value of: intermediate
Parser_Project[57815:207] Found an element named: Book with a
value of: intermediate
Parser_Project[57815:207] Found an element named: Books with a
value of: intermediate
Parser_Project[57815:207] Found an element named: Author with a
value of: intermediate
```

You can see that using the NSXMLParser delegate methods we successfully parsed all of the information in our XML file. From here, we could create Objective-C objects to represent the XML and use it throughout our application. XML processing is a vital part of most applications that get their content from some kind of web source; Twitter Clients, News Clients, or YouTube.

## Summary

Protocols are all over the place when developing for the iPhone. They are one of the foundation design decisions for the majority of the classes the Apple provides. With attentive coding, the usage of these protocols can make your application efficient and error proof. Through a proper understanding and implementation of the protocol design method, you can ensure a well-designed application.

NSXMLParser is a fringe design class that follows the principles of protocol design but doesn’t explicitly define a protocol. An NSXMLParser object has a parameter called delegate, which needs to be defined. Whatever object is defined as the delegate has the option of implementing a collection of 20 different delegate methods. NSXMLParser provides delegate methods that handle every point of parsing for both XML- and DTD-based documents.

# 

We will parse the highlighted tag data through NSXMLParser

We have declared few properties as follows
```objectivec
@property(nonatomic, strong)NSMutableArray *results;
@property(nonatomic, strong)NSMutableString *parsedString;
@property(nonatomic, strong)NSXMLParser *xmlParser;

//Fetch xml data
NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
NSURLSessionDataTask *task=[session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:YOUR_XMLURL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
self.xmlParser=[[NSXMLParser alloc] initWithData:data];
self.xmlParser.delegate=self;
if([self.xmlParser parse]){
   //If parsing completed successfully
    NSLog(@"%@",self.results);
}
}];
    
[task resume];
```
Then we define the NSXMLParserDelegate
```objectivec
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    if([elementName isEqualToString:@"GeocodeResponse"]){
        self.results=[[NSMutableArray alloc] init];
    }
    
    if([elementName isEqualToString:@"formatted_address"]){
        self.parsedString=[[NSMutableString alloc] init];
    }

}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if(self.parsedString){
        [self.parsedString appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }


}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if([elementName isEqualToString:@"formatted_address"]){
        [self.results addObject:self.parsedString];
        
        self.parsedString=nil;
    }

}
```