package com.toras.eight_barrels
import java.util.Timer
import kotlin.concurrent.schedule
import android.content.Context
import androidx.annotation.NonNull
import com.xendit.AuthenticationCallback
import com.xendit.Models.Authentication
import com.xendit.Models.Card
import com.xendit.Models.Token
import com.xendit.Models.XenditError
import com.xendit.TokenCallback
import com.xendit.Xendit
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(), FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel

    private var mContext: Context? = null

    private var tokenId: String = ""



    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel =  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "bottle.union/xendit")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        mContext = flutterPluginBinding.applicationContext;
//        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bottle.union/xendit")
//        channel.setMethodCallHandler(this)
    }


 

    private fun createAuthentification(call: MethodCall, result: MethodChannel.Result) {
        // If using EMV 3DS (3DS 2.0), please send the activity in the constructor,

        val xendit = Xendit(this, "xnd_public_production_B99eGILsUL9tW8iYaJ7GNu0Mhec12HA6QYtJJv6Yj3oefkwnDYJ7u0Q3WSvKholc", activity)
        val tokenId = "6422702d25ceea00198b386d"
        val amount = 75000

        xendit.createAuthentication(tokenId, amount, "IDR", object : AuthenticationCallback() {
            override fun onSuccess(authentication: Authentication) {
                // Handle successful authentication
                println("Authentication ID: " + authentication.id)

                result.success(authentication.id)
            }

            override fun onError(xenditError: XenditError?) {
                result.error("Failed",xenditError?.errorMessage,null)
            }
        })
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivityForConfigChanges() {
        channel.setMethodCallHandler(null);
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        channel.setMethodCallHandler(null);
    }



    private fun xenditCreateToken(call: MethodCall, result: MethodChannel.Result) {
        System.out.println("metode ini xenditCreateToken");
        System.out.println(call.arguments);


     
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        System.out.println("Apkah kepanggil?");
        if (call.method == "xenditCreateToken") {
            val argument = call.arguments as Map<*, *> ;
            val xendit = Xendit(this, "xnd_public_production_B99eGILsUL9tW8iYaJ7GNu0Mhec12HA6QYtJJv6Yj3oefkwnDYJ7u0Q3WSvKholc", activity)
            System.out.println(argument["card_number"] as String?);
            val card = Card(argument["card_number"] as String?, argument["exp_month"] as String?, argument["exp_year"] as String?, argument["cvn"] as String?)
    
            xendit.createSingleUseToken(card, 75000, object : TokenCallback() {
                override fun onSuccess(token: Token) {
                    // Handle successful tokenization

                    Timer().schedule(100) { 
                       result.success("ini bisa")
                     }
    
                    // 
                    // result.success(tokenId)
                }
    
                override fun onError(xenditError: XenditError) {
                    System.out.println("ERROR XENDIT: " + xenditError.errorMessage);

                    result.error("FAILED",xenditError.errorMessage,null)

                }
            })
        }
        if (call.method == "xenditCreateAuthentication") {
            createAuthentification(call, result)
        }
        else {
            result.notImplemented()
        }
    }

     fun setTokenId(tokenId: String,result: MethodChannel.Result) {
       result.success(tokenId)
    }
}