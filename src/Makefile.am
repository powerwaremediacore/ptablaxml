include $(top_srcdir)/vala.mk
include $(top_srcdir)/vala_gtk.mk

VALA_TARGET = ptablaxml

bin_PROGRAMS = $(VALA_TARGET)

VALASOURCES= \
	main.vala \
	window.vala \
	ptx-reader.vala \
	$(NULL)

ptablaxml_SOURCES = $(VALA_GTK_CSOURCES)
ptablaxml_CPPFLAGS = \
	$(PTABLAXML_CFLAGS) \
	-I$(top_srcdir) \
	$(NULL)

VALAFLAGS +=\
	--target-glib=2.50 \
	--pkg gtk+-3.0 \
	--pkg gxml-0.14 \
	$(top_srcdir)/src/config.vapi \
	$(NULL)

ptablaxml_LDADD = $(PTABLAXML_LIBS)

EXTRA_DIST+=resources.vapi

VALA_GTK_UI = window.ui

VALA_GTK_IMAGES=

VALA_GTK_RESOURCES=resources.xml
