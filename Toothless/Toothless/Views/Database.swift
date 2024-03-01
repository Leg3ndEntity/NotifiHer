
import SwiftUI
import Firebase
import FirebaseFirestore

class Database: ObservableObject {
    @Published var utenti: [User] = []
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        utenti.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("utenti")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let fcmToken = data["fcmToken"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let surname = data["surname"] as? String ?? ""
                    let phoneNumber = data["phoneNumber"] as? String ?? ""
                    
                    let utenti = User(name: name, surname: surname, phoneNumber: phoneNumber, fcmToken: fcmToken)
                    self.utenti.append(utenti)
                }
            }
        }
    }
    func addUser(utentiName: String) {
        let db = Firestore.firestore()
        let ref = db.collection("utenti").document(utentiName)
        ref.setData(["name": utentiName, "id": 10]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func addUser(utentiSurname: String) {
        let db = Firestore.firestore()
        let ref = db.collection("utenti").document(utentiSurname)
        ref.setData(["surname": utentiSurname, "id": 10]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func addUser(utentiPhoneNumber: String) {
        let db = Firestore.firestore()
        let ref = db.collection("utenti").document(utentiPhoneNumber)
        ref.setData(["phoneNumber": utentiPhoneNumber, "id": 10]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func addUser(utentifcmToken: String) {
        let db = Firestore.firestore()
        let ref = db.collection("utenti").document(utentifcmToken)
        ref.setData(["fcmToken": utentifcmToken, "id": 10]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
