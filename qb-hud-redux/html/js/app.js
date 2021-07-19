$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: ESC
            //Inventory.Close();
            break;
    }
});

var moneyTimeout = null;
var voiceLevel = 33;
var useRadio = false;
var ShowUI = false;

var healthblink = 50;
var foodblink = 30;
var drinkblink = 30;
var bleedingblink = 5;
var oxygenblink = 40;
var staminablink = 30;
var fuelblink = 20;

(() => {
    QBHud = {};

    QBHud.Open = function(data) {
        $(".money-cash").css("display", "block");
        $(".money-bank").css("display", "block");
        $("#cash").html(data.cash);
        $("#bank").html(data.bank);
    };

    QBHud.Close = function() {

    };

    QBHud.ToggleSeatbelt = function(data) {
        if (data.seatbelt) {
            $(".fa-eye-dropper").css("color", "#5feb46 !important");
        } else {
            $(".fa-eye-dropper").css("color", "#212529 !important");
        }
    };

    QBHud.ToggleCruise = function(data) {
        if (data.cruise) {
            $(".fa-tachometer-alt").css("color", "#5feb46 !important");
        } else {
            $(".fa-tachometer-alt").css("color", "#212529 !important");
        }
    };

    QBHud.CarHud = function(data) {
        if (data.show) {
            $(".ui-car-container").fadeIn();
            $(".locationbar").css("bottom", "20.05vh");
            $(".infobar").css("bottom", "21vh");
        } else {
            $(".ui-car-container").fadeOut();
            $(".locationbar").css("bottom", "4.05vh");
            $(".infobar").css("bottom", "5vh");
        }
    };

    QBHud.ExtraHud = function(data) {
        if (data.extra) {
            $(".locationbar").show();
            $(".infobar").show();
        } else {
            $(".locationbar").hide();
            $(".infobar").hide();
        }
    };

    QBHud.UpdateHudSlow = function(data) {
        if (ShowUI == false) {
            $(".ui-container").hide();
            $(".ui-carcontainer").hide();
        } else if (ShowUI == true) {
            $(".ui-container").show();
            $(".ui-carcontainer").show();
        }

        if (data.street2 != "" && data.street2 != undefined) {
            document.getElementById("street1").innerHTML = data.street1;
            document.getElementById("street2").innerHTML = data.street2;
        } else {
            document.getElementById("street1").innerHTML = data.street1;
        }
        
        document.getElementById("playerid").innerHTML = "ID: " + data.playerid;
        document.getElementById("money").innerHTML = "$" + data.money;

        if (useRadio == true) {
            $("#voiceBarIcon").removeClass("voiceBarIcon fas fa-microphone");
            $("#voiceBarIcon").addClass("voiceBarIcon fas fa-headset");
        } else if (useRadio == false) {
            $("#voiceBarIcon").removeClass("voiceBarIcon fas fa-headset");
            $("#voiceBarIcon").addClass("voiceBarIcon fas fa-microphone");
        }

        $('.time-text').html(data.time.hour + ':' + data.time.minute);
        $(".fuelBar").css("height", data.fuel + "%");

        if (data.fuel < fuelblink) {
            $(".fuel").css("background", 'rgba(162, 0, 37, 0.6)');
            $(".fuel").addClass("blink-anim");
        } else {
            $(".fuel").removeClass("blink-anim");
            $(".fuel").css("background", 'rgba(0, 0, 0, 0.6)');
        }

    };

    QBHud.UpdateHudFast = function(data) {
        if (ShowUI == false) {
            $(".ui-container").hide();
            $(".ui-carcontainer").hide();
        } else if (ShowUI == true) {
            $(".ui-container").show();
            $(".ui-carcontainer").show();
        }

        document.getElementById("heading").innerHTML = data.direction;

        $(".healthBar").css("width", data.health / 2 + "%");
        document.getElementById("HealthText").innerHTML = Math.round(data.health / 2)  + "%";

        $(".armorBar").css("width", data.armor + "%");
        document.getElementById("ArmorText").innerHTML = data.armor + "%";


        $(".thirstBar").css("height", data.thirst + "%");
        $(".hungerBar").css("height", data.hunger + "%");
        $(".bleedingBar").css("height", data.bleeding + "%");
        $(".oxygenBar").css("height", data.oxygen + "%");
        $(".staminaBar").css("height", data.stamina + "%");
        $(".voiceBar").css("height", voiceLevel + "%");

        if ((data.health / 2) < healthblink) {
            $(".health").css("background", 'rgba(162, 0, 37, 0.6)');
            $(".health").addClass("blink-anim");
        } else {
            $(".health").removeClass("blink-anim");
            $(".health").css("background", 'rgba(0, 0, 0, 0.6)');
        }

        if (data.thirst < drinkblink) {
            $(".thirst").css("background", 'rgba(162, 0, 37, 0.6)');
            $(".thirst").addClass("blink-anim");
        } else {
            $(".thirst").removeClass("blink-anim");
            $(".thirst").css("background", 'rgba(0, 0, 0, 0.6)');
        }

        if (data.hunger < foodblink) {
            $(".hunger").css("background", 'rgba(162, 0, 37, 0.6)');
            $(".hunger").addClass("blink-anim");
        } else {
            $(".hunger").removeClass("blink-anim");
            $(".hunger").css("background", 'rgba(0, 0, 0, 0.6)');
        }

        if (data.bleeding > bleedingblink) {
            $(".bleeding").addClass("blink-anim");
        } else {
            $(".bleeding").removeClass("blink-anim");
        }

        if (data.oxygen < oxygenblink) {
            $(".oxygen").css("background", 'rgba(162, 0, 37, 0.6)');
            $(".oxygen").addClass("blink-anim");
        } else {
            $(".oxygen").removeClass("blink-anim");
            $(".oxygen").css("background", 'rgba(0, 0, 0, 0.6)');
        }

        if (data.stamina < staminablink) {
            $(".stamina").css("background", 'rgba(162, 0, 37, 0.6)');
            $(".stamina").addClass("blink-anim");
        } else {
            $(".stamina").removeClass("blink-anim");
            $(".stamina").css("background", 'rgba(0, 0, 0, 0.6)');
        }

        if (data.talking == 1) {
            $(".voiceBar").css("background", '#F1C40F');
        } else {
            $(".voiceBar").css("background", '#34495E');
        }   
    
        document.getElementById("speedometer").innerHTML = data.speed;
    };

    if (ShowUI == false) {
        $(".ui-container").hide();
        $(".ui-carcontainer").hide();
    } else if (ShowUI == true) {
        $(".ui-container").show();
        $(".ui-carcontainer").show();
    }

    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    QBHud.Open(event.data);
                    break;
                case "close":
                    QBHud.Close();
                    break;
                case "slowhudtick":
                    QBHud.UpdateHudSlow(event.data);
                    break;
                case "fasthudtick":
                    QBHud.UpdateHudFast(event.data);
                    break;
                case "car":
                    QBHud.CarHud(event.data);
                    break;
                case "extras":
                    QBHud.ExtraHud(event.data);
                    break;
                case "seatbelt":
                    QBHud.ToggleSeatbelt(event.data);
                    break;
                case "cruise":
                    QBHud.ToggleCruise(event.data);
                    break;
                case "radio_status":
                    switch (event.data.radio) {
                        case true:
                            useRadio = true;
                            break;
                        case false:
                            useRadio = false;
                            break;
                        default:
                            useRadio = false;
                            break;
                    }
                    break;
                case "voice_level":
                    switch (event.data.voicelevel) {
                        case 1.0:
                            voiceLevel = 33;
                            break;
                        case 2.3:
                            voiceLevel = 66;
                            break;
                        case 5.0:
                            voiceLevel = 100;
                            break;
                        default:
                            voiceLevel = 33;
                            break;
                    }
                    break;
                case "hudstatus":
                    switch (event.data.UI) {
                        case true:
                            ShowUI = true;
                            break;
                        case false:
                            ShowUI = false;
                        default:
                            ShowUI = false;
                            break;
                    }
                    break;
            }
        })
    }

})();
