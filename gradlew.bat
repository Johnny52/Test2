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
    private var mSignInProgress: Int = 0
    private lateinit var mSignInIntent: PendingIntent
    private lateinit var mSignInButton: SignInButton
    private lateinit var mSignOutButton: SignInButton
    private lateinit var mRevokeButton: SignInButton
    private val mStatus: TextView = TextView(this)


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //удаляем панель с названием
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        getWindow().setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN
        )

        setContentView(R.layout.activity_main)

        //объявляем неизменяемую переменную, типа SignInButton (гу