//
//  TrailBlazerAppDelegate.m
//  TrailBlazer
//
//  Created by Dasa Anand on 23/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrailBlazerAppDelegate.h"

@implementation TrailBlazerAppDelegate

@synthesize window, webView, urlText, statusMessage, statusIndicator, searchText, searchMode;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

-(id)init
{
	
	[webView setEditable:YES];
	[statusIndicator setHidden:YES];
	return self;
}


/***** Event on GO button *****/
-(IBAction)navigate:(id)sender
{
	[self httpRequest];
	
}


/***** First responder for the text box editting done *****/
-(void)controlTextDidEndEditing:(NSNotification *)obj
{
	NSTextField *text = [obj object];
	
	if (text == urlText)
	{
		[self httpRequest];
	}
	else
	{
		if (text == searchText)
		{
			[self searchResult];
		}
	}

}


/***** Load the url into the webView *****/
-(void)httpRequest
{
	NSString *urlString = [urlText stringValue];
	NSString *protocol = @"http://";
	NSRange match;
	match = [urlString rangeOfString:protocol];
	count = 0;
	
	if (match.location == NSNotFound)
	{
		NSString *temp = [protocol stringByAppendingString:urlString];
		urlString = temp;
	}
	
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
	[urlText setStringValue:urlString];
	[webView setFrameLoadDelegate:self];
	
	WebHistoryItem *ch= [[WebHistoryItem alloc] initWithURLString:[urlText stringValue] title:[urlText stringValue] lastVisitedTimeInterval:320];
	NSArray *array = [[NSArray alloc] initWithObjects:ch,nil];
	[myHistory addItems:array];
	
}


/***** To load the title of the window based on the url *****/
-(void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame 
{
	if (frame == [sender mainFrame])
	{
		[[sender window] setTitle:title];
	}
}	
					 
						 

/***** Error on loading the resources *****/
-(void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame])
	{
		[statusMessage setStringValue:@"Error"];
	}
}


/***** Loading the data resources *****/
-(void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame])
	{
		count++;
		[statusMessage setStringValue:@"Loading......."];
		NSString *url = [[[[frame provisionalDataSource] request] URL] absoluteString];
		[urlText setStringValue:url];
		[statusIndicator setHidden:NO];
		[statusIndicator startAnimation:self];
	}
}



/***** Tracing whether the request has received a successful response *****/
-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame])
	{
		count--;
		if (count == 0)
		{
			[statusMessage setStringValue:@"All resources are loaded successfully"];
			[statusIndicator stopAnimation:self];
			[statusIndicator setHidden:YES];
		}
		
		[back setEnabled:[sender canGoBack]];
		[forward setEnabled:[sender canGoForward]];
	}
}


-(BOOL)windowShouldClose:(id)sender
{
	[sender setBackgroundColor:[NSColor lightGrayColor]]; 
	return NO;
}



-(IBAction)clearAll:(id)sender
{
	[[WebHistory optionalSharedHistory] removeAllItems];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(historyDidRemoveAllItems:)name:WebHistoryAllItemsRemovedNotification object:myHistory];
}


-(IBAction)homePage:(id)sender
{
	NSString *home = @"http://www.apple.com";
	[urlText setStringValue:home];	
	[self httpRequest];
}



- (NSData *)dataOfType: (NSString*)typeName error: (NSError**)outError
{
	NSString *doc = [(id)[[[webView mainFrame] DOMDocument] documentElement] outerHTML];
	return [doc dataUsingEncoding: NSUTF8StringEncoding];
}


- (BOOL)readFromData: (NSData*)data ofType: (NSString*)typeName error: (NSError**)outError
{
	NSString *loadedDoc = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	[[webView mainFrame] loadHTMLString: loadedDoc baseURL: nil];
    return YES;
}



/***** Quick Search *****/
-(void)searchResult
{
	NSArray *list = [[searchText stringValue] componentsSeparatedByString:@" "];

	if ([[searchOption titleOfSelectedItem] isEqualToString:@"Google"])
	{
		NSString *data = [list componentsJoinedByString:@"+"];
		NSString *query = @"http://www.google.com/search?hl=en&q=";
		
		if ([searchMode selectedTag] == 1)
		{
			query = [query stringByReplacingOccurrencesOfString:@"search" withString:@"images"];
			query = [query stringByAppendingString:data];
			query = [query stringByAppendingFormat:@"&biw=1280&bih=680"];
		}
		else
		{
			query = [query stringByAppendingString:data];
		}
		[urlText setStringValue:query];
	}
	else
	{
		if ([[searchOption titleOfSelectedItem] isEqualToString:@"Wikipedia"])
		{
			NSString *data = [list componentsJoinedByString:@"_"];
			NSString *query = @"http://en.wikipedia.org/wiki/";
			query = [query stringByAppendingString:data];
			[urlText setStringValue:query];
		}
		else
		{
			NSString *data = [list componentsJoinedByString:@"+"];
			NSString *query =@"";

			if ([searchMode selectedTag] == 1)
			{
				query = [query stringByAppendingFormat:@"http://in.images.search.yahoo.com/search/images?vc=&p="];
			}
			else
			{
				query = [query stringByAppendingFormat:@"http://in.search.yahoo.com/search;_ylt=AncHMDmo9UdN0o21j7A7iAiuitIF?vc=&p="];
			}
			query = [query stringByAppendingString:data];
			query = [query stringByAppendingFormat:@"&toggle=1&cop=mss&ei=UTF-8&fr=yfp-t-704"];
			[urlText setStringValue:query];
		}
	}

	[self httpRequest];
}



- (IBAction)history:(id)sender
{
	
	
}





- (NSString *) plistPath:(NSString *) database
{
	return [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:database];
}



@end
