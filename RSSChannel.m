//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Alan Sparrow on 12/31/13.
//  Copyright (c) 2013 Alan Sparrow. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize items, title, infoString, parentParserDelegate;

- (id)init
{
    self = [super init];
    
    if (self) {
        // Create the container for the RSSItems this channel has;
        // we'll create the RSSItem class shortly.
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"]) {
        // Create new address
        currentString = [[NSMutableString alloc] init];
        // Assign title to point to that address
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"description"]) {
        // Create new address
        currentString =[[NSMutableString alloc] init];
        // Assign infoString to point to that address
        [self setInfoString:currentString];
    } else if ([elementName isEqual:@"item"]) {
        // When we find an item, create an instance of RSSItem
        RSSItem *entry = [[RSSItem alloc] init];
        
        // Set up its parent as ourselves so we can regain control
        // of the parser
        [entry setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:entry];
        
        // Add the item to our array and release our hold on it
        [items addObject:entry];
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    // If we were in an element that we were collecting the string for,
    // this appropriately releases our hold on it and the permanent
    // ivar keeps ownership of it. If we weren't parsing such an element,
    // currentString is nil already
    currentString = nil;
    
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    if ([elementName isEqual:@"channel"]) {
        [parser setDelegate:parentParserDelegate];
        [self trimItemTitles];
    }
}

- (void)trimItemTitles
{
    // Create a regular expression with the pattern: Author
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"(.*) :: (.*) :: .*"
                                                                    options:0
                                                                      error:nil];
    
    // Loop through every title of the items in channel
    for (RSSItem *i in items) {
        NSString *itemTitle = [i title];
        
        // Find matches in the title string. The range
        // argument specifies how much of the title to search;
        // in this case, all of it
        NSArray *matches = [reg matchesInString:itemTitle
                                        options:0 range:NSMakeRange(0, [itemTitle length])];
        
        // If there was a match...
        if ([matches count] > 0) {
            // Print the location of the match in the string
            // and the string
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            NSLog(@"{%d %d}", [[matches objectAtIndex:0] rangeAtIndex:0].location,
                  [[matches objectAtIndex:0] rangeAtIndex:0].length);
            
            NSLog(@"Num of range: %d", [result numberOfRanges]);
            
            
            // One capture group, so two ranges, let's verify
            if ([result numberOfRanges] > 1) {
                // Pull out the 2nd range, which will be the capture group
                NSRange r = [result rangeAtIndex:2];
                NSLog(@"{%d %d}", r.location, r.length);
                NSString *trimmedTitle = [itemTitle substringWithRange:r];
                NSLog(@"trimmed %@", trimmedTitle);
                
                // Fix the Re:
                NSRegularExpression *reg1 = [[NSRegularExpression alloc] initWithPattern:@"(Re: )*(.*)"
                                                           options:0
                                                             error:nil];
                matches = [reg1 matchesInString:trimmedTitle
                                       options:0
                                         range:NSMakeRange(0, [trimmedTitle length])];
                // If there was a match...
                if ([matches count] > 0) {
                    result = [matches objectAtIndex:0];
                    if ([result numberOfRanges] > 1) {
                        r = [result rangeAtIndex:2];
                        [i setTitle:[trimmedTitle substringWithRange:r]];
                    }
                }
                
                // Set the title of the item to the string within the capture group
                    //[i setTitle:[itemTitle substringWithRange:r]];
            }
            
        }
    }
}

- (void)setupThreads
{
    
}

@end
