#-------------------------------------------------
#
# Project created by QtCreator 2015-04-23T13:23:33
#
#-------------------------------------------------

include( ../../FugioGlobal.pri )

QT += gui widgets

TARGET = $$qtLibraryTarget(fugio-fftw)
TEMPLATE = lib
CONFIG += plugin c++11

DESTDIR = $$DESTDIR/plugins

DEFINES += FFTW_LIBRARY

SOURCES += fftwplugin.cpp \
	fftnode.cpp

HEADERS += fftwplugin.h\
	../../include/fugio/nodecontrolbase.h \
	../../include/fugio/fftw/uuid.h \
	fftnode.h

TRANSLATIONS = \
	$$FUGIO_BASE/translations/fugio_fftw_de.ts \
	$$FUGIO_BASE/translations/fugio_fftw_es.ts \
	$$FUGIO_BASE/translations/fugio_fftw_fr.ts

#------------------------------------------------------------------------------
# OSX plugin bundle

macx {
	DEFINES += TARGET_OS_MAC
	CONFIG -= x86
	CONFIG += lib_bundle

	BUNDLEDIR    = $$DESTDIR/$$TARGET".bundle"
	INSTALLDEST  = $$INSTALLDATA/plugins
	INCLUDEDEST  = $$INSTALLDATA/include/fugio

	DESTDIR = $$BUNDLEDIR/Contents/MacOS
	DESTLIB = $$DESTDIR/"lib"$$TARGET".dylib"

	CONFIG(release,debug|release) {
		QMAKE_POST_LINK += echo

		LIBCHANGEDEST = $$DESTLIB

		QMAKE_POST_LINK += $$qtLibChange( QtWidgets )
		QMAKE_POST_LINK += $$qtLibChange( QtGui )
		QMAKE_POST_LINK += $$qtLibChange( QtCore )

		QMAKE_POST_LINK += && defaults write $$absolute_path( "Contents/Info", $$BUNDLEDIR ) CFBundleExecutable "lib"$$TARGET".dylib"

		isEmpty( CASKBASE ) {
			QMAKE_POST_LINK += && macdeployqt $$BUNDLEDIR -always-overwrite -no-plugins

			QMAKE_POST_LINK += $$libChange( libfftw3f.3.dylib )
		}

		plugin.path = $$INSTALLDEST
		plugin.files = $$BUNDLEDIR
		plugin.extra = rm -rf $$INSTALLDEST/$$TARGET".bundle"

		INSTALLS += plugin
	}
}

#------------------------------------------------------------------------------
# Windows

windows {
	INSTALLDIR   = $$INSTALLBASE/packages/com.bigfug.fugio
	INSTALLDEST  = $$INSTALLDIR/data/plugins/fftw

	CONFIG(release,debug|release) {
		QMAKE_POST_LINK += echo

		QMAKE_POST_LINK += & mkdir $$shell_path( $$INSTALLDEST )

		QMAKE_POST_LINK += & copy /V /Y $$shell_path( $$DESTDIR/$$TARGET".dll" ) $$shell_path( $$INSTALLDEST )

		win32 {
			 QMAKE_POST_LINK += & copy /V /Y $$shell_path( $$(LIBS)/fftw-3.3.5/libfftw3f-3.dll ) $$shell_path( $$INSTALLDEST )
		}

		win64 {
			 QMAKE_POST_LINK += & copy /V /Y $$shell_path( $$(LIBS)/fftw-3.3.5/libfftw3f-3.dll ) $$shell_path( $$INSTALLDEST )
		}
	}
}

#------------------------------------------------------------------------------
# Linux

unix:!macx {
	INSTALLDIR = $$INSTALLBASE/packages/com.bigfug.fugio

	contains( DEFINES, Q_OS_RASPBERRY_PI ) {
		target.path = Desktop/Fugio/plugins
	} else {
		target.path = $$shell_path( $$INSTALLDIR/data/plugins )
	}

	INSTALLS += target
}

#------------------------------------------------------------------------------
# API

INCLUDEPATH += $$PWD/../../include

#------------------------------------------------------------------------------

win32 {
	contains(QMAKE_CC, cl) {
		exists( $$(LIBS)/fftw-3.3.5 ) {
			INCLUDEPATH += $$(LIBS)/fftw-3.3.5

			LIBS += -L$$(LIBS)/fftw-3.3.5 -llibfftw3f-3

			DEFINES += FFTW_PLUGIN_SUPPORTED
		}
	}
}

macx:exists( /usr/local/opt/fftw ) {
	INCLUDEPATH += /usr/local/include

	LIBS += -L/usr/local/lib -lfftw3f

	DEFINES += FFTW_PLUGIN_SUPPORTED

} else:macx:exists( $$(LIBS)/fftw-3.3.5 ) {
	INCLUDEPATH += $$(LIBS)/fftw-3.3.5/api

	LIBS += $$(LIBS)/fftw-3.3.5/.libs/libfftw3f.a

	DEFINES += FFTW_PLUGIN_SUPPORTED
}

unix:!macx {
	exists( $$[QT_SYSROOT]/usr/include/fftw3.h ) {
		INCLUDEPATH += $$[QT_SYSROOT]/usr/include

		LIBS += -lfftw3f

		DEFINES += FFTW_PLUGIN_SUPPORTED

	} else:exists( /usr/include/fftw3.h ) {
		INCLUDEPATH += /usr/include

		LIBS += -lfftw3f

		DEFINES += FFTW_PLUGIN_SUPPORTED
	}
}

!contains( DEFINES, FFTW_PLUGIN_SUPPORTED ) {
   warning( "FFTW not supported" )
}

