/* -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 2; tab-width: 2 -*-  */
/**
 * Copyrigth 2017 Daniel Espinosa <daniel.espinosa@pwmc.mx>
 */

using Gtk;

int main (string[] args) {
    Gtk.init (ref args);

    var window = new Ptx.Window ();

    window.show_all ();

    Gtk.main ();
    return 0;
}
