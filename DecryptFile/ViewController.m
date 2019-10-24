//
//  ViewController.m
//  DecryptFile
//
//  Created by Michael Powell on 7/1/19.
//  Copyright © 2019 Michael Powell. All rights reserved.
//

#import "ViewController.h"
#include <dlfcn.h>

@implementation ViewController
@synthesize decryptTime;
@synthesize encryptionKey;
@synthesize fileTextField;
@synthesize selectButton;
@synthesize decryptButton;
@synthesize outputText;
//
// key: 8571a448cf9a6ef062336293fb6dad4c8d4a89224354bcdf048c335b08a9e03c
//
const char keyBytes[] = "\x85\x71\xa4\x48\xcf\x9a\x6e\xf0\x62\x33\x62\x93\xfb\x6d\xad\x4c\x8d\x4a\x89\x22\x43\x54\xbc\xdf\x04\x8c\x33\x5b\x08\xa9\xe0\x3c";
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
    ourRect = self.outputText.frame;
    ourRect.origin.x = 20;
    ourRect.origin.y = 500;
    ourRect.size.height = 500;
    ourRect.size.width = 500;
//    self.outputText.frame = ourRect;
    self.encryptionKey = [NSData dataWithBytes:keyBytes length:32];
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
    NSError *ourError = nil;
    NSString *secondsDecrypting = @"seconds decrypting";
    NSString *outputString = nil;
    if (ourFilePath) {
        NSURL *ourFileURL = [NSURL fileURLWithPath:ourFilePath];
        if (ourFileURL) {
            NSLog(@"have ourFileURL");
            NSString *ourFileContents = [NSString stringWithContentsOfURL:ourFileURL encoding:NSUTF8StringEncoding error:nil];
            if (ourFileContents) {
                NSLog(@"got ourFileContents");
                NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:ourFileContents options:0];
                if (encryptedData) {
                    NSLog(@"got encyptedData");
                    unsigned long encryptedDataLength = [encryptedData length];
                    NSDate  *timeBefore = [NSDate date];
                    NSData *decryptedData = nil;
                    unsigned char *charEncryptedData = (unsigned char *)[encryptedData bytes];
                    unsigned char * decryptedCharData;
                    unsigned long   decryptedLength;
                    decryptedCharData = malloc(2*encryptedDataLength);
                    void    *handle = dlopen("/usr/local/include/libdylibforlabview.dylib",RTLD_LOCAL|RTLD_LAZY);
                    if (!handle) {
                        decryptedLength = 0;
                        NSLog(@"cannot get handle");
                    }
                    else    {
                        uint64_t    (*decryptBytes)(uint8_t *, uint64_t, uint8_t *) = dlsym(handle, "decryptData");
                        decryptedLength = (*decryptBytes) (charEncryptedData, encryptedDataLength, decryptedCharData);
                    }
                    if (decryptedLength > 0) {
                        decryptedData = [NSData dataWithBytes:decryptedCharData length:decryptedLength ];
                    }   //  no error
                    else    {
                        ourError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:1 userInfo:nil];
                    }
                    free(decryptedCharData);
                    if (ourError) {
                        NSLog(@"error decrypting data: %@",[ourError description]);
                    }
                    if (decryptedData) {
                        NSLog(@"got decryptedData");
                        NSDate  *timeAfter = [NSDate date];
                        NSTimeInterval timeDecrypting = [timeAfter timeIntervalSinceDate:timeBefore];
                        NSString  *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSASCIIStringEncoding];
                        if (decryptedString && ([decryptedString length] > 0)) {
                            NSLog(@"have decryptedString");
                            NSDate  *timeAfter = [NSDate date];
                            NSTimeInterval timeDecrypting = [timeAfter timeIntervalSinceDate:timeBefore];
                            secondsDecrypting = [[NSString alloc] initWithFormat:@"seconds decrypting: %fd",timeDecrypting ];
                            NSLog(secondsDecrypting);
                            outputString = decryptedString;
                        }   //  have decryptedString
                        else    {
                            if (!decryptedString) {
                                NSLog(@"decryptedString is empty");
                            }
                            else    {
                                NSLog(@"decryptedString is nil");
                            }
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
    [self.outputText setString:outputString];
    //[self.decryptTime setString:secondsDecrypting];
}   //  decryptButtonPressed
@end
