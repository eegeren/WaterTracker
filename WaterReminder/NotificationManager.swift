//
//  NotificationManager.swift
//  WaterReminder
//
//  Created by Yusufege Eren on 2.07.2025.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    // Su içme hatırlatmalarını özelleştirilmiş mesajlarla gönderecek
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // Su içme hedeflerine göre özelleştirilmiş motivasyonel mesajlar
    let motivationalMessages = [
        "Tebrikler! Bugün 1 litre suyu içtin. Devam et!",
        "Harika gidiyorsun! Hedefe doğru adım adım ilerliyorsun.",
        "Su içmek cildin için çok faydalı! Bir bardak daha içmeye ne dersin?",
        "Su içerek enerji seviyelerini artırabilirsin. Bir bardak daha iç!"
    ]

    // Bildirim zamanlayıcısını ayarla
    func scheduleReminders() {
        let content = UNMutableNotificationContent()
        
        // Kullanıcının günlük su tüketimine göre mesaj
        let currentIntake = UserDefaults.standard.integer(forKey: "currentIntake")
        let goal = 2000 // örnek hedef: 2000 ml
        
        if currentIntake >= goal {
            content.body = "Harika iş çıkardın! Bugün 2 litre suyu içtin!"
        } else {
            content.body = "Bir bardak daha içmeye ne dersin? Hedefe doğru ilerliyorsun!"
        }
        
        content.title = "💧 Su içmeyi unutma!"
        content.body = motivationalMessages.randomElement() ?? "Su içmeyi unutma, sağlıklı kal!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)

        let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // Farklı zaman dilimlerinde bildirim gönderme
    func scheduleDailyReminders() {
        let content = UNMutableNotificationContent()
        content.title = "💧 Su içmeyi unutma!"

        // Farklı zaman dilimlerinde bildirimler gönder
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 9, minute: 0), repeats: true)
        let lunchTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 12, minute: 0), repeats: true)
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 18, minute: 0), repeats: true)

        let morningRequest = UNNotificationRequest(identifier: "morningReminder", content: content, trigger: morningTrigger)
        let lunchRequest = UNNotificationRequest(identifier: "lunchReminder", content: content, trigger: lunchTrigger)
        let eveningRequest = UNNotificationRequest(identifier: "eveningReminder", content: content, trigger: eveningTrigger)
        
        UNUserNotificationCenter.current().add(morningRequest)
        UNUserNotificationCenter.current().add(lunchRequest)
        UNUserNotificationCenter.current().add(eveningRequest)
    }
}
