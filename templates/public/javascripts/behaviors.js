var AutofocusElements = $.klass({
  initialize: function() { if(!Modernizr.input.autofocus) { this.element.focus(); } }
});
$('input[autofocus]').attach(AutofocusElements);
