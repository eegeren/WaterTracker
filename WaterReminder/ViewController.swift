//
//  ViewController.swift
//  WaterReminder
//
//  Created by Yusufege Eren on 2.07.2025.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    let titleLabel = UILabel()
    let progressView = UIProgressView(progressViewStyle: .default)
    let amountLabel = UILabel()
    let drinkButton = UIButton(type: .system)
    let resetButton = UIButton(type: .system)

    // Günlük hedef (ml)
    let goal = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        NotificationManager.shared.requestPermission()
        NotificationManager.shared.scheduleReminders()
        updateUI()
    }

    func setupUI() {
        titleLabel.text = "Water Tracker"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemBlue

        progressView.progress = 0.0
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.3)
        progressView.tintColor = .systemBlue
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true

        amountLabel.text = "0 ml"
        amountLabel.font = UIFont.systemFont(ofSize: 24)
        amountLabel.textAlignment = .center
        amountLabel.textColor = .systemBlue

        drinkButton.setTitle("Add 250ml", for: .normal)
        drinkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        drinkButton.backgroundColor = .systemGreen
        drinkButton.tintColor = .white
        drinkButton.layer.cornerRadius = 12
        drinkButton.layer.shadowColor = UIColor.black.cgColor
        drinkButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        drinkButton.layer.shadowOpacity = 0.3
        drinkButton.layer.shadowRadius = 5
        drinkButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)

        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        resetButton.backgroundColor = .systemRed
        resetButton.tintColor = .white
        resetButton.layer.cornerRadius = 12
        resetButton.layer.shadowColor = UIColor.black.cgColor
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        resetButton.layer.shadowOpacity = 0.3
        resetButton.layer.shadowRadius = 5
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)

        [titleLabel, progressView, amountLabel, drinkButton, resetButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalToConstant: 20),

            amountLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            drinkButton.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 40),
            drinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drinkButton.widthAnchor.constraint(equalToConstant: 200),
            drinkButton.heightAnchor.constraint(equalToConstant: 50),

            resetButton.topAnchor.constraint(equalTo: drinkButton.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func didTapAdd() {
        var currentIntake = UserDefaults.standard.integer(forKey: "currentIntake")
        
        // Eğer kullanıcı hedefin altındaysa, 250 ml ekle
        if currentIntake < goal {
            currentIntake += 250
            if currentIntake > goal {
                currentIntake = goal // Hedefi geçemez
                showCelebration()  // Hedef geçildiğinde kutlama animasyonu göster
            }
            UserDefaults.standard.set(currentIntake, forKey: "currentIntake")
        } else {
            // Hedefi geçtikten sonra kullanıcıya bilgi ver
            let alert = UIAlertController(title: "Hedef Tamamlandı", message: "Bugün 2000 ml suyu içtiniz! Tebrikler! Daha fazla su içemezsiniz.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        updateUI()
    }

    @objc func didTapReset() {
        // Su içme miktarını sıfırla
        UserDefaults.standard.set(0, forKey: "currentIntake")
        
        // UI'yi güncelle
        updateUI()
    }

    func updateUI() {
        let currentIntake = UserDefaults.standard.integer(forKey: "currentIntake")
        
        // İlerlemeni göster
        progressView.progress = Float(currentIntake) / Float(goal)
        
        // İçilen suyu göster
        amountLabel.text = "\(currentIntake) ml"
    }

    // Hedef geçildiğinde kutlama mesajı ve animasyonu başlat
    func showCelebration() {
        let celebrationLabel = UILabel()
        celebrationLabel.text = "Tebrikler! Hedefi Geçtin!"
        celebrationLabel.font = UIFont.boldSystemFont(ofSize: 24)
        celebrationLabel.textAlignment = .center
        celebrationLabel.textColor = .systemYellow
        celebrationLabel.alpha = 0.0
        celebrationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(celebrationLabel)

        // Konfeti animasyonu veya kutlama mesajı ekleyebilirsiniz
        UIView.animate(withDuration: 1.5, animations: {
            celebrationLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                celebrationLabel.alpha = 0.0
            })
        }

        // Konfeti veya başka animasyonlar da eklenebilir.
    }
}
