//
//  PosterView.swift
//  BestMovie
//
//  Created by Laure Compoint on 23/01/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit

class PosterView: UIView {

    @IBOutlet private var imageView: UIImageView!
    
    enum Style{
        case liked, unliked, neutral
    }
    var style: Style = .neutral{
        didSet{
            switch style {
            case .liked:backgroundColor = UIColor.bmGreen
             case .unliked:backgroundColor = UIColor.bmRed
              case .neutral:backgroundColor = UIColor.bmWhite
                
            
        }
    }
}
    var poster = Data(){
        didSet{
            imageView.image = UIImage(data: poster)
        }
    }
}
