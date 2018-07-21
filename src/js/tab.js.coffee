# ======================================================================
# ----------------------------------------------------------------------
# Tab
# ----------------------------------------------------------------------
# ======================================================================
class Tab
  constructor: (@_options) ->
  
  Object.defineProperties @prototype,
    # ===================================================================
    # getter
    # @return {object} options
    # ===================================================================
    options      : get: -> this._options

    # ===================================================================
    # getter
    # @return {string} container attribute
    # ===================================================================
    containerAttr: get: -> this.options.containerAttr

    # ===================================================================
    # getter
    # @return {string} trigger attribute  
    # ===================================================================  
    triggerAttr  : get: -> this.options.triggerAttr

    # ===================================================================
    # getter
    # @return {string} content attribute
    # ===================================================================
    contentAttr  : get: -> this.options.contentAttr

    # ===================================================================
    # getter
    # @return {string} active css class
    # ===================================================================
    activeValue  : get: -> this.options.activeValue

    # ===================================================================
    # getter
    # @return {number} active content index number.
    #   number >=  0: success number. active content is exist.
    #   number == -1: error number. active content is not exist.
    # ===================================================================
    activeIndex  : get: ->
      activeIndex = -1

      this.$trigger.each (index, trigger) => if $(trigger).attr(this.triggerAttr) == this.activeValue
        activeIndex = index

      activeIndex

    # ===================================================================
    # getter
    # @return {jquery} container jquery element inside options.
    # ===================================================================
    $container   : get: -> this.options.$container

    # ===================================================================
    # getter
    # @return {jquery} trigger jquery element inside container.
    # ===================================================================
    $trigger     : get: -> this.$container.find this._createAttrSelector this.triggerAttr

    # ===================================================================
    # getter
    # @return {jquery} content jquery element inside container.
    # ===================================================================
    $content     : get: -> this.$container.find this._createAttrSelector this.contentAttr

  # ===================================================================
  # private function
  # @params
  #   attr {string} attribute
  #   data {string} attribute's value
  # ===================================================================
  _createAttrSelector: (attr, data) =>
    if data? then '[' + attr + '="' + data + '"]' else '[' + attr + ']'

  # ===================================================================
  # private function
  # @params {number} target trigger's index number
  # 
  # This function switches a active trigger.
  # Active trigger is judged by number.
  # ===================================================================
  _switchTrigger: (index) =>
    $targetTrigger = this.$trigger.eq index
    $otherTrigger  = this.$trigger.not $targetTrigger

    $targetTrigger.attr this.triggerAttr, this.activeValue
    $otherTrigger.attr  this.triggerAttr, ''

  # ===================================================================
  # private function
  # @params {number} target content/trigger's index number
  # 
  # This function switches a active content/trigger.
  # Target content/trigger is judged by number.
  # ===================================================================
  _triggerClickEventHandle: (index) =>
    if index is this.activeIndex
      return

    this._switchTrigger index
    this._switchContent index

  # ===================================================================
  # private function
  # 
  # This function set trigger event.
  # ===================================================================
  _setTriggerEvent: =>
    this.$trigger.each (index, trigger) =>
      $(trigger).on 'click', => this._triggerClickEventHandle index

  # ===================================================================
  # public function
  # ===================================================================
  setTab: => this._setTriggerEvent()

# ======================================================================
# ----------------------------------------------------------------------
# SwitchTab
# ----------------------------------------------------------------------
# ======================================================================
class SwitchTab extends Tab
  constructor: (options) -> super options
  
  # ===================================================================
  # private function
  # @params {number} target content's index number
  # 
  # This function switches a active content.
  # Active content is judged by number.
  # ===================================================================
  _switchContent: (index) =>
    $targetContent = this.$content.eq index
    $otherContent  = this.$content.not $targetContent

    $otherContent.hide 0, => $targetContent.show 0

(->
  containerAttr = 'data-tab';

  $('[' + containerAttr + ']').each (index, container) =>
    tab = new SwitchTab
      $container   : $ container
      containerAttr: containerAttr
      triggerAttr  : containerAttr + '-trigger'
      contentAttr  : containerAttr + '-content'
      activeValue  : 'active'

    tab.setTab()
)()