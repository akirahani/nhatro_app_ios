import SwiftUI
struct LoginView: View {
    //khai bao model
    @State var models: [Users] = []
    @State var passd: String = ""
    @State var user: String = ""
    
    @State var isLogin = false
    @State var alertShow = false
    //api login
    func loginHome() {

        guard let urlAddTB =  URL(string:"http://192.168.1.183/nhatro/admin/api/auth/login.php")
        else { return }

        let body: [String: Any] = ["username": user, "password": passd]
        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
        var request = URLRequest(url: urlAddTB)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
               
       URLSession.shared.dataTask(with: request) { data, response, error in

           if error != nil{
               print(error)
               return
           }
//      call with JSON
           if let data = data {
              let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
              
              // Check if the login was successful
              if json["status"] as! String == "success" {
                  DispatchQueue.main.async {
                      self.isLogin = true
                  }
                  print(json["fullname"])
              } else {
                  self.alertShow = true
              }
          }
            
           //
           if isLogin == true {
             HomeView()
           } else {
             LoginView()
       
           }
       
       }.resume()
    }

    
    //NSUserDefault
    let shp = UserDefaults.standard.set("user", forKey: "username")

    let userName = UserDefaults.standard.string(forKey: "username")
    
    // View
    var body: some View {
       
        NavigationView{
            ZStack {
                ScrollView{
                    VStack{
                        Image("logo").padding(.top, 32)
                        
                        Text("ID Đăng nhập")
                            .padding(.top, 41)
                            .padding(.leading, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            TextField("User",
                                text: $user
                            )
                            .frame(height: 49)
                            .foregroundColor(Color(hex: "#000000"))
                        }
                        .background(Color(hex: "F9F9FA"))
                        .cornerRadius(10)
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                        .shadow(color: Color.white, radius:5, x: 0, y: 2)
                 
                   
                        VStack{
                            Text("Mật khẩu")
                                .padding(.top, 41)
                                .padding(.leading, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                            
                        HStack{
                            SecureField("Password",
                                text: $passd)
                            .foregroundColor(Color(hex: "#000000"))
                            .frame(height: 49)
                            
                        }.background(Color(hex: "F9F9FA"))
                        .cornerRadius(10)
                        .shadow(color: Color.white, radius:5, x: 0, y: 2)
                        .padding(.bottom, 38)
                        .padding(.trailing, 12)
                        .padding(.leading, 12)
                     

                        HStack {
                            VStack{
                                Button(action: {
                                     loginHome()
                                }){
                                    Text("Đăng nhập")
                                        .frame(maxWidth: .infinity, minHeight: 49)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .textCase(.uppercase)
                                        .font(.system(size: 16, weight: .bold))
                                    
                                }
                                .overlay(
                                    NavigationLink(destination: HomeView(), isActive: $isLogin){
                                        EmptyView()
                                    }
                                )
                                .alert(isPresented: $alertShow){
                                    Alert(title: Text("Thông báo !"), message: Text("Đăng nhập thất bại !"), dismissButton: .default(Text("Ok")))
                                }
                            }
                            .background(Color(hex: "354B9C"))
                            
                        }
                        .disabled(user.isEmpty)
                        .disabled(passd.isEmpty)
                        .cornerRadius(10)
                        .padding(.trailing, 12)
                        .padding(.leading, 12)

                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}



// model chi tiết
struct Users: Identifiable, Codable {
    let id = UUID()
    var user: String?
    var iduser: String?
    var status: String?
    var fullname: String?
    var dienthoai: String?
    var diachi: String?
    var cancuoc: String?
    var ngaycap: String?
    var quoctich: String?
    var ngaysinh: String?
    
    enum CodingKeys: String, CodingKey {
        case user = "username"
        case iduser = "id"
        case status = "status"
        case fullname = "fullname"
        case dienthoai = "dienthoai"
        case diachi = "diachi"
        case cancuoc = "cancuoc"
        case ngaycap = "ngaycap"
        case quoctich = "quoctich"
        case ngaysinh = "ngaysinh"
        
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
