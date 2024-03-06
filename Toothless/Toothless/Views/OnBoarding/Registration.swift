
import SwiftUI
import Firebase

struct Registration: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var generatedCode: String = ""
    let customDocumentID = "customDocumentID123"

    @EnvironmentObject var database: Database
    @Environment(\.modelContext) var modelContext
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false

    @State var isShowingMain: Bool = false
    @State private var isUserSignedIn: Bool = false

    var fcmToken: String? {
        UserDefaults.standard.string(forKey: "fcmToken")
    }

    private func generateUniqueCode() -> String {
        var code = ""
        repeat {
            let randomNumber = String(format: "%06d", Int.random(in: 0...999999))
            code = randomNumber
            database.searchUserByPhoneNumber(phoneNumber: code) { result in
                if result != nil {
                    code = generateUniqueCode()
                }
            }
        } while false
        return code
    }

    var body: some View {

        VStack {
            Text("Set up personal details")
                .font(.title)
                .bold()
            Text("Your personal details are the basic information the app needs to help you in case of danger.")
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .frame(width: 350)
                .padding(.top, 1)
                .padding(.bottom, 50)
Divider()
            HStack {
                Text("First Name").bold()
                TextField("Required", text: $name)
                    .accessibilityRemoveTraits(.isStaticText)
                    .padding(.leading, 20)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            Divider()
            HStack {
                Text("Last Name").bold()
                TextField("Required", text: $surname)
                    .accessibilityRemoveTraits(.isStaticText)
                    .padding(.leading, 20)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            Divider()
            HStack {
                Text("Generated Code").bold()
//                TextField("Required", text: $generatedCode)
//                    .accessibilityRemoveTraits(.isStaticText)
//                    .padding(.leading, 20)
//                    .disabled(true)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            Divider().padding(.bottom, 50)

            HStack {
                Text("Get started")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
            }
            .padding(.bottom, 60)
            .onTapGesture {
                let user = User(name: name, surname: surname, phoneNumber: generatedCode, fcmToken: fcmToken ?? "")
                database.addUser(user: user, phoneNumber: user.phoneNumber)

                isWelcomeScreenOver = true
                isShowingMain.toggle()
                modelContext.insert(user)
                print("ciao")
            }
        }
//        .onAppear {
//            generatedCode = generateUniqueCode()
//        }
        .fullScreenCover(isPresented: $isShowingMain, content: {
            CompleteTimer()
        })
    }
}


struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration()
    }
}

