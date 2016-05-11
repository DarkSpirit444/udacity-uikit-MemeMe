//
//  CustomMemeCell.swift
//  Meme Me
//
//  Created by David Teo on 5/6/16.
//  Copyright © 2016 Compete Co-op Networks. All rights reserved.
//

import UIKit

class CustomMemeCell: UICollectionViewCell {
    
    @IBOutlet weak var top : UITextField!
    @IBOutlet weak var bottom : UITextField!

    //@IBOutlet weak var schemeLabel: UILabel!
    func setText(topString: String, bottomString: String)
    {
        self.top.text = topString
        self.bottom.text = bottomString
    }
}
