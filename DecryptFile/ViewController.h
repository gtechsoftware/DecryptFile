//
//  ViewController.h
//  DecryptFile
//
//  Created by Michael Powell on 7/1/19.
//  Copyright © 2019 Michael Powell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property   NSData  *encryptionKey;
@property   IBOutlet    NSTextField *fileTextField;
@property   IBOutlet    NSTextView *decryptTime;
@property   IBOutlet   NSButton    *selectButton;
@property   IBOutlet    NSButton    *decryptButton;
@property   IBOutlet    NSTextView    *outputText;
-(IBAction)selectButtonPressed:(id)sender;
-(IBAction)decryptButtonPressed:(id)sender;
@end

