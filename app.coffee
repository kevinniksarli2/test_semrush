$(document).ready(()->
  MainActionButtonsView = Backbone.View.extend(
    tagName : "div"
    el : "body"
    template : _.template($("#mainActionButtonsTemplate").html())
    events :
      "click #addStiker" : "addStiker"
      "click #removeStiker.actionBut" : "removeStiker"
      "click #removeStiker.actionBut_active" : "endRemoveStiker"
    render : ()->
      this.$el.append(this.template())
      return this
    addStiker : ()->
      stikerModel = new StikerModel
      $("body").append('<div id="'+stikerModel.cid+'_wrapper"></div>')
      stikerView = new StikerView(
        model : stikerModel
        el : "#"+stikerModel.cid+"_wrapper"
      )
      stikerCollection.add(stikerModel)
      stikerView.render()
    removeStiker : ()->
      $("#removeStiker").removeClass("actionBut").addClass("actionBut_active")
      $(".stiker .del").show()
    endRemoveStiker : ()->
      $("#removeStiker").removeClass("actionBut_active").addClass("actionBut")
      $(".stiker .del").hide()

  )
  StikerCollection = Backbone.Collection.extend(
    model:StikerModel
  )
  StikerModel = Backbone.Model.extend(
    top : 50
    left : 300
    zIndex : 1
    color : "color1"
    shadow : "shadow"
    text : "hello"
    degX : 0
    degY : 0
    rot : 0
    fontSize : 15
    font : "Helvetica"
  )
  StikerView = Backbone.View.extend(
    tagName : "div"
    template : _.template($("#stikerView").html())
    events :
      "click .info" : "dopSettings"
      "click .buttonDone" : "dopSettings"
      "mousedown textarea" : "moveStiker"
      "mouseup  textarea" : "stopMoveStiker"
      "keyup textarea" : "updateText"
      "click  li" : "changeColor"
      "change #fontSizeSelect" : "changeFontSize"
      "change #fontSelect" : "changeFont"
      "click div.del" : "removeStiker"
    render : ()->
      this.$el.html(this.template(this.model))
      if $("#removeStiker").hasClass("actionBut_active") then $(".stiker .del").show()
      return this
    updatePicture : ()->
      this.$el.empty()
      this.render()
    stopMoveStiker : ()->
      $("body").off "mousemove"
      this.$el.find("textarea").focus()
    moveStiker : (e)->
      $("div.stiker").css("z-index",1)
      this.model.zIndex = 19000
      this.updatePicture()
      view = this
      startX = e.pageX
      startY = e.pageY
      $("body").on "mousemove", (eo)->
        deltaX = startX - eo.pageX
        deltaY = startY - eo.pageY
        view.model.top = view.model.top - deltaY
        view.model.left = view.model.left - deltaX
        startX = eo.pageX
        startY = eo.pageY
        view.updatePicture()
    updateText : ()->
      this.model.text = $("#"+this.model.cid).find("textarea").val()
    dopSettings : ()->
      if this.model.rot is 1
        this.model.rot = 0
      else
        this.model.rot = 1
      this.updatePicture()
    changeColor : (e)->
      this.model.color = $(e.target).attr("color")
      this.updatePicture()
    changeFontSize : (e)->
      this.model.fontSize = $(e.target).val()
      this.updatePicture()
    changeFont : (e)->
      this.model.font = $(e.target).val()
      this.updatePicture()
    removeStiker : ()->
      stikerCollection.remove(this.model)
      this.remove()
  )
  stikerCollection = new StikerCollection
  mainActionButtons = new MainActionButtonsView
  mainActionButtons.render()
)