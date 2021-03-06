# - Try to find ARToolKit-library
# Once done this will define
#
#  ARTOOLKIT_INCLUDE_DIR    - where to find ARToolKit.h, etc.
#  ARTOOLKIT_INCLUDE_DIRS   - same as above (uncached version)
#  ARTOOLKIT_LIBRARIES      - list of libraries when using ARToolKit.
#  ARTOOLKIT_DEFINITIONS    - use ADD_DEFINITIONS(${ARTOOLKIT_DEFINITIONS})
#  ARTOOLKIT_FOUND          - True if ARToolKit was found.

IF(ARTOOLKIT_INCLUDE_DIR)
  SET(ARTOOLKIT_FIND_QUIETLY TRUE)
ENDIF(ARTOOLKIT_INCLUDE_DIR)

set( ARTOOLKIT5_LIBS $ENV{ARTOOLKIT5_ROOT}/lib )

IF( WIN32 )
if (CMAKE_SIZEOF_VOID_P EQUAL 8)
	set( ARTOOLKIT5_LIBS ${ARTOOLKIT5_LIBS}/win64-x64 )
else ()
	set( ARTOOLKIT5_LIBS ${ARTOOLKIT5_LIBS}/win32-i386 )
endif ()
ENDIF()

FIND_PATH(ARTOOLKIT_INCLUDE_DIR AR/ar.h
   PATHS
   $ENV{ARTOOLKIT_HOME}/include
   $ENV{EXTERNLIBS}/ARToolKit/include
   $ENV{ARTOOLKIT5_ROOT}/include
   /usr/local/include
   /usr/include
   DOC "ARToolKit - Headers"
   NO_DEFAULT_PATH
)
MARK_AS_ADVANCED(ARTOOLKIT_INCLUDE_DIR)

IF (MSVC)
    # check whether this is a /MT(d) build
    STRING(REGEX MATCH "[mM][tT][dD]" MTD_COMPILE_OPTION ${CMAKE_C_FLAGS_DEBUG})
    IF (MTD_COMPILE_OPTION)
      MESSAGE("Using static MS-Runtime !!!")
      FIND_LIBRARY(ARTOOLKIT_LIBRARY_DEBUG NAMES ARToolKitd_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_LIBRARY_RELEASE NAMES ARToolKit_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
    ELSE (MTD_COMPILE_OPTION)
      FIND_LIBRARY(ARTOOLKIT_LIBRARY_DEBUG NAMES ARToolKitd ARToolKit-staticd libARToolKitd
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_LIBRARY_RELEASE NAMES ARToolKit ARToolKit-static libARToolKit
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
    ENDIF (MTD_COMPILE_OPTION)

    IF(MSVC_IDE)
      IF (ARTOOLKIT_LIBRARY_DEBUG AND ARTOOLKIT_LIBRARY_RELEASE)
         SET(ARTOOLKIT_LIBRARIES optimized ${ARTOOLKIT_LIBRARY_RELEASE} debug ${ARTOOLKIT_LIBRARY_DEBUG})
      ELSE (ARTOOLKIT_LIBRARY_DEBUG AND ARTOOLKIT_LIBRARY_RELEASE)
         SET(ARTOOLKIT_LIBRARIES NOTFOUND)
         MESSAGE(STATUS "Could not find the debug AND release version of ARToolKit")
      ENDIF (ARTOOLKIT_LIBRARY_DEBUG AND ARTOOLKIT_LIBRARY_RELEASE)
    ELSE(MSVC_IDE)
      STRING(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)
      IF(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
         SET(ARTOOLKIT_LIBRARIES ${ARTOOLKIT_LIBRARY_DEBUG})
      ELSE(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
         SET(ARTOOLKIT_LIBRARIES ${ARTOOLKIT_LIBRARY_RELEASE})
      ENDIF(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
    ENDIF(MSVC_IDE)
    MARK_AS_ADVANCED(ARTOOLKIT_LIBRARY_DEBUG ARTOOLKIT_LIBRARY_RELEASE)
    
    # try to figure out whether we are using an "import-lib"
    STRING(REGEX MATCH "_[iI].[lL][iI][bB]$" ARTOOLKIT_USING_IMPORT_LIB "${ARTOOLKIT_LIBRARY_RELEASE}")
    IF(ARTOOLKIT_USING_IMPORT_LIB)
      SET(ARTOOLKIT_DEFINITIONS -DARTOOLKIT_USE_DLL)
    ELSE(ARTOOLKIT_USING_IMPORT_LIB)
      SET(ARTOOLKIT_DEFINITIONS -DARTOOLKIT_STATIC)
    ENDIF(ARTOOLKIT_USING_IMPORT_LIB)
ELSE (MSVC)
  
  SET(ARTOOLKIT_NAMES ${ARTOOLKIT_NAMES} ARToolKit libARToolKit)
  FIND_LIBRARY(ARTOOLKIT_LIBRARY NAMES ${ARTOOLKIT_NAMES}
    PATHS
    $ENV{ARTOOLKIT_HOME}/lib
    $ENV{EXTERNLIBS}/ARToolKit/lib
	${ARTOOLKIT5_LIBS}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ARTOOLKIT_LIBRARY NAMES ${ARTOOLKIT_NAMES})
  MARK_AS_ADVANCED(ARTOOLKIT_LIBRARY)
  
ENDIF (MSVC)

IF (NOT ARTOOLKIT_LIBRARIES)
IF (MSVC)
    # check whether this is a /MT(d) build
    STRING(REGEX MATCH "[mM][tT][dD]" MTD_COMPILE_OPTION ${CMAKE_C_FLAGS_DEBUG})
    IF (MTD_COMPILE_OPTION)
      MESSAGE("Using static MS-Runtime !!!")
      FIND_LIBRARY(ARTOOLKIT_AR_LIBRARY_DEBUG NAMES ARD_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_AR_LIBRARY_RELEASE NAMES AR_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_ARGSUB_LIBRARY_DEBUG NAMES ARgsubD_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
      FIND_LIBRARY(ARTOOLKIT_ARGSUB_LIBRARY_RELEASE NAMES ARgsub_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
      FIND_LIBRARY(ARTOOLKIT_ARVIDEO_LIBRARY_DEBUG NAMES ARvideoD_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_ARGVIDEO_LIBRARY_RELEASE NAMES ARvideo_mt
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
    ELSE (MTD_COMPILE_OPTION)
      MESSAGE("Using dynamic MS-Runtime !!!")
      FIND_LIBRARY(ARTOOLKIT_AR_LIBRARY_DEBUG NAMES ARD AR-staticd
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
      FIND_LIBRARY(ARTOOLKIT_AR_LIBRARY_RELEASE NAMES AR AR-static
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
      FIND_LIBRARY(ARTOOLKIT_ARGSUB_LIBRARY_DEBUG NAMES ARgsubD ARgsub-staticd
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
      FIND_LIBRARY(ARTOOLKIT_ARGSUB_LIBRARY_RELEASE NAMES ARgsub ARgsub-static
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_ARVIDEO_LIBRARY_DEBUG NAMES ARvideoD ARvideo-staticd
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
      FIND_LIBRARY(ARTOOLKIT_ARVIDEO_LIBRARY_RELEASE NAMES ARvideo ARvideo-static
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
		${ARTOOLKIT5_LIBS}
      )
       FIND_LIBRARY(ARTOOLKIT_ARICP_LIBRARY_DEBUG NAMES ARICPD ARICP-staticd
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
 		${ARTOOLKIT5_LIBS}
     )
     FIND_LIBRARY(ARTOOLKIT_ARICP_LIBRARY_RELEASE NAMES ARICP ARICP-static
        PATHS
        $ENV{ARTOOLKIT_HOME}/lib
        $ENV{EXTERNLIBS}/ARToolKit/lib
  		${ARTOOLKIT5_LIBS}
    )
   ENDIF (MTD_COMPILE_OPTION)

    IF(MSVC_IDE)
      IF (ARTOOLKIT_AR_LIBRARY_DEBUG AND ARTOOLKIT_AR_LIBRARY_RELEASE)
         SET(ARTOOLKIT_LIBRARIES optimized ${ARTOOLKIT_ARICP_LIBRARY_RELEASE} optimized ${ARTOOLKIT_ARGSUB_LIBRARY_RELEASE} optimized ${ARTOOLKIT_ARVIDEO_LIBRARY_RELEASE} optimized ${ARTOOLKIT_AR_LIBRARY_RELEASE} debug ${ARTOOLKIT_ARICP_LIBRARY_DEBUG} debug ${ARTOOLKIT_ARGSUB_LIBRARY_DEBUG} debug ${ARTOOLKIT_ARVIDEO_LIBRARY_DEBUG} debug ${ARTOOLKIT_AR_LIBRARY_DEBUG})
      ELSE (ARTOOLKIT_AR_LIBRARY_DEBUG AND ARTOOLKIT_AR_LIBRARY_RELEASE)
         SET(ARTOOLKIT_LIBRARIES NOTFOUND)
         MESSAGE(STATUS "Could not find the debug AND release version of ARToolKit")
      ENDIF (ARTOOLKIT_AR_LIBRARY_DEBUG AND ARTOOLKIT_AR_LIBRARY_RELEASE)
    ELSE(MSVC_IDE)
      STRING(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)
      IF(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
         SET(ARTOOLKIT_LIBRARIES ${ARTOOLKIT_ARGSUB_LIBRARY_DEBUG} ${ARTOOLKIT_ARICP_LIBRARY_DEBUG} ${ARTOOLKIT_ARVIDEO_LIBRARY_DEBUG} ${ARTOOLKIT_AR_LIBRARY_DEBUG})
      ELSE(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
         SET(ARTOOLKIT_LIBRARIES ${ARTOOLKIT_ARGSUB_LIBRARY_RELEASE} ${ARTOOLKIT_ARICP_LIBRARY_RELEASE} ${ARTOOLKIT_ARVIDEO_LIBRARY_RELEASE} ${ARTOOLKIT_AR_LIBRARY_RELEASE})
      ENDIF(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
    ENDIF(MSVC_IDE)
    MARK_AS_ADVANCED(ARTOOLKIT_ARGSUB_LIBRARY_DEBUG ARTOOLKIT_ARICP_LIBRARY_DEBUG ARTOOLKIT_ARVIDEO_LIBRARY_DEBUG ARTOOLKIT_AR_LIBRARY_DEBUG ARTOOLKIT_ARICP_LIBRARY_RELEASE ARTOOLKIT_ARGSUB_LIBRARY_RELEASE ARTOOLKIT_ARVIDEO_LIBRARY_RELEASE ARTOOLKIT_AR_LIBRARY_RELEASE)
    
    #MESSAGE("ARTOOLKIT_DEFINITIONS = ${ARTOOLKIT_DEFINITIONS}")

ELSE (MSVC)
  FIND_LIBRARY(ARTOOLKIT_DV_LIBRARY NAMES libdv.so libdv.a
    PATHS
    $ENV{EXTERNLIBS}/ARToolKit/lib
    $ENV{ARTOOLKIT_HOME}/lib
	${ARTOOLKIT5_LIBS}
 )
  FIND_LIBRARY(ARTOOLKIT_DC1394_LIBRARY NAMES libdc1394.so
    PATHS
    $ENV{EXTERNLIBS}/ARToolKit/lib
    $ENV{ARTOOLKIT_HOME}/lib
	${ARTOOLKIT5_LIBS}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ARTOOLKIT_RAW1394_LIBRARY NAMES libraw1394.so
    PATHS
    $ENV{EXTERNLIBS}/ARToolKit/lib
    $ENV{ARTOOLKIT_HOME}/lib
	${ARTOOLKIT5_LIBS}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ARTOOLKIT_AR_LIBRARY NAMES libAR.a
    PATHS
    $ENV{EXTERNLIBS}/ARToolKit/lib
    $ENV{ARTOOLKIT_HOME}/lib
	${ARTOOLKIT5_LIBS}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ARTOOLKIT_ARGSUB_LIBRARY NAMES libARgsub.a
    PATHS
    $ENV{ARTOOLKIT_HOME}/lib
    $ENV{EXTERNLIBS}/ARToolKit/lib
	${ARTOOLKIT5_LIBS}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ARTOOLKIT_ARVIDEO_LIBRARY NAMES libARvideo.a
    PATHS
    $ENV{ARTOOLKIT_HOME}/lib
    $ENV{EXTERNLIBS}/ARToolKit/lib
	${ARTOOLKIT5_LIBS}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ARTOOLKIT_ARICP_LIBRARY NAMES libARICP.a
    PATHS
    $ENV{ARTOOLKIT_HOME}/lib
    $ENV{EXTERNLIBS}/ARToolKit/lib
 	${ARTOOLKIT5_LIBS}
   NO_DEFAULT_PATH
  )

  MARK_AS_ADVANCED(ARTOOLKIT_AR_LIBRARY ARTOOLKIT_ARGSUB_LIBRARY
     ARTOOLKIT_ARICP_LIBRARY ARTOOLKIT_ARVIDEO_LIBRARY ARTOOLKIT_DC1394_LIBRARY
     ARTOOLKIT_RAW1394_LIBRARY ARTOOLKIT_DV_LIBRARY)
  
ENDIF (MSVC)
ENDIF (NOT ARTOOLKIT_LIBRARIES)

INCLUDE(FindPackageHandleStandardArgs)
IF(MSVC)
  IF(ARTOOLKIT_LIBRARY_RELEASE)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(ARTOOLKIT DEFAULT_MSG ARTOOLKIT_LIBRARY_RELEASE ARTOOLKIT_LIBRARY_DEBUG ARTOOLKIT_ARICP_LIBRARY_RELEASE ARTOOLKIT_ARICP_LIBRARY_DEBUG ARTOOLKIT_INCLUDE_DIR)
  ELSE(ARTOOLKIT_LIBRARY_RELEASE)
     FIND_PACKAGE_HANDLE_STANDARD_ARGS(ARTOOLKIT DEFAULT_MSG ARTOOLKIT_AR_LIBRARY_RELEASE ARTOOLKIT_AR_LIBRARY_DEBUG ARTOOLKIT_ARICP_LIBRARY_RELEASE ARTOOLKIT_ARICP_LIBRARY_DEBUG ARTOOLKIT_ARGSUB_LIBRARY_RELEASE ARTOOLKIT_ARGSUB_LIBRARY_DEBUG ARTOOLKIT_ARVIDEO_LIBRARY_RELEASE ARTOOLKIT_ARVIDEO_LIBRARY_DEBUG ARTOOLKIT_INCLUDE_DIR)
  ENDIF(ARTOOLKIT_LIBRARY_RELEASE)
ELSE(MSVC)
  IF(ARTOOLKIT_LIBRARY)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(ARTOOLKIT DEFAULT_MSG ARTOOLKIT_LIBRARY ARTOOLKIT_INCLUDE_DIR)
    IF(ARTOOLKIT_FOUND)
      SET(ARTOOLKIT_LIBRARIES
        ${ARTOOLKIT_LIBRARY} ${ARTOOLKIT_ARICP_LIBRARY} ${ARTOOLKIT_DC1394_LIBRARY}
        ${ARTOOLKIT_RAW1394_LIBRARY} ${ARTOOLKIT_DV_LIBRARY})
    ENDIF()
  ELSE(ARTOOLKIT_LIBRARY)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(ARTOOLKIT DEFAULT_MSG ARTOOLKIT_AR_LIBRARY
      ARTOOLKIT_ARGSUB_LIBRARY ARTOOLKIT_ARICP_LIBRARY ARTOOLKIT_ARVIDEO_LIBRARY ARTOOLKIT_INCLUDE_DIR
      ARTOOLKIT_DC1394_LIBRARY ARTOOLKIT_RAW1394_LIBRARY
      ARTOOLKIT_DV_LIBRARY)
    IF(ARTOOLKIT_FOUND)
      SET(ARTOOLKIT_LIBRARIES
        ${ARTOOLKIT_AR_LIBRARY} ${ARTOOLKIT_ARGSUB_LIBRARY} ${ARTOOLKIT_ARICP_LIBRARY}
        ${ARTOOLKIT_ARVIDEO_LIBRARY} ${ARTOOLKIT_DC1394_LIBRARY}
        ${ARTOOLKIT_RAW1394_LIBRARY} ${ARTOOLKIT_DV_LIBRARY})
    ENDIF()
  ENDIF(ARTOOLKIT_LIBRARY)
ENDIF(MSVC)
