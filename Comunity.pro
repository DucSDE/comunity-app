QT += gui quick core5compat qml
QT += network

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        Backend/AuthHandler/authhandler.cpp \
        Backend/FireStoreHandler/FireStoreHandler.cpp \
        Backend/FireStoreHandler/LoadMessageHelper.cpp \
        Backend/Model/User.cpp \
        Backend/core/ComponentCreatorEngine.cpp \
        Backend/core/FileWatcher.cpp \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/../../../Qt/6.3.1/mingw_64/qml/Component
QML_IMPORT_PATH += $$PWD/../../../Qt/6.3.1/mingw_64/qml/QtQuick/Dialogs

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = $$PWD/../../../Qt/6.3.1/mingw_64/qml/Component
QML_DESIGNER_IMPORT_PATH += $$PWD/../../../Qt/6.3.1/mingw_64/qml/QtQuick/Dialogs
# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Backend/AuthHandler/authhandler.h \
    Backend/FireStoreHandler/FireStoreHandler.h \
    Backend/FireStoreHandler/LoadMessageHelper.h \
    Backend/Model/User.h \
    Backend/core/ComponentCreatorEngine.h \
    Backend/core/FileWatcher.h
