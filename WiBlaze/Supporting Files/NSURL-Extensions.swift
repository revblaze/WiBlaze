//
//  NSURL-Extensions.swift
//  NSURL-Validation-Demo
//
//  Created by James Hickman on 11/18/14.
//  Copyright (c) 2014 NitWit Studios. All rights reserved.
//

import Foundation
import UIKit

extension NSURL {
    
    struct ValidationQueue {
        static var queue = NSOperationQueue()
    }
    
    class func validateUrl(urlString: String?, completion:(success: Bool, urlString: String? , error: NSString) -> Void) {
        // Description: This function will validate the format of a URL, re-format if necessary, then attempt to make a header request to verify the URL actually exists and responds.
        // Return Value: This function has no return value but uses a closure to send the response to the caller.
        
        var formattedUrlString: String?
        
        // Ignore Nils & Empty Strings
        if (urlString == nil || urlString == "") {
            completion(success: false, urlString: nil, error: "URL String was empty")
            print("String is empty")
            return
        }
        
        // Ignore prefixes (including partials)
        let prefixes = ["http://www.", "https://www.", "www."]
        for prefix in prefixes {
            if ((prefix.rangeOfString(urlString!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)) != nil){
                completion(success: false, urlString: nil, error: "URL String was prefix only")
                print("Only prefix used")
                return
            }
        }
        
        // Ignore URLs with spaces (NOTE - You should use the below method in the caller to remove spaces before attempting to validate a URL)
        // Example:
        // textField.text = textField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        /*
        formattedUrlString = urlString
        let range = urlString!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
        if let test = range {
            formattedUrlString = "http://google.com/#q="+urlString!
            formattedUrlString = urlString
            completion(success: true, urlString: formattedUrlStringy, error: "Url String cannot contain whitespaces")
            
            //let request = NSURL(string: formattedUrlString!)
            //let url = request.URL!.formattedUrlString!
            return
        }
        */
        /*
        if (urlString!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet()) != nil) {
            formattedUrlString = "http://google.com/#q="+urlString!
            let urlString = formattedUrlString!
            completion(success: true, urlString: urlString, error: "Search term detected")
            return
        }
*/
        
        // Check that URL already contains required 'http://' or 'https://', prepend if it does not
        formattedUrlString = urlString
        if (!formattedUrlString!.hasPrefix("http://") && !formattedUrlString!.hasPrefix("https://")) {
            formattedUrlString = "http://"+urlString!
        }
        
        // Check that an NSURL can actually be created with the formatted string
        if let validatedUrl = NSURL(string: formattedUrlString!) {
            // Test that URL actually exists by sending a URL request that returns only the header response
            let request = NSMutableURLRequest(URL: validatedUrl)
            request.HTTPMethod = "HEAD"
            ValidationQueue.queue.cancelAllOperations()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: ValidationQueue.queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                let url = request.URL!.absoluteString
                
                // URL failed - No Response
                if (error != nil) {
                    // NOTE: Does not take in to account URL redirects (https://goo.gl/rt08xg)
                    completion(success: true, urlString: url, error: "The url: \(url) received no response")
                    print("URL received no response")
                    print(url)
                    return
                }
                
                // URL Responded - Check Status Code
                if let urlResponse = response as? NSHTTPURLResponse {
                    if ((urlResponse.statusCode >= 200 && urlResponse.statusCode < 400) || urlResponse.statusCode == 405) {
                        // 200-399 = Valid Responses, 405 = Valid Response (Weird Response on some valid URLs)
                        completion(success: true, urlString: url, error: "The url: \(url) is valid!")
                        print("URL is valid")
                        return
                    }
                        
                    else {
                        // Error
                        completion(success: false, urlString: url, error: "The url: \(url) received a \(urlResponse.statusCode) response")
                        print("URL returned error")
                        return
                    }
                }
            })
        }
    }
}
