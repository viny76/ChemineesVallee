//
//  ContactViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "ContactViewController.h"
#import "UIColor+CustomColors.h"

@interface ContactViewController ()
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    int zoom = 0;
    self.marker = [[GMSMarker alloc] init];
    [self displayShowroom:zoom];
}

- (IBAction)phoneButton:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0235983750"]];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0235043644"]];
    } else if (self.segmentControl.selectedSegmentIndex == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0235043644"]];
    }
}

- (IBAction)sendEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Contact par l'App Cheminées VALLÉE"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"info@chemineesvallee.com", nil];
        [mailer setToRecipients:toRecipients];
        UIImage *myImage = [UIImage imageNamed:@"logo"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"logo"];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                        message:@"L'envoi d'email n'est pas supporté par l'appareil"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
}

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    int zoom = 0;
    
    if (selectedSegment == 0) {
        [self displayShowroom:zoom];
    } else if (selectedSegment == 1) {
        [self displaySiege:zoom];
    } else if (selectedSegment == 2) {
        [self displayMagasin:zoom];
    }
}

- (void)displayShowroom:(int)zoom {
    NSString *text = @"Le Showroom.\n17 Rue de la République,\n76000 Rouen";
    NSString *phoneText = @"02 35 98 37 50";
    // If attributed text is supported (iOS6+)
    if ([self.addressLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        // iOS6 and above : Use NSAttributedStrings
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            zoom = 16;
            const CGFloat fontSize = 30;
            NSDictionary *attrs = @{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                    NSForegroundColorAttributeName:[UIColor colorWhite]
                                    };
            NSDictionary *subAttrs = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                       };
            const NSRange range = NSMakeRange(0,12);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            NSMutableAttributedString *attributedPhoneText =
            [[NSMutableAttributedString alloc] initWithString:phoneText
                                                   attributes:attrs];
            [self.addressLabel setAttributedText:attributedText];
            [self.phoneButton setAttributedTitle:attributedPhoneText forState:UIControlStateNormal];
            
        } else {
            const CGFloat fontSize = 15;
            zoom = 15;
            NSDictionary *attrs = @{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                    NSForegroundColorAttributeName:[UIColor colorWhite]
                                    };
            NSDictionary *subAttrs = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                       };
            const NSRange range = NSMakeRange(0,12);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            NSMutableAttributedString *attributedPhoneText =
            [[NSMutableAttributedString alloc] initWithString:phoneText
                                                   attributes:attrs];
            [self.addressLabel setAttributedText:attributedText];
            [self.phoneButton setAttributedTitle:attributedPhoneText forState:UIControlStateNormal];
        }
    }
    // If attributed text is NOT supported (iOS5-)
    else {
        self.addressLabel.text = text;
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.438561
                                                            longitude:1.096386
                                                                 zoom:zoom];
    [self.mapView animateToCameraPosition:camera];
    
    // Creates a marker in the center of the map.
    self.marker.position = CLLocationCoordinate2DMake(49.438561, 1.096386);
    self.marker.title = @"Le Showroom";
    self.marker.snippet = @"Rouen";
    self.marker.map = self.mapView;
}

- (void)displaySiege:(int)zoom {
    NSString *text = @"Le Siège.\n20 Rue de la Libération,\n76720 Auffay";
    NSString *phoneText = @"02 35 04 36 44";
    // If attributed text is supported (iOS6+)
    if ([self.addressLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        // iOS6 and above : Use NSAttributedStrings
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            zoom = 15;
            const CGFloat fontSize = 30;
            NSDictionary *attrs = @{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                    NSForegroundColorAttributeName:[UIColor colorWhite]
                                    };
            NSDictionary *subAttrs = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                       };
            const NSRange range = NSMakeRange(0,9);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            [attributedText setAttributes:attrs range:range];
            NSMutableAttributedString *attributedPhoneText =
            [[NSMutableAttributedString alloc] initWithString:phoneText
                                                   attributes:attrs];
            [self.addressLabel setAttributedText:attributedText];
            [self.phoneButton setAttributedTitle:attributedPhoneText forState:UIControlStateNormal];
            
        } else {
            const CGFloat fontSize = 15;
            zoom = 14;
            NSDictionary *attrs = @{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                    NSForegroundColorAttributeName:[UIColor colorWhite]
                                    };
            NSDictionary *subAttrs = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                       };
            const NSRange range = NSMakeRange(0,9);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            [attributedText setAttributes:attrs range:range];
            NSMutableAttributedString *attributedPhoneText =
            [[NSMutableAttributedString alloc] initWithString:phoneText
                                                   attributes:attrs];
            [self.addressLabel setAttributedText:attributedText];
            [self.phoneButton setAttributedTitle:attributedPhoneText forState:UIControlStateNormal];
        }
    }
    // If attributed text is NOT supported (iOS5-)
    else {
        self.addressLabel.text = text;
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.7132796
                                                            longitude:1.0978198
                                                                 zoom:zoom];
    [self.mapView animateToCameraPosition:camera];
    
    // Creates a marker in the center of the map.
    self.marker.position = CLLocationCoordinate2DMake(49.7132796, 1.0978198);
    self.marker.title = @"Le Siège";
    self.marker.snippet = @"Auffay";
    self.marker.map = self.mapView;
}

- (void)displayMagasin:(int)zoom {
    NSString *text = @"Le Magasin.\n48 Rue Robert Lefranc,\n76510 Saint-Nicolas-d'Aliermont";
    NSString *phoneText = @"02 35 04 36 44";
    // If attributed text is supported (iOS6+)
    if ([self.addressLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        // iOS6 and above : Use NSAttributedStrings
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            zoom = 15;
            const CGFloat fontSize = 30;
            NSDictionary *attrs = @{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                    NSForegroundColorAttributeName:[UIColor colorWhite]
                                    };
            NSDictionary *subAttrs = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                       };
            const NSRange range = NSMakeRange(0,11);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            
            NSMutableAttributedString *attributedPhoneText =
            [[NSMutableAttributedString alloc] initWithString:phoneText
                                                   attributes:attrs];
            [self.addressLabel setAttributedText:attributedText];
            [self.phoneButton setAttributedTitle:attributedPhoneText forState:UIControlStateNormal];
            
        } else {
            const CGFloat fontSize = 15;
            zoom = 14;
            NSDictionary *attrs = @{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                    NSForegroundColorAttributeName:[UIColor colorWhite]
                                    };
            NSDictionary *subAttrs = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                       };
            const NSRange range = NSMakeRange(0,11);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            NSMutableAttributedString *attributedPhoneText =
            [[NSMutableAttributedString alloc] initWithString:phoneText
                                                   attributes:attrs];
            [self.addressLabel setAttributedText:attributedText];
            [self.phoneButton setAttributedTitle:attributedPhoneText forState:UIControlStateNormal];
        }
    }
    // If attributed text is NOT supported (iOS5-)
    else {
        self.addressLabel.text = text;
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.8785822
                                                            longitude:1.2224575
                                                                 zoom:zoom];
    [self.mapView animateToCameraPosition:camera];
    
    // Creates a marker in the center of the map.
    self.marker.position = CLLocationCoordinate2DMake(49.8785822, 1.2224575);
    self.marker.title = @"Le Magasin";
    self.marker.snippet = @"Saint-Nicolas-d'Aliermont";
    self.marker.map = self.mapView;
}

@end
