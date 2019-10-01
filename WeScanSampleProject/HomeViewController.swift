//
//  ViewController.swift
//  WeScanSampleProject
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import WeScan

final class HomeViewController: UIViewController {
    
    lazy private var logoImageView: UIImageView = {
        let image = UIImage(named: "WeScanLogo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "WeScan"
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(red: 64.0 / 255.0, green: 159 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var editSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow editing ?"
        label.textColor = UIColor(red: 64.0 / 255.0, green: 159 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy private var editSwitch: UISwitch = {
        let editSwitch = UISwitch()
        editSwitch.isOn = true
        editSwitch.translatesAutoresizingMaskIntoConstraints = false
        return editSwitch
    }()
    
    lazy private var scanButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitle("Scan Item", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scanOrSelectImage(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 64.0 / 255.0, green: 159 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 10.0
        return button
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(logoLabel)
        view.addSubview(scanButton)
        view.addSubview(editSwitchLabel)
        view.addSubview(editSwitch)
    }
    
    private func setupConstraints() {
        
        let logoImageViewConstraints = [
            logoImageView.widthAnchor.constraint(equalToConstant: 150.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 150.0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NSLayoutConstraint(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.75, constant: 0.0)
        ]
        
        let logoLabelConstraints = [
            logoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0),
            logoLabel.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(logoLabelConstraints + logoImageViewConstraints)
        
        if #available(iOS 11.0, *) {
            let scanButtonConstraints = [
                scanButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
                scanButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
                scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                scanButton.heightAnchor.constraint(equalToConstant: 55)
            ]
            
            NSLayoutConstraint.activate(scanButtonConstraints)
        } else {
            let scanButtonConstraints = [
                scanButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                scanButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                scanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
                scanButton.heightAnchor.constraint(equalToConstant: 55)
            ]
            
            NSLayoutConstraint.activate(scanButtonConstraints)
        }

        if #available(iOS 11.0, *) {
            let editSwitchConstraints = [
                editSwitch.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
                editSwitch.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -16),
                editSwitch.leftAnchor.constraint(equalTo: editSwitchLabel.rightAnchor, constant: 8),
                editSwitchLabel.centerYAnchor.constraint(equalTo: editSwitch.centerYAnchor, constant: 0)
            ]
            NSLayoutConstraint.activate(editSwitchConstraints)
        } else {
            let editSwitchConstraints = [
                editSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                editSwitch.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -16),
                editSwitch.leftAnchor.constraint(equalTo: editSwitchLabel.rightAnchor, constant: 8),
                editSwitchLabel.centerYAnchor.constraint(equalTo: editSwitch.centerYAnchor, constant: 0)
            ]
            NSLayoutConstraint.activate(editSwitchConstraints)
        }


    }
    
    // MARK: - Actions
    
    @objc func scanOrSelectImage(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Would you like to scan an image or select one from your photo library?", message: nil, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sender
        let scanAction = UIAlertAction(title: "Scan", style: .default) { (_) in
            self.scanImage()
        }
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { (_) in
            self.selectImage()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(scanAction)
        actionSheet.addAction(selectAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func scanImage() {
        let scannerViewController = ImageScannerController(delegate: self)
        scannerViewController.skipImageEdition = !editSwitch.isOn
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
    
    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
}

extension HomeViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
}
