//
//  CreditsViewController.swift
//  BestMovie
//
//  Created by Laure Compoint on 13/02/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBAction func shareDidPressed(_ sender: Any) {
        share()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func share(){
        let activityItems: [Any] = [
            UIImage(named: "logobestmovie")!,
            URL(string: "https://ecole-webstart.com")!,
            "j'ai testé cette application, je vous le conseille !"
        ]
        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    

}
