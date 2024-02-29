//
//  ViewController.swift
//  Camera
//
//  Created by siddhesh.bhajey on 27/02/24.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var imageClicked: UIImageView!
    var originalImage: UIImage?
    var savedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageClicked.layer.cornerRadius = 10
        imageClicked.contentMode = .scaleToFill
        buttonConfiguration()
        addRightBarButton()
        editPhotoButton.isHidden = true
        self.navigationItem.title = "Camera"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Camera"
        if savedImage != nil {
            imageClicked.image = savedImage
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            imageClicked.image = originalImage
        }
    }

    //MARK: - Edit button action
    @IBAction func editPhotoAction(_ sender: Any) {
        guard let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "secondViewController") as? SecondViewController else {
            return
        }
        secondVC.originalImage = originalImage
        self.navigationController?.pushViewController(secondVC, animated: true)
    }

    //MARK: - Take a photo button action
    @IBAction func photoButtonAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera;
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: - Configure buttons
    private func buttonConfiguration() {
        photoButton.backgroundColor = .systemBlue
        photoButton.layer.cornerRadius = 10
        photoButton.tintColor = .white
        editPhotoButton.backgroundColor = .systemBlue
        editPhotoButton.layer.cornerRadius = 10
        editPhotoButton.tintColor = .white
    }

    //MARK: - Add Share button
    private func addRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    //MARK: - Share button action
    @objc func shareTapped() {
        guard let savedImage = savedImage else {
            return
        }
        let vc = UIActivityViewController(activityItems: [savedImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

//MARK: - Image Picker Delegate functions
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        originalImage = image
        imageClicked.image = image
        editPhotoButton.isHidden = false
    }
}

extension UINavigationController {
    func viewController<T: UIViewController>(class: T.Type) -> T? {
        return viewControllers.filter({$0 is T}).first as? T
    }
}
