package com.example.menubuilder

import android.app.PendingIntent
import android.content.Context
import android.os.Bundle
import android.os.Parcel
import android.os.Parcelable
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.auth.api.Auth
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.auth.api.signin.GoogleSignInResult
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.SignInButton
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.common.api.OptionalPendingResult
import com.google.android.gms.common.api.ResultCallback
import org.w3c.dom.Text
import java.lang.Exception


private const val SIGNED_IN = 0
private const val STATE_SIGNING_IN = 1
private const val STATE_IN_PROGRESS = 2
private const val RC_SIGN_IN = 0


class MainActivity() : AppCompatActivity(), View.OnClickListener, GoogleApiClient.ConnectionCallbacks,
        GoogleApiClient.OnConnectionFailedListener, ResultCallback<GoogleSignInResult> {

    private lateinit var mGoogleApiClient: GoogleApiClient
  //  private var mSignInProgress: Int = 0
    private lateinit var mSignInIntent: PendingIntent
    private lateinit var mSignInButton: SignInButton
    private lateinit var mSignOutButton: SignInButton
    private lateinit var mRevokeButton: SignInButton
    //private val mStatus: TextView = TextView(this)


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //удаляем панель с названием
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        getWindow().setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN
        )

        setContentView(R.layout.activity_main)

        //объявляем неизменяемую переменную, типа SignInButton (гугловская кнопка), привязываем их реальной кнопке на лейауте
        mSignInButton = findViewById(R.id.sign_in_button)
        //устанавливаем нужный текст на гугловской кнопке
        setGooglePlusButtonText(mSignInButton, getString(R.string.sign_in))

        mSignOutButton = findViewById(R.id.sign_out_button)
        setGooglePlusButtonText(mSignOutButton, getString(R.string.sign_out))

        mRevokeButton = findViewById(R.id.revoke_access_button)
        setGooglePlusButtonText(mRevokeButton, getString(R.string.revoke_access))

        mSignInButton.setOnClickListener(this)
        mSignOutButton.setOnClickListener(this)
        mRevokeButton.setOnClickListener(this)

        mGoogleApiClient = buildGoogleApiClient()

    }

    private fun buildGoogleApiClient(): GoogleApiClient {
        val gso: GoogleSignInOptions =
                GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestEmail().build()
        return GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
                .build()
    }

    //метод установки текста на гугловской кнопке типа SignInButton
    fun setGooglePlusButtonText(
            signInButton: SignInButton,
            buttonText: String?
    ) { // Найходит TextView, который находится внутри обьекта, типа SignInButton, и установливает текст,
        for (i in 0 until signInButton.childCount) {
            val v: View = signInButton.getChildAt(i)
            if (v is TextView) {
                val tv: TextView = v
                tv.text = buttonText
                return
            }
        }
    }

    override fun onStart() {
        super.onStart()
        mGoogleApiClient.connect()
    }

    override fun onStop() {
        mGoogleApiClient.disconnect()
        super.onStop()
    }

    override fun onClick(v: View?) {
    }

    override fun onConnected(p0: Bundle?) {
    }

/*
    override fun onConnected(connectionHint: Bundle?) {
        mSignInButton.isEnabled.not()
        mSignOutButton.isEnabled
        mRevokeButton.isEnabled

        mSignInProgress = SIGNED_IN

        var opr: OptionalPendingResult<GoogleSignInResult> =
                Auth.GoogleSignInApi.silentSignIn(mGoogleApiClient)
        opr.setResultCallback(ResultCallback<GoogleSignInResult>() {
           override fun onResult(result: GoogleSignInResult?) {
                if (result.isSuccess()) {
                    try {
                        val account: GoogleSignInAccount? = result.signInAccount
                        mStatus.setText(String.format("Signed In to My App as %s", account?.email))
                    } catch (ex: Exception) {
 