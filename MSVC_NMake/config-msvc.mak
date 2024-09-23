# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building glibmm.
!ifndef INCLUDEDIR
INCLUDEDIR = $(PREFIX)\include
!endif
!ifndef LIBDIR
LIBDIR = $(PREFIX)\lib
!endif

BASE_INCLUDES = /I$(INCLUDEDIR)

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
LIBXMLXX_MAJOR_VERSION = 2
LIBXMLXX_MINOR_VERSION = 6

GLIB_API_VERSION = 2.0

GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 4

LIBSIGC_MAJOR_VERSION = 2
LIBSIGC_MINOR_VERSION = 0

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

LIBXMLXX_BASE_CFLAGS =			\
	/I.\libxml++ /I.. /EHsc		\
	/FImsvc_recommended_pragmas.h

LIBXMLXX_EXTRA_INCLUDES =	\
	/I$(INCLUDEDIR)\libxml2	\
	/I$(INCLUDEDIR)\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)	\
	/I$(LIBDIR)\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\include	\
	/I$(INCLUDEDIR)\gio-win32-$(GLIB_API_VERSION)	\
	/I$(INCLUDEDIR)\glib-$(GLIB_API_VERSION)	\
	/I$(LIBDIR)\glib-$(GLIB_API_VERSION)\include	\
	/I$(INCLUDEDIR)\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)	\
	/I$(LIBDIR)\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include	\
	/I$(INCLUDEDIR)

LIBXMLXX_CFLAGS = /DLIBXMLPP_BUILD $(LIBXMLXX_BASE_CFLAGS) $(LIBXMLXX_EXTRA_INCLUDES)
LIBXMLXX_EX_CFLAGS = $(LIBXMLXX_BASE_CFLAGS) $(LIBXMLXX_EXTRA_INCLUDES)

# We build xml++-vc$(VSVER_LIB)-$(LIBXMLXX_MAJOR_VERSION)_$(LIBXMLXX_MINOR_VERSION).dll or
#          xml++-vc$(VSVER_LIB)-d-$(LIBXMLXX_MAJOR_VERSION)_$(LIBXMLXX_MINOR_VERSION).dll at least

!if "$(USE_COMPAT_LIBS)" != ""
VSVER_LIB = $(PDBVER)0
MSVC_VSVER_LIB =
!else
VSVER_LIB = $(PDBVER)$(VSVER_SUFFIX)
MSVC_VSVER_LIB = -vc$(VSVER_LIB)
!endif

!ifdef USE_MESON_LIBS
LIBSIGC_LIBNAME = sigc-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)
GLIBMM_LIBNAME = glibmm$(MSVC_VSVER_LIB)-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)
LIBXMLXX_LIBNAME = xml++$(MSVC_VSVER_LIB)-$(LIBXMLXX_MAJOR_VERSION).$(LIBXMLXX_MINOR_VERSION)

LIBXMLXX_DLLNAME = $(LIBXMLXX_LIBNAME)-1
!else
LIBSIGC_LIBNAME = sigc-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)
GLIBMM_LIBNAME = glibmm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(GLIBMM_MAJOR_VERSION)_$(GLIBMM_MINOR_VERSION)
LIBXMLXX_LIBNAME = xml++-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(LIBXMLXX_MAJOR_VERSION)_$(LIBXMLXX_MINOR_VERSION)

LIBXMLXX_DLLNAME = $(LIBXMLXX_LIBNAME)
!endif

LIBSIGC_LIB = $(LIBSIGC_LIBNAME).lib
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib

LIBXMLXX_DLL = vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBXMLXX_DLLNAME).dll
LIBXMLXX_LIB = vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBXMLXX_LIBNAME).lib

LIBXML2_LIBS = libxml2.lib
GOBJECT_LIBS = gobject-2.0.lib gmodule-2.0.lib glib-2.0.lib

!if "$(PLAT)" == "Win32"
DOM_UPDATE_NAMESPACE_MANIFEST = vs$(VSVER)\$(CFG)\$(PLAT)\dom_update_namespace.exe.manifest
!else
DOM_UPDATE_NAMESPACE_MANIFEST =
!endif
