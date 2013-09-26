#ifndef SMARTBG_GLOBAL_H
#define SMARTBG_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(SMARTBG_LIBRARY)
#  define SMARTBGSHARED_EXPORT Q_DECL_EXPORT
#else
#  define SMARTBGSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // SMARTBG_GLOBAL_H
