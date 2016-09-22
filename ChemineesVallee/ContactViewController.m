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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:49.438561
                                                            longitude:1.096386
                                                                 zoom:16];
    [self.mapView animateToCameraPosition:camera];
    //    self.mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(49.438561, 1.096386);
    marker.title = @"Cheminées Vallée";
    marker.snippet = @"Rouen";
    marker.map = self.mapView;
    
    // Make Bold first line.
    NSString *text = @"Cheminées VALLÉE.\n17 Rue de la République,\n76000 Rouen";
    if ([self.addressLabel respondsToSelector:@selector(setAttributedText:)]) {
        // iOS6 and above : Use NSAttributedStrings
        const CGFloat fontSize = 15;
        NSDictionary *attrs = @{
                                NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize],
                                NSForegroundColorAttributeName:[UIColor colorWhite]
                                };
        NSDictionary *subAttrs = @{
                                   NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize]
                                   };
        const NSRange range = NSMakeRange(0,17);
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:subAttrs];
        [attributedText setAttributes:attrs range:range];
        [self.addressLabel setAttributedText:attributedText];
    } else {
        // iOS5 and below
        [self.addressLabel setText:text];
    }
}

- (IBAction)phoneButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0235983750"]];
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


@end
