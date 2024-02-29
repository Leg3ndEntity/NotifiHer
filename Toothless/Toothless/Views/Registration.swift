
import SwiftUI

struct Registration: View {
    
    @State var name: String
    @State var surname: String
    @State var phoneNumber: String
    
    var body: some View {
        VStack {
            Text("Set up Health Details")
                .font(.title)
                .bold()
                .padding()
            
            Text("Your health details are the basic information the app needs to provide you with relevant information.")
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .frame(width: 350)
                .padding(.top, 20)
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
                Text("Phone Number").bold()
                TextField("Required", text: $phoneNumber)
                    .accessibilityRemoveTraits(.isStaticText)
                    .padding(.leading, 20)
                    .keyboardType(.numberPad)
            }
            .padding(.leading, 20)
            .padding(.bottom)
            .padding(.top)
            
            Divider().padding(.bottom, 50)
        }
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration(name: "", surname: "", phoneNumber: "")
    }
}

