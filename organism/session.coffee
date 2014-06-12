###
@TODO

@namespace Atoms.Organism
@class AppnimaSession

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

class Atoms.Organism.AppnimaSession extends Atoms.Organism.Section

  @extends  : true

  @events   : ["login", "signup", "error"]

  @default  :
    style   : "padding",
    children: [
      "Atom.Image": {}
    ,
      "Molecule.Form": id: "form", events: ["change"], children: [
        "Atom.Input": id: "mail", type:"email", name: "mail", placeholder: "Email...", events: ["keyup"], required: true
      ,
        "Atom.Input": id: "password", type:"password", name: "password", placeholder: "Password...", events: ["keyup"], required: true
      ,
        "Atom.Button": text: "Login", action: "login", style: "fluid theme", callbacks: ["onSubmit"]
      ,
        "Atom.Button": text: "Signup", action: "signup", style: "fluid", callbacks: ["onSubmit"]
      ]
    ,
      "Atom.Heading": text: "© All Rights Reserved"
    ]

  render: ->
    super
    if window.Appnima?
      do @onFormChange
    else
      alert "ERROR: App/nima library not exists."

  onFormChange: =>
    form = @form.value()
    method = if (form.mail is "" or form.password is "") then "attr" else "removeAttr"
    for child in @form.children when not child.value
      child.el[method] "disabled", true
    false

  onSubmit: (event, button) ->
    if window.Appnima?.key?
      action = button.attributes.action
      values = @form.value()

      __.Modal.Loading.show()
      window.Appnima.User[action](values.mail, values.password).then (error, appnima) =>
        if error
          @bubble "error", error
        else
          @bubble action, appnima
        __.Modal.Loading.hide()
    else
      alert "ERROR: Unknown App/nima key"
