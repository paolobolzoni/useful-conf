# Tip and tricks with ALSA

`aplay -l` gives as output the names of all cards. `hw:`_name_ refers to the specific card.
It is usually more readable than the `hw:0,0` syntax.


## Allow to select the default PCM output via env variable

Since it connects via a `plug` plugin it allows any needed format conversion.

```
pcm.!default {
    type plug
    slave.pcm {
        @func getenv
        vars [ ALSAPCM ]
        default "pcm.smix"
    }
}
```


## Activate software mixing

This is useful...

- if a sound card does not support hardware mixing.
- to have a well-known name for the most-used playback and capure device of the system (e.g., the speakers and the microphone). In this example `pch_playback` and `pch_capture` will be the name of the two devices.

_n.b._, _all the ipc\_keys must be unique_ a call to `echo $RANDOM` can give a quick ipc key.

_n.b._, the settings check for the env variable `ALSAPCMHW` as final hardware device.

```
pcm.smix {
    type asym

    playback.pcm "pcm.pch_playback"
    capture.pcm "pcm.pch_capture"

    hint {
        show on
        description "Default full duplex card using microphone and speakers"
    }
}


pcm.pch_playback {
    type dmix
    ipc_key 9175930
    ipc_key_add_uid true
    slave.pcm {
        @func getenv
        vars [ ALSAPCMHW ]
        default "hw:PCH"
    }
}


pcm.pch_capture {
    type dsnoop
    ipc_key 5978293
    ipc_key_add_uid yes
    slave.pcm {
        @func getenv
        vars [ ALSAPCMHW ]
        default "hw:PCH"
    }
}
```


## Create a device that maximize the volume


_n.b._, the ladspa plugins are not installed by default. In archlinux one can install them with `pacman -S ladspa`.

```
pcm.fixvol {
    type ladspa
    slave.pcm "ladcomp_limiter"
    path "/usr/lib/ladspa"
    plugins [{
        label dysonCompress
        #peak limit, release time, fast ratio, ratio
        input.controls [ 0 1 0.5 0.99 ]
    }]

    hint {
        show on
        description "Playback card that normalize volume"
    }
}


pcm.ladcomp_limiter {
    type ladspa
    slave.pcm {
        type plug
        slave.pcm "pcm.pch_playback"
    }
    path "/usr/lib/ladspa"
    plugins [{
        label fastLookaheadLimiter
        #InputGain(Db) -20 -> +20 ; Limit (db) -20 -> 0 ; Release time (s) 0.01 -> 2
        #also possible... 20 0 0.8
        input.controls [ 10 0 0.8  ]
    }]
}
```


## Create a virtual microphone so that it records both the microphone input _and_ the sound card output

First we create a full-duplex card; Skype allows to select playback and capture devices separately, but this way it is easier as you can simply set up the same device for both settings. The playback is just the normal device.

_n.b._, here is used the idea that `skype_` (as prefix) means that the PCM may be used by the users and instead `_skype` (as suffix) means it is for internal use only.

```
pcm.skype_bicard {
    type asym

    playback.pcm "pcm.pch_playback"
    capture.pcm  "pcm.skype_multiroutein"

    hint {
        show on
        description "Skype full-duplex card with music"
    }
}
```

### The microphone side

The  `pcm.skype_multiroutein` device is a stereo device that mixes together
four channels from the `pcm.indev_skype` device. The four channels are two stereo, one from the microphone and one from the application sounds.

```
pcm.skype_multiroutein {
    type route;
    slave {
        pcm "pcm.indev_skype";
        channels 4
    }
    ttable {
        0 { 0 1.0; 2 1.0; }
        1 { 1 1.0; 3 1.0; }
    }
}
```

`pcm.indev_skype` is four-channels device that takes its input from the
microphone (`pcm.pch_capture`) and from the loopback device (`hw:Loopback,1,0`).

The loopback device basically creates a connection between a PCM capture device
and a PCM playback device. The playback device is `hw:Loopback,0,0` and the
capture device is `hw:Loopback,1,0`.

_n.b._, if the system has no loopback devices you may need to load the kernel module with `modprobe snd_aloop`.

```
pcm.indev_skype {
    type multi;
    slaves {
        a {
            pcm "pcm.pch_capture"
            channels 2
        }
        b {
            pcm "hw:Loopback,1,0"
            channels 2
        }
    }
    bindings {
        0 { slave a; channel 0; }
        1 { slave a; channel 1; }
        2 { slave b; channel 0; }
        3 { slave b; channel 1; }
    }
}
```

### The applications side

Now we have a virtual microphone that reads both from the real microphone and
from the loopback device.  It would be easy to send the sounds to the loopback
device, but we also want to hear the sound ourselves from the speakers.

So we need a way to pump the sound in our speakers _and_ in the loopback device.

The `pcm.skype_game` device is a stereo device that repeats its left and right
channels twice and it sends the resulting four channels to `pcm.splitter_skype`.

```
pcm.skype_game {
    slave {
        pcm "pcm.splitter_skype"
        channels 4
    }

    type route
    ttable.0.0 1
    ttable.1.1 1
    ttable.0.2 1
    ttable.1.3 1

    hint {
        show on
        description "Card to playback in Skype"
    }
}
```

The `pcm.splitter_skype` device has four channels and it sends the first two to
normal playback device (`pcm.pch_playback`) and to the loopback
(`pcm.loopbackdmix_skype`).

```
pcm.splitter_skype {
    type multi;
    slaves {
        a { channels 2 pcm "pcm.pch_playback" }
        b { channels 2 pcm "pcm.loopbackdmix_skype" }
    }
    bindings {
        0 { slave a channel 0 }
        1 { slave a channel 1 }
        2 { slave b channel 0 }
        3 { slave b channel 1 }
    }
}

pcm.loopbackdmix_skype {
    type dmix
    ipc_key 6300
    ipc_key_add_uid true
    slave.pcm "hw:Loopback,0,0"
}
```

So, at the end, the application sends its sound to both the virtual microphone and the speakers.

