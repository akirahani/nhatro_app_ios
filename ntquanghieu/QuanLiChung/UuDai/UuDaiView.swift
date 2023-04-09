//
//  UuDaiView.swift
//  ntquanghieu
//
//  Created by Phạm Khải on 05/04/2023.
//

import SwiftUI

struct UuDaiView: View {
      @State var uuDaiModel = [UuDai]()
      @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
      @State private var isSideBarOpened = false
        
      @State var xoaThanhCong = false
      @State var alertUDDelShow = false
    
      var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image("back")
              }
          }
      }
      
      func loadDataUD() async {
            guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/uu-dai/list.php")
//            guard let url = URL(string: "http://192.168.0.104/nhatro/admin/api/uu-dai/list.php")

          else {
                print("Invalid URL")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                uuDaiModel = try JSONDecoder().decode([UuDai].self, from: data) // <-- here
            } catch {
                print(error)  // <-- important
            }
        }
      
      func delUD(parameters : [String: Any]) async {
            guard let url = URL(string: "http://192.168.1.183/nhatro/admin/api/uu-dai/del.php")
//            guard let url = URL(string: "http://192.168.0.104/nhatro/admin/api/uu-dai/del.php")
          
          else {
                return
            }
          
           let jsonData = try? JSONSerialization.data(withJSONObject: parameters ,options: .fragmentsAllowed)
           var request = URLRequest(url: url)
           
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Length")
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.httpBody = jsonData
                  
          URLSession.shared.dataTask(with: request) { data, response, error in

              if  error != nil{
                  print("Err delete uu dai")
                  return
              }
              //      call with JSON
             if let data = data {
                 let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]

                // Check if the login was successful
                if json["status"] as! String == "success" {
                    DispatchQueue.main.async {
                        self.xoaThanhCong = true
                    }
                    print("success delete UD")

                } else {
                    print("err delete UD")
                    self.alertUDDelShow = true
                }
            }
              
              if xoaThanhCong == true{
                  UuDaiView()
              }
          }.resume()
        }

    var body: some View {
        //
        ZStack{
           VStack{
               // tieu de dich vu
               ZStack{
                   HStack{
                       Image("uudai")
                       Text("Ưu đãi").textCase(.uppercase).foregroundColor(Color(hex: "#354B9C"))
                           .font(.system(size: 18, weight: .bold))
                       Spacer()
                       NavigationLink(destination: UuDaiAddView()){
                           Image("add").padding(.trailing,10)
                       }
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
                   .zIndex(2)
               // thong tin dich vu
               ScrollView{
                   ZStack{
                       VStack{
                           VStack{
                               HStack{
                                   Text("Tên").font(.system(size: 16, weight: .bold))
                                   Spacer()
                                   Text("Tình trạng").font(.system(size: 16, weight: .bold))
                                   Spacer()
                                   Text("Tác vụ").font(.system(size: 16, weight: .bold))
                               }.padding(.top, 16)
                                   .padding(.leading, 25)
                                   .padding(.trailing, 25)
                                   .padding(.bottom, 4)
                           }.background(Color.white)
                               .padding(.top,10)
                           
                           // danh sach uu dai
                           if #available(iOS 15.0, *) {
                               
                               VStack{
                                   ForEach(uuDaiModel) { model in
                                       HStack(spacing: 10){
                                           Text(model.ten ?? "").padding(.leading, 5)
                                           Spacer()
                                           if model.apdung == "0" {
                                               Text("Không áp dụng").foregroundColor(Color.init(hex: "DA2C2C"))
                                               
                                           }else{
                                               Text("Đang áp dụng").foregroundColor(Color.init(hex: "36CFD9"))
                                           }
                                           Spacer()
                                           HStack{
                                               NavigationLink(destination: UuDaiEditView(uuDaiItem :model)){
                                                   Image("edit")
                                               }
                                               
                                               // Xoá thiết bị
                                               Image("del").onTapGesture {
                                                   Task{
                                                       do {
                                                           let param : [String: Any] = ["id": model.idud]
                                                           try await delUD(parameters: param)
                                                       }
                                                       catch {
                                                           print(error)
                                                       }
                                                   }
                                               }.overlay(
                                                NavigationLink(destination: UuDaiView(), isActive : $xoaThanhCong){
                                                        EmptyView()
                                                }
                                               )
                                               
                                           }.padding(.trailing, 5)
                                       }
                                       .frame(width: .none, height: 44)
                                       .background(Color(hex: "E8EDFF"))
                                       .clipShape(RoundedRectangle(cornerRadius:10))
                                       .padding(.top, 4)
                                       .padding(.leading, 10)
                                       .padding(.trailing, 10)
                                       .padding(.bottom, 4)
                                   }
                               }
                               .task {
                                   await loadDataUD()
                               }
                           } else {
                               // Fallback on earlier versions
                           }
                       }
                       .padding(.bottom, 20)
                   }
                   .background(Color.white)
                   .padding(.top,20)
                  .zIndex(1)
               }
              
               Spacer()
           }.background(Color(hex: "#F2F1F6"))
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

struct UuDai: Identifiable, Codable{
    let id = UUID()
    var idud: String?
    var ten: String?
    var apdung: String?
    var songay: String?
    var phong: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case idud = "id"
        case ten = "ten"
        case apdung = "apdung"
        case songay = "so"
        case phong = "phong"
        case status = "status"
    }

}
struct UuDaiView_Previews: PreviewProvider {
    static var previews: some View {
        UuDaiView()
    }
}
