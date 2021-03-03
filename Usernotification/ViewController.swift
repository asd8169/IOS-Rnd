//
//  ViewController.swift
//  Usernotification
//
//  Created by  p2noo on 2021/03/03.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    
    var selectTime = ""
    var alarmTime: [String] = []
    var alarmHour = ""
    var alarmminute = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        center.delegate = self
        
        // 사용자에게 권한 요청
        
        center.requestAuthorization(options: options) { (noProblem, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard noProblem else { return print("No Problem") }
            self.setupNotificationActions()
        }
        print(selectTime)
        
        }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        // 전달된 인수 저장
        let datePickerView = sender
        // DateFormatter 클래스 상수 선언
        let formatter = DateFormatter()
        
        // Locale 설정 "ko" 한국 기준
        formatter.locale = Locale(identifier: "ko")
        // formatter의 dateFormat 속성을 설정
        // 년도 - 월 - 일 요일 (오전/오후) 시간 : 분 : 초
        formatter.dateFormat = "HH:mm"
        
        selectTime = formatter.string(from: datePickerView.date)
        print(selectTime)
        alarmTime = selectTime.components(separatedBy: [":"])
        print("alarmTime",alarmTime)
        alarmHour = alarmTime[0]
        alarmminute = alarmTime[1]
        print("alarmHour",alarmHour)
        print("alarmminute",alarmminute)
    }
    
    @IBAction func btnAlarm(_ sender: UIButton) {
        print("알림 설정 완료")
        triggerTimeIntervalNotifications()
    }
    
    func setupNotificationActions(){
        let center = UNUserNotificationCenter.current()
        let destructiveAction = UNNotificationAction(identifier: "DESID", title: "종료", options: [.destructive])
        
        // ios 10 +
        let category = UNNotificationCategory(
            identifier: "testID",
            actions: [destructiveAction],
            intentIdentifiers: [],
            options: []
            )
        
        center.setNotificationCategories([category])
        
        }
    
    
    // Notification 에 대한 세팅
    func getNotificationSettings(completionHandler: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            completionHandler(settings.authorizationStatus == .authorized)
        }
    
    }
    
    // 일정 시간 간격으로 Notification 발송을 관리하기 위한 triggerTimeIntervalNotification
    func triggerTimeIntervalNotifications(){
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "Moca"
        content.subtitle = "Moca에서 오늘도 마시고싶은 음료를 찾아보세요!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "testID"
        
//        // 정해진 시간만큼 알림 반복
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        // 현재 시간 알람
//        let date = Date(timeIntervalSinceNow: 3600)
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        print("triggerDate.year",triggerDate.year!)
//        print("triggerDate.month",triggerDate.month!)
//        print("triggerDate.day",triggerDate.day!)
//        print("triggerDate.hour",triggerDate.hour!)
//        print("triggerDate.minute",triggerDate.minute!)
//        print("triggerDate.second",triggerDate.second!)
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//        // 매주
//        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
//
//        let calendar = Calendar.current
//               let realHour = calendar.component(.hour, from: date)
//               let realMinute = calendar.component(.minute, from: date)
//               let realSecond = calendar.component(.second, from: date)
//        print("realHour",realHour)
//        print("realMinute",realMinute)
//        print("realSecond",realSecond)
//
//        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: date)
//        // 매일
//        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
//                print("triggerDaily.hour",triggerDaily.hour!)
//                print("triggerDaily.minute",triggerDaily.minute!)
//                print("triggerDaily.second",triggerDaily.second!)
        var date = DateComponents()
        date.hour = Int(alarmHour)
        date.minute = Int(alarmminute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        //언제 발생 시킬 것인지 알려준다.
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
//
        // identifier? 알림 요청이 여러가지가 될 떄 이 알림들을 구별하는 식별자
        // 등록할 결과물
        let request = UNNotificationRequest(identifier: "notice", content: content, trigger: trigger)
        //UNUserNotificationCenter.current()에 등록
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    @objc func tick() {
        selectTime = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
    }
    
    
    
    
    
    
}

