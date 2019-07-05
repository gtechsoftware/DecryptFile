//
//  ViewController.m
//  DecryptFile
//
//  Created by Michael Powell on 7/1/19.
//  Copyright © 2019 Michael Powell. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize fileTextField;
@synthesize passwordTextField;
@synthesize selectButton;
@synthesize decryptButton;
@synthesize outputText;
//
- (void)viewDidLoad {
    [super viewDidLoad];
    NSRect ourRect;
    ourRect = self.selectButton.frame;
    ourRect.size.width = 200;
//    self.selectButton.frame = ourRect;
    self.selectButton.title = @"Select File";
    ourRect = self.decryptButton.frame;
    ourRect.size.width = 200;
//    self.decryptButton.frame = ourRect;
    self.decryptButton.title = @"Decrypt File";
    ourRect = self.passwordTextField.frame;
    ourRect.size.width = 200;
//    self.passwordTextField.frame = ourRect;
    ourRect.origin.x = 20;
    ourRect.origin.y = 500;
    ourRect.size.height = 500;
    ourRect.size.width = 500;
//    self.outputText.frame = ourRect;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(IBAction)selectButtonPressed:(id)sender {

    NSLog(@"selectButtonPressed");
    NSOpenPanel *ourPanel = [NSOpenPanel openPanel];
    ourPanel.title = @"Choose a file";
    ourPanel.showsResizeIndicator = YES;
    ourPanel.allowedFileTypes = @[@"xml"];
    ourPanel.canChooseFiles = YES;
    
    NSURL   *ourURL;
    NSString  *ourPath;
    
    if ([ourPanel runModal] == NSModalResponseOK) {
        ourURL = ourPanel.URL;
        if (ourURL != nil) {
            ourPath = ourURL.path;
            [self.fileTextField setStringValue:ourPath];
        }   //  non nil URL
    }   //  responseOK
}   //  selectButtonPressed

-(IBAction)  decryptButtonPressed:(id)sender {
    
    NSLog(@"decryptButtonPressed");
    NSString *ourFilePath = [self.fileTextField stringValue];
    NSString *ourPassWord = [self.passwordTextField stringValue];
    NSError *ourError = nil;
    NSString *outputString = nil;
    if (ourFilePath) {
        NSURL *ourFileURL = [NSURL fileURLWithPath:ourFilePath];
        if (ourFileURL) {
            NSLog(@"have ourFileURL");
            NSString *ourFileContents = [NSString stringWithContentsOfURL:ourFileURL encoding:NSUTF8StringEncoding error:nil];
            if (ourFileContents) {
                NSLog(@"got ourFileContents");
                //NSLog(ourFileContents);
                NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:ourFileContents options:0];
                if (encryptedData) {
                    NSLog(@"got encyptedData");
                    //NSLog(encryptedData.description);
                    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withPassword:ourPassWord error:&ourError];
                    if (decryptedData) {
                        NSLog(@"got decryptedData");
                        //NSLog(decryptedData.description);
                        NSString  *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
                        if (decryptedString && [decryptedString length] > 0) {
                            NSLog(@"have decryptedString");
                            outputString = decryptedString;
                        }   //  have decryptedString
                        else    {
                            NSLog(@"decryptedString is nil or empty");
                            outputString = @"decryptedString is nil or empty";
                        }   //  have decryptedString
                    }   //  got decryptedData
                    else    {
                        NSLog(@"could not get decryptedData");
                        outputString = @"could not get decryptedData";
                    }   //  could not get decryptedData
                }   //  got encryptedData
                else    {
                    NSLog(@"could not get encryptedData");
                    outputString = @"could not get encryptedData";
                }   //  could not get encryptedData
            }   //  got ourFileContents
            else    {
                NSLog(@"could not get ourFileContents");
                outputString = @"could not get ourFileContents";
            }   //  couldn't get ourFileContents
        }   //  we have a url
        else    {
            NSLog(@"no URL");
            outputString = @"no URL";
        }   //  no URL
    }   //  we have a filePath
    else    {
        NSLog(@"no filePath");
        outputString = @"no filePath";
    }   //  we have no filePath
    [self.outputText setStringValue:outputString];
}   //  decryptButtonPressed
@end
