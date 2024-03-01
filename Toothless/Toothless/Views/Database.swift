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
                    
                    let user = User(name: name, surname: surname, phoneNumber: phoneNumber, fcmToken: fcmToken)
                    self.utenti.append(user)
                }
            }
        }
    }
    
    func addUser(user: User, phoneNumber: String) {
        // Remove non-alphanumeric characters from the phone number
        let sanitizedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()

        let db = Firestore.firestore()
        let ref = db.collection("utenti").document(sanitizedPhoneNumber)
        
        ref.setData([
            "name": user.name,
            "surname": user.surname,
            "phoneNumber": user.phoneNumber,
            "fcmToken": user.fcmToken,
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func searchUserByPhoneNumber(phoneNumber: String, completion: @escaping (String?) -> Void) {
            let sanitizedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()

            let db = Firestore.firestore()
            let ref = db.collection("utenti").document(sanitizedPhoneNumber)

            ref.getDocument { document, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    completion(nil)
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    let fcmToken = data?["fcmToken"] as? String
                    completion(fcmToken)
                } else {
                    // Document not found
                    completion(nil)
                }
            }
        }
    }
