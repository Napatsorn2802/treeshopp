//package com.example.treeshop

//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.android.FlutterFragmentActivity


//class MainActivity : FlutterFragmentActivity(){
//}

package com.example.treeshop

// *** IMPORT ที่ขาดหายไป: Bundle และ App Check Components ***
import android.os.Bundle
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.playintegrity.PlayIntegrityAppCheckProviderFactory
// *********************************************************

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity(){
    
    // onCreate ถูกเขียนทับอย่างถูกต้อง (ต้องมี Bundle? parameter)
    override fun onCreate(savedInstanceState: Bundle?) {
        // ต้องเรียก super.onCreate ก่อนเสมอ
        super.onCreate(savedInstanceState)
        
        // Initializing Firebase App Check
        FirebaseApp.initializeApp(this)
        val firebaseAppCheck = FirebaseAppCheck.getInstance()
        firebaseAppCheck.installAppCheckProviderFactory(
            PlayIntegrityAppCheckProviderFactory.getInstance()
        )
    }
}
