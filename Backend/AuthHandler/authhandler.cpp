#include "authhandler.h"
#include <QVariantMap>

AuthHandler::AuthHandler(QObject *parent)
    : QObject{parent},
    m_apiKey( QString() )
{
    m_networkAccessManager = new QNetworkAccessManager( this );

    connect(this, &AuthHandler::signedInSuccess, this, &AuthHandler::getUserDetail );

//    connect(this, &AuthHandler::signedInSuccess, this, &AuthHandler::getAllUser );
    //    connect(this, &AuthHandler::signedInSuccess, this, &AuthHandler::readDatabase );
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


// Q_INVOKABLE function
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

// END Q_INVOKABLE function

// GETTER SETTER Message and UID
const QString &AuthHandler::uid() const
{
    return m_uid;
}

void AuthHandler::setUid(const QString &newUid)
{
    m_uid = newUid;
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
//END GETTER SETTER Message and UID

void AuthHandler::networkReplyReadyRead()
{
    QByteArray respone = m_networkReply->readAll();
    m_networkReply -> deleteLater ();
    parseRespone ( respone );
}

void AuthHandler::networkReplyReadyReadData()
{
    QByteArray respone = m_networkReply->readAll();
    m_networkReply -> deleteLater ();
    parseResponeData ( respone );
}

void AuthHandler::readDatabase()
{
    qDebug() << "connect readDatabase slot";
    QString dataEndPoint = "https://comunitybackend-default-rtdb.asia-southeast1.firebasedatabase.app/Users.json?auth=" + m_idToken;
    m_networkReply = m_networkAccessManager->get ( QNetworkRequest(QUrl(dataEndPoint)));
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyReadData );
}

//PRIVATE FUNCTION
void AuthHandler::post(const QString &url, const QJsonDocument &payLoad)
{
    QNetworkRequest newRequest ( ( QUrl (url) ) );
    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString("application/json") );
    m_networkReply = m_networkAccessManager->post ( newRequest, payLoad.toJson() );
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyRead );
}

void AuthHandler::get(const QString &url)
{
    QNetworkRequest newRequest ( ( QUrl (url) ) );
    newRequest.setHeader( QNetworkRequest::ContentTypeHeader, QString("application/json") );
    m_networkReply = m_networkAccessManager->get ( newRequest);
    connect( m_networkReply, &QNetworkReply::readyRead, this, &AuthHandler::networkReplyReadyReadData );
}

void AuthHandler::parseRespone(const QByteArray &respone)
{
    qDebug() << "In Parse respone:" ;
    QJsonDocument responeJsonDoc = QJsonDocument::fromJson( respone );
    bool isObject = responeJsonDoc.isObject();
    //when respone is object
    if(isObject){
        qDebug() <<"Receive data is an object" ;
        QJsonObject responeObject = responeJsonDoc.object();
        parseJsonObject(responeObject);
    }
    //when respone data is an array

}

void AuthHandler::parseJsonObject(const QJsonObject &object)
{
    if( object.contains("kind")){
        //sign in or sign up success
        handleResponeSuccess(object);
        return;
    }
    if ( object.contains("error")) {
        QJsonObject errorObject = object["error"].toObject();
        handleResponeError(errorObject);
        return;
    }
}

void AuthHandler::parseResponeData(const QByteArray &respone)
{
    connect(this, &AuthHandler::getUserSuccess, &fireStore, &FireStoreHandler::setUser );
    QJsonDocument responeJsonDoc = QJsonDocument::fromJson( respone );
    bool isEmpty = responeJsonDoc.isEmpty();
    bool isNull = responeJsonDoc.isNull();
    if(isEmpty || isNull)
    {
        qDebug() << "data respone is empty" ;
        if (isNull){
            qDebug() <<"Receive null data / check query " ;
        }
        return;
    }
    else {
        //else data get success
        bool isObject = responeJsonDoc.isObject();
        bool isArray = responeJsonDoc.isArray();

        if(isObject){
            QJsonObject responeDataObject = responeJsonDoc.object();
            if (responeDataObject.contains("documents")) {
                //get all document of collection
                qDebug() << "data respone is a documents" ;
                qDebug() << "receive data get from all user" ;
                qDebug() << "Retrive data from firestore: \n" << responeDataObject;
                return;
            }
            if(responeDataObject.contains("name") && responeDataObject.contains("fields")){
                //get user info
                qDebug() << "receive data get specify user id:" ;
                QJsonObject fields = responeDataObject["fields"].toObject();
                qDebug() << "Retrive data from firestore fields \n";
                QList<QString> groups;
                QJsonArray jsonArray = fields["groups"].toObject().value("arrayValue").toObject().value("values").toArray();
                for(int i = 0; i < jsonArray.size(); i ++){
                    groups.append(jsonArray[i].toObject().value("stringValue").toString());
                }

                m_user.setDisplayName(fields["displayName"].toObject().value("stringValue").toString());
                m_user.setDoB(fields["dob"].toObject().value("timestampValue").toString());
                m_user.setLastOnline(fields["lastOnline"].toObject().value("stringValue").toString());
                m_user.setPhotoURL(fields["photoURL"].toObject().value("stringValue").toString());
                m_user.setGroups(groups);
                emit getUserSuccess(m_user);
                return;
            }
        }

        if(isArray){
            qDebug() <<"Receive data is an array" ;
            QJsonArray responeDataArray = responeJsonDoc.array();
            qDebug() <<"Receive data from realtime database with user.json and auth key with idToken" ;
            qDebug() << "Receive data from in slot readDatabase: \n" << responeDataArray;
        }
    }



}

void AuthHandler::handleResponeSuccess(const QJsonObject &resObj)
{
    qDebug()<<"In Sign In / Sign Up Success";
    QString idToken = resObj["idToken"].toString();
    m_idToken = idToken;
    if(resObj.contains("registered"))
    {
        qDebug() << "Sign In Success" ;
        m_responeStatus = "OK";
        QString UID = resObj["localId"].toString();
        QString displayName = resObj["displayName"].toString();
        QString email = resObj["email"].toString();
        QString photoURL = resObj["photoURL"].toString();
        QString dob = resObj["dob"].toString();
        QList<QString> groups((QList<QString>()));
        QString lastOnline = resObj["lastOnline"].toString();
        const User userLogin(UID,displayName, email, photoURL, dob, groups, lastOnline);
        m_user = userLogin;

        emit signedInSuccess(m_user);
    }
    else {
        qDebug() << "Sign Up Success" ;
        m_responeStatus = "OK";
        const User newUserSignUp;
        emit signedUpSuccess(newUserSignUp);
    }
}

void AuthHandler::handleResponeError(const QJsonObject &errorObject)
{
    connect(this, &AuthHandler::signInError, this, &AuthHandler::errorHandle );

    QString message = errorObject["message"].toString();
    qDebug() << "ErrorMessage: " << message;
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
        emit signUpError(message);
        break;
    }

    case OPERATION_NOT_ALLOWED:
    {
        //            qDebug() << "LOGIN EMAIL&PASSWORD DISABLE" ;
        emit signUpError(message);
        break;
    }

    case TOO_MANY_ATTEMPTS_TRY_LATER:
    {
        //            qDebug() << "TOO MANY REQUEST OCCURED" ;
        emit signUpError(message);
        break;
    }

    case EMAIL_NOT_FOUND:
    {
        //            qDebug() << "CAN NOT FIND THE EMAIL OF USER IN DATABASE" ;
        emit signInError(message);
        break;
    }

    case INVALID_PASSWORD:
    {
        //            qDebug() << "USER ENTER WRONG PASSWORD" ;
        emit signInError(message);
        break;
    }
    case USER_DISABLED:
    {
        //            qDebug() << "YOUR ACCOUNT HAS BEEN DISABLE BY ADMIN" ;
        emit signInError(message);
        break;
    }

    default:
        qDebug() << "another error" ;
    }
}


//END PRIVATE FUNCTION

//PUBLIC FUNTION
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

void AuthHandler::successLogin(const User &userLogin)
{
    Q_UNUSED(userLogin);
    qDebug() << "auth.cpp:/ current code:" << m_responeStatus;
}

void AuthHandler::userLogout(User &userLogout)
{
    Q_UNUSED(userLogout);
    m_user = User();
}

void AuthHandler::getUserDetail()
{
    qDebug() << "connect get specify user id";
    QString dataEndPoint = "https://firestore.googleapis.com/v1/projects/comunitybackend/databases/(default)/documents/user_info/" + m_user.UID();
    get ( dataEndPoint );
}

void AuthHandler::getAllUser()
{
    qDebug() << "connect get ALL user slot";
    QString dataEndPoint = "https://firestore.googleapis.com/v1/projects/comunitybackend/databases/(default)/documents/user_info/";
    get ( dataEndPoint );

}

//END PUBLIC FUNTION
