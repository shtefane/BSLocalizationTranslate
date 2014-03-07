//
//  BSViewController.m
//  LocalizationTranslate
//
//  Created by Balica S on 07/03/2014.
//  Copyright (c) 2014 Balica Stefan. All rights reserved.
//

#import "BSTranslateViewController.h"

@interface BSTranslateViewController ()
{
    
    IBOutlet UIActivityIndicatorView *activity;
}

@property (nonatomic, strong) NSDictionary *wordsEnglish;

@end

@implementation BSTranslateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Load english Words from .strings file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                     ofType:@"strings"
                                                inDirectory:nil
                                            forLocalization:@"en"];
    // compiled .strings file becomes a "binary property list"
    _wordsEnglish = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"Localization %@", _wordsEnglish);
    
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"Language %@", [_languageInfo objectForKey:@"language"]);
    
    [self translateWords];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) translateWords
{
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
     
        __block NSString *languageAndGlossaryDictionary = @"";
        [_wordsEnglish enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {   //NSLog(@"%@", key);
              NSString *translate = [self translate:obj];
             languageAndGlossaryDictionary = [languageAndGlossaryDictionary stringByAppendingFormat:@"\n\"%@\" = \"%@\";", key, translate];
             
           
         }];

        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [activity stopAnimating];
             NSLog(@"localization %@ %@",[_languageInfo objectForKey:@"language"], languageAndGlossaryDictionary);
            
            //Save to file ... not work yet
            /*
            NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath=[docs stringByAppendingPathComponent:@"Localizable.strings"];
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            NSError *error = nil;
            [languageAndGlossaryDictionary writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:&error];
            if (error) {
                NSLog(@"error create file %@", error);
            }
            */
           });
    });
    
    
}

- (NSString*) translate: (NSString*) word
{
    
    NSString *langCode = [[[_languageInfo objectForKey:@"code"] componentsSeparatedByString:@"-"] firstObject];
    NSString *baseURLStr = [NSString stringWithFormat:@"http://mymemory.translated.net/api/get?q=%@&langpair=en|%@&de=%@", word, langCode, @"bsp13cmd@gmail.com"];
    
    NSURL *reqUrl = [NSURL URLWithString:[baseURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"URL %@", reqUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:reqUrl];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error ) {
        NSLog(@"error %@",error);
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
   // NSLog(@"JSON %@", json);
   
    NSArray *matches = [json objectForKey:@"matches"];
    for (NSDictionary *match in matches)
    {
        if (![[match objectForKey:@"translation"] isEqualToString:@""]) {
            
            return [match objectForKey:@"translation"];
        }
    }
    
    //
    return @"";
}



@end
