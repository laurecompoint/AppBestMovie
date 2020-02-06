//
//  ViewController.swift
//  BestMovie
//
//  Created by Laure Compoint on 28/11/2019.
//  Copyright © 2019 Laure Compoint. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var posterView: PosterView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBAction func dragPosterView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began, .changed:
             transformPosterViewWith(gesture: sender)
            case .ended, .cancelled:
                 setUserChoiceFrom(gesture: sender)
                default:
                break
            }
        
    }
    
    var choice = Choice()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterView.layer.cornerRadius = 10
        
        posterView.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(discoverMoviesLoaded), name: Notification.Name.discoverMoviesLoaded, object: nil)
       choice.start()
       
    }
    @objc func discoverMoviesLoaded(){
        posterView.poster = choice.currentMovie.poster
        movieTitleLabel.text = choice.currentMovie.title
    }
    
    private func transformPosterViewWith(gesture: UIPanGestureRecognizer){
        //creation du deplacement
        let gestureTranslation = gesture.translation(in: posterView)
       
        let translationTransform = CGAffineTransform(translationX: gestureTranslation.x, y: gestureTranslation.y)
        
        //creation de la rotation
        
        let screenWidth = UIScreen.main.bounds.width
        let ratioOfTranslationAndScreenWidth = gestureTranslation.x / (screenWidth / 2)
        let rotationAngle = (CGFloat.pi / 6) * ratioOfTranslationAndScreenWidth
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
    
        //combinaison du deplacement et de la rotation
        let transform = translationTransform.concatenating(rotationTransform)
        //application de la combinaison des deux transformations à la posterview
        posterView.transform = transform
        posterView.style = gestureTranslation.x > 0 ? .liked : .unliked
    }
    private func setUserChoiceFrom(gesture: UIPanGestureRecognizer){
        
        //recuparation du geste et calcul du ration geste/largeur de l'ecran
        let gestureTranslation = gesture.translation(in: posterView)
        let screenWidth = UIScreen.main.bounds.width
        let ratioOfTranslationAndScreenWidth = gestureTranslation.x / (screenWidth / 4)
        
        //tout stopper si le geste n'est pas significatif
        guard ratioOfTranslationAndScreenWidth < -1 || ratioOfTranslationAndScreenWidth > 1 else {
            posterView.transform = .identity
            posterView.style = .neutral
            return
        }
        
        
        //regler le choix de l'utilisateur
        switch posterView.style {
        case .liked:
            choice.setLikeOfCurrentMovie(with : true)
        case .unliked:
           
            choice.setLikeOfCurrentMovie(with: false)
        default: break
        }
        
       
        //animer la sortie du posterview
        
        var translationTransform: CGAffineTransform
        if posterView.style == .liked {
            translationTransform = CGAffineTransform(translationX: screenWidth, y:0)
        }
        else{
            translationTransform = CGAffineTransform(translationX: -screenWidth, y:0)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.posterView.transform = translationTransform
        }) { (success) in
            guard success else {return }
            self.showPoster()
        }
        
    }
    private func showPoster() {
        //replacer le posterview à sa place d'origine et passer au film suivant
        posterView.transform = .identity
        posterView.style = .neutral
        
        switch choice.state {
        case .ongoing:
            posterView.poster = choice.currentMovie.poster
            movieTitleLabel.text = choice.currentMovie.title
        case .over:
            posterView.poster = Data()
             performSegue(withIdentifier: "toContinuation", sender: nil)
            movieTitleLabel.text = ""
            
            
            
        }
        
        //animer l'apparition du posterview
        posterView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: [], animations: {
            self .posterView.transform = .identity
        })
    }
    
    
    

   

}

