// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require rorshack_admin_ui/jwysiwyg
(function($){
      
  $.fn.extend({
    outerHTML : function( value ){
  
      // Replaces the content
      if( typeof value === "string" ){
        var $this = $(this),
          $parent = $this.parent();
          
        var replaceElements = function(){
          
          // For some reason sometimes images are not replaced properly so we get rid of them first
          var $img = $this.find("img");
          if( $img.length > 0 ){
            $img.remove();
          }
          
          var element;
          $( value ).map(function(){
            element = $(this);
            $this.replaceWith( element );
          })
          
          return element;
          
        }
        
        return replaceElements();
        
      // Returns the value
      }else{
        return $("<div />").append($(this).clone()).html();
      }
  
    }
  });

})(jQuery);
