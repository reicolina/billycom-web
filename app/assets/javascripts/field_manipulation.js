function showhidefield1()
 {
   if (document.frm1.upload_form.checked)
   {
     document.getElementById("hideablearea1").style.display = "block";
   }
   else
   {
     document.getElementById("hideablearea1").style.display = "none";
   }
 }

function showhidefield2()
 {
   if (document.frm2.new_international_rate.checked)
   {
     document.getElementById("hideablearea2").style.display = "block";
   }
   else
   {
     document.getElementById("hideablearea2").style.display = "none";
   }
 }

function validateFiles(inputFile) {
  var maxExceededMessage = "This file exceeds the maximum allowed file size";
  var extErrorMessage = "Only image file with extension: .jpg, .jpeg, .gif or .png is allowed";
  var allowedExtension = ["jpg", "jpeg", "gif", "png"];
 
  var extName;
  var maxFileSize = $(inputFile).data('max-file-size');
  var sizeExceeded = false;
  var extError = false;
 
  $.each(inputFile.files, function() {
    if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {sizeExceeded=true;};
    extName = this.name.split('.').pop();
    if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
  });
  if (sizeExceeded) {
    window.alert(maxExceededMessage);
    $(inputFile).val('');
  };
 
  if (extError) {
    window.alert(extErrorMessage);
    $(inputFile).val('');
  };
}