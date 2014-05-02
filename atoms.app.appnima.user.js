/* atoms v0.05.02
   http://atoms.tapquo.com
   Copyright (c) 2014 Tapquo S.L. - Licensed MIT */
(function(){"use strict";var __bind=function(fn,me){return function(){return fn.apply(me,arguments)}},__hasProp={}.hasOwnProperty,__extends=function(child,parent){function ctor(){this.constructor=child}for(var key in parent)__hasProp.call(parent,key)&&(child[key]=parent[key]);return ctor.prototype=parent.prototype,child.prototype=new ctor,child.__super__=parent.prototype,child};Atoms.Organism.AppnimaSession=function(_super){function AppnimaSession(){return this.onFormChange=__bind(this.onFormChange,this),AppnimaSession.__super__.constructor.apply(this,arguments)}return __extends(AppnimaSession,_super),AppnimaSession["extends"]=!0,AppnimaSession.events=["login","signup","error"],AppnimaSession["default"]={style:"padding",events:["login","signup","error"],children:[{"Atom.Image":{}},{"Molecule.Form":{id:"form",events:["change"],children:[{"Atom.Input":{type:"email",name:"mail",placeholder:"Email...",events:["keyup"],required:!0}},{"Atom.Input":{id:"password",type:"password",name:"password",placeholder:"Password...",events:["keyup"],required:!0}},{"Atom.Button":{text:"Login",action:"login",style:"fluid theme",callbacks:["onSubmit"]}},{"Atom.Button":{text:"Signup",action:"signup",style:"fluid",callbacks:["onSubmit"]}}]}},{"Atom.Heading":{text:"© All Rights Reserved"}}]},AppnimaSession.prototype.render=function(){return AppnimaSession.__super__.render.apply(this,arguments),null!=window.Appnima?this.onFormChange():alert("ERROR: App/nima library not exists.")},AppnimaSession.prototype.onFormChange=function(){var child,form,method,_i,_len,_ref;for(form=this.form.value(),method=""===form.mail||""===form.password?"attr":"removeAttr",_ref=this.form.children,_i=0,_len=_ref.length;_len>_i;_i++)child=_ref[_i],child.value||child.el[method]("disabled",!0);return!1},AppnimaSession.prototype.onSubmit=function(event,button){var action,values,_ref;return null!=(null!=(_ref=window.Appnima)?_ref.key:void 0)?(action=button.attributes.action,values=this.form.value(),Atoms.App.Modal.Loading.show(),window.Appnima.User[action](values.mail,values.password).then(function(_this){return function(error,appnima){return error?_this.bubble("error",error):_this.bubble(action,appnima.response),Atoms.App.Modal.Loading.hide()}}(this))):alert("ERROR: Unknown App/nima key")},AppnimaSession}(Atoms.Organism.Section)}).call(this);