/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 0; tab-width: 2 -*- */
/* main.vala
 *
 * Copyright (C) 2017  Daniel Espinosa <daniel.espinosa@pwmc.mx>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *      Daniel Espinosa <daniel.espinosa@pwmc.mx>
 */

using Gtk;
using Gee;
using GXml;

public errordomain CsvReaderError {
  INVALID_FILE
}

[GtkTemplate (ui="/mx/pwmc/ptablaxml/window.ui")]
public class Ptx.Window : Gtk.ApplicationWindow {
  private GLib.File _save = GLib.File.new_for_path (GLib.Environment.get_home_dir ());
  [GtkChild]
  private Gtk.Entry enodename;
  [GtkChild]
  private Gtk.Entry erowname;
  [GtkChild]
  private Gtk.FileChooserButton file;
  [GtkChild]
  private Gtk.InfoBar infobar;
  [GtkChild]
  private Gtk.Button bconvert;
  [GtkChild]
  private Gtk.Button bsave;
  [GtkChild]
  private Gtk.Label lsave;
  construct {
    //GLib.Intl.textdomain(Config.GETTEXT_PACKAGE);
    //GLib.Intl.bindtextdomain(Config.GETTEXT_PACKAGE, Config.PACKAGE_LOCALE_DIR);
    file.file_set.connect (()=>{
      var f = file.get_file ();
      bsave.sensitive = true;
      if (f.query_exists () && _save != null)
        if (_save.query_exists ())
          bconvert.sensitive = true;
    });
    bsave.clicked.connect (()=>{
      var dlg = new Gtk.FileChooserDialog (
        "Select File to Save to", this, Gtk.FileChooserAction.SAVE,
        "_Cancel",
        Gtk.ResponseType.CANCEL,
        "_Save",
        Gtk.ResponseType.ACCEPT);
      if (_save != null)
      try { dlg.set_file (_save); } catch {}
      if (dlg.run () == Gtk.ResponseType.ACCEPT) {
        _save = dlg.get_file ();
        lsave.label = _save.get_path ();
        bconvert.sensitive = true;
      }
      dlg.destroy ();
    });
    bconvert.clicked.connect (()=>{
      if (enodename.text == "" || erowname.text == "") return;
      if (_save == null) {
        warning ("No file output selected");
        return;
      }
      try {
        var r = new Reader (enodename.text, erowname.text);
        r.read (file.get_file ());
        message ((r.document_element as GomElement).write_string ());
        (r as GomDocument).write_file (_save);
      }
      catch (GLib.Error e) {
        warning ("Error reading file: "+e.message);
      }
    });
    destroy.connect (Gtk.main_quit);
    title = "Separted Value XML Converter";
    infobar.hide ();
    bconvert.sensitive = false;
    bsave.sensitive = false;
  }
}
