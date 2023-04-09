import SwiftUI

struct HomeView: View {
    @State public var selected = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("logout")
            }
        }
    }
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(Color(red: 38 / 255, green: 58 / 255, blue: 132 / 255))
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance

    }
    
    var body: some View {
        ZStack{
            TabView(selection: $selected) {
                HomeFragment()
                    .tabItem {
                        selected == 0 ? Image("home_selected") : Image("home")
                        Text("Trang chủ")
                    }.tag(0)
                
                NotificationFragment()
                    .tabItem {
                        selected == 1 ?
                        Image("noti_selected")
                        : Image("noti")
                        Text("Thông báo")
                    }.tag(1)
                
                
                AccountFragment()
                    .tabItem {
                        selected == 2 ?
                        Image("acc_selected")
                        : Image("account")
                        Text("Tài khoản")
                    }.tag(2)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, minHeight: 92)
            .toolbar{

                ToolbarItem(placement: .navigationBarLeading) {
                    btnBack
                }
                ToolbarItem(placement: .principal) {
                    Image("logohome")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("bar")
                        .onTapGesture {
                            isSideBarOpened.toggle()
                        }
                }
            }
            
           MenuSlideView(isSidebarVisible: $isSideBarOpened)
        
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
