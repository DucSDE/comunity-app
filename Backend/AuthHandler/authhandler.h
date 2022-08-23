#ifndef AUTHHANDLER_H
#define AUTHHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QMetaObject>
#include <QMetaEnum>

#include "Backend/FireStoreHandler/FireStoreHandler.h"
#include "Backend/Model/User.h"

class AuthHandler : public QObject
{
    Q_OBJECT
public:
    explicit AuthHandler(QObject *parent = nullptr);
    ~AuthHandler();
    void setAPIKey(const QString &newAPIKey);
    void signUp(const QString &email, const QString &password);
    void signIn(const QString &email, const QString &password);
    void setErrorMessage(const QString &newErrorMessage);
    QString errorMessage();

    Q_INVOKABLE bool login(const QString &username, const QString &password);
    Q_INVOKABLE QString getResponeCode();
    Q_INVOKABLE QString getErrorMessage();

    enum ErrorCode : qint32 {
        EMAIL_EXISTS,
        OPERATION_NOT_ALLOWED,
        TOO_MANY_ATTEMPTS_TRY_LATER,
        EMAIL_NOT_FOUND,
        INVALID_PASSWORD,
        USER_DISABLED
    };
    Q_ENUM( ErrorCode );

    const QString &uid() const;
    void setUid(const QString &newUid);

public slots:
    void networkReplyReadyRead();
    void networkReplyReadyReadData();
    void readDatabase();
    void errorHandle();
    void successLogin(const User &userLogin);
    void userLogout(User &userLogout);

    void getUserDetail();
    void getAllUser();

public: signals:
    void signedInSuccess(const User &user);
    void getUserSuccess(const User &user);
    void signedUpSuccess(const User &);
    void signInError(const QString &errorMessage);
    void signUpError(const QString &errorMessage);

private:
    QString m_apiKey;
    QString m_uid;
    QString m_idToken;
    QString m_responeStatus;
    QString m_errorMessage;
    User m_user;
    //Network pointer
    QNetworkAccessManager *m_networkAccessManager;
    QNetworkReply *m_networkReply;

    void post(const QString &url, const QJsonDocument &payLoad );
    void get(const QString &url);
    void parseRespone(const QByteArray &respone);
    void parseResponeData(const QByteArray &respone);
    void handleResponeSuccess(const QJsonObject &resObj);
    void handleResponeError(const QJsonObject &errorObject);
    void parseJsonObject(const QJsonObject &object);
    void parseJsonArray(const QJsonArray &array);
    void parseJsonNull(const QJsonArray &array);

    FireStoreHandler fireStore;
};

#endif // AUTHHANDLER_H

