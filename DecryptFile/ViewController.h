//
//  ViewController.h
//  DecryptFile
//
//  Created by Michael Powell on 7/1/19.
//  Copyright © 2019 Michael Powell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RNCryptor.h"
#import "RNDecryptor.h"

@interface ViewController : NSViewController
@property   IBOutlet    NSTextField *fileTextField;
@property   IBOutlet    NSTextField *passwordTextField;
@property   IBOutlet   NSButton    *selectButton;
@property   IBOutlet    NSButton    *decryptButton;
@property   IBOutlet    NSTextField    *outputText;
-(IBAction)selectButtonPressed:(id)sender;
-(IBAction)decryptButtonPressed:(id)sender;
@end

