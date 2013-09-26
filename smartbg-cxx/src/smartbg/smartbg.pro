#-------------------------------------------------
#
# Project created by QtCreator 2013-09-04T21:15:59
#
#-------------------------------------------------

TARGET = smartbg
TEMPLATE = lib

DEFINES += SMARTBG_LIBRARY

SOURCES += detector.cpp

HEADERS += detector.h\
        smartbg_global.h

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}
