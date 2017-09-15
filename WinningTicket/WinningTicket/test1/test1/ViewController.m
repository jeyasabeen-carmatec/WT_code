//
//  ViewController.m
//  test1
//
//  Created by Test User on 23/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

     - (IBAction)referesh:(id)sender {
         NSArray *array = [array valueForKey:@"title"];;
         NSURL *url = [NSURL URLWithString:@"http://www.androidbegin.com/tutorial/jsonparsetutorial.txt"];
         NSURLRequest *request = [NSURLRequest requestWithURL:url];
         [NSURLConnection sendAsynchronousRequest:request
                                            queue:[NSOperationQueue mainQueue]
                                completionHandler:^(NSURLResponse *response,
                                                    NSData *data, NSError *connectionError)
          {
              if (data.length > 0 && connectionError == nil)
              {
                  NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0
                                                                             error:NULL];
                  
                  
                  NSMutableArray *getdata=[[NSMutableArray alloc]init];
                  getdata=[greeting objectForKey:@"worldpopulation"];
                  
                  NSString *value=[getdata valueForKey:@"rank"];
                  NSLog(@"%@",value);
                  
                  self.rank.text = [[getdata valueForKey:@"rank"] stringValue];
                  
                  self.country.text = [getdata valueForKey:@"country"];
                  self.population.text =[getdata valueForKey:@"population"];
                  self.imageview.image = [UIImage imageNamed:[getdata valueForKey:@"flag"]];
     }
          }
          ]; }
          
              @end

