#ifndef AUTHHANDLER_H
#define AUTHHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMetaObject>
#include <QMetaEnum>

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
    void readDatabase();
    void errorHandle();
    void successHandle();

signals:
    void signedInSuccess();
    void signedUpSuccess();
    void signInError();
    void signUpError();

private:
    QString m_apiKey;
    QString m_uid;
    QString m_idToken;
    QString m_responeStatus;
    QString m_errorMessage;

    QNetworkAccessManager *m_networkAccessManager;
    QNetworkReply *m_networkReply;

    void post(const QString &url, const QJsonDocument &payLoad );
    void parseRespone(const QByteArray &respone);
    void handleResponeSuccess(QJsonObject &resObj);
    void handleResponeError(QJsonObject &errorObject);
};

#endif // AUTHHANDLER_H

