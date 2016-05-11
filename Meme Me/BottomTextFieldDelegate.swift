//
//  BottomTextFieldDelegate.swift
//  Meme Me
//
//  Created by David Teo on 5/9/16.
//  Copyright © 2016 Compete Co-op Networks. All rights reserved.
//

import Foundation
import UIKit

class BottomTextFieldDelegate : NSObject, UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
}
