###
@TODO

@namespace Atoms.Organism
@class AppnimaProfile

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

class Atoms.Organism.AppnimaProfile extends Atoms.Organism.Section

  @extends  : true

  @events   : ["error", "change", "logout"]

  @default  :
    children: [
      "Atom.Figure": id: "avatar", style: "big", events: ["touch"]
    ,
      "Atom.Heading": id: "mail"
    ,
      "Molecule.Form": id: "form", style: "margin-all", events: ["change", "error", "submit"], children: [
        "Atom.Input": id: "username", type:"text", name: "username", placeholder: "Username..."
      ,
        "Atom.Label": text: "Other Information"
      ,
        "Atom.Input": id: "name", type: "text", name: "name", placeholder: "Name..."
      ,
        "Atom.Input": id: "phone", type: "tel", name: "phone", placeholder: "Phone..."
      ,
        "Atom.Input": id: "site", type: "text", name: "site", placeholder: "Site..."
      ,
        "Atom.Button": text: "Update profile", style: "margin-top fluid accept"
      ,
        "Atom.Button": text: "Logout", style: "fluid", callbacks: ["onLogout"]
      ,
        "Atom.Input": id: "file", type: "file", events: ["change"], callbacks: ["onAvatarChange"]
      ]
    ]

  file  : undefined

  render: ->
    super
    unless window.Appnima?
      alert "ERROR: App/nima library not exists."

  show: ->
    super
    session = Appnima.User.session()
    if session
      @avatar.refresh url: session.avatar
      @mail.refresh text: session.mail
      @form[field]?.value value for field, value of session when value
      do @onFormChange

  # Children Bubble events
  onFigureTouch: ->
    @form.file.el.trigger "click"
    false

  onAvatarChange: ->
    event.stopPropagation()
    event.preventDefault()
    file_url = event.target.files[0]
    if file_url?.type?.match /image.*/
      reader = new FileReader()
      reader.onerror = (event) ->
        alert "Error code: #{event.target.error}"
      reader.onload = (event) =>
        @file = event.target.result
        @avatar.refresh url: @file
        do @onFormSubmit
      reader.readAsDataURL file_url
    false

  onFormChange: =>
    form = @form.value()
    method = if (form.mail is "") then "attr" else "removeAttr"
    for child in @form.children when not child.value
      child.el[method] "disabled", true
    false

  onFormError: (event) ->
    @bubble "error", form
    false

  onFormSubmit: (event, form) ->
    if window.Appnima?.key?
      parameters = form?.value() or {}
      parameters.avatar = @file if @file?
      __.Modal.Loading.show()
      window.Appnima.User.update(parameters).then (error, result) =>
        if error
          @bubble "error", error
        else
          @bubble "change", result
        __.Modal.Loading.hide()
    false

  onLogout: (event, atom) ->
    Appnima.User.logout().then (error, result) => @bubble "logout", result
