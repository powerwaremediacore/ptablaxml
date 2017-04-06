include $(top_srcdir)/valalib.mk
include $(top_srcdir)/vala_gtk.mk

-include $(top_srcdir)/git.mk

VALA_TARGET = ptablaxml

VALASOURCES= main.vala

ptablaxml_SOURCES = $(VALA_GTK_CSOURCES)
ptablaxml_CPPFLAGS = $(PTABLAXML_CFLAGS)
VALAFLAGS += --pkg gtk+-3.0

ptablaxml_LDADD = $(PTABLAXML_LIBS)

EXTRA_DIST+=resources.vapi

VALA_GTK_UI =

VALA_GTK_IMAGES=

VALA_GTK_RESOURCES=resources.xml
