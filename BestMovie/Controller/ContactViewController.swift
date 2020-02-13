//
//  ContactViewController.swift
//  BestMovie
//
//  Created by Laure Compoint on 13/02/2020.
//  Copyright © 2020 Laure Compoint. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController {

    @IBAction func launchEmailClient(_ sender: Any) {
        sendEmail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ContactViewController: MFMailComposeViewControllerDelegate{
    func sendEmail(){
        guard MFMailComposeViewController.canSendMail() else{
            //afficher une alerte
            return print("erreur envoi e-mail")
        }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["compointlaure@gmail.com"])
        mail.setMessageBody("<p>Vous etes formidable </p>", isHTML: true)
        mail.setSubject("Demande d'information")
        
        present(mail, animated: true)
        print("E-Mail envoyé")
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
