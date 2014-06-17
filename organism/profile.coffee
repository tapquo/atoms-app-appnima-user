###
@TODO

@namespace Atoms.Organism
@class AppnimaProfile

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

###
mail
password
username
name
bio
avatar
phone
site
country
language
###
class Atoms.Organism.AppnimaProfile extends Atoms.Organism.Section

  @extends  : true

  @events   : ["error", "submit"]

  @default  :
    style   : "padding",
    children: [
      "Molecule.Form": id: "form", events: ["change", "error", "submit"], children: [
        "Atom.Input": id: "mail", type:"email", name: "mail", placeholder: "Email...", events: ["keyup"], required: true
      # ,
      #   "Atom.Input": id: "password", type:"password", name: "password", placeholder: "Password...", required: true
      ,
        "Atom.Input": id: "username", type:"text", name: "username", placeholder: "Username..."
      ,
        "Atom.Input": id: "name", type:"text", name: "name", placeholder: "Name..."
      ,
        "Atom.Textarea": id: "bio", type:"text", name: "bio", placeholder: "Bio..."
      ,
        "Atom.Input": id: "avatar", type:"text", name: "avatar", placeholder: "Avatar..."
      ,
        "Atom.Input": id: "phone", type:"tel", name: "phone", placeholder: "Phone..."
      ,
        "Atom.Input": id: "site", type:"text", name: "site", placeholder: "Site..."
      ,
        "Atom.Input": id: "country", type:"text", name: "country", placeholder: "Country..."
      ,
        "Atom.Input": id: "language", type:"text", name: "language", placeholder: "Language..."
      ,
        "Atom.Button": text: "Update", action: "login", style: "fluid theme"
      ]
    ]

  render: ->
    super
    if window.Appnima?
      do @onFormChange
    else
      alert "ERROR: App/nima library not exists."

  show: ->
    super
    session = Appnima.User.session()
    @form[field]?.value value for field, value of session when value

  onFormChange: =>
    form = @form.value()
    method = if (form.mail is "" or form.password is "") then "attr" else "removeAttr"
    for child in @form.children when not child.value
      child.el[method] "disabled", true
    false

  onFormError: (event) ->
    @bubble "error", form
    false

  onFormSubmit: (event, form) ->
    console.info form.value()
    if window.Appnima?.key?
      __.Modal.Loading.show()
      window.Appnima.User.update(form.value()).then (error, appnima) =>
        if error
          @bubble "error", error
        else
          @bubble "submit", appnima
        __.Modal.Loading.hide()
    false
