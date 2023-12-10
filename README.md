### Make Firebase Code Easier
### 파이어베이스 코드를 더 쉽게 !

2023 / 12 / 9

version 1.0.0

You can use Firebase Firestore easier.

🅾️ Firestore
❌ Realtime Database ( Working on... )
❌ Storage (Working on... )

## Before
Firestore.firestore().collection("users").getDocuments...... 

## After
let users = try await ShawnyFirestore.fetchList(of: UserModel.self, path: "users")



### 1.  import ShawnyFirestore

### 2. use functions
- save
- fetch ( fetch Single Model )
- fetchList (fetch List of Model)

Model  < - Codable


