import SwiftUI

struct DichVuEditView: View {
    @State var thietBiModel = [ThietBi]()
    @State var getDichVu = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    
    @State private var tenDichVu: String = ""
    @State private var giaDichVu: String = ""
    @State private var idDV: String = ""
    @State var gotConfig = false
    @State var capNhatDichVuThanhCong = false
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        isSideBarOpened = false
        }) {
            HStack {
                Image("back")
            }
        }
    }
    
    
    func updateThietBi() async throws {

       guard let urlEditTB =  URL(string:"http://192.168.1.183/nhatro/admin/api/thiet-bi/edit.php")
//       guard let urlEditTB =  URL(string:"http://192.168.0.104/nhatro/admin/api/thiet-bi/edit.php")
        
        else { return }

        let body: [String: Any] = ["id" : dichVuItem.idtb ?? "","ten": tenDichVu, "gia": giaDichVu]
        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
        var request = URLRequest(url: urlEditTB)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
               
       URLSession.shared.dataTask(with: request) { data, response, error in

           guard let data = data, error == nil else {
               return
           }
        
        let responseJSON = try? JSONDecoder().decode([ThietBi].self ,from: data )
        capNhatDichVuThanhCong = true
           
       if(capNhatDichVuThanhCong == true){
            DichVuView()
       }else{
           DichVuAddView()
       }
           
       }.resume()
    }
    
    func fetchData() async {
        
    }
    
    let dichVuItem : ThietBi
    
    var body: some View {
        ZStack{
            VStack{
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("dichvu")
                        Text("Sửa dịch vụ").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
                            .font(.system(size: 18, weight: .bold))
                    }.padding(.top, 13)
                        .padding(.leading, 23)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 59,
                            alignment: .topLeading
                        )
                }.background(Color.white)
                    .zIndex(3)
                // sua dich vu
                
                ScrollView{
                    ZStack{
                        VStack{
                            ZStack{
                                HStack{
                                    Text("Tên thiết bị: ").font(.system(size: 16, weight: .bold))
                                        .padding(.leading, 9)
                                    TextField("Tên dịch vụ", text: $tenDichVu)
                                        .padding(.trailing, 9)
                                    
                                } .padding(.bottom, 8)
                                .padding(.top, 8)
                                .background(Color.white)
                                 .clipShape(RoundedRectangle(cornerRadius:10))
                                
                            }.padding(.top, 16)
                                .padding(.trailing, 8)
                                .padding(.leading, 8)

                            ZStack{
                                HStack{
                                    Text("Giá thiết bị: ").font(.system(size: 16, weight: .bold))
                                        .padding(.leading, 9)
                                    TextField("Giá dịch vụ", text: $giaDichVu)
                                        .padding(.trailing, 9)
                                }
                                .padding(.bottom, 8)
                                .padding(.top, 8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius:10))
                            }.padding(.top, 16)
                                .padding(.trailing, 8)
                                .padding(.leading, 8)

                            
                            HStack{
                                Button
                                {
                                }label: {
                                    Text("Quay lại")
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        .padding(.leading, 44)
                                        .padding(.trailing ,44)
                                      .foregroundColor(.white)
                                  }
                                .foregroundColor(Color.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#8091CE"),
                                Color(hex:"#3252C5")]),startPoint: .topLeading,endPoint: .bottomTrailing))
                                .cornerRadius(6)
                                .padding(.top,22)
                                .padding(.bottom,17)
                                .padding(.leading,9)
                                
                                Spacer()
                                
                                Button{
                                    Task{
                                        do {
                                           try await updateThietBi()
                                        }
                                       catch {
                                           print(error)
                                       }
                                    }
                                }
                                label:{
                                    Text("Cập nhật")
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        .padding(.leading, 44)
                                        .padding(.trailing ,44)
                                }
                                .overlay{
                                    NavigationLink(destination: DichVuView(), isActive: $capNhatDichVuThanhCong){
                                            EmptyView()
                                    }
                                }
                                .foregroundColor(Color.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#B71616"), Color(hex:"#ec323780")]),startPoint: .topLeading,endPoint: .trailing))
                                .cornerRadius(6)
                                .padding(.top,22)
                                .padding(.bottom,17)
                                .padding(.trailing,9)
                            }
                        }.background(Color(hex: "F3F6FF"))
                            .clipShape(RoundedRectangle(cornerRadius:7))
                    }.padding(.top,16)
                    .padding(.leading,14)
                    .padding(.trailing,14)
                    .zIndex(1)
                }.background(Color.white)
                    .padding(.top,20)
                .zIndex(1)
                
                Spacer()
            }.background(Color(hex: "F2F1F6"))
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        btnBack
                    }
                    ToolbarItem(placement: .principal) {
                        Button(){
                              
                        }label: {
                            Image("logohome")
                            
                        }
                        .onTapGesture {
                            NavigationView{
                                NavigationLink(destination: HomeView()){
                                    Image("logohome")
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("bar") .onTapGesture {
                            isSideBarOpened.toggle()
                        }
                    }
                }.navigationBarBackButtonHidden(true)
            MenuSlideView(isSidebarVisible: $isSideBarOpened)
        }.onAppear(perform: {
            self.giaDichVu = dichVuItem.gia!
            self.tenDichVu = dichVuItem.ten!
        })
    }
}


