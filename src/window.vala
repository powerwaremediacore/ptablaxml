/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 2; tab-width: 2 -*-  */
/**
 * Copyrigth 2017 Daniel Espinosa <daniel.espinosa@pwmc.mx>
 */

using Gtk;
using Gee;
using GXml;

public errordomain CsvReaderError {
  INVALID_FILE
}

[GtkTemplate (ui="/mx/pwmc/cfdi/window.ui")]
public class Ptx.Window : Gtk.ApplicationWindow {
  private GLib.File _save = null;
  [GtkChild]
  private Gtk.Entry enodename;
  [GtkChild]
  private Gtk.Entry erowname;
  [GtkChild]
  private Gtk.ListBox listbox;
  [GtkChild]
  private Gtk.FileChooserButton file;
  [GtkChild]
  private Gtk.InfoBar infobar;
  [GtkChild]
  private Gtk.Label lmessage;
  [GtkChild]
  private Gtk.Box bxtitles;
  [GtkChild]
  private Gtk.Button bconvert;
  [GtkChild]
  private Gtk.Button bsave;
  [GtkChild]
  private Gtk.CheckButton cbtab;
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
      if (dlg.run () == Gtk.ResponseType.ACCEPT) {
        _save = dlg.get_file ();
        lsave.label = _save.get_path ();
        bconvert.sensitive = true;
      }
      dlg.destroy ();
    });
    bconvert.clicked.connect (()=>{
      if (enodename.text == "" || erowname.text == "") return;
      var r = new Reader (enodename.text, erowname.text);
      r.read (file.get_file ());
      message ((r.document_element as GomElement).write_string ());
    });
    destroy.connect (Gtk.main_quit);
    title = "Separted Value XML Converter";
    infobar.hide ();
    bconvert.sensitive = false;
    bsave.sensitive = false;
  }
}
public class Ptx.Reader : GomDocument {
  private Gee.ArrayList<string> titles = new Gee.ArrayList<string> ();
  private string _child;
  public Reader (string root, string child)
    requires (root != "")
    requires (child != "")
  {
    var r = create_element (root);
    append_child (r);
    _child = child;
  }
  public void read (GLib.File f) throws GLib.Error {
    if (!f.query_exists ())
      throw new CsvReaderError.INVALID_FILE ("File doesn't exists");
    if (document_element == null)
      throw new CsvReaderError.INVALID_FILE ("Root node is not set");
    if (_child == null || _child == "")
      throw new CsvReaderError.INVALID_FILE ("Childs node's name is invalid");
    var reader = new GLib.DataInputStream (f.read ());
    // First line
    string line = "";
    int ln = -1;
    while (line != null) {
      line = reader.read_line ();
      ln++;
      if (line == null) continue;
      string[] props = line.split ("\t");
      if (props == null) continue;
      if (props.length <= 0) continue;
      for (int i = 0; i < props.length; i++) {
        if (ln == 0) {
          message (props[i].to_ascii ());
          titles.add (props[i].to_ascii ());
          continue;
        }
        if (titles.size != 0 && i < titles.size) {
          var r = create_element (_child);
          for (int j = 0; j < titles.size; j++) {
            var pn = titles.get (j);
            if (pn == null) continue;
            r.set_attribute (pn, props[j]);
          }
          document_element.append_child (r);
        }
      }
    }
  }
}
