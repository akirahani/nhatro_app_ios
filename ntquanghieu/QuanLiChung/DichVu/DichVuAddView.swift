//
//  DichVuAddView.swift
//  ntquanghieu
//
//  Created by Phạm Khải on 02/04/2023.
//

import SwiftUI

struct DichVuAddView: View {
    @State var thietBiModel = [ThietBi]()
    @State var getDichVu = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSideBarOpened = false
    
    @State private var tenDichVu: String = ""
    @State private var giaDichVu: String = ""
    @State var gotConfig = false
    @State var themDichVuThanhCong = false
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        isSideBarOpened = true
        }) {
            HStack {
                Image("back")
            }
        }
    }
    
    func addThietBi() async throws {

       guard let urlAddTB =  URL(string:"http://192.168.1.183/nhatro/admin/api/thiet-bi/add.php")
//       guard let urlAddTB =  URL(string:"http://192.168.1.104/nhatro/admin/api/thiet-bi/add.php")
        
        else { return }

        let body: [String: Any] = ["ten": tenDichVu, "gia": giaDichVu]
        let jsonData = try? JSONSerialization.data(withJSONObject: body,options: .fragmentsAllowed)
        var request = URLRequest(url: urlAddTB)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
               
       URLSession.shared.dataTask(with: request) { data, response, error in

           guard let data = data, error == nil else {
               return
           }
           
           do{
               let responseJSON = try? JSONDecoder().decode([ThietBi].self ,from: data )
               themDichVuThanhCong = true
           }
           catch{
               print(error)
           }
           
           if(themDichVuThanhCong == true){
                DichVuView()
           }else{
               DichVuAddView()
           }
           
       }.resume()
    }
    
    func fetchData() async {
        
    }
   
    var body: some View {
        ZStack{
            VStack{
                // tieu de dich vu
                ZStack{
                    HStack{
                        Image("dichvu")
                        Text("Thêm mới dịch vụ").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
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
                // them dich vu
                
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
                                           try await addThietBi()
                                        }
                                       catch {
                                           print(error)
                                       }
                                    }
                                }
                                label:{
                                    Text("Thêm mới")
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        .padding(.leading, 44)
                                        .padding(.trailing ,44)
                                }
                                .overlay{
                                    NavigationLink(destination: DichVuView(), isActive: $themDichVuThanhCong){
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
                        Image("logohome")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image("bar") .onTapGesture {
                            isSideBarOpened.toggle()
                        }
                    }
                }.navigationBarBackButtonHidden(true)
            MenuSlideView(isSidebarVisible: $isSideBarOpened)
        }
    }
}

struct DichVuAddView_Previews: PreviewProvider {
    static var previews: some View {
        DichVuAddView()
    }
}
