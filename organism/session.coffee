###
@TODO

@namespace Atoms.Molecule
@class GMapFullScreen

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
        "Atom.Input": type:"email", name: "mail", placeholder: "Email...", events: ["keyup"], required: true
      ,
        "Atom.Input": type:"password", name: "password", placeholder: "Password...", events: ["keyup"], required: true
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
    if window.Appnima?.key?
      do @onFormChange
    else
      alert "ERROR: Unknown Appnima key"

  onFormChange: =>
    form = @form.value()
    method = if (form.mail is "" or form.password is "") then "attr" else "removeAttr"
    for child in @form.children when not child.value
      child.el[method] "disabled", true
    false

  onSubmit: (event, button) ->
    action = button.attributes.action
    values = @form.value()

    Atoms.App.Modal.Loading.show()
    Appnima.User[action](values.mail, values.password).then (error, appnima) =>
      if error
        @bubble "error", error
      else
        @bubble action, appnima.response
      Atoms.App.Modal.Loading.hide()
