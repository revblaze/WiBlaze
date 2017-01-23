//
//  SourceViewController.swift
//  WiBlaze
//
//  Created by Justin Bush on 2017-01-23.
//  Copyright © 2017 Justin Bush. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var sourceCode: UITextView!
    weak var delegate: ViewController?
    var code: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        sourceCode.text = code
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
