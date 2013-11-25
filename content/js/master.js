function ga_ext_link(link) {
    try {
        ga('send', 'event', 'external-link', link.title);
    } catch(err){}

    setTimeout(function() {
        document.location.href = link.href;
    }, 100);
}

function checkUpdate(currentTime, oldTime, cues) {
    var art = $("#art");
    var timeIndex;
    for (timeIndex in cues) {
        if (currentTime > timeIndex && oldTime < timeIndex) {
            var _timeIndex = timeIndex;
            art.fadeOut('slow', function() {
                $(this).html(cues[_timeIndex]).fadeIn('slow');
            });
        }
    }
}

var createPlayer =
    function(filename, cues) {
        var supportsAudio = !!document.createElement('audio').canPlayType,
	audio,
	loadingIndicator,
	positionIndicator,
	timeleft,
	loaded = false,
	manualSeek = false;
        if(supportsAudio) {
            var base_path = "https://s3.amazonaws.com/spokenrune/" + filename;
            var mp3path = base_path + '.mp3';
            var oggpath = base_path + '.ogg';
            var player = '<div class="player">\
  <span id="playtoggle" />\
  <span id="gutter">\
    <span id="loading" />\
    <span id="handle" class="ui-slider-handle" />\
  </span>\
  <span id="timeleft" />\
<audio>\
<source src="' + oggpath + '" type="audio/ogg"></source>\
<source src="' + mp3path + '" type="audio/mpeg"></source>\
</audio></div>';

            $(player).insertBefore(".download");
            audio = $('.player audio').get(0);
            loadingIndicator = $('.player #loading');
            positionIndicator = $('.player #handle');
            timeleft = $('.player #timeleft');
            if ((audio.buffered != undefined) && (audio.buffered.length != 0)) {
                $(audio).bind('progress', function() {
                    var loaded = parseInt(((audio.buffered.end(0) / audio.duration) * 100), 10);
                    loadingIndicator.css({width: loaded + '%'});
                });
            } else {
                loadingIndicator.remove();
            }
            var oldTime = 0;
            $(audio).bind('timeupdate.main', function() {

                var rem = parseInt(audio.duration - audio.currentTime, 10),
                pos = (audio.currentTime / audio.duration) * 100,
                mins = Math.floor(rem / 60,10),
                secs = rem - mins * 60,
                newTime = audio.currentTime;

                timeleft.text('-' + mins + ':' + (secs > 9 ? secs : '0' + secs));
                checkUpdate(audio.currentTime, oldTime, cues);

                if (!manualSeek) { positionIndicator.css({left: pos + '%'}); }
                if (!loaded) {
                    loaded = true;

                    $('.player #gutter').slider({
                        value: 0,
                        step: 0.01,
                        orientation: "horizontal",
                        range: "min",
                        max: audio.duration,
                        animate: true,
                        slide: function() {
                            manualSeek = true;
                        },
                        stop:function(e,ui) {
                            manualSeek = false;
                            audio.currentTime = ui.value;
                        }
                    });
                }
                oldTime = audio.currentTime;
            });
            $(audio).bind('timeupdate.firstdecile', function () {
                var pos = (audio.currentTime / audio.duration) * 100;
                if (pos > 10) {
                    ga('send', 'event', 'readings', 'start-listening', filename);
                    $(audio).unbind('timeupdate.firstdecile');
                }});
            $(audio).bind('timeupdate.lastdecile', function () {
                var pos = (audio.currentTime / audio.duration) * 100;
                if (pos > 90) {
                    ga('send', 'event', 'readings', 'finish-listening', filename);
                    $(audio).unbind('timeupdate.lastdecile');
                }});

            $(audio).bind('play',function() {
                $("#playtoggle").addClass('playing');
            }).bind('pause ended', function() {
                $("#playtoggle").removeClass('playing');
            });
            $("#playtoggle").click(function() {
                if (audio.paused) { audio.play(); }
                else { audio.pause(); }
            });

            $("#download").click(function() {
                ga('send', 'event', 'readings', 'download', filename);
            });
        }
    };
