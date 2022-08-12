#include "authhandler.h"
#include <QVariantMap>

AuthHandler::AuthHandler(QObject *parent)
    : QObject{parent},
    m_apiKey( QString() )
{
    m_networkAccessManager = new QNetworkAccessManager( this );

}

AuthHandler::~AuthHandler()
{
    m_networkAccessManager->deleteLater();
}

void AuthHandler::setAPIKey(const QString &newAPIKey)
{
    if(m_apiKey == newAPIKey)
        return;
    m_apiKey = newAPIKey;
}

void AuthHandler::signUp(const QString &email, const QString &password)
{
    QString signUpEndPoint = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + m_apiKey;
    QVariantMap payLoadVariantMap;
    payLoadVariantMap["email"] = email;
    payLoadVariantMap["password"] = password;
    payLoadVariantMap["returnSecureToken"] = true;

    QJsonDocument jsonPayLoad = QJsonDocument::fromVariant(payLoadVariantMap);

    post( signUpEndPoint, jsonPayLoad );
}

bool AuthHandler::login(const QString &email, const QString &password)
{
    signIn( email, password );
    return m_responeStatus=="OK";
}

QString AuthHandler::getResponeCode()
{
    QString code = m_responeStatus;
    //    qDebug() << "QML can invoke: data in cpp: code: " << code;
    return code;
}

QString AuthHandler::getErrorMessage()
{
    return errorMessage();
}

const QString &AuthHandler::uid() const
{
    return m_uid;
}

void AuthHandler::setUid(const QString &newUid)
{
    m_uid = newUid;
}

void AuthHandler::signIn(const QString &email, const QString &password)
{
    QString signInEndPoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + m_apiKey;
    QVariantMap payLoadVariantMap;
    payLoadVariantMap["email"] = email;
    payLoadVariantMap["password"] = password;
    payLoadVariantMap["returnSecureToken"] = true;

    QJsonDocument jsonPayLoad = QJsonDocument::fromVariant(payLoadVariantMap);

    post( signInEndPoint, jsonPayLoad );
}

void AuthHandler::setErrorMessage(const QString &newErrorMessage)
{
    if(m_errorMessage == newErrorMessage)
        return;
    m_errorMessage = newErrorMessage;
}

QString AuthHandler::errorMessage()
{
    return m_errorMessage;
}

void AuthHandler::networkReplyReadyRead()
{
    QByteArray respone = m_networkReply->readAll();
    m_networkReply -> deleteLater ();

    parseRespone ( respone );
}

void AuthHandler::readDatabase()
{
    QString dataEndPoint = "https://comunitybackend-default-rtdb.asia-southeast1.firebasedatabase.app/Users.json?auth=" + m_idToken;
    m_networkReply = m_networkAccessManager->get ( QNetworkRequest(QUrl(dataEndPoint)));
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );
}

void AuthHandler::post(const QString &url, const QJsonDocument &payLoad)
{
    QNetworkRequest newRequest ( ( QUrl (url) ) );
    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString("application/json") );
    m_networkReply = m_networkAccessManager->post ( newRequest, payLoad.toJson() );
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );
}

void AuthHandler::parseRespone(const QByteArray &respone)
{
    QJsonDocument responeJsonDoc = QJsonDocument::fromJson( respone );
    QJsonObject responeObject = responeJsonDoc.object();
    if( responeObject.contains("kind")){
        handleResponeSuccess(responeObject);
    }
    else if ( responeObject.contains("error")) {
        QJsonObject errorObject = responeObject["error"].toObject();
        handleResponeError(errorObject);
    } else {
        qDebug() << "Retrive data from auth user: \n" << QJsonDocument::fromJson(respone);
    }
}

void AuthHandler::handleResponeSuccess(QJsonObject &resObj)
{
    connect(this, &AuthHandler::signedInSuccess, this, &AuthHandler::successHandle );
    connect(this, &AuthHandler::signedInSuccess, this, &AuthHandler::readDatabase );

    QString idToken = resObj["idToken"].toString();
    m_idToken = idToken;

    if(resObj.contains("registered"))
    {
        qDebug() << "Sign In Success" ;
        m_responeStatus = "OK";
        emit signedInSuccess();
    }
    else {
        qDebug() << "Sign Up Success" ;
        m_responeStatus = "OK";
        emit signedUpSuccess();
    }
}

void AuthHandler::handleResponeError(QJsonObject &errorObject)
{
    connect(this, &AuthHandler::signInError, this, &AuthHandler::errorHandle );

    QString message = errorObject["message"].toString();
//    qDebug() << "ErrorMessage: " << message;
    std::string str = message.toStdString();
    const char* p = str.c_str();
    QMetaEnum metaEnum = QMetaEnum::fromType<AuthHandler::ErrorCode>();
    auto errorCode = metaEnum.keyToValue(p);
    //    qDebug() << "ErrorCode: " << errorCode;
    m_responeStatus = message;
    switch(errorCode) {

        case EMAIL_EXISTS:
        {
//            qDebug() << "SIGN UP WITH EXISTS EMAIL, NOTIFY TO USER TO TRY ANOTHER EMAIL" ;
            emit signUpError();
            break;
        }

        case OPERATION_NOT_ALLOWED:
        {
//            qDebug() << "LOGIN EMAIL&PASSWORD DISABLE" ;
            emit signUpError();
            break;
        }

        case TOO_MANY_ATTEMPTS_TRY_LATER:
        {
//            qDebug() << "TOO MANY REQUEST OCCURED" ;
            emit signUpError();
            break;
        }

        case EMAIL_NOT_FOUND:
        {
//            qDebug() << "CAN NOT FIND THE EMAIL OF USER IN DATABASE" ;
            emit signInError();
            break;
        }

        case INVALID_PASSWORD:
        {
//            qDebug() << "USER ENTER WRONG PASSWORD" ;
            emit signInError();
            break;
        }
        case USER_DISABLED:
        {
//            qDebug() << "YOUR ACCOUNT HAS BEEN DISABLE BY ADMIN" ;
            emit signInError();
            break;
        }

        default:
            qDebug() << "another error" ;
    }
}

void AuthHandler::errorHandle()
{
    std::string responeMessage = m_responeStatus.toStdString();
    const char* key = responeMessage.c_str();
    QMetaEnum metaEnum = QMetaEnum::fromType<AuthHandler::ErrorCode>();
    auto errorCode = metaEnum.keyToValue(key);

    switch(errorCode) {

        case EMAIL_EXISTS:
        {
            setErrorMessage("Email has exists, please sign in!");
            qDebug() << "SIGN UP WITH EXISTS EMAIL, NOTIFY TO USER TO TRY ANOTHER EMAIL" ;
            break;
        }

        case OPERATION_NOT_ALLOWED:
        {
            setErrorMessage("Sorry, our policy disable login via email and password for a moment, please sign in with another type!");
            qDebug() << "LOGIN EMAIL&PASSWORD DISABLE" ;
            break;
        }

        case TOO_MANY_ATTEMPTS_TRY_LATER:
        {
             setErrorMessage("Sorry for interrupt your expirent, we detect you are spaming!\nPlease wait a little bit and try again");
            qDebug() << "TOO MANY REQUEST OCCURED" ;
            break;
        }

        case EMAIL_NOT_FOUND:
        {
            setErrorMessage("Sorry we can't find your account with these email, please try with correct email typing");
            qDebug() << "CAN NOT FIND THE EMAIL OF USER IN DATABASE" ;
            break;
        }

        case INVALID_PASSWORD:
        {
            setErrorMessage("Email or password incorrect, please check!");
            qDebug() << "USER ENTER WRONG PASSWORD" ;
            break;
        }
        case USER_DISABLED:
        {
            setErrorMessage("YOUR ACCOUNT HAS BEEN DISABLE BY ADMIN!");
            qDebug() << "YOUR ACCOUNT HAS BEEN DISABLE BY ADMIN" ;
            break;
        }

    }
}

void AuthHandler::successHandle()
{
    qDebug() << "auth.cpp:/ current code:" << m_responeStatus;
    qDebug() << "auth.cpp:/ user id token:" << m_idToken;
}

