### Make Firebase Code Easier
### 파이어베이스 코드를 더 쉽게 !

2023 / 12 / 9

version 1.0.0

You can use Firebase Firestore easier.

✅ Firestore   
✅ Storage  
❌ Realtime Database ( Working on... )   


## Before
Firestore.firestore().collection("users").getDocuments...... 

## After
let users = try await EZFirestore.fetchList(of: UserModel.self, path: "users")



### 1.  import EZFireStore

### 2. use functions

#### Firebase Firestore
- save
- fetch ( fetch Single Model )
- fetchList (fetch List of Model)

Model  < - Codable

#### Firebase Storage

- save (with Data)
- save (with UIImage)
- save (completion)


