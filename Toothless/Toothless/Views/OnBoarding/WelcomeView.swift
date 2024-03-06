
import SwiftUI
import AuthenticationServices

struct CustomColor {
    static let background = Color("Background")
    static let customred = Color("CustomRed")
    static let text = Color("Text")
    static let brightred = Color("BrightRed")
    static let backgroundhome = Color("BackgroundHome")
}

struct WelcomeView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State static var currentShowingView: String = "signup"
    @State var showSignIn: Bool = false
    @State private var isUserSignedIn: Bool = false
    //@Binding var currentShowingView: String
    
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    
    @EnvironmentObject var database: Database
    @Environment(\.modelContext) var modelContex
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                ZStack {
                    PageView(page: page)
                        .ignoresSafeArea()
                    Spacer()
                    if page == pages.last {
                        ZStack{
                            PageView(page: page)
                                .ignoresSafeArea()
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width:200, height:60)
                                    .foregroundStyle(.black)
                                Text("Get started")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }.padding(.top, 630)
                        }.onTapGesture {
                            showSignIn.toggle()
                        }
                        
                    }
                }
                .tag(page.tag)
            }
        }.ignoresSafeArea()
            .animation(.easeInOut, value: pageIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                dotAppearance.currentPageIndicatorTintColor = .red
                dotAppearance.pageIndicatorTintColor = .gray
            }
            .fullScreenCover(isPresented: $showSignIn, content: {
                SignupView()
            })
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func goToZero() {
        pageIndex = 0
    }
}


struct WELCOMEView_Previews: PreviewProvider {
    @State static var currentShowingView: String = "signup"
    
    static var previews: some View {
        WelcomeView()
        
    }
}
