/** CONFIG **/

// !! Change this to your current resource name !!
var resourcename = "trainer";

// Max amount of items in 1 menu (before autopaging kicks in)
var maxVisibleItems = 7;

/** CODE **/

var counter;
var currentpage;

var menus = [];

var container;
var content;
var maxamount;

var pageindicator = "<p id='pageindicator'></p>"

$(function() {
    container = $("#trainercontainer");
    
    init();
    
    window.addEventListener("message", function(event) {
        var item = event.data;
        
        if (item.showtrainer) {
            resetTrainer();
            container.show();
            playSound("YES");
        } else if (item.hidetrainer) {
            container.hide();
            playSound("NO");
        }
        
        if (item.trainerenter) {
            handleSelectedOption();
        } else if (item.trainerback) {
            trainerBack();
        }
        
        if (item.trainerup) {
            trainerUp();
        } else if (item.trainerdown) {
            trainerDown();
        }
        
        if (item.trainerleft) {
            trainerPrevPage();
        } else if (item.trainerright) {
            trainerNextPage();
        }
    });
});

function init() {
    $("div").each(function(i, obj) {
        if ($(this).attr("id") != "trainercontainer") {
            var data = {};
            data.menu = $(this).detach();
            
            data.pages = [];
            $(this).children().each(function(i, obj) {
                // send true state if it exists
                if ($(this).data("state") == "ON") {
                    var statedata = $(this).data("action").split(" ");
                    sendData(statedata[0], {action: statedata[1], newstate: true});
                }
                
                var page = Math.floor(i / maxVisibleItems);
                if (data.pages[page] == null) {
                    data.pages[page] = [];
                }
                
                data.pages[page].push($(this).detach());
                data.maxpages = page;
            });
            
            menus[$(this).attr("id")] = data;
        }
    });
}

function trainerUp() {
    $(".traineroption").eq(counter).attr("class", "traineroption");
    
    if (counter > 1) {
        counter -= 1;
    } else {
        counter = maxamount;
    }
    
    $(".traineroption").eq(counter).attr("class", "traineroption selected");
    playSound("NAV_UP_DOWN");
}

function trainerDown() {
    $(".traineroption").eq(counter).attr("class", "traineroption");
    
    if (counter < maxamount) {
        counter += 1;
    } else {
        counter = 1;
    }
    
    $(".traineroption").eq(counter).attr("class", "traineroption selected");
    playSound("NAV_UP_DOWN");
}

function trainerPrevPage() {
    var newpage;
    if (pageExists(currentpage - 1)) {
        newpage = currentpage - 1;
    } else {
        newpage = content.maxpages;
    }
    
    showPage(newpage);
    playSound("NAV_UP_DOWN");
}

function trainerNextPage() {
    var newpage;
    if (pageExists(currentpage + 1)) {
        newpage = currentpage + 1;
    } else {
        newpage = 0;
    }
    
    showPage(newpage);
    playSound("NAV_UP_DOWN");
}

function trainerBack() {
    if (content.menu == menus["mainmenu"].menu) {
        container.hide();
        sendData("trainerclose", {})
    } else {
        showMenu(menus[content.menu.data("parent")]);
    }
    
    playSound("BACK");
}

function handleSelectedOption() {
    var item = $(".traineroption").eq(counter);
    
    if (item.data("sub")) {
        var submenu = menus[item.data("sub")];
        if (item.data("subdata")) {
            submenu.menu.attr("data-subdata", item.data("subdata"));
        } else {
            submenu.menu.attr("data-subdata", "");
        }
        
        showMenu(submenu);
    } else if (item.data("action")) {
        var newstate = true;
        if (item.data("state")) {
            // .attr() because .data() gives original values
            if (item.attr("data-state") == "ON") {
                newstate = false;
                item.attr("data-state", "OFF");
            } else if (item.attr("data-state") == "OFF") {
                item.attr("data-state", "ON");
            }
        }
        
        var data = item.data("action").split(" ");
        if (data[1] == "*") {
            data[1] = item.parent().attr("data-subdata");
        }
        
        sendData(data[0], {action: data[1], newstate: newstate});
    }
    
    playSound("SELECT");
}

function resetSelected() {
    $(".traineroption").each(function(i, obj) {
        if ($(this).attr("class") == "traineroption selected") {
            $(this).attr("class", "traineroption");
        }
    });
    
    counter = 1;
    maxamount = $(".traineroption").length - 1;
    $(".traineroption").eq(1).attr("class", "traineroption selected");
}

function resetTrainer() {
    showMenu(menus["mainmenu"]);
}

function showMenu(menu) {
    if (content != null) {
        content.menu.detach();
    }
    
    content = menu;
    container.append(content.menu);
    
    showPage(0);
}

function showPage(page) {
    if (currentpage != null) {
        content.menu.children().detach();
    }
    
    currentpage = page;
    
    for (var i = 0; i < content.pages[currentpage].length; ++i) {
        content.menu.append(content.pages[currentpage][i]);
    }
    
    content.menu.append(pageindicator);
    
    if (content.maxpages > 0) {
        $("#pageindicator").text("Page " + (currentpage + 1) + " / " + (content.maxpages + 1));
    }
    
    resetSelected();
}

function pageExists(page) {
    return content.pages[page] != null;
}

function sendData(name, data) {
    $.post("http://" + resourcename + "/" + name, JSON.stringify(data), function(datab) {
        console.log(datab);
    });
}

function playSound(sound) {
    sendData("playsound", {name: sound});
}