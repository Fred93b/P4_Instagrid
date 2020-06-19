//
//  ViewController.swift
//  P4_01_Architecture
//
//  Created by vaillant on 13/05/2020.
//  Copyright © 2020 vaillant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - PROPERTIES
    
    // création d'un tableau pour la connexion de chaque type de bouton
    @IBOutlet var pictureButtons: [UIButton]!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet var validateLayoutButtons: [UIImageView]!
    
    // connexion des élements servant à transformer la vue pour l'accès et le partage des photos
    @IBOutlet weak var ContainerPics: UIView!
    @IBOutlet weak var SwipeUpToShare: UILabel!
    
    // variable pour accéder aux fontions des propriétés suivantes
    var imagePicker = UIImagePickerController()
    var selectedPictureButtons = UIButton()
    var swipeGesture: UISwipeGestureRecognizer!
    
    // variable pour vérifier que la grille n'est pas vide avant le partage
    var layoutIsEmpty = true
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLayout(layoutButtons[1])
        imagePicker.delegate = self
        
        // méthode pour intégrer le changement d'orientation de l'appareil
        NotificationCenter.default.addObserver(self, selector: #selector(changedLabelSwipeAndOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // méthode pour actionner et animer la grille photo
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(animedSwipeContainerPics))
        view.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: - ACTIONS
    
    // fonction permettant de changer la disposition de la grille photo
    enum Grid {
        case first
        case second
        case third
    }
    
    var currentGrid = Grid.second
    
    @IBAction func changeLayout(_ sender: UIButton) {
        
        switch sender {
            
        case layoutButtons[0]:
            showValidateLayoutButtons(at: 0)
            showPictureButtons(at: 0)
            currentGrid = .first
            
        case layoutButtons[1]:
            showValidateLayoutButtons(at: 1)
            showPictureButtons(at: 1)
            currentGrid = .second
            
        case layoutButtons[2]:
            showValidateLayoutButtons(at: 2)
            showPictureButtons(at: 2)
            currentGrid = .third
            
        default: break
        }
        sortImageButton(for: currentGrid)
    }
    // fonction pour accéder à sa galerie photo et choisir une image
    @IBAction func ChooseImageButtonTapped(_ sender: UIButton) {
        selectedPictureButtons = sender
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - METHODS
    
    // fonction modifiant le label du "swipe" selon l'orientation
    @objc func changedLabelSwipeAndOrientation() {
        if UIDevice.current.orientation.isPortrait {
            SwipeUpToShare.text = "Swipe Up to share"
            swipeGesture.direction = .up
        } else if UIDevice.current.orientation.isLandscape {
            SwipeUpToShare.text = "Swipe Left to share"
            swipeGesture.direction = .left
        }
    }
    // fonction pour animer le glissé de la grille photo selon l'orientation
    @objc func animedSwipeContainerPics() {
        if swipeGesture.direction == .up {
            UIView.animate(withDuration: 0.5) {
                self.ContainerPics.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
                self.showAlertContainerEmpty()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.ContainerPics.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                self.showAlertContainerEmpty()
            }
        }
    }
    // fonction pour faire apparaitre un nombre déterminé de boutons photos (selon la disposition choisie)
    
    //MR<<<
    func showPictureButtons(at index: Int) {
        if index == 0 {
            pictureButtons[0].isHidden = false
            pictureButtons[1].isHidden = true
            pictureButtons[2].isHidden = false
            pictureButtons[3].isHidden = false
        } else if index == 1 {
            pictureButtons[0].isHidden = false
            pictureButtons[1].isHidden = false
            pictureButtons[2].isHidden = false
            pictureButtons[3].isHidden = true
        } else if index == 2 {
            pictureButtons[0].isHidden = false
            pictureButtons[1].isHidden = false
            pictureButtons[2].isHidden = false
            pictureButtons[3].isHidden = false
        }
//                for (number, button) in pictureButtons.enumerated() {
//                    if number == index {
//                        button.isHidden = true
//                    } else {
//                        button.isHidden = false
//                    }
//                }
    }
    //MR>>>
    
    // fonction pour afficher l'images indiquant la validation de chaque disposition
    func showValidateLayoutButtons(at index: Int) {
        for (number, button) in validateLayoutButtons.enumerated() {
            if number == index {
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }
    
    // fonction pour accéder au partage de sa grille photo
    func shareContainerPics() {
        let renderer = UIGraphicsImageRenderer(size: ContainerPics.bounds.size)
        let image = renderer.image { _ in ContainerPics.drawHierarchy(in: ContainerPics.bounds, afterScreenUpdates: true)}
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true)
        activityController.completionWithItemsHandler = {
            _ , _ , _, _ in UIView.animate(withDuration: 0.5) {
                self.ContainerPics.transform = .identity
            }
        }
    }
    
    //MR<<<
    var imageStore: [String: UIImage?] = [
        "first": UIImage(named: "Image"),
        "second": UIImage(named: "Image"),
        "third": UIImage(named: "Image"),
        "fourth": UIImage(named: "Image"),
    ]
    
    func sortImageButton(for grid: Grid) {
        print("selected grid: \(grid)")
        print(imageStore)
        switch grid {
        case .first:
            pictureButtons[0].setImage(imageStore["first"]!, for: .normal)
            pictureButtons[2].setImage(imageStore["second"]!, for: .normal)
            pictureButtons[3].setImage(imageStore["third"]!, for: .normal)
        case .second:
            pictureButtons[0].setImage(imageStore["first"]!, for: .normal)
            pictureButtons[1].setImage(imageStore["second"]!, for: .normal)
            pictureButtons[2].setImage(imageStore["third"]!, for: .normal)
        case .third:
            pictureButtons[0].setImage(imageStore["first"]!, for: .normal)
            pictureButtons[1].setImage(imageStore["second"]!, for: .normal)
            pictureButtons[2].setImage(imageStore["third"]!, for: .normal)
            pictureButtons[3].setImage(imageStore["fourth"]!, for: .normal)
        }
    }
    
    func manageStoreImage(image: UIImage, tag: Int, grid: Grid) {
        switch grid {
        case .first:
            if tag == 0 {
                 imageStore["first"] = image
            } else if tag == 2 {
                imageStore["second"] = image
            } else if tag == 3 {
                imageStore["third"] = image
            }
        case .second:
            if tag == 0 {
                 imageStore["first"] = image
            } else if tag == 1 {
                imageStore["second"] = image
            } else if tag == 2 {
                imageStore["third"] = image
            }
        case .third:
            if tag == 0 {
                 imageStore["first"] = image
            } else if tag == 1 {
                imageStore["second"] = image
            } else if tag == 2 {
                imageStore["third"] = image
            } else if tag == 3 {
                imageStore["fourth"] = image
            }
        }
    }
    //MR>>>
    
    
    // fonction pour signaler une galerie vide au moment du partage
    func showAlertContainerEmpty() {
        let alert = UIAlertController(title: "empty photo grid" , message: "your photo grid is not complete !"
            , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        if layoutIsEmpty == true {
            self.present(alert, animated: true)
            ContainerPics.transform = .identity
        } else {
            shareContainerPics()
        }
    }
}
extension ViewController: UIImagePickerControllerDelegate {
    // fonction pour faire apparaitre l'image choisie sur sa galerie photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        selectedPictureButtons.setImage(pickedImage, for: .normal)
        manageStoreImage(image: pickedImage!, tag: selectedPictureButtons.tag, grid: currentGrid)
        print(imageStore)
        selectedPictureButtons.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
        layoutIsEmpty = false
    }
    
    
}
