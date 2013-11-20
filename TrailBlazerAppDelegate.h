//
//  TrailBlazerAppDelegate.h
//  TrailBlazer
//
//  Created by Dasa Anand on 23/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TrailBlazerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet WebView *webView;
	IBOutlet NSTextField *urlText, *searchText;
	IBOutlet NSTextField *statusMessage;
	IBOutlet NSProgressIndicator *statusIndicator;
	IBOutlet NSButton *back, *forward;
	IBOutlet NSPopUpButton *searchOption;
	IBOutlet NSMatrix *searchMode;
	IBOutlet NSMenuItem *separatorBeforeHistory;
	IBOutlet NSMenuItem *separatorAfterHistory;
	
	WebHistory *myHistory;
	NSString *_source;
	
	int count;
	
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *urlText, *searchText;
@property (assign) IBOutlet NSTextField *statusMessage;
@property (assign) IBOutlet NSProgressIndicator *statusIndicator;
@property (assign) IBOutlet NSMatrix *searchMode;


- (IBAction)navigate:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)homePage:(id)sender;
- (IBAction)history:(id)sender;

-(void)httpRequest;
-(void)searchResult;

@end
