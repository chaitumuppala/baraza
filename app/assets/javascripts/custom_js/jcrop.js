  var jcrop_api;

  function jcropInit()
  {
    jcrop_api = $.Jcrop("#coverImage", {
	onChange:   showCoords,
      	onSelect:   showCoords,
        allowResize: false,
        allowSelect: false,
      	onRelease:  clearCoords
    });

    jcrop_api.setSelect([0,0,891,350]);

    $('#coords').on('change','input',function(e){
      var x1 = $('#x1').val(),
          x2 = $('#x2').val(),
          y1 = $('#y1').val(),
          y2 = $('#y2').val();
      jcrop_api.setSelect([x1,y1,x2,y2]);
    });

  }

  function jcropDestroy()
  {
    if (jcrop_api)
    {
      jcrop_api.destroy();
      $('#x1').val("");
      $('#y1').val("");
      $('#x2').val("");
      $('#y2').val("");
      $('#w').val("");
      $('#h').val("");
    }
    return (false);
  }

function showCoords(c)
{
  $('#x1').val(c.x);
  $('#y1').val(c.y);
  $('#x2').val(c.x2);
  $('#y2').val(c.y2);
  $('#w').val(c.w);
  $('#h').val(c.h);
};

function clearCoords()
{
  $('#coords input').val('');
};
