var _STRINGS = {
        Ad: {
            Mobile: {
                Preroll: {
                    ReadyIn: "The game is ready in ",
                    Loading: "Your game is loading...",
                    Close: "Close"
                },
                Header: {
                    ReadyIn: "The game is ready in ",
                    Loading: "Your game is loading...",
                    Close: "Close"
                },
                End: {
                    ReadyIn: "Advertisement ends in ",
                    Loading: "Please wait ...",
                    Close: "Close"
                }
            }
        },
        Splash: {
            Loading: "Loading ...",
            LogoLine1: "Some text here",
            LogoLine2: "powered by MarketJS",
            LogoLine3: "none"
        },
        Game: {
            SelectPlayer: "Select Player",
            You: "You",
            Win: "Win",
            Lose: "LOSE",
            Score: "分数",
            Highscore: "最高分",
            Coin: "Coin",
            Time: "时间",
            Music: "音乐",
            Sound: "声音",
            Paused: "暂停",
            Game: "游戏",
            Over: "结束",
            Settings: "设置",
            Levels: "选择关卡",
            ArmoCombo: "Extras Combo",
            PopCombo: "Pop Combo",
            DropCombo: "Drop Combo",
            level: "关卡:",
            score: "分数:",
            READY: "READY",
            GO: "GO",
            Proceed: "点击继续"
        },
        Results: {
            Title: "High score"
        }
    },
    _LVL = {
        lvl0: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [10, 10, 0, 0],
            armoEachArmo: 10,
            armoExtra: 1,
            starScore: [2E3, 3E3, 3312],
            rainbow: 0,
            arrow: [{
                x: 108,
                y: 354
            }, {
                x: 108,
                y: 354
            }, {
                x: 121,
                y: 615
            }],
            rowOffset: 0,
            speech: ["My babies are trapped in these bubbles!", "Let's pop these bubbles and rescue them!", "Click on the arrow button or press B to use the floating bubble"],
            speechMobile: ["My babies are trapped in these bubbles!", "Let's pop these bubbles and rescue them!", "Click on the arrow button to use the floating bubble"],
            map: [
                [, 0, , 0, 0, 0, 0, , 0],
                [, 0, 0, , 0, "baby0", 0, , 0, 0],
                [0, "baby0", 0, , 0, 0, , 0, "baby0", 0],
                [0, 0, 0, 0, , 0, , 0, 0, 0, 0],
                [, 1, , 1, 1, 1, 1, , 1],
                [, 1, 1, , 1, "baby1", 1, ,
                    1, 1
                ],
                [1, "baby1", 1, , 1, 1, , 1, "baby1", 1],
                [1, 1, 1, 1, , 1, , 1, 1, 1, 1],
                [, 0, , 0, 0, 0, 0, , 0],
                [, 0, 0, , 0, "baby0", 0, , 0, 0],
                [0, "baby0", 0, , 0, 0, , 0, "baby0", 0],
                [0, 0, 0, 0, , 0, , 0, 0, 0, 0]
            ]
        },
        lvl1: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [5, 5, 5, 5],
            armoEachArmo: 6,
            armoExtra: 1,
            starScore: [1700, 2816, 3349],
            rainbow: 0,
            rowOffset: 0,
            map: [
                [0, 0, , , 1, 1, , , 2, 2],
                [0, 0, 0, , 1, "baby1", 1, , 2, 2, 2],
                [0, 0, 3, 3, 1, 1, 3, 3, 2, 2],
                [, , , 3, , , , 3, , , ],
                [1, 1, 3, 3, 2, 2, 3, 3, 0, 0],
                [1, "baby1", 1, , 2, 2, 2, , 0,
                    "baby0", 0
                ],
                [1, 1, 3, 3, 2, 2, 3, 3, 0, 0],
                [, , , 3, , , , 3, , , ],
                [2, 2, 3, 3, 0, 0, 3, 3, 1, 1],
                [2, 2, 2, , 0, "baby0", 0, , 1, 1, 1],
                [2, 2, , , 0, 0, , , 1, 1]
            ]
        },
        lvl2: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 13,
            armoExtra: 1,
            starScore: [3400, 5010, 6E3],
            rainbow: 0,
            rowOffset: 0,
            map: [
                [, 0, "baby0", 0, , , 1, "baby1", 1],
                [, , 0, 0, , 2, , 1, 1, , ],
                [, 3, 3, 3, 2, 2, 3, 3, 3],
                [, 3, 0, 0, 2, 2, 2, 0, 0, 3],
                [3, 0, 3, 0, 1, 1, 0, 3, 0, 3],
                [3, 1, 1, 3, 1, "baby1", 1, 3, 1, 1, 3],
                [2, 1, 0, 1, 1, 1, 1, 0, 1, 2],
                [2,
                    3, 3, 3, 0, 0, 0, 3, 3, 3, 2
                ],
                [2, 2, 1, 3, 0, 0, 3, 1, 2, 2],
                [3, 1, "baby1", 0, 2, 2, 2, 0, "baby1", 1, 3],
                [3, 0, 1, 2, 3, 3, 2, 1, 0, 3],
                [3, 0, 2, 0, 0, 0, 0, 0, 2, 0, 3],
                [0, 1, 2, 0, 0, 0, 0, 2, 1, 0],
                [3, 0, 1, 2, 0, 0, 0, 2, 1, 0, 2],
                [3, 0, 1, 2, 0, 0, 3, 1, 0, 2],
                [1, 3, 3, 2, 1, 1, 1, 3, 2, 2, 1],
                [1, 2, 2, , 1, 1, , 3, 3, 1],
                [1, , , , , 1, , , , , 1]
            ]
        },
        lvl3: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [15, 15, 15, 15],
            armoEachArmo: 15,
            starScore: [3E3, 4347, 5E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [, , 1, 1, , , 2, 2, , ],
                [, , , "baby1", , , , "baby2", , , ],
                [, , 0, 3, , , 3, 0, , ],
                [, , 3, 0, 2, , 2, 0, 3, , ],
                [, 3, 0, 1, 2, 2, 1, 0, 3],
                [3, 2, 2, 1, 0, "baby0", 0, 1, 2, 2, 3],
                [3, 3, 2, 1, 0, 0, 1, 2, 3, 3],
                [1, 2, 1, 0, 2, 1, 2, 0, 1, 2, 1],
                [1, 2, 2, 3, 1, 1, 3, 3, 3, 1],
                [2, 3, 1, 0, 1, 3, 1, 2, 2, 0, 3],
                [2, 3, 1, 0, 3, 2, 3, 2, 0, 3],
                [0, 2, 2, 3, 3, 0, 2, 3, 1, 1, 3],
                [0, 0, 1, 1, 1, 0, 1, 1, 3, 1],
                [2, 1, 3, 0, 3, 1, 0, 0, 2, 2, 3],
                [3, 0, 1, 3, , 1, 2, 3, 1, 3],
                [0, 0, 3, 3, , , 1, 2, 2, 1, 1]
            ]
        },
        lvl4: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 13,
            starScore: [3E3, 4500,
                6E3
            ],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            arrow: {
                x: 109,
                y: 284
            },
            speech: ["Avoid hitting the - bubbles!", "You'll lose 3 bubble ammo for popping one of those!"],
            map: [
                [2, "baby2", 2, 3, 3, 0, "baby0", 0, 1, 1],
                [2, 2, "minus3", "minus3", 1, 3, 2, 2, 2, 1, 1],
                [0, 0, 0, 1, 1, 1, 3, 2, 2, 3],
                [3, 0, 0, 2, 1, 1, 1, 3, 3, 0, 3],
                [3, 3, 3, "minus2", "minus2", 1, 1, 3, 0, 3],
                [1, 3, 3, "minus2", "minus2", 3, 0, "minus0", "minus0", 0, 3],
                [1, 1, 1, 1, 3, 3, 2, "minus0", 1, 3],
                [3, 1, 1, 3, 3, 3, 2, 2, 1, 1, 1],
                [3, 2, 2, 2, 2, 1, 2, 2, 2, 2],
                ["minus3", "minus3", 2, 1, 2, 1, 3, 3, "minus3", 0, 2],
                [1, "minus3", 3, 1, 1,
                    1, 2, "minus3", 3, 0
                ],
                [1, 1, 0, 0, 3, 3, 1, 2, 0, 0, 0],
                [1, 1, 0, 0, 0, 3, 3, 2, 2, 2],
                [1, 2, 2, 2, 0, 0, 3, 3, 3, 2, 2]
            ]
        },
        lvl5: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 13,
            starScore: [2E3, 3252, 4E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            speech: ["Bubble block can't be popped!", "Drop them to get rid of them!"],
            arrow: {
                x: 88,
                y: 356
            },
            map: [
                [, 3, "baby3", 3, , , 2, "baby2", 2],
                [, , 2, 2, , , , 1, 1, , ],
                [, , "wood", , , , , "wood", , ],
                [, , 2, 2, 2, "baby0", 3, 3, 3, , ],
                [, 0,
                    "wood", 1, 0, 3, 2, "wood", 2
                ],
                [, 0, "wood", 1, 3, 0, 1, 2, "wood", 3],
                [3, "wood", 3, "wood", 1, 2, "wood", 2, "wood", 1],
                [, 3, "wood", 3, 0, 0, 3, 0, "wood", 0],
                [1, 2, 2, "wood", 1, 3, "wood", 1, 3, 0],
                [1, "wood", 0, 3, 2, 1, 0, 1, 2, "wood", 3],
                [0, 3, , , , , , , 2, 0]
            ]
        },
        lvl6: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [10, 10, 10, 10],
            armoEachArmo: 13,
            starScore: [3900, 4403, 5075],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            speech: ["Try popping bubbles beside the clear bubbles", "They take over the colour of the popped bubble"],
            arrow: {
                x: 89,
                y: 354
            },
            map: [
                [3, 2, "baby1", 0, 3, 2, 1, "baby0", 3, 2],
                [0, 3, 2, 1, 0, 3, 2, 1, 0, 3, 2],
                [0, 3, 2, 1, 0, 3, 2, 1, 0, 3], "ice ice babyice ice ice ice ice ice babyice ice ice".split(" "), [0, 3, 2, 1, 0, 3, 2, 1, 0, 3],
                [1, 0, 3, 2, 1, 0, 3, 2, 1, 0, 3],
                [1, 0, 3, 2, 1, 0, 3, 2, 1, 0], "ice ice ice babyice ice ice ice babyice ice ice ice".split(" "), [1, 0, 3, 2, 1, 0, 3, 2, 1, 0],
                [2, 1, 0, 3, 2, 1, 0, 3, 2, 1, 0],
                [2, 1, 0, 3, 2, 1, 0, 3, 2, 1], "ice ice babyice ice ice ice ice ice babyice ice ice".split(" "), [2, 1, 0, 3, 2, 1, 0, 3, 2, 1]
            ]
        },
        lvl7: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 13,
            starScore: [3100, 4E3, 4900],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [, , 1, 3, 3, 2, 3, 1, , ],
                [, , , 0, 2, "baby2", 3, 0, , , ],
                [, , , 0, 0, 2, 0, , , ],
                [, , , 1, 1, 1, 0, 0, , , ],
                [, , , 2, 2, 2, 2, , , ],
                [, , , "wood", 0, "baby3", 1, 1, , , ],
                [, , , 0, 3, 1, "wood", , , ],
                [, , , "ice", "ice", "ice", "ice", "ice", , , ],
                [, , , 0, "wood", 1, 3, , , ],
                [, , , 0, 0, 1, 2, 3, , , ],
                [, , , 3, 1, 2, 3, , , ],
                [, , , 3, 1, 2, 0, 0, , , ],
                [, , , 3, 1, 0, 0, , , ],
                [, , , "ice", "ice", "babyice", "ice", "ice", , , ],
                [, , , 0, "wood", 1, 3, , , ],
                [, , , 0, 0, 1, 2, 3, , , ],
                [, , , 3, 1, 2, 3, , , ],
                [, , , 3, 1, 2, 0, 0, , , ],
                [, , , 3, 1, 0, 0, , , ],
                [, , , "ice", "ice", "babyice", "ice", "ice", , , ],
                [, 1, 0, 1, 3, 3, 1, 0, 2],
                [, , 1, 0, 1, 3, 1, 0, 2, , ],
                [, , 1, 0, 3, 1, 0, 2, , ],
                [, , , 3, 3, 2, 2, 2, , , ],
                [, , , 0, 0, 1, 3, , , ],
                [, , , , 0, 3, 3, , , , ],
                [, , , , 0, 3, , , , ],
                [, , , , , 3, , , , , ]
            ]
        },
        lvl8: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 16,
            starScore: [2500, 3800, 4300],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [, , , , "ice", "ice", , , , ],
                [, "ice",
                    "ice", , "ice", 2, "ice", , "ice", "ice"
                ], "ice baby1 ice ice ice ice ice ice baby3 ice".split(" "), [, "ice", "ice", , "ice", "ice", "ice", , "ice", "ice"],
                ["ice", 3, "ice", "ice", 0, 2, "ice", "ice", 1, "ice"],
                [, "ice", "ice", , 0, "babyice", 2, , "ice", "ice"],
                ["ice", 2, "ice", "ice", 1, 3, "ice", "ice", 0, "ice"],
                [, "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice"],
                ["ice", "ice", "ice", 3, "ice", "ice", 1, "ice", "ice", "ice"],
                ["ice", "ice", 1, "ice", "ice", "ice", "ice", "ice", 2, "ice", "ice"],
                ["ice", "ice", "ice", 0, "ice", "ice", 3, "ice", "ice", "ice"],
                ["ice",
                    "ice", "baby2", "ice", "ice", 3, "ice", "ice", "baby0", "ice", "ice"
                ],
                ["ice", "ice", "ice", "ice", 0, 2, "ice", "ice", "ice", "ice"],
                ["ice", 3, "ice", 0, "ice", "ice", "ice", 2, "ice", 1, "ice"]
            ]
        },
        lvl9: {
            colourSet: [
                ["green", "pink", "purple", "cyan"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [16, 16, 16, 16],
            armoEachArmo: 16,
            starScore: [1500, 2405, 4E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                ["ice", "ice", , , "ice", "ice", , , "ice", "ice"],
                ["ice", "baby0", "ice", , "ice", "baby1", "ice", , "ice", "baby2", "ice"],
                ["ice",
                    "ice", , , "ice", "ice", , , "ice", "ice"
                ],
                ["ice", "ice", "ice", 3, "ice", "ice", "ice", 1, "ice", "ice", "ice"],
                [3, 0, 2, 3, 0, 1, 3, 1, 2, 2],
                [0, 1, 3, 0, 2, 3, 0, 2, 3, 1, 1],
                [2, 0, 3, 0, "ice", "ice", 1, 0, 2, 3],
                [3, 3, 2, 1, "ice", "baby3", "ice", 1, 3, 2, 0],
                [0, 0, 1, 3, "ice", "ice", 2, 2, 0, 0],
                [1, 2, 3, 1, 2, 3, 0, 0, 1, 3, 1],
                [1, 1, 2, 3, 3, 2, 2, 3, 0, 1], "ice ice ice ice ice ice ice ice ice ice ice".split(" "), [0, 1, 2, 3, 2, 3, 2, 3, 0, 1]
            ]
        },
        lvl10: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13,
                13
            ],
            armoEachArmo: 16,
            starScore: [3E3, 4E3, 5E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [3, 2, "ice", 2, 1, "baby1", "baby0", 3, 3, "ice"],
                [3, "babyice", 2, "ice", "ice", "ice", "ice", "ice", "ice", "ice", 2],
                [0, 1, "ice", "ice", 2, 0, 0, 1, "ice", 3],
                ["ice", "ice", "ice", 1, "ice", 1, "baby0", 3, "ice", 1, 3],
                [0, 3, "ice", 2, "ice", 2, 3, "ice", 1, 1],
                [1, 0, 3, "ice", "ice", "ice", 2, "ice", 2, 2, 1],
                ["ice", "ice", "ice", "ice", 0, "ice", "ice", "ice", "ice", 3],
                [1, 0, 3, "ice", 2, 0, "ice", 2, 3, "ice", 3],
                [0, 1, "ice", 1, "baby2", 3, "ice", 0, 3, "ice"],
                ["ice", "ice", "ice", 1, 1, 3, 3, "ice",
                    0, 3, "ice"
                ],
                [0, "ice", "ice", "ice", "ice", "ice", "ice", "ice", 2, "ice"],
                [0, 1, 0, 1, 2, 3, 2, 3, "ice", "ice", 3],
                [1, 0, 1, 0, 1, 2, 3, 2, "ice", 3]
            ]
        },
        lvl11: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [0, 15, 15, 15],
            armoEachArmo: 15,
            starScore: [1100, 2E3, 3E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            speech: ["Popping each + bubble will give you 3 extra bubbles"],
            arrow: {
                x: 72,
                y: 318
            },
            map: [
                [1, 1, , , 3, 3, , , 3, 3],
                [2, "babyice", 3, , 2, "babyice", 1, , 2, "babyice", 1],
                ["minus2",
                    3, , , "minus2", "plus1", , , 2, "minus1"
                ],
                [, "babyice", , , , "babyice", , , , "babyice"],
                ["plus2", 2, , , 3, 1, , , "plus1", 1],
                [3, "babyice", 2, , "plus3", "babyice", "minus1", , 1, "babyice", "minus2"],
                [3, "plus3", , , 3, "minus1", , , "minus2", 2],
                [, "babyice", , , , "babyice", , , , "babyice"],
                [3, "minus3", , , 1, 1, , , 2, 2],
                ["plus2", "babyice", "minus3", , 3, "babyice", 2, , "plus2", "babyice", "minus3"],
                [2, 2, , , 3, 2, , , 3, 3],
                [, "babyice", , , , "babyice", , , , "babyice"],
                ["plus2", 2, , , 3, 2, , , "minus3", 3],
                [1, "babyice", 2, , "minus3", "babyice", "minus2", , 3, "babyice", 1],
                [1, 1, , , 1,
                    1, , , 1, 1
                ]
            ]
        },
        lvl12: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 20,
            starScore: [2E3, 3E3, 4E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                ["baby0", 0, , , 1, 3, , , 2, "baby2"],
                [0, 3, 0, 3, 2, , 0, 1, 2, 1, 2],
                [, 3, 3, , , , , 1, 1], "ice ice ice ice ice ice ice ice ice ice ice".split(" "), [0, 1, 2, 3, 0, 1, 2, 3, 0, 1],
                [1, 2, "plus0", 1, 2, "plus3", 0, "minus2", 1, 3, 0],
                [3, 1, 2, 3, 0, "minus1", 2, 3, "plus0", 1],
                ["ice", 2, "minus0", 3, "plus2", "ice", 3, 1, 2, 3, "ice"],
                [0, 1, "ice", 3, 0, 3, 0, "ice", "minus1", 2],
                [3, 2, "plus2", 0, "minus1", 3, 1, 2, 0, 0, 1],
                [3, 3, 2, 0, 0, 2, "plus2", 0, 1, 1],
                [1, 1, 0, 3, 2, 1, 0, 3, 2, "minus0", 3],
                [2, 3, "ice", 1, 0, 3, 2, "ice", 3, 1]
            ]
        },
        lvl13: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [0, 20, 20, 20],
            armoEachArmo: 24,
            starScore: [3E3, 4E3, 5E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: ["babyice babyice babyice babyice babyice babyice babyice babyice babyice".split(" "), "ice ice ice ice ice ice ice ice ice ice".split(" "), [, 2, 2, 3, 3, 1, 2, 2, 3, "ice"],
                [, , 2, 1, 1, 3, "ice", 1, 1, "ice", "ice"],
                [, "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice"],
                [, "ice", "ice", 2, 1, 1, 3, 2, 2, 1],
                ["ice", "ice", 1, 3, 2, 3, 1, 3, 3],
                [, "ice", "ice", 1, 3, "ice", 2, 2, 1, 1],
                [, "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice"],
                [, , 1, 1, 3, 2, 3, 2, 1, "ice"],
                [, , 2, 3, 1, 1, "ice", 1, "ice", "ice"],
                [, , "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice"],
                [, "ice", 2, 3, 1, 2, 3, 1, 1],
                [, "ice", "ice", 2, "ice", 3, 3, 2, 3, 1],
                [, "ice", "ice", "ice", "ice", "ice", "ice", "ice", "ice"],
                [, 1, 2, 1, 3, 3, 1, 1, 3, "ice"],
                [2, 3,
                    3, 1, 2, "ice", 2, 2, "ice", "ice"
                ], "ice ice ice ice ice ice ice ice ice ice".split(" ")
            ]
        },
        lvl14: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 0],
            armoEachArmo: 16,
            starScore: [2800, 4E3, 6E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            arrow: {
                x: 241,
                y: 385
            },
            speech: ["Hitting thunder bubble will pop the whole row of bubbles!"],
            map: ["babyice babyice babyice babyice babyice wood wood thunder wood wood".split(" "), [2, 2, 0, 0, 1, 1, 0, "ice", "ice",
                    0, 0
                ],
                [1, 0, "ice", 2, 1, 2, 2, "ice", 2, 2],
                [0, 1, "ice", "ice", 1, 0, 2, 0, 1, 1, 0],
                [0, 0, 2, 2, 0, 1, 0, 1, 2, 0],
                ["wood", "wood", "thunder", "wood", "wood", 2, 2, "ice", "ice", 2, 0],
                [0, "ice", "ice", 1, 0, 2, 0, 2, 1, 0],
                [0, 2, "ice", 1, 2, 1, 1, 0, 2, 1, 1],
                [2, 0, 0, 0, 2, 2, 1, 1, 0, 0],
                [2, 1, "ice", "ice", 1, 1, "wood", "wood", "thunder", "wood", "wood"],
                [0, 1, 0, 2, 0, 1, 1, "ice", "ice", 0],
                [0, 0, 1, 2, 0, 0, 2, 0, "ice", 0, 0],
                [0, 2, 0, 2, 1, 0, 2, 2, 2, 0], "wood wood wood wood wood thunder wood wood wood wood wood".split(" ")
            ]
        },
        lvl15: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange",
                    "pink", "purple"
                ],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [0, 13, 13, 13],
            armoEachArmo: 20,
            starScore: [1500, 2500, 3E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: ["wood ice ice babyice ice ice babyice ice ice wood".split(" "), "baby1 wood wood wood wood thunder wood wood wood wood baby3".split(" "), "wood ice ice ice ice ice ice ice ice wood".split(" "), ["baby2", "wood", 2, 2, "ice", "ice", "ice", "ice", "ice", "wood", "baby2"],
                ["wood", 1, "thunder", 3, "ice", "minus1", "minus1", "minus2", "minus3", "wood"],
                ["baby3", "wood", 1,
                    3, "ice", 3, 3, "minus2", "minus3", "wood", "baby1"
                ],
                ["wood", "ice", "ice", "ice", "minus2", 1, "ice", "ice", "ice", "wood"],
                ["baby1", "wood", 2, 1, 2, 1, "ice", 2, 3, "wood", "baby3"],
                ["wood", "minus3", 2, 3, 3, "ice", 1, "thunder", 1, "wood"],
                ["baby2", "wood", "minus3", 1, 3, 2, "ice", 3, 2, "wood", "baby2"],
                ["wood", 1, 1, 2, "ice", "minus2", "ice", "ice", "ice", "wood"],
                ["baby3", "wood", "ice", 2, 1, 1, 2, "ice", 3, "wood", "baby1"],
                ["wood", "ice", 2, "ice", 1, "ice", "ice", 2, "ice", "wood"]
            ]
        },
        lvl16: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink",
                    "purple"
                ],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 13,
            starScore: [2E3, 4E3, 5E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                ["thunder", , 3, 3, , , , "ice", 2, 2],
                [, , 2, "babyice", 0, , , "ice", 3, "babyice", 1],
                [, , 2, 0, 1, 1, "ice", , 3, 1],
                [, 3, 3, "ice", "ice", 3, , 0, , 2],
                [3, , , , , 3, , 0, , 2],
                ["ice", "ice", 2, 2, "ice", "ice", 2, , 1, , ],
                [, 0, , "ice", "thunder", "ice", , , 1],
                [, 0, , 3, "ice", "ice", 1, , , , ],
                [2, , 3, , 2, , 1, , , ],
                [2, , 0, , 2, "ice", , 1, 0, 0],
                [, 0, , 3, , "babyice", "ice", 3, "thunder", 0],
                [, , , 3, , "ice", , , 3, 1],
                [, , , "ice", 2, 2, 2, 1, , ],
                [, 0, 0,
                    "ice", 3, , 0, , 1, ,
                ],
                [3, "babyice", 1, , 3, , 0, , 2],
                [, 3, 2, , , 0, , 1, , 2],
                [, , , , , 0, , 1, , ]
            ]
        },
        lvl17: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [16, 16, 16, 16],
            armoEachArmo: 16,
            starScore: [2E3, 3E3, 4200],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            speech: ["Avoid hitting skull bubbles at all course!", "Otherwise you'll lose the game!"],
            arrow: {
                x: 127,
                y: 182
            },
            map: ["ice ice babyice ice ice ice ice ice babyice ice".split(" "), [, 1, 2, "evil", 0, , 1, "evil", 2, 3],
                [, 1, 2,
                    0, , , 1, 2, 3
                ],
                [, , 0, 1, , , , 3, 0, , ],
                [1, 0, 2, 1, 1, 3, 3, 2, 1, 1],
                [1, 3, 2, 0, 0, "evil", 2, 0, 0, 2, 1],
                [, 1, 3, 3, 0, 2, 0, 1, 2],
                [, 1, "evil", 2, 3, , 2, 1, "evil", 0],
                [, 1, 2, , , , , 3, 0],
                [, , "ice", , , , , , "ice", , ],
                [1, "ice", 3, 2, 1, 2, 1, 0, "ice", 3],
                ["ice", 0, 3, "ice", 1, 0, 1, "ice", 2, 0, "ice"],
                ["ice", 0, 1, "ice", 2, 0, "ice", 1, 3, "ice"],
                [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2]
            ]
        },
        lvl18: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            armoEachArmo: 13,
            starScore: [1800, 3E3, 4E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            speech: ["Shoot star bubble to pop all bubbles with the same colour with your shooting bubble"],
            arrow: {
                x: 243,
                y: 183
            },
            map: [
                [0, 0, , 2, 2, 1, 1, , 2, 2],
                [1, "star", 3, 3, "evil", "evil", "evil", 0, 0, "star", 3],
                [1, 3, , "evil", "baby0", "baby0", "evil", , 0, 3],
                [, , , "evil", "baby3", "baby1", "baby2", "evil", , , ],
                [, 3, 3, "evil", "baby3", "baby2", "evil", 0, 0],
                [, , , 3, "evil", "evil", "evil", 0, , , ],
                [, , , , 1, 1, , , , ],
                [3, 3, "evil", 2, 2, "star", 2, 2, "evil", 3, 3],
                [1, 0, 0, 3, 3, 3, 3, 1, 1, 0],
                [1, 0, 1, 2, 1, 2, 0, "ice", 0, 1, 3],
                [2, 2, 0, 1, 0, 1, "evil", "ice", 2, 3],
                [2, 1,
                    "ice", "evil", "ice", 3, 2, 1, 3, 2, 2
                ],
                [1, 2, 3, 1, 2, 3, 2, 1, 0, 3],
                [0, 0, 3, 2, 3, 2, 1, 0, 2, 1, 1]
            ]
        },
        lvl19: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [20, 20, 20, 20],
            armoEachArmo: 26,
            starScore: [1500, 2500, 4E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [3, "ice", "babyice", "ice", 0, 0, "ice", "babyice", "ice", 1],
                ["ice", , , , "ice", "babyice", "ice", , , , "ice"],
                ["babyice", "ice", 3, 1, 0, 2, 2, 1, "ice", "babyice"],
                [, , , , "ice", , "ice", , , , ],
                [, , 1, 1, 0, 0, 2, 2, , ],
                [, , "evil", , "ice", , "evil", , 1, , ],
                [, 2, , 3, 3, 1, 1, , 3],
                [, 1, , "evil", , 0, , 1, , 0],
                [3, , 1, , 1, 2, , 2, , 1],
                ["ice", "ice", 2, "ice", 3, "babyice", 3, "ice", 3, "ice", 2],
                ["ice", , 3, , 2, 1, , 0, , 3],
                [, 2, , "evil", , "ice", , "evil", , 0],
                [, 0, , 0, 1, 2, 3, , "evil"],
                [, , 0, "ice", , "ice", , "ice", "ice", , ],
                [, , 1, 3, 2, 0, 1, 3, , ]
            ]
        },
        lvl20: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [20, 20, 20, 20],
            armoEachArmo: 20,
            starScore: [3E3, 5E3, 6E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [3, 2, 2, "baby1", "baby1", 3, 3, 3,
                    "ice", "ice"
                ],
                [3, "ice", "ice", "ice", 2, 1, 0, 2, "ice", "baby3", "ice"],
                [1, 0, 0, 2, 3, 3, 0, 3, "ice", "ice"],
                [1, "wood", "wood", 0, 1, 3, 2, 2, 1, 3, 1], "wood thunder ice evil evil evil evil evil evil evil".split(" "), [3, "ice", "ice", 0, 3, 3, "baby2", "baby0", "baby3", 1, 1],
                [3, 2, 2, 0, 1, 3, 0, 2, 1, 3],
                [0, 2, "ice", "ice", "ice", 1, 1, "ice", "ice", "ice", 3],
                [0, 1, 3, 2, 0, 3, 3, 1, 1, 2],
                [0, 1, 1, 3, 0, 2, 0, 1, "wood", "wood", 2], "evil evil evil evil evil evil evil ice thunder wood".split(" "), [3, 0, "baby3", "baby2", "baby0", 2, 3, 2, "ice", "ice", 3],
                [3, 2, 0, 1, 1, 3, 1, 2, 0,
                    3
                ],
                [2, "ice", "ice", "ice", 3, 0, 3, "ice", "ice", "ice", 3],
                [2, 2, 0, 0, 3, 2, 0, 1, 3, 1],
                [3, "wood", "wood", 3, 2, 2, 1, 3, 0, 0, 1], "wood thunder ice evil evil evil evil evil evil evil".split(" "), [0, "ice", "ice", 3, 2, 0, 3, 2, 1, 3, 0],
                [3, 1, 2, 3, 2, 0, 2, 0, 2, 1]
            ]
        },
        lvl21: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [20, 20, 20, 0],
            armoEachArmo: 25,
            starScore: [4E3, 5500, 7E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [2, 0, 2, "ice", "wood", "ice", 1, 1, 1, 0],
                [2, 1, 1, "ice", "wood",
                    "ice", 2, "wood", "wood", 0, 2
                ],
                [1, 0, "ice", "thunder", "ice", 1, "wood", "baby2", "wood", 2],
                [2, 2, 0, "ice", "wood", "ice", 2, "wood", "wood", 1, 1],
                [0, "wood", "wood", "ice", "wood", "ice", 2, 0, 0, 2],
                [0, "wood", "baby1", "wood", "ice", "thunder", "ice", 0, 1, 1, 2],
                [1, "wood", "wood", 0, "ice", "wood", "ice", 0, 2, 0],
                [1, 0, 0, 1, 0, "ice", "wood", "ice", 2, 1, 0],
                [1, 2, 2, 1, 2, "ice", "thunder", "ice", 0, 1],
                [2, 0, 1, 2, "ice", "wood", "ice", "wood", "wood", 2, 0],
                [0, 1, 0, "ice", "thunder", "ice", "wood", "baby0", "wood", 2],
                [2, 1, 2, "ice", "wood", "ice", 2, "wood", "wood", 1, 1],
                [2, 0,
                    "ice", "wood", "ice", 1, 2, 0, 0, 1
                ],
                [1, 1, 2, 1, "ice", "wood", "ice", 1, 2, 2, 0],
                [0, 2, 0, 1, "ice", "wood", "ice", 1, 1, 0],
                [0, 1, 1, 2, 0, "ice", "wood", "ice", 0, 2, 2]
            ]
        },
        lvl22: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [0, 20, 20, 20],
            armoEachArmo: 30,
            starScore: [1500, 3E3, 5E3],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                ["ice", "babyice", 2, "babyice", 2, 1, "babyice", "ice", "babyice", "ice"],
                [, "ice", , 1, 3, , 3, 2, , "ice"],
                [, "ice", "ice", , 1, 2, , "evil", 1],
                [, , "evil", , , "ice", , , "ice", , ],
                [, 1, 3, , "ice", "ice", , 2, 1],
                [, 1, "babyice", "evil", 3, , "ice", "evil", "babyice", 1],
                [, 1, 2, "ice", "ice", "evil", "ice", 2, 1],
                [, , "ice", , , , , , "ice", , ],
                [, "ice", 3, , 3, 3, , 1, "ice"],
                [, "ice", , "ice", 1, , 2, "evil", , "ice"],
                ["evil", "ice", 1, "ice", 1, 2, "ice", "ice", 2, "ice"],
                [, , , , , "ice", , , , , ],
                [, , , , "ice", "ice", , , , ],
                [, 1, 1, , "ice", , "evil", , 2, 2],
                [1, "babyice", 1, "ice", "ice", "ice", "ice", 2, "babyice", 2],
                [, 1, 1, , "evil", , 2, , 2, 2],
                [, "ice", , , 1, "ice", , , "evil"],
                [, "evil", 1, , , "ice", , , "ice", "evil"],
                ["ice", , "ice", , 3, "evil", , "ice", , "ice"],
                [1,
                    "ice", 3, "ice", 3, "babyice", 3, "ice", 3, "ice", 2
                ],
                [, , , , 3, 3, , , , ]
            ]
        },
        lvl23: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [20, 20, 20, 20],
            armoEachArmo: 30,
            starScore: [5E3, 7E3, 1E4],
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: ["babyice babyice thunder babyice thunder babyice babyice thunder babyice babyice".split(" "), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""),
                "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split(""), "rrrrrrrrrrr".split(""), "rrrrrrrrrr".split("")
            ]
        },
        lvl24: {
            colourSet: [
                ["cyan", "pink", "purple", "green"],
                ["red", "orange", "pink", "purple"],
                ["green", "yellow", "orange", "purple"]
            ],
            armo: [13, 13, 13, 13],
            starScore: [100, 500, 600],
            armoEachArmo: 20,
            armoExtra: 1,
            rainbow: 0,
            rowOffset: 0,
            map: [
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ],
                [, , , , , , , , , ],
                [, , , , , , , , , , ]
            ]
        }
    };
var _SETTINGS = {
    API: {
        Enabled: !0,
        Log: {
            Events: {
                InitializeGame: !0,
                EndGame: !0,
                Level: {
                    Begin: !0,
                    End: !0,
                    Win: !0,
                    Lose: !0,
                    Draw: !0
                }
            }
        }
    },
    Ad: {
        Mobile: {
            Preroll: {
                Enabled: !0,
                Duration: 5,
                Width: 300,
                Height: 250,
                Rotation: {
                    Enabled: !1,
                    Weight: {
                        MobileAdInGamePreroll: 40,
                        MobileAdInGamePreroll2: 40,
                        MobileAdInGamePreroll3: 20
                    }
                }
            },
            Header: {
                Enabled: !1,
                Duration: 5,
                Width: 320,
                Height: 50,
                Rotation: {
                    Enabled: !1,
                    Weight: {
                        MobileAdInGameHeader: 40,
                        MobileAdInGameHeader2: 40,
                        MobileAdInGameHeader3: 20
                    }
                }
            },
            Footer: {
                Enabled: !1,
                Duration: 5,
                Width: 320,
                Height: 50,
                Rotation: {
                    Enabled: !1,
                    Weight: {
                        MobileAdInGameFooter: 40,
                        MobileAdInGameFooter2: 40,
                        MobileAdInGameFooter3: 20
                    }
                }
            },
            End: {
                Enabled: !1,
                Duration: 1,
                Width: 300,
                Height: 250,
                Rotation: {
                    Enabled: !1,
                    Weight: {
                        MobileAdInGameEnd: 40,
                        MobileAdInGameEnd2: 40,
                        MobileAdInGameEnd3: 20
                    }
                }
            }
        }
    },
    Language: {
        Default: "en"
    },
    DeveloperBranding: {
        Splash: {
            Enabled: !0
        },
        Logo: {
            Enabled: !0,
            Link: "/marketjs.com",
            LinkEnabled: !1,
            NewWindow: !0,
            Width: 166,
            Height: 61
        }
    },
    Branding: {
        Splash: {
            Enabled: !1
        },
        Logo: {
            Enabled: !1,
            Link: "/google.com",
            LinkEnabled: !1,
            NewWindow: !0,
            Width: 280,
            Height: 34
        }
    },
    MoreGames: {
        Enabled: !1,
        Link: "/www.marketjs.com/game/links/mobile",
        NewWindow: !0
    },
    Gamecenter: {
        Enabled: !1
    }
};

(function(b, c) {
    function d(b, j, z) {
        if (z === c && 1 === b.nodeType)
            if (z = "data-" + j.replace(tc, "-$1").toLowerCase(), z = b.getAttribute(z), "string" == typeof z) {
                try {
                    z = "true" === z ? !0 : "false" === z ? !1 : "null" === z ? null : +z + "" === z ? +z : uc.test(z) ? f.parseJSON(z) : z
                } catch (d) {}
                f.data(b, j, z)
            } else z = c;
        return z
    }

    function e(b) {
        for (var j in b)
            if (!("data" === j && f.isEmptyObject(b[j])) && "toJSON" !== j) return !1;
        return !0
    }

    function g() {
        return !1
    }

    function m() {
        return !0
    }

    function y(b) {
        return !b || !b.parentNode || 11 === b.parentNode.nodeType
    }

    function s(b,
        j) {
        do b = b[j]; while (b && 1 !== b.nodeType);
        return b
    }

    function t(b, j, c) {
        j = j || 0;
        if (f.isFunction(j)) return f.grep(b, function(b, u) {
            return !!j.call(b, u, b) === c
        });
        if (j.nodeType) return f.grep(b, function(b) {
            return b === j === c
        });
        if ("string" == typeof j) {
            var d = f.grep(b, function(b) {
                return 1 === b.nodeType
            });
            if (vc.test(j)) return f.filter(j, d, !c);
            j = f.filter(j, d)
        }
        return f.grep(b, function(b) {
            return 0 <= f.inArray(b, j) === c
        })
    }

    function v(b) {
        var j = xb.split("|");
        b = b.createDocumentFragment();
        if (b.createElement)
            for (; j.length;) b.createElement(j.pop());
        return b
    }

    function r(b, j) {
        if (1 === j.nodeType && f.hasData(b)) {
            var c, d, x;
            d = f._data(b);
            var B = f._data(j, d),
                q = d.events;
            if (q)
                for (c in delete B.handle, B.events = {}, q) {
                    d = 0;
                    for (x = q[c].length; d < x; d++) f.event.add(j, c, q[c][d])
                }
            B.data && (B.data = f.extend({}, B.data))
        }
    }

    function l(b, j) {
        var c;
        1 === j.nodeType && (j.clearAttributes && j.clearAttributes(), j.mergeAttributes && j.mergeAttributes(b), c = j.nodeName.toLowerCase(), "object" === c ? (j.parentNode && (j.outerHTML = b.outerHTML), f.support.html5Clone && b.innerHTML && !f.trim(j.innerHTML) &&
            (j.innerHTML = b.innerHTML)) : "input" === c && yb.test(b.type) ? (j.defaultChecked = j.checked = b.checked, j.value !== b.value && (j.value = b.value)) : "option" === c ? j.selected = b.defaultSelected : "input" === c || "textarea" === c ? j.defaultValue = b.defaultValue : "script" === c && j.text !== b.text && (j.text = b.text), j.removeAttribute(f.expando))
    }

    function n(b) {
        return "undefined" != typeof b.getElementsByTagName ? b.getElementsByTagName("*") : "undefined" != typeof b.querySelectorAll ? b.querySelectorAll("*") : []
    }

    function p(b) {
        yb.test(b.type) && (b.defaultChecked =
            b.checked)
    }

    function A(b, j) {
        if (j in b) return j;
        for (var c = j.charAt(0).toUpperCase() + j.slice(1), f = j, d = zb.length; d--;)
            if (j = zb[d] + c, j in b) return j;
        return f
    }

    function E(b, j) {
        return b = j || b, "none" === f.css(b, "display") || !f.contains(b.ownerDocument, b)
    }

    function C(b, j) {
        for (var c, d, x = [], B = 0, q = b.length; B < q; B++) c = b[B], c.style && (x[B] = f._data(c, "olddisplay"), j ? (!x[B] && "none" === c.style.display && (c.style.display = ""), "" === c.style.display && E(c) && (x[B] = f._data(c, "olddisplay", P(c.nodeName)))) : (d = Q(c, "display"), !x[B] && "none" !==
            d && f._data(c, "olddisplay", d)));
        for (B = 0; B < q; B++)
            if (c = b[B], c.style && (!j || "none" === c.style.display || "" === c.style.display)) c.style.display = j ? x[B] || "" : "none";
        return b
    }

    function G(b, j, c) {
        return (b = wc.exec(j)) ? Math.max(0, b[1] - (c || 0)) + (b[2] || "px") : j
    }

    function Ya(b, j, c, d) {
        j = c === (d ? "border" : "content") ? 4 : "width" === j ? 1 : 0;
        for (var x = 0; 4 > j; j += 2) "margin" === c && (x += f.css(b, c + ea[j], !0)), d ? ("content" === c && (x -= parseFloat(Q(b, "padding" + ea[j])) || 0), "margin" !== c && (x -= parseFloat(Q(b, "border" + ea[j] + "Width")) || 0)) : (x += parseFloat(Q(b,
            "padding" + ea[j])) || 0, "padding" !== c && (x += parseFloat(Q(b, "border" + ea[j] + "Width")) || 0));
        return x
    }

    function I(b, j, c) {
        var d = "width" === j ? b.offsetWidth : b.offsetHeight,
            x = !0,
            B = f.support.boxSizing && "border-box" === f.css(b, "boxSizing");
        if (0 >= d || null == d) {
            d = Q(b, j);
            if (0 > d || null == d) d = b.style[j];
            if (za.test(d)) return d;
            x = B && (f.support.boxSizingReliable || d === b.style[j]);
            d = parseFloat(d) || 0
        }
        return d + Ya(b, j, c || (B ? "border" : "content"), x) + "px"
    }

    function P(b) {
        if (Za[b]) return Za[b];
        var j = f("<" + b + ">").appendTo(D.body),
            c = j.css("display");
        j.remove();
        if ("none" === c || "" === c) {
            la = D.body.appendChild(la || f.extend(D.createElement("iframe"), {
                frameBorder: 0,
                width: 0,
                height: 0
            }));
            if (!ma || !la.createElement) ma = (la.contentWindow || la.contentDocument).document, ma.write("<!doctype html><html><body>"), ma.close();
            j = ma.body.appendChild(ma.createElement(b));
            c = Q(j, "display");
            D.body.removeChild(la)
        }
        return Za[b] = c, c
    }

    function N(b, j, c, d) {
        var x;
        if (f.isArray(j)) f.each(j, function(j, f) {
            c || xc.test(b) ? d(b, f) : N(b + "[" + ("object" == typeof f ? j : "") + "]", f, c, d)
        });
        else if (!c &&
            "object" === f.type(j))
            for (x in j) N(b + "[" + x + "]", j[x], c, d);
        else d(b, j)
    }

    function Aa(b) {
        return function(j, c) {
            "string" != typeof j && (c = j, j = "*");
            var d, x, B = j.toLowerCase().split(fa),
                q = 0,
                e = B.length;
            if (f.isFunction(c))
                for (; q < e; q++) d = B[q], (x = /^\+/.test(d)) && (d = d.substr(1) || "*"), d = b[d] = b[d] || [], d[x ? "unshift" : "push"](c)
        }
    }

    function na(b, j, z, f, d, B) {
        d = d || j.dataTypes[0];
        B = B || {};
        B[d] = !0;
        var q;
        d = b[d];
        for (var e = 0, l = d ? d.length : 0, g = b === $a; e < l && (g || !q); e++) q = d[e](j, z, f), "string" == typeof q && (!g || B[q] ? q = c : (j.dataTypes.unshift(q),
            q = na(b, j, z, f, q, B)));
        return (g || !q) && !B["*"] && (q = na(b, j, z, f, "*", B)), q
    }

    function sa(b, j) {
        var z, d, x = f.ajaxSettings.flatOptions || {};
        for (z in j) j[z] !== c && ((x[z] ? b : d || (d = {}))[z] = j[z]);
        d && f.extend(!0, b, d)
    }

    function Ab() {
        try {
            return new b.XMLHttpRequest
        } catch (u) {}
    }

    function Bb() {
        return setTimeout(function() {
            Ba = c
        }, 0), Ba = f.now()
    }

    function Cb(b, j, c) {
        var d, x = 0,
            B = Ca.length,
            q = f.Deferred().always(function() {
                delete e.elem
            }),
            e = function() {
                for (var j = Ba || Bb(), j = Math.max(0, l.startTime + l.duration - j), c = 1 - (j / l.duration || 0), z =
                    0, f = l.tweens.length; z < f; z++) l.tweens[z].run(c);
                return q.notifyWith(b, [l, c, j]), 1 > c && f ? j : (q.resolveWith(b, [l]), !1)
            },
            l = q.promise({
                elem: b,
                props: f.extend({}, j),
                opts: f.extend(!0, {
                    specialEasing: {}
                }, c),
                originalProperties: j,
                originalOptions: c,
                startTime: Ba || Bb(),
                duration: c.duration,
                tweens: [],
                createTween: function(j, c) {
                    var z = f.Tween(b, l.opts, j, c, l.opts.specialEasing[j] || l.opts.easing);
                    return l.tweens.push(z), z
                },
                stop: function(j) {
                    for (var c = 0, z = j ? l.tweens.length : 0; c < z; c++) l.tweens[c].run(1);
                    return j ? q.resolveWith(b, [l, j]) : q.rejectWith(b, [l, j]), this
                }
            });
        j = l.props;
        c = l.opts.specialEasing;
        var g, n, p, s;
        for (d in j)
            if (g = f.camelCase(d), n = c[g], p = j[d], f.isArray(p) && (n = p[1], p = j[d] = p[0]), d !== g && (j[g] = p, delete j[d]), (s = f.cssHooks[g]) && "expand" in s)
                for (d in p = s.expand(p), delete j[g], p) d in j || (j[d] = p[d], c[d] = n);
            else c[g] = n;
        for (; x < B; x++)
            if (d = Ca[x].call(l, b, j, l.opts)) return d;
        var m = l;
        f.each(j, function(b, u) {
            for (var j = (ua[b] || []).concat(ua["*"]), c = 0, z = j.length; c < z && !j[c].call(m, b, u); c++);
        });
        return f.isFunction(l.opts.start) && l.opts.start.call(b,
            l), f.fx.timer(f.extend(e, {
            anim: l,
            queue: l.opts.queue,
            elem: b
        })), l.progress(l.opts.progress).done(l.opts.done, l.opts.complete).fail(l.opts.fail).always(l.opts.always)
    }

    function S(b, j, c, f, d) {
        return new S.prototype.init(b, j, c, f, d)
    }

    function Da(b, j) {
        var c, f = {
                height: b
            },
            d = 0;
        for (j = j ? 1 : 0; 4 > d; d += 2 - j) c = ea[d], f["margin" + c] = f["padding" + c] = b;
        return j && (f.opacity = f.width = b), f
    }

    function Db(b) {
        return f.isWindow(b) ? b : 9 === b.nodeType ? b.defaultView || b.parentWindow : !1
    }
    var Eb, Ea, D = b.document,
        zc = b.location,
        Ac = b.navigator,
        Bc =
        b.jQuery,
        Cc = b.$,
        Fb = Array.prototype.push,
        aa = Array.prototype.slice,
        Gb = Array.prototype.indexOf,
        Dc = Object.prototype.toString,
        ab = Object.prototype.hasOwnProperty,
        bb = String.prototype.trim,
        f = function(b, j) {
            return new f.fn.init(b, j, Eb)
        },
        Fa = /[\-+]?(?:\d*\.|)\d+(?:[eE][\-+]?\d+|)/.source,
        Ec = /\S/,
        fa = /\s+/,
        Fc = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,
        Gc = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/,
        Hb = /^<(\w+)\s*\/?>(?:<\/\1>|)$/,
        Hc = /^[\],:{}\s]*$/,
        Ic = /(?:^|:|,)(?:\s*\[)+/g,
        Jc = /\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g,
        Kc = /"[^"\\\r\n]*"|true|false|null|-?(?:\d\d*\.|)\d+(?:[eE][\-+]?\d+|)/g,
        Lc = /^-ms-/,
        Mc = /-([\da-z])/gi,
        Nc = function(b, j) {
            return (j + "").toUpperCase()
        },
        Ga = function() {
            D.addEventListener ? (D.removeEventListener("DOMContentLoaded", Ga, !1), f.ready()) : "complete" === D.readyState && (D.detachEvent("onreadystatechange", Ga), f.ready())
        },
        Ib = {};
    f.fn = f.prototype = {
        constructor: f,
        init: function(b, j, z) {
            var d, x;
            if (!b) return this;
            if (b.nodeType) return this.context = this[0] = b, this.length = 1, this;
            if ("string" == typeof b) {
                "<" === b.charAt(0) && ">" === b.charAt(b.length - 1) && 3 <= b.length ? d = [null, b, null] : d = Gc.exec(b);
                if (d && (d[1] || !j)) {
                    if (d[1]) return j = j instanceof f ? j[0] : j, x = j && j.nodeType ? j.ownerDocument || j : D, b = f.parseHTML(d[1], x, !0), Hb.test(d[1]) && f.isPlainObject(j) && this.attr.call(b, j, !0), f.merge(this, b);
                    if ((j = D.getElementById(d[2])) && j.parentNode) {
                        if (j.id !== d[2]) return z.find(b);
                        this.length = 1;
                        this[0] = j
                    }
                    return this.context = D, this.selector = b, this
                }
                return !j || j.jquery ? (j || z).find(b) : this.constructor(j).find(b)
            }
            return f.isFunction(b) ? z.ready(b) : (b.selector !== c && (this.selector = b.selector, this.context = b.context), f.makeArray(b,
                this))
        },
        selector: "",
        jquery: "1.8.2",
        length: 0,
        size: function() {
            return this.length
        },
        toArray: function() {
            return aa.call(this)
        },
        get: function(b) {
            return null == b ? this.toArray() : 0 > b ? this[this.length + b] : this[b]
        },
        pushStack: function(b, j, c) {
            b = f.merge(this.constructor(), b);
            return b.prevObject = this, b.context = this.context, "find" === j ? b.selector = this.selector + (this.selector ? " " : "") + c : j && (b.selector = this.selector + "." + j + "(" + c + ")"), b
        },
        each: function(b, j) {
            return f.each(this, b, j)
        },
        ready: function(b) {
            return f.ready.promise().done(b),
                this
        },
        eq: function(b) {
            return b = +b, -1 === b ? this.slice(b) : this.slice(b, b + 1)
        },
        first: function() {
            return this.eq(0)
        },
        last: function() {
            return this.eq(-1)
        },
        slice: function() {
            return this.pushStack(aa.apply(this, arguments), "slice", aa.call(arguments).join(","))
        },
        map: function(b) {
            return this.pushStack(f.map(this, function(j, c) {
                return b.call(j, c, j)
            }))
        },
        end: function() {
            return this.prevObject || this.constructor(null)
        },
        push: Fb,
        sort: [].sort,
        splice: [].splice
    };
    f.fn.init.prototype = f.fn;
    f.extend = f.fn.extend = function() {
        var b,
            j, z, d, x, e, q = arguments[0] || {},
            l = 1,
            g = arguments.length,
            n = !1;
        "boolean" == typeof q && (n = q, q = arguments[1] || {}, l = 2);
        "object" != typeof q && !f.isFunction(q) && (q = {});
        for (g === l && (q = this, --l); l < g; l++)
            if (null != (b = arguments[l]))
                for (j in b) z = q[j], d = b[j], q !== d && (n && d && (f.isPlainObject(d) || (x = f.isArray(d))) ? (x ? (x = !1, e = z && f.isArray(z) ? z : []) : e = z && f.isPlainObject(z) ? z : {}, q[j] = f.extend(n, e, d)) : d !== c && (q[j] = d));
        return q
    };
    f.extend({
        noConflict: function(u) {
            return b.$ === f && (b.$ = Cc), u && b.jQuery === f && (b.jQuery = Bc), f
        },
        isReady: !1,
        readyWait: 1,
        holdReady: function(b) {
            b ? f.readyWait++ : f.ready(!0)
        },
        ready: function(b) {
            if (!(!0 === b ? --f.readyWait : f.isReady)) {
                if (!D.body) return setTimeout(f.ready, 1);
                f.isReady = !0;
                !0 !== b && 0 < --f.readyWait || (Ea.resolveWith(D, [f]), f.fn.trigger && f(D).trigger("ready").off("ready"))
            }
        },
        isFunction: function(b) {
            return "function" === f.type(b)
        },
        isArray: Array.isArray || function(b) {
            return "array" === f.type(b)
        },
        isWindow: function(b) {
            return null != b && b == b.window
        },
        isNumeric: function(b) {
            return !isNaN(parseFloat(b)) && isFinite(b)
        },
        type: function(b) {
            return null == b ? String(b) : Ib[Dc.call(b)] || "object"
        },
        isPlainObject: function(b) {
            if (!b || "object" !== f.type(b) || b.nodeType || f.isWindow(b)) return !1;
            try {
                if (b.constructor && !ab.call(b, "constructor") && !ab.call(b.constructor.prototype, "isPrototypeOf")) return !1
            } catch (j) {
                return !1
            }
            for (var z in b);
            return z === c || ab.call(b, z)
        },
        isEmptyObject: function(b) {
            for (var j in b) return !1;
            return !0
        },
        error: function(b) {
            throw Error(b);
        },
        parseHTML: function(b, j, c) {
            var d;
            return !b || "string" != typeof b ? null : ("boolean" ==
                typeof j && (c = j, j = 0), j = j || D, (d = Hb.exec(b)) ? [j.createElement(d[1])] : (d = f.buildFragment([b], j, c ? null : []), f.merge([], (d.cacheable ? f.clone(d.fragment) : d.fragment).childNodes)))
        },
        parseJSON: function(u) {
            if (!u || "string" != typeof u) return null;
            u = f.trim(u);
            if (b.JSON && b.JSON.parse) return b.JSON.parse(u);
            if (Hc.test(u.replace(Jc, "@").replace(Kc, "]").replace(Ic, ""))) return (new Function("return " + u))();
            f.error("Invalid JSON: " + u)
        },
        parseXML: function(u) {
            var j, z;
            if (!u || "string" != typeof u) return null;
            try {
                b.DOMParser ?
                    (z = new DOMParser, j = z.parseFromString(u, "text/xml")) : (j = new ActiveXObject("Microsoft.XMLDOM"), j.async = "false", j.loadXML(u))
            } catch (d) {
                j = c
            }
            return (!j || !j.documentElement || j.getElementsByTagName("parsererror").length) && f.error("Invalid XML: " + u), j
        },
        noop: function() {},
        globalEval: function(u) {
            u && Ec.test(u) && (b.execScript || function(u) {
                b.eval.call(b, u)
            })(u)
        },
        camelCase: function(b) {
            return b.replace(Lc, "ms-").replace(Mc, Nc)
        },
        nodeName: function(b, j) {
            return b.nodeName && b.nodeName.toLowerCase() === j.toLowerCase()
        },
        each: function(b, j, z) {
            var d, x = 0,
                e = b.length,
                q = e === c || f.isFunction(b);
            if (z)
                if (q)
                    for (d in b) {
                        if (!1 === j.apply(b[d], z)) break
                    } else
                        for (; x < e && !1 !== j.apply(b[x++], z););
                else if (q)
                for (d in b) {
                    if (!1 === j.call(b[d], d, b[d])) break
                } else
                    for (; x < e && !1 !== j.call(b[x], x, b[x++]););
            return b
        },
        trim: bb && !bb.call("\ufeff\u00a0") ? function(b) {
            return null == b ? "" : bb.call(b)
        } : function(b) {
            return null == b ? "" : (b + "").replace(Fc, "")
        },
        makeArray: function(b, j) {
            var c, d = j || [];
            return null != b && (c = f.type(b), null == b.length || "string" === c || "function" ===
                c || "regexp" === c || f.isWindow(b) ? Fb.call(d, b) : f.merge(d, b)), d
        },
        inArray: function(b, j, c) {
            var d;
            if (j) {
                if (Gb) return Gb.call(j, b, c);
                d = j.length;
                for (c = c ? 0 > c ? Math.max(0, d + c) : c : 0; c < d; c++)
                    if (c in j && j[c] === b) return c
            }
            return -1
        },
        merge: function(b, j) {
            var d = j.length,
                f = b.length,
                x = 0;
            if ("number" == typeof d)
                for (; x < d; x++) b[f++] = j[x];
            else
                for (; j[x] !== c;) b[f++] = j[x++];
            return b.length = f, b
        },
        grep: function(b, j, c) {
            var d, f = [],
                e = 0,
                q = b.length;
            for (c = !!c; e < q; e++) d = !!j(b[e], e), c !== d && f.push(b[e]);
            return f
        },
        map: function(b, j, d) {
            var F,
                x, e = [],
                q = 0,
                l = b.length;
            if (b instanceof f || l !== c && "number" == typeof l && (0 < l && b[0] && b[l - 1] || 0 === l || f.isArray(b)))
                for (; q < l; q++) F = j(b[q], q, d), null != F && (e[e.length] = F);
            else
                for (x in b) F = j(b[x], x, d), null != F && (e[e.length] = F);
            return e.concat.apply([], e)
        },
        guid: 1,
        proxy: function(b, j) {
            var d, F, x;
            return "string" == typeof j && (d = b[j], j = b, b = d), f.isFunction(b) ? (F = aa.call(arguments, 2), x = function() {
                return b.apply(j, F.concat(aa.call(arguments)))
            }, x.guid = b.guid = b.guid || f.guid++, x) : c
        },
        access: function(b, j, d, F, x, e, q) {
            var l, g =
                null == d,
                n = 0,
                p = b.length;
            if (d && "object" == typeof d) {
                for (n in d) f.access(b, j, n, d[n], 1, e, F);
                x = 1
            } else if (F !== c) {
                l = q === c && f.isFunction(F);
                g && (l ? (l = j, j = function(b, u, j) {
                    return l.call(f(b), j)
                }) : (j.call(b, F), j = null));
                if (j)
                    for (; n < p; n++) j(b[n], d, l ? F.call(b[n], n, j(b[n], d)) : F, q);
                x = 1
            }
            return x ? b : g ? j.call(b) : p ? j(b[0], d) : e
        },
        now: function() {
            return (new Date).getTime()
        }
    });
    f.ready.promise = function(u) {
        if (!Ea)
            if (Ea = f.Deferred(), "complete" === D.readyState) setTimeout(f.ready, 1);
            else if (D.addEventListener) D.addEventListener("DOMContentLoaded",
            Ga, !1), b.addEventListener("load", f.ready, !1);
        else {
            D.attachEvent("onreadystatechange", Ga);
            b.attachEvent("onload", f.ready);
            var j = !1;
            try {
                j = null == b.frameElement && D.documentElement
            } catch (c) {}
            j && j.doScroll && function x() {
                if (!f.isReady) {
                    try {
                        j.doScroll("left")
                    } catch (b) {
                        return setTimeout(x, 50)
                    }
                    f.ready()
                }
            }()
        }
        return Ea.promise(u)
    };
    f.each("Boolean Number String Function Array Date RegExp Object".split(" "), function(b, j) {
        Ib["[object " + j + "]"] = j.toLowerCase()
    });
    Eb = f(D);
    var Jb = {};
    f.Callbacks = function(b) {
        var j;
        if ("string" ==
            typeof b) {
            if (!(j = Jb[b])) {
                j = b;
                var d = Jb[j] = {};
                j = (f.each(j.split(fa), function(b, u) {
                    d[u] = !0
                }), d)
            }
        } else j = f.extend({}, b);
        b = j;
        var F, x, e, q, l, g, n = [],
            p = !b.once && [],
            s = function(j) {
                F = b.memory && j;
                x = !0;
                g = q || 0;
                q = 0;
                l = n.length;
                for (e = !0; n && g < l; g++)
                    if (!1 === n[g].apply(j[0], j[1]) && b.stopOnFalse) {
                        F = !1;
                        break
                    }
                e = !1;
                n && (p ? p.length && s(p.shift()) : F ? n = [] : m.disable())
            },
            m = {
                add: function() {
                    if (n) {
                        var j = n.length;
                        (function yc(j) {
                            f.each(j, function(j, c) {
                                var d = f.type(c);
                                "function" === d && (!b.unique || !m.has(c)) ? n.push(c) : c && c.length && "string" !==
                                    d && yc(c)
                            })
                        })(arguments);
                        e ? l = n.length : F && (q = j, s(F))
                    }
                    return this
                },
                remove: function() {
                    return n && f.each(arguments, function(b, u) {
                        for (var j; - 1 < (j = f.inArray(u, n, j));) n.splice(j, 1), e && (j <= l && l--, j <= g && g--)
                    }), this
                },
                has: function(b) {
                    return -1 < f.inArray(b, n)
                },
                empty: function() {
                    return n = [], this
                },
                disable: function() {
                    return n = p = F = c, this
                },
                disabled: function() {
                    return !n
                },
                lock: function() {
                    return p = c, F || m.disable(), this
                },
                locked: function() {
                    return !p
                },
                fireWith: function(b, u) {
                    return u = u || [], u = [b, u.slice ? u.slice() : u], n && (!x || p) &&
                        (e ? p.push(u) : s(u)), this
                },
                fire: function() {
                    return m.fireWith(this, arguments), this
                },
                fired: function() {
                    return !!x
                }
            };
        return m
    };
    f.extend({
        Deferred: function(b) {
            var j = [
                    ["resolve", "done", f.Callbacks("once memory"), "resolved"],
                    ["reject", "fail", f.Callbacks("once memory"), "rejected"],
                    ["notify", "progress", f.Callbacks("memory")]
                ],
                c = "pending",
                d = {
                    state: function() {
                        return c
                    },
                    always: function() {
                        return x.done(arguments).fail(arguments), this
                    },
                    then: function() {
                        var b = arguments;
                        return f.Deferred(function(u) {
                            f.each(j, function(j,
                                c) {
                                var d = c[0],
                                    z = b[j];
                                x[c[1]](f.isFunction(z) ? function() {
                                    var b = z.apply(this, arguments);
                                    b && f.isFunction(b.promise) ? b.promise().done(u.resolve).fail(u.reject).progress(u.notify) : u[d + "With"](this === x ? u : this, [b])
                                } : u[d])
                            });
                            b = null
                        }).promise()
                    },
                    promise: function(b) {
                        return null != b ? f.extend(b, d) : d
                    }
                },
                x = {};
            return d.pipe = d.then, f.each(j, function(b, u) {
                var f = u[2],
                    e = u[3];
                d[u[1]] = f.add;
                e && f.add(function() {
                    c = e
                }, j[b ^ 1][2].disable, j[2][2].lock);
                x[u[0]] = f.fire;
                x[u[0] + "With"] = f.fireWith
            }), d.promise(x), b && b.call(x, x), x
        },
        when: function(b) {
            var j = 0,
                c = aa.call(arguments),
                d = c.length,
                x = 1 !== d || b && f.isFunction(b.promise) ? d : 0,
                e = 1 === x ? b : f.Deferred(),
                q = function(b, u, j) {
                    return function(c) {
                        u[b] = this;
                        j[b] = 1 < arguments.length ? aa.call(arguments) : c;
                        j === l ? e.notifyWith(u, j) : --x || e.resolveWith(u, j)
                    }
                },
                l, g, n;
            if (1 < d) {
                l = Array(d);
                g = Array(d);
                for (n = Array(d); j < d; j++) c[j] && f.isFunction(c[j].promise) ? c[j].promise().done(q(j, n, c)).fail(e.reject).progress(q(j, g, l)) : --x
            }
            return x || e.resolveWith(n, c), e.promise()
        }
    });
    var Oc = f,
        cb, O, Ha, ga, Ia, Ja, T, ha, Ka, db,
        va, Kb, L = D.createElement("div");
    L.setAttribute("className", "t");
    L.innerHTML = "  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>";
    Ha = L.getElementsByTagName("*");
    ga = L.getElementsByTagName("a")[0];
    ga.style.cssText = "top:1px;float:left;opacity:.5";
    if (!Ha || !Ha.length) cb = {};
    else {
        Ia = D.createElement("select");
        Ja = Ia.appendChild(D.createElement("option"));
        T = L.getElementsByTagName("input")[0];
        O = {
            leadingWhitespace: 3 === L.firstChild.nodeType,
            tbody: !L.getElementsByTagName("tbody").length,
            htmlSerialize: !!L.getElementsByTagName("link").length,
            style: /top/.test(ga.getAttribute("style")),
            hrefNormalized: "/a" === ga.getAttribute("href"),
            opacity: /^0.5/.test(ga.style.opacity),
            cssFloat: !!ga.style.cssFloat,
            checkOn: "on" === T.value,
            optSelected: Ja.selected,
            getSetAttribute: "t" !== L.className,
            enctype: !!D.createElement("form").enctype,
            html5Clone: "<:nav></:nav>" !== D.createElement("nav").cloneNode(!0).outerHTML,
            boxModel: "CSS1Compat" === D.compatMode,
            submitBubbles: !0,
            changeBubbles: !0,
            focusinBubbles: !1,
            deleteExpando: !0,
            noCloneEvent: !0,
            inlineBlockNeedsLayout: !1,
            shrinkWrapBlocks: !1,
            reliableMarginRight: !0,
            boxSizingReliable: !0,
            pixelPosition: !1
        };
        T.checked = !0;
        O.noCloneChecked = T.cloneNode(!0).checked;
        Ia.disabled = !0;
        O.optDisabled = !Ja.disabled;
        try {
            delete L.test
        } catch (Qd) {
            O.deleteExpando = !1
        }!L.addEventListener && L.attachEvent && L.fireEvent && (L.attachEvent("onclick", Kb = function() {
            O.noCloneEvent = !1
        }), L.cloneNode(!0).fireEvent("onclick"), L.detachEvent("onclick", Kb));
        T = D.createElement("input");
        T.value = "t";
        T.setAttribute("type", "radio");
        O.radioValue = "t" === T.value;
        T.setAttribute("checked",
            "checked");
        T.setAttribute("name", "t");
        L.appendChild(T);
        ha = D.createDocumentFragment();
        ha.appendChild(L.lastChild);
        O.checkClone = ha.cloneNode(!0).cloneNode(!0).lastChild.checked;
        O.appendChecked = T.checked;
        ha.removeChild(T);
        ha.appendChild(L);
        if (L.attachEvent)
            for (db in {
                submit: !0,
                change: !0,
                focusin: !0
            }) Ka = "on" + db, (va = Ka in L) || (L.setAttribute(Ka, "return;"), va = "function" == typeof L[Ka]), O[db + "Bubbles"] = va;
        cb = (f(function() {
            var u, j, c, d, f = D.getElementsByTagName("body")[0];
            f && (u = D.createElement("div"), u.style.cssText =
                "visibility:hidden;border:0;width:0;height:0;position:static;top:0;margin-top:1px", f.insertBefore(u, f.firstChild), j = D.createElement("div"), u.appendChild(j), j.innerHTML = "<table><tr><td></td><td>t</td></tr></table>", c = j.getElementsByTagName("td"), c[0].style.cssText = "padding:0;margin:0;border:0;display:none", va = 0 === c[0].offsetHeight, c[0].style.display = "", c[1].style.display = "none", O.reliableHiddenOffsets = va && 0 === c[0].offsetHeight, j.innerHTML = "", j.style.cssText = "box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;",
                O.boxSizing = 4 === j.offsetWidth, O.doesNotIncludeMarginInBodyOffset = 1 !== f.offsetTop, b.getComputedStyle && (O.pixelPosition = "1%" !== (b.getComputedStyle(j, null) || {}).top, O.boxSizingReliable = "4px" === (b.getComputedStyle(j, null) || {
                    width: "4px"
                }).width, d = D.createElement("div"), d.style.cssText = j.style.cssText = "padding:0;margin:0;border:0;display:block;overflow:hidden;", d.style.marginRight = d.style.width = "0", j.style.width = "1px", j.appendChild(d), O.reliableMarginRight = !parseFloat((b.getComputedStyle(d, null) || {}).marginRight)),
                "undefined" != typeof j.style.zoom && (j.innerHTML = "", j.style.cssText = "padding:0;margin:0;border:0;display:block;overflow:hidden;width:1px;padding:1px;display:inline;zoom:1", O.inlineBlockNeedsLayout = 3 === j.offsetWidth, j.style.display = "block", j.style.overflow = "visible", j.innerHTML = "<div></div>", j.firstChild.style.width = "5px", O.shrinkWrapBlocks = 3 !== j.offsetWidth, u.style.zoom = 1), f.removeChild(u))
        }), ha.removeChild(L), Ha = ga = Ia = Ja = T = ha = L = null, O)
    }
    Oc.support = cb;
    var uc = /(?:\{[\s\S]*\}|\[[\s\S]*\])$/,
        tc = /([A-Z])/g;
    f.extend({
        cache: {},
        deletedIds: [],
        uuid: 0,
        expando: "jQuery" + (f.fn.jquery + Math.random()).replace(/\D/g, ""),
        noData: {
            embed: !0,
            object: "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",
            applet: !0
        },
        hasData: function(b) {
            return b = b.nodeType ? f.cache[b[f.expando]] : b[f.expando], !!b && !e(b)
        },
        data: function(b, j, d, F) {
            if (f.acceptData(b)) {
                var x, e, q = f.expando,
                    l = "string" == typeof j,
                    g = b.nodeType,
                    n = g ? f.cache : b,
                    p = g ? b[q] : b[q] && q;
                if (p && n[p] && (F || n[p].data) || !(l && d === c)) {
                    p || (g ? b[q] = p = f.deletedIds.pop() || f.guid++ : p = q);
                    n[p] || (n[p] = {},
                        g || (n[p].toJSON = f.noop));
                    if ("object" == typeof j || "function" == typeof j) F ? n[p] = f.extend(n[p], j) : n[p].data = f.extend(n[p].data, j);
                    return x = n[p], F || (x.data || (x.data = {}), x = x.data), d !== c && (x[f.camelCase(j)] = d), l ? (e = x[j], null == e && (e = x[f.camelCase(j)])) : e = x, e
                }
            }
        },
        removeData: function(b, j, c) {
            if (f.acceptData(b)) {
                var d, x, l, q = b.nodeType,
                    g = q ? f.cache : b,
                    n = q ? b[f.expando] : f.expando;
                if (g[n]) {
                    if (j && (d = c ? g[n] : g[n].data)) {
                        f.isArray(j) || (j in d ? j = [j] : (j = f.camelCase(j), j in d ? j = [j] : j = j.split(" ")));
                        x = 0;
                        for (l = j.length; x < l; x++) delete d[j[x]];
                        if (!(c ? e : f.isEmptyObject)(d)) return
                    }
                    if (c || !(delete g[n].data, !e(g[n]))) q ? f.cleanData([b], !0) : f.support.deleteExpando || g != g.window ? delete g[n] : g[n] = null
                }
            }
        },
        _data: function(b, j, c) {
            return f.data(b, j, c, !0)
        },
        acceptData: function(b) {
            var j = b.nodeName && f.noData[b.nodeName.toLowerCase()];
            return !j || !0 !== j && b.getAttribute("classid") === j
        }
    });
    f.fn.extend({
        data: function(b, j) {
            var z, F, x, e, q, l = this[0],
                g = 0,
                n = null;
            if (b === c) {
                if (this.length && (n = f.data(l), 1 === l.nodeType && !f._data(l, "parsedAttrs"))) {
                    x = l.attributes;
                    for (q = x.length; g <
                        q; g++) e = x[g].name, e.indexOf("data-") || (e = f.camelCase(e.substring(5)), d(l, e, n[e]));
                    f._data(l, "parsedAttrs", !0)
                }
                return n
            }
            return "object" == typeof b ? this.each(function() {
                f.data(this, b)
            }) : (z = b.split(".", 2), z[1] = z[1] ? "." + z[1] : "", F = z[1] + "!", f.access(this, function(j) {
                if (j === c) return n = this.triggerHandler("getData" + F, [z[0]]), n === c && l && (n = f.data(l, b), n = d(l, b, n)), n === c && z[1] ? this.data(z[0]) : n;
                z[1] = j;
                this.each(function() {
                    var c = f(this);
                    c.triggerHandler("setData" + F, z);
                    f.data(this, b, j);
                    c.triggerHandler("changeData" +
                        F, z)
                })
            }, null, j, 1 < arguments.length, null, !1))
        },
        removeData: function(b) {
            return this.each(function() {
                f.removeData(this, b)
            })
        }
    });
    f.extend({
        queue: function(b, j, c) {
            var d;
            if (b) return j = (j || "fx") + "queue", d = f._data(b, j), c && (!d || f.isArray(c) ? d = f._data(b, j, f.makeArray(c)) : d.push(c)), d || []
        },
        dequeue: function(b, c) {
            c = c || "fx";
            var d = f.queue(b, c),
                F = d.length,
                x = d.shift(),
                e = f._queueHooks(b, c),
                q = function() {
                    f.dequeue(b, c)
                };
            "inprogress" === x && (x = d.shift(), F--);
            x && ("fx" === c && d.unshift("inprogress"), delete e.stop, x.call(b, q, e));
            !F && e && e.empty.fire()
        },
        _queueHooks: function(b, c) {
            var d = c + "queueHooks";
            return f._data(b, d) || f._data(b, d, {
                empty: f.Callbacks("once memory").add(function() {
                    f.removeData(b, c + "queue", !0);
                    f.removeData(b, d, !0)
                })
            })
        }
    });
    f.fn.extend({
        queue: function(b, j) {
            var d = 2;
            return "string" != typeof b && (j = b, b = "fx", d--), arguments.length < d ? f.queue(this[0], b) : j === c ? this : this.each(function() {
                var c = f.queue(this, b, j);
                f._queueHooks(this, b);
                "fx" === b && "inprogress" !== c[0] && f.dequeue(this, b)
            })
        },
        dequeue: function(b) {
            return this.each(function() {
                f.dequeue(this,
                    b)
            })
        },
        delay: function(b, c) {
            return b = f.fx ? f.fx.speeds[b] || b : b, c = c || "fx", this.queue(c, function(c, j) {
                var d = setTimeout(c, b);
                j.stop = function() {
                    clearTimeout(d)
                }
            })
        },
        clearQueue: function(b) {
            return this.queue(b || "fx", [])
        },
        promise: function(b, j) {
            var d, F = 1,
                e = f.Deferred(),
                l = this,
                q = this.length,
                g = function() {
                    --F || e.resolveWith(l, [l])
                };
            "string" != typeof b && (j = b, b = c);
            for (b = b || "fx"; q--;)(d = f._data(l[q], b + "queueHooks")) && d.empty && (F++, d.empty.add(g));
            return g(), e.promise(j)
        }
    });
    var ba, Lb, Mb, Nb = /[\t\r\n]/g,
        Pc = /\r/g,
        Qc = /^(?:button|input)$/i,
        Rc = /^(?:button|input|object|select|textarea)$/i,
        Sc = /^a(?:rea|)$/i,
        Ob = /^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i,
        Pb = f.support.getSetAttribute;
    f.fn.extend({
        attr: function(b, c) {
            return f.access(this, f.attr, b, c, 1 < arguments.length)
        },
        removeAttr: function(b) {
            return this.each(function() {
                f.removeAttr(this, b)
            })
        },
        prop: function(b, c) {
            return f.access(this, f.prop, b, c, 1 < arguments.length)
        },
        removeProp: function(b) {
            return b = f.propFix[b] ||
                b, this.each(function() {
                    try {
                        this[b] = c, delete this[b]
                    } catch (j) {}
                })
        },
        addClass: function(b) {
            var c, d, F, e, l, q, g;
            if (f.isFunction(b)) return this.each(function(c) {
                f(this).addClass(b.call(this, c, this.className))
            });
            if (b && "string" == typeof b) {
                c = b.split(fa);
                d = 0;
                for (F = this.length; d < F; d++)
                    if (e = this[d], 1 === e.nodeType)
                        if (!e.className && 1 === c.length) e.className = b;
                        else {
                            l = " " + e.className + " ";
                            q = 0;
                            for (g = c.length; q < g; q++) 0 > l.indexOf(" " + c[q] + " ") && (l += c[q] + " ");
                            e.className = f.trim(l)
                        }
            }
            return this
        },
        removeClass: function(b) {
            var j,
                d, F, e, l, q, g;
            if (f.isFunction(b)) return this.each(function(c) {
                f(this).removeClass(b.call(this, c, this.className))
            });
            if (b && "string" == typeof b || b === c) {
                j = (b || "").split(fa);
                q = 0;
                for (g = this.length; q < g; q++)
                    if (F = this[q], 1 === F.nodeType && F.className) {
                        d = (" " + F.className + " ").replace(Nb, " ");
                        e = 0;
                        for (l = j.length; e < l; e++)
                            for (; 0 <= d.indexOf(" " + j[e] + " ");) d = d.replace(" " + j[e] + " ", " ");
                        F.className = b ? f.trim(d) : ""
                    }
            }
            return this
        },
        toggleClass: function(b, c) {
            var d = typeof b,
                e = "boolean" == typeof c;
            return f.isFunction(b) ? this.each(function(d) {
                f(this).toggleClass(b.call(this,
                    d, this.className, c), c)
            }) : this.each(function() {
                if ("string" === d)
                    for (var x, l = 0, q = f(this), g = c, n = b.split(fa); x = n[l++];) g = e ? g : !q.hasClass(x), q[g ? "addClass" : "removeClass"](x);
                else if ("undefined" === d || "boolean" === d) this.className && f._data(this, "__className__", this.className), this.className = this.className || !1 === b ? "" : f._data(this, "__className__") || ""
            })
        },
        hasClass: function(b) {
            b = " " + b + " ";
            for (var c = 0, d = this.length; c < d; c++)
                if (1 === this[c].nodeType && 0 <= (" " + this[c].className + " ").replace(Nb, " ").indexOf(b)) return !0;
            return !1
        },
        val: function(b) {
            var j, d, e, x = this[0];
            if (arguments.length) return e = f.isFunction(b), this.each(function(d) {
                var z, x = f(this);
                if (1 === this.nodeType && (e ? z = b.call(this, d, x.val()) : z = b, null == z ? z = "" : "number" == typeof z ? z += "" : f.isArray(z) && (z = f.map(z, function(b) {
                    return null == b ? "" : b + ""
                })), j = f.valHooks[this.type] || f.valHooks[this.nodeName.toLowerCase()], !j || !("set" in j) || j.set(this, z, "value") === c)) this.value = z
            });
            if (x) return j = f.valHooks[x.type] || f.valHooks[x.nodeName.toLowerCase()], j && "get" in j && (d = j.get(x,
                "value")) !== c ? d : (d = x.value, "string" == typeof d ? d.replace(Pc, "") : null == d ? "" : d)
        }
    });
    f.extend({
        valHooks: {
            option: {
                get: function(b) {
                    var c = b.attributes.value;
                    return !c || c.specified ? b.value : b.text
                }
            },
            select: {
                get: function(b) {
                    var c, d, e = b.selectedIndex,
                        x = [],
                        l = b.options,
                        q = "select-one" === b.type;
                    if (0 > e) return null;
                    b = q ? e : 0;
                    for (d = q ? e + 1 : l.length; b < d; b++)
                        if (c = l[b], c.selected && (f.support.optDisabled ? !c.disabled : null === c.getAttribute("disabled")) && (!c.parentNode.disabled || !f.nodeName(c.parentNode, "optgroup"))) {
                            c = f(c).val();
                            if (q) return c;
                            x.push(c)
                        }
                    return q && !x.length && l.length ? f(l[e]).val() : x
                },
                set: function(b, c) {
                    var d = f.makeArray(c);
                    return f(b).find("option").each(function() {
                        this.selected = 0 <= f.inArray(f(this).val(), d)
                    }), d.length || (b.selectedIndex = -1), d
                }
            }
        },
        attrFn: {},
        attr: function(b, j, d, e) {
            var x, l, q = b.nodeType;
            if (b && !(3 === q || 8 === q || 2 === q)) {
                if (e && f.isFunction(f.fn[j])) return f(b)[j](d);
                if ("undefined" == typeof b.getAttribute) return f.prop(b, j, d);
                (e = 1 !== q || !f.isXMLDoc(b)) && (j = j.toLowerCase(), l = f.attrHooks[j] || (Ob.test(j) ? Lb :
                    ba));
                if (d !== c) {
                    if (null === d) {
                        f.removeAttr(b, j);
                        return
                    }
                    return l && "set" in l && e && (x = l.set(b, d, j)) !== c ? x : (b.setAttribute(j, d + ""), d)
                }
                return l && "get" in l && e && null !== (x = l.get(b, j)) ? x : (x = b.getAttribute(j), null === x ? c : x)
            }
        },
        removeAttr: function(b, c) {
            var d, e, x, l, q = 0;
            if (c && 1 === b.nodeType)
                for (e = c.split(fa); q < e.length; q++)(x = e[q]) && (d = f.propFix[x] || x, l = Ob.test(x), l || f.attr(b, x, ""), b.removeAttribute(Pb ? x : d), l && d in b && (b[d] = !1))
        },
        attrHooks: {
            type: {
                set: function(b, c) {
                    if (Qc.test(b.nodeName) && b.parentNode) f.error("type property can't be changed");
                    else if (!f.support.radioValue && "radio" === c && f.nodeName(b, "input")) {
                        var d = b.value;
                        return b.setAttribute("type", c), d && (b.value = d), c
                    }
                }
            },
            value: {
                get: function(b, c) {
                    return ba && f.nodeName(b, "button") ? ba.get(b, c) : c in b ? b.value : null
                },
                set: function(b, c, d) {
                    if (ba && f.nodeName(b, "button")) return ba.set(b, c, d);
                    b.value = c
                }
            }
        },
        propFix: {
            tabindex: "tabIndex",
            readonly: "readOnly",
            "for": "htmlFor",
            "class": "className",
            maxlength: "maxLength",
            cellspacing: "cellSpacing",
            cellpadding: "cellPadding",
            rowspan: "rowSpan",
            colspan: "colSpan",
            usemap: "useMap",
            frameborder: "frameBorder",
            contenteditable: "contentEditable"
        },
        prop: function(b, j, d) {
            var e, x, l, q = b.nodeType;
            if (b && !(3 === q || 8 === q || 2 === q)) return l = 1 !== q || !f.isXMLDoc(b), l && (j = f.propFix[j] || j, x = f.propHooks[j]), d !== c ? x && "set" in x && (e = x.set(b, d, j)) !== c ? e : b[j] = d : x && "get" in x && null !== (e = x.get(b, j)) ? e : b[j]
        },
        propHooks: {
            tabIndex: {
                get: function(b) {
                    var j = b.getAttributeNode("tabindex");
                    return j && j.specified ? parseInt(j.value, 10) : Rc.test(b.nodeName) || Sc.test(b.nodeName) && b.href ? 0 : c
                }
            }
        }
    });
    Lb = {
        get: function(b,
            j) {
            var d, e = f.prop(b, j);
            return !0 === e || "boolean" != typeof e && (d = b.getAttributeNode(j)) && !1 !== d.nodeValue ? j.toLowerCase() : c
        },
        set: function(b, c, d) {
            var e;
            return !1 === c ? f.removeAttr(b, d) : (e = f.propFix[d] || d, e in b && (b[e] = !0), b.setAttribute(d, d.toLowerCase())), d
        }
    };
    Pb || (Mb = {
        name: !0,
        id: !0,
        coords: !0
    }, ba = f.valHooks.button = {
        get: function(b, j) {
            var d;
            return d = b.getAttributeNode(j), d && (Mb[j] ? "" !== d.value : d.specified) ? d.value : c
        },
        set: function(b, c, d) {
            var f = b.getAttributeNode(d);
            return f || (f = D.createAttribute(d), b.setAttributeNode(f)),
                f.value = c + ""
        }
    }, f.each(["width", "height"], function(b, c) {
        f.attrHooks[c] = f.extend(f.attrHooks[c], {
            set: function(b, u) {
                if ("" === u) return b.setAttribute(c, "auto"), u
            }
        })
    }), f.attrHooks.contenteditable = {
        get: ba.get,
        set: function(b, c, d) {
            "" === c && (c = "false");
            ba.set(b, c, d)
        }
    });
    f.support.hrefNormalized || f.each(["href", "src", "width", "height"], function(b, j) {
        f.attrHooks[j] = f.extend(f.attrHooks[j], {
            get: function(b) {
                b = b.getAttribute(j, 2);
                return null === b ? c : b
            }
        })
    });
    f.support.style || (f.attrHooks.style = {
        get: function(b) {
            return b.style.cssText.toLowerCase() ||
                c
        },
        set: function(b, c) {
            return b.style.cssText = c + ""
        }
    });
    f.support.optSelected || (f.propHooks.selected = f.extend(f.propHooks.selected, {
        get: function(b) {
            b = b.parentNode;
            return b && (b.selectedIndex, b.parentNode && b.parentNode.selectedIndex), null
        }
    }));
    f.support.enctype || (f.propFix.enctype = "encoding");
    f.support.checkOn || f.each(["radio", "checkbox"], function() {
        f.valHooks[this] = {
            get: function(b) {
                return null === b.getAttribute("value") ? "on" : b.value
            }
        }
    });
    f.each(["radio", "checkbox"], function() {
        f.valHooks[this] = f.extend(f.valHooks[this], {
            set: function(b, c) {
                if (f.isArray(c)) return b.checked = 0 <= f.inArray(f(b).val(), c)
            }
        })
    });
    var eb = /^(?:textarea|input|select)$/i,
        Qb = /^([^\.]*|)(?:\.(.+)|)$/,
        Tc = /(?:^|\s)hover(\.\S+|)\b/,
        Uc = /^key/,
        Vc = /^(?:mouse|contextmenu)|click/,
        Rb = /^(?:focusinfocus|focusoutblur)$/,
        Sb = function(b) {
            return f.event.special.hover ? b : b.replace(Tc, "mouseenter$1 mouseleave$1")
        };
    f.event = {
        add: function(b, j, d, e, x) {
            var l, q, g, n, p, s, m, t, v;
            if (!(3 === b.nodeType || 8 === b.nodeType || !j || !d || !(l = f._data(b)))) {
                d.handler && (m = d, d = m.handler, x = m.selector);
                d.guid || (d.guid = f.guid++);
                (g = l.events) || (l.events = g = {});
                (q = l.handle) || (l.handle = q = function(b) {
                    return "undefined" != typeof f && (!b || f.event.triggered !== b.type) ? f.event.dispatch.apply(q.elem, arguments) : c
                }, q.elem = b);
                j = f.trim(Sb(j)).split(" ");
                for (l = 0; l < j.length; l++) {
                    n = Qb.exec(j[l]) || [];
                    p = n[1];
                    s = (n[2] || "").split(".").sort();
                    v = f.event.special[p] || {};
                    p = (x ? v.delegateType : v.bindType) || p;
                    v = f.event.special[p] || {};
                    n = f.extend({
                        type: p,
                        origType: n[1],
                        data: e,
                        handler: d,
                        guid: d.guid,
                        selector: x,
                        needsContext: x && f.expr.match.needsContext.test(x),
                        namespace: s.join(".")
                    }, m);
                    t = g[p];
                    if (!t && (t = g[p] = [], t.delegateCount = 0, !v.setup || !1 === v.setup.call(b, e, s, q))) b.addEventListener ? b.addEventListener(p, q, !1) : b.attachEvent && b.attachEvent("on" + p, q);
                    v.add && (v.add.call(b, n), n.handler.guid || (n.handler.guid = d.guid));
                    x ? t.splice(t.delegateCount++, 0, n) : t.push(n);
                    f.event.global[p] = !0
                }
                b = null
            }
        },
        global: {},
        remove: function(b, c, d, e, l) {
            var g, q, n, p, s, m, ta, t, v, A, r = f.hasData(b) && f._data(b);
            if (r && (ta = r.events)) {
                c = f.trim(Sb(c || "")).split(" ");
                for (g = 0; g < c.length; g++)
                    if (q = Qb.exec(c[g]) || [], n = p = q[1], q = q[2], n) {
                        t = f.event.special[n] || {};
                        n = (e ? t.delegateType : t.bindType) || n;
                        v = ta[n] || [];
                        s = v.length;
                        q = q ? RegExp("(^|\\.)" + q.split(".").sort().join("\\.(?:.*\\.|)") + "(\\.|$)") : null;
                        for (m = 0; m < v.length; m++) A = v[m], (l || p === A.origType) && (!d || d.guid === A.guid) && (!q || q.test(A.namespace)) && (!e || e === A.selector || "**" === e && A.selector) && (v.splice(m--, 1), A.selector && v.delegateCount--, t.remove && t.remove.call(b, A));
                        0 === v.length && s !== v.length && ((!t.teardown || !1 === t.teardown.call(b, q, r.handle)) && f.removeEvent(b,
                            n, r.handle), delete ta[n])
                    } else
                        for (n in ta) f.event.remove(b, n + c[g], d, e, !0);
                f.isEmptyObject(ta) && (delete r.handle, f.removeData(b, "events", !0))
            }
        },
        customEvent: {
            getData: !0,
            setData: !0,
            changeData: !0
        },
        trigger: function(u, j, d, e) {
            if (!d || 3 !== d.nodeType && 8 !== d.nodeType) {
                var l, g, q, n, p, s, m, t = u.type || u;
                n = [];
                if (!Rb.test(t + f.event.triggered) && (0 <= t.indexOf("!") && (t = t.slice(0, -1), l = !0), 0 <= t.indexOf(".") && (n = t.split("."), t = n.shift(), n.sort()), d && !f.event.customEvent[t] || f.event.global[t]))
                    if (u = "object" == typeof u ? u[f.expando] ?
                        u : new f.Event(t, u) : new f.Event(t), u.type = t, u.isTrigger = !0, u.exclusive = l, u.namespace = n.join("."), u.namespace_re = u.namespace ? RegExp("(^|\\.)" + n.join("\\.(?:.*\\.|)") + "(\\.|$)") : null, n = 0 > t.indexOf(":") ? "on" + t : "", d) {
                        if (u.result = c, u.target || (u.target = d), j = null != j ? f.makeArray(j) : [], j.unshift(u), p = f.event.special[t] || {}, !(p.trigger && !1 === p.trigger.apply(d, j))) {
                            m = [
                                [d, p.bindType || t]
                            ];
                            if (!e && !p.noBubble && !f.isWindow(d)) {
                                g = p.delegateType || t;
                                l = Rb.test(g + t) ? d : d.parentNode;
                                for (q = d; l; l = l.parentNode) m.push([l, g]),
                                    q = l;
                                q === (d.ownerDocument || D) && m.push([q.defaultView || q.parentWindow || b, g])
                            }
                            for (g = 0; g < m.length && !u.isPropagationStopped(); g++) l = m[g][0], u.type = m[g][1], (s = (f._data(l, "events") || {})[u.type] && f._data(l, "handle")) && s.apply(l, j), (s = n && l[n]) && f.acceptData(l) && s.apply && !1 === s.apply(l, j) && u.preventDefault();
                            return u.type = t, !e && !u.isDefaultPrevented() && (!p._default || !1 === p._default.apply(d.ownerDocument, j)) && ("click" !== t || !f.nodeName(d, "a")) && f.acceptData(d) && n && d[t] && ("focus" !== t && "blur" !== t || 0 !== u.target.offsetWidth) &&
                                !f.isWindow(d) && (q = d[n], q && (d[n] = null), f.event.triggered = t, d[t](), f.event.triggered = c, q && (d[n] = q)), u.result
                        }
                    } else
                        for (g in d = f.cache, d) d[g].events && d[g].events[t] && f.event.trigger(u, j, d[g].handle.elem, !0)
            }
        },
        dispatch: function(u) {
            u = f.event.fix(u || b.event);
            var j, d, e, l, g, q, n = (f._data(this, "events") || {})[u.type] || [],
                p = n.delegateCount,
                m = aa.call(arguments),
                s = !u.exclusive && !u.namespace,
                t = f.event.special[u.type] || {},
                v = [];
            m[0] = u;
            u.delegateTarget = this;
            if (!(t.preDispatch && !1 === t.preDispatch.call(this, u))) {
                if (p &&
                    (!u.button || "click" !== u.type))
                    for (d = u.target; d != this; d = d.parentNode || this)
                        if (!0 !== d.disabled || "click" !== u.type) {
                            l = {};
                            g = [];
                            for (j = 0; j < p; j++) e = n[j], q = e.selector, l[q] === c && (l[q] = e.needsContext ? 0 <= f(q, this).index(d) : f.find(q, this, null, [d]).length), l[q] && g.push(e);
                            g.length && v.push({
                                elem: d,
                                matches: g
                            })
                        }
                n.length > p && v.push({
                    elem: this,
                    matches: n.slice(p)
                });
                for (j = 0; j < v.length && !u.isPropagationStopped(); j++) {
                    l = v[j];
                    u.currentTarget = l.elem;
                    for (d = 0; d < l.matches.length && !u.isImmediatePropagationStopped(); d++)
                        if (e = l.matches[d],
                            s || !u.namespace && !e.namespace || u.namespace_re && u.namespace_re.test(e.namespace)) u.data = e.data, u.handleObj = e, e = ((f.event.special[e.origType] || {}).handle || e.handler).apply(l.elem, m), e !== c && (u.result = e, !1 === e && (u.preventDefault(), u.stopPropagation()))
                }
                return t.postDispatch && t.postDispatch.call(this, u), u.result
            }
        },
        props: "attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),
        fixHooks: {},
        keyHooks: {
            props: ["char", "charCode", "key", "keyCode"],
            filter: function(b, c) {
                return null == b.which && (b.which = null != c.charCode ? c.charCode : c.keyCode), b
            }
        },
        mouseHooks: {
            props: "button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),
            filter: function(b, j) {
                var d, f, e, l = j.button,
                    q = j.fromElement;
                return null == b.pageX && null != j.clientX && (d = b.target.ownerDocument || D, f = d.documentElement, e = d.body, b.pageX = j.clientX + (f && f.scrollLeft || e && e.scrollLeft || 0) - (f && f.clientLeft ||
                    e && e.clientLeft || 0), b.pageY = j.clientY + (f && f.scrollTop || e && e.scrollTop || 0) - (f && f.clientTop || e && e.clientTop || 0)), !b.relatedTarget && q && (b.relatedTarget = q === b.target ? j.toElement : q), !b.which && l !== c && (b.which = l & 1 ? 1 : l & 2 ? 3 : l & 4 ? 2 : 0), b
            }
        },
        fix: function(b) {
            if (b[f.expando]) return b;
            var c, d, e = b,
                l = f.event.fixHooks[b.type] || {},
                g = l.props ? this.props.concat(l.props) : this.props;
            b = f.Event(e);
            for (c = g.length; c;) d = g[--c], b[d] = e[d];
            return b.target || (b.target = e.srcElement || D), 3 === b.target.nodeType && (b.target = b.target.parentNode),
                b.metaKey = !!b.metaKey, l.filter ? l.filter(b, e) : b
        },
        special: {
            load: {
                noBubble: !0
            },
            focus: {
                delegateType: "focusin"
            },
            blur: {
                delegateType: "focusout"
            },
            beforeunload: {
                setup: function(b, c, d) {
                    f.isWindow(this) && (this.onbeforeunload = d)
                },
                teardown: function(b, c) {
                    this.onbeforeunload === c && (this.onbeforeunload = null)
                }
            }
        },
        simulate: function(b, c, d, e) {
            b = f.extend(new f.Event, d, {
                type: b,
                isSimulated: !0,
                originalEvent: {}
            });
            e ? f.event.trigger(b, null, c) : f.event.dispatch.call(c, b);
            b.isDefaultPrevented() && d.preventDefault()
        }
    };
    f.event.handle =
        f.event.dispatch;
    f.removeEvent = D.removeEventListener ? function(b, c, d) {
        b.removeEventListener && b.removeEventListener(c, d, !1)
    } : function(b, c, d) {
        c = "on" + c;
        b.detachEvent && ("undefined" == typeof b[c] && (b[c] = null), b.detachEvent(c, d))
    };
    f.Event = function(b, c) {
        if (this instanceof f.Event) b && b.type ? (this.originalEvent = b, this.type = b.type, this.isDefaultPrevented = b.defaultPrevented || !1 === b.returnValue || b.getPreventDefault && b.getPreventDefault() ? m : g) : this.type = b, c && f.extend(this, c), this.timeStamp = b && b.timeStamp || f.now(),
            this[f.expando] = !0;
        else return new f.Event(b, c)
    };
    f.Event.prototype = {
        preventDefault: function() {
            this.isDefaultPrevented = m;
            var b = this.originalEvent;
            b && (b.preventDefault ? b.preventDefault() : b.returnValue = !1)
        },
        stopPropagation: function() {
            this.isPropagationStopped = m;
            var b = this.originalEvent;
            b && (b.stopPropagation && b.stopPropagation(), b.cancelBubble = !0)
        },
        stopImmediatePropagation: function() {
            this.isImmediatePropagationStopped = m;
            this.stopPropagation()
        },
        isDefaultPrevented: g,
        isPropagationStopped: g,
        isImmediatePropagationStopped: g
    };
    f.each({
        mouseenter: "mouseover",
        mouseleave: "mouseout"
    }, function(b, c) {
        f.event.special[b] = {
            delegateType: c,
            bindType: c,
            handle: function(b) {
                var u, d = b.relatedTarget,
                    e = b.handleObj;
                if (!d || d !== this && !f.contains(this, d)) b.type = e.origType, u = e.handler.apply(this, arguments), b.type = c;
                return u
            }
        }
    });
    f.support.submitBubbles || (f.event.special.submit = {
        setup: function() {
            if (f.nodeName(this, "form")) return !1;
            f.event.add(this, "click._submit keypress._submit", function(b) {
                b = b.target;
                (b = f.nodeName(b, "input") || f.nodeName(b, "button") ?
                    b.form : c) && !f._data(b, "_submit_attached") && (f.event.add(b, "submit._submit", function(b) {
                    b._submit_bubble = !0
                }), f._data(b, "_submit_attached", !0))
            })
        },
        postDispatch: function(b) {
            b._submit_bubble && (delete b._submit_bubble, this.parentNode && !b.isTrigger && f.event.simulate("submit", this.parentNode, b, !0))
        },
        teardown: function() {
            if (f.nodeName(this, "form")) return !1;
            f.event.remove(this, "._submit")
        }
    });
    f.support.changeBubbles || (f.event.special.change = {
        setup: function() {
            if (eb.test(this.nodeName)) {
                if ("checkbox" === this.type ||
                    "radio" === this.type) f.event.add(this, "propertychange._change", function(b) {
                    "checked" === b.originalEvent.propertyName && (this._just_changed = !0)
                }), f.event.add(this, "click._change", function(b) {
                    this._just_changed && !b.isTrigger && (this._just_changed = !1);
                    f.event.simulate("change", this, b, !0)
                });
                return !1
            }
            f.event.add(this, "beforeactivate._change", function(b) {
                b = b.target;
                eb.test(b.nodeName) && !f._data(b, "_change_attached") && (f.event.add(b, "change._change", function(b) {
                    this.parentNode && !b.isSimulated && !b.isTrigger &&
                        f.event.simulate("change", this.parentNode, b, !0)
                }), f._data(b, "_change_attached", !0))
            })
        },
        handle: function(b) {
            var c = b.target;
            if (this !== c || b.isSimulated || b.isTrigger || "radio" !== c.type && "checkbox" !== c.type) return b.handleObj.handler.apply(this, arguments)
        },
        teardown: function() {
            return f.event.remove(this, "._change"), !eb.test(this.nodeName)
        }
    });
    f.support.focusinBubbles || f.each({
        focus: "focusin",
        blur: "focusout"
    }, function(b, c) {
        var d = 0,
            e = function(b) {
                f.event.simulate(c, b.target, f.event.fix(b), !0)
            };
        f.event.special[c] = {
            setup: function() {
                0 === d++ && D.addEventListener(b, e, !0)
            },
            teardown: function() {
                0 === --d && D.removeEventListener(b, e, !0)
            }
        }
    });
    f.fn.extend({
        on: function(b, j, d, e, l) {
            var n, q;
            if ("object" == typeof b) {
                "string" != typeof j && (d = d || j, j = c);
                for (q in b) this.on(q, j, d, b[q], l);
                return this
            }
            null == d && null == e ? (e = j, d = j = c) : null == e && ("string" == typeof j ? (e = d, d = c) : (e = d, d = j, j = c));
            if (!1 === e) e = g;
            else if (!e) return this;
            return 1 === l && (n = e, e = function(b) {
                return f().off(b), n.apply(this, arguments)
            }, e.guid = n.guid || (n.guid = f.guid++)), this.each(function() {
                f.event.add(this,
                    b, e, d, j)
            })
        },
        one: function(b, c, d, f) {
            return this.on(b, c, d, f, 1)
        },
        off: function(b, j, d) {
            var e, l;
            if (b && b.preventDefault && b.handleObj) return e = b.handleObj, f(b.delegateTarget).off(e.namespace ? e.origType + "." + e.namespace : e.origType, e.selector, e.handler), this;
            if ("object" == typeof b) {
                for (l in b) this.off(l, j, b[l]);
                return this
            }
            if (!1 === j || "function" == typeof j) d = j, j = c;
            return !1 === d && (d = g), this.each(function() {
                f.event.remove(this, b, d, j)
            })
        },
        bind: function(b, c, d) {
            return this.on(b, null, c, d)
        },
        unbind: function(b, c) {
            return this.off(b,
                null, c)
        },
        live: function(b, c, d) {
            return f(this.context).on(b, this.selector, c, d), this
        },
        die: function(b, c) {
            return f(this.context).off(b, this.selector || "**", c), this
        },
        delegate: function(b, c, d, f) {
            return this.on(c, b, d, f)
        },
        undelegate: function(b, c, d) {
            return 1 === arguments.length ? this.off(b, "**") : this.off(c, b || "**", d)
        },
        trigger: function(b, c) {
            return this.each(function() {
                f.event.trigger(b, c, this)
            })
        },
        triggerHandler: function(b, c) {
            if (this[0]) return f.event.trigger(b, c, this[0], !0)
        },
        toggle: function(b) {
            var c = arguments,
                d =
                b.guid || f.guid++,
                e = 0,
                l = function(d) {
                    var z = (f._data(this, "lastToggle" + b.guid) || 0) % e;
                    return f._data(this, "lastToggle" + b.guid, z + 1), d.preventDefault(), c[z].apply(this, arguments) || !1
                };
            for (l.guid = d; e < c.length;) c[e++].guid = d;
            return this.click(l)
        },
        hover: function(b, c) {
            return this.mouseenter(b).mouseleave(c || b)
        }
    });
    f.each("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error contextmenu".split(" "),
        function(b, c) {
            f.fn[c] = function(b, d) {
                return null == d && (d = b, b = null), 0 < arguments.length ? this.on(c, null, b, d) : this.trigger(c)
            };
            Uc.test(c) && (f.event.fixHooks[c] = f.event.keyHooks);
            Vc.test(c) && (f.event.fixHooks[c] = f.event.mouseHooks)
        });
    var Wc = b,
        H = function(b, c, d, f) {
            d = d || [];
            c = c || X;
            var e, l, q, g, n = c.nodeType;
            if (!b || "string" != typeof b) return d;
            if (1 !== n && 9 !== n) return [];
            q = La(c);
            if (!q && !f && (e = Xc.exec(b)))
                if (g = e[1])
                    if (9 === n) {
                        l = c.getElementById(g);
                        if (!l || !l.parentNode) return d;
                        if (l.id === g) return d.push(l), d
                    } else {
                        if (c.ownerDocument &&
                            (l = c.ownerDocument.getElementById(g)) && Tb(c, l) && l.id === g) return d.push(l), d
                    } else {
                if (e[2]) return oa.apply(d, pa.call(c.getElementsByTagName(b), 0)), d;
                if ((g = e[3]) && Ub && c.getElementsByClassName) return oa.apply(d, pa.call(c.getElementsByClassName(g), 0)), d
            }
            return fb(b.replace(Ma, "$1"), c, d, f, q)
        },
        wa = function(b) {
            return function(c) {
                return "input" === c.nodeName.toLowerCase() && c.type === b
            }
        },
        Vb = function(b) {
            return function(c) {
                var d = c.nodeName.toLowerCase();
                return ("input" === d || "button" === d) && c.type === b
            }
        },
        ia = function(b) {
            return Y(function(c) {
                return c = +c, Y(function(d, f) {
                    for (var e, l = b([], d.length, c), q = l.length; q--;) d[e = l[q]] && (d[e] = !(f[e] = d[e]))
                })
            })
        },
        Na = function(b, c, d) {
            if (b === c) return d;
            for (b = b.nextSibling; b;) {
                if (b === c) return -1;
                b = b.nextSibling
            }
            return 1
        },
        Pa = function(b, c) {
            var d, f, e, l, q, g, n;
            if (q = Wb[J][b]) return c ? 0 : q.slice(0);
            q = b;
            g = [];
            for (n = M.preFilter; q;) {
                if (!d || (f = Yc.exec(q))) f && (q = q.slice(f[0].length)), g.push(e = []);
                d = !1;
                if (f = Zc.exec(q)) e.push(d = new Xb(f.shift())), q = q.slice(d.length), d.type = f[0].replace(Ma, " ");
                for (l in M.filter)(f = Oa[l].exec(q)) &&
                    (!n[l] || (f = n[l](f, X, !0))) && (e.push(d = new Xb(f.shift())), q = q.slice(d.length), d.type = l, d.matches = f);
                if (!d) break
            }
            return c ? q.length : q ? H.error(b) : Wb(b, g).slice(0)
        },
        hb = function(b, c, d) {
            var f = c.dir,
                e = d && "parentNode" === c.dir,
                l = $c++;
            return c.first ? function(c, d, j) {
                for (; c = c[f];)
                    if (e || 1 === c.nodeType) return b(c, d, j)
            } : function(c, d, j) {
                if (j)
                    for (; c = c[f];) {
                        if ((e || 1 === c.nodeType) && b(c, d, j)) return c
                    } else
                        for (var z, g = xa + " " + l + " ", n = g + gb; c = c[f];)
                            if (e || 1 === c.nodeType) {
                                if ((z = c[J]) === n) return c.sizset;
                                if ("string" == typeof z &&
                                    0 === z.indexOf(g)) {
                                    if (c.sizset) return c
                                } else {
                                    c[J] = n;
                                    if (b(c, d, j)) return c.sizset = !0, c;
                                    c.sizset = !1
                                }
                            }
            }
        },
        ib = function(b) {
            return 1 < b.length ? function(c, d, f) {
                for (var e = b.length; e--;)
                    if (!b[e](c, d, f)) return !1;
                return !0
            } : b[0]
        },
        Qa = function(b, c, d, f, e) {
            for (var l, q = [], g = 0, n = b.length, p = null != c; g < n; g++)
                if (l = b[g])
                    if (!d || d(l, f, e)) q.push(l), p && c.push(g);
            return q
        },
        jb = function(b, c, d, f, e, l) {
            return f && !f[J] && (f = jb(f)), e && !e[J] && (e = jb(e, l)), Y(function(l, g, n, p) {
                if (!l || !e) {
                    var B, m, s = [],
                        t = [],
                        v = g.length;
                    if (!(m = l)) {
                        m = c || "*";
                        var A =
                            n.nodeType ? [n] : n,
                            r = [];
                        B = 0;
                        for (var y = A.length; B < y; B++) H(m, A[B], r, l);
                        m = r
                    }
                    A = b && (l || !c) ? Qa(m, s, b, n, p) : m;
                    r = d ? e || (l ? b : v || f) ? [] : g : A;
                    d && d(A, r, n, p);
                    if (f) {
                        m = Qa(r, t);
                        f(m, [], n, p);
                        for (n = m.length; n--;)
                            if (B = m[n]) r[t[n]] = !(A[t[n]] = B)
                    }
                    if (l)
                        for (n = b && r.length; n--;) {
                            if (B = r[n]) l[s[n]] = !(g[s[n]] = B)
                        } else r = Qa(r === g ? r.splice(v, r.length) : r), e ? e(null, g, r, p) : oa.apply(g, r)
                }
            })
        },
        kb = function(b) {
            var c, d, f, e = b.length,
                l = M.relative[b[0].type];
            d = l || M.relative[" "];
            for (var q = l ? 1 : 0, g = hb(function(b) {
                return b === c
            }, d, !0), n = hb(function(b) {
                return -1 <
                    Yb.call(c, b)
            }, d, !0), p = [
                function(b, d, u) {
                    return !l && (u || d !== Ra) || ((c = d).nodeType ? g(b, d, u) : n(b, d, u))
                }
            ]; q < e; q++)
                if (d = M.relative[b[q].type]) p = [hb(ib(p), d)];
                else {
                    d = M.filter[b[q].type].apply(null, b[q].matches);
                    if (d[J]) {
                        for (f = ++q; f < e && !M.relative[b[f].type]; f++);
                        return jb(1 < q && ib(p), 1 < q && b.slice(0, q - 1).join("").replace(Ma, "$1"), d, q < f && kb(b.slice(q, f)), f < e && kb(b = b.slice(f)), f < e && b.join(""))
                    }
                    p.push(d)
                }
            return ib(p)
        },
        fb = function(b, c, d, f, e) {
            var l, q, g, n, p = Pa(b);
            if (!f && 1 === p.length) {
                q = p[0] = p[0].slice(0);
                if (2 < q.length &&
                    "ID" === (g = q[0]).type && 9 === c.nodeType && !e && M.relative[q[1].type]) {
                    c = M.find.ID(g.matches[0].replace(ja, ""), c, e)[0];
                    if (!c) return d;
                    b = b.slice(q.shift().length)
                }
                for (l = Oa.POS.test(b) ? -1 : q.length - 1; 0 <= l; l--) {
                    g = q[l];
                    if (M.relative[n = g.type]) break;
                    if (n = M.find[n])
                        if (f = n(g.matches[0].replace(ja, ""), lb.test(q[0].type) && c.parentNode || c, e)) {
                            q.splice(l, 1);
                            b = f.length && q.join("");
                            if (!b) return oa.apply(d, pa.call(f, 0)), d;
                            break
                        }
                }
            }
            return mb(b, p)(f, c, e, d, lb.test(b)), d
        },
        Zb = function() {},
        gb, nb, M, Sa, La, Tb, mb, ob, ya, Ra, $b = !0,
        J = ("sizcache" + Math.random()).replace(".", ""),
        Xb = String,
        X = Wc.document,
        W = X.documentElement,
        xa = 0,
        $c = 0,
        ad = [].pop,
        oa = [].push,
        pa = [].slice,
        Yb = [].indexOf || function(b) {
            for (var c = 0, d = this.length; c < d; c++)
                if (this[c] === b) return c;
            return -1
        },
        Y = function(b, c) {
            return b[J] = null == c || c, b
        },
        pb = function() {
            var b = {},
                c = [];
            return Y(function(d, f) {
                return c.push(d) > M.cacheLength && delete b[c.shift()], b[d] = f
            }, b)
        },
        ac = pb(),
        Wb = pb(),
        bc = pb(),
        cc = "\\[[\\x20\\t\\r\\n\\f]*((?:\\\\.|[-\\w]|[^\\x00-\\xa0])+)[\\x20\\t\\r\\n\\f]*(?:([*^$|!~]?=)[\\x20\\t\\r\\n\\f]*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|(" +
        "(?:\\\\.|[-\\w]|[^\\x00-\\xa0])+".replace("w", "w#") + ")|)|)[\\x20\\t\\r\\n\\f]*\\]",
        qb = ":((?:\\\\.|[-\\w]|[^\\x00-\\xa0])+)(?:\\((?:(['\"])((?:\\\\.|[^\\\\])*?)\\2|([^()[\\]]*|(?:(?:" + cc + ")|[^:]|\\\\.)*|.*))\\)|)",
        Ma = /^[\x20\t\r\n\f]+|((?:^|[^\\])(?:\\.)*)[\x20\t\r\n\f]+$/g,
        Yc = /^[\x20\t\r\n\f]*,[\x20\t\r\n\f]*/,
        Zc = /^[\x20\t\r\n\f]*([\x20\t\r\n\f>+~])[\x20\t\r\n\f]*/,
        bd = RegExp(qb),
        Xc = /^(?:#([\w\-]+)|(\w+)|\.([\w\-]+))$/,
        lb = /[\x20\t\r\n\f]*[+~]/,
        cd = /h\d/i,
        dd = /input|select|textarea|button/i,
        ja = /\\(?!\\)/g,
        Oa = {
            ID: /^#((?:\\.|[-\w]|[^\x00-\xa0])+)/,
            CLASS: /^\.((?:\\.|[-\w]|[^\x00-\xa0])+)/,
            NAME: /^\[name=['"]?((?:\\.|[-\w]|[^\x00-\xa0])+)['"]?\]/,
            TAG: RegExp("^(" + "(?:\\\\.|[-\\w]|[^\\x00-\\xa0])+".replace("w", "w*") + ")"),
            ATTR: RegExp("^" + cc),
            PSEUDO: RegExp("^" + qb),
            POS: /:(even|odd|eq|gt|lt|nth|first|last)(?:\([\x20\t\r\n\f]*((?:-\d)?\d*)[\x20\t\r\n\f]*\)|)(?=[^-]|$)/i,
            CHILD: RegExp("^:(only|nth|first|last)-child(?:\\([\\x20\\t\\r\\n\\f]*(even|odd|(([+-]|)(\\d*)n|)[\\x20\\t\\r\\n\\f]*(?:([+-]|)[\\x20\\t\\r\\n\\f]*(\\d+)|))[\\x20\\t\\r\\n\\f]*\\)|)",
                "i"),
            needsContext: RegExp("^[\\x20\\t\\r\\n\\f]*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\([\\x20\\t\\r\\n\\f]*((?:-\\d)?\\d*)[\\x20\\t\\r\\n\\f]*\\)|)(?=[^-]|$)", "i")
        },
        ca = function(b) {
            var c = X.createElement("div");
            try {
                return b(c)
            } catch (d) {
                return !1
            } finally {}
        },
        ed = ca(function(b) {
            return b.appendChild(X.createComment("")), !b.getElementsByTagName("*").length
        }),
        fd = ca(function(b) {
            return b.innerHTML = "<a href='#'></a>", b.firstChild && "undefined" !== typeof b.firstChild.getAttribute && "#" === b.firstChild.getAttribute("href")
        }),
        gd = ca(function(b) {
            b.innerHTML = "<select></select>";
            b = typeof b.lastChild.getAttribute("multiple");
            return "boolean" !== b && "string" !== b
        }),
        Ub = ca(function(b) {
            return b.innerHTML = "<div class='hidden e'></div><div class='hidden'></div>", !b.getElementsByClassName || !b.getElementsByClassName("e").length ? !1 : (b.lastChild.className = "e", 2 === b.getElementsByClassName("e").length)
        }),
        hd = ca(function(b) {
            b.id = J + 0;
            b.innerHTML = "<a name='" + J + "'></a><div name='" + J + "'></div>";
            W.insertBefore(b, W.firstChild);
            var c = X.getElementsByName &&
                X.getElementsByName(J).length === 2 + X.getElementsByName(J + 0).length;
            return nb = !X.getElementById(J), W.removeChild(b), c
        });
    try {
        pa.call(W.childNodes, 0)[0].nodeType
    } catch (Rd) {
        pa = function(b) {
            for (var c, d = []; c = this[b]; b++) d.push(c);
            return d
        }
    }
    H.matches = function(b, c) {
        return H(b, null, null, c)
    };
    H.matchesSelector = function(b, c) {
        return 0 < H(c, null, null, [b]).length
    };
    Sa = H.getText = function(b) {
        var c, d = "",
            f = 0;
        if (c = b.nodeType)
            if (1 === c || 9 === c || 11 === c) {
                if ("string" == typeof b.textContent) return b.textContent;
                for (b = b.firstChild; b; b =
                    b.nextSibling) d += Sa(b)
            } else {
                if (3 === c || 4 === c) return b.nodeValue
            } else
            for (; c = b[f]; f++) d += Sa(c);
        return d
    };
    La = H.isXML = function(b) {
        return (b = b && (b.ownerDocument || b).documentElement) ? "HTML" !== b.nodeName : !1
    };
    Tb = H.contains = W.contains ? function(b, c) {
        var d = 9 === b.nodeType ? b.documentElement : b,
            f = c && c.parentNode;
        return b === f || !(!f || !(1 === f.nodeType && d.contains && d.contains(f)))
    } : W.compareDocumentPosition ? function(b, c) {
        return c && !!(b.compareDocumentPosition(c) & 16)
    } : function(b, c) {
        for (; c = c.parentNode;)
            if (c === b) return !0;
        return !1
    };
    H.attr = function(b, c) {
        var d, f = La(b);
        return f || (c = c.toLowerCase()), (d = M.attrHandle[c]) ? d(b) : f || gd ? b.getAttribute(c) : (d = b.getAttributeNode(c), d ? "boolean" == typeof b[c] ? b[c] ? c : null : d.specified ? d.value : null : null)
    };
    M = H.selectors = {
        cacheLength: 50,
        createPseudo: Y,
        match: Oa,
        attrHandle: fd ? {} : {
            href: function(b) {
                return b.getAttribute("href", 2)
            },
            type: function(b) {
                return b.getAttribute("type")
            }
        },
        find: {
            ID: nb ? function(b, c, d) {
                if ("undefined" !== typeof c.getElementById && !d) return (b = c.getElementById(b)) && b.parentNode ? [b] : []
            } : function(b, c, d) {
                if ("undefined" !== typeof c.getElementById && !d) return (c = c.getElementById(b)) ? c.id === b || "undefined" !== typeof c.getAttributeNode && c.getAttributeNode("id").value === b ? [c] : void 0 : []
            },
            TAG: ed ? function(b, c) {
                if ("undefined" !== typeof c.getElementsByTagName) return c.getElementsByTagName(b)
            } : function(b, c) {
                var d = c.getElementsByTagName(b);
                if ("*" === b) {
                    for (var f, e = [], l = 0; f = d[l]; l++) 1 === f.nodeType && e.push(f);
                    return e
                }
                return d
            },
            NAME: hd && function(b, c) {
                if ("undefined" !== typeof c.getElementsByName) return c.getElementsByName(name)
            },
            CLASS: Ub && function(b, c, d) {
                if ("undefined" !== typeof c.getElementsByClassName && !d) return c.getElementsByClassName(b)
            }
        },
        relative: {
            ">": {
                dir: "parentNode",
                first: !0
            },
            " ": {
                dir: "parentNode"
            },
            "+": {
                dir: "previousSibling",
                first: !0
            },
            "~": {
                dir: "previousSibling"
            }
        },
        preFilter: {
            ATTR: function(b) {
                return b[1] = b[1].replace(ja, ""), b[3] = (b[4] || b[5] || "").replace(ja, ""), "~=" === b[2] && (b[3] = " " + b[3] + " "), b.slice(0, 4)
            },
            CHILD: function(b) {
                return b[1] = b[1].toLowerCase(), "nth" === b[1] ? (b[2] || H.error(b[0]), b[3] = +(b[3] ? b[4] + (b[5] || 1) :
                    2 * ("even" === b[2] || "odd" === b[2])), b[4] = +(b[6] + b[7] || "odd" === b[2])) : b[2] && H.error(b[0]), b
            },
            PSEUDO: function(b) {
                var c, d;
                if (Oa.CHILD.test(b[0])) return null;
                if (b[3]) b[2] = b[3];
                else if (c = b[4]) bd.test(c) && (d = Pa(c, !0)) && (d = c.indexOf(")", c.length - d) - c.length) && (c = c.slice(0, d), b[0] = b[0].slice(0, d)), b[2] = c;
                return b.slice(0, 3)
            }
        },
        filter: {
            ID: nb ? function(b) {
                return b = b.replace(ja, ""),
                    function(c) {
                        return c.getAttribute("id") === b
                    }
            } : function(b) {
                return b = b.replace(ja, ""),
                    function(c) {
                        return (c = "undefined" !== typeof c.getAttributeNode &&
                            c.getAttributeNode("id")) && c.value === b
                    }
            },
            TAG: function(b) {
                return "*" === b ? function() {
                    return !0
                } : (b = b.replace(ja, "").toLowerCase(), function(c) {
                    return c.nodeName && c.nodeName.toLowerCase() === b
                })
            },
            CLASS: function(b) {
                var c = ac[J][b];
                return c || (c = ac(b, RegExp("(^|[\\x20\\t\\r\\n\\f])" + b + "([\\x20\\t\\r\\n\\f]|$)"))),
                    function(b) {
                        return c.test(b.className || "undefined" !== typeof b.getAttribute && b.getAttribute("class") || "")
                    }
            },
            ATTR: function(b, c, d) {
                return function(f) {
                    f = H.attr(f, b);
                    return null == f ? "!=" === c : c ? (f += "", "=" ===
                        c ? f === d : "!=" === c ? f !== d : "^=" === c ? d && 0 === f.indexOf(d) : "*=" === c ? d && -1 < f.indexOf(d) : "$=" === c ? d && f.substr(f.length - d.length) === d : "~=" === c ? -1 < (" " + f + " ").indexOf(d) : "|=" === c ? f === d || f.substr(0, d.length + 1) === d + "-" : !1) : !0
                }
            },
            CHILD: function(b, c, d, f) {
                return "nth" === b ? function(b) {
                    var c, j;
                    c = b.parentNode;
                    if (1 === d && 0 === f) return !0;
                    if (c) {
                        j = 0;
                        for (c = c.firstChild; c && !(1 === c.nodeType && (j++, b === c)); c = c.nextSibling);
                    }
                    return j -= f, j === d || 0 === j % d && 0 <= j / d
                } : function(c) {
                    var d = c;
                    switch (b) {
                        case "only":
                        case "first":
                            for (; d = d.previousSibling;)
                                if (1 ===
                                    d.nodeType) return !1;
                            if ("first" === b) return !0;
                            d = c;
                        case "last":
                            for (; d = d.nextSibling;)
                                if (1 === d.nodeType) return !1;
                            return !0
                    }
                }
            },
            PSEUDO: function(b, c) {
                var d, f = M.pseudos[b] || M.setFilters[b.toLowerCase()] || H.error("unsupported pseudo: " + b);
                return f[J] ? f(c) : 1 < f.length ? (d = [b, b, "", c], M.setFilters.hasOwnProperty(b.toLowerCase()) ? Y(function(b, d) {
                    for (var u, e = f(b, c), l = e.length; l--;) u = Yb.call(b, e[l]), b[u] = !(d[u] = e[l])
                }) : function(b) {
                    return f(b, 0, d)
                }) : f
            }
        },
        pseudos: {
            not: Y(function(b) {
                var c = [],
                    d = [],
                    f = mb(b.replace(Ma, "$1"));
                return f[J] ? Y(function(b, c, d, j) {
                    j = f(b, null, j, []);
                    for (var u = b.length; u--;)
                        if (d = j[u]) b[u] = !(c[u] = d)
                }) : function(b, u, e) {
                    return c[0] = b, f(c, null, e, d), !d.pop()
                }
            }),
            has: Y(function(b) {
                return function(c) {
                    return 0 < H(b, c).length
                }
            }),
            contains: Y(function(b) {
                return function(c) {
                    return -1 < (c.textContent || c.innerText || Sa(c)).indexOf(b)
                }
            }),
            enabled: function(b) {
                return !1 === b.disabled
            },
            disabled: function(b) {
                return !0 === b.disabled
            },
            checked: function(b) {
                var c = b.nodeName.toLowerCase();
                return "input" === c && !!b.checked || "option" ===
                    c && !!b.selected
            },
            selected: function(b) {
                return b.parentNode && b.parentNode.selectedIndex, !0 === b.selected
            },
            parent: function(b) {
                return !M.pseudos.empty(b)
            },
            empty: function(b) {
                var c;
                for (b = b.firstChild; b;) {
                    if ("@" < b.nodeName || 3 === (c = b.nodeType) || 4 === c) return !1;
                    b = b.nextSibling
                }
                return !0
            },
            header: function(b) {
                return cd.test(b.nodeName)
            },
            text: function(b) {
                var c, d;
                return "input" === b.nodeName.toLowerCase() && "text" === (c = b.type) && (null == (d = b.getAttribute("type")) || d.toLowerCase() === c)
            },
            radio: wa("radio"),
            checkbox: wa("checkbox"),
            file: wa("file"),
            password: wa("password"),
            image: wa("image"),
            submit: Vb("submit"),
            reset: Vb("reset"),
            button: function(b) {
                var c = b.nodeName.toLowerCase();
                return "input" === c && "button" === b.type || "button" === c
            },
            input: function(b) {
                return dd.test(b.nodeName)
            },
            focus: function(b) {
                var c = b.ownerDocument;
                return b === c.activeElement && (!c.hasFocus || c.hasFocus()) && (!!b.type || !!b.href)
            },
            active: function(b) {
                return b === b.ownerDocument.activeElement
            },
            first: ia(function() {
                return [0]
            }),
            last: ia(function(b, c) {
                return [c - 1]
            }),
            eq: ia(function(b,
                c, d) {
                return [0 > d ? d + c : d]
            }),
            even: ia(function(b, c) {
                for (var d = 0; d < c; d += 2) b.push(d);
                return b
            }),
            odd: ia(function(b, c) {
                for (var d = 1; d < c; d += 2) b.push(d);
                return b
            }),
            lt: ia(function(b, c, d) {
                for (c = 0 > d ? d + c : d; 0 <= --c;) b.push(c);
                return b
            }),
            gt: ia(function(b, c, d) {
                for (d = 0 > d ? d + c : d; ++d < c;) b.push(d);
                return b
            })
        }
    };
    ob = W.compareDocumentPosition ? function(b, c) {
        return b === c ? (ya = !0, 0) : (!b.compareDocumentPosition || !c.compareDocumentPosition ? b.compareDocumentPosition : b.compareDocumentPosition(c) & 4) ? -1 : 1
    } : function(b, c) {
        if (b === c) return ya = !0, 0;
        if (b.sourceIndex && c.sourceIndex) return b.sourceIndex - c.sourceIndex;
        var d, f, e = [],
            l = [];
        d = b.parentNode;
        f = c.parentNode;
        var g = d;
        if (d === f) return Na(b, c);
        if (!d) return -1;
        if (!f) return 1;
        for (; g;) e.unshift(g), g = g.parentNode;
        for (g = f; g;) l.unshift(g), g = g.parentNode;
        d = e.length;
        f = l.length;
        for (g = 0; g < d && g < f; g++)
            if (e[g] !== l[g]) return Na(e[g], l[g]);
        return g === d ? Na(b, l[g], -1) : Na(e[g], c, 1)
    };
    [0, 0].sort(ob);
    $b = !ya;
    H.uniqueSort = function(b) {
        var c, d = 1;
        ya = $b;
        b.sort(ob);
        if (ya)
            for (; c = b[d]; d++) c === b[d - 1] && b.splice(d--, 1);
        return b
    };
    H.error = function(b) {
        throw Error("Syntax error, unrecognized expression: " + b);
    };
    mb = H.compile = function(b, c) {
        var d, f = [],
            e = [],
            l = bc[J][b];
        if (!l) {
            c || (c = Pa(b));
            for (d = c.length; d--;) l = kb(c[d]), l[J] ? f.push(l) : e.push(l);
            var g = 0 < f.length,
                n = 0 < e.length,
                p = function(b, c, d, j, u) {
                    var l, z, m = [],
                        s = 0,
                        B = "0",
                        t = b && [],
                        v = null != u,
                        r = Ra,
                        A = b || n && M.find.TAG("*", u && c.parentNode || c),
                        y = xa += null == r ? 1 : Math.E;
                    for (v && (Ra = c !== X && c, gb = p.el); null != (u = A[B]); B++) {
                        if (n && u) {
                            for (l = 0; z = e[l]; l++)
                                if (z(u, c, d)) {
                                    j.push(u);
                                    break
                                }
                            v && (xa = y, gb =
                                ++p.el)
                        }
                        g && ((u = !z && u) && s--, b && t.push(u))
                    }
                    s += B;
                    if (g && B !== s) {
                        for (l = 0; z = f[l]; l++) z(t, m, c, d);
                        if (b) {
                            if (0 < s)
                                for (; B--;)!t[B] && !m[B] && (m[B] = ad.call(j));
                            m = Qa(m)
                        }
                        oa.apply(j, m);
                        v && !b && 0 < m.length && 1 < s + f.length && H.uniqueSort(j)
                    }
                    return v && (xa = y, Ra = r), t
                };
            d = (p.el = 0, g ? Y(p) : p);
            l = bc(b, d)
        }
        return l
    };
    if (X.querySelectorAll) {
        var dc, id = fb,
            jd = /'|\\/g,
            kd = /\=[\x20\t\r\n\f]*([^'"\]]*)[\x20\t\r\n\f]*\]/g,
            Z = [":focus"],
            Ta = [":active", ":focus"],
            Ua = W.matchesSelector || W.mozMatchesSelector || W.webkitMatchesSelector || W.oMatchesSelector ||
            W.msMatchesSelector;
        ca(function(b) {
            b.innerHTML = "<select><option selected=''></option></select>";
            b.querySelectorAll("[selected]").length || Z.push("\\[[\\x20\\t\\r\\n\\f]*(?:checked|disabled|ismap|multiple|readonly|selected|value)");
            b.querySelectorAll(":checked").length || Z.push(":checked")
        });
        ca(function(b) {
            b.innerHTML = "<p test=''></p>";
            b.querySelectorAll("[test^='']").length && Z.push("[*^$]=[\\x20\\t\\r\\n\\f]*(?:\"\"|'')");
            b.innerHTML = "<input type='hidden'/>";
            b.querySelectorAll(":enabled").length || Z.push(":enabled",
                ":disabled")
        });
        Z = RegExp(Z.join("|"));
        fb = function(b, c, d, f, e) {
            if (!f && !e && (!Z || !Z.test(b))) {
                var l, g, n = !0,
                    p = J;
                g = c;
                l = 9 === c.nodeType && b;
                if (1 === c.nodeType && "object" !== c.nodeName.toLowerCase()) {
                    l = Pa(b);
                    (n = c.getAttribute("id")) ? p = n.replace(jd, "\\$&"): c.setAttribute("id", p);
                    p = "[id='" + p + "'] ";
                    for (g = l.length; g--;) l[g] = p + l[g].join("");
                    g = lb.test(b) && c.parentNode || c;
                    l = l.join(",")
                }
                if (l) try {
                    return oa.apply(d, pa.call(g.querySelectorAll(l), 0)), d
                } catch (m) {} finally {
                    n || c.removeAttribute("id")
                }
            }
            return id(b, c, d, f, e)
        };
        Ua &&
            (ca(function(b) {
                dc = Ua.call(b, "div");
                try {
                    Ua.call(b, "[test!='']:sizzle"), Ta.push("!=", qb)
                } catch (c) {}
            }), Ta = RegExp(Ta.join("|")), H.matchesSelector = function(b, c) {
                c = c.replace(kd, "='$1']");
                if (!La(b) && !Ta.test(c) && (!Z || !Z.test(c))) try {
                    var d = Ua.call(b, c);
                    if (d || dc || b.document && 11 !== b.document.nodeType) return d
                } catch (f) {}
                return 0 < H(c, null, null, [b]).length
            })
    }
    M.pseudos.nth = M.pseudos.eq;
    M.filters = Zb.prototype = M.pseudos;
    M.setFilters = new Zb;
    H.attr = f.attr;
    f.find = H;
    f.expr = H.selectors;
    f.expr[":"] = f.expr.pseudos;
    f.unique =
        H.uniqueSort;
    f.text = H.getText;
    f.isXMLDoc = H.isXML;
    f.contains = H.contains;
    var ld = /Until$/,
        md = /^(?:parents|prev(?:Until|All))/,
        vc = /^.[^:#\[\.,]*$/,
        ec = f.expr.match.needsContext,
        nd = {
            children: !0,
            contents: !0,
            next: !0,
            prev: !0
        };
    f.fn.extend({
        find: function(b) {
            var c, d, e, l, g, n, p = this;
            if ("string" != typeof b) return f(b).filter(function() {
                c = 0;
                for (d = p.length; c < d; c++)
                    if (f.contains(p[c], this)) return !0
            });
            n = this.pushStack("", "find", b);
            c = 0;
            for (d = this.length; c < d; c++)
                if (e = n.length, f.find(b, this[c], n), 0 < c)
                    for (l = e; l < n.length; l++)
                        for (g =
                            0; g < e; g++)
                            if (n[g] === n[l]) {
                                n.splice(l--, 1);
                                break
                            }
            return n
        },
        has: function(b) {
            var c, d = f(b, this),
                e = d.length;
            return this.filter(function() {
                for (c = 0; c < e; c++)
                    if (f.contains(this, d[c])) return !0
            })
        },
        not: function(b) {
            return this.pushStack(t(this, b, !1), "not", b)
        },
        filter: function(b) {
            return this.pushStack(t(this, b, !0), "filter", b)
        },
        is: function(b) {
            return !!b && ("string" == typeof b ? ec.test(b) ? 0 <= f(b, this.context).index(this[0]) : 0 < f.filter(b, this).length : 0 < this.filter(b).length)
        },
        closest: function(b, c) {
            for (var d, e = 0, l = this.length,
                g = [], n = ec.test(b) || "string" != typeof b ? f(b, c || this.context) : 0; e < l; e++)
                for (d = this[e]; d && d.ownerDocument && d !== c && 11 !== d.nodeType;) {
                    if (n ? -1 < n.index(d) : f.find.matchesSelector(d, b)) {
                        g.push(d);
                        break
                    }
                    d = d.parentNode
                }
            return g = 1 < g.length ? f.unique(g) : g, this.pushStack(g, "closest", b)
        },
        index: function(b) {
            return b ? "string" == typeof b ? f.inArray(this[0], f(b)) : f.inArray(b.jquery ? b[0] : b, this) : this[0] && this[0].parentNode ? this.prevAll().length : -1
        },
        add: function(b, c) {
            var d = "string" == typeof b ? f(b, c) : f.makeArray(b && b.nodeType ? [b] : b),
                e = f.merge(this.get(), d);
            return this.pushStack(y(d[0]) || y(e[0]) ? e : f.unique(e))
        },
        addBack: function(b) {
            return this.add(null == b ? this.prevObject : this.prevObject.filter(b))
        }
    });
    f.fn.andSelf = f.fn.addBack;
    f.each({
        parent: function(b) {
            return (b = b.parentNode) && 11 !== b.nodeType ? b : null
        },
        parents: function(b) {
            return f.dir(b, "parentNode")
        },
        parentsUntil: function(b, c, d) {
            return f.dir(b, "parentNode", d)
        },
        next: function(b) {
            return s(b, "nextSibling")
        },
        prev: function(b) {
            return s(b, "previousSibling")
        },
        nextAll: function(b) {
            return f.dir(b,
                "nextSibling")
        },
        prevAll: function(b) {
            return f.dir(b, "previousSibling")
        },
        nextUntil: function(b, c, d) {
            return f.dir(b, "nextSibling", d)
        },
        prevUntil: function(b, c, d) {
            return f.dir(b, "previousSibling", d)
        },
        siblings: function(b) {
            return f.sibling((b.parentNode || {}).firstChild, b)
        },
        children: function(b) {
            return f.sibling(b.firstChild)
        },
        contents: function(b) {
            return f.nodeName(b, "iframe") ? b.contentDocument || b.contentWindow.document : f.merge([], b.childNodes)
        }
    }, function(b, c) {
        f.fn[b] = function(d, e) {
            var l = f.map(this, c, d);
            return ld.test(b) ||
                (e = d), e && "string" == typeof e && (l = f.filter(e, l)), l = 1 < this.length && !nd[b] ? f.unique(l) : l, 1 < this.length && md.test(b) && (l = l.reverse()), this.pushStack(l, b, aa.call(arguments).join(","))
        }
    });
    f.extend({
        filter: function(b, c, d) {
            return d && (b = ":not(" + b + ")"), 1 === c.length ? f.find.matchesSelector(c[0], b) ? [c[0]] : [] : f.find.matches(b, c)
        },
        dir: function(b, d, e) {
            var l = [];
            for (b = b[d]; b && 9 !== b.nodeType && (e === c || 1 !== b.nodeType || !f(b).is(e));) 1 === b.nodeType && l.push(b), b = b[d];
            return l
        },
        sibling: function(b, c) {
            for (var d = []; b; b = b.nextSibling) 1 ===
                b.nodeType && b !== c && d.push(b);
            return d
        }
    });
    var xb = "abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",
        od = / jQuery\d+="(?:null|\d+)"/g,
        rb = /^\s+/,
        fc = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
        gc = /<([\w:]+)/,
        pd = /<tbody/i,
        qd = /<|&#?\w+;/,
        rd = /<(?:script|style|link)/i,
        sd = /<(?:script|object|embed|option|style)/i,
        sb = RegExp("<(?:" + xb + ")[\\s/>]", "i"),
        yb = /^(?:checkbox|radio)$/,
        hc = /checked\s*(?:[^=]|=\s*.checked.)/i,
        td = /\/(java|ecma)script/i,
        ud = /^\s*<!(?:\[CDATA\[|\-\-)|[\]\-]{2}>\s*$/g,
        V = {
            option: [1, "<select multiple='multiple'>", "</select>"],
            legend: [1, "<fieldset>", "</fieldset>"],
            thead: [1, "<table>", "</table>"],
            tr: [2, "<table><tbody>", "</tbody></table>"],
            td: [3, "<table><tbody><tr>", "</tr></tbody></table>"],
            col: [2, "<table><tbody></tbody><colgroup>", "</colgroup></table>"],
            area: [1, "<map>", "</map>"],
            _default: [0, "", ""]
        },
        ic = v(D),
        tb = ic.appendChild(D.createElement("div"));
    V.optgroup =
        V.option;
    V.tbody = V.tfoot = V.colgroup = V.caption = V.thead;
    V.th = V.td;
    f.support.htmlSerialize || (V._default = [1, "X<div>", "</div>"]);
    f.fn.extend({
        text: function(b) {
            return f.access(this, function(b) {
                return b === c ? f.text(this) : this.empty().append((this[0] && this[0].ownerDocument || D).createTextNode(b))
            }, null, b, arguments.length)
        },
        wrapAll: function(b) {
            if (f.isFunction(b)) return this.each(function(c) {
                f(this).wrapAll(b.call(this, c))
            });
            if (this[0]) {
                var c = f(b, this[0].ownerDocument).eq(0).clone(!0);
                this[0].parentNode && c.insertBefore(this[0]);
                c.map(function() {
                    for (var b = this; b.firstChild && 1 === b.firstChild.nodeType;) b = b.firstChild;
                    return b
                }).append(this)
            }
            return this
        },
        wrapInner: function(b) {
            return f.isFunction(b) ? this.each(function(c) {
                f(this).wrapInner(b.call(this, c))
            }) : this.each(function() {
                var c = f(this),
                    d = c.contents();
                d.length ? d.wrapAll(b) : c.append(b)
            })
        },
        wrap: function(b) {
            var c = f.isFunction(b);
            return this.each(function(d) {
                f(this).wrapAll(c ? b.call(this, d) : b)
            })
        },
        unwrap: function() {
            return this.parent().each(function() {
                f.nodeName(this, "body") ||
                    f(this).replaceWith(this.childNodes)
            }).end()
        },
        append: function() {
            return this.domManip(arguments, !0, function(b) {
                (1 === this.nodeType || 11 === this.nodeType) && this.appendChild(b)
            })
        },
        prepend: function() {
            return this.domManip(arguments, !0, function(b) {
                (1 === this.nodeType || 11 === this.nodeType) && this.insertBefore(b, this.firstChild)
            })
        },
        before: function() {
            if (!y(this[0])) return this.domManip(arguments, !1, function(b) {
                this.parentNode.insertBefore(b, this)
            });
            if (arguments.length) {
                var b = f.clean(arguments);
                return this.pushStack(f.merge(b,
                    this), "before", this.selector)
            }
        },
        after: function() {
            if (!y(this[0])) return this.domManip(arguments, !1, function(b) {
                this.parentNode.insertBefore(b, this.nextSibling)
            });
            if (arguments.length) {
                var b = f.clean(arguments);
                return this.pushStack(f.merge(this, b), "after", this.selector)
            }
        },
        remove: function(b, c) {
            for (var d, e = 0; null != (d = this[e]); e++)
                if (!b || f.filter(b, [d]).length)!c && 1 === d.nodeType && (f.cleanData(d.getElementsByTagName("*")), f.cleanData([d])), d.parentNode && d.parentNode.removeChild(d);
            return this
        },
        empty: function() {
            for (var b,
                c = 0; null != (b = this[c]); c++)
                for (1 === b.nodeType && f.cleanData(b.getElementsByTagName("*")); b.firstChild;) b.removeChild(b.firstChild);
            return this
        },
        clone: function(b, c) {
            return b = null == b ? !1 : b, c = null == c ? b : c, this.map(function() {
                return f.clone(this, b, c)
            })
        },
        html: function(b) {
            return f.access(this, function(b) {
                var d = this[0] || {},
                    e = 0,
                    l = this.length;
                if (b === c) return 1 === d.nodeType ? d.innerHTML.replace(od, "") : c;
                if ("string" == typeof b && !rd.test(b) && (f.support.htmlSerialize || !sb.test(b)) && (f.support.leadingWhitespace || !rb.test(b)) &&
                    !V[(gc.exec(b) || ["", ""])[1].toLowerCase()]) {
                    b = b.replace(fc, "<$1></$2>");
                    try {
                        for (; e < l; e++) d = this[e] || {}, 1 === d.nodeType && (f.cleanData(d.getElementsByTagName("*")), d.innerHTML = b);
                        d = 0
                    } catch (u) {}
                }
                d && this.empty().append(b)
            }, null, b, arguments.length)
        },
        replaceWith: function(b) {
            return y(this[0]) ? this.length ? this.pushStack(f(f.isFunction(b) ? b() : b), "replaceWith", b) : this : f.isFunction(b) ? this.each(function(c) {
                var d = f(this),
                    e = d.html();
                d.replaceWith(b.call(this, c, e))
            }) : ("string" != typeof b && (b = f(b).detach()), this.each(function() {
                var c =
                    this.nextSibling,
                    d = this.parentNode;
                f(this).remove();
                c ? f(c).before(b) : f(d).append(b)
            }))
        },
        detach: function(b) {
            return this.remove(b, !0)
        },
        domManip: function(b, d, e) {
            b = [].concat.apply([], b);
            var l, g, n, q = 0,
                p = b[0],
                m = [],
                s = this.length;
            if (!f.support.checkClone && 1 < s && "string" == typeof p && hc.test(p)) return this.each(function() {
                f(this).domManip(b, d, e)
            });
            if (f.isFunction(p)) return this.each(function(l) {
                var g = f(this);
                b[0] = p.call(this, l, d ? g.html() : c);
                g.domManip(b, d, e)
            });
            if (this[0]) {
                l = f.buildFragment(b, this, m);
                n = l.fragment;
                g = n.firstChild;
                1 === n.childNodes.length && (n = g);
                if (g) {
                    d = d && f.nodeName(g, "tr");
                    for (l = l.cacheable || s - 1; q < s; q++) e.call(d && f.nodeName(this[q], "table") ? this[q].getElementsByTagName("tbody")[0] || this[q].appendChild(this[q].ownerDocument.createElement("tbody")) : this[q], q === l ? n : f.clone(n, !0, !0))
                }
                n = g = null;
                m.length && f.each(m, function(b, c) {
                    c.src ? f.ajax ? f.ajax({
                        url: c.src,
                        type: "GET",
                        dataType: "script",
                        async: !1,
                        global: !1,
                        "throws": !0
                    }) : f.error("no ajax") : f.globalEval((c.text || c.textContent || c.innerHTML || "").replace(ud,
                        ""));
                    c.parentNode && c.parentNode.removeChild(c)
                })
            }
            return this
        }
    });
    f.buildFragment = function(b, d, e) {
        var l, g, n, q = b[0];
        return d = d || D, d = !d.nodeType && d[0] || d, d = d.ownerDocument || d, 1 === b.length && "string" == typeof q && 512 > q.length && d === D && "<" === q.charAt(0) && !sd.test(q) && (f.support.checkClone || !hc.test(q)) && (f.support.html5Clone || !sb.test(q)) && (g = !0, l = f.fragments[q], n = l !== c), l || (l = d.createDocumentFragment(), f.clean(b, d, l, e), g && (f.fragments[q] = n && l)), {
            fragment: l,
            cacheable: g
        }
    };
    f.fragments = {};
    f.each({
        appendTo: "append",
        prependTo: "prepend",
        insertBefore: "before",
        insertAfter: "after",
        replaceAll: "replaceWith"
    }, function(b, c) {
        f.fn[b] = function(d) {
            var e, l = 0,
                g = [];
            d = f(d);
            var n = d.length;
            e = 1 === this.length && this[0].parentNode;
            if ((null == e || e && 11 === e.nodeType && 1 === e.childNodes.length) && 1 === n) return d[c](this[0]), this;
            for (; l < n; l++) e = (0 < l ? this.clone(!0) : this).get(), f(d[l])[c](e), g = g.concat(e);
            return this.pushStack(g, b, d.selector)
        }
    });
    f.extend({
        clone: function(b, c, d) {
            var e, g, p, q;
            f.support.html5Clone || f.isXMLDoc(b) || !sb.test("<" + b.nodeName +
                ">") ? q = b.cloneNode(!0) : (tb.innerHTML = b.outerHTML, tb.removeChild(q = tb.firstChild));
            if ((!f.support.noCloneEvent || !f.support.noCloneChecked) && (1 === b.nodeType || 11 === b.nodeType) && !f.isXMLDoc(b)) {
                l(b, q);
                e = n(b);
                g = n(q);
                for (p = 0; e[p]; ++p) g[p] && l(e[p], g[p])
            }
            if (c && (r(b, q), d)) {
                e = n(b);
                g = n(q);
                for (p = 0; e[p]; ++p) r(e[p], g[p])
            }
            return q
        },
        clean: function(b, c, d, e) {
            var l, g, n, m, s, t, r, A = c === D && ic,
                y = [];
            if (!c || "undefined" == typeof c.createDocumentFragment) c = D;
            for (l = 0; null != (n = b[l]); l++)
                if ("number" == typeof n && (n += ""), n) {
                    if ("string" ==
                        typeof n)
                        if (qd.test(n)) {
                            A = A || v(c);
                            t = c.createElement("div");
                            A.appendChild(t);
                            n = n.replace(fc, "<$1></$2>");
                            g = (gc.exec(n) || ["", ""])[1].toLowerCase();
                            m = V[g] || V._default;
                            s = m[0];
                            for (t.innerHTML = m[1] + n + m[2]; s--;) t = t.lastChild;
                            if (!f.support.tbody) {
                                s = pd.test(n);
                                m = "table" === g && !s ? t.firstChild && t.firstChild.childNodes : "<table>" === m[1] && !s ? t.childNodes : [];
                                for (g = m.length - 1; 0 <= g; --g) f.nodeName(m[g], "tbody") && !m[g].childNodes.length && m[g].parentNode.removeChild(m[g])
                            }!f.support.leadingWhitespace && rb.test(n) && t.insertBefore(c.createTextNode(rb.exec(n)[0]),
                                t.firstChild);
                            n = t.childNodes;
                            t.parentNode.removeChild(t)
                        } else n = c.createTextNode(n);
                    n.nodeType ? y.push(n) : f.merge(y, n)
                }
            t && (n = t = A = null);
            if (!f.support.appendChecked)
                for (l = 0; null != (n = y[l]); l++) f.nodeName(n, "input") ? p(n) : "undefined" != typeof n.getElementsByTagName && f.grep(n.getElementsByTagName("input"), p);
            if (d) {
                b = function(b) {
                    if (!b.type || td.test(b.type)) return e ? e.push(b.parentNode ? b.parentNode.removeChild(b) : b) : d.appendChild(b)
                };
                for (l = 0; null != (n = y[l]); l++)
                    if (!f.nodeName(n, "script") || !b(n)) d.appendChild(n),
                        "undefined" != typeof n.getElementsByTagName && (r = f.grep(f.merge([], n.getElementsByTagName("script")), b), y.splice.apply(y, [l + 1, 0].concat(r)), l += r.length)
            }
            return y
        },
        cleanData: function(b, c) {
            for (var d, e, l, g, n = 0, p = f.expando, m = f.cache, s = f.support.deleteExpando, t = f.event.special; null != (l = b[n]); n++)
                if (c || f.acceptData(l))
                    if (d = (e = l[p]) && m[e]) {
                        if (d.events)
                            for (g in d.events) t[g] ? f.event.remove(l, g) : f.removeEvent(l, g, d.handle);
                        m[e] && (delete m[e], s ? delete l[p] : l.removeAttribute ? l.removeAttribute(p) : l[p] = null, f.deletedIds.push(e))
                    }
        }
    });
    var Va, da;
    f.uaMatch = function(b) {
        b = b.toLowerCase();
        b = /(chrome)[ \/]([\w.]+)/.exec(b) || /(webkit)[ \/]([\w.]+)/.exec(b) || /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(b) || /(msie) ([\w.]+)/.exec(b) || 0 > b.indexOf("compatible") && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(b) || [];
        return {
            browser: b[1] || "",
            version: b[2] || "0"
        }
    };
    Va = f.uaMatch(Ac.userAgent);
    da = {};
    Va.browser && (da[Va.browser] = !0, da.version = Va.version);
    da.chrome ? da.webkit = !0 : da.webkit && (da.safari = !0);
    f.browser = da;
    f.sub = function() {
        function b(c, d) {
            return new b.fn.init(c,
                d)
        }
        f.extend(!0, b, this);
        b.superclass = this;
        b.fn = b.prototype = this();
        b.fn.constructor = b;
        b.sub = this.sub;
        b.fn.init = function(d, e) {
            return e && e instanceof f && !(e instanceof b) && (e = b(e)), f.fn.init.call(this, d, e, c)
        };
        b.fn.init.prototype = b.fn;
        var c = b(D);
        return b
    };
    var Q, la, ma, ub = /alpha\([^)]*\)/i,
        vd = /opacity=([^)]*)/,
        wd = /^(top|right|bottom|left)$/,
        xd = /^(none|table(?!-c[ea]).+)/,
        jc = /^margin/,
        wc = RegExp("^(" + Fa + ")(.*)$", "i"),
        za = RegExp("^(" + Fa + ")(?!px)[a-z%]+$", "i"),
        yd = RegExp("^([-+])=(" + Fa + ")", "i"),
        Za = {},
        zd = {
            position: "absolute",
            visibility: "hidden",
            display: "block"
        },
        kc = {
            letterSpacing: 0,
            fontWeight: 400
        },
        ea = ["Top", "Right", "Bottom", "Left"],
        zb = ["Webkit", "O", "Moz", "ms"],
        Ad = f.fn.toggle;
    f.fn.extend({
        css: function(b, d) {
            return f.access(this, function(b, d, e) {
                return e !== c ? f.style(b, d, e) : f.css(b, d)
            }, b, d, 1 < arguments.length)
        },
        show: function() {
            return C(this, !0)
        },
        hide: function() {
            return C(this)
        },
        toggle: function(b, c) {
            var d = "boolean" == typeof b;
            return f.isFunction(b) && f.isFunction(c) ? Ad.apply(this, arguments) : this.each(function() {
                (d ? b : E(this)) ? f(this).show():
                    f(this).hide()
            })
        }
    });
    f.extend({
        cssHooks: {
            opacity: {
                get: function(b, c) {
                    if (c) {
                        var d = Q(b, "opacity");
                        return "" === d ? "1" : d
                    }
                }
            }
        },
        cssNumber: {
            fillOpacity: !0,
            fontWeight: !0,
            lineHeight: !0,
            opacity: !0,
            orphans: !0,
            widows: !0,
            zIndex: !0,
            zoom: !0
        },
        cssProps: {
            "float": f.support.cssFloat ? "cssFloat" : "styleFloat"
        },
        style: function(b, d, e, l) {
            if (b && !(3 === b.nodeType || 8 === b.nodeType || !b.style)) {
                var g, n, p, m = f.camelCase(d),
                    s = b.style;
                d = f.cssProps[m] || (f.cssProps[m] = A(s, m));
                p = f.cssHooks[d] || f.cssHooks[m];
                if (e === c) return p && "get" in p && (g = p.get(b, !1, l)) !== c ? g : s[d];
                n = typeof e;
                "string" === n && (g = yd.exec(e)) && (e = (g[1] + 1) * g[2] + parseFloat(f.css(b, d)), n = "number");
                if (!(null == e || "number" === n && isNaN(e)))
                    if ("number" === n && !f.cssNumber[m] && (e += "px"), !p || !("set" in p) || (e = p.set(b, e, l)) !== c) try {
                        s[d] = e
                    } catch (t) {}
            }
        },
        css: function(b, d, e, l) {
            var g, n, p, m = f.camelCase(d);
            return d = f.cssProps[m] || (f.cssProps[m] = A(b.style, m)), p = f.cssHooks[d] || f.cssHooks[m], p && "get" in p && (g = p.get(b, !0, l)), g === c && (g = Q(b, d)), "normal" === g && d in kc && (g = kc[d]), e || l !== c ? (n = parseFloat(g), e ||
                f.isNumeric(n) ? n || 0 : g) : g
        },
        swap: function(b, c, d) {
            var f, e = {};
            for (f in c) e[f] = b.style[f], b.style[f] = c[f];
            d = d.call(b);
            for (f in c) b.style[f] = e[f];
            return d
        }
    });
    b.getComputedStyle ? Q = function(c, d) {
        var e, l, g, n, p = b.getComputedStyle(c, null),
            m = c.style;
        return p && (e = p[d], "" === e && !f.contains(c.ownerDocument, c) && (e = f.style(c, d)), za.test(e) && jc.test(d) && (l = m.width, g = m.minWidth, n = m.maxWidth, m.minWidth = m.maxWidth = m.width = e, e = p.width, m.width = l, m.minWidth = g, m.maxWidth = n)), e
    } : D.documentElement.currentStyle && (Q = function(b,
        c) {
        var d, f, e = b.currentStyle && b.currentStyle[c],
            l = b.style;
        return null == e && l && l[c] && (e = l[c]), za.test(e) && !wd.test(c) && (d = l.left, f = b.runtimeStyle && b.runtimeStyle.left, f && (b.runtimeStyle.left = b.currentStyle.left), l.left = "fontSize" === c ? "1em" : e, e = l.pixelLeft + "px", l.left = d, f && (b.runtimeStyle.left = f)), "" === e ? "auto" : e
    });
    f.each(["height", "width"], function(b, c) {
        f.cssHooks[c] = {
            get: function(b, d, e) {
                if (d) return 0 === b.offsetWidth && xd.test(Q(b, "display")) ? f.swap(b, zd, function() {
                    return I(b, c, e)
                }) : I(b, c, e)
            },
            set: function(b,
                d, e) {
                return G(b, d, e ? Ya(b, c, e, f.support.boxSizing && "border-box" === f.css(b, "boxSizing")) : 0)
            }
        }
    });
    f.support.opacity || (f.cssHooks.opacity = {
        get: function(b, c) {
            return vd.test((c && b.currentStyle ? b.currentStyle.filter : b.style.filter) || "") ? 0.01 * parseFloat(RegExp.$1) + "" : c ? "1" : ""
        },
        set: function(b, c) {
            var d = b.style,
                e = b.currentStyle,
                l = f.isNumeric(c) ? "alpha(opacity=" + 100 * c + ")" : "",
                g = e && e.filter || d.filter || "";
            d.zoom = 1;
            if (!(1 <= c && "" === f.trim(g.replace(ub, "")) && d.removeAttribute && (d.removeAttribute("filter"), e && !e.filter))) d.filter =
                ub.test(g) ? g.replace(ub, l) : g + " " + l
        }
    });
    f(function() {
        f.support.reliableMarginRight || (f.cssHooks.marginRight = {
            get: function(b, c) {
                return f.swap(b, {
                    display: "inline-block"
                }, function() {
                    if (c) return Q(b, "marginRight")
                })
            }
        });
        !f.support.pixelPosition && f.fn.position && f.each(["top", "left"], function(b, c) {
            f.cssHooks[c] = {
                get: function(b, d) {
                    if (d) {
                        var e = Q(b, c);
                        return za.test(e) ? f(b).position()[c] + "px" : e
                    }
                }
            }
        })
    });
    f.expr && f.expr.filters && (f.expr.filters.hidden = function(b) {
        return 0 === b.offsetWidth && 0 === b.offsetHeight || !f.support.reliableHiddenOffsets &&
            "none" === (b.style && b.style.display || Q(b, "display"))
    }, f.expr.filters.visible = function(b) {
        return !f.expr.filters.hidden(b)
    });
    f.each({
        margin: "",
        padding: "",
        border: "Width"
    }, function(b, c) {
        f.cssHooks[b + c] = {
            expand: function(d) {
                var f = "string" == typeof d ? d.split(" ") : [d],
                    e = {};
                for (d = 0; 4 > d; d++) e[b + ea[d] + c] = f[d] || f[d - 2] || f[0];
                return e
            }
        };
        jc.test(b) || (f.cssHooks[b + c].set = G)
    });
    var Bd = /%20/g,
        xc = /\[\]$/,
        lc = /\r?\n/g,
        Cd = /^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,
        Dd = /^(?:select|textarea)/i;
    f.fn.extend({
        serialize: function() {
            return f.param(this.serializeArray())
        },
        serializeArray: function() {
            return this.map(function() {
                return this.elements ? f.makeArray(this.elements) : this
            }).filter(function() {
                return this.name && !this.disabled && (this.checked || Dd.test(this.nodeName) || Cd.test(this.type))
            }).map(function(b, c) {
                var d = f(this).val();
                return null == d ? null : f.isArray(d) ? f.map(d, function(b) {
                    return {
                        name: c.name,
                        value: b.replace(lc, "\r\n")
                    }
                }) : {
                    name: c.name,
                    value: d.replace(lc, "\r\n")
                }
            }).get()
        }
    });
    f.param = function(b, d) {
        var e, l = [],
            g = function(b, c) {
                c = f.isFunction(c) ? c() : null == c ? "" : c;
                l[l.length] = encodeURIComponent(b) + "=" + encodeURIComponent(c)
            };
        d === c && (d = f.ajaxSettings && f.ajaxSettings.traditional);
        if (f.isArray(b) || b.jquery && !f.isPlainObject(b)) f.each(b, function() {
            g(this.name, this.value)
        });
        else
            for (e in b) N(e, b[e], d, g);
        return l.join("&").replace(Bd, "+")
    };
    var qa, ka, Ed = /#.*$/,
        Fd = /^(.*?):[ \t]*([^\r\n]*)\r?$/mg,
        Gd = /^(?:GET|HEAD)$/,
        Hd = /^\/\//,
        mc = /\?/,
        Id = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
        Jd = /([?&])_=[^&]*/,
        nc = /^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/,
        oc = f.fn.load,
        $a = {},
        pc = {},
        qc = ["*/"] + ["*"];
    try {
        ka = zc.href
    } catch (Sd) {
        ka = D.createElement("a"), ka.href = "", ka = ka.href
    }
    qa = nc.exec(ka.toLowerCase()) || [];
    f.fn.load = function(b, d, e) {
        if ("string" != typeof b && oc) return oc.apply(this, arguments);
        if (!this.length) return this;
        var l, g, n, p = this,
            m = b.indexOf(" ");
        return 0 <= m && (l = b.slice(m, b.length), b = b.slice(0, m)), f.isFunction(d) ? (e = d, d = c) : d && "object" == typeof d && (g = "POST"), f.ajax({
            url: b,
            type: g,
            dataType: "html",
            data: d,
            complete: function(b, c) {
                e && p.each(e, n || [b.responseText, c, b])
            }
        }).done(function(b) {
            n = arguments;
            p.html(l ? f("<div>").append(b.replace(Id, "")).find(l) : b)
        }), this
    };
    f.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "), function(b, c) {
        f.fn[c] = function(b) {
            return this.on(c, b)
        }
    });
    f.each(["get", "post"], function(b, d) {
        f[d] = function(b, e, l, g) {
            return f.isFunction(e) && (g = g || l, l = e, e = c), f.ajax({
                type: d,
                url: b,
                data: e,
                success: l,
                dataType: g
            })
        }
    });
    f.extend({
        getScript: function(b, d) {
            return f.get(b,
                c, d, "script")
        },
        getJSON: function(b, c, d) {
            return f.get(b, c, d, "json")
        },
        ajaxSetup: function(b, c) {
            return c ? sa(b, f.ajaxSettings) : (c = b, b = f.ajaxSettings), sa(b, c), b
        },
        ajaxSettings: {
            url: ka,
            isLocal: /^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/.test(qa[1]),
            global: !0,
            type: "GET",
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            processData: !0,
            async: !0,
            accepts: {
                xml: "application/xml, text/xml",
                html: "text/html",
                text: "text/plain",
                json: "application/json, text/javascript",
                "*": qc
            },
            contents: {
                xml: /xml/,
                html: /html/,
                json: /json/
            },
            responseFields: {
                xml: "responseXML",
                text: "responseText"
            },
            converters: {
                "* text": b.String,
                "text html": !0,
                "text json": f.parseJSON,
                "text xml": f.parseXML
            },
            flatOptions: {
                context: !0,
                url: !0
            }
        },
        ajaxPrefilter: Aa($a),
        ajaxTransport: Aa(pc),
        ajax: function(b, d) {
            function e(b, d, j, n) {
                var u, s, v, z, B, G = d;
                if (2 !== I) {
                    I = 2;
                    m && clearTimeout(m);
                    p = c;
                    g = n || "";
                    K.readyState = 0 < b ? 4 : 0;
                    if (j) {
                        z = r;
                        n = K;
                        var U, R, H, L, M = z.contents,
                            N = z.dataTypes,
                            P = z.responseFields;
                        for (R in P) R in j && (n[P[R]] = j[R]);
                        for (;
                            "*" === N[0];) N.shift(),
                            U === c && (U = z.mimeType || n.getResponseHeader("content-type"));
                        if (U)
                            for (R in M)
                                if (M[R] && M[R].test(U)) {
                                    N.unshift(R);
                                    break
                                }
                        if (N[0] in j) H = N[0];
                        else {
                            for (R in j) {
                                if (!N[0] || z.converters[R + " " + N[0]]) {
                                    H = R;
                                    break
                                }
                                L || (L = R)
                            }
                            H = H || L
                        }
                        z = j = H ? (H !== N[0] && N.unshift(H), j[H]) : void 0
                    }
                    if (200 <= b && 300 > b || 304 === b)
                        if (r.ifModified && (B = K.getResponseHeader("Last-Modified"), B && (f.lastModified[l] = B), B = K.getResponseHeader("Etag"), B && (f.etag[l] = B)), 304 === b) G = "notmodified", u = !0;
                        else {
                            var J;
                            a: {
                                u = r;
                                s = z;
                                var O, G = u.dataTypes.slice();
                                j = G[0];
                                U = {};
                                R = 0;
                                u.dataFilter && (s = u.dataFilter(s, u.dataType));
                                if (G[1])
                                    for (J in u.converters) U[J.toLowerCase()] = u.converters[J];
                                for (; v = G[++R];)
                                    if ("*" !== v) {
                                        if ("*" !== j && j !== v) {
                                            J = U[j + " " + v] || U["* " + v];
                                            if (!J)
                                                for (O in U)
                                                    if (B = O.split(" "), B[1] === v && (J = U[j + " " + B[0]] || U["* " + B[0]])) {
                                                        !0 === J ? J = U[O] : !0 !== U[O] && (v = B[0], G.splice(R--, 0, v));
                                                        break
                                                    }
                                            if (!0 !== J)
                                                if (J && u["throws"]) s = J(s);
                                                else try {
                                                    s = J(s)
                                                } catch (Q) {
                                                    J = {
                                                        state: "parsererror",
                                                        error: J ? Q : "No conversion from " + j + " to " + v
                                                    };
                                                    break a
                                                }
                                        }
                                        j = v
                                    }
                                J = {
                                    state: "success",
                                    data: s
                                }
                            }
                            u = J;
                            G = u.state;
                            s = u.data;
                            v = u.error;
                            u = !v
                        } else if (v = G, !G || b) G = "error", 0 > b && (b = 0);
                    K.status = b;
                    K.statusText = (d || G) + "";
                    u ? E.resolveWith(A, [s, G, K]) : E.rejectWith(A, [K, G, v]);
                    K.statusCode(D);
                    D = c;
                    t && y.trigger("ajax" + (u ? "Success" : "Error"), [K, r, u ? s : v]);
                    C.fireWith(A, [K, G]);
                    t && (y.trigger("ajaxComplete", [K, r]), --f.active || f.event.trigger("ajaxStop"))
                }
            }
            "object" == typeof b && (d = b, b = c);
            d = d || {};
            var l, g, n, p, m, s, t, v, r = f.ajaxSetup({}, d),
                A = r.context || r,
                y = A !== r && (A.nodeType || A instanceof f) ? f(A) : f.event,
                E = f.Deferred(),
                C = f.Callbacks("once memory"),
                D = r.statusCode || {},
                G = {},
                H = {},
                I = 0,
                L = "canceled",
                K = {
                    readyState: 0,
                    setRequestHeader: function(b, c) {
                        if (!I) {
                            var d = b.toLowerCase();
                            b = H[d] = H[d] || b;
                            G[b] = c
                        }
                        return this
                    },
                    getAllResponseHeaders: function() {
                        return 2 === I ? g : null
                    },
                    getResponseHeader: function(b) {
                        var d;
                        if (2 === I) {
                            if (!n)
                                for (n = {}; d = Fd.exec(g);) n[d[1].toLowerCase()] = d[2];
                            d = n[b.toLowerCase()]
                        }
                        return d === c ? null : d
                    },
                    overrideMimeType: function(b) {
                        return I || (r.mimeType = b), this
                    },
                    abort: function(b) {
                        return b = b || L, p && p.abort(b), e(0, b), this
                    }
                };
            E.promise(K);
            K.success = K.done;
            K.error = K.fail;
            K.complete = C.add;
            K.statusCode = function(b) {
                if (b) {
                    var c;
                    if (2 > I)
                        for (c in b) D[c] = [D[c], b[c]];
                    else c = b[K.status], K.always(c)
                }
                return this
            };
            r.url = ((b || r.url) + "").replace(Ed, "").replace(Hd, qa[1] + "//");
            r.dataTypes = f.trim(r.dataType || "*").toLowerCase().split(fa);
            null == r.crossDomain && (s = nc.exec(r.url.toLowerCase()) || !1, r.crossDomain = s && s.join(":") + (s[3] ? "" : "http:" === s[1] ? 80 : 443) !== qa.join(":") + (qa[3] ? "" : "http:" === qa[1] ? 80 : 443));
            r.data && r.processData && "string" != typeof r.data && (r.data = f.param(r.data,
                r.traditional));
            na($a, r, d, K);
            if (2 === I) return K;
            t = r.global;
            r.type = r.type.toUpperCase();
            r.hasContent = !Gd.test(r.type);
            t && 0 === f.active++ && f.event.trigger("ajaxStart");
            if (!r.hasContent && (r.data && (r.url += (mc.test(r.url) ? "&" : "?") + r.data, delete r.data), l = r.url, !1 === r.cache)) {
                s = f.now();
                var M = r.url.replace(Jd, "$1_=" + s);
                r.url = M + (M === r.url ? (mc.test(r.url) ? "&" : "?") + "_=" + s : "")
            }(r.data && r.hasContent && !1 !== r.contentType || d.contentType) && K.setRequestHeader("Content-Type", r.contentType);
            r.ifModified && (l = l || r.url,
                f.lastModified[l] && K.setRequestHeader("If-Modified-Since", f.lastModified[l]), f.etag[l] && K.setRequestHeader("If-None-Match", f.etag[l]));
            K.setRequestHeader("Accept", r.dataTypes[0] && r.accepts[r.dataTypes[0]] ? r.accepts[r.dataTypes[0]] + ("*" !== r.dataTypes[0] ? ", " + qc + "; q=0.01" : "") : r.accepts["*"]);
            for (v in r.headers) K.setRequestHeader(v, r.headers[v]);
            if (!r.beforeSend || !1 !== r.beforeSend.call(A, K, r) && 2 !== I) {
                L = "abort";
                for (v in {
                    success: 1,
                    error: 1,
                    complete: 1
                }) K[v](r[v]);
                if (p = na(pc, r, d, K)) {
                    K.readyState = 1;
                    t && y.trigger("ajaxSend", [K, r]);
                    r.async && 0 < r.timeout && (m = setTimeout(function() {
                        K.abort("timeout")
                    }, r.timeout));
                    try {
                        I = 1, p.send(G, e)
                    } catch (N) {
                        if (2 > I) e(-1, N);
                        else throw N;
                    }
                } else e(-1, "No Transport");
                return K
            }
            return K.abort()
        },
        active: 0,
        lastModified: {},
        etag: {}
    });
    var rc = [],
        Kd = /\?/,
        Wa = /(=)\?(?=&|$)|\?\?/,
        Ld = f.now();
    f.ajaxSetup({
        jsonp: "callback",
        jsonpCallback: function() {
            var b = rc.pop() || f.expando + "_" + Ld++;
            return this[b] = !0, b
        }
    });
    f.ajaxPrefilter("json jsonp", function(d, e, l) {
        var g, n, p, m = d.data,
            s = d.url,
            r = !1 !== d.jsonp,
            t = r && Wa.test(s),
            v = r && !t && "string" == typeof m && !(d.contentType || "").indexOf("application/x-www-form-urlencoded") && Wa.test(m);
        if ("jsonp" === d.dataTypes[0] || t || v) return g = d.jsonpCallback = f.isFunction(d.jsonpCallback) ? d.jsonpCallback() : d.jsonpCallback, n = b[g], t ? d.url = s.replace(Wa, "$1" + g) : v ? d.data = m.replace(Wa, "$1" + g) : r && (d.url += (Kd.test(s) ? "&" : "?") + d.jsonp + "=" + g), d.converters["script json"] = function() {
            return p || f.error(g + " was not called"), p[0]
        }, d.dataTypes[0] = "json", b[g] = function() {
            p = arguments
        }, l.always(function() {
            b[g] =
                n;
            d[g] && (d.jsonpCallback = e.jsonpCallback, rc.push(g));
            p && f.isFunction(n) && n(p[0]);
            p = n = c
        }), "script"
    });
    f.ajaxSetup({
        accepts: {
            script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
        },
        contents: {
            script: /javascript|ecmascript/
        },
        converters: {
            "text script": function(b) {
                return f.globalEval(b), b
            }
        }
    });
    f.ajaxPrefilter("script", function(b) {
        b.cache === c && (b.cache = !1);
        b.crossDomain && (b.type = "GET", b.global = !1)
    });
    f.ajaxTransport("script", function(b) {
        if (b.crossDomain) {
            var d, f =
                D.head || D.getElementsByTagName("head")[0] || D.documentElement;
            return {
                send: function(e, l) {
                    d = D.createElement("script");
                    d.async = "async";
                    b.scriptCharset && (d.charset = b.scriptCharset);
                    d.src = b.url;
                    d.onload = d.onreadystatechange = function(b, e) {
                        if (e || !d.readyState || /loaded|complete/.test(d.readyState)) d.onload = d.onreadystatechange = null, f && d.parentNode && f.removeChild(d), d = c, e || l(200, "success")
                    };
                    f.insertBefore(d, f.firstChild)
                },
                abort: function() {
                    d && d.onload(0, 1)
                }
            }
        }
    });
    var ra, vb = b.ActiveXObject ? function() {
            for (var b in ra) ra[b](0,
                1)
        } : !1,
        Md = 0;
    f.ajaxSettings.xhr = b.ActiveXObject ? function() {
        var c;
        if (!(c = !this.isLocal && Ab())) a: {
            try {
                c = new b.ActiveXObject("Microsoft.XMLHTTP");
                break a
            } catch (d) {}
            c = void 0
        }
        return c
    } : Ab;
    var wb = f.ajaxSettings.xhr();
    f.extend(f.support, {
        ajax: !!wb,
        cors: !!wb && "withCredentials" in wb
    });
    f.support.ajax && f.ajaxTransport(function(d) {
        if (!d.crossDomain || f.support.cors) {
            var e;
            return {
                send: function(l, g) {
                    var n, p, m = d.xhr();
                    d.username ? m.open(d.type, d.url, d.async, d.username, d.password) : m.open(d.type, d.url, d.async);
                    if (d.xhrFields)
                        for (p in d.xhrFields) m[p] =
                            d.xhrFields[p];
                    d.mimeType && m.overrideMimeType && m.overrideMimeType(d.mimeType);
                    !d.crossDomain && !l["X-Requested-With"] && (l["X-Requested-With"] = "XMLHttpRequest");
                    try {
                        for (p in l) m.setRequestHeader(p, l[p])
                    } catch (s) {}
                    m.send(d.hasContent && d.data || null);
                    e = function(b, l) {
                        var p, s, r, t, v;
                        try {
                            if (e && (l || 4 === m.readyState))
                                if (e = c, n && (m.onreadystatechange = f.noop, vb && delete ra[n]), l) 4 !== m.readyState && m.abort();
                                else {
                                    p = m.status;
                                    r = m.getAllResponseHeaders();
                                    t = {};
                                    (v = m.responseXML) && v.documentElement && (t.xml = v);
                                    try {
                                        t.text =
                                            m.responseText
                                    } catch (z) {}
                                    try {
                                        s = m.statusText
                                    } catch (A) {
                                        s = ""
                                    }!p && d.isLocal && !d.crossDomain ? p = t.text ? 200 : 404 : 1223 === p && (p = 204)
                                }
                        } catch (y) {
                            l || g(-1, y)
                        }
                        t && g(p, s, t, r)
                    };
                    d.async ? 4 === m.readyState ? setTimeout(e, 0) : (n = ++Md, vb && (ra || (ra = {}, f(b).unload(vb)), ra[n] = e), m.onreadystatechange = e) : e()
                },
                abort: function() {
                    e && e(0, 1)
                }
            }
        }
    });
    var Ba, Xa, Nd = /^(?:toggle|show|hide)$/,
        Od = RegExp("^(?:([-+])=|)(" + Fa + ")([a-z%]*)$", "i"),
        Pd = /queueHooks$/,
        Ca = [
            function(b, c, d) {
                var e, l, g, n, p, m, s = this,
                    r = b.style,
                    t = {},
                    v = [],
                    A = b.nodeType && E(b);
                d.queue ||
                    (p = f._queueHooks(b, "fx"), null == p.unqueued && (p.unqueued = 0, m = p.empty.fire, p.empty.fire = function() {
                        p.unqueued || m()
                    }), p.unqueued++, s.always(function() {
                        s.always(function() {
                            p.unqueued--;
                            f.queue(b, "fx").length || p.empty.fire()
                        })
                    }));
                1 === b.nodeType && ("height" in c || "width" in c) && (d.overflow = [r.overflow, r.overflowX, r.overflowY], "inline" === f.css(b, "display") && "none" === f.css(b, "float") && (!f.support.inlineBlockNeedsLayout || "inline" === P(b.nodeName) ? r.display = "inline-block" : r.zoom = 1));
                d.overflow && (r.overflow = "hidden",
                    f.support.shrinkWrapBlocks || s.done(function() {
                        r.overflow = d.overflow[0];
                        r.overflowX = d.overflow[1];
                        r.overflowY = d.overflow[2]
                    }));
                for (e in c) l = c[e], Nd.exec(l) && (delete c[e], l !== (A ? "hide" : "show") && v.push(e));
                if (l = v.length) {
                    g = f._data(b, "fxshow") || f._data(b, "fxshow", {});
                    A ? f(b).show() : s.done(function() {
                        f(b).hide()
                    });
                    s.done(function() {
                        var c;
                        f.removeData(b, "fxshow", !0);
                        for (c in t) f.style(b, c, t[c])
                    });
                    for (e = 0; e < l; e++) c = v[e], n = s.createTween(c, A ? g[c] : 0), t[c] = g[c] || f.style(b, c), c in g || (g[c] = n.start, A && (n.end = n.start,
                        n.start = "width" === c || "height" === c ? 1 : 0))
                }
            }
        ],
        ua = {
            "*": [
                function(b, c) {
                    var d, e, l = this.createTween(b, c),
                        g = Od.exec(c),
                        n = l.cur(),
                        p = +n || 0,
                        m = 1,
                        s = 20;
                    if (g) {
                        d = +g[2];
                        e = g[3] || (f.cssNumber[b] ? "" : "px");
                        if ("px" !== e && p) {
                            p = f.css(l.elem, b, !0) || d || 1;
                            do m = m || ".5", p /= m, f.style(l.elem, b, p + e); while (m !== (m = l.cur() / n) && 1 !== m && --s)
                        }
                        l.unit = e;
                        l.start = p;
                        l.end = g[1] ? p + (g[1] + 1) * d : d
                    }
                    return l
                }
            ]
        };
    f.Animation = f.extend(Cb, {
        tweener: function(b, c) {
            f.isFunction(b) ? (c = b, b = ["*"]) : b = b.split(" ");
            for (var d, e = 0, l = b.length; e < l; e++) d = b[e], ua[d] = ua[d] || [], ua[d].unshift(c)
        },
        prefilter: function(b, c) {
            c ? Ca.unshift(b) : Ca.push(b)
        }
    });
    f.Tween = S;
    S.prototype = {
        constructor: S,
        init: function(b, c, d, e, l, g) {
            this.elem = b;
            this.prop = d;
            this.easing = l || "swing";
            this.options = c;
            this.start = this.now = this.cur();
            this.end = e;
            this.unit = g || (f.cssNumber[d] ? "" : "px")
        },
        cur: function() {
            var b = S.propHooks[this.prop];
            return b && b.get ? b.get(this) : S.propHooks._default.get(this)
        },
        run: function(b) {
            var c, d = S.propHooks[this.prop];
            return this.options.duration ? this.pos = c = f.easing[this.easing](b, this.options.duration *
                b, 0, 1, this.options.duration) : this.pos = c = b, this.now = (this.end - this.start) * c + this.start, this.options.step && this.options.step.call(this.elem, this.now, this), d && d.set ? d.set(this) : S.propHooks._default.set(this), this
        }
    };
    S.prototype.init.prototype = S.prototype;
    S.propHooks = {
        _default: {
            get: function(b) {
                var c;
                return null == b.elem[b.prop] || b.elem.style && null != b.elem.style[b.prop] ? (c = f.css(b.elem, b.prop, !1, ""), !c || "auto" === c ? 0 : c) : b.elem[b.prop]
            },
            set: function(b) {
                f.fx.step[b.prop] ? f.fx.step[b.prop](b) : b.elem.style &&
                    (null != b.elem.style[f.cssProps[b.prop]] || f.cssHooks[b.prop]) ? f.style(b.elem, b.prop, b.now + b.unit) : b.elem[b.prop] = b.now
            }
        }
    };
    S.propHooks.scrollTop = S.propHooks.scrollLeft = {
        set: function(b) {
            b.elem.nodeType && b.elem.parentNode && (b.elem[b.prop] = b.now)
        }
    };
    f.each(["toggle", "show", "hide"], function(b, c) {
        var d = f.fn[c];
        f.fn[c] = function(e, l, g) {
            return null == e || "boolean" == typeof e || !b && f.isFunction(e) && f.isFunction(l) ? d.apply(this, arguments) : this.animate(Da(c, !0), e, l, g)
        }
    });
    f.fn.extend({
        fadeTo: function(b, c, d, f) {
            return this.filter(E).css("opacity",
                0).show().end().animate({
                opacity: c
            }, b, d, f)
        },
        animate: function(b, c, d, e) {
            var l = f.isEmptyObject(b),
                g = f.speed(c, d, e);
            c = function() {
                var c = Cb(this, f.extend({}, b), g);
                l && c.stop(!0)
            };
            return l || !1 === g.queue ? this.each(c) : this.queue(g.queue, c)
        },
        stop: function(b, d, e) {
            var l = function(b) {
                var c = b.stop;
                delete b.stop;
                c(e)
            };
            return "string" != typeof b && (e = d, d = b, b = c), d && !1 !== b && this.queue(b || "fx", []), this.each(function() {
                var c = !0,
                    d = null != b && b + "queueHooks",
                    g = f.timers,
                    j = f._data(this);
                if (d) j[d] && j[d].stop && l(j[d]);
                else
                    for (d in j) j[d] &&
                        j[d].stop && Pd.test(d) && l(j[d]);
                for (d = g.length; d--;) g[d].elem === this && (null == b || g[d].queue === b) && (g[d].anim.stop(e), c = !1, g.splice(d, 1));
                (c || !e) && f.dequeue(this, b)
            })
        }
    });
    f.each({
        slideDown: Da("show"),
        slideUp: Da("hide"),
        slideToggle: Da("toggle"),
        fadeIn: {
            opacity: "show"
        },
        fadeOut: {
            opacity: "hide"
        },
        fadeToggle: {
            opacity: "toggle"
        }
    }, function(b, c) {
        f.fn[b] = function(b, d, f) {
            return this.animate(c, b, d, f)
        }
    });
    f.speed = function(b, c, d) {
        var e = b && "object" == typeof b ? f.extend({}, b) : {
            complete: d || !d && c || f.isFunction(b) && b,
            duration: b,
            easing: d && c || c && !f.isFunction(c) && c
        };
        e.duration = f.fx.off ? 0 : "number" == typeof e.duration ? e.duration : e.duration in f.fx.speeds ? f.fx.speeds[e.duration] : f.fx.speeds._default;
        if (null == e.queue || !0 === e.queue) e.queue = "fx";
        return e.old = e.complete, e.complete = function() {
            f.isFunction(e.old) && e.old.call(this);
            e.queue && f.dequeue(this, e.queue)
        }, e
    };
    f.easing = {
        linear: function(b) {
            return b
        },
        swing: function(b) {
            return 0.5 - Math.cos(b * Math.PI) / 2
        }
    };
    f.timers = [];
    f.fx = S.prototype.init;
    f.fx.tick = function() {
        for (var b, c = f.timers,
            d = 0; d < c.length; d++) b = c[d], !b() && c[d] === b && c.splice(d--, 1);
        c.length || f.fx.stop()
    };
    f.fx.timer = function(b) {
        b() && f.timers.push(b) && !Xa && (Xa = setInterval(f.fx.tick, f.fx.interval))
    };
    f.fx.interval = 13;
    f.fx.stop = function() {
        clearInterval(Xa);
        Xa = null
    };
    f.fx.speeds = {
        slow: 600,
        fast: 200,
        _default: 400
    };
    f.fx.step = {};
    f.expr && f.expr.filters && (f.expr.filters.animated = function(b) {
        return f.grep(f.timers, function(c) {
            return b === c.elem
        }).length
    });
    var sc = /^(?:body|html)$/i;
    f.fn.offset = function(b) {
        if (arguments.length) return b ===
            c ? this : this.each(function(c) {
                f.offset.setOffset(this, b, c)
            });
        var d, e, l, g, n, p, m, s = {
                top: 0,
                left: 0
            },
            r = this[0],
            t = r && r.ownerDocument;
        if (t) return (e = t.body) === r ? f.offset.bodyOffset(r) : (d = t.documentElement, f.contains(d, r) ? ("undefined" != typeof r.getBoundingClientRect && (s = r.getBoundingClientRect()), l = Db(t), g = d.clientTop || e.clientTop || 0, n = d.clientLeft || e.clientLeft || 0, p = l.pageYOffset || d.scrollTop, m = l.pageXOffset || d.scrollLeft, {
            top: s.top + p - g,
            left: s.left + m - n
        }) : s)
    };
    f.offset = {
        bodyOffset: function(b) {
            var c = b.offsetTop,
                d = b.offsetLeft;
            return f.support.doesNotIncludeMarginInBodyOffset && (c += parseFloat(f.css(b, "marginTop")) || 0, d += parseFloat(f.css(b, "marginLeft")) || 0), {
                top: c,
                left: d
            }
        },
        setOffset: function(b, c, d) {
            var e = f.css(b, "position");
            "static" === e && (b.style.position = "relative");
            var l = f(b),
                g = l.offset(),
                n = f.css(b, "top"),
                p = f.css(b, "left"),
                m = {},
                s = {},
                r, t;
            ("absolute" === e || "fixed" === e) && -1 < f.inArray("auto", [n, p]) ? (s = l.position(), r = s.top, t = s.left) : (r = parseFloat(n) || 0, t = parseFloat(p) || 0);
            f.isFunction(c) && (c = c.call(b, d, g));
            null !=
                c.top && (m.top = c.top - g.top + r);
            null != c.left && (m.left = c.left - g.left + t);
            "using" in c ? c.using.call(b, m) : l.css(m)
        }
    };
    f.fn.extend({
        position: function() {
            if (this[0]) {
                var b = this[0],
                    c = this.offsetParent(),
                    d = this.offset(),
                    e = sc.test(c[0].nodeName) ? {
                        top: 0,
                        left: 0
                    } : c.offset();
                return d.top -= parseFloat(f.css(b, "marginTop")) || 0, d.left -= parseFloat(f.css(b, "marginLeft")) || 0, e.top += parseFloat(f.css(c[0], "borderTopWidth")) || 0, e.left += parseFloat(f.css(c[0], "borderLeftWidth")) || 0, {
                    top: d.top - e.top,
                    left: d.left - e.left
                }
            }
        },
        offsetParent: function() {
            return this.map(function() {
                for (var b =
                    this.offsetParent || D.body; b && !sc.test(b.nodeName) && "static" === f.css(b, "position");) b = b.offsetParent;
                return b || D.body
            })
        }
    });
    f.each({
        scrollLeft: "pageXOffset",
        scrollTop: "pageYOffset"
    }, function(b, d) {
        var e = /Y/.test(d);
        f.fn[b] = function(l) {
            return f.access(this, function(b, l, g) {
                var n = Db(b);
                if (g === c) return n ? d in n ? n[d] : n.document.documentElement[l] : b[l];
                n ? n.scrollTo(e ? f(n).scrollLeft() : g, e ? g : f(n).scrollTop()) : b[l] = g
            }, b, l, arguments.length, null)
        }
    });
    f.each({
        Height: "height",
        Width: "width"
    }, function(b, d) {
        f.each({
            padding: "inner" +
                b,
            content: d,
            "": "outer" + b
        }, function(e, l) {
            f.fn[l] = function(l, g) {
                var n = arguments.length && (e || "boolean" != typeof l),
                    p = e || (!0 === l || !0 === g ? "margin" : "border");
                return f.access(this, function(d, e, l) {
                    var g;
                    return f.isWindow(d) ? d.document.documentElement["client" + b] : 9 === d.nodeType ? (g = d.documentElement, Math.max(d.body["scroll" + b], g["scroll" + b], d.body["offset" + b], g["offset" + b], g["client" + b])) : l === c ? f.css(d, e, l, p) : f.style(d, e, l, p)
                }, d, n ? l : c, n, null)
            }
        })
    });
    b.jQuery = b.$ = f;
    "function" == typeof define && define.amd && define.amd.jQuery &&
        define("jquery", [], function() {
            return f
        })
})(window);
var portraitMode = !0,
    mobilePortraitWidth = 480,
    mobilePortraitHeight = 640,
    mobileLandscapeWidth = 640,
    mobileLandscapeHeight = 480,
    mobileWidth = portraitMode ? mobilePortraitWidth : mobileLandscapeWidth,
    mobileHeight = portraitMode ? mobilePortraitHeight : mobileLandscapeHeight,
    desktopWidth = 480,
    desktopHeight = 640,
    w, h, multiplier, destW, destH, dynamicClickableEntityDivs = {},
    coreDivsToResize = ["game", "play", "orientate"],
    advancedDivsToResize = {/*
        MobileAdInGamePreroll: {
            "box-width": _SETTINGS.Ad.Mobile.Preroll.Width + 2,
            "box-height": _SETTINGS.Ad.Mobile.Preroll.Height +
                20
        },
        MobileAdInGameEnd: {
            "box-width": _SETTINGS.Ad.Mobile.End.Width + 2,
            "box-height": _SETTINGS.Ad.Mobile.End.Height + 20
        },
        MobileAdInGamePreroll2: {
            "box-width": _SETTINGS.Ad.Mobile.Preroll.Width + 2,
            "box-height": _SETTINGS.Ad.Mobile.Preroll.Height + 20
        },
        MobileAdInGameEnd2: {
            "box-width": _SETTINGS.Ad.Mobile.End.Width + 2,
            "box-height": _SETTINGS.Ad.Mobile.End.Height + 20
        },
        MobileAdInGamePreroll3: {
            "box-width": _SETTINGS.Ad.Mobile.Preroll.Width + 2,
            "box-height": _SETTINGS.Ad.Mobile.Preroll.Height + 20
        },
        MobileAdInGameEnd3: {
            "box-width": _SETTINGS.Ad.Mobile.End.Width +
                2,
            "box-height": _SETTINGS.Ad.Mobile.End.Height + 20
        }*/
    };

function adjustLayers(b) {
    for (i = 0; i < coreDivsToResize.length; i++) ig.ua.mobile ? ($("#" + coreDivsToResize[i]).width(w), $("#" + coreDivsToResize[i]).height(h)) : ($("#" + coreDivsToResize[i]).width(destW), $("#" + coreDivsToResize[i]).height(destH), $("#" + coreDivsToResize[i]).css("left", b ? 0 : w / 2 - destW / 2));
    for (key in advancedDivsToResize) try {
        $("#" + key).width(w), $("#" + key).height(h), $("#" + key + "-Box").css("left", (w - advancedDivsToResize[key]["box-width"]) / 2), $("#" + key + "-Box").css("top", (h - advancedDivsToResize[key]["box-height"]) /
            2)
    } catch (c) {
        console.log(c)
    }
    $("#ajaxbar").width(w);
    $("#ajaxbar").height(h)
}
var minHeight = 99999999;

function sizeHandler() {
    if ($("#game")) {
        w = window.innerWidth;
        h = window.innerHeight;
        ig.ua.mobile ? (multiplier = Math.min(h / mobileHeight, w / mobileWidth), destW = mobileWidth * multiplier, destH = mobileHeight * multiplier) : (multiplier = Math.min(h / desktopHeight, w / desktopWidth), destW = desktopWidth * multiplier, destH = desktopHeight * multiplier);
        widthRatio = window.innerWidth / mobileWidth;
        heightRatio = window.innerHeight / mobileHeight;
        adjustLayers();
        window.scrollTo(0, 1);
        for (var b = navigator.userAgent.split(" "), c = 0; c < b.length; c++) b[c].substr(0,
            8);
        navigator.userAgent.indexOf("wv");
        navigator.userAgent.indexOf("SamsungBrowser")
    }
}

function orientationHandler() {
    console.log("changing orientation ...");
    ig.ua.mobile && ((portraitMode ? window.innerHeight < window.innerWidth : window.innerHeight > window.innerWidth) ? ($("#orientate").show(), $("#game").hide()) : ($("#orientate").hide(), $("#game").show()));
    sizeHandler()
}

function fixSamsungHandler() {
    ig.ua.android && !(4.2 > parseFloat(navigator.userAgent.slice(navigator.userAgent.indexOf("Android") + 8, navigator.userAgent.indexOf("Android") + 11))) && (!(0 > navigator.userAgent.indexOf("GT")) && !(0 < navigator.userAgent.indexOf("Chrome")) && !(0 < navigator.userAgent.indexOf("Firefox"))) && (document.addEventListener("touchstart", function(b) {
        b.preventDefault();
        return !1
    }, !1), document.addEventListener("touchmove", function(b) {
        b.preventDefault();
        return !1
    }, !1), document.addEventListener("touchend",
        function(b) {
            b.preventDefault();
            return !1
        }, !1))
}
window.addEventListener("resize", function() {
    orientationHandler()
}, !1);
window.addEventListener("orientationchange", function() {
    orientationHandler()
}, !1);
document.ontouchmove = function(b) {
    window.scrollTo(0, 1);
    b.preventDefault()
};

function getInternetExplorerVersion() {
    var b = -1;
    "Microsoft Internet Explorer" == navigator.appName && null != /MSIE ([0-9]{1,}[.0-9]{0,})/.exec(navigator.userAgent) && (b = parseFloat(RegExp.$1));
    return b
}
var ie = getInternetExplorerVersion();

function getQueryVariable(b) {
    for (var c = window.location.search.substring(1).split("&"), d = 0; d < c.length; d++) {
        var e = c[d].split("=");
        if (decodeURIComponent(e[0]) == b) return decodeURIComponent(e[1])
    }
}
this.jukebox = {};
jukebox.Player = function(b, c) {
    this.id = ++jukebox.__jukeboxId;
    this.origin = c || null;
    this.settings = {};
    for (var d in this.defaults) this.settings[d] = this.defaults[d];
    if ("[object Object]" === Object.prototype.toString.call(b))
        for (var e in b) this.settings[e] = b[e];
    "[object Function]" === Object.prototype.toString.call(jukebox.Manager) && (jukebox.Manager = new jukebox.Manager);
    this.resource = this.isPlaying = null;
    this.resource = "[object Object]" === Object.prototype.toString.call(jukebox.Manager) ? jukebox.Manager.getPlayableResource(this.settings.resources) :
        this.settings.resources[0] || null;
    if (null === this.resource) throw "Your browser can't playback the given resources - or you have missed to include jukebox.Manager";
    this.__init();
    return this
};
jukebox.__jukeboxId = 0;
jukebox.Player.prototype = {
    defaults: {
        resources: [],
        autoplay: !1,
        spritemap: {},
        flashMediaElement: "./swf/FlashMediaElement.swf",
        timeout: 1E3
    },
    __addToManager: function() {
        !0 !== this.__wasAddedToManager && (jukebox.Manager.add(this), this.__wasAddedToManager = !0)
    },
    __init: function() {
        var b = this,
            c = this.settings,
            d = {},
            e;
        jukebox.Manager && void 0 !== jukebox.Manager.features && (d = jukebox.Manager.features);
        if (!0 === d.html5audio) {
            this.context = new Audio;
            this.context.src = this.resource;
            if (null === this.origin) {
                var g = function(c) {
                    b.__addToManager(c)
                };
                this.context.addEventListener("canplaythrough", g, !0);
                window.setTimeout(function() {
                    b.context.removeEventListener("canplaythrough", g, !0);
                    g("timeout")
                }, c.timeout)
            }
            this.context.autobuffer = !0;
            this.context.preload = !0;
            for (e in this.HTML5API) this[e] = this.HTML5API[e];
            1 < d.channels ? !0 === c.autoplay ? this.context.autoplay = !0 : void 0 !== c.spritemap[c.autoplay] && this.play(c.autoplay) : 1 === d.channels && void 0 !== c.spritemap[c.autoplay] && (this.backgroundMusic = c.spritemap[c.autoplay], this.backgroundMusic.started = Date.now ?
                Date.now() : +new Date, this.play(c.autoplay));
            1 == d.channels && !0 !== c.canPlayBackground && (window.addEventListener("pagehide", function() {
                null !== b.isPlaying && (b.pause(), b.__wasAutoPaused = !0)
            }), window.addEventListener("pageshow", function() {
                b.__wasAutoPaused && (b.resume(), delete b._wasAutoPaused)
            }))
        } else if (!0 === d.flashaudio) {
            for (e in this.FLASHAPI) this[e] = this.FLASHAPI[e];
            d = ["id=jukebox-flashstream-" + this.id, "autoplay=" + c.autoplay, "file=" + window.encodeURIComponent(this.resource)];
            this.__initFlashContext(d);
            !0 === c.autoplay ? this.play(0) : c.spritemap[c.autoplay] && this.play(c.autoplay)
        } else throw "Your Browser does not support Flash Audio or HTML5 Audio.";
    },
    __initFlashContext: function(b) {
        var c, d = this.settings.flashMediaElement,
            e, g = {
                flashvars: b.join("&"),
                quality: "high",
                bgcolor: "#000000",
                wmode: "transparent",
                allowscriptaccess: "always",
                allowfullscreen: "true"
            };
        if (navigator.userAgent.match(/MSIE/)) {
            c = document.createElement("div");
            document.getElementsByTagName("body")[0].appendChild(c);
            var m = document.createElement("object");
            m.id = "jukebox-flashstream-" + this.id;
            m.setAttribute("type", "application/x-shockwave-flash");
            m.setAttribute("classid", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000");
            m.setAttribute("width", "0");
            m.setAttribute("height", "0");
            g.movie = d + "?x=" + (Date.now ? Date.now() : +new Date);
            g.flashvars = b.join("&amp;");
            for (e in g) b = document.createElement("param"), b.setAttribute("name", e), b.setAttribute("value", g[e]), m.appendChild(b);
            c.outerHTML = m.outerHTML;
            this.context = document.getElementById("jukebox-flashstream-" + this.id)
        } else {
            c =
                document.createElement("embed");
            c.id = "jukebox-flashstream-" + this.id;
            c.setAttribute("type", "application/x-shockwave-flash");
            c.setAttribute("width", "100");
            c.setAttribute("height", "100");
            g.play = !1;
            g.loop = !1;
            g.src = d + "?x=" + (Date.now ? Date.now() : +new Date);
            for (e in g) c.setAttribute(e, g[e]);
            document.getElementsByTagName("body")[0].appendChild(c);
            this.context = c
        }
    },
    backgroundHackForiOS: function() {
        if (void 0 !== this.backgroundMusic) {
            var b = Date.now ? Date.now() : +new Date;
            void 0 === this.backgroundMusic.started ? (this.backgroundMusic.started =
                b, this.setCurrentTime(this.backgroundMusic.start)) : (this.backgroundMusic.lastPointer = (b - this.backgroundMusic.started) / 1E3 % (this.backgroundMusic.end - this.backgroundMusic.start) + this.backgroundMusic.start, this.play(this.backgroundMusic.lastPointer))
        }
    },
    play: function(b, c) {
        if (null !== this.isPlaying && !0 !== c) void 0 !== jukebox.Manager && jukebox.Manager.addToQueue(b, this.id);
        else {
            var d = this.settings.spritemap,
                e;
            if (void 0 !== d[b]) e = d[b].start;
            else if ("number" === typeof b) {
                e = b;
                for (var g in d)
                    if (e >= d[g].start && e <=
                        d[g].end) {
                        b = g;
                        break
                    }
            }
            void 0 !== e && "[object Object]" === Object.prototype.toString.call(d[b]) && (this.isPlaying = this.settings.spritemap[b], this.context.play && this.context.play(), this.wasReady = this.setCurrentTime(e))
        }
    },
    stop: function() {
        this.__lastPosition = 0;
        this.isPlaying = null;
        this.backgroundMusic ? this.backgroundHackForiOS() : this.context.pause();
        return !0
    },
    pause: function() {
        this.isPlaying = null;
        this.__lastPosition = this.getCurrentTime();
        this.context.pause();
        return this.__lastPosition
    },
    resume: function(b) {
        b = "number" ===
            typeof b ? b : this.__lastPosition;
        if (null !== b) return this.play(b), this.__lastPosition = null, !0;
        this.context.play();
        return !1
    },
    HTML5API: {
        getVolume: function() {
            return this.context.volume || 1
        },
        setVolume: function(b) {
            this.context.volume = b;
            return 1E-4 > Math.abs(this.context.volume - b) ? !0 : !1
        },
        getCurrentTime: function() {
            return this.context.currentTime || 0
        },
        setCurrentTime: function(b) {
            try {
                return this.context.currentTime = b, !0
            } catch (c) {
                return !1
            }
        }
    },
    FLASHAPI: {
        getVolume: function() {
            return this.context && "function" === typeof this.context.getVolume ?
                this.context.getVolume() : 1
        },
        setVolume: function(b) {
            return this.context && "function" === typeof this.context.setVolume ? (this.context.setVolume(b), !0) : !1
        },
        getCurrentTime: function() {
            return this.context && "function" === typeof this.context.getCurrentTime ? this.context.getCurrentTime() : 0
        },
        setCurrentTime: function(b) {
            return this.context && "function" === typeof this.context.setCurrentTime ? this.context.setCurrentTime(b) : !1
        }
    }
};
if (void 0 === this.jukebox) throw "jukebox.Manager requires jukebox.Player (Player.js) to run properly.";
jukebox.Manager = function(b) {
    this.features = {};
    this.codecs = {};
    this.__players = {};
    this.__playersLength = 0;
    this.__clones = {};
    this.__queue = [];
    this.settings = {};
    for (var c in this.defaults) this.settings[c] = this.defaults[c];
    if ("[object Object]" === Object.prototype.toString.call(b))
        for (var d in b) this.settings[d] = b[d];
    this.__detectFeatures();
    jukebox.Manager.__initialized = !1 === this.settings.useGameLoop ? window.setInterval(function() {
        jukebox.Manager.loop()
    }, 20) : !0
};
jukebox.Manager.prototype = {
    defaults: {
        useFlash: !1,
        useGameLoop: !1
    },
    __detectFeatures: function() {
        var b = window.Audio && new Audio;
        if (b && b.canPlayType && !1 === this.settings.useFlash) {
            for (var c = [{
                    e: "3gp",
                    m: ["audio/3gpp", "audio/amr"]
                }, {
                    e: "aac",
                    m: ["audio/aac", "audio/aacp"]
                }, {
                    e: "amr",
                    m: ["audio/amr", "audio/3gpp"]
                }, {
                    e: "caf",
                    m: ["audio/IMA-ADPCM", "audio/x-adpcm", 'audio/x-aiff; codecs="IMA-ADPCM, ADPCM"']
                }, {
                    e: "m4a",
                    m: 'audio/mp4{audio/mp4; codecs="mp4a.40.2,avc1.42E01E"{audio/mpeg4{audio/mpeg4-generic{audio/mp4a-latm{audio/MP4A-LATM{audio/x-m4a'.split("{")
                }, {
                    e: "mp3",
                    m: ["audio/mp3", "audio/mpeg", 'audio/mpeg; codecs="mp3"', "audio/MPA", "audio/mpa-robust"]
                }, {
                    e: "mpga",
                    m: ["audio/MPA", "audio/mpa-robust", "audio/mpeg", "video/mpeg"]
                }, {
                    e: "mp4",
                    m: ["audio/mp4", "video/mp4"]
                }, {
                    e: "ogg",
                    m: ["application/ogg", "audio/ogg", 'audio/ogg; codecs="theora, vorbis"', "video/ogg", 'video/ogg; codecs="theora, vorbis"']
                }, {
                    e: "wav",
                    m: ["audio/wave", "audio/wav", 'audio/wav; codecs="1"', "audio/x-wav", "audio/x-pn-wav"]
                }, {
                    e: "webm",
                    m: ["audio/webm", 'audio/webm; codecs="vorbis"', "video/webm"]
                }],
                d, e, g = 0, m = c.length; g < m; g++)
                if (e = c[g].e, c[g].m.length && "object" === typeof c[g].m)
                    for (var y = 0, s = c[g].m.length; y < s; y++)
                        if (d = c[g].m[y], "" !== b.canPlayType(d)) {
                            this.codecs[e] = d;
                            break
                        } else this.codecs[e] || (this.codecs[e] = !1);
            this.features.html5audio = !(!this.codecs.mp3 && !this.codecs.ogg && !this.codecs.webm && !this.codecs.wav);
            this.features.channels = 8;
            b.volume = 0.1337;
            this.features.volume = !!(1E-4 > Math.abs(b.volume - 0.1337));
            navigator.userAgent.match(/iPhone|iPod|iPad/i) && (this.features.channels = 1)
        }
        this.features.flashaudio = !!navigator.mimeTypes["application/x-shockwave-flash"] || !!navigator.plugins["Shockwave Flash"] || !1;
        if (window.ActiveXObject) try {
            new ActiveXObject("ShockwaveFlash.ShockwaveFlash.10"), this.features.flashaudio = !0
        } catch (t) {}!0 === this.settings.useFlash && (this.features.flashaudio = !0);
        !0 === this.features.flashaudio && !this.features.html5audio && (this.codecs.mp3 = "audio/mp3", this.codecs.mpga = "audio/mpeg", this.codecs.mp4 = "audio/mp4", this.codecs.m4a = "audio/mp4", this.codecs["3gp"] = "audio/3gpp", this.codecs.amr = "audio/amr",
            this.features.volume = !0, this.features.channels = 1)
    },
    __getPlayerById: function(b) {
        return this.__players && void 0 !== this.__players[b] ? this.__players[b] : null
    },
    __getClone: function(b, c) {
        for (var d in this.__clones) {
            var e = this.__clones[d];
            if (null === e.isPlaying && e.origin === b) return e
        }
        if ("[object Object]" === Object.prototype.toString.call(c)) {
            d = {};
            for (var g in c) d[g] = c[g];
            d.autoplay = !1;
            g = new jukebox.Player(d, b);
            g.isClone = !0;
            g.wasReady = !1;
            return this.__clones[g.id] = g
        }
        return null
    },
    loop: function() {
        if (0 !== this.__playersLength)
            if (this.__queue.length &&
                this.__playersLength < this.features.channels) {
                var b = this.__queue[0],
                    c = this.__getPlayerById(b.origin);
                if (null !== c) {
                    var d = this.__getClone(b.origin, c.settings);
                    null !== d && (!0 === this.features.volume && (c = this.__players[b.origin]) && d.setVolume(c.getVolume()), this.add(d), d.play(b.pointer, !0))
                }
                this.__queue.splice(0, 1)
            } else
                for (d in this.__queue.length && 1 === this.features.channels && (b = this.__queue[0], c = this.__getPlayerById(b.origin), null !== c && c.play(b.pointer, !0), this.__queue.splice(0, 1)), this.__players) b = this.__players[d],
                    c = b.getCurrentTime() || 0, b.isPlaying && !1 === b.wasReady ? b.wasReady = b.setCurrentTime(b.isPlaying.start) : b.isPlaying && !0 === b.wasReady ? c > b.isPlaying.end && (!0 === b.isPlaying.loop ? b.play(b.isPlaying.start, !0) : b.stop()) : b.isClone && null === b.isPlaying ? this.remove(b) : void 0 !== b.backgroundMusic && null === b.isPlaying && c > b.backgroundMusic.end && b.backgroundHackForiOS()
    },
    getPlayableResource: function(b) {
        "[object Array]" !== Object.prototype.toString.call(b) && (b = [b]);
        for (var c = 0, d = b.length; c < d; c++) {
            var e = b[c],
                g = e.match(/\.([^\.]*)$/)[1];
            if (g && this.codecs[g]) return e
        }
        return null
    },
    add: function(b) {
        return b instanceof jukebox.Player && void 0 === this.__players[b.id] ? (this.__playersLength++, this.__players[b.id] = b, !0) : !1
    },
    remove: function(b) {
        return b instanceof jukebox.Player && void 0 !== this.__players[b.id] ? (this.__playersLength--, delete this.__players[b.id], !0) : !1
    },
    addToQueue: function(b, c) {
        return ("string" === typeof b || "number" === typeof b) && void 0 !== this.__players[c] ? (this.__queue.push({
            pointer: b,
            origin: c
        }), !0) : !1
    }
};
(function() {
    var b = {},
        c = null,
        d = !0,
        e = !1;
    if ("undefined" !== typeof AudioContext) c = new AudioContext;
    else if ("undefined" !== typeof webkitAudioContext) c = new webkitAudioContext;
    else if ("undefined" !== typeof Audio) {
        d = !1;
        try {
            new Audio
        } catch (g) {
            e = !0
        }
    } else d = !1, e = !0; if (d) {
        var m = "undefined" === typeof c.createGain ? c.createGainNode() : c.createGain();
        m.gain.value = 1;
        m.connect(c.destination)
    }
    var y = function() {
        this._volume = 1;
        this._muted = !1;
        this.usingWebAudio = d;
        this.noAudio = e;
        this._howls = []
    };
    y.prototype = {
        volume: function(b) {
            b =
                parseFloat(b);
            if (0 <= b && 1 >= b) {
                this._volume = b;
                d && (m.gain.value = b);
                for (var c in this._howls)
                    if (this._howls.hasOwnProperty(c) && !1 === this._howls[c]._webAudio)
                        for (b = 0; b < this._howls[c]._audioNode.length; b++) this._howls[c]._audioNode[b].volume = this._howls[c]._volume * this._volume;
                return this
            }
            return d ? m.gain.value : this._volume
        },
        mute: function() {
            this._setMuted(!0);
            return this
        },
        unmute: function() {
            this._setMuted(!1);
            return this
        },
        _setMuted: function(b) {
            this._muted = b;
            d && (m.gain.value = b ? 0 : this._volume);
            for (var c in this._howls)
                if (this._howls.hasOwnProperty(c) &&
                    !1 === this._howls[c]._webAudio)
                    for (var e = 0; e < this._howls[c]._audioNode.length; e++) this._howls[c]._audioNode[e].muted = b
        }
    };
    var s = new y,
        y = null;
    if (!e) var y = new Audio,
        t = {
            mp3: !!y.canPlayType("audio/mpeg;").replace(/^no$/, ""),
            opus: !!y.canPlayType('audio/ogg; codecs="opus"').replace(/^no$/, ""),
            ogg: !!y.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/, ""),
            wav: !!y.canPlayType('audio/wav; codecs="1"').replace(/^no$/, ""),
            m4a: !!(y.canPlayType("audio/x-m4a;") || y.canPlayType("audio/aac;")).replace(/^no$/,
                ""),
            mp4: !!(y.canPlayType("audio/x-mp4;") || y.canPlayType("audio/aac;")).replace(/^no$/, ""),
            weba: !!y.canPlayType('audio/webm; codecs="vorbis"').replace(/^no$/, "")
        };
    var v = function(b) {
        this._autoplay = b.autoplay || !1;
        this._buffer = b.buffer || !1;
        this._duration = b.duration || 0;
        this._format = b.format || null;
        this._loop = b.loop || !1;
        this._loaded = !1;
        this._sprite = b.sprite || {};
        this._src = b.src || "";
        this._pos3d = b.pos3d || [0, 0, -0.5];
        this._volume = void 0 !== b.volume ? b.volume : 1;
        this._urls = b.urls || [];
        this._rate = b.rate || 1;
        this._onload = [b.onload || function() {}];
        this._onloaderror = [b.onloaderror || function() {}];
        this._onend = [b.onend || function() {}];
        this._onpause = [b.onpause || function() {}];
        this._onplay = [b.onplay || function() {}];
        this._onendTimer = [];
        this._webAudio = d && !this._buffer;
        this._audioNode = [];
        this._webAudio && this._setupAudioNode();
        s._howls.push(this);
        this.load()
    };
    v.prototype = {
        load: function() {
            var d = this,
                g = null;
            if (!e) {
                for (var p = 0; p < d._urls.length; p++) {
                    var m, v;
                    if (d._format) m = d._format;
                    else if (v = d._urls[p].toLowerCase().split("?")[0], m =
                        (m = v.match(/.+\.([^?]+)(\?|$)/)) && 2 <= m.length ? m : v.match(/data\:audio\/([^?]+);/)) m = m[1];
                    else {
                        d.on("loaderror");
                        return
                    } if (t[m]) {
                        g = d._urls[p];
                        break
                    }
                }
                if (g) {
                    d._src = g;
                    if (d._webAudio) {
                        var y = g;
                        if (y in b) d._duration = b[y].duration, r(d);
                        else {
                            var G = new XMLHttpRequest;
                            G.open("GET", y, !0);
                            G.responseType = "arraybuffer";
                            G.onload = function() {
                                c.decodeAudioData(G.response, function(c) {
                                    c && (b[y] = c, r(d, c))
                                }, function() {
                                    d.on("loaderror")
                                })
                            };
                            G.onerror = function() {
                                d._webAudio && (d._buffer = !0, d._webAudio = !1, d._audioNode = [], delete d._gainNode,
                                    d.load())
                            };
                            try {
                                // G.send()
                            } catch (Ya) {
                                G.onerror()
                            }
                        }
                    } else {
                        var I = new Audio;
                        d._audioNode.push(I);
                        I.src = g;
                        I._pos = 0;
                        I.preload = "auto";
                        I.volume = s._muted ? 0 : d._volume * s.volume();
                        b[g] = d;
                        var P = function() {
                            d._duration = Math.ceil(10 * I.duration) / 10;
                            0 === Object.getOwnPropertyNames(d._sprite).length && (d._sprite = {
                                _default: [0, 1E3 * d._duration]
                            });
                            d._loaded || (d._loaded = !0, d.on("load"));
                            d._autoplay && d.play();
                            I.removeEventListener("canplaythrough", P, !1)
                        };
                        I.addEventListener("canplaythrough", P, !1);
                        I.load()
                    }
                    return d
                }
            }
            d.on("loaderror")
        },
        urls: function(b) {
            return b ? (this.stop(), this._urls = "string" === typeof b ? [b] : b, this._loaded = !1, this.load(), this) : this._urls
        },
        play: function(d, e) {
            var g = this;
            "function" === typeof d && (e = d);
            if (!d || "function" === typeof d) d = "_default";
            if (!g._loaded) return g.on("load", function() {
                g.play(d, e)
            }), g;
            if (!g._sprite[d]) return "function" === typeof e && e(), g;
            g._inactiveNode(function(m) {
                m._sprite = d;
                var r = 0 < m._pos ? m._pos : g._sprite[d][0] / 1E3,
                    t = g._sprite[d][1] / 1E3 - m._pos,
                    v = !(!g._loop && !g._sprite[d][2]),
                    y = "string" === typeof e ? e :
                    Math.round(Date.now() * Math.random()) + "",
                    I, P = {
                        id: y,
                        sprite: d,
                        loop: v
                    };
                I = setTimeout(function() {
                    !g._webAudio && v && g.stop(P.id, P.timer).play(d, P.id);
                    g._webAudio && !v && (g._nodeById(P.id).paused = !0, g._nodeById(P.id)._pos = 0);
                    !g._webAudio && !v && g.stop(P.id, P.timer);
                    g.on("end", y)
                }, 1E3 * t);
                g._onendTimer.push(I);
                P.timer = g._onendTimer[g._onendTimer.length - 1];
                if (g._webAudio) {
                    I = g._sprite[d][0] / 1E3;
                    var N = g._sprite[d][1] / 1E3;
                    m.id = y;
                    m.paused = !1;
                    I = [v, I, N];
                    N = g._nodeById(y);
                    N.bufferSource = c.createBufferSource();
                    N.bufferSource.buffer =
                        b[g._src];
                    N.bufferSource.connect(N.panner);
                    N.bufferSource.loop = I[0];
                    I[0] && (N.bufferSource.loopStart = I[1], N.bufferSource.loopEnd = I[1] + I[2]);
                    N.bufferSource.playbackRate.value = g._rate;
                    g._playStart = c.currentTime;
                    m.gain.value = g._volume;
                    "undefined" === typeof m.bufferSource.start ? m.bufferSource.noteGrainOn(0, r, t) : m.bufferSource.start(0, r, t)
                } else if (4 === m.readyState) m.id = y, m.currentTime = r, m.muted = s._muted, m.volume = g._volume * s.volume(), setTimeout(function() {
                    m.play()
                }, 0);
                else {
                    g._clearEndTimer(I);
                    var Aa = d,
                        na =
                        e,
                        sa = function() {
                            g.play(Aa, na);
                            m.removeEventListener("canplaythrough", sa, !1)
                        };
                    m.addEventListener("canplaythrough", sa, !1);
                    return g
                }
                g.on("play");
                "function" === typeof e && e(y);
                return g
            });
            return g
        },
        pause: function(b, c) {
            var d = this;
            if (!d._loaded) return d.on("play", function() {
                d.pause(b)
            }), d;
            d._clearEndTimer(c || 0);
            var e = b ? d._nodeById(b) : d._activeNode();
            if (e)
                if (e._pos = d.pos(null, b), d._webAudio) {
                    if (!e.bufferSource || e.paused) return d;
                    e.paused = !0;
                    "undefined" === typeof e.bufferSource.stop ? e.bufferSource.noteOff(0) :
                        e.bufferSource.stop(0)
                } else e.pause();
            d.on("pause");
            return d
        },
        stop: function(b, c) {
            var d = this;
            if (!d._loaded) return d.on("play", function() {
                d.stop(b)
            }), d;
            d._clearEndTimer(c || 0);
            var e = b ? d._nodeById(b) : d._activeNode();
            if (e)
                if (e._pos = 0, d._webAudio) {
                    if (!e.bufferSource || e.paused) return d;
                    e.paused = !0;
                    "undefined" === typeof e.bufferSource.stop ? e.bufferSource.noteOff(0) : e.bufferSource.stop(0)
                } else e.pause(), e.currentTime = 0;
            return d
        },
        mute: function(b) {
            var c = this;
            if (!c._loaded) return c.on("play", function() {
                    c.mute(b)
                }),
                c;
            var d = b ? c._nodeById(b) : c._activeNode();
            d && (c._webAudio ? d.gain.value = 0 : d.volume = 0);
            return c
        },
        unmute: function(b) {
            var c = this;
            if (!c._loaded) return c.on("play", function() {
                c.unmute(b)
            }), c;
            var d = b ? c._nodeById(b) : c._activeNode();
            d && (c._webAudio ? d.gain.value = c._volume : d.volume = c._volume);
            return c
        },
        volume: function(b, c) {
            var d = this;
            b = parseFloat(b);
            if (0 <= b && 1 >= b) {
                d._volume = b;
                if (!d._loaded) return d.on("play", function() {
                    d.volume(b, c)
                }), d;
                var e = c ? d._nodeById(c) : d._activeNode();
                e && (d._webAudio ? e.gain.value = b : e.volume =
                    b * s.volume());
                return d
            }
            return d._volume
        },
        loop: function(b) {
            return "boolean" === typeof b ? (this._loop = b, this) : this._loop
        },
        sprite: function(b) {
            return "object" === typeof b ? (this._sprite = b, this) : this._sprite
        },
        pos: function(b, d) {
            var e = this;
            if (!e._loaded) return e.on("load", function() {
                e.pos(b)
            }), "number" === typeof b ? e : e._pos || 0;
            b = parseFloat(b);
            var g = d ? e._nodeById(d) : e._activeNode();
            if (g) return 0 <= b ? (e.pause(d), g._pos = b, e.play(g._sprite, d), e) : e._webAudio ? g._pos + (c.currentTime - e._playStart) : g.currentTime;
            if (0 <= b) return e;
            for (g = 0; g < e._audioNode.length; g++)
                if (e._audioNode[g].paused && 4 === e._audioNode[g].readyState) return e._webAudio ? e._audioNode[g]._pos : e._audioNode[g].currentTime
        },
        pos3d: function(b, c, d, e) {
            var g = this;
            c = "undefined" === typeof c || !c ? 0 : c;
            d = "undefined" === typeof d || !d ? -0.5 : d;
            if (!g._loaded) return g.on("play", function() {
                g.pos3d(b, c, d, e)
            }), g;
            if (0 <= b || 0 > b) {
                if (g._webAudio) {
                    var m = e ? g._nodeById(e) : g._activeNode();
                    m && (g._pos3d = [b, c, d], m.panner.setPosition(b, c, d))
                }
            } else return g._pos3d;
            return g
        },
        fade: function(b, c, d,
            e, g) {
            var m = this,
                s = Math.abs(b - c),
                r = b > c ? "down" : "up",
                s = s / 0.01,
                t = d / s;
            if (!m._loaded) return m.on("load", function() {
                m.fade(b, c, d, e, g)
            }), m;
            m.volume(b, g);
            for (var v = 1; v <= s; v++)(function() {
                var b = Math.round(1E3 * (m._volume + ("up" === r ? 0.01 : -0.01) * v)) / 1E3;
                setTimeout(function() {
                    m.volume(b, g);
                    b === c && e && e()
                }, t * v)
            })()
        },
        fadeIn: function(b, c, d) {
            return this.volume(0).play().fade(0, b, c, d)
        },
        fadeOut: function(b, c, d, e) {
            var g = this;
            return g.fade(g._volume, b, c, function() {
                d && d();
                g.pause(e);
                g.on("end")
            }, e)
        },
        _nodeById: function(b) {
            for (var c =
                this._audioNode[0], d = 0; d < this._audioNode.length; d++)
                if (this._audioNode[d].id === b) {
                    c = this._audioNode[d];
                    break
                }
            return c
        },
        _activeNode: function() {
            for (var b = null, c = 0; c < this._audioNode.length; c++)
                if (!this._audioNode[c].paused) {
                    b = this._audioNode[c];
                    break
                }
            this._drainPool();
            return b
        },
        _inactiveNode: function(b) {
            for (var c = null, d = 0; d < this._audioNode.length; d++)
                if (this._audioNode[d].paused && 4 === this._audioNode[d].readyState) {
                    b(this._audioNode[d]);
                    c = !0;
                    break
                }
            this._drainPool();
            if (!c) {
                var e;
                this._webAudio ? (e = this._setupAudioNode(),
                    b(e)) : (this.load(), e = this._audioNode[this._audioNode.length - 1], e.addEventListener("loadedmetadata", function() {
                    b(e)
                }))
            }
        },
        _drainPool: function() {
            var b = 0,
                c;
            for (c = 0; c < this._audioNode.length; c++) this._audioNode[c].paused && b++;
            for (c = this._audioNode.length - 1; 0 <= c && !(5 >= b); c--) this._audioNode[c].paused && (this._webAudio && this._audioNode[c].disconnect(0), b--, this._audioNode.splice(c, 1))
        },
        _clearEndTimer: function(b) {
            b = this._onendTimer.indexOf(b);
            b = 0 <= b ? b : 0;
            this._onendTimer[b] && (clearTimeout(this._onendTimer[b]),
                this._onendTimer.splice(b, 1))
        },
        _setupAudioNode: function() {
            var b = this._audioNode,
                d = this._audioNode.length;
            b[d] = "undefined" === typeof c.createGain ? c.createGainNode() : c.createGain();
            b[d].gain.value = this._volume;
            b[d].paused = !0;
            b[d]._pos = 0;
            b[d].readyState = 4;
            b[d].connect(m);
            b[d].panner = c.createPanner();
            b[d].panner.setPosition(this._pos3d[0], this._pos3d[1], this._pos3d[2]);
            b[d].panner.connect(b[d]);
            return b[d]
        },
        on: function(b, c) {
            var d = this["_on" + b];
            if ("function" === typeof c) d.push(c);
            else
                for (var e = 0; e < d.length; e++) c ?
                    d[e].call(this, c) : d[e].call(this);
            return this
        },
        off: function(b, c) {
            for (var d = this["_on" + b], e = c.toString(), g = 0; g < d.length; g++)
                if (e === d[g].toString()) {
                    d.splice(g, 1);
                    break
                }
            return this
        },
        unload: function() {
            for (var c = this._audioNode, d = 0; d < this._audioNode.length; d++) c[d].paused || this.stop(c[d].id), this._webAudio ? c[d].disconnect(0) : c[d].src = "";
            c = s._howls.indexOf(this);
            null !== c && 0 <= c && s._howls.splice(c, 1);
            delete b[this._src]
        }
    };
    if (d) var r = function(b, c) {
        b._duration = c ? c.duration : b._duration;
        0 === Object.getOwnPropertyNames(b._sprite).length &&
            (b._sprite = {
                _default: [0, 1E3 * b._duration]
            });
        b._loaded || (b._loaded = !0, b.on("load"));
        b._autoplay && b.play()
    };
    "function" === typeof define && define.amd && define(function() {
        return {
            Howler: s,
            Howl: v
        }
    });
    "undefined" !== typeof exports && (exports.Howler = s, exports.Howl = v);
    window.Howler = s;
    window.Howl = v
})();
(function(b) {
    Number.prototype.map = function(b, c, d, e) {
        return d + (e - d) * ((this - b) / (c - b))
    };
    Number.prototype.limit = function(b, c) {
        return Math.min(c, Math.max(b, this))
    };
    Number.prototype.round = function(b) {
        b = Math.pow(10, b || 0);
        return Math.round(this * b) / b
    };
    Number.prototype.floor = function() {
        return Math.floor(this)
    };
    Number.prototype.ceil = function() {
        return Math.ceil(this)
    };
    Number.prototype.toInt = function() {
        return this | 0
    };
    Number.prototype.toRad = function() {
        return this / 180 * Math.PI
    };
    Number.prototype.toDeg = function() {
        return 180 *
            this / Math.PI
    };
    Array.prototype.erase = function(b) {
        for (var c = this.length; c--;) this[c] === b && this.splice(c, 1);
        return this
    };
    Array.prototype.random = function() {
        return this[Math.floor(Math.random() * this.length)]
    };
    Function.prototype.bind = Function.prototype.bind || function(b) {
        if ("function" !== typeof this) throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
        var c = Array.prototype.slice.call(arguments, 1),
            d = this,
            e = function() {},
            g = function() {
                return d.apply(this instanceof e && b ?
                    this : b, c.concat(Array.prototype.slice.call(arguments)))
            };
        e.prototype = this.prototype;
        g.prototype = new e;
        return g
    };
    b.ig = {
        game: null,
        debug: null,
        version: "1.23",
        global: b,
        modules: {},
        resources: [],
        ready: !1,
        baked: !1,
        nocache: "",
        ua: {},
        prefix: b.ImpactPrefix || "",
        lib: "lib/",
        _current: null,
        _loadQueue: [],
        _waitForOnload: 0,
        $: function(b) {
            return "#" == b.charAt(0) ? document.getElementById(b.substr(1)) : document.getElementsByTagName(b)
        },
        $new: function(b) {
            return document.createElement(b)
        },
        copy: function(b) {
            if (!b || "object" != typeof b ||
                b instanceof HTMLElement || b instanceof ig.Class) return b;
            if (b instanceof Array)
                for (var c = [], d = 0, e = b.length; d < e; d++) c[d] = ig.copy(b[d]);
            else
                for (d in c = {}, b) c[d] = ig.copy(b[d]);
            return c
        },
        merge: function(b, c) {
            for (var d in c) {
                var e = c[d];
                if ("object" != typeof e || e instanceof HTMLElement || e instanceof ig.Class || null === e) b[d] = e;
                else {
                    if (!b[d] || "object" != typeof b[d]) b[d] = e instanceof Array ? [] : {};
                    ig.merge(b[d], e)
                }
            }
            return b
        },
        ksort: function(b) {
            if (!b || "object" != typeof b) return [];
            var c = [],
                d = [],
                e;
            for (e in b) c.push(e);
            c.sort();
            for (e = 0; e < c.length; e++) d.push(b[c[e]]);
            return d
        },
        setVendorAttribute: function(b, c, d) {
            var e = c.charAt(0).toUpperCase() + c.substr(1);
            b[c] = "undefined" !== typeof b.imageSmoothingEnabled ? b["ms" + e] = b["moz" + e] = b["o" + e] = d : b["ms" + e] = b["moz" + e] = b["webkit" + e] = b["o" + e] = d
        },
        getVendorAttribute: function(b, c) {
            var d = c.charAt(0).toUpperCase() + c.substr(1);
            return "undefined" !== typeof b.imageSmoothingEnabled ? b[c] || b["ms" + d] || b["moz" + d] || b["o" + d] : b[c] || b["ms" + d] || b["moz" + d] || b["webkit" + d] || b["o" + d]
        },
        normalizeVendorAttribute: function(b,
            c) {
            var d = ig.getVendorAttribute(b, c);
            !b[c] && d && (b[c] = d)
        },
        getImagePixels: function(b, c, d, e, g) {
            var n = ig.$new("canvas");
            n.width = b.width;
            n.height = b.height;
            var m = n.getContext("2d");
            ig.System.SCALE.CRISP(n, m);
            var y = ig.getVendorAttribute(m, "backingStorePixelRatio") || 1;
            ig.normalizeVendorAttribute(m, "getImageDataHD");
            var E = b.width / y,
                C = b.height / y;
            n.width = Math.ceil(E);
            n.height = Math.ceil(C);
            m.drawImage(b, 0, 0, E, C);
            return 1 === y ? m.getImageData(c, d, e, g) : m.getImageDataHD(c, d, e, g)
        },
        module: function(b) {
            if (ig._current) throw "Module '" +
                ig._current.name + "' defines nothing";
            if (ig.modules[b] && ig.modules[b].body) throw "Module '" + b + "' is already defined";
            ig._current = {
                name: b,
                requires: [],
                loaded: !1,
                body: null
            };
            ig.modules[b] = ig._current;
            ig._loadQueue.push(ig._current);
            return ig
        },
        requires: function() {
            ig._current.requires = Array.prototype.slice.call(arguments);
            return ig
        },
        defines: function(b) {
            ig._current.body = b;
            ig._current = null;
            ig._initDOMReady()
        },
        addResource: function(b) {
            ig.resources.push(b)
        },
        setNocache: function(b) {
            ig.nocache = b ? "?" + Date.now() : ""
        },
        log: function() {},
        assert: function() {},
        show: function() {},
        mark: function() {},
        _loadScript: function(b, c) {
            ig.modules[b] = {
                name: b,
                requires: [],
                loaded: !1,
                body: null
            };
            ig._waitForOnload++;
            var d = ig.prefix + ig.lib + b.replace(/\./g, "/") + ".js" + ig.nocache,
                e = ig.$new("script");
            e.type = "text/javascript";
            e.src = d;
            e.onload = function() {
                ig._waitForOnload--;
                ig._execModules()
            };
            e.onerror = function() {
                throw "Failed to load module " + b + " at " + d + " required from " + c;
            };
            ig.$("head")[0].appendChild(e)
        },
        _execModules: function() {
            for (var b = !1, c =
                0; c < ig._loadQueue.length; c++) {
                for (var d = ig._loadQueue[c], e = !0, g = 0; g < d.requires.length; g++) {
                    var n = d.requires[g];
                    ig.modules[n] ? ig.modules[n].loaded || (e = !1) : (e = !1, ig._loadScript(n, d.name))
                }
                e && d.body && (ig._loadQueue.splice(c, 1), d.loaded = !0, d.body(), b = !0, c--)
            }
            if (b) ig._execModules();
            else if (!ig.baked && 0 == ig._waitForOnload && 0 != ig._loadQueue.length) {
                b = [];
                for (c = 0; c < ig._loadQueue.length; c++) {
                    e = [];
                    n = ig._loadQueue[c].requires;
                    for (g = 0; g < n.length; g++) d = ig.modules[n[g]], (!d || !d.loaded) && e.push(n[g]);
                    b.push(ig._loadQueue[c].name +
                        " (requires: " + e.join(", ") + ")")
                }
                throw "Unresolved (or circular?) dependencies. Most likely there's a name/path mismatch for one of the listed modules or a previous syntax error prevents a module from loading:\n" + b.join("\n");
            }
        },
        _DOMReady: function() {
            if (!ig.modules["dom.ready"].loaded) {
                if (!document.body) return setTimeout(ig._DOMReady, 13);
                ig.modules["dom.ready"].loaded = !0;
                ig._waitForOnload--;
                ig._execModules()
            }
            return 0
        },
        _boot: function() {
            document.location.href.match(/\?nocache/) && ig.setNocache(!0);
            ig.ua.pixelRatio =
                b.devicePixelRatio || 1;
            ig.ua.viewport = {
                width: b.innerWidth,
                height: b.innerHeight
            };
            ig.ua.screen = {
                width: b.screen.availWidth * ig.ua.pixelRatio,
                height: b.screen.availHeight * ig.ua.pixelRatio
            };
            ig.ua.iPhone = /iPhone/i.test(navigator.userAgent);
            ig.ua.iPhone4 = ig.ua.iPhone && 2 == ig.ua.pixelRatio;
            ig.ua.iPad = /iPad/i.test(navigator.userAgent);
            ig.ua.android = /android/i.test(navigator.userAgent);
            ig.ua.winPhone = /Windows Phone/i.test(navigator.userAgent);
            ig.ua.is_uiwebview = /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(navigator.userAgent);
            ig.ua.is_safari_or_uiwebview = /(iPhone|iPod|iPad).*AppleWebKit/i.test(navigator.userAgent);
            ig.ua.iOS = ig.ua.iPhone || ig.ua.iPad;
            ig.ua.iOS6_tag = /OS 6_/i.test(navigator.userAgent);
            ig.ua.iOS6 = (ig.ua.iPhone || ig.ua.iPad) && ig.ua.iOS6_tag;
            ig.ua.iOSgt5 = ig.ua.iOS && 5 < parseInt(navigator.appVersion.match(/OS (\d+)_(\d+)_?(\d+)?/)[1]);
            ig.ua.HTCONE = /HTC_One/i.test(navigator.userAgent);
            ig.ua.winPhone = /Windows Phone/i.test(navigator.userAgent);
            ig.ua.Kindle = /Silk/i.test(navigator.userAgent);
            ig.ua.touchDevice = "ontouchstart" in
                b || b.navigator.msMaxTouchPoints;
            ig.ua.mobile = ig.ua.iOS || ig.ua.android || ig.ua.iOS6 || ig.ua.winPhone || ig.ua.Kindle || /mobile/i.test(navigator.userAgent)
        },
        _initDOMReady: function() {
            ig.modules["dom.ready"] ? ig._execModules() : (ig._boot(), ig.modules["dom.ready"] = {
                requires: [],
                loaded: !1,
                body: null
            }, ig._waitForOnload++, "complete" === document.readyState ? ig._DOMReady() : (document.addEventListener("DOMContentLoaded", ig._DOMReady, !1), b.addEventListener("load", ig._DOMReady, !1)))
        }
    };
    ig.normalizeVendorAttribute(b, "requestAnimationFrame");
    if (b.requestAnimationFrame) {
        var c = 1,
            d = {};
        b.ig.setAnimation = function(e, g) {
            var m = c++;
            d[m] = !0;
            var r = function() {
                d[m] && (b.requestAnimationFrame(r, g), e())
            };
            b.requestAnimationFrame(r, g);
            return m
        };
        b.ig.clearAnimation = function(b) {
            delete d[b]
        }
    } else b.ig.setAnimation = function(c) {
        return b.setInterval(c, 1E3 / 60)
    }, b.ig.clearAnimation = function(c) {
        b.clearInterval(c)
    };
    var e = !1,
        g = /xyz/.test(function() {
            xyz
        }) ? /\bparent\b/ : /.*/,
        m = 0;
    b.ig.Class = function() {};
    var y = function(b) {
        var c = this.prototype,
            d = {},
            e;
        for (e in b) "function" ==
            typeof b[e] && "function" == typeof c[e] && g.test(b[e]) ? (d[e] = c[e], c[e] = function(b, c) {
                return function() {
                    var e = this.parent;
                    this.parent = d[b];
                    var g = c.apply(this, arguments);
                    this.parent = e;
                    return g
                }
            }(e, b[e])) : c[e] = b[e]
    };
    b.ig.Class.extend = function(c) {
        function d() {
            if (!e) {
                if (this.staticInstantiate) {
                    var b = this.staticInstantiate.apply(this, arguments);
                    if (b) return b
                }
                for (var c in this) "object" == typeof this[c] && (this[c] = ig.copy(this[c]));
                this.init && this.init.apply(this, arguments)
            }
            return this
        }
        var v = this.prototype;
        e = !0;
        var r = new this;
        e = !1;
        for (var l in c) r[l] = "function" == typeof c[l] && "function" == typeof v[l] && g.test(c[l]) ? function(b, c) {
            return function() {
                var d = this.parent;
                this.parent = v[b];
                var e = c.apply(this, arguments);
                this.parent = d;
                return e
            }
        }(l, c[l]) : c[l];
        d.prototype = r;
        d.prototype.constructor = d;
        d.extend = b.ig.Class.extend;
        d.inject = y;
        d.classId = r.classId = ++m;
        return d
    };
    b.ImpactMixin && ig.merge(ig, b.ImpactMixin)
})(window);
ig.baked = !0;
ig.module("impact.image").defines(function() {
    ig.Image = ig.Class.extend({
        data: null,
        width: 0,
        height: 0,
        loaded: !1,
        failed: !1,
        loadCallback: null,
        path: "",
        staticInstantiate: function(b) {
            return ig.Image.cache[b] || null
        },
        init: function(b) {
            this.path = b;
            this.load()
        },
        load: function(b) {
            this.loaded ? b && b(this.path, !0) : (!this.loaded && ig.ready ? (this.loadCallback = b || null, this.data = new Image, this.data.onload = this.onload.bind(this), this.data.onerror = this.onerror.bind(this), this.data.src = ig.prefix + this.path + ig.nocache) : ig.addResource(this),
                ig.Image.cache[this.path] = this)
        },
        reload: function() {
            this.loaded = !1;
            this.data = new Image;
            this.data.onload = this.onload.bind(this);
            this.data.src = this.path + "?" + Date.now()
        },
        onload: function() {
            this.width = this.data.width;
            this.height = this.data.height;
            this.loaded = !0;
            1 != ig.system.scale && this.resize(ig.system.scale);
            this.loadCallback && this.loadCallback(this.path, !0)
        },
        onerror: function() {
            this.failed = !0;
            this.loadCallback && this.loadCallback(this.path, !1)
        },
        resize: function(b) {
            var c = ig.getImagePixels(this.data, 0, 0, this.width,
                    this.height),
                d = this.width * b,
                e = this.height * b,
                g = ig.$new("canvas");
            g.width = d;
            g.height = e;
            for (var m = g.getContext("2d"), y = m.getImageData(0, 0, d, e), s = 0; s < e; s++)
                for (var t = 0; t < d; t++) {
                    var v = 4 * (Math.floor(s / b) * this.width + Math.floor(t / b)),
                        r = 4 * (s * d + t);
                    y.data[r] = c.data[v];
                    y.data[r + 1] = c.data[v + 1];
                    y.data[r + 2] = c.data[v + 2];
                    y.data[r + 3] = c.data[v + 3]
                }
            m.putImageData(y, 0, 0);
            this.data = g
        },
        draw: function(b, c, d, e, g, m) {
            if (this.loaded) {
                var y = ig.system.scale;
                g = (g ? g : this.width) * y;
                m = (m ? m : this.height) * y;
                ig.system.context.drawImage(this.data,
                    d ? d * y : 0, e ? e * y : 0, g, m, ig.system.getDrawPos(b), ig.system.getDrawPos(c), g, m);
                ig.Image.drawCount++
            }
        },
        drawTile: function(b, c, d, e, g, m, y) {
            g = g ? g : e;
            if (this.loaded && !(e > this.width || g > this.height)) {
                var s = ig.system.scale,
                    t = Math.floor(e * s),
                    v = Math.floor(g * s),
                    r = m ? -1 : 1,
                    l = y ? -1 : 1;
                if (m || y) ig.system.context.save(), ig.system.context.scale(r, l);
                ig.system.context.drawImage(this.data, Math.floor(d * e) % this.width * s, Math.floor(d * e / this.width) * g * s, t, v, ig.system.getDrawPos(b) * r - (m ? t : 0), ig.system.getDrawPos(c) * l - (y ? v : 0), t, v);
                (m ||
                    y) && ig.system.context.restore();
                ig.Image.drawCount++
            }
        }
    });
    ig.Image.drawCount = 0;
    ig.Image.cache = {};
    ig.Image.reloadCache = function() {
        for (var b in ig.Image.cache) ig.Image.cache[b].reload()
    }
});
ig.baked = !0;
ig.module("impact.font").requires("impact.image").defines(function() {
    ig.Font = ig.Image.extend({
        widthMap: [],
        indices: [],
        firstChar: 32,
        alpha: 1,
        letterSpacing: 1,
        lineSpacing: 0,
        onload: function(b) {
            this._loadMetrics(this.data);
            this.parent(b)
        },
        widthForString: function(b) {
            if (-1 !== b.indexOf("\n")) {
                b = b.split("\n");
                for (var c = 0, d = 0; d < b.length; d++) c = Math.max(c, this._widthForLine(b[d]));
                return c
            }
            return this._widthForLine(b)
        },
        _widthForLine: function(b) {
            for (var c = 0, d = 0; d < b.length; d++) c += this.widthMap[b.charCodeAt(d) - this.firstChar] +
                this.letterSpacing;
            return c
        },
        heightForString: function(b) {
            return b.split("\n").length * (this.height + this.lineSpacing)
        },
        draw: function(b, c, d, e) {
            "string" != typeof b && (b = b.toString());
            if (-1 !== b.indexOf("\n")) {
                b = b.split("\n");
                for (var g = this.height + this.lineSpacing, m = 0; m < b.length; m++) this.draw(b[m], c, d + m * g, e)
            } else {
                if (e == ig.Font.ALIGN.RIGHT || e == ig.Font.ALIGN.CENTER) m = this._widthForLine(b), c -= e == ig.Font.ALIGN.CENTER ? m / 2 : m;
                1 !== this.alpha && (ig.system.context.globalAlpha = this.alpha);
                for (m = 0; m < b.length; m++) e = b.charCodeAt(m),
                    c += this._drawChar(e - this.firstChar, c, d);
                1 !== this.alpha && (ig.system.context.globalAlpha = 1);
                ig.Image.drawCount += b.length
            }
        },
        _drawChar: function(b, c, d) {
            if (!this.loaded || 0 > b || b >= this.indices.length) return 0;
            var e = ig.system.scale,
                g = this.widthMap[b] * e,
                m = (this.height - 2) * e;
            ig.system.context.drawImage(this.data, this.indices[b] * e, 0, g, m, ig.system.getDrawPos(c), ig.system.getDrawPos(d), g, m);
            return this.widthMap[b] + this.letterSpacing
        },
        _loadMetrics: function(b) {
            this.height = b.height - 1;
            this.widthMap = [];
            this.indices = [];
            for (var c = ig.getImagePixels(b, 0, b.height - 1, b.width, 1), d = 0, e = 0, g = 0; g < b.width; g++) {
                var m = 4 * g + 3;
                127 < c.data[m] ? e++ : 128 > c.data[m] && e && (this.widthMap.push(e), this.indices.push(g - e), d++, e = 0)
            }
            this.widthMap.push(e);
            this.indices.push(g - e)
        }
    });
    ig.Font.ALIGN = {
        LEFT: 0,
        RIGHT: 1,
        CENTER: 2
    }
});
ig.baked = !0;
ig.module("impact.sound").defines(function() {
    ig.SoundManager = ig.Class.extend({
        clips: {},
        volume: 1,
        format: null,
        init: function() {
            if (!ig.Sound.enabled || !window.Audio) ig.Sound.enabled = !1;
            else {
                for (var b = new Audio, c = 0; c < ig.Sound.use.length; c++) {
                    var d = ig.Sound.use[c];
                    if (b.canPlayType(d.mime)) {
                        this.format = d;
                        break
                    }
                }
                this.format || (ig.Sound.enabled = !1)
            }
        },
        load: function(b, c, d) {
            var e = ig.prefix + b.replace(/[^\.]+$/, this.format.ext) + ig.nocache;
            if (this.clips[b]) {
                if (c && this.clips[b].length < ig.Sound.channels)
                    for (c = this.clips[b].length; c <
                        ig.Sound.channels; c++) {
                        var g = new Audio(e);
                        g.load();
                        this.clips[b].push(g)
                    }
                return this.clips[b][0]
            }
            var m = new Audio(e);
            d && (m.addEventListener("canplaythrough", function s(c) {
                m.removeEventListener("canplaythrough", s, !1);
                d(b, !0, c)
            }, !1), m.addEventListener("error", function(c) {
                d(b, !1, c)
            }, !1));
            m.preload = "auto";
            m.load();
            this.clips[b] = [m];
            if (c)
                for (c = 1; c < ig.Sound.channels; c++) g = new Audio(e), g.load(), this.clips[b].push(g);
            return m
        },
        get: function(b) {
            b = this.clips[b];
            for (var c = 0, d; d = b[c++];)
                if (d.paused || d.ended) return d.ended &&
                    (d.currentTime = 0), d;
            b[0].pause();
            b[0].currentTime = 0;
            return b[0]
        }
    });
    ig.Music = ig.Class.extend({
        tracks: [],
        namedTracks: {},
        currentTrack: null,
        currentIndex: 0,
        random: !1,
        _volume: 1,
        _loop: !1,
        _fadeInterval: 0,
        _fadeTimer: null,
        _endedCallbackBound: null,
        init: function() {
            this._endedCallbackBound = this._endedCallback.bind(this);
            Object.defineProperty ? (Object.defineProperty(this, "volume", {
                    get: this.getVolume.bind(this),
                    set: this.setVolume.bind(this)
                }), Object.defineProperty(this, "loop", {
                    get: this.getLooping.bind(this),
                    set: this.setLooping.bind(this)
                })) :
                this.__defineGetter__ && (this.__defineGetter__("volume", this.getVolume.bind(this)), this.__defineSetter__("volume", this.setVolume.bind(this)), this.__defineGetter__("loop", this.getLooping.bind(this)), this.__defineSetter__("loop", this.setLooping.bind(this)))
        },
        add: function(b, c) {
            if (ig.Sound.enabled) {
                var d = ig.soundManager.load(b instanceof ig.Sound ? b.path : b, !1);
                d.loop = this._loop;
                d.volume = this._volume;
                d.addEventListener("ended", this._endedCallbackBound, !1);
                this.tracks.push(d);
                c && (this.namedTracks[c] = d);
                this.currentTrack ||
                    (this.currentTrack = d)
            }
        },
        next: function() {
            this.tracks.length && (this.stop(), this.currentIndex = this.random ? Math.floor(Math.random() * this.tracks.length) : (this.currentIndex + 1) % this.tracks.length, this.currentTrack = this.tracks[this.currentIndex], this.play())
        },
        pause: function() {
            this.currentTrack && this.currentTrack.pause()
        },
        stop: function() {
            this.currentTrack && (this.currentTrack.pause(), this.currentTrack.currentTime = 0)
        },
        play: function(b) {
            if (b && this.namedTracks[b]) b = this.namedTracks[b], b != this.currentTrack && (this.stop(),
                this.currentTrack = b);
            else if (!this.currentTrack) return;
            this.currentTrack.play()
        },
        getLooping: function() {
            return this._loop
        },
        setLooping: function(b) {
            this._loop = b;
            for (var c in this.tracks) this.tracks[c].loop = b
        },
        getVolume: function() {
            return this._volume
        },
        setVolume: function(b) {
            this._volume = b.limit(0, 1);
            for (var c in this.tracks) this.tracks[c].volume = this._volume
        },
        fadeOut: function(b) {
            this.currentTrack && (clearInterval(this._fadeInterval), this.fadeTimer = new ig.Timer(b), this._fadeInterval = setInterval(this._fadeStep.bind(this),
                50))
        },
        _fadeStep: function() {
            var b = this.fadeTimer.delta().map(-this.fadeTimer.target, 0, 1, 0).limit(0, 1) * this._volume;
            0.01 >= b ? (this.stop(), this.currentTrack.volume = this._volume, clearInterval(this._fadeInterval)) : this.currentTrack.volume = b
        },
        _endedCallback: function() {
            this._loop ? this.play() : this.next()
        }
    });
    ig.Sound = ig.Class.extend({
        path: "",
        volume: 1,
        currentClip: null,
        multiChannel: !0,
        init: function(b, c) {
            this.path = b;
            this.multiChannel = !1 !== c;
            this.load()
        },
        load: function(b) {
            ig.Sound.enabled ? ig.ready ? ig.soundManager.load(this.path,
                this.multiChannel, b) : ig.addResource(this) : b && b(this.path, !0)
        },
        play: function() {
            ig.Sound.enabled && (this.currentClip = ig.soundManager.get(this.path), this.currentClip.volume = ig.soundManager.volume * this.volume, this.currentClip.play())
        },
        stop: function() {
            this.currentClip && (this.currentClip.pause(), this.currentClip.currentTime = 0)
        }
    });
    ig.Sound.FORMAT = {
        MP3: {
            ext: "mp3",
            mime: "audio/mpeg"
        },
        M4A: {
            ext: "m4a",
            mime: "audio/mp4; codecs=mp4a"
        },
        OGG: {
            ext: "ogg",
            mime: "audio/ogg; codecs=vorbis"
        },
        WEBM: {
            ext: "webm",
            mime: "audio/webm; codecs=vorbis"
        },
        CAF: {
            ext: "caf",
            mime: "audio/x-caf"
        }
    };
    ig.Sound.use = [ig.Sound.FORMAT.OGG, ig.Sound.FORMAT.MP3];
    ig.Sound.channels = 4;
    ig.Sound.enabled = !0
});
ig.baked = !0;
ig.module("impact.loader").requires("impact.image", "impact.font", "impact.sound").defines(function() {
    ig.Loader = ig.Class.extend({
        resources: [],
        gameClass: null,
        status: 0,
        done: !1,
        _unloaded: [],
        _drawStatus: 0,
        _intervalId: 0,
        _loadCallbackBound: null,
        init: function(b, c) {
            this.gameClass = b;
            this.resources = c;
            this._loadCallbackBound = this._loadCallback.bind(this);
            for (var d = 0; d < this.resources.length; d++) this._unloaded.push(this.resources[d].path)
        },
        load: function() {
            ig.system.clear("#000");
            if (this.resources.length) {
                for (var b =
                    0; b < this.resources.length; b++) this.loadResource(this.resources[b]);
                this._intervalId = setInterval(this.draw.bind(this), 16)
            } else this.end()
        },
        loadResource: function(b) {
            b.load(this._loadCallbackBound)
        },
        end: function() {
            this.done || (this.done = !0, clearInterval(this._intervalId))
        },
        draw: function() {},
        _loadCallback: function(b, c) {
            if (c) this._unloaded.erase(b);
            else throw "Failed to load resource: " + b;
            this.status = 1 - this._unloaded.length / this.resources.length;
            0 == this._unloaded.length && setTimeout(this.end.bind(this), 250)
        }
    })
});
ig.baked = !0;
ig.module("impact.timer").defines(function() {
    ig.Timer = ig.Class.extend({
        target: 0,
        base: 0,
        last: 0,
        pausedAt: 0,
        init: function(b) {
            this.last = this.base = ig.Timer.time;
            this.target = b || 0
        },
        set: function(b) {
            this.target = b || 0;
            this.base = ig.Timer.time;
            this.pausedAt = 0
        },
        reset: function() {
            this.base = ig.Timer.time;
            this.pausedAt = 0
        },
        tick: function() {
            var b = ig.Timer.time - this.last;
            this.last = ig.Timer.time;
            return this.pausedAt ? 0 : b
        },
        delta: function() {
            return (this.pausedAt || ig.Timer.time) - this.base - this.target
        },
        pause: function() {
            this.pausedAt || (this.pausedAt =
                ig.Timer.time)
        },
        unpause: function() {
            this.pausedAt && (this.base += ig.Timer.time - this.pausedAt, this.pausedAt = 0)
        }
    });
    ig.Timer._last = 0;
    ig.Timer.time = Number.MIN_VALUE;
    ig.Timer.timeScale = 1;
    ig.Timer.maxStep = 0.05;
    ig.Timer.step = function() {
        var b = Date.now();
        ig.Timer.time += Math.min((b - ig.Timer._last) / 1E3, ig.Timer.maxStep) * ig.Timer.timeScale;
        ig.Timer._last = b
    }
});
ig.baked = !0;
ig.module("impact.system").requires("impact.timer", "impact.image").defines(function() {
    ig.System = ig.Class.extend({
        fps: 30,
        width: 320,
        height: 240,
        realWidth: 320,
        realHeight: 240,
        scale: 1,
        tick: 0,
        animationId: 0,
        newGameClass: null,
        running: !1,
        delegate: null,
        clock: null,
        canvas: null,
        context: null,
        init: function(b, c, d, e, g) {
            this.fps = c;
            this.clock = new ig.Timer;
            this.canvas = ig.$(b);
            this.resize(d, e, g);
            this.context = this.canvas.getContext("2d");
            this.getDrawPos = ig.System.drawMode;
            1 != this.scale && (ig.System.scaleMode = ig.System.SCALE.CRISP);
            ig.System.scaleMode(this.canvas, this.context)
        },
        resize: function(b, c, d) {
            this.width = b;
            this.height = c;
            this.scale = d || this.scale;
            this.realWidth = this.width * this.scale;
            this.realHeight = this.height * this.scale;
            this.canvas.width = this.realWidth;
            this.canvas.height = this.realHeight
        },
        setGame: function(b) {
            this.running ? this.newGameClass = b : this.setGameNow(b)
        },
        setGameNow: function(b) {
            ig.game = new b;
            ig.system.setDelegate(ig.game)
        },
        setDelegate: function(b) {
            if ("function" == typeof b.run) this.delegate = b, this.startRunLoop();
            else throw "System.setDelegate: No run() function in object";
        },
        stopRunLoop: function() {
            ig.clearAnimation(this.animationId);
            this.running = !1
        },
        startRunLoop: function() {
            this.stopRunLoop();
            this.animationId = ig.setAnimation(this.run.bind(this), this.canvas);
            this.running = !0
        },
        clear: function(b) {
            this.context.fillStyle = b;
            this.context.fillRect(0, 0, this.realWidth, this.realHeight)
        },
        run: function() {
            ig.Timer.step();
            this.tick = this.clock.tick();
            this.delegate.run();
            ig.input.clearPressed();
            this.newGameClass && (this.setGameNow(this.newGameClass), this.newGameClass = null)
        },
        getDrawPos: null
    });
    ig.System.DRAW = {
        AUTHENTIC: function(b) {
            return Math.round(b) * this.scale
        },
        SMOOTH: function(b) {
            return Math.round(b * this.scale)
        },
        SUBPIXEL: function(b) {
            return b * this.scale
        }
    };
    ig.System.drawMode = ig.System.DRAW.SMOOTH;
    ig.System.SCALE = {
        CRISP: function(b, c) {
            ig.setVendorAttribute(c, "imageSmoothingEnabled", !1);
            b.style.imageRendering = "-moz-crisp-edges";
            b.style.imageRendering = "-o-crisp-edges";
            b.style.imageRendering = "-webkit-optimize-contrast";
            b.style.imageRendering = "crisp-edges";
            b.style.msInterpolationMode = "nearest-neighbor"
        },
        SMOOTH: function(b, c) {
            ig.setVendorAttribute(c, "imageSmoothingEnabled", !0);
            b.style.imageRendering = "";
            b.style.msInterpolationMode = ""
        }
    };
    ig.System.scaleMode = ig.System.SCALE.SMOOTH
});
ig.baked = !0;
ig.module("impact.input").defines(function() {
    ig.KEY = {
        MOUSE1: -1,
        MOUSE2: -3,
        MWHEEL_UP: -4,
        MWHEEL_DOWN: -5,
        BACKSPACE: 8,
        TAB: 9,
        ENTER: 13,
        PAUSE: 19,
        CAPS: 20,
        ESC: 27,
        SPACE: 32,
        PAGE_UP: 33,
        PAGE_DOWN: 34,
        END: 35,
        HOME: 36,
        LEFT_ARROW: 37,
        UP_ARROW: 38,
        RIGHT_ARROW: 39,
        DOWN_ARROW: 40,
        INSERT: 45,
        DELETE: 46,
        _0: 48,
        _1: 49,
        _2: 50,
        _3: 51,
        _4: 52,
        _5: 53,
        _6: 54,
        _7: 55,
        _8: 56,
        _9: 57,
        A: 65,
        B: 66,
        C: 67,
        D: 68,
        E: 69,
        F: 70,
        G: 71,
        H: 72,
        I: 73,
        J: 74,
        K: 75,
        L: 76,
        M: 77,
        N: 78,
        O: 79,
        P: 80,
        Q: 81,
        R: 82,
        S: 83,
        T: 84,
        U: 85,
        V: 86,
        W: 87,
        X: 88,
        Y: 89,
        Z: 90,
        NUMPAD_0: 96,
        NUMPAD_1: 97,
        NUMPAD_2: 98,
        NUMPAD_3: 99,
        NUMPAD_4: 100,
        NUMPAD_5: 101,
        NUMPAD_6: 102,
        NUMPAD_7: 103,
        NUMPAD_8: 104,
        NUMPAD_9: 105,
        MULTIPLY: 106,
        ADD: 107,
        SUBSTRACT: 109,
        DECIMAL: 110,
        DIVIDE: 111,
        F1: 112,
        F2: 113,
        F3: 114,
        F4: 115,
        F5: 116,
        F6: 117,
        F7: 118,
        F8: 119,
        F9: 120,
        F10: 121,
        F11: 122,
        F12: 123,
        SHIFT: 16,
        CTRL: 17,
        ALT: 18,
        PLUS: 187,
        COMMA: 188,
        MINUS: 189,
        PERIOD: 190
    };
    ig.Input = ig.Class.extend({
        bindings: {},
        actions: {},
        presses: {},
        locks: {},
        delayedKeyup: {},
        isUsingMouse: !1,
        isUsingKeyboard: !1,
        isUsingAccelerometer: !1,
        mouse: {
            x: 0,
            y: 0
        },
        accel: {
            x: 0,
            y: 0,
            z: 0
        },
        initMouse: function() {
            if (!this.isUsingMouse) {
                this.isUsingMouse = !0;
                var b = this.mousewheel.bind(this);
                ig.system.canvas.addEventListener("mousewheel", b, !1);
                ig.system.canvas.addEventListener("DOMMouseScroll", b, !1);
                ig.system.canvas.addEventListener("contextmenu", this.contextmenu.bind(this), !1);
                ig.system.canvas.addEventListener("mousedown", this.keydown.bind(this), !1);
                ig.system.canvas.addEventListener("mouseup", this.keyup.bind(this), !1);
                ig.system.canvas.addEventListener("mousemove", this.mousemove.bind(this), !1);
                ig.ua.touchDevice && (ig.system.canvas.addEventListener("touchstart",
                    this.keydown.bind(this), !1), ig.system.canvas.addEventListener("touchend", this.keyup.bind(this), !1), ig.system.canvas.addEventListener("touchmove", this.mousemove.bind(this), !1), ig.system.canvas.addEventListener("MSPointerDown", this.keydown.bind(this), !1), ig.system.canvas.addEventListener("MSPointerUp", this.keyup.bind(this), !1), ig.system.canvas.addEventListener("MSPointerMove", this.mousemove.bind(this), !1), ig.system.canvas.style.msTouchAction = "none")
            }
        },
        initKeyboard: function() {
            this.isUsingKeyboard || (this.isUsingKeyboard = !0, window.addEventListener("keydown", this.keydown.bind(this), !1), window.addEventListener("keyup", this.keyup.bind(this), !1))
        },
        initAccelerometer: function() {
            this.isUsingAccelerometer || window.addEventListener("devicemotion", this.devicemotion.bind(this), !1)
        },
        mousewheel: function(b) {
            var c = this.bindings[0 < (b.wheelDelta ? b.wheelDelta : -1 * b.detail) ? ig.KEY.MWHEEL_UP : ig.KEY.MWHEEL_DOWN];
            c && (this.actions[c] = !0, this.presses[c] = !0, this.delayedKeyup[c] = !0, b.stopPropagation(), b.preventDefault())
        },
        mousemove: function(b) {
            var c =
                parseInt(ig.system.canvas.offsetWidth) || ig.system.realWidth;
            ig.ua.mobile && (c = ig.system.realWidth);
            var c = ig.system.scale * (c / ig.system.realWidth),
                d = {
                    left: 0,
                    top: 0
                };
            ig.system.canvas.getBoundingClientRect && (d = ig.system.canvas.getBoundingClientRect());
            b = b.touches ? b.touches[0] : b;
            this.mouse.x = (b.clientX - d.left) / c;
            this.mouse.y = (b.clientY - d.top) / c
        },
        contextmenu: function(b) {
            this.bindings[ig.KEY.MOUSE2] && (b.stopPropagation(), b.preventDefault())
        },
        keydown: function(b) {
            var c = b.target.tagName;
            if (!("INPUT" == c || "TEXTAREA" ==
                c))
                if (c = "keydown" == b.type ? b.keyCode : 2 == b.button ? ig.KEY.MOUSE2 : ig.KEY.MOUSE1, 0 > c && window.focus(), ("touchstart" == b.type || "mousedown" == b.type) && this.mousemove(b), c = this.bindings[c]) this.actions[c] = !0, this.locks[c] || (this.presses[c] = !0, this.locks[c] = !0), b.stopPropagation(), b.preventDefault()
        },
        keyup: function(b) {
            var c = b.target.tagName;
            if (!("INPUT" == c || "TEXTAREA" == c))
                if (c = this.bindings["keyup" == b.type ? b.keyCode : 2 == b.button ? ig.KEY.MOUSE2 : ig.KEY.MOUSE1]) this.delayedKeyup[c] = !0, b.stopPropagation(), b.preventDefault()
        },
        devicemotion: function(b) {
            this.accel = b.accelerationIncludingGravity
        },
        bind: function(b, c) {
            0 > b ? this.initMouse() : 0 < b && this.initKeyboard();
            this.bindings[b] = c
        },
        bindTouch: function(b, c) {
            var d = ig.$(b),
                e = this;
            d.addEventListener("touchstart", function(b) {
                e.touchStart(b, c)
            }, !1);
            d.addEventListener("touchend", function(b) {
                e.touchEnd(b, c)
            }, !1);
            d.addEventListener("MSPointerDown", function(b) {
                e.touchStart(b, c)
            }, !1);
            d.addEventListener("MSPointerUp", function(b) {
                e.touchEnd(b, c)
            }, !1)
        },
        unbind: function(b) {
            this.delayedKeyup[this.bindings[b]] = !0;
            this.bindings[b] = null
        },
        unbindAll: function() {
            this.bindings = {};
            this.actions = {};
            this.presses = {};
            this.locks = {};
            this.delayedKeyup = {}
        },
        state: function(b) {
            return this.actions[b]
        },
        pressed: function(b) {
            return this.presses[b]
        },
        released: function(b) {
            return !!this.delayedKeyup[b]
        },
        clearPressed: function() {
            for (var b in this.delayedKeyup) this.actions[b] = !1, this.locks[b] = !1;
            this.delayedKeyup = {};
            this.presses = {}
        },
        touchStart: function(b, c) {
            this.actions[c] = !0;
            this.presses[c] = !0;
            b.stopPropagation();
            b.preventDefault();
            return !1
        },
        touchEnd: function(b, c) {
            this.delayedKeyup[c] = !0;
            b.stopPropagation();
            b.preventDefault();
            return !1
        }
    })
});
ig.baked = !0;
ig.module("impact.sound-handler").defines(function() {
    ig.SoundHandler = ig.Class.extend({
        formats: {
            ogg: ".ogg",
            mp3: ".mp3"
        },
        jukebox: null,
        pausePosition: null,
        globalMute: !1,
        forceMuted: !1,
        muted: !1,
        bgmStarted: !1,
        bgmPlaying: !1,
        soundPlaying: !1,
        currentSoundPlaying: null,
        soundBuffer: [],
        voSoundLoaded: [],
        sfxSoundLoaded: [],
        SOUNDID: {},
        voSoundsToLoad: [],
        sfxSoundsToLoad: [{
            name: "staticSound",
            path: "media/audio/play/static"
        }, {
            name: "openingSound",
            path: "media/audio/opening/opening"
        }, {
            name: "kittyopeningSound",
            path: "media/audio/opening/kittyopening"
        }, {
            name: "bubble",
            path: "media/audio/bubble"
        }, {
            name: "click",
            path: "media/audio/pop"
        }, {
            name: "count",
            path: "media/audio/count"
        }, {
            name: "over",
            path: "media/audio/over"
        }, {
            name: "evil",
            path: "media/audio/evil"
        }, {
            name: "hehe",
            path: "media/audio/yipee"
        }, {
            name: "win",
            path: "media/audio/win"
        }],
        debug: !1,
        init: function() {
            ig.ua.mobile ? (this.initSfx(), this.setupJukebox()) : (this.initSfx(), this.setupDesktopMusic());
            this.setupWindowHandler()
        },
        allVoSoundLoaded: function() {
            if (this.voSoundLoaded.length >= this.voSoundsToLoad.length) {
                this.debug &&
                    console.log("Vo ready");
                for (index = 0; index < this.voSoundLoaded.length; index++) this.voSoundLoaded[index].on("end", function(b) {
                    b.isPlaying = !1;
                    this.soundBuffer.pop()
                }.bind(this, this.voSoundLoaded[index])), this.voSoundLoaded[index].on("play", function(b) {
                    b.isPlaying = !0
                }.bind(this, this.voSoundLoaded[index]));
                return !0
            }
            return !1
        },
        allSfxSoundLoaded: function() {
            return this.sfxSoundLoaded.length >= this.sfxSoundsToLoad.length ? !0 : !1
        },
        stopBackgroundMusic: function() {
            ig.ua.mobile ? this.pausePosition = this.jukebox.player.pause() :
                ig.music.pause();
            this.bgmPlaying = !1
        },
        playBackgroundMusic: function() {
            this.bgmPlaying || (this.bgmStarted = !0, ig.ua.mobile ? this.pausePosition ? this.jukebox.player.resume(this.pausePosition) : this.jukebox.player.play(this.jukebox.player.settings.spritemap.music.start, !0) : ig.music.play(), this._unMuteBackgroundMusic(), this.bgmPlaying = !0)
        },
        playSound: function(b) {
            if ((b = this[b]) && (!this.forceMuted || !this.muted) && !b.isPlaying) this.soundBuffer.push(b), b.play()
        },
        stopAllAndPlaySound: function(b) {
            this.stopAllSounds();
            this.playSound(b)
        },
        stopAllSounds: function() {
            for (index = 0; index < this.soundBuffer.length; index++) this.soundBuffer[index].isPlaying = !1, this.soundBuffer.splice(0, 1)[0].stop()
        },
        addSound: function(b, c, d) {
            var e = c + this.formats.ogg;
            c += this.formats.mp3;
            this.SOUNDID[b] = b;
            this[b] = d ? new Howl({
                urls: [e, c],
                onload: d
            }) : new Howl({
                urls: [e, c]
            })
        },
        _muteSounds: function() {
            for (i = 0; i < ig.resources.length; i++) ig.resources[i].multiChannel && ig.resources[i].stop();
            Howler.mute();
            this.debug && console.log("Sounds muted")
        },
        _unMuteSounds: function() {
            Howler.unmute();
            ig.Sound.enabled = !0;
            this.debug && console.log("Sounds can play")
        },
        _muteBackgroundMusic: function() {
            ig.ua.mobile ? (this.stopBackgroundMusic(), this.jukebox.player.setVolume(0)) : ig.music.volume = 0;
            this.debug && console.log("BGM muted");
            this.bgmPlaying = !1
        },
        _unMuteBackgroundMusic: function() {
            this.bgmStarted && (ig.ua.mobile ? (this.pausePosition ? this.jukebox.player.resume(this.pausePosition) : this.jukebox.player.play(this.jukebox.player.settings.spritemap.music.start, !0), this.jukebox.player.setVolume(1)) : ig.music.volume =
                1, this.debug && console.log("BGM can play"), this.bgmPlaying = !0)
        },
        focusBlurMute: function() {
            this.forceMuted || this.mute()
        },
        focusBlurUnmute: function() {
            this.forceMuted || (this.unmute(), ig.game && (ig.game.getSound(), ig.game.getMusic()))
        },
        setForceMuted: function(b) {
            this.forceMuted = b
        },
        mute: function() {
            this.muted || (this._muteSounds(), this._muteBackgroundMusic(), this.muted = !0)
        },
        unmute: function() {
            this.muted && (this._unMuteSounds(), this._unMuteBackgroundMusic(), this.muted = !1)
        },
        setupWindowHandler: function() {
            "true" ===
            getQueryVariable("webview") ? ($(window).focus(function() {
                ig.ua.mobile && ig.game && ig.game.resumeGame();
                ig.soundHandler && ig.soundHandler.focusBlurUnmute()
            }), $(window).blur(function() {
                ig.soundHandler && ig.soundHandler.focusBlurMute()
            })) : (window.onfocus = function() {
                ig.ua.mobile && ig.game && ig.game.resumeGame();
                ig.soundHandler && ig.soundHandler.focusBlurUnmute()
            }, window.onblur = function() {
                ig.soundHandler && ig.soundHandler.focusBlurMute()
            })
        },
        initSfx: function() {
            for (index = 0; index < this.sfxSoundsToLoad.length; index++) {
                var b =
                    function(b) {
                        this.sfxSoundLoaded.push(this[b])
                    }.bind(this, this.sfxSoundsToLoad[index].name);
                this.addSound(this.sfxSoundsToLoad[index].name, this.sfxSoundsToLoad[index].path, b)
            }
        },
        initVoSfx: function() {
            for (index = 0; index < this.voSoundsToLoad.length; index++) {
                var b = function(b) {
                    this.voSoundLoaded.push(this[b])
                }.bind(this, this.voSoundsToLoad[index].name);
                this.addSound(this.voSoundsToLoad[index].name, this.voSoundsToLoad[index].path, b)
            }
        },
        setupDesktopMusic: function() {
            ig.music.add("media/audio/bgm.*", "background")
        },
        setupJukebox: function() {
            ig.ua.mobile && (this.jukebox = new ig.Jukebox, this.pausePosition = this.jukebox.player.settings.spritemap.music.start)
        },
        forceLoopBGM: function() {
            if (ig.ua.winPhone && !this.forceMuted && this.bgmPlaying && this.jukebox && this.jukebox.player && this.jukebox.player.settings.spritemap.music && this.jukebox.player.settings.spritemap.music.loop) {
                if (0 <= this.prevTime)
                    if (this.jukebox.player.getCurrentTime() === this.prevTime) {
                        if (this.silentCounter || (this.silentCounter = 0), this.silentCounter++, this.jukebox.player.getCurrentTime() >=
                            this.jukebox.player.settings.spritemap.music.end || this.silentCounter > 0.0010 * ig.soundHandler.jukebox.player.settings.timeout * ig.system.fps) ig.ua.mobile || this.jukebox.player.pause(), this.jukebox.player.play(this.jukebox.player.settings.spritemap.music.start, !0), this.silentCounter = null
                    } else this.silentCounter = null;
                this.prevTime = this.jukebox.player.getCurrentTime()
            }
        }
    })
});

function getHiddenProp() {
    var b = ["webkit", "moz", "ms", "o"];
    if ("hidden" in document) return "hidden";
    for (var c = 0; c < b.length; c++)
        if (b[c] + "Hidden" in document) return b[c] + "Hidden";
    return null
}

function isHidden() {
    var b = getHiddenProp();
    return !b ? !1 : document[b]
}
var visProp = getHiddenProp();
if (visProp) {
    var evtname = visProp.replace(/[H|h]idden/, "") + "visibilitychange";
    document.addEventListener(evtname, visChange)
}
window.addEventListener("pagehide", function() {
    ig.soundHandler && ig.soundHandler.focusBlurMute()
}, !1);
window.addEventListener("pageshow", function() {
    ig.ua.mobile && ig.game && ig.game.resumeGame();
    ig.soundHandler && ig.soundHandler.focusBlurUnmute()
}, !1);

function visChange() {
    isHidden() ? ig.soundHandler && ig.soundHandler.focusBlurMute() : (ig.ua.mobile && ig.game && ig.game.resumeGame(), ig.soundHandler && ig.soundHandler.focusBlurUnmute())
}
ig.baked = !0;
ig.module("impact.impact").requires("dom.ready", "impact.loader", "impact.system", "impact.input", "impact.sound", "impact.sound-handler").defines(function() {
    ig.main = function(b, c, d, e, g, m, y) {
        ig.system = new ig.System(b, d, e, g, m || 1);
        ig.input = new ig.Input;
        ig.soundManager = new ig.SoundManager;
        ig.music = new ig.Music;
        ig.ready = !0;
        ig.soundHandler = new ig.SoundHandler;
        (new(y || ig.Loader)(c, ig.resources)).load()
    }
});
ig.baked = !0;
ig.module("impact.animation").requires("impact.timer", "impact.image").defines(function() {
    ig.AnimationSheet = ig.Class.extend({
        width: 8,
        height: 8,
        image: null,
        init: function(b, c, d) {
            this.width = c;
            this.height = d;
            this.image = new ig.Image(b)
        }
    });
    ig.Animation = ig.Class.extend({
        sheet: null,
        timer: null,
        sequence: [],
        flip: {
            x: !1,
            y: !1
        },
        pivot: {
            x: 0,
            y: 0
        },
        frame: 0,
        tile: 0,
        loopCount: 0,
        alpha: 1,
        angle: 0,
        init: function(b, c, d, e) {
            this.sheet = b;
            this.pivot = {
                x: b.width / 2,
                y: b.height / 2
            };
            this.timer = new ig.Timer;
            this.frameTime = c;
            this.sequence = d;
            this.stop = !!e;
            this.tile = this.sequence[0]
        },
        rewind: function() {
            this.timer.set();
            this.frame = this.loopCount = 0;
            this.tile = this.sequence[0];
            return this
        },
        gotoFrame: function(b) {
            this.timer.set(this.frameTime * -b - 1E-4);
            this.update()
        },
        gotoRandomFrame: function() {
            this.gotoFrame(Math.floor(Math.random() * this.sequence.length))
        },
        update: function() {
            var b = Math.floor(this.timer.delta() / this.frameTime);
            this.loopCount = Math.floor(b / this.sequence.length);
            this.frame = this.stop && 0 < this.loopCount ? this.sequence.length - 1 : b % this.sequence.length;
            this.tile = this.sequence[this.frame]
        },
        draw: function(b, c) {
            var d = Math.max(this.sheet.width, this.sheet.height);
            b > ig.system.width || c > ig.system.height || (0 > b + d || 0 > c + d) || (1 != this.alpha && (ig.system.context.globalAlpha = this.alpha), 0 == this.angle ? this.sheet.image.drawTile(b, c, this.tile, this.sheet.width, this.sheet.height, this.flip.x, this.flip.y) : (ig.system.context.save(), ig.system.context.translate(ig.system.getDrawPos(b + this.pivot.x), ig.system.getDrawPos(c + this.pivot.y)), ig.system.context.rotate(this.angle),
                this.sheet.image.drawTile(-this.pivot.x, -this.pivot.y, this.tile, this.sheet.width, this.sheet.height, this.flip.x, this.flip.y), ig.system.context.restore()), 1 != this.alpha && (ig.system.context.globalAlpha = 1))
        }
    })
});
ig.baked = !0;
ig.module("impact.entity").requires("impact.animation", "impact.impact").defines(function() {
    ig.Entity = ig.Class.extend({
        id: 0,
        settings: {},
        size: {
            x: 16,
            y: 16
        },
        offset: {
            x: 0,
            y: 0
        },
        pos: {
            x: 0,
            y: 0
        },
        last: {
            x: 0,
            y: 0
        },
        vel: {
            x: 0,
            y: 0
        },
        accel: {
            x: 0,
            y: 0
        },
        friction: {
            x: 0,
            y: 0
        },
        maxVel: {
            x: 100,
            y: 100
        },
        zIndex: 0,
        gravityFactor: 1,
        standing: !1,
        bounciness: 0,
        minBounceVelocity: 40,
        anims: {},
        animSheet: null,
        currentAnim: null,
        health: 10,
        type: 0,
        checkAgainst: 0,
        collides: 0,
        _killed: !1,
        slopeStanding: {
            min: (44).toRad(),
            max: (136).toRad()
        },
        init: function(b,
            c, d) {
            this.id = ++ig.Entity._lastId;
            this.pos.x = this.last.x = b;
            this.pos.y = this.last.y = c;
            ig.merge(this, d)
        },
        reset: function(b, c, d) {
            var e = this.constructor.prototype;
            this.pos.x = b;
            this.pos.y = c;
            this.last.x = b;
            this.last.y = c;
            this.vel.x = e.vel.x;
            this.vel.y = e.vel.y;
            this.accel.x = e.accel.x;
            this.accel.y = e.accel.y;
            this.health = e.health;
            this._killed = e._killed;
            this.standing = e.standing;
            this.type = e.type;
            this.checkAgainst = e.checkAgainst;
            this.collides = e.collides;
            ig.merge(this, d)
        },
        addAnim: function(b, c, d, e) {
            if (!this.animSheet) throw "No animSheet to add the animation " +
                b + " to.";
            c = new ig.Animation(this.animSheet, c, d, e);
            this.anims[b] = c;
            this.currentAnim || (this.currentAnim = c);
            return c
        },
        update: function() {
            this.last.x = this.pos.x;
            this.last.y = this.pos.y;
            this.vel.y += ig.game.gravity * ig.system.tick * this.gravityFactor;
            this.vel.x = this.getNewVelocity(this.vel.x, this.accel.x, this.friction.x, this.maxVel.x);
            this.vel.y = this.getNewVelocity(this.vel.y, this.accel.y, this.friction.y, this.maxVel.y);
            var b = ig.game.collisionMap.trace(this.pos.x, this.pos.y, this.vel.x * ig.system.tick, this.vel.y *
                ig.system.tick, this.size.x, this.size.y);
            this.handleMovementTrace(b);
            this.currentAnim && this.currentAnim.update()
        },
        getNewVelocity: function(b, c, d, e) {
            return c ? (b + c * ig.system.tick).limit(-e, e) : d ? (c = d * ig.system.tick, 0 < b - c ? b - c : 0 > b + c ? b + c : 0) : b.limit(-e, e)
        },
        handleMovementTrace: function(b) {
            this.standing = !1;
            b.collision.y && (0 < this.bounciness && Math.abs(this.vel.y) > this.minBounceVelocity ? this.vel.y *= -this.bounciness : (0 < this.vel.y && (this.standing = !0), this.vel.y = 0));
            b.collision.x && (this.vel.x = 0 < this.bounciness && Math.abs(this.vel.x) >
                this.minBounceVelocity ? this.vel.x * -this.bounciness : 0);
            if (b.collision.slope) {
                var c = b.collision.slope;
                if (0 < this.bounciness) {
                    var d = this.vel.x * c.nx + this.vel.y * c.ny;
                    this.vel.x = (this.vel.x - 2 * c.nx * d) * this.bounciness;
                    this.vel.y = (this.vel.y - 2 * c.ny * d) * this.bounciness
                } else d = (this.vel.x * c.x + this.vel.y * c.y) / (c.x * c.x + c.y * c.y), this.vel.x = c.x * d, this.vel.y = c.y * d, c = Math.atan2(c.x, c.y), c > this.slopeStanding.min && c < this.slopeStanding.max && (this.standing = !0)
            }
            this.pos = b.pos
        },
        draw: function() {
            this.currentAnim && this.currentAnim.draw(this.pos.x -
                this.offset.x - ig.game._rscreen.x, this.pos.y - this.offset.y - ig.game._rscreen.y)
        },
        kill: function() {
            ig.game.removeEntity(this)
        },
        receiveDamage: function(b) {
            this.health -= b;
            0 >= this.health && this.kill()
        },
        touches: function(b) {
            return !(this.pos.x >= b.pos.x + b.size.x || this.pos.x + this.size.x <= b.pos.x || this.pos.y >= b.pos.y + b.size.y || this.pos.y + this.size.y <= b.pos.y)
        },
        distanceTo: function(b) {
            var c = this.pos.x + this.size.x / 2 - (b.pos.x + b.size.x / 2);
            b = this.pos.y + this.size.y / 2 - (b.pos.y + b.size.y / 2);
            return Math.sqrt(c * c + b * b)
        },
        angleTo: function(b) {
            return Math.atan2(b.pos.y +
                b.size.y / 2 - (this.pos.y + this.size.y / 2), b.pos.x + b.size.x / 2 - (this.pos.x + this.size.x / 2))
        },
        check: function() {},
        collideWith: function() {},
        ready: function() {},
        erase: function() {}
    });
    ig.Entity._lastId = 0;
    ig.Entity.COLLIDES = {
        NEVER: 0,
        LITE: 1,
        PASSIVE: 2,
        ACTIVE: 4,
        FIXED: 8
    };
    ig.Entity.TYPE = {
        NONE: 0,
        A: 1,
        B: 2,
        BOTH: 3
    };
    ig.Entity.checkPair = function(b, c) {
        b.checkAgainst & c.type && b.check(c);
        c.checkAgainst & b.type && c.check(b);
        b.collides && c.collides && b.collides + c.collides > ig.Entity.COLLIDES.ACTIVE && ig.Entity.solveCollision(b, c)
    };
    ig.Entity.solveCollision =
        function(b, c) {
            var d = null;
            if (b.collides == ig.Entity.COLLIDES.LITE || c.collides == ig.Entity.COLLIDES.FIXED) d = b;
            else if (c.collides == ig.Entity.COLLIDES.LITE || b.collides == ig.Entity.COLLIDES.FIXED) d = c;
            b.last.x + b.size.x > c.last.x && b.last.x < c.last.x + c.size.x ? (b.last.y < c.last.y ? ig.Entity.seperateOnYAxis(b, c, d) : ig.Entity.seperateOnYAxis(c, b, d), b.collideWith(c, "y"), c.collideWith(b, "y")) : b.last.y + b.size.y > c.last.y && b.last.y < c.last.y + c.size.y && (b.last.x < c.last.x ? ig.Entity.seperateOnXAxis(b, c, d) : ig.Entity.seperateOnXAxis(c,
                b, d), b.collideWith(c, "x"), c.collideWith(b, "x"))
        };
    ig.Entity.seperateOnXAxis = function(b, c, d) {
        var e = b.pos.x + b.size.x - c.pos.x;
        d ? (d.vel.x = -d.vel.x * d.bounciness + (b === d ? c : b).vel.x, c = ig.game.collisionMap.trace(d.pos.x, d.pos.y, d == b ? -e : e, 0, d.size.x, d.size.y), d.pos.x = c.pos.x) : (d = (b.vel.x - c.vel.x) / 2, b.vel.x = -d, c.vel.x = d, d = ig.game.collisionMap.trace(b.pos.x, b.pos.y, -e / 2, 0, b.size.x, b.size.y), b.pos.x = Math.floor(d.pos.x), b = ig.game.collisionMap.trace(c.pos.x, c.pos.y, e / 2, 0, c.size.x, c.size.y), c.pos.x = Math.ceil(b.pos.x))
    };
    ig.Entity.seperateOnYAxis = function(b, c, d) {
        var e = b.pos.y + b.size.y - c.pos.y;
        if (d) {
            c = b === d ? c : b;
            d.vel.y = -d.vel.y * d.bounciness + c.vel.y;
            var g = 0;
            d == b && Math.abs(d.vel.y - c.vel.y) < d.minBounceVelocity && (d.standing = !0, g = c.vel.x * ig.system.tick);
            b = ig.game.collisionMap.trace(d.pos.x, d.pos.y, g, d == b ? -e : e, d.size.x, d.size.y);
            d.pos.y = b.pos.y;
            d.pos.x = b.pos.x
        } else ig.game.gravity && (c.standing || 0 < b.vel.y) ? (d = ig.game.collisionMap.trace(b.pos.x, b.pos.y, 0, -(b.pos.y + b.size.y - c.pos.y), b.size.x, b.size.y), b.pos.y = d.pos.y, 0 < b.bounciness &&
            b.vel.y > b.minBounceVelocity ? b.vel.y *= -b.bounciness : (b.standing = !0, b.vel.y = 0)) : (d = (b.vel.y - c.vel.y) / 2, b.vel.y = -d, c.vel.y = d, g = c.vel.x * ig.system.tick, d = ig.game.collisionMap.trace(b.pos.x, b.pos.y, g, -e / 2, b.size.x, b.size.y), b.pos.y = d.pos.y, b = ig.game.collisionMap.trace(c.pos.x, c.pos.y, 0, e / 2, c.size.x, c.size.y), c.pos.y = b.pos.y)
    }
});
ig.baked = !0;
ig.module("impact.map").defines(function() {
    ig.Map = ig.Class.extend({
        tilesize: 8,
        width: 1,
        height: 1,
        data: [
            []
        ],
        name: null,
        init: function(b, c) {
            this.tilesize = b;
            this.data = c;
            this.height = c.length;
            this.width = c[0].length;
            this.pxWidth = this.width * this.tilesize;
            this.pxHeight = this.height * this.tilesize
        },
        getTile: function(b, c) {
            var d = Math.floor(b / this.tilesize),
                e = Math.floor(c / this.tilesize);
            return 0 <= d && d < this.width && 0 <= e && e < this.height ? this.data[e][d] : 0
        },
        setTile: function(b, c, d) {
            b = Math.floor(b / this.tilesize);
            c = Math.floor(c /
                this.tilesize);
            0 <= b && b < this.width && 0 <= c && c < this.height && (this.data[c][b] = d)
        }
    })
});
ig.baked = !0;
ig.module("impact.collision-map").requires("impact.map").defines(function() {
    ig.CollisionMap = ig.Map.extend({
        lastSlope: 1,
        tiledef: null,
        init: function(b, c, g) {
            this.parent(b, c);
            this.tiledef = g || ig.CollisionMap.defaultTileDef;
            for (var m in this.tiledef) m | 0 > this.lastSlope && (this.lastSlope = m | 0)
        },
        trace: function(b, c, g, m, y, s) {
            var t = {
                    collision: {
                        x: !1,
                        y: !1,
                        slope: !1
                    },
                    pos: {
                        x: b,
                        y: c
                    },
                    tile: {
                        x: 0,
                        y: 0
                    }
                },
                v = Math.ceil(Math.max(Math.abs(g), Math.abs(m)) / this.tilesize);
            if (1 < v)
                for (var r = g / v, l = m / v, n = 0; n < v && (r || l) && !(this._traceStep(t,
                    b, c, r, l, y, s, g, m, n), b = t.pos.x, c = t.pos.y, t.collision.x && (g = r = 0), t.collision.y && (m = l = 0), t.collision.slope); n++);
            else this._traceStep(t, b, c, g, m, y, s, g, m, 0);
            return t
        },
        _traceStep: function(b, c, g, m, y, s, t, v, r, l) {
            b.pos.x += m;
            b.pos.y += y;
            var n = 0;
            if (m) {
                var p = 0 < m ? s : 0,
                    A = 0 > m ? this.tilesize : 0,
                    n = Math.max(Math.floor(g / this.tilesize), 0),
                    E = Math.min(Math.ceil((g + t) / this.tilesize), this.height);
                m = Math.floor((b.pos.x + p) / this.tilesize);
                var C = Math.floor((c + p) / this.tilesize);
                if (0 < l || m == C || 0 > C || C >= this.width) C = -1;
                if (0 <= m && m < this.width)
                    for (var G =
                        n; G < E && !(-1 != C && (n = this.data[G][C], 1 < n && n <= this.lastSlope && this._checkTileDef(b, n, c, g, v, r, s, t, C, G))); G++)
                        if (n = this.data[G][m], 1 == n || n > this.lastSlope || 1 < n && this._checkTileDef(b, n, c, g, v, r, s, t, m, G)) {
                            if (1 < n && n <= this.lastSlope && b.collision.slope) break;
                            b.collision.x = !0;
                            b.tile.x = n;
                            c = b.pos.x = m * this.tilesize - p + A;
                            v = 0;
                            break
                        }
            }
            if (y) {
                p = 0 < y ? t : 0;
                y = 0 > y ? this.tilesize : 0;
                n = Math.max(Math.floor(b.pos.x / this.tilesize), 0);
                A = Math.min(Math.ceil((b.pos.x + s) / this.tilesize), this.width);
                G = Math.floor((b.pos.y + p) / this.tilesize);
                E = Math.floor((g + p) / this.tilesize);
                if (0 < l || G == E || 0 > E || E >= this.height) E = -1;
                if (0 <= G && G < this.height)
                    for (m = n; m < A && !(-1 != E && (n = this.data[E][m], 1 < n && n <= this.lastSlope && this._checkTileDef(b, n, c, g, v, r, s, t, m, E))); m++)
                        if (n = this.data[G][m], 1 == n || n > this.lastSlope || 1 < n && this._checkTileDef(b, n, c, g, v, r, s, t, m, G)) {
                            if (1 < n && n <= this.lastSlope && b.collision.slope) break;
                            b.collision.y = !0;
                            b.tile.y = n;
                            b.pos.y = G * this.tilesize - p + y;
                            break
                        }
            }
        },
        _checkTileDef: function(b, c, g, m, y, s, t, v, r, l) {
            var n = this.tiledef[c];
            if (!n) return !1;
            c = (n[2] -
                n[0]) * this.tilesize;
            var p = (n[3] - n[1]) * this.tilesize,
                A = n[4];
            t = g + y + (0 > p ? t : 0) - (r + n[0]) * this.tilesize;
            v = m + s + (0 < c ? v : 0) - (l + n[1]) * this.tilesize;
            if (0 < c * v - p * t) {
                if (0 > y * -p + s * c) return A;
                r = Math.sqrt(c * c + p * p);
                l = p / r;
                r = -c / r;
                var E = t * l + v * r,
                    n = l * E,
                    E = r * E;
                if (n * n + E * E >= y * y + s * s) return A || 0.5 > c * (v - s) - p * (t - y);
                b.pos.x = g + y - n;
                b.pos.y = m + s - E;
                b.collision.slope = {
                    x: c,
                    y: p,
                    nx: l,
                    ny: r
                };
                return !0
            }
            return !1
        }
    });
    var b = 1 / 3,
        c = 2 / 3;
    ig.CollisionMap.defaultTileDef = {
        5: [0, 1, 1, c, !0],
        6: [0, c, 1, b, !0],
        7: [0, b, 1, 0, !0],
        3: [0, 1, 1, 0.5, !0],
        4: [0, 0.5, 1, 0, !0],
        2: [0,
            1, 1, 0, !0
        ],
        10: [0.5, 1, 1, 0, !0],
        21: [0, 1, 0.5, 0, !0],
        32: [c, 1, 1, 0, !0],
        43: [b, 1, c, 0, !0],
        54: [0, 1, b, 0, !0],
        27: [0, 0, 1, b, !0],
        28: [0, b, 1, c, !0],
        29: [0, c, 1, 1, !0],
        25: [0, 0, 1, 0.5, !0],
        26: [0, 0.5, 1, 1, !0],
        24: [0, 0, 1, 1, !0],
        11: [0, 0, 0.5, 1, !0],
        22: [0.5, 0, 1, 1, !0],
        33: [0, 0, b, 1, !0],
        44: [b, 0, c, 1, !0],
        55: [c, 0, 1, 1, !0],
        16: [1, b, 0, 0, !0],
        17: [1, c, 0, b, !0],
        18: [1, 1, 0, c, !0],
        14: [1, 0.5, 0, 0, !0],
        15: [1, 1, 0, 0.5, !0],
        13: [1, 1, 0, 0, !0],
        8: [0.5, 1, 0, 0, !0],
        19: [1, 1, 0.5, 0, !0],
        30: [b, 1, 0, 0, !0],
        41: [c, 1, b, 0, !0],
        52: [1, 1, c, 0, !0],
        38: [1, c, 0, 1, !0],
        39: [1, b, 0, c, !0],
        40: [1, 0,
            0, b, !0
        ],
        36: [1, 0.5, 0, 1, !0],
        37: [1, 0, 0, 0.5, !0],
        35: [1, 0, 0, 1, !0],
        9: [1, 0, 0.5, 1, !0],
        20: [0.5, 0, 0, 1, !0],
        31: [1, 0, c, 1, !0],
        42: [c, 0, b, 1, !0],
        53: [b, 0, 0, 1, !0],
        12: [0, 0, 1, 0, !1],
        23: [1, 1, 0, 1, !1],
        34: [1, 0, 1, 1, !1],
        45: [0, 1, 0, 0, !1]
    };
    ig.CollisionMap.staticNoCollision = {
        trace: function(b, c, g, m) {
            return {
                collision: {
                    x: !1,
                    y: !1,
                    slope: !1
                },
                pos: {
                    x: b + g,
                    y: c + m
                },
                tile: {
                    x: 0,
                    y: 0
                }
            }
        }
    }
});
ig.baked = !0;
ig.module("impact.background-map").requires("impact.map", "impact.image").defines(function() {
    ig.BackgroundMap = ig.Map.extend({
        tiles: null,
        scroll: {
            x: 0,
            y: 0
        },
        distance: 1,
        repeat: !1,
        tilesetName: "",
        foreground: !1,
        enabled: !0,
        preRender: !1,
        preRenderedChunks: null,
        chunkSize: 512,
        debugChunks: !1,
        anims: {},
        init: function(b, c, d) {
            this.parent(b, c);
            this.setTileset(d)
        },
        setTileset: function(b) {
            this.tilesetName = b instanceof ig.Image ? b.path : b;
            this.tiles = new ig.Image(this.tilesetName);
            this.preRenderedChunks = null
        },
        setScreenPos: function(b,
            c) {
            this.scroll.x = b / this.distance;
            this.scroll.y = c / this.distance
        },
        preRenderMapToChunks: function() {
            var b = this.width * this.tilesize * ig.system.scale,
                c = this.height * this.tilesize * ig.system.scale;
            this.chunkSize = Math.min(Math.max(b, c), this.chunkSize);
            var d = Math.ceil(b / this.chunkSize),
                e = Math.ceil(c / this.chunkSize);
            this.preRenderedChunks = [];
            for (var g = 0; g < e; g++) {
                this.preRenderedChunks[g] = [];
                for (var m = 0; m < d; m++) this.preRenderedChunks[g][m] = this.preRenderChunk(m, g, m == d - 1 ? b - m * this.chunkSize : this.chunkSize, g == e - 1 ?
                    c - g * this.chunkSize : this.chunkSize)
            }
        },
        preRenderChunk: function(b, c, d, e) {
            var g = d / this.tilesize / ig.system.scale + 1,
                m = e / this.tilesize / ig.system.scale + 1,
                y = b * this.chunkSize / ig.system.scale % this.tilesize,
                s = c * this.chunkSize / ig.system.scale % this.tilesize;
            b = Math.floor(b * this.chunkSize / this.tilesize / ig.system.scale);
            c = Math.floor(c * this.chunkSize / this.tilesize / ig.system.scale);
            var t = ig.$new("canvas");
            t.width = d;
            t.height = e;
            t.retinaResolutionEnabled = !1;
            e = t.getContext("2d");
            ig.System.scaleMode(t, e);
            d = ig.system.context;
            ig.system.context = e;
            for (e = 0; e < g; e++)
                for (var v = 0; v < m; v++)
                    if (e + b < this.width && v + c < this.height) {
                        var r = this.data[v + c][e + b];
                        r && this.tiles.drawTile(e * this.tilesize - y, v * this.tilesize - s, r - 1, this.tilesize)
                    }
            ig.system.context = d;
            return t
        },
        draw: function() {
            this.tiles.loaded && this.enabled && (this.preRender ? this.drawPreRendered() : this.drawTiled())
        },
        drawPreRendered: function() {
            this.preRenderedChunks || this.preRenderMapToChunks();
            var b = ig.system.getDrawPos(this.scroll.x),
                c = ig.system.getDrawPos(this.scroll.y);
            if (this.repeat) var d =
                this.width * this.tilesize * ig.system.scale,
                b = (b % d + d) % d,
                d = this.height * this.tilesize * ig.system.scale,
                c = (c % d + d) % d;
            var d = Math.max(Math.floor(b / this.chunkSize), 0),
                e = Math.max(Math.floor(c / this.chunkSize), 0),
                g = Math.ceil((b + ig.system.realWidth) / this.chunkSize),
                m = Math.ceil((c + ig.system.realHeight) / this.chunkSize),
                y = this.preRenderedChunks[0].length,
                s = this.preRenderedChunks.length;
            this.repeat || (g = Math.min(g, y), m = Math.min(m, s));
            for (var t = 0; e < m; e++) {
                for (var v = 0, r = d; r < g; r++) {
                    var l = this.preRenderedChunks[e % s][r % y],
                        n = -b + r * this.chunkSize - v,
                        p = -c + e * this.chunkSize - t;
                    ig.system.context.drawImage(l, n, p);
                    ig.Image.drawCount++;
                    this.debugChunks && (ig.system.context.strokeStyle = "#f0f", ig.system.context.strokeRect(n, p, this.chunkSize, this.chunkSize));
                    this.repeat && l.width < this.chunkSize && n + l.width < ig.system.realWidth && (v += this.chunkSize - l.width, g++)
                }
                this.repeat && l.height < this.chunkSize && p + l.height < ig.system.realHeight && (t += this.chunkSize - l.height, m++)
            }
        },
        drawTiled: function() {
            for (var b = 0, c = null, d = (this.scroll.x / this.tilesize).toInt(),
                e = (this.scroll.y / this.tilesize).toInt(), g = this.scroll.x % this.tilesize, m = this.scroll.y % this.tilesize, y = -g - this.tilesize, g = ig.system.width + this.tilesize - g, s = ig.system.height + this.tilesize - m, t = -1, m = -m - this.tilesize; m < s; t++, m += this.tilesize) {
                var v = t + e;
                if (v >= this.height || 0 > v) {
                    if (!this.repeat) continue;
                    v = (v % this.height + this.height) % this.height
                }
                for (var r = -1, l = y; l < g; r++, l += this.tilesize) {
                    b = r + d;
                    if (b >= this.width || 0 > b) {
                        if (!this.repeat) continue;
                        b = (b % this.width + this.width) % this.width
                    }
                    if (b = this.data[v][b])(c = this.anims[b -
                        1]) ? c.draw(l, m) : this.tiles.drawTile(l, m, b - 1, this.tilesize)
                }
            }
        }
    })
});
ig.baked = !0;
ig.module("impact.game").requires("impact.impact", "impact.entity", "impact.collision-map", "impact.background-map").defines(function() {
    ig.Game = ig.Class.extend({
        clearColor: "#000000",
        gravity: 0,
        screen: {
            x: 0,
            y: 0
        },
        _rscreen: {
            x: 0,
            y: 0
        },
        entities: [],
        namedEntities: {},
        collisionMap: ig.CollisionMap.staticNoCollision,
        backgroundMaps: [],
        backgroundAnims: {},
        autoSort: !1,
        sortBy: null,
        cellSize: 64,
        _deferredKill: [],
        _levelToLoad: null,
        _doSortEntities: !1,
        staticInstantiate: function() {
            this.sortBy = this.sortBy || ig.Game.SORT.Z_INDEX;
            ig.game = this;
            return null
        },
        loadLevel: function(b) {
            this.screen = {
                x: 0,
                y: 0
            };
            this.entities = [];
            this.namedEntities = {};
            for (var c = 0; c < b.entities.length; c++) {
                var d = b.entities[c];
                this.spawnEntity(d.type, d.x, d.y, d.settings)
            }
            this.sortEntities();
            this.collisionMap = ig.CollisionMap.staticNoCollision;
            this.backgroundMaps = [];
            for (c = 0; c < b.layer.length; c++)
                if (d = b.layer[c], "collision" == d.name) this.collisionMap = new ig.CollisionMap(d.tilesize, d.data);
                else {
                    var e = new ig.BackgroundMap(d.tilesize, d.data, d.tilesetName);
                    e.anims = this.backgroundAnims[d.tilesetName] || {};
                    e.repeat = d.repeat;
                    e.distance = d.distance;
                    e.foreground = !!d.foreground;
                    e.preRender = !!d.preRender;
                    e.name = d.name;
                    this.backgroundMaps.push(e)
                }
            for (c = 0; c < this.entities.length; c++) this.entities[c].ready()
        },
        loadLevelDeferred: function(b) {
            this._levelToLoad = b
        },
        getMapByName: function(b) {
            if ("collision" == b) return this.collisionMap;
            for (var c = 0; c < this.backgroundMaps.length; c++)
                if (this.backgroundMaps[c].name == b) return this.backgroundMaps[c];
            return null
        },
        getEntityByName: function(b) {
            return this.namedEntities[b]
        },
        getEntitiesByType: function(b) {
            b =
                "string" === typeof b ? ig.global[b] : b;
            for (var c = [], d = 0; d < this.entities.length; d++) {
                var e = this.entities[d];
                e instanceof b && !e._killed && c.push(e)
            }
            return c
        },
        spawnEntity: function(b, c, d, e) {
            var g = "string" === typeof b ? ig.global[b] : b;
            if (!g) throw "Can't spawn entity of type " + b;
            b = new g(c, d, e || {});
            this.entities.push(b);
            b.name && (this.namedEntities[b.name] = b);
            return b
        },
        sortEntities: function() {
            this.entities.sort(this.sortBy)
        },
        sortEntitiesDeferred: function() {
            this._doSortEntities = !0
        },
        removeEntity: function(b) {
            b.name &&
                delete this.namedEntities[b.name];
            b._killed = !0;
            b.type = ig.Entity.TYPE.NONE;
            b.checkAgainst = ig.Entity.TYPE.NONE;
            b.collides = ig.Entity.COLLIDES.NEVER;
            this._deferredKill.push(b)
        },
        run: function() {
            this.update();
            this.draw()
        },
        update: function() {
            this._levelToLoad && (this.loadLevel(this._levelToLoad), this._levelToLoad = null);
            this.updateEntities();
            this.checkEntities();
            for (var b = 0; b < this._deferredKill.length; b++) this._deferredKill[b].erase(), this.entities.erase(this._deferredKill[b]);
            this._deferredKill = [];
            if (this._doSortEntities ||
                this.autoSort) this.sortEntities(), this._doSortEntities = !1;
            for (var c in this.backgroundAnims) {
                var b = this.backgroundAnims[c],
                    d;
                for (d in b) b[d].update()
            }
        },
        updateEntities: function() {
            for (var b = 0; b < this.entities.length; b++) {
                var c = this.entities[b];
                c._killed || c.update()
            }
        },
        draw: function() {
            this.clearColor && ig.system.clear(this.clearColor);
            ig.system.context.clearRect(0, 0, ig.system.width, ig.system.height);
            this._rscreen.x = ig.system.getDrawPos(this.screen.x) / ig.system.scale;
            this._rscreen.y = ig.system.getDrawPos(this.screen.y) /
                ig.system.scale;
            var b;
            for (b = 0; b < this.backgroundMaps.length; b++) {
                var c = this.backgroundMaps[b];
                if (c.foreground) break;
                c.setScreenPos(this.screen.x, this.screen.y);
                c.draw()
            }
            this.drawEntities();
            for (b; b < this.backgroundMaps.length; b++) c = this.backgroundMaps[b], c.setScreenPos(this.screen.x, this.screen.y), c.draw()
        },
        drawEntities: function() {
            for (var b = 0; b < this.entities.length; b++) this.entities[b].draw()
        },
        checkEntities: function() {
            for (var b = {}, c = 0; c < this.entities.length; c++) {
                var d = this.entities[c];
                if (!(d.type == ig.Entity.TYPE.NONE &&
                    d.checkAgainst == ig.Entity.TYPE.NONE && d.collides == ig.Entity.COLLIDES.NEVER))
                    for (var e = {}, g = Math.floor(d.pos.y / this.cellSize), m = Math.floor((d.pos.x + d.size.x) / this.cellSize) + 1, y = Math.floor((d.pos.y + d.size.y) / this.cellSize) + 1, s = Math.floor(d.pos.x / this.cellSize); s < m; s++)
                        for (var t = g; t < y; t++)
                            if (b[s])
                                if (b[s][t]) {
                                    for (var v = b[s][t], r = 0; r < v.length; r++) d.touches(v[r]) && !e[v[r].id] && (e[v[r].id] = !0, ig.Entity.checkPair(d, v[r]));
                                    v.push(d)
                                } else b[s][t] = [d];
                else b[s] = {}, b[s][t] = [d]
            }
        }
    });
    ig.Game.SORT = {
        Z_INDEX: function(b,
            c) {
            return b.zIndex - c.zIndex
        },
        POS_X: function(b, c) {
            return b.pos.x + b.size.x - (c.pos.x + c.size.x)
        },
        POS_Y: function(b, c) {
            return b.pos.y + b.size.y - (c.pos.y + c.size.y)
        }
    }
});
ig.baked = !0;
ig.module("plugins.splash-loader").requires("impact.loader", "impact.animation").defines(function() {
    ig.SplashLoader = ig.Loader.extend({
        bgIm: new ig.Image("media/graphics/sprites/home-bg.png"),
        barIm: new ig.Image("media/graphics/sprites/bar.png"),
        baseIm: new ig.Image("media/graphics/sprites/bar-base.png"),
        bg: {
            scX: 1,
            scY: 1.005,
            twnScX: !0,
            twnScY: !0
        },
        bar: {
            scX: 1,
            scY: 1,
            twnScX: !0,
            twnScY: !0
        },
        init: function(b, c) {
            this.ctx = ig.system.context;
            this.parent(b, c);
            ig.ua.mobile; 
            // && _SETTINGS.Ad.Mobile.Preroll.Enabled && MobileAdInGamePreroll.Initialize()
        },
        end: function() {
            this.parent();
            var b = 0 <= document.URL.indexOf("localhost") ? 500 : 3E3;
            window.setTimeout("ig.system.setGame(MyGame)", b)
        },
        setupCustomAnimation: function() {
            this.customAnim = new ig.Animation(this.customAnim, 0.05, [0, 1, 2, 3, 4, 5]);
            this.customAnim.currentFrame = 0;
            ig.loadingScreen = this;
            ig.loadingScreen.animationTimer = window.setInterval("ig.loadingScreen.animate()", 100)
        },
        animate: function() {
            this.customAnim.currentFrame < this.customAnim.sequence.length ? this.customAnim.currentFrame++ : this.customAnim.currentFrame =
                0;
            this.customAnim.gotoFrame(this.customAnim.currentFrame)
        },
        tweenHolder: function(b, c, d, e) {
            !1 == this[b.targ][b.bol] ? (this[b.targ][b.inner] = this.tinyTween(this[b.targ][b.inner], c, e), this[b.targ][b.inner] == c && (this[b.targ][b.bol] = !0)) : (this[b.targ][b.inner] = this.tinyTween(this[b.targ][b.inner], d, e), this[b.targ][b.inner] == d && (this[b.targ][b.bol] = !1))
        },
        tinyTween: function(b, c, d) {
            if (b > c) return b -= d, b < c && (b = c), b;
            if (b < c) return b += d, b > c && (b = c), b;
            if (b == c) return b
        },
        drawer: function(b) {
            var c = b.ctx || ig.system.context,
                d = b.offX || 0,
                e = b.offY || 0,
                g = b.cent || !1,
                m = null == b.scX ? 1 : b.scX,
                y = null == b.scY ? 1 : b.scY,
                s = null == b.alp && 0 != b.alp ? 1 : b.alp,
                t = null == b.rot ? 0 : b.rot,
                v = b.frameX || 1,
                r = b.frameY || 1,
                l = b.frame || 0,
                n = b.pic.width / v * (l % v),
                l = b.pic.height / r * Math.floor(l / v),
                p = b.pic.width / v,
                A = b.pic.height / r,
                v = b.pic.width / v * m,
                r = b.pic.height / r * y;
            if (!(0 >= s))
                if (0 < t || 0 > m || 0 > y) {
                    var E = b.x,
                        C = b.y,
                        d = g ? -p / 2 + d : d || 0,
                        e = g ? -A / 2 + e : e || 0;
                    0 < p && 0 < A && (c.save(), c.translate(E, C), c.scale(m, y), c.rotate(2 * Math.PI / 360 * t), c.globalAlpha = s, c.drawImage(b.pic.data, n, l, p, A,
                        d, e, p, A), c.restore())
                } else E = g ? b.x - v / 2 + d : b.x + d, C = g ? b.y - r / 2 + e : b.y + e, 0 < p && 0 < A && (c.globalAlpha = s, c.drawImage(b.pic.data, n, l, p, A, E, C, v, r), c.globalAlpha = 1)
        },
        textW: function(b) {
            return this.ctxRef.measureText(b).width
        },
        textDraw: function(b) {
            var c = b.rot ? b.rot : 0,
                d = b.tx ? b.tx : 0,
                e = b.x ? b.x : 0,
                g = b.y ? b.y : 0,
                m = void 0 == b.scX ? 1 : b.scX,
                y = void 0 == b.scY ? 1 : b.scY,
                s = b.stroke ? b.stroke : !1,
                t = void 0 == b.strokeAlp ? 1 : b.strokeAlp,
                v = b.strokeColour ? b.strokeColour : "black",
                r = void 0 == b.alp ? 1 : b.alp,
                l = b.col ? b.col : this.ctx.fillStyle,
                n = b.font ||
                "dunkin",
                p = b.px || 10,
                A = b.strokeLine || 3,
                E = b.align || "center",
                C = b.ctx || ig.system.context;
            this.ctxRef = b.ctx || ig.system.context;
            C.font = p + "px " + n;
            "left" == E ? e += 0.5 * this.textW(d) : "right" == E && (e -= 0.5 * this.textW(d));
            C.save();
            b = C.measureText("M").width * y;
            C.translate(e, g + b / 2);
            C.scale(m, y);
            C.rotate(c ? 2 * Math.PI / 360 * c : 0);
            C.fillStyle = l;
            C.globalAlpha = t;
            !0 == s && (C.lineWidth = A, C.strokeStyle = v, C.strokeText(d, -this.textW(d) / 2, 0));
            C.globalAlpha = r;
            C.fillText(d, -this.textW(d) / 2, 0);
            C.restore()
        },
        draw: function() {
            this._drawStatus +=
                (this.status - this._drawStatus) / 5;
            this.textDraw({
                x: -100,
                y: -100,
                tx: "loading",
                px: 10
            });
            this.ctx.clearRect(0, 0, ig.system.width, ig.system.height);
            ig.ua.mobile ? this.bgIm.draw(0, 0) : (this.tweenHolder({
                targ: "bg",
                inner: "scX",
                bol: "twnScX"
            }, 1, 1.008, 2E-4), this.tweenHolder({
                targ: "bg",
                inner: "scY",
                bol: "twnScY"
            }, 1.008, 1, 2E-4), this.tweenHolder({
                targ: "bar",
                inner: "scX",
                bol: "twnScX"
            }, 1, 0.95, 2E-4), this.tweenHolder({
                targ: "bar",
                inner: "scY",
                bol: "twnScY"
            }, 0.95, 1, 2E-4), this.drawer({
                x: ig.system.width / 2,
                y: ig.system.height / 2,
                scX: this.bg.scX,
                scY: this.bg.scY,
                pic: this.bgIm,
                cent: !0
            }));
            this.ctx.drawImage(this.baseIm.data, 0, 0, this.baseIm.width - 1, this.baseIm.height - 1, (ig.system.width - this.baseIm.width * this.bar.scX) / 2, 540 - this.baseIm.height / 2 * this.bar.scY, this.baseIm.width * this.bar.scX, this.baseIm.height * this.bar.scY);
            0 < this._drawStatus && this.ctx.drawImage(this.barIm.data, 0, 0, this.barIm.width * this._drawStatus > this.barIm.width - 1 ? this.barIm.width - 1 : this.barIm.width * this._drawStatus, this.barIm.height, (ig.system.width - this.barIm.width * this.bar.scX) /
                2, 540 - this.barIm.height / 2 * this.bar.scY, this.barIm.width * this._drawStatus * this.bar.scX, this.barIm.height * this.bar.scY)
        }
    })
});
ig.baked = !0;
ig.module("plugins.tween").requires("impact.entity").defines(function() {
    Array.prototype.indexOf || (Array.prototype.indexOf = function(b) {
        for (var c = 0; c < this.length; ++c)
            if (this[c] === b) return c;
        return -1
    });
    ig.Entity.prototype.tweens = [];
    ig.Entity.prototype._preTweenUpdate = ig.Entity.prototype.update;
    ig.Entity.prototype.update = function() {
        this._preTweenUpdate();
        if (0 < this.tweens.length) {
            for (var b = [], c = 0; c < this.tweens.length; c++) this.tweens[c].update(), this.tweens[c].complete || b.push(this.tweens[c]);
            this.tweens =
                b
        }
    };
    ig.Entity.prototype.tween = function(b, c, d) {
        b = new ig.Tween(this, b, c, d);
        this.tweens.push(b);
        return b
    };
    ig.Entity.prototype.pauseTweens = function() {
        for (var b = 0; b < this.tweens.length; b++) this.tweens[b].pause()
    };
    ig.Entity.prototype.resumeTweens = function() {
        for (var b = 0; b < this.tweens.length; b++) this.tweens[b].resume()
    };
    ig.Entity.prototype.stopTweens = function(b) {
        for (var c = 0; c < this.tweens.length; c++) this.tweens[c].stop(b)
    };
    ig.Tween = function(b, c, d, e) {
        var g = {},
            m = {},
            y = {},
            s = 0,
            t = !1,
            v = !1,
            r = !1;
        this.duration = d;
        this.paused =
            this.complete = !1;
        this.easing = ig.Tween.Easing.Linear.EaseNone;
        this.onComplete = !1;
        this.loop = this.delay = 0;
        this.loopCount = -1;
        ig.merge(this, e);
        this.loopNum = this.loopCount;
        this.chain = function(b) {
            r = b
        };
        this.initEnd = function(b, c, d) {
            if ("object" !== typeof c[b]) d[b] = c[b];
            else
                for (subprop in c[b]) d[b] || (d[b] = {}), this.initEnd(subprop, c[b], d[b])
        };
        this.initStart = function(b, c, d, e) {
            if ("object" !== typeof d[b]) "undefined" !== typeof c[b] && (e[b] = d[b]);
            else
                for (subprop in d[b]) e[b] || (e[b] = {}), "undefined" !== typeof c[b] && this.initStart(subprop,
                    c[b], d[b], e[b])
        };
        this.start = function() {
            this.paused = this.complete = !1;
            this.loopNum = this.loopCount;
            s = 0; - 1 == b.tweens.indexOf(this) && b.tweens.push(this);
            v = !0;
            t = new ig.Timer;
            for (var d in c) this.initEnd(d, c, m);
            for (d in m) this.initStart(d, m, b, g), this.initDelta(d, y, b, m)
        };
        this.initDelta = function(b, c, d, e) {
            if ("object" !== typeof e[b]) c[b] = e[b] - d[b];
            else
                for (subprop in e[b]) c[b] || (c[b] = {}), this.initDelta(subprop, c[b], d[b], e[b])
        };
        this.propUpdate = function(b, c, d, e, g) {
            if ("object" !== typeof d[b]) c[b] = "undefined" != typeof d[b] ?
                d[b] + e[b] * g : c[b];
            else
                for (subprop in d[b]) this.propUpdate(subprop, c[b], d[b], e[b], g)
        };
        this.propSet = function(b, c, d) {
            if ("object" !== typeof c[b]) d[b] = c[b];
            else
                for (subprop in c[b]) d[b] || (d[b] = {}), this.propSet(subprop, c[b], d[b])
        };
        this.update = function() {
            if (!v) return !1;
            if (this.delay) {
                if (t.delta() < this.delay) return;
                this.delay = 0;
                t.reset()
            }
            if (this.paused || this.complete) return !1;
            var c = (t.delta() + s) / this.duration,
                c = 1 < c ? 1 : c,
                d = this.easing(c);
            for (property in y) this.propUpdate(property, b, g, y, d);
            if (1 <= c) {
                if (0 == this.loopNum ||
                    !this.loop) {
                    this.complete = !0;
                    if (this.onComplete) this.onComplete();
                    r && r.start();
                    return !1
                }
                if (this.loop == ig.Tween.Loop.Revert) {
                    for (property in g) this.propSet(property, g, b);
                    s = 0;
                    t.reset(); - 1 != this.loopNum && this.loopNum--
                } else if (this.loop == ig.Tween.Loop.Reverse) {
                    c = {};
                    d = {};
                    ig.merge(c, m);
                    ig.merge(d, g);
                    ig.merge(g, c);
                    ig.merge(m, d);
                    for (property in m) this.initDelta(property, y, b, m);
                    s = 0;
                    t.reset(); - 1 != this.loopNum && this.loopNum--
                }
            }
        };
        this.pause = function() {
            this.paused = !0;
            s += t.delta()
        };
        this.resume = function() {
            this.paused = !1;
            t.reset()
        };
        this.stop = function(b) {
            b && (this.loop = this.complete = this.paused = !1, s += d, this.update());
            this.complete = !0
        }
    };
    ig.Tween.Loop = {
        Revert: 1,
        Reverse: 2
    };
    ig.Tween.Easing = {
        Linear: {},
        Quadratic: {},
        Cubic: {},
        Quartic: {},
        Quintic: {},
        Sinusoidal: {},
        Exponential: {},
        Circular: {},
        Elastic: {},
        Back: {},
        Bounce: {}
    };
    ig.Tween.Easing.Linear.EaseNone = function(b) {
        return b
    };
    ig.Tween.Easing.Quadratic.EaseIn = function(b) {
        return b * b
    };
    ig.Tween.Easing.Quadratic.EaseOut = function(b) {
        return -b * (b - 2)
    };
    ig.Tween.Easing.Quadratic.EaseInOut =
        function(b) {
            return 1 > (b *= 2) ? 0.5 * b * b : -0.5 * (--b * (b - 2) - 1)
        };
    ig.Tween.Easing.Cubic.EaseIn = function(b) {
        return b * b * b
    };
    ig.Tween.Easing.Cubic.EaseOut = function(b) {
        return --b * b * b + 1
    };
    ig.Tween.Easing.Cubic.EaseInOut = function(b) {
        return 1 > (b *= 2) ? 0.5 * b * b * b : 0.5 * ((b -= 2) * b * b + 2)
    };
    ig.Tween.Easing.Quartic.EaseIn = function(b) {
        return b * b * b * b
    };
    ig.Tween.Easing.Quartic.EaseOut = function(b) {
        return -(--b * b * b * b - 1)
    };
    ig.Tween.Easing.Quartic.EaseInOut = function(b) {
        return 1 > (b *= 2) ? 0.5 * b * b * b * b : -0.5 * ((b -= 2) * b * b * b - 2)
    };
    ig.Tween.Easing.Quintic.EaseIn =
        function(b) {
            return b * b * b * b * b
        };
    ig.Tween.Easing.Quintic.EaseOut = function(b) {
        return (b -= 1) * b * b * b * b + 1
    };
    ig.Tween.Easing.Quintic.EaseInOut = function(b) {
        return 1 > (b *= 2) ? 0.5 * b * b * b * b * b : 0.5 * ((b -= 2) * b * b * b * b + 2)
    };
    ig.Tween.Easing.Sinusoidal.EaseIn = function(b) {
        return -Math.cos(b * Math.PI / 2) + 1
    };
    ig.Tween.Easing.Sinusoidal.EaseOut = function(b) {
        return Math.sin(b * Math.PI / 2)
    };
    ig.Tween.Easing.Sinusoidal.EaseInOut = function(b) {
        return -0.5 * (Math.cos(Math.PI * b) - 1)
    };
    ig.Tween.Easing.Exponential.EaseIn = function(b) {
        return 0 == b ? 0 : Math.pow(2,
            10 * (b - 1))
    };
    ig.Tween.Easing.Exponential.EaseOut = function(b) {
        return 1 == b ? 1 : -Math.pow(2, -10 * b) + 1
    };
    ig.Tween.Easing.Exponential.EaseInOut = function(b) {
        return 0 == b ? 0 : 1 == b ? 1 : 1 > (b *= 2) ? 0.5 * Math.pow(2, 10 * (b - 1)) : 0.5 * (-Math.pow(2, -10 * (b - 1)) + 2)
    };
    ig.Tween.Easing.Circular.EaseIn = function(b) {
        return -(Math.sqrt(1 - b * b) - 1)
    };
    ig.Tween.Easing.Circular.EaseOut = function(b) {
        return Math.sqrt(1 - --b * b)
    };
    ig.Tween.Easing.Circular.EaseInOut = function(b) {
        return 1 > (b /= 0.5) ? -0.5 * (Math.sqrt(1 - b * b) - 1) : 0.5 * (Math.sqrt(1 - (b -= 2) * b) + 1)
    };
    ig.Tween.Easing.Elastic.EaseIn =
        function(b) {
            var c, d = 0.1,
                e = 0.4;
            if (0 == b) return 0;
            if (1 == b) return 1;
            e || (e = 0.3);
            !d || 1 > d ? (d = 1, c = e / 4) : c = e / (2 * Math.PI) * Math.asin(1 / d);
            return -(d * Math.pow(2, 10 * (b -= 1)) * Math.sin(2 * (b - c) * Math.PI / e))
        };
    ig.Tween.Easing.Elastic.EaseOut = function(b) {
        var c, d = 0.1,
            e = 0.4;
        if (0 == b) return 0;
        if (1 == b) return 1;
        e || (e = 0.3);
        !d || 1 > d ? (d = 1, c = e / 4) : c = e / (2 * Math.PI) * Math.asin(1 / d);
        return d * Math.pow(2, -10 * b) * Math.sin(2 * (b - c) * Math.PI / e) + 1
    };
    ig.Tween.Easing.Elastic.EaseInOut = function(b) {
        var c, d = 0.1,
            e = 0.4;
        if (0 == b) return 0;
        if (1 == b) return 1;
        e || (e = 0.3);
        !d || 1 > d ? (d = 1, c = e / 4) : c = e / (2 * Math.PI) * Math.asin(1 / d);
        return 1 > (b *= 2) ? -0.5 * d * Math.pow(2, 10 * (b -= 1)) * Math.sin(2 * (b - c) * Math.PI / e) : 0.5 * d * Math.pow(2, -10 * (b -= 1)) * Math.sin(2 * (b - c) * Math.PI / e) + 1
    };
    ig.Tween.Easing.Back.EaseIn = function(b) {
        return b * b * (2.70158 * b - 1.70158)
    };
    ig.Tween.Easing.Back.EaseOut = function(b) {
        return (b -= 1) * b * (2.70158 * b + 1.70158) + 1
    };
    ig.Tween.Easing.Back.EaseInOut = function(b) {
        return 1 > (b *= 2) ? 0.5 * b * b * (3.5949095 * b - 2.5949095) : 0.5 * ((b -= 2) * b * (3.5949095 * b + 2.5949095) + 2)
    };
    ig.Tween.Easing.Bounce.EaseIn =
        function(b) {
            return 1 - ig.Tween.Easing.Bounce.EaseOut(1 - b)
        };
    ig.Tween.Easing.Bounce.EaseOut = function(b) {
        return (b /= 1) < 1 / 2.75 ? 7.5625 * b * b : b < 2 / 2.75 ? 7.5625 * (b -= 1.5 / 2.75) * b + 0.75 : b < 2.5 / 2.75 ? 7.5625 * (b -= 2.25 / 2.75) * b + 0.9375 : 7.5625 * (b -= 2.625 / 2.75) * b + 0.984375
    };
    ig.Tween.Easing.Bounce.EaseInOut = function(b) {
        return 0.5 > b ? 0.5 * ig.Tween.Easing.Bounce.EaseIn(2 * b) : 0.5 * ig.Tween.Easing.Bounce.EaseOut(2 * b - 1) + 0.5
    }
});
ig.baked = !0;
ig.module("plugins.url-parameters").defines(function() {
    ig.UrlParameters = ig.Class.extend({
        init: function() {
            switch (getQueryVariable("iphone")) {
                case "true":
                    ig.ua.iPhone = !0, console.log("iPhone mode")
            }
            var b = getQueryVariable("webview");
            if (b) switch (b) {
                case "true":
                    ig.ua.is_uiwebview = !0, console.log("webview mode")
            }
            if (b = getQueryVariable("debug")) switch (b) {
                case "true":
                    ig.game.showDebugMenu(), console.log("debug mode")
            }
            switch (getQueryVariable("view")) {
                case "stats":
                    ig.game.resetPlayerStats(), ig.game.endGame()
            }
            getQueryVariable("ad")
        }
    })
});
ig.baked = !0;
ig.module("plugins.jukebox").defines(function() {
    ig.Jukebox = ig.Class.extend({
        init: function() {
            this.player = new jukebox.Player({
                resources: ["media/audio/bgm.mp3", "media/audio/bgm.ogg"],
                autoplay: !1,
                spritemap: {
                    music: {
                        start: 0,
                        end: 11.4,
                        loop: !0
                    }
                },
                timeout: 1E3
            })
        }
    })
});
ig.baked = !0;
ig.module("plugins.director").requires("impact.impact").defines(function() {
    ig.Director = ig.Class.extend({
        init: function(b, c) {
            this.game = b;
            this.levels = [];
            this.currentLevel = 0;
            this.append(c)
        },
        loadLevel: function(b) {
            for (key in dynamicClickableEntityDivs) ig.game.hideOverlay([key]);
            this.currentLevel = b;
            this.game.loadLevel(this.levels[b]);
            return !0
        },
        loadLevelWithoutEntities: function(b) {
            this.currentLevel = b;
            this.game.loadLevelWithoutEntities(this.levels[b]);
            return !0
        },
        append: function(b) {
            newLevels = [];
            return "object" ===
                typeof b ? (b.constructor === [].constructor ? newLevels = b : newLevels[0] = b, this.levels = this.levels.concat(newLevels), !0) : !1
        },
        nextLevel: function() {
            return this.currentLevel + 1 < this.levels.length ? this.loadLevel(this.currentLevel + 1) : !1
        },
        previousLevel: function() {
            return 0 <= this.currentLevel - 1 ? this.loadLevel(this.currentLevel - 1) : !1
        },
        jumpTo: function(b) {
            var c = null;
            for (i = 0; i < this.levels.length; i++) this.levels[i] == b && (c = i);
            return 0 <= c ? this.loadLevel(c) : !1
        },
        firstLevel: function() {
            return this.loadLevel(0)
        },
        lastLevel: function() {
            return this.loadLevel(this.levels.length -
                1)
        },
        reloadLevel: function() {
            return this.loadLevel(this.currentLevel)
        }
    })
});
ig.baked = !0;
ig.module("plugins.impact-storage").requires("impact.game").defines(function() {
    ig.Storage = ig.Class.extend({
        staticInstantiate: function() {
            return !ig.Storage.instance ? null : ig.Storage.instance
        },
        init: function() {
            ig.Storage.instance = this
        },
        isCapable: function() {
            return "undefined" !== typeof window.localStorage
        },
        isSet: function(b) {
            return null !== this.get(b)
        },
        initUnset: function(b, c) {
            null === this.get(b) && this.set(b, c)
        },
        get: function(b) {
            if (!this.isCapable()) return null;
            try {
                return JSON.parse(localStorage.getItem(b))
            } catch (c) {
                return window.localStorage.getItem(b)
            }
        },
        getInt: function(b) {
            return ~~this.get(b)
        },
        getFloat: function(b) {
            return parseFloat(this.get(b))
        },
        getBool: function(b) {
            return !!this.get(b)
        },
        key: function(b) {
            return this.isCapable() ? window.localStorage.key(b) : null
        },
        set: function(b, c) {
            if (!this.isCapable()) return null;
            try {
                window.localStorage.setItem(b, JSON.stringify(c))
            } catch (d) {
                console.log(d)
            }
        },
        setHighest: function(b, c) {
            c > this.getFloat(b) && this.set(b, c)
        },
        remove: function(b) {
            if (!this.isCapable()) return null;
            window.localStorage.removeItem(b)
        },
        clear: function() {
            if (!this.isCapable()) return null;
            window.localStorage.clear()
        }
    })
});
this.START_BRANDING_SPLASH;
ig.baked = !0;
ig.module("plugins.branding.splash").requires("impact.impact", "impact.entity").defines(function() {
    ig.BrandingSplash = ig.Class.extend({
        init: function() {
            ig.game.spawnEntity(EntityBranding, 0, 0)
        }
    });
    EntityBranding = ig.Entity.extend({
        gravityFactor: 0,
        size: {
            x: 32,
            y: 32
        },
        splash: new ig.Image("branding/splash1.png"),
        init: function(b, c, d) {
            this.parent(b, c, d);
            320 >= ig.system.width ? (this.size.x = 320, this.size.y = 200) : (this.size.x = 480, this.size.y = 240);
            this.pos.x = (ig.system.width - this.size.x) / 2;
            this.pos.y = -this.size.y - 200;
            this.endPosY = (ig.system.height - this.size.y) / 2;
            b = this.tween({
                pos: {
                    y: this.endPosY
                }
            }, 0.5, {
                easing: ig.Tween.Easing.Bounce.EaseIn
            });
            c = this.tween({}, 2.5, {
                onComplete: function() {
                    ig.game.director.loadLevel(ig.game.director.currentLevel)
                }
            });
            b.chain(c);
            b.start();
            this.currentAnim = this.anims.idle
        },
        createClickableLayer: function() {
            console.log("Build clickable layer");
            this.checkClickableLayer("branding-splash", _SETTINGS.Branding.Logo.Link, _SETTINGS.Branding.Logo.NewWindow)
        },
        doesClickableLayerExist: function(b) {
            for (k in dynamicClickableEntityDivs)
                if (k ==
                    b) return !0;
            return !1
        },
        checkClickableLayer: function(b, c, d) {
            "undefined" == typeof wm && (this.doesClickableLayerExist(b) ? (ig.game.showOverlay([b]), $("#" + b).find("[href]").attr("href", c)) : this.createClickableOutboundLayer(b, c, "media/graphics/misc/invisible.png", d))
        },
        createClickableOutboundLayer: function(b, c, d, e) {
            var g = ig.$new("div");
            g.id = b;
            document.body.appendChild(g);
            $("#" + g.id).css("float", "left");
            $("#" + g.id).css("position", "absolute");
            if (ig.ua.mobile) {
                var m = window.innerHeight / mobileHeight,
                    y = window.innerWidth /
                    mobileWidth;
                $("#" + g.id).css("left", this.pos.x * y);
                $("#" + g.id).css("top", this.pos.y * m);
                $("#" + g.id).css("width", this.size.x * y);
                $("#" + g.id).css("height", this.size.y * m)
            } else m = w / 2 - destW / 2, y = h / 2 - destH / 2, console.log(m, y), $("#" + g.id).css("left", m + this.pos.x * multiplier), $("#" + g.id).css("top", y + this.pos.y * multiplier), $("#" + g.id).css("width", this.size.x * multiplier), $("#" + g.id).css("height", this.size.y * multiplier);
            e ? $("#" + g.id).html("<a target='_blank' href='" + c + "'><img style='width:100%;height:100%' src='" +
                d + "'></a>") : $("#" + g.id).html("<a href='" + c + "'><img style='width:100%;height:100%' src='" + d + "'></a>");
            dynamicClickableEntityDivs[b] = {};
            dynamicClickableEntityDivs[b].width = this.size.x * multiplier;
            dynamicClickableEntityDivs[b].height = this.size.y * multiplier;
            dynamicClickableEntityDivs[b].entity_pos_x = this.pos.x;
            dynamicClickableEntityDivs[b].entity_pos_y = this.pos.y
        },
        draw: function() {
            ig.system.context.fillStyle = "#ffffff";
            ig.system.context.fillRect(0, 0, ig.system.width, ig.system.height);
            ig.system.context.fillStyle =
                "#000";
            ig.system.context.font = "12px Arial";
            320 >= ig.system.width ? ig.system.context.fillText("powered by MarketJS.com", ig.system.width - 150, ig.system.height - 15) : ig.system.context.fillText("powered by MarketJS.com", ig.system.width - 160, ig.system.height - 15);
            this.parent();
            this.splash && ig.system.context.drawImage(this.splash.data, 0, 0, this.splash.data.width, this.splash.data.height, this.pos.x, this.pos.y, this.size.x, this.size.y)
        }
    })
});
this.END_BRANDING_SPLASH;
ig.baked = !0;
ig.module("game.entities.branding-logo-placeholder").requires("impact.entity").defines(function() {
    EntityBrandingLogoPlaceholder = ig.Entity.extend({
        gravityFactor: 0,
        size: {
            x: 32,
            y: 32
        },
        _wmDrawBox: !0,
        _wmBoxColor: "rgba(0, 0, 255, 0.7)",
        init: function(b, c, d) {
            this.parent(b, c, d);
            if (d) switch (console.log("settings found ... using that div layer name"), b = d.div_layer_name, console.log("settings.centralize:", d.centralize), d.centralize) {
                case "true":
                    console.log("centralize true");
                    centralize = !0;
                    break;
                case "false":
                    console.log("centralize false");
                    centralize = !1;
                    break;
                default:
                    console.log("default ... centralize false"), centralize = !1
            } else b = "branding-logo", centralize = !1;
            if ("undefined" == typeof wm) {
                if (_SETTINGS.Branding.Logo.Enabled) try {
                    ig.game.spawnEntity(EntityBrandingLogo, this.pos.x, this.pos.y, {
                        div_layer_name: b,
                        centralize: centralize
                    })
                } catch (e) {
                    console.log(e)
                }
                this.kill()
            }
        }
    })
});
this.START_BRANDING_LOGO;
ig.baked = !0;
ig.module("game.entities.branding-logo").requires("impact.entity").defines(function() {
    EntityBrandingLogo = ig.Entity.extend({
        gravityFactor: 0,
        logo: new ig.AnimationSheet("branding/logo.png", _SETTINGS.Branding.Logo.Width, _SETTINGS.Branding.Logo.Height),
        size: {
            x: 32,
            y: 32
        },
        zIndex: 10001,
        init: function(b, c, d) {
            this.parent(b, c, d);
            "undefined" == typeof wm && (_SETTINGS.Branding.Logo.Enabled ? (this.size.x = _SETTINGS.Branding.Logo.Width, this.size.y = _SETTINGS.Branding.Logo.Height, d && d.centralize && (this.pos.x = ig.system.width /
                2 - this.size.x / 2, console.log("centralize true ... centering branded logo ..."))) : this.kill());
            this.anims.idle = new ig.Animation(this.logo, 0, [0], !0);
            this.currentAnim = this.anims.idle;
            d ? (console.log("branding settings found ... using that div layer name"), b = d.div_layer_name) : b = "branding-logo";
            _SETTINGS.Branding.Logo.LinkEnabled && (console.log("logo link enabled"), this.checkClickableLayer(b, _SETTINGS.Branding.Logo.Link, _SETTINGS.Branding.Logo.NewWindow));
            console.log("branding logo spawed ...")
        },
        doesClickableLayerExist: function(b) {
            for (k in dynamicClickableEntityDivs)
                if (k ==
                    b) return !0;
            return !1
        },
        checkClickableLayer: function(b, c, d) {
            "undefined" == typeof wm && (this.doesClickableLayerExist(b) ? (ig.game.showOverlay([b]), $("#" + b).find("[href]").attr("href", c)) : this.createClickableOutboundLayer(b, c, "media/graphics/misc/invisible.png", d))
        },
        createClickableOutboundLayer: function(b, c, d, e) {
            var g = ig.$new("div");
            g.id = b;
            document.body.appendChild(g);
            $("#" + g.id).css("float", "left");
            $("#" + g.id).css("position", "absolute");
            if (ig.ua.mobile) {
                var m = window.innerHeight / mobileHeight,
                    y = window.innerWidth /
                    mobileWidth;
                $("#" + g.id).css("left", this.pos.x * y);
                $("#" + g.id).css("top", this.pos.y * m);
                $("#" + g.id).css("width", this.size.x * y);
                $("#" + g.id).css("height", this.size.y * m)
            } else m = w / 2 - destW / 2, y = h / 2 - destH / 2, console.log(m, y), $("#" + g.id).css("left", m + this.pos.x * multiplier), $("#" + g.id).css("top", y + this.pos.y * multiplier), $("#" + g.id).css("width", this.size.x * multiplier), $("#" + g.id).css("height", this.size.y * multiplier);
            e ? $("#" + g.id).html("<a target='_blank' href='" + c + "'><img style='width:100%;height:100%' src='" +
                d + "'></a>") : $("#" + g.id).html("<a href='" + c + "'><img style='width:100%;height:100%' src='" + d + "'></a>");
            dynamicClickableEntityDivs[b] = {};
            dynamicClickableEntityDivs[b].width = this.size.x * multiplier;
            dynamicClickableEntityDivs[b].height = this.size.y * multiplier;
            dynamicClickableEntityDivs[b].entity_pos_x = this.pos.x;
            dynamicClickableEntityDivs[b].entity_pos_y = this.pos.y
        }
    })
});
this.END_BRANDING_LOGO;
ig.baked = !0;
ig.module("game.entities.plain").requires("impact.entity").defines(function() {
    EntityPlain = ig.Entity.extend({
        redraw: !1,
        sc: {
            x: 1,
            y: 1
        },
        maxVel: {
            x: 5E3,
            y: 5E3
        },
        sheetX: 1,
        sheetY: 1,
        gravityFactor: 0,
        clearColor: null,
        tweening: !1,
        which: 0,
        size: {
            x: 50,
            y: 50
        },
        halfSize: {
            x: 50,
            y: 50
        },
        ctxRef: null,
        init: function(b, c, d) {
            this.parent(b, c, d);
            ig.global.wm || (this.ctx = ig.system.context)
        },
        circleHitTest: function(b, c, d, e, g, m) {
            b -= e;
            c -= g;
            return Math.sqrt(b * b + c * c) < d + m ? !0 : !1
        },
        getSize: function(b) {
            this.size.x = this[b].width;
            this.size.y = this[b].height;
            this.halfSize.x = this[b].width / 2;
            this.halfSize.y = this[b].height / 2
        },
        ready: function() {
            this.parent();
            this.main = ig.game.getEntitiesByType(EntityPlainGame)[0];
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0]
        },
        soundLooper: function(b) {
            null == this[b + "sTimer"] && (this[b + "sTimer"] = new ig.Timer, this[b + "sTime"] = this.sLoop[b].duration, this.sounder(b));
            this[b + "sTimer"].delta() > this[b + "sTime"] && (this[b + "sTimer"].reset(), this.sounder(b))
        },
        soundLoopReset: function(b) {
            this[b + "sTimer"].reset()
        },
        sounder: function(b) {
            try {
                ig.soundHandler.playSound(ig.soundHandler.SOUNDID[b])
            } catch (c) {
                console.log(c)
            }
        },
        posXY: function(b) {
            b.pos.x = this.pointer.pos.x;
            b.pos.y = this.pointer.pos.y;
            console.log(this.pos.x, this.pos.y)
        },
        resetFrame: function(b) {
            this[b].ended = !1;
            this[b].frame = 0
        },
        runAnim: function(b) {
            void 0 == this[b] && (this[b] = {});
            this[b].ended = this[b].ended || !1;
            this[b].loop = this[b].loop || !1;
            this[b].frame = this[b].frame || 0;
            this[b].frameTimer = this[b].frameTimer || new ig.Timer;
            this[b].frameTime = this[b].frameTime || 0.03;
            !0 != this[b].ended && (!1 == this[b].loop && this[b].frame == this[b].frames.length - 1 ? (this[b].ended = !0, this.done &&
                this.done(b)) : 1 < this[b].frames.length && this[b].frameTimer.delta() > this[b].frameTime && (this[b].frameTimer.reset(), this[b].frame = (this[b].frame + 1) % this[b].frames.length))
        },
        tweener: function(b, c, d, e, g) {
            var m = {};
            m[b] = c;
            null == g && (g = 0);
            null == e && (e = "none");
            this.tween("this" == b ? c : m, d, {
                delay: g,
                targ: b,
                seq: e,
                onComplete: function() {
                    null != e && this.tweenF(e, b)
                }.bind(this),
                easing: ig.Tween.Easing.Quadratic.EaseOut
            }).start()
        },
        tweener2: function(b, c, d, e, g) {
            var m = {};
            m[b] = c;
            null == g && (g = 0);
            null == e && (e = "none");
            this.tween("this" ==
                b ? c : m, d, {
                    delay: g,
                    targ: b,
                    seq: e,
                    onComplete: function() {
                        null != e && this.tweenF(e, b)
                    }.bind(this),
                    easing: ig.Tween.Easing.Linear.EaseNone
                }).start()
        },
        sizer: function(b, c, d, e, g, m, y, s) {
            this.size.x = b.width / c * this.base.oriSc + (y || 0);
            this.size.y = b.height / d * this.base.oriSc + (s || 0);
            !0 == m ? (this.pos.x = e - this.size.x / 2, this.pos.y = g - this.size.y / 2) : (this.pos.x = e, this.pos.y = g)
        },
        pauseT: function() {
            this.pauseTweens()
        },
        unpauseT: function() {
            this.resumeTweens()
        },
        unpause: function() {
            for (var b = 0; b < this.main.timers.length; b++) this.main.timers[b].unpause();
            this.unpauseT()
        },
        pause: function() {
            for (var b = 0; b < this.main.timers.length; b++) this.main.timers[b].pause();
            this.pauseT()
        },
        tinyTween: function(b, c, d) {
            if (b > c) return b -= d, b < c && (b = c), b;
            if (b < c) return b += d, b > c && (b = c), b;
            if (b == c) return b
        },
        clearBg: function() {
            ig.system.bgcontext.clearRect(0, 0, ig.system.width, ig.system.height);
            ig.game.redrawEntities()
        },
        centDraw: function(b, c, d, e, g) {
            this.drawer("game", b, 1, 1, 0, c, d, e, e, !0, 1, g)
        },
        ctxDrawer: function(b) {
            var c = b.ctx || ig.system.context,
                d = b.offX || 0,
                e = b.offY || 0,
                g = b.cent || !1,
                m = null == b.scX ? 1 : b.scX,
                y = null == b.scY ? 1 : b.scY,
                s = null == b.alp && 0 != b.alp ? 1 : b.alp,
                t = null == b.rot ? 0 : b.rot,
                v = b.sx,
                r = b.sy,
                l = b.sw,
                n = b.sh,
                p = l * m,
                A = n * y;
            if (!(0 >= s))
                if (0 < t || 0 > m || 0 > y) {
                    var E = b.x,
                        C = b.y,
                        d = g ? -l / 2 + d : d || 0,
                        e = g ? -n / 2 + e : e || 0;
                    0 < l && 0 < n && (c.save(), c.translate(E, C), c.scale(m, y), c.rotate(2 * Math.PI / 360 * t), c.globalAlpha = s, c.drawImage(b.pic, v, r, l, n, d, e, l, n), c.restore())
                } else E = g ? b.x - p / 2 + d : b.x + d, C = g ? b.y - A / 2 + e : b.y + e, 0 < l && 0 < n && (c.globalAlpha = s, c.drawImage(b.pic, v, r, l, n, E, C, p, A), c.globalAlpha = 1)
        },
        frameDrawer: function(b) {
            var c =
                b.ctx || ig.system.context,
                d = b.offX || 0,
                e = b.offY || 0,
                g = b.cent || !1,
                m = null == b.scX ? 1 : b.scX,
                y = null == b.scY ? 1 : b.scY,
                s = null == b.alp && 0 != b.alp ? 1 : b.alp,
                t = null == b.rot ? 0 : b.rot,
                v = b.frame.x,
                r = b.frame.y,
                l = b.frame.w,
                n = b.frame.h,
                p = l * m,
                A = n * y;
            if (!(0 >= s))
                if (0 < t || 0 > m || 0 > y) {
                    var E = b.x,
                        C = b.y,
                        d = g ? -l / 2 + d : d || 0,
                        e = g ? -n / 2 + e : e || 0;
                    0 < l && 0 < n && (c.save(), c.translate(E, C), c.scale(m, y), c.rotate(2 * Math.PI / 360 * t), c.globalAlpha = s, c.drawImage(b.pic, v, r, l, n, d, e, l, n), c.restore())
                } else E = g ? b.x - p / 2 + d : b.x + d, C = g ? b.y - A / 2 + e : b.y + e, 0 < l && 0 < n && (c.globalAlpha =
                    s, c.drawImage(b.pic, v, r, l, n, E, C, p, A), c.globalAlpha = 1)
        },
        drawer: function(b) {
            var c = b.ctx || ig.system.context,
                d = b.offX || 0,
                e = b.offY || 0,
                g = b.cent || !1,
                m = null == b.scX ? 1 : b.scX,
                y = null == b.scY ? 1 : b.scY,
                s = null == b.alp && 0 != b.alp ? 1 : b.alp,
                t = null == b.rot ? 0 : b.rot,
                v = b.frameX || 1,
                r = b.frameY || 1,
                l = b.frame || 0,
                n = b.pic.width / v * (l % v),
                l = b.pic.height / r * Math.floor(l / v),
                p = b.pic.width / v,
                A = b.pic.height / r,
                v = b.pic.width / v * m,
                r = b.pic.height / r * y;
            if (!(0 >= s))
                if (0 < t || 0 > m || 0 > y) {
                    var E = b.x,
                        C = b.y,
                        d = g ? -p / 2 + d : d || 0,
                        e = g ? -A / 2 + e : e || 0;
                    0 < p && 0 < A && (c.save(),
                        c.translate(E, C), c.scale(m, y), c.rotate(2 * Math.PI / 360 * t), c.globalAlpha = s, c.drawImage(b.pic.data, n, l, p, A, d, e, p, A), c.restore())
                } else E = g ? b.x - v / 2 + d : b.x + d, C = g ? b.y - r / 2 + e : b.y + e, 0 < p && 0 < A && (c.globalAlpha = s, c.drawImage(b.pic.data, n, l, p, A, E, C, v, r), c.globalAlpha = 1)
        },
        textSet: function(b, c, d, e) {
            this.ctxRef = e = e || ig.system.context;
            e.font = b + "px " + (d || "dunkin");
            e.fillStyle = c
        },
        textLib: function(b, c, d) {
            d = d || 0;
            this.textDraw("game", _STRINGS.Game[b][3], _STRINGS.Game[b][4], _STRINGS.Game[b][0], (c || 0) + _STRINGS.Game[b][1] - this.ctx.measureText(_STRINGS.Game[b][0]).width /
                2 * _STRINGS.Game[b][3], _STRINGS.Game[b][2] + d)
        },
        textLibLeft: function(b, c, d) {
            this.textDraw("game", _STRINGS.Game[b][3], _STRINGS.Game[b][4], _STRINGS.Game[b][0], (c || 0) + _STRINGS.Game[b][1], _STRINGS.Game[b][2] + (d || 0))
        },
        textW: function(b) {
            return this.ctxRef.measureText(b).width
        },
        textDraw: function(b) {
            var c = b.rot ? b.rot : 0,
                d = b.tx ? b.tx : 0,
                e = b.x ? b.x : 0,
                g = b.y ? b.y : 0,
                m = void 0 == b.scX ? 1 : b.scX,
                y = void 0 == b.scY ? 1 : b.scY,
                s = b.stroke ? b.stroke : !1,
                t = void 0 == b.strokeAlp ? 1 : b.strokeAlp,
                v = b.strokeColour ? b.strokeColour : "black",
                r = void 0 ==
                b.alp ? 1 : b.alp,
                l = b.col ? b.col : this.ctx.fillStyle,
                n = b.font || "dunkin",
                p = b.px || 10,
                A = b.strokeLine || 3,
                E = b.align || "center",
                C = b.ctx || ig.system.context;
            this.ctxRef = b.ctx || ig.system.context;
            C.font = p + "px " + n;
            void 0 != b.maxWidth && this.textW(d) > b.maxWidth && (y = m = b.maxWidth / this.textW(d));
            "left" == E ? e += 0.5 * this.textW(d) : "right" == E && (e -= 0.5 * this.textW(d));
            C.save();
            b = C.measureText("M").width * y;
            C.translate(e, g + b / 2);
            C.scale(m, y);
            C.rotate(c ? 2 * Math.PI / 360 * c : 0);
            C.fillStyle = l;
            C.globalAlpha = t;
            !0 == s && (C.lineWidth = A, C.strokeStyle =
                v, C.strokeText(d, -this.textW(d) / 2, 0));
            C.globalAlpha = r;
            C.fillText(d, -this.textW(d) / 2, 0);
            C.restore()
        },
        angleTo: function(b) {
            return Math.atan2(b.pos.y + b.size.y / 2 - (this.pos.y + 26 + this.size.y / 2), b.pos.x + b.size.x / 2 - (this.pos.x + this.size.x / 2))
        },
        checkStorage: function() {
            try {
                return localStorage.setItem("test", "test"), localStorage.removeItem("test"), "localStorage" in window && null !== window.localStorage
            } catch (b) {
                return !1
            }
        },
        textLeft: function(b, c, d, e, g) {
            var m = ig.system.context;
            m.save();
            var y = m.measureText("M").width *
                g;
            m.translate(c, d + y / 2);
            m.scale(e, g);
            m.fillText(b, 0, 0);
            m.restore()
        },
        shuffleArray: function(b) {
            for (var c = b.length, d, e; 0 < c;) e = Math.floor(Math.random() * c), c--, d = b[c], b[c] = b[e], b[e] = d;
            return b
        }
    })
});
ig.baked = !0;
ig.module("game.entities.button-more-games").requires("game.entities.plain").defines(function() {
    EntityButtonMoreGames = EntityPlain.extend({
        gravityFactor: 0,
        moreIm: new ig.Image("media/graphics/sprites/more.png"),
        butIm: new ig.Image("media/graphics/sprites/more.png"),
        size: {
            x: 64,
            y: 66
        },
        oriSc: 1,
        sc: 1,
        mouseSc: 0.95,
        zIndex: 1E3,
        oriPos: {
            x: 0,
            y: 0
        },
        update: function() {
            ig.global.wm || (this.parent(), !0 != this.tweening && (this.mouseSc = this.pointer.hoveringItem == this ? 1 : 0.95))
        },
        draw: function() {
            ig.global.wm || this.drawer({
                pic: this.butIm,
                x: this.pos.x + this.butIm.width / 2,
                y: this.pos.y + this.butIm.height / 2,
                scX: this.oriSc * this.sc * this.mouseSc,
                scY: this.oriSc * this.sc * this.mouseSc,
                cent: !0
            })
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.tweenF("floatUp")
        },
        tweenF: function(b) {
            switch (b) {
                case "floatUp":
                    this.tweener("pos", {
                        y: this.oriPos.y - 5
                    }, 0.8, "floatDown");
                    break;
                case "floatDown":
                    this.tweener("pos", {
                        y: this.oriPos.y + 8
                    }, 1, "floatUp")
            }
        },
        init: function(b, c, d) {
            this.parent(b, c, d);
            this.oriPos.x = b;
            this.oriPos.y = c;
            this.logo =
                new ig.AnimationSheet(this.moreIm.path, this.moreIm.width, this.moreIm.height);
            this.size.x = this.moreIm.width;
            this.size.y = this.moreIm.height;
            "undefined" == typeof wm && (_SETTINGS.MoreGames.Enabled ? (d.div_layer_name ? (console.log("settings found ... using that div layer name"), b = d.div_layer_name) : b = "more-games", console.log("div_layer_name:", b), this.checkClickableLayer(b, _SETTINGS.MoreGames.Link, _SETTINGS.MoreGames.NewWindow)) : this.kill());
            this.anims.idle = new ig.Animation(this.logo, 0, [0], !0);
            this.currentAnim =
                this.anims.idle
        },
        doesClickableLayerExist: function(b) {
            for (k in dynamicClickableEntityDivs)
                if (k == b) return console.log("clickable layer already exists ..."), !0;
            console.log("doesnt exist yet ...");
            return !1
        },
        checkClickableLayer: function(b, c, d) {
            "undefined" == typeof wm && (this.doesClickableLayerExist(b) ? (ig.game.showOverlay([b]), $("#" + b).find("[href]").attr("href", c)) : this.createClickableOutboundLayer(b, c, "media/graphics/misc/invisible.png", d))
        },
        createClickableOutboundLayer: function(b, c, d, e) {
            var g = ig.$new("div");
            g.id = b;
            document.body.appendChild(g);
            $("#" + g.id).css("float", "left");
            $("#" + g.id).css("position", "absolute");
            if (ig.ua.mobile) {
                var m = window.innerHeight / mobileHeight,
                    y = window.innerWidth / mobileWidth;
                $("#" + g.id).css("left", this.pos.x * y);
                $("#" + g.id).css("top", this.pos.y * m);
                $("#" + g.id).css("width", this.size.x * y);
                $("#" + g.id).css("height", this.size.y * m)
            } else m = document.getElementById("game").offsetLeft, y = document.getElementById("game").offsetTop, $("#" + g.id).css("left", m + this.pos.x * multiplier), $("#" + g.id).css("top",
                y + this.pos.y * multiplier), $("#" + g.id).css("width", this.size.x * multiplier), $("#" + g.id).css("height", this.size.y * multiplier);
            e ? $("#" + g.id).html("<a target='_blank' href='" + c + "'><img style='width:100%;height:100%' src='" + d + "'></a>") : $("#" + g.id).html("<a href='" + c + "'><img style='width:100%;height:100%' src='" + d + "'></a>");
            dynamicClickableEntityDivs[b] = {};
            dynamicClickableEntityDivs[b].width = this.size.x * multiplier;
            dynamicClickableEntityDivs[b].height = this.size.y * multiplier;
            dynamicClickableEntityDivs[b].entity_pos_x =
                this.pos.x;
            dynamicClickableEntityDivs[b].entity_pos_y = this.pos.y
        }
    })
});
ig.baked = !0;
ig.module("game.entities.opening-shield").requires("impact.entity").defines(function() {
    EntityOpeningShield = ig.Entity.extend({
        size: {
            x: 48,
            y: 48
        },
        move: 0,
        mIconAnim: 0,
        shieldAnim: 0,
        titleAnim: 0,
        shieldImage: new ig.Image("media/graphics/opening/shield.png"),
        mIconImage: new ig.Image("media/graphics/opening/m_icon.png"),
        titleImage: new ig.Image("media/graphics/opening/title.png"),
        init: function(b, c, d) {
            this.parent(b, c, d)
        },
        ready: function() {
            if (!ig.wm)
                if (_SETTINGS.DeveloperBranding.Splash.Enabled) {
                    this.initTimer = new ig.Timer(0.1);
                    try {
                        ig.soundHandler.playSound(ig.soundHandler.SOUNDID.openingSound)
                    } catch (b) {
                        console.log(b)
                    }
                } else ig.game.director.nextLevel(), ig.system.context.globalAlpha = 1, this.kill()
        },
        update: function() {
            this.parent();
            this.updateOriginalShieldOpening()
        },
        draw: function() {
            this.parent();
            ig.global.wm || (this.nextLevelTimer && 0 > this.nextLevelTimer.delta() && (ig.system.context.globalAlpha = -this.nextLevelTimer.delta()), this.drawOriginalShieldOpening())
        },
        updateOriginalShieldOpening: function() {
            this.initTimer && 0 < this.initTimer.delta() &&
                (this.initTimer = null, this.sheildTimer = new ig.Timer(0.05));
            this.sheildTimer && 0 < this.sheildTimer.delta() && (3 > this.shieldAnim ? (this.shieldAnim++, this.sheildTimer.reset()) : (this.sheildTimer = null, this.moveTimer = new ig.Timer(0.0010), this.mIconTimer = new ig.Timer(0.05), this.titleTimer = new ig.Timer(0.15)));
            this.moveTimer && 0 < this.moveTimer.delta() && (this.move += 0.3, this.moveTimer.reset());
            this.mIconTimer && 0 < this.mIconTimer.delta() && (12 > this.mIconAnim ? (this.mIconAnim++, this.moveTimer.reset()) : this.mIconTimer =
                null);
            this.titleTimer && 0 < this.titleTimer.delta() && (11 > this.titleAnim ? (this.titleAnim++, this.titleTimer.reset()) : (this.titleTimer = null, this.nextLevelTimer = new ig.Timer(1)));
            this.nextLevelTimer && 0 < this.nextLevelTimer.delta() && (this.nextLevelTimer = null, ig.game.director.nextLevel(), ig.system.context.globalAlpha = 1)
        },
        drawOriginalShieldOpening: function() {
            if (this.moveTimer) {
                var b = ig.system.context;
                b.save();
                var c = ig.system.width / 2,
                    d = ig.system.height / 2;
                b.translate(c, d);
                b.rotate(this.move * Math.PI / 180);
                b.beginPath();
                b.moveTo(0, 0);
                for (var e = 0, g = 1; 48 >= g; g += 1) b.lineTo(0 + 800 * Math.cos(2 * g * Math.PI / 48), 0 + 800 * Math.sin(2 * g * Math.PI / 48)), e++, 2 == e && (e = 0, b.lineTo(0, 0));
                b.translate(-c, -d);
                c = b.createRadialGradient(c, d, 100, c, d, 250);
                c.addColorStop(0, "rgba(255,255,255,0.1)");
                c.addColorStop(1, "rgba(0,0,0,0)");
                b.fillStyle = c;
                b.fill();
                b.restore()
            }
            this.shieldImage.drawTile(ig.system.width / 2 - 91, 0 - (768 - ig.system.height) / 2, this.shieldAnim, 182, 768);
            this.moveTimer && (this.mIconImage.drawTile(ig.system.width / 2 - 96, ig.system.height / 2 - 70, this.mIconAnim,
                166, 160), this.titleImage.drawTile(ig.system.width / 2 - 204, ig.system.height / 2 + 100, this.titleAnim, 409, 76));
            ig.system.context.globalAlpha = 1
        }
    })
});
ig.baked = !0;
ig.module("game.entities.opening-kitty").requires("impact.entity").defines(function() {
    EntityOpeningKitty = ig.Entity.extend({
        size: {
            x: 48,
            y: 48
        },
        kittyAnim: -1,
        kittyImage: new ig.Image("media/graphics/opening/kitty.png"),
        kittyTitleImage: new ig.Image("media/graphics/opening/kittytitle.png"),
        init: function(b, c, d) {
            this.parent(b, c, d)
        },
        ready: function() {
            if (!ig.wm)
                if (_SETTINGS.DeveloperBranding.Splash.Enabled) {
                    this.initTimer = new ig.Timer(0.1);
                    try {
                        ig.soundHandler.playSound(ig.soundHandler.SOUNDID.kittyopeningSound)
                    } catch (b) {
                        console.log(b)
                    }
                } else ig.game.director.nextLevel(),
                    ig.system.context.globalAlpha = 1, this.kill()
        },
        update: function() {
            this.parent();
            this.updateKittyOpening()
        },
        draw: function() {
            this.parent();
            ig.global.wm || (this.nextLevelTimer && 0 > this.nextLevelTimer.delta() && (ig.system.context.globalAlpha = -this.nextLevelTimer.delta()), this.drawKittyOpening())
        },
        updateKittyOpening: function() {
            this.initTimer && 0 < this.initTimer.delta() && (this.initTimer = null, this.kittyTimer = new ig.Timer(0.15));
            this.kittyTimer && 0 < this.kittyTimer.delta() && (7 > this.kittyAnim ? (this.kittyAnim++, this.kittyTimer.reset()) :
                (this.kittyTimer = null, this.nextLevelTimer = new ig.Timer(2)));
            this.nextLevelTimer && 0 < this.nextLevelTimer.delta() && (this.nextLevelTimer = null, ig.game.director.nextLevel(), ig.system.context.globalAlpha = 1)
        },
        drawKittyOpening: function() {
            var b = ig.system.context.createLinearGradient(0, 0, 0, ig.system.height);
            b.addColorStop(0, "#ffed94");
            b.addColorStop(1, "#ffcd85");
            ig.system.context.fillStyle = b;
            ig.system.context.fillRect(0, 0, ig.system.width, ig.system.height);
            0 <= this.kittyAnim && (this.kittyImage.drawTile(ig.system.width /
                2 - this.kittyImage.width / 8, ig.system.height / 2 - this.kittyImage.height / 4, this.kittyAnim, 218, 325), this.kittyTitleImage.drawTile(ig.system.width / 2 - this.kittyTitleImage.width / 2, ig.system.height / 2 + this.kittyImage.height / 4 + 10, this.kittyAnim, 380, 37));
            ig.system.context.globalAlpha = 1
        }
    })
});
ig.baked = !0;
ig.module("game.entities.pointer").requires("impact.entity").defines(function() {
    EntityPointer = ig.Entity.extend({
        type: ig.Entity.TYPE.A,
        checkAgainst: ig.Entity.TYPE.B,
        isClicking: !1,
        isHovering: !1,
        firstClick: !1,
        isReleased: !1,
        hoveringItem: null,
        objectArray: [],
        ignorePause: !0,
        zIndex: 0,
        check: function(b) {
            this.objectArray.push(b)
        },
        clickObject: function(b) {
            this.isClicking && !this.firstClick && "function" == typeof b.clicked && (b.clicked(), this.firstClick = !0);
            this.firstClick && !this.isReleased && "function" == typeof b.clicking &&
                b.clicking();
            this.firstClick && this.isReleased && "function" == typeof b.released && (b.released(), this.firstClick = !1)
        },
        update: function() {
            if (ig.ua.mobile) {
                var b = window.innerHeight / mobileHeight;
                this.pos.x = ig.input.mouse.x / (window.innerWidth / mobileWidth) - this.size.x / 2 + ig.game.screen.x;
                this.pos.y = ig.input.mouse.y / b - this.size.y / 2
            } else this.pos.x = ig.input.mouse.x - this.size.x / 2, this.pos.y = ig.input.mouse.y - this.size.y / 2;
            var b = null,
                c = -1;
            for (a = this.objectArray.length - 1; - 1 < a; a--) this.objectArray[a].zIndex > c && (c = this.objectArray[a].zIndex,
                b = this.objectArray[a]);
            null != b ? ("close" == b.name && console.log(b), null != this.hoveringItem && "function" == typeof this.hoveringItem.idle && this.hoveringItem != b && this.hoveringItem.idle(), this.hoveringItem = b, this.clickObject(b), this.objectArray = []) : null != this.hoveringItem && "function" == typeof this.hoveringItem.idle && (this.hoveringItem.idle(), this.hoveringItem = null);
            this.isClicking = ig.input.pressed("click");
            this.isReleased = ig.input.released("click")
        }
    })
});
ig.baked = !0;
ig.module("game.entities.pointer-selector").requires("game.entities.pointer").defines(function() {
    EntityPointerSelector = EntityPointer.extend({
        zIndex: 1E3,
        _wmDrawBox: !0,
        _wmBoxColor: "rgba(0, 0, 255, 0.7)",
        size: {
            x: 20,
            y: 20
        },
        init: function(b, c, d) {
            this.parent(b, c, d)
        }
    })
});
ig.baked = !0;
ig.module("game.entities.select").requires("impact.entity").defines(function() {
    EntitySelect = ig.Entity.extend({
        type: ig.Entity.TYPE.B,
        checkAgainst: ig.Entity.TYPE.A,
        collides: ig.Entity.COLLIDES.NEVER,
        canSelect: !1,
        canSelectTimerDuration: 0.35,
        zIndex: 99999,
        isHovering: !1,
        isSelected: !1,
        init: function(b, c, d) {
            this.parent(b, c, d);
            this.canSelectTimer = new ig.Timer(this.canSelectTimerDuration)
        },
        doesClickableLayerExist: function(b) {
            for (k in dynamicClickableEntityDivs)
                if (k == b) return !0;
            return !1
        },
        checkClickableLayer: function(b,
            c, d) {
            "undefined" == typeof wm && (this.doesClickableLayerExist(b) ? (ig.game.showOverlay([b]), $("#" + b).find("[href]").attr("href", c)) : this.createClickableOutboundLayer(b, c, "media/graphics/misc/invisible.png", d))
        },
        createClickableOutboundLayer: function(b, c, d, e) {
            var g = ig.$new("div");
            g.id = b;
            document.body.appendChild(g);
            $("#" + g.id).css("float", "left");
            $("#" + g.id).css("width", this.size.x * multiplier);
            $("#" + g.id).css("height", this.size.y * multiplier);
            $("#" + g.id).css("position", "absolute");
            var m = w / 2 - destW / 2,
                y = h /
                2 - destH / 2;
            w == mobileWidth ? ($("#" + g.id).css("left", this.pos.x), $("#" + g.id).css("top", this.pos.y)) : ($("#" + g.id).css("left", m + this.pos.x * multiplier), $("#" + g.id).css("top", y + this.pos.y * multiplier));
            e ? $("#" + g.id).html("<a target='_blank' href='" + c + "'><img style='width:100%;height:100%' src='" + d + "'></a>") : $("#" + g.id).html("<a href='" + c + "'><img style='width:100%;height:100%' src='" + d + "'></a>");
            dynamicClickableEntityDivs[b] = {};
            dynamicClickableEntityDivs[b].width = $("#" + g.id).width();
            dynamicClickableEntityDivs[b].height =
                $("#" + g.id).height();
            dynamicClickableEntityDivs[b].entity_pos_x = this.pos.x;
            dynamicClickableEntityDivs[b].entity_pos_y = this.pos.y
        },
        hovered: function() {
            this.isHovering = !0;
            this.dehoverOthers()
        },
        dehoverOthers: function() {
            var b = ig.game.getEntitiesByType(EntitySelect);
            for (i = 0; i < b.length; i++) b[i] != this && (b[i].isHovering = !1)
        },
        deselectOthers: function() {
            var b = ig.game.getEntitiesByType(EntitySelect);
            for (i = 0; i < b.length; i++) b[i] != this && (b[i].isSelected = !1)
        },
        update: function() {
            this.parent();
            this.canSelectTimer && 0 <
                this.canSelectTimer.delta() && (this.canSelect = !0, this.canSelectTimer = null)
        }
    })
});
ig.baked = !0;
ig.module("game.levels.opening").requires("impact.image", "game.entities.opening-kitty").defines(function() {
    LevelOpening = {
        entities: [{
            type: "EntityOpeningKitty",
            x: 520,
            y: 212
        }],
        layer: []
    }
});
ig.baked = !0;
ig.module("game.entities.plain-baby").requires("game.entities.plain").defines(function() {
    EntityPlainBaby = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 10,
        w: 800,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        im: new ig.Image("media/graphics/sprites/baby.png"),
        shadowIm: new ig.Image("media/graphics/sprites/babyshadow.png"),
        speed: {
            x: 50,
            y: 0
        },
        sheetX: 8,
        sheetY: 1,
        vel: {
            x: 0,
            y: -100
        },
        accel: {
            x: 0,
            y: 600
        },
        floorPos: 560,
        floorOffset: 10,
        drawSheetCent: function() {},
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.pointer = ig.game.getEntitiesByType(EntityPointer)[0],
                this.reGen(), this.zIndex = 2E3, ig.game.sortEntitiesDeferred(), this.zIndex = 800, this.pickWalkSide(), this.main.soundLooper("hehe"))
        },
        reGen: function() {
            this.animSheet = new ig.AnimationSheet(this.im.path, this.im.width / this.sheetX, this.im.height / this.sheetY);
            this.size.x = this.im.width / this.sheetX;
            this.size.y = this.im.height / this.sheetY;
            this.addAnim("idle", 0.1, [0, 1]);
            this.currentAnim = this.anims.idle
        },
        pickWalkSide: function() {
            this.walkEdge = 50 + 100 * Math.random()
        },
        tweenF: function() {},
        update: function() {
            !ig.global.wm &&
                !0 != this.main.gamePaused && (this.parent(), !0 == this.walkSides ? 0 < this.vel.x ? this.pos.x > ig.system.width - this.walkEdge && (this.pickWalkSide(), this.vel.x = -this.speed.x) : this.pos.x < this.walkEdge + 100 && (this.pickWalkSide(), this.vel.x = this.speed.x) : (this.pos.y > this.floorPos - this.floorOffset - 200 && ig.game.sortEntitiesDeferred(), this.pos.y > this.floorPos - this.floorOffset && (this.walkSides = !0, this.vel.y = 0, this.accel.y = 0, this.vel.x = 0.5 < 1 * Math.random() ? this.speed.x : -this.speed.x, this.pos.y = this.floorPos - this.floorOffset)))
        },
        ready: function() {},
        draw: function() {
            this.parent();
            ig.global.wm || (this.drawer({
                cent: !0,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y - 4,
                pic: this.shadowIm
            }), this.parent())
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-tile").requires("game.entities.plain", "game.entities.plain-baby").defines(function() {
    EntityPlainTile = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 100,
        name: "tile",
        renderer: !1,
        renderFrame: 0,
        tweening: !1,
        hitThunder: !1,
        baby: !1,
        iceDelay: !1,
        drawIce: !1,
        w: 800,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        causer: "pop",
        offBounce: !1,
        killDelay: 0,
        delayTime: 0.03,
        eviled: !1,
        evilActive: !1,
        tileHit: {
            x: 0,
            y: 0
        },
        evilCauser: !1,
        dropPopHeight: 420,
        iceBubble: {
            sc: 0,
            alp: 0
        },
        iceFrame: 0,
        iceEndFrame: 48,
        ice: {
            frame: 0,
            frameTime: 0.015
        },
        drawBurst: !1,
        burstFrame: 0,
        burstEndFrame: 48,
        burst: {
            frame: 0,
            frameTime: 0.015
        },
        im: new ig.Image("media/graphics/sprites/bubbles.png"),
        plusIm: new ig.Image("media/graphics/sprites/plus.png"),
        minusIm: new ig.Image("media/graphics/sprites/minus.png"),
        skullIm: new ig.Image("media/graphics/sprites/skull.png"),
        skull: {
            sc: 0,
            alp: 1
        },
        skull2: {
            sc: 0,
            alp: 0
        },
        darkAuraIm: new ig.Image("media/graphics/sprites/darkaura.png"),
        darkAura: {
            sc: 0,
            alp: 0
        },
        score: {
            sc: 0,
            alp: 0,
            gradp1: -10,
            gradp2: -3,
            offY: 0,
            tx: "normal"
        },
        sheetX: 8,
        sheetY: 4,
        angle: 0,
        sc: {
            x: 1,
            y: 1
        },
        oriPos: {
            x: 0,
            y: 0
        },
        tile: {
            x: 0,
            y: 0
        },
        offset: {
            x: 2,
            y: 4
        },
        off: {
            x: 0,
            y: 0
        },
        bouncy: {
            x: 0,
            y: 0
        },
        bubbleKilled: !1,
        linkedColours: [],
        refLinked: [],
        hanging: !0,
        killStuff: !1,
        hangingChecked: !1,
        checkedTiles: [],
        linkTeams: [],
        innerNeighbour: [
            [-1, 0],
            [1, 0],
            [0, -1],
            [1, -1],
            [0, 1],
            [1, 1]
        ],
        sideNeighbour: [
            [-1, 0],
            [1, 0],
            [-1, -1],
            [0, -1],
            [-1, 1],
            [0, 1]
        ],
        scoreChoice: {
            normal: {
                where: 0,
                tx: "10",
                sx: 5,
                sy: 205,
                sw: 50,
                sh: 50
            },
            plus: {
                where: 1,
                tx: "+3",
                sx: 65,
                sy: 205,
                sw: 50,
                sh: 50
            },
            minus: {
                where: 2,
                tx: "-3",
                sx: 125,
                sy: 205,
                sw: 50,
                sh: 50
            }
        },
        score: {
            sc: 0,
            alp: 0,
            gradp1: -10,
            gradp2: -3,
            offY: 0,
            tx: "normal"
        },
        linkedBubbleArray: [],
        killBubble: function() {
            this.tweener("this", {}, this.killDelay, "kill")
        },
        dropAndPopBubble: function() {
            this.main.resetCombo();
            this.bubble.basicArmoUpdate();
            for (var b = 0; b < this.linkTeams.length; b++)
                if (!1 == this.linkTeams[b][1])
                    for (var c = 0; c < this.linkTeams[b][0].length; c++) {
                        var d = this.linkTeams[b][0][c];
                        d.hanging = !1;
                        d.tweening = !0;
                        this.main.scoreVault += 10;
                        this.main.dropAll.total++;
                        d.vel.y = -(50 * Math.random() + 80);
                        d.accel.y = 600;
                        d.accel.x = -150 + 300 * Math.random();
                        d.zIndex = 101;
                        !0 == d.baby && this.main.babyRescued++;
                        this.main.tiles[d.tile.y][d.tile.x] = void 0
                    }
                ig.game.sortEntitiesDeferred();
            b = ig.game.getEntitiesByType(EntityPlainTile);
            for (c = 0; c < b.length; c++)!0 == b[c].bubbleKilled && (this.main.doneCombo = !1, this.main.scoreVault += 10, this.main.popAll.total++, b[c].killBubble(), !0 == b[c].baby && this.main.babyRescued++);
            if (!0 == this.hitThunder)
                for (c = 0; c < b.length; c++) b[c].tile.y >= this.tile.y && !1 == b[c].bubbleKilled && !0 == b[c].hanging && (console.log("hihihi"), b[c].hanging = !1, b[c].tweening = !0, this.main.scoreVault += 10, this.main.dropAll.total++, b[c].vel.y = -(50 * Math.random() + 80), b[c].accel.y = 600, b[c].accel.x = -150 + 300 * Math.random(), b[c].zIndex = 101, !0 == b[c].baby && this.main.babyRescued++, this.main.tiles[b[c].tile.y][b[c].tile.x] = void 0);
            this.main.showComboText();
            ig.game.redraw = !0
        },
        init: function(b, c, d) {
            if (!ig.global.wm) {
                this.main = ig.game.getEntitiesByType(EntityPlainGame)[0];
                this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
                this.parent(b, c, d);
                this.tile.x = d.i;
                this.tile.y = d.j;
                void 0 ==
                    this.main.tiles[this.tile.y] && (this.main.tiles[this.tile.y] = []);
                this.main.tiles[this.tile.y][this.tile.x] = this;
                this.aniStuff();
                this.dropPopHeight -= 100 * Math.random();
                if (void 0 != d.bubblePos) {
                    this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
                    this.main.scoreVault = 0;
                    this.oriPos.x = d.bubblePos.x - this.stage.topLeft.x;
                    this.oriPos.y = d.bubblePos.y - this.stage.pos.y - this.stage.topGap - this.stage.topLeft.y;
                    this.which = d.which;
                    this.tweenF("snap");
                    this.shooter = ig.game.getEntitiesByType(EntityPlainShooter)[0];
                    this.shooter.drawGuide = !0;
                    ig.game.redraw = !0;
                    b = ig.game.getEntitiesByType(EntityPlainTile);
                    for (c = 0; c < b.length; c++) b[c].offBounce = !0, b[c].tileHit = {
                        x: d.i,
                        y: d.j
                    }
                } else this.readPresetTile();
                this.aniStuff();
                this.pos.x = this.oriPos.x + this.stage.topLeft.x;
                this.pos.y = this.oriPos.y + this.stage.pos.y + this.stage.topLeft.y;
                this.bubbleTypeRegen();
                ig.game.sortEntitiesDeferred();
                this.burst.frames = ig.game.burstRender.frames;
                this.ice.frames = ig.game.iceRender.frames
            }
        },
        handleBubbleCheck: function() {
            this.refLinked.push(this);
            this.linkBubbles(this);
            if (!0 != this.evilActive) {
                for (var b = 0; b < this.linkedBubbleArray.length; b++)
                    for (var c = 0; c < this.linkedBubbleArray[b].length; c++)
                        if (3 <= this.linkedBubbleArray[b].length) {
                            var d = this.linkedBubbleArray[b][c];
                            !0 != d.bubbleKilled && (d.bubbleKilled = !0, d.tweening = !0, d.killDelay = (Math.abs(d.tile.x - this.tile.x) + Math.abs(d.tile.y - this.tile.y)) * this.delayTime, -1 == this.checkedTiles.indexOf(d) && this.checkedTiles.push(d), this.killStuff = !0)
                        }!0 == this.bubbleKilled && this.triggerHangingCheck();
                this.dropAndPopBubble()
            }
        },
        openLinkTeam: function(b) {
            this.linkTeams[b] = [];
            this.linkTeams[b][0] = [];
            this.linkTeams[b][1] = !1
        },
        triggerHangingCheck: function() {
            for (var b = ig.game.getEntitiesByType(EntityPlainTile), c = 0; this.checkedTiles.length != b.length && !(10 < c);)
                for (var d = 0; d < b.length; d++)
                    if (-1 == this.checkedTiles.indexOf(b[d])) {
                        this.openLinkTeam(this.linkTeams.length);
                        this.findHangingCluster(b[d], this.linkTeams[this.linkTeams.length - 1]);
                        c++;
                        break
                    }
        },
        findHangingCluster: function(b, c) {
            var d = this.getNeighbour(b.tile);
            d.push(b);
            for (var e =
                0; e < d.length; e++) - 1 == this.checkedTiles.indexOf(d[e]) && (!0 == d[e].bubbleKilled ? this.checkedTiles.push(d[e]) : (0 == d[e].tile.y && (c[1] = !0), c[0].push(d[e]), this.checkedTiles.push(d[e]), this.findHangingCluster(d[e], c)))
        },
        getNeighbour: function(b) {
            for (var c = b.y % 2 == this.main.rowOffset ? this.sideNeighbour : this.innerNeighbour, d = [], e = 0; e < c.length; e++) {
                var g = b.x + c[e][0],
                    m = b.y + c[e][1];
                void 0 != this.main.tiles[m] && void 0 != this.main.tiles[m][g] && d.push(this.main.tiles[m][g])
            }
            return d
        },
        iceStuff: function() {
            if (!0 == this.hanging &&
                "pop" == this.causer)
                for (var b = this.getNeighbour(this.tile), c = 0; c < b.length; c++) "ice" == b[c].refType && (b[c].frame = this.getFrame("ice"), b[c].which = !0 == b[c].baby ? "baby" + this.refColour : this.refColour, b[c].refType = "normal", b[c].tweenF("ice"))
        },
        readPresetTile: function() {
            this.oriPos.x = this.tile.y % 2 == this.main.rowOffset ? this.tile.x * this.size.x : this.tile.x * this.size.x + this.size.x / 2;
            this.oriPos.y = this.tile.y * this.size.y;
            var b = this.main.map[this.tile.y][this.tile.x];
            "r" == b && (b = 0.05 > 1 * Math.random() ? this.main.choice[Math.floor(Math.random() *
                this.main.choice.length)] : 0.2 > 1 * Math.random() ? this.main.choice[Math.floor(Math.random() * (this.main.choice.length - 2))] : this.main.choice[Math.floor(4 * Math.random())]);
            "string" == typeof b ? (-1 < b.indexOf("baby") && (this.baby = !0, this.main.totalBaby++), this.which = -1 < b.indexOf("baby") && -1 == b.indexOf("ice") ? "baby" + this.main.colourSet[Number(b.replace("baby", ""))] : -1 < b.indexOf("minus") ? "minus" + this.main.colourSet[Number(b.replace("minus", ""))] : -1 < b.indexOf("plus") ? "plus" + this.main.colourSet[Number(b.replace("plus",
                ""))] : b) : this.which = this.main.colourSet[b]
        },
        bubbleTypeRegen: function() {
            -1 < this.which.indexOf("baby") ? ("babyice" == this.which ? (this.refType = "ice", this.refColour = "none") : (this.refType = "baby", this.refColour = this.which.replace("baby", "")), this.frame = this.getFrame(this.which)) : -1 < this.which.indexOf("plus") ? (this.refType = "plus", this.refColour = this.which.replace("plus", ""), this.frame = this.getFrame(this.refColour)) : -1 < this.which.indexOf("minus") ? (this.refType = "minus", this.refColour = this.which.replace("minus",
                ""), this.frame = this.getFrame(this.refColour)) : (-1 < this.main.bubbleColours.indexOf(this.which) ? (this.refType = "normal", this.refColour = this.which) : (this.refType = this.which, this.refColour = "none"), this.frame = this.getFrame(this.which))
        },
        aniStuff: function() {
            this.size.x = (this.im.width / this.sheetX - 4) * this.sc.x;
            this.size.y = (this.im.height / this.sheetY - 8) * this.sc.y;
            this.animList = [
                ["red", 0],
                ["orange", 1],
                ["yellow", 2],
                ["green", 3],
                ["cyan", 4],
                ["blue", 5],
                ["purple", 6],
                ["pink", 7],
                ["super", 19],
                ["babyred", 8],
                ["babyorange",
                    9
                ],
                ["babyyellow", 10],
                ["babygreen", 11],
                ["babycyan", 12],
                ["babyblue", 13],
                ["babypurple", 14],
                ["babypink", 15],
                ["ice", 16],
                ["grey", 17],
                ["babyice", 18],
                ["rainbow", 19],
                ["thunder", 20],
                ["star", 21],
                ["time", 22],
                ["bomb", 23],
                ["steel", 26],
                ["evil", 25],
                ["wood", 26],
                ["guide", 27],
                ["change", 28],
                ["pick", 29],
                ["search", 30],
                ["armo", 31]
            ]
        },
        getFrame: function(b) {
            return this.animList[this.animIndex(b)][1]
        },
        animIndex: function(b) {
            for (var c = 0; c < this.animList.length; c++)
                if (-1 < this.animList[c].indexOf(b)) return c
        },
        powerBubbleCheck: function(b,
            c) {
            if (void 0 != this.main.tiles[b.y] && this.main.tiles[b.y][b.x]) switch (this.main.tiles[b.y][b.x].which) {
                case "evil":
                    this.sounder("evil");
                    this.main.tiles[b.y][b.x].evilCauser = !0;
                    this.main.tiles[b.y][b.x].zIndex += 1;
                    ig.game.sortEntitiesDeferred();
                    this.main.tiles[b.y][b.x].tweenF("skullExpand");
                    for (var d = ig.game.getEntitiesByType(EntityPlainTile), e = 0; e < d.length; e++) d[e].killDelay = 0.05 * (Math.abs(d[e].tile.x - this.tile.x) + Math.abs(d[e].tile.y - this.tile.y)), d[e].tweenF("evil");
                    this.tweening = this.evilActive = !0;
                    break;
                case "thunder":
                    for (e = 0; e < this.main.tiles[b.y].length; e++) void 0 != this.main.tiles[b.y] && void 0 != this.main.tiles[b.y][e] && (this.main.tiles[b.y][e].causer = "thunder", this.main.tiles[b.y][e].bubbleKilled = !0, this.main.tiles[b.y][e].tweening = !0, this.main.tiles[b.y][e].killDelay = Math.abs(e - b.x) * this.delayTime);
                    this.main.tiles[c.y][c.x].bubbleKilled = !0;
                    this.main.tiles[c.y][c.x].tweening = !0;
                    this.main.tiles[b.y][b.x].killDelay = (Math.abs(this.main.tiles[b.y][b.x].tile.x - this.tile.x) + Math.abs(this.main.tiles[b.y][b.x].tile.y -
                        this.tile.y)) * this.delayTime;
                    this.tweening = this.hitThunder = !0;
                    break;
                case "star":
                    d = ig.game.getEntitiesByType(EntityPlainTile);
                    for (e = 0; e < d.length; e++) d[e].refColour == this.refColour && (-1 == this.checkedTiles.indexOf(d[e]) && this.checkedTiles.push(d[e]), d[e].causer = "star", d[e].bubbleKilled = !0, d[e].tweening = !0, d[e].killDelay = (Math.abs(d[e].tile.x - this.tile.x) + Math.abs(d[e].tile.y - this.tile.y)) * this.delayTime); - 1 == this.checkedTiles.indexOf(this.main.tiles[b.y][b.x]) && this.checkedTiles.push(this.main.tiles[b.y][b.x]);
                    this.main.tiles[b.y][b.x].bubbleKilled = !0;
                    this.main.tiles[b.y][b.x].tweening = !0;
                    this.main.tiles[b.y][b.x].killDelay = (Math.abs(this.main.tiles[b.y][b.x].tile.x - this.tile.x) + Math.abs(this.main.tiles[b.y][b.x].tile.y - this.tile.y)) * this.delayTime;
                    this.tweening = !0
            }
        },
        slotBubbles: function(b) {
            -1 == this.refLinked.indexOf(b) && this.refLinked.push(b)
        },
        slotLinkedBubble: function(b, c) {
            this.slotBubbles(c);
            for (var d = 0; d < this.linkedBubbleArray.length; d++) "super" == c.refColour ? 0 == this.linkedBubbleArray[d].length ? this.linkedBubbleArray[d].push(c) :
                -1 < this.linkedBubbleArray[d].indexOf(b) && this.linkedBubbleArray[d].push(c) : -1 < this.linkedBubbleArray[d].indexOf(b) && this.linkedColours[d] == c.refColour && this.linkedBubbleArray[d].push(c)
        },
        slotBubbleCheck: function(b, c) {
            -1 == this.refLinked.indexOf(c) && (this.slotLinkedBubble(b, c), this.linkBubbles(c))
        },
        initiateColourTeam: function(b) {
            for (var c = 0; c < this.main.bubbleColours.length - 1; c++) this.linkedColours.push(this.main.bubbleColours[c]), this.linkedBubbleArray[this.linkedBubbleArray.length] = [];
            this.slotBubbles(b);
            if ("super" == b.refColour)
                for (c = 0; c < this.linkedBubbleArray.length; c++) this.linkedBubbleArray[c].push(b);
            else
                for (c = 0; c < this.linkedBubbleArray.length; c++) this.linkedColours[c] == b.refColour && this.linkedBubbleArray[c].push(b)
        },
        linkBubbles: function(b) {
            var c = this.getNeighbour(b.tile);
            b == this && this.initiateColourTeam(b);
            for (var d = 0; d < c.length; d++) b == this && this.powerBubbleCheck(c[d].tile, b.tile), c[d].refColour == b.refColour && "super" != b.refColour ? this.slotBubbleCheck(b, c[d]) : ("super" == b.refColour || "super" ==
                c[d].refColour) && this.slotBubbleCheck(b, c[d])
        },
        tileCheck: function(b, c) {
            return void 0 != this.main.tiles[c] ? void 0 != this.main.tiles[c][b] ? !0 : !1 : !1
        },
        plusStuff: function(b) {
            switch (b) {
                case "changeScoreText":
                    "plus" == this.refType && !0 == this.hanging && (this.bubble.plusVault += 3, this.score.tx = "plus")
            }
        },
        minusStuff: function(b) {
            switch (b) {
                case "changeScoreText":
                    "minus" == this.refType && !0 == this.hanging && (this.bubble.minusVault += 3, this.score.tx = "minus")
            }
        },
        tweenF: function(b) {
            switch (b) {
                case "auraExpand":
                    this.darkAura.sc =
                        0;
                    this.darkAura.alp = 1;
                    this.tweener("darkAura", {
                        sc: 0.8
                    }, 1.8, "auraExpand");
                    this.tweener("darkAura", {
                        alp: 0
                    }, 1.3, "none", 0.5);
                    break;
                case "skullExpand":
                    this.skull.alp = 0.75;
                    this.tweener("skull", {
                        sc: 2.5
                    }, 0.8);
                    this.tweener("skull", {
                        alp: 0
                    }, 0.4, "skullFade", 0.2);
                    this.tweener("this", {}, 0.2, "skull2Expand");
                    break;
                case "skull2Expand":
                    this.skull2.alp = 1;
                    this.tweener("skull2", {
                        sc: 1.5
                    }, 2);
                    this.tweener("skull2", {
                        alp: 0
                    }, 0.3, "none", 0.3);
                    break;
                case "evil":
                    this.tweener("this", {}, this.killDelay, "evil2");
                    break;
                case "evil2":
                    this.eviled = !0;
                    this.tweener("this", {}, 1, "evilGameOver");
                    break;
                case "evilGameOver":
                    this.main.loseGame();
                    break;
                case "bounceBack":
                    this.tweener("bouncy", {
                        x: 0,
                        y: 0
                    }, 0.03);
                    break;
                case "snap":
                    this.tweening = !0;
                    this.tweener("oriPos", {
                        x: this.tile.y % 2 == this.main.rowOffset ? this.tile.x * this.size.x : this.tile.x * this.size.x + this.size.x / 2,
                        y: this.tile.y * this.size.y
                    }, 0.08, "snap2");
                    break;
                case "snap2":
                    this.tweening = !1;
                    ig.game.redraw = !0;
                    this.handleBubbleCheck();
                    break;
                case "ice":
                    this.drawIce = this.tweening = !0;
                    this.tweener("iceBubble", {
                        sc: 1.2,
                        alp: 1
                    }, 0.2, "ice3", 0.3);
                    break;
                case "ice3":
                    this.tweener("iceBubble", {
                        sc: 1
                    }, 0.1, "convertColour");
                    ig.game.redraw = !0;
                    this.bubbleTypeRegen();
                    break;
                case "convertColour":
                    this.drawIce = !1;
                    this.iceDelay = !0;
                    break;
                case "babyTall":
                    this.tweener("sc", {
                        x: 0.99,
                        y: 1.01
                    }, 1, "babyFat");
                    break;
                case "babyFat":
                    this.tweener("sc", {
                        x: 1.01,
                        y: 0.99
                    }, 1, "babyTall");
                    break;
                case "kill":
                    if (!0 == this.eviled) break;
                    this.drawBurst = !0;
                    this.main.soundLooper("bubble");
                    this.main.tiles[this.tile.y][this.tile.x] = void 0;
                    this.zIndex += 10;
                    ig.game.sortEntitiesDeferred();
                    this.vel.x = 0;
                    this.vel.y = -30;
                    this.accel.x = 0;
                    this.accel.y = 0;
                    !0 == this.baby && ig.game.spawnEntity(EntityPlainBaby, this.pos.x, this.pos.y, {
                        main: this.main
                    });
                    this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
                    this.minusStuff("changeScoreText");
                    this.plusStuff("changeScoreText");
                    this.iceStuff();
                    this.tweener("score", {
                        sc: 1.3,
                        alp: 1
                    }, 0.1, "scoreFadeOut");
                    break;
                case "scoreFadeOut":
                    this.tweener("score", {
                        alp: 0
                    }, 0.1, "killTile", 0.2);
                    this.tweener("score", {
                        offY: -20
                    }, 1);
                    break;
                case "killTile":
                    !0 == this.hanging ? this.main.popAll.killed++ :
                        this.main.dropAll.killed++, this.kill()
            }
        },
        update: function() {
            if (!ig.global.wm && (!1 == this.hanging && (this.tweening = !0), !0 != this.main.gamePaused && (!0 == this.iceDelay && !0 == ig.game.redraw && (this.iceDelay = !1, !0 == this.hanging && (this.tweening = !1)), this.parent(), void 0 != this.stage))) {
                if (!0 == this.hanging || !0 == this.bubbleKilled) this.pos.x = this.oriPos.x + this.stage.topLeft.x, this.pos.y = this.oriPos.y + this.stage.pos.y + this.stage.topGap + this.stage.topLeft.y, !0 == this.offBounce && (this.offBounce = !1, this.tweenF("collideOffset"));
                !1 == this.hanging && (this.pos.x + this.size.x > ig.system.width - 10 ? this.pos.x = ig.system.width - this.size.x - 10 : 10 > this.pos.x && (this.pos.x = 10), this.pos.y > this.dropPopHeight && !1 == this.drawBurst && this.tweenF("kill"))
            }
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            "evil" == this.which && (this.tweenF("auraExpand"), this.zIndex += 1, ig.game.sortEntitiesDeferred());
            !0 == this.baby && this.tweenF("babyFat");
            "plus" == this.refType && (this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0], this.bubble.armoExtra +=
                3)
        },
        changeBubble: function() {
            this.which = "super";
            this.frame = this.getFrame(this.which)
        },
        drawSheets: function(b) {
            this[b].update()
        },
        drawEvilStuff: function() {
            !1 == this.eviled && "evil" == this.which && (!0 == this.hanging && !1 == this.drawBurst) && this.drawer({
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                pic: this.darkAuraIm,
                scX: this.sc.x * this.darkAura.sc,
                scY: this.sc.y * this.darkAura.sc,
                cent: !0,
                alp: this.darkAura.alp
            });
            !0 == this.eviled && !1 == this.evilCauser ? this.drawer({
                pic: this.im,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y +
                    this.size.y / 2,
                frame: this.getFrame("grey"),
                frameX: this.sheetX,
                frameY: this.sheetY,
                scX: this.sc.x,
                scY: this.sc.y,
                cent: !0
            }) : !0 == this.evilCauser && (this.drawer({
                pic: this.im,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                frame: this.frame,
                frameX: this.sheetX,
                frameY: this.sheetY,
                scX: this.sc.x,
                scY: this.sc.y,
                cent: !0
            }), this.drawer({
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                pic: this.skullIm,
                scX: this.sc.x * this.skull.sc,
                scY: this.sc.y * this.skull.sc,
                cent: !0,
                alp: this.skull.alp
            }), this.drawer({
                x: this.pos.x +
                    this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                pic: this.skullIm,
                scX: this.sc.x * this.skull2.sc,
                scY: this.sc.y * this.skull2.sc,
                cent: !0,
                alp: this.skull2.alp
            }))
        },
        drawBurstStuff: function() {
            this.burst.frame < this.burstEndFrame && void 0 != ig.game.burstRender.frames[this.burst.frame] && this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2 + this.score.offY,
                sx: ig.game.burstRender.frames[Math.floor(this.burst.frame)].sx,
                sy: ig.game.burstRender.frames[Math.floor(this.burst.frame)].sy + 200 * this.scoreChoice[this.score.tx].where,
                sw: 60,
                sh: 60,
                cent: !0
            });
            !1 == this.main.gamePaused && (this.burstFrame += 1 * ig.system.tick, this.runAnim("burst"))
        },
        drawIceStuff: function(b) {
            !0 == this.drawIce && (this.ctxDrawer({
                ctx: b,
                x: this.pos.x + this.size.x / 2 + this.off.x,
                y: this.pos.y + this.size.y / 2 + this.off.y,
                pic: ig.game.hidEle,
                cent: !0,
                sx: ig.game.iceRender.frames[this.ice.frame].sx,
                sy: ig.game.iceRender.frames[this.ice.frame].sy,
                sw: 60,
                sh: 60
            }), !1 == this.iceDelay && this.drawer({
                ctx: b,
                pic: this.im,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                frame: this.getFrame(this.which),
                frameX: this.sheetX,
                frameY: this.sheetY,
                scX: this.iceBubble.sc,
                scY: this.iceBubble.sc,
                alp: this.iceBubble.alp,
                cent: !0
            }), !1 == this.main.gamePaused && this.runAnim("ice"))
        },
        drawPlusStuff: function(b) {
            "plus" == this.refType && this.drawer({
                ctx: b,
                pic: this.plusIm,
                x: this.pos.x + this.size.x / 2 + this.bouncy.x,
                y: this.pos.y + this.size.y / 2 + this.bouncy.y,
                cent: !0,
                alp: 0.8,
                scX: 0.8,
                scY: 0.8
            })
        },
        drawMinusStuff: function(b) {
            "minus" == this.refType && this.drawer({
                ctx: b,
                pic: this.minusIm,
                x: this.pos.x + this.size.x / 2 + this.bouncy.x,
                y: this.pos.y +
                    this.size.y / 2 + this.bouncy.y,
                cent: !0,
                alp: 0.7,
                scX: 0.8,
                scY: 0.8
            })
        },
        draw: function() {
            0 > this.pos.y || (this.drawEvilStuff(), !0 != this.eviled && (!0 == this.drawBurst ? this.drawBurstStuff() : !1 == this.tweening ? "evil" == this.which ? this.drawer({
                pic: this.im,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                frame: this.frame,
                frameX: this.sheetX,
                frameY: this.sheetY,
                scX: this.sc.x,
                scY: this.sc.y,
                cent: !0
            }) : !0 == ig.game.redraw && (!1 == this.drawIce && this.drawer({
                ctx: ig.game.bgCtx,
                pic: this.im,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y +
                    this.size.y / 2,
                frame: this.frame,
                frameX: this.sheetX,
                frameY: this.sheetY,
                scX: this.sc.x,
                scY: this.sc.y,
                cent: !0
            }), this.drawMinusStuff(ig.game.bgCtx), this.drawPlusStuff(ig.game.bgCtx), this.drawIceStuff(ig.game.bgCtx)) : (!1 == this.drawIce && this.drawer({
                pic: this.im,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                frame: this.frame,
                frameX: this.sheetX,
                frameY: this.sheetY,
                scX: this.sc.x,
                scY: this.sc.y,
                cent: !0
            }), this.drawMinusStuff(this.ctx), this.drawPlusStuff(this.ctx), this.drawIceStuff(this.ctx))))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-gui").requires("game.entities.plain").defines(function() {
    EntityPlainGui = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 2010,
        comboTextSize: 18,
        w: 800,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        gameOver: !1,
        gamePaused: !1,
        foregroundIm: new ig.Image("media/graphics/sprites/top-wall.png"),
        bottomIm: new ig.Image("media/graphics/sprites/bottom-wall.png"),
        armoIm: new ig.Image("media/graphics/sprites/armo.png"),
        gradIm: new ig.Image("media/graphics/sprites/grad.png"),
        startOffset: 0,
        score: {
            x: 100,
            y: 20,
            gradp1: -10,
            gradp2: 2
        },
        bubbleArmo: 0,
        plus: {
            offY: 0,
            alp: 0,
            sc: 1,
            gradp1: -10,
            gradp2: 0
        },
        minus: {
            offY: 0,
            alp: 0,
            sc: 1,
            gradp1: -10,
            gradp2: 0
        },
        armoCombo: {
            x: 350,
            y: 538,
            alp: 0,
            sc: 0,
            offY: 20
        },
        popCombo: {
            x: 350,
            y: 538,
            alp: 0,
            sc: 0,
            offY: 20
        },
        dropCombo: {
            x: 350,
            y: 538,
            alp: 0,
            sc: 0,
            offY: 20
        },
        starbarIm: new ig.Image("media/graphics/sprites/star-bar.png"),
        starbaseIm: new ig.Image("media/graphics/sprites/star-base.png"),
        star0Im: new ig.Image("media/graphics/sprites/star_01.png"),
        star1Im: new ig.Image("media/graphics/sprites/star_02.png"),
        star2Im: new ig.Image("media/graphics/sprites/star_03.png"),
        scoreIm: new ig.Image("media/graphics/sprites/score.png"),
        lvlIm: new ig.Image("media/graphics/sprites/level.png"),
        starBar: {
            x: 3,
            y: 18,
            percent: 1,
            star1: 0,
            star2: 0,
            star3: 0
        },
        oneBar: 1 / 3,
        drawSheetCent: function() {},
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.reGen(), this.score.grad = this.ctx.createLinearGradient(0, this.score.gradp1, 0, this.score.gradp2), this.score.grad.addColorStop(0, "#fffcea"), this.score.grad.addColorStop(0.8, "#ffd977"), this.score.grad.addColorStop(1, "#a85a15"), this.score.grad2 =
                this.ctx.createLinearGradient(0, this.score.gradp1, 0, this.score.gradp2 + 5), this.score.grad2.addColorStop(0, "#fffcea"), this.score.grad2.addColorStop(0.8, "#ffd977"), this.score.grad2.addColorStop(1, "#a85a15"), this.plus.grad = this.ctx.createLinearGradient(0, this.plus.gradp1, 0, this.plus.gradp2 + 10), this.plus.grad.addColorStop(0, "#e6e438"), this.plus.grad.addColorStop(0.3, "#c2d73a"), this.plus.grad.addColorStop(1, "#6d8225"), this.plus.strokeCol = "#56612f", this.minus.grad = this.ctx.createLinearGradient(0, this.plus.gradp1,
                    0, this.plus.gradp2 + 10), this.minus.grad.addColorStop(0, "#ff9c00"), this.minus.grad.addColorStop(1, "#e80000"), this.minus.strokeCol = "#8b2929", this.renderScore(), this.renderLevel(), this.renderPopCombo(), this.renderDropCombo(), this.renderArmoCombo())
        },
        reGen: function() {},
        tweenF: function(b) {
            switch (b) {
                case "pauseFadeIn":
                    this.tweener("pauseRect", {
                        alp: this.pauseRect.targAlp
                    }, 0.3);
                    break;
                case "armoPlusUpdate":
                    this.bubble.plusMinusArmo();
                    0 < this.bubble.plusVault ? (this.plus.offY = -10, this.renderPlus(), this.tweener("plus", {
                        alp: 1
                    }, 0.1, "armoPlusUpdate2")) : 0 < this.bubble.minusVault && this.tweenF("armoPlusUpdate3");
                    break;
                case "armoPlusUpdate2":
                    this.tweener("plus", {
                        alp: 0,
                        offY: 10
                    }, 0.1, "armoPlusUpdate3", 0.1);
                    break;
                case "armoPlusUpdate3":
                    0 == this.bubble.minusVault ? this.tweenF("armoPlusUpdate5") : (this.renderMinus(), this.minus.offY = -10, this.tweener("minus", {
                        alp: 1
                    }, 0.1, "armoPlusUpdate4"));
                    break;
                case "armoPlusUpdate4":
                    this.tweener("minus", {
                        alp: 0,
                        offY: 10
                    }, 0.1, "armoPlusUpdate5", 0.1);
                    break;
                case "armoPlusUpdate5":
                    this.bubble.plusMinusArmoUpdate();
                    break;
                case "armoCombo":
                    0 < this.main.armoCombo && (this.armoCombo.offY = 10, this.renderArmoCombo(), this.tweener("armoCombo", {
                        sc: 1,
                        alp: 1,
                        offY: 0
                    }, 0.1));
                    break;
                case "armoCombo2":
                    this.tweener("armoCombo", {
                        offY: -1,
                        alp: 0
                    }, 0.1);
                    break;
                case "popCombo":
                    0 < this.main.popAll.combo ? (this.popCombo.offY = 10, this.renderPopCombo(), this.tweener("popCombo", {
                        sc: 1,
                        alp: 1,
                        offY: 0
                    }, 0.1, "popCombo2")) : this.main.doneCombo = !0;
                    break;
                case "popCombo2":
                    this.tweener("popCombo", {
                        offY: -1,
                        alp: 0
                    }, 0.1, "dropCombo", 0.6);
                    break;
                case "dropCombo":
                    0 < this.main.dropAll.combo ?
                        (this.dropCombo.offY = 10, this.renderDropCombo(), this.tweener("dropCombo", {
                            sc: 1,
                            alp: 1,
                            offY: 0
                        }, 0.1, "dropCombo2")) : this.main.doneCombo = !0;
                    break;
                case "dropCombo2":
                    this.tweener("dropCombo", {
                        offY: -10,
                        alp: 0
                    }, 0.1, "doneCombo", 0.6);
                    break;
                case "endDropCombo":
                    0 < this.main.dropAll.combo ? (this.dropCombo.offY = 10, this.renderDropCombo(), this.tweener("dropCombo", {
                        sc: 1,
                        alp: 1,
                        offY: 0
                    }, 0.1)) : this.main.doneCombo = !0;
                    break;
                case "endDropCombo2":
                    this.tweener("dropCombo", {
                        offY: -10,
                        alp: 0
                    }, 0.1);
                    break;
                case "doneCombo":
                    this.main.doneCombo = !0
            }
        },
        update: function() {
            if (!ig.global.wm) {
                this.parent();
                this.bubbleArmo = this.bubble.armoVault.length - this.bubble.armoIndex - this.bubble.armoExtra + this.bubble.armoPlus - this.bubble.armoMinus;
                var b = this.main.starScore,
                    c = this.main.score;
                c >= b[0] ? (this.starBar.star1 = this.oneBar, this.main.star = 0, c >= b[1] ? (this.starBar.star2 = this.oneBar, this.main.star = 1, c >= b[2] ? (this.starBar.star3 = this.oneBar, this.main.star = 2) : this.starBar.star3 = (c - b[1]) / (b[2] - b[1]) * this.oneBar) : this.starBar.star2 = (c - b[0]) / (b[1] - b[0]) * this.oneBar) :
                    this.starBar.star1 = c / b[0] * this.oneBar;
                this.starBar.percent = this.starBar.star1 + this.starBar.star2 + this.starBar.star3
            }
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
            this.startOffset = Math.abs(this.stage.startOffset);
            this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
            this.over = ig.game.getEntitiesByType(EntityPlainOver)[0];
            this.renderPlus();
            this.renderMinus()
        },
        renderArmoCombo: function() {
            ig.game.hidCtx.clearRect(880,
                140, 200, 100);
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 40,
                tx: this.main.armoCombo,
                x: 980,
                y: 177,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: "#92551c"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 40,
                tx: this.main.armoCombo,
                x: 980,
                y: 175,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: this.score.grad2
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.comboTextSize,
                tx: _STRINGS.Game.ArmoCombo,
                x: 980,
                y: 212,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: "#92551c"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.comboTextSize,
                tx: _STRINGS.Game.ArmoCombo,
                x: 980,
                y: 210,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: this.score.grad2
            })
        },
        renderPopCombo: function() {
            ig.game.hidCtx.clearRect(480, 140, 200, 100);
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 40,
                tx: this.main.popAll.combo,
                x: 580,
                y: 177,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: "#92551c"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 40,
                tx: this.main.popAll.combo,
                x: 580,
                y: 175,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: this.score.grad2
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.comboTextSize,
                tx: _STRINGS.Game.PopCombo,
                x: 580,
                y: 212,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: "#92551c"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.comboTextSize,
                tx: _STRINGS.Game.PopCombo,
                x: 580,
                y: 210,
                stroke: !0,
                strokeLine: 5,
                strokeColour: "#92551c",
                col: this.score.grad2
            })
        },
        renderDropCombo: function() {
            ig.game.hidCtx.clearRect(680, 140, 200, 100);
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 40,
                strokeLine: 2,
                tx: this.main.dropAll.combo,
                x: 780,
                y: 177,
                strokeLine: 5,
                stroke: !0,
                strokeColour: "#92551c",
                col: "#92551c"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 40,
                tx: this.main.dropAll.combo,
                x: 780,
                y: 175,
                strokeLine: 5,
                stroke: !0,
                strokeColour: "#92551c",
                col: this.score.grad2
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.comboTextSize,
                tx: _STRINGS.Game.DropCombo,
                x: 780,
                y: 212,
                strokeLine: 5,
                stroke: !0,
                strokeColour: "#92551c",
                col: "#92551c"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.comboTextSize,
                tx: _STRINGS.Game.DropCombo,
                x: 780,
                y: 210,
                strokeLine: 5,
                stroke: !0,
                strokeColour: "#92551c",
                col: this.score.grad2
            })
        },
        renderLevel: function() {
            ig.game.hidCtx.clearRect(680, 100, 200, 40);
            this.drawer({
                ctx: ig.game.hidCtx,
                pic: this.lvlIm,
                x: 780,
                y: 122,
                cent: !0
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: _STRINGS.Game.level,
                x: 746,
                y: 120,
                stroke: !0,
                strokeColour: "#92551c",
                col: "#92551c",
                align: "left"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: _STRINGS.Game.level,
                x: 746,
                y: 119,
                stroke: !0,
                strokeColour: "#92551c",
                col: this.score.grad,
                align: "left"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: ig.game.lvl + 1,
                x: 808,
                y: 120,
                stroke: !0,
                strokeColour: "#92551c",
                col: "#92551c",
                align: "center"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: ig.game.lvl +
                    1,
                x: 808,
                y: 119,
                stroke: !0,
                strokeColour: "#92551c",
                col: this.score.grad,
                align: "center"
            })
        },
        renderScore: function() {
            ig.game.hidCtx.clearRect(480, 100, 200, 40);
            this.drawer({
                ctx: ig.game.hidCtx,
                pic: this.scoreIm,
                x: 580,
                y: 122,
                cent: !0
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: _STRINGS.Game.score,
                x: 530,
                y: 120,
                stroke: !0,
                strokeColour: "#92551c",
                col: "#92551c",
                align: "left"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: _STRINGS.Game.score,
                x: 530,
                y: 119,
                stroke: !0,
                strokeColour: "#92551c",
                col: this.score.grad,
                align: "left"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: Math.floor(this.main.score),
                x: 608,
                y: 120,
                stroke: !0,
                strokeColour: "#92551c",
                col: "#92551c",
                align: "center"
            });
            this.textDraw({
                ctx: ig.game.hidCtx,
                px: 14,
                tx: Math.floor(this.main.score),
                x: 608,
                y: 119,
                stroke: !0,
                strokeColour: "#92551c",
                col: this.score.grad,
                align: "center"
            })
        },
        drawPopCombo: function() {
            0 < this.popCombo.alp && this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.popCombo.x,
                y: this.popCombo.y + this.popCombo.offY,
                sx: 480,
                sy: 140,
                sw: 200,
                sh: 100,
                scX: 0.8 * this.popCombo.sc,
                scY: 0.8 * this.popCombo.sc,
                alp: this.popCombo.alp,
                cent: !0
            })
        },
        drawDropCombo: function() {
            0 < this.dropCombo.alp && this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.dropCombo.x,
                y: this.dropCombo.y + this.dropCombo.offY,
                sx: 680,
                sy: 140,
                sw: 200,
                sh: 100,
                scX: 0.8 * this.dropCombo.sc,
                scY: 0.8 * this.dropCombo.sc,
                alp: this.dropCombo.alp,
                cent: !0
            })
        },
        drawArmoCombo: function() {
            0 < this.armoCombo.alp && this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.armoCombo.x,
                y: this.armoCombo.y + this.armoCombo.offY,
                sx: 880,
                sy: 140,
                sw: 200,
                sh: 100,
                scX: 0.8 * this.armoCombo.sc,
                scY: 0.8 * this.armoCombo.sc,
                alp: this.armoCombo.alp,
                cent: !0
            })
        },
        renderPlus: function() {
            ig.game.hidCtx.clearRect(880, 50, 100, 40);
            this.textDraw({
                tx: "+" + this.bubble.plusVault,
                x: 930,
                y: 70,
                px: 19,
                col: "white",
                strokeLine: 4,
                stroke: !0,
                strokeColour: this.plus.strokeCol,
                col: this.plus.grad,
                ctx: ig.game.hidCtx
            })
        },
        renderMinus: function() {
            ig.game.hidCtx.clearRect(980, 50, 100, 40);
            this.textDraw({
                tx: "-" + this.bubble.minusVault,
                x: 1030,
                y: 70,
                px: 19,
                col: "white",
                strokeLine: 4,
                stroke: !0,
                strokeColour: this.minus.strokeCol,
                col: this.minus.grad,
                ctx: ig.game.hidCtx
            })
        },
        drawPlus: function() {
            0 !=
                this.plus.alp && this.ctxDrawer({
                    pic: ig.game.hidEle,
                    x: 50,
                    y: ig.system.height - this.armoIm.height + this.plus.offY + 5,
                    px: 19,
                    col: "white",
                    alp: this.plus.alp,
                    scX: this.plus.sc,
                    scY: this.plus.sc,
                    sx: 880,
                    sy: 50,
                    sw: 100,
                    sh: 40,
                    cent: !0
                })
        },
        drawMinus: function() {
            0 != this.minus.alp && this.ctxDrawer({
                pic: ig.game.hidEle,
                x: 50,
                y: ig.system.height - this.armoIm.height + this.minus.offY + 5,
                px: 19,
                col: "white",
                alp: this.minus.alp,
                scX: this.minus.sc,
                scY: this.minus.sc,
                sx: 980,
                sy: 50,
                sw: 100,
                sh: 40,
                cent: !0
            })
        },
        renderCount: function() {
            ig.game.hidCtx.clearRect(300,
                1100, 400, 100);
            this.textDraw({
                tx: 0 > this.main.countDown ? 0 : Math.floor(this.main.countDown),
                x: 500,
                y: 1150,
                px: 80,
                col: "white",
                ctx: ig.game.hidCtx
            });
            ig.game.hidCtx.globalCompositeOperation = "source-atop";
            ig.game.hidCtx.drawImage(this.gradIm.data, 300, 1100, 400, 100);
            ig.game.hidCtx.globalCompositeOperation = "source-over"
        },
        draw: function() {
            this.parent();
            !ig.global.wm && void 0 != this.stage && (this.foregroundIm.draw(0, 0), this.starbaseIm.draw(this.starBar.x, this.starBar.y), 0 < this.starBar.percent && this.ctx.drawImage(this.starbarIm.data,
                    0, this.starbarIm.height * (1 - this.starBar.percent), this.starbarIm.width, this.starbarIm.height * this.starBar.percent, this.starBar.x + 1, this.starBar.y + this.starbarIm.height * (1 - this.starBar.percent), this.starbarIm.width, this.starbarIm.height * this.starBar.percent), this.ctx.globalAlpha = this.starBar.star3 == this.oneBar ? 1 : 0.8, this.star2Im.draw(this.starBar.x - 5, this.starBar.y - 10), this.ctx.globalAlpha = this.starBar.star2 == this.oneBar ? 1 : 0.8, this.star1Im.draw(this.starBar.x, this.starBar.y + 28), this.ctx.globalAlpha =
                this.starBar.star1 == this.oneBar ? 1 : 0.8, this.star0Im.draw(this.starBar.x + 5, this.starBar.y + 58), this.ctx.globalAlpha = 1, this.drawPopCombo(), this.drawDropCombo(), this.drawArmoCombo(), this.ctxDrawer({
                    pic: ig.game.hidEle,
                    x: this.score.x,
                    y: this.score.y + 5,
                    sx: 480,
                    sy: 100,
                    sw: 200,
                    sh: 40,
                    cent: !0
                }), this.ctxDrawer({
                    pic: ig.game.hidEle,
                    x: 370,
                    y: this.score.y + 5,
                    sx: 680,
                    sy: 100,
                    sw: 200,
                    sh: 40,
                    cent: !0
                }), !1 == this.stage.startTween ? (this.bottomIm.draw(0, ig.system.height - this.bottomIm.height), this.armoIm.draw(0, ig.system.height - this.armoIm.height), !0 == this.main.gameOver ? this.textDraw({
                    px: 28,
                    col: "white",
                    tx: 0 > this.main.countDown ? 0 : Math.floor(this.main.countDown),
                    x: 50,
                    y: ig.system.height - this.armoIm.height + 25,
                    rot: -16,
                    scX: this.main.scoreSc,
                    scY: this.main.scoreSc
                }) : this.textDraw({
                    px: 28,
                    col: "white",
                    tx: 0 > this.bubble.armoLeft ? 0 : this.bubble.armoLeft,
                    x: 50,
                    y: ig.system.height - this.armoIm.height + 25,
                    rot: -16
                })) : (this.bottomIm.draw(0, ig.system.height - this.bottomIm.height + this.stage.pos.y + this.startOffset), this.armoIm.draw(0, ig.system.height - this.armoIm.height +
                    this.stage.pos.y + this.startOffset), this.textDraw({
                    px: 28,
                    col: "white",
                    tx: this.bubble.armoLeft,
                    x: 50,
                    y: ig.system.height - this.armoIm.height + 25 + this.stage.pos.y + this.startOffset,
                    rot: -16
                })), this.drawPlus(), this.drawMinus())
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-tut").requires("game.entities.plain").defines(function() {
    EntityPlainTut = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2028,
        size: {
            x: 50,
            y: 50
        },
        textSize: 14,
        arrowIm: new ig.Image("media/graphics/sprites/tut-arrow.png"),
        arrow: {
            offY: 0,
            alp: 1
        },
        speechIm: new ig.Image("media/graphics/sprites/speech.png"),
        speech: {
            sc: 0
        },
        buttons: [],
        offY: -600,
        tutIndex: 0,
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.main = d.main, this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0],
                this.size.x = this.speechIm.width, this.size.y = this.speechIm.height, this.main.levelStat.speech ? (this.main.tutOn = !0, this.prepareText(), this.tweenF("fadeIn"), this.tweenF("alpFadeIn")) : this.kill())
        },
        clicked: function() {},
        released: function() {},
        handleText: function(b) {
            var c = b.tx.split(" "),
                d = [],
                e = "";
            this.textSet(b.px, "white", null, ig.game.hidCtx);
            for (var g = 0; g < c.length; g++) "" == e ? e += c[g] : this.textW(e + " " + c[g]) < b.maxWidth ? e = 0 == e.length ? e + c[g] : e + (" " + c[g]) : (d.push(e), e = c[g]);
            0 != e.length && d.push(e);
            this.textSet(b.px,
                "white", null, ig.game.hidCtx);
            c = 1.3 * this.textW("M");
            return d.length * c > b.maxHeight ? this.handleText({
                px: b.px - 1,
                tx: b.tx,
                maxWidth: b.maxWidth,
                maxHeight: b.maxHeight
            }) : {
                px: b.px,
                lines: d
            }
        },
        tweenF: function(b) {
            switch (b) {
                case "expandSpeech":
                    this.speech.sc = 0;
                    0 == this.tutIndex && this.sounder("click");
                    this.tweener("speech", {
                        sc: 1.1
                    }, 0.1, "expandSpeech2");
                    break;
                case "expandSpeech2":
                    this.tweener("speech", {
                        sc: 1
                    }, 0.1);
                    break;
                case "fadeIn":
                    this.tweener("arrow", {
                        offY: 10
                    }, 0.5, "fadeOut");
                    break;
                case "fadeOut":
                    this.tweener("arrow", {
                        offY: 0
                    }, 0.5, "fadeIn");
                    break;
                case "alpFadeIn":
                    this.tweener("arrow", {
                        alp: 0
                    }, 1, "alpFadeOut", 1);
                    break;
                case "alpFadeOut":
                    this.tweener("arrow", {
                        alp: 1
                    }, 1, "alpFadeIn")
            }
        },
        runTask: function() {},
        update: function() {
            !ig.global.wm && !0 != this.main.gamePaused && (this.parent(), ig.input.released("click") && !1 == this.stage.startTween && !0 != this.main.gamePaused && 1 == this.speech.sc && (this.sounder("click"), this.tutIndex++, this.main.levelStat.speech[this.tutIndex] ? this.prepareText() : (this.main.tutOn = !1, this.kill())))
        },
        ready: function() {
            this.pointer =
                ig.game.getEntitiesByType(EntityPointer)[0]
        },
        prepareText: function() {
            this.speech.sc = 0;
            this.textLines = ig.ua.mobile ? this.main.levelStat.speechMobile ? this.handleText({
                tx: this.main.levelStat.speechMobile[this.tutIndex],
                px: this.textSize,
                maxWidth: 0.86 * this.size.x,
                maxHeight: 0.8 * this.size.y
            }) : this.handleText({
                tx: this.main.levelStat.speech[this.tutIndex],
                px: this.textSize,
                maxWidth: 0.86 * this.size.x,
                maxHeight: 0.8 * this.size.y
            }) : this.handleText({
                tx: this.main.levelStat.speech[this.tutIndex],
                px: this.textSize,
                maxWidth: 0.86 *
                    this.size.x,
                maxHeight: 0.8 * this.size.y
            });
            this.renderText();
            !1 == this.stage.startTween && this.tweenF("expandSpeech")
        },
        renderText: function() {
            ig.game.hidCtx.clearRect(0, 1100, this.size.x, this.size.y);
            this.drawer({
                ctx: ig.game.hidCtx,
                pic: this.speechIm,
                x: 0,
                y: 1100
            });
            this.textSet(this.textLines.px, "#92551c", null, ig.game.hidCtx);
            for (var b = 1.3 * this.textW("M"), c = 0.5 * (b * this.textLines.lines.length - 0.5 * b), d = 0; d < this.textLines.lines.length; d++) this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textLines.px,
                tx: this.textLines.lines[d],
                x: 0 + 0.07 * this.size.x,
                y: 1100 + this.size.y / 2 - c + d * b,
                align: "left",
                col: "#92551c"
            })
        },
        draw: function() {
            this.parent();
            ig.global.wm || (this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0], !1 == this.stage.startTween && !0 == this.main.gameStarted && (0 == this.speech.sc && this.tweenF("expandSpeech"), this.main.levelStat.arrow && (this.main.levelStat.arrow[this.tutIndex] ? this.drawer({
                pic: this.arrowIm,
                x: this.main.levelStat.arrow[this.tutIndex].x,
                y: this.main.levelStat.arrow[this.tutIndex].y + this.arrow.offY,
                cent: !0,
                scX: 0.8,
                scY: 0.8
            }) : this.drawer({
                pic: this.arrowIm,
                x: this.main.levelStat.arrow.x,
                y: this.main.levelStat.arrow.y + this.arrow.offY,
                cent: !0,
                scX: 0.8,
                scY: 0.8
            })), this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                cent: !0,
                scX: this.speech.sc,
                scY: this.speech.sc,
                sx: 0,
                sy: 1100,
                sw: this.size.x,
                sh: this.size.y
            }), this.textDraw({
                tx: _STRINGS.Game.Proceed,
                col: "white",
                px: 8,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y - 2,
                scX: this.speech.sc,
                scY: this.speech.sc
            })))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-stage").requires("game.entities.plain").defines(function() {
    EntityPlainStage = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 99,
        w: 800,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        topLeft: {
            x: 32,
            y: 0
        },
        size: {
            x: 50,
            y: 50
        },
        oriPos: {
            x: 55,
            y: 128
        },
        im: new ig.Image("media/graphics/sprites/line_star.png"),
        wallIm: new ig.Image("media/graphics/sprites/wall.png"),
        sheetX: 8,
        sheetY: 4,
        topGap: 75,
        sc: {
            x: 1,
            y: 1
        },
        startOffset: 0,
        startTween: !0,
        stageHeight: 0.4,
        tweening: !1,
        drawSheetCent: function() {},
        init: function(b, c, d) {
            ig.global.wm ||
                (this.parent(b, c, d), this.reGen())
        },
        reGen: function() {},
        tweenF: function(b) {
            switch (b) {
                case "triggerPosDelay":
                    this.tweener(this, {}, 0.3, "triggerPos");
                    break;
                case "triggerPos":
                    this.stagePos();
                    break;
                case "startTween":
                    this.startTween = !1;
                    this.shooter = ig.game.getEntitiesByType(EntityPlainShooter)[0];
                    this.shooter.oriPos.y = 490;
                    this.shooter.pos.y = this.shooter.oriPos.y;
                    this.shooter.shadow.y = this.shooter.pos.y + 110;
                    this.tweening = !1;
                    ig.game.redraw = !0;
                    break;
                case "endTween":
                    this.tweening = !1
            }
        },
        update: function() {
            ig.global.wm ||
                !0 != this.main.gamePaused && this.parent()
        },
        stagePos: function() {
            var b = 0;
            this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
            for (var c = this.main.tiles.length - 1; 0 < c; c--) {
                var d = !1;
                if (void 0 != this.main.tiles[c])
                    for (var e = 0; e < this.main.tiles[c].length; e++) void 0 != this.main.tiles[c][e] && (d = !0);
                !0 == d && b++
            }
            b = ig.system.height * this.stageHeight - b * this.tile[0].size.y;
            0 < b && (b = 0);
            this.startOffset = b;
            this.tweening = this.main.allowShoot = !0;
            ig.game.redraw = !0;
            this.tweener("pos", {
                y: this.startOffset
            }, 0.5, "endTween")
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.tile = ig.game.getEntitiesByType(EntityPlainTile);
            this.shooter = ig.game.getEntitiesByType(EntityPlainShooter)[0];
            for (var b = 0, c = this.main.tiles.length - 1; 0 < c; c--) {
                for (var d = !1, e = 0; e < this.main.tiles[c].length; e++) void 0 != this.main.tiles[c][e] && (d = !0);
                !0 == d && b++
            }
            this.startOffset = ig.system.height * this.stageHeight - b * this.tile[0].size.y;
            this.tweening = !0;
            ig.game.redraw = !0;
            this.tweener2("pos", {
                    y: this.startOffset
                }, Math.abs(this.startOffset) /
                100, "startTween");
            this.shooter.setStartPosition()
        },
        draw: function() {
            this.parent();
            if (!ig.global.wm) {
                this.ctx.drawImage(this.im.data, (ig.system.width - this.im.width * this.sc.x) / 2, this.pos.y - 12 + this.topGap - this.im.height / 2 * this.sc.y, this.im.width * this.sc.x, this.im.height * this.sc.y);
                for (var b = 0; b < Math.floor(Math.abs(this.pos.y / this.wallIm.height)) + 5; b++) 0 < this.pos.y + this.wallIm.height * b + this.wallIm.height && (this.drawer({
                        x: -1,
                        y: this.pos.y + this.wallIm.height * b,
                        frameX: 2,
                        frameY: 1,
                        frame: 0,
                        cent: !1,
                        pic: this.wallIm
                    }),
                    this.drawer({
                        x: ig.system.width - this.wallIm.width / 2 + 1,
                        y: this.pos.y + this.wallIm.height * b,
                        frameX: 2,
                        frameY: 1,
                        frame: 1,
                        cent: !1,
                        pic: this.wallIm
                    }))
            }
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-bubble").requires("game.entities.plain").defines(function() {
    EntityPlainBubble = EntityPlain.extend({
        type: ig.Entity.TYPE.A,
        checkAgainst: ig.Entity.TYPE.B,
        zIndex: 2002,
        sheetX: 8,
        sheetY: 4,
        tile: {
            x: 0,
            y: 0
        },
        size: {
            x: 50,
            y: 50
        },
        friction: {
            x: 0,
            y: 0
        },
        gameOver: !1,
        gamePaused: !1,
        im: new ig.Image("media/graphics/sprites/bubbles.png"),
        speed: 800,
        shooted: !1,
        which: "red",
        realPos: {
            x: 0,
            y: 0
        },
        hitPos: {
            x: 0,
            y: 0
        },
        disPos: {},
        count: 0,
        spawned: !1,
        collided: !1,
        firstBubble: !0,
        ani: "red",
        refColour: "red",
        refType: "normal",
        arrowIm: new ig.Image("media/graphics/sprites/arrow.png"),
        woodIm: new ig.Image("media/graphics/sprites/log.png"),
        woodFrontIm: new ig.Image("media/graphics/sprites/log-front.png"),
        rayIm: new ig.Image("media/graphics/sprites/ray.png"),
        lightIm: new ig.Image("media/graphics/sprites/dot.png"),
        giveBubble: !1,
        showPrevBubble: !1,
        drawShootBubble: !0,
        prevBubble: "red",
        armoLeft: 0,
        armoIndex: -1,
        armoVault: [],
        activeBubble: 0,
        oriPos: {
            x: 0,
            y: 0
        },
        armoPlus: 0,
        armoMinus: 0,
        armoExtra: 10,
        minusVault: 0,
        plusVault: 0,
        light: {
            x: 10,
            y: 0,
            sc: 0,
            alp: 0
        },
        light2: {
            x: 2,
            y: 10,
            sc: 0,
            alp: 0
        },
        light3: {
            x: -10,
            y: -20,
            sc: 0,
            alp: 0
        },
        ray: {
            x: 123,
            y: -93,
            alp: 1
        },
        wood: {
            x: 121,
            y: -30
        },
        woodOff: {
            x: -112,
            y: -60
        },
        woodAniOff: {
            x: -112,
            y: -60
        },
        nextBubbleToggle: 0,
        onHandPos: {
            x: 212,
            y: -49
        },
        onWoodPos: {
            x: 99,
            y: -117
        },
        nextBubble0: {
            x: 99,
            y: -37,
            allow: !0
        },
        nextBubble1: {
            x: 99,
            y: -37,
            allow: !0
        },
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.main = d.main, this.aniStuff(), this.prepareBubbleArmo())
        },
        prepareBubbleArmo: function() {
            for (var b = [], c = 0; c < this.main.armo.length; c++) 0 < this.main.armo[c] &&
                b.push(this.main.colourSet[c]);
            for (c = 0; c < this.main.levelStat.armoEachArmo; c++) {
                this.shuffleArray(b);
                for (var d = 0; d < b.length; d++) this.armoVault.push(b[d])
            }
            this.nextBubble0.index = 1;
            this.nextBubble1.index = 2;
            this.armoExtra = this.main.armoExtra;
            this.armoLeft = this.armoVault.length - this.armoExtra + 1
        },
        basicArmoUpdate: function() {
            this.armoLeft -= 1
        },
        plusMinusArmo: function() {
            this.armoPlus += this.plusVault;
            this.armoMinus += this.minusVault
        },
        plusMinusArmoUpdate: function() {
            this.minusVault = this.plusVault = 0;
            this.armoLeft =
                this.armoLeft + this.armoPlus - this.armoMinus;
            this.armoMinus = this.armoPlus = 0
        },
        bubbleTypeRegen: function() {
            -1 < this.which.indexOf("baby") ? (this.refType = "baby", this.refColour = this.which.replace("baby", "")) : this.main.bubbleColours.indexOf(this.which) ? (this.refType = "normal", this.refColour = this.which) : (this.refType = this.which, this.refColour = "none");
            this.currentAnim = this.anims[this.which]
        },
        followShooterPosition: function() {
            this.pos.x = this.shooter.pos.x + this.shooter.size.x / 2 - this.size.x / 2;
            this.pos.y = this.shooter.pos.y +
                this.shooter.anims.idle.pivot.y - 43;
            this.oriPos.x = this.pos.x;
            this.oriPos.y = this.pos.y
        },
        toggleBubble: function() {
            if (!(void 0 == this.armoVault[this.armoIndex + 1] || 1 >= this.armoLeft) && !1 != this.main.allowShoot) {
                var b = [this.armoVault[this.armoIndex] + "", this.armoVault[this.armoIndex + 1] + ""];
                this.armoVault[this.armoIndex] = b[1];
                this.armoVault[this.armoIndex + 1] = b[0];
                this.which = this.armoVault[this.armoIndex];
                this.bubbleTypeRegen()
            }
        },
        reGen: function() {
            !0 == this.shooted && (this.shooted = this.giveBubble = !1);
            this.shooter.allowShoot = !0;
            this.armoIndex += 1;
            void 0 != this.armoVault[this.armoIndex] ? (this.which = this.armoVault[this.armoIndex], this.bubbleTypeRegen()) : this.main.noArmo = !0
        },
        bubblesCollision: function() {
            var b = this.pos.x + this.size.x / 2,
                c = this.pos.y + this.size.y / 2,
                d = this.size.y / 2 - 2;
            this.tiles = ig.game.getEntitiesByType(EntityPlainTile);
            for (var e = 0; e < this.tiles.length; e++) {
                var g = this.tiles[e].pos.x + this.tiles[e].size.x / 2,
                    m = this.tiles[e].pos.y + this.tiles[e].size.y / 2,
                    y = this.tiles[e].size.y / 2;
                if (!1 == this.tiles[e].bubbleKilled && !0 ==
                    this.tiles[e].hanging && !0 == this.circleHitTest(b, c, d, g, m, y)) {
                    this.bubbleHitted(b - g, c - m);
                    break
                }
            }
            0 > this.pos.y - this.stage.pos.y - this.stage.topGap - this.stage.topLeft.y && this.bubbleHitted(-this.vel.x, 10)
        },
        getTilePos: function() {
            this.tile.y = Math.floor((this.realPos.y + this.size.y / 2) / this.size.y);
            this.tile.y % 2 == this.main.rowOffset ? (this.tile.x = Math.floor((this.realPos.x + this.size.x / 2) / this.size.x), 10 < this.tile.x && (this.tile.x = 10)) : (this.tile.x = Math.floor(this.realPos.x / this.size.x), 9 < this.tile.x && (this.tile.x =
                9));
            0 > this.tile.x && (this.tile.x = 0)
        },
        bubbleHitted: function(b, c) {
            !0 != this.collided && (this.hitPos.x = this.pos.x, this.hitPos.y = this.pos.y, this.disPos = {
                x: b,
                y: c
            }, this.collided = !0, this.spawned = !1, this.realPos.x = this.pos.x - this.stage.topLeft.x, this.realPos.y = this.pos.y - this.stage.pos.y - this.stage.topGap - this.stage.topLeft.y, this.count = 0, this.handleSnap())
        },
        getPosfromTile: function() {
            this.oriPos.x = this.tile.y % 2 == this.main.rowOffset ? this.tile.x * this.size.x : this.tile.x * this.size.x + this.size.x / 2;
            this.oriPos.y =
                this.tile.y * this.size.y
        },
        snap: function() {
            !0 != this.spawned && (this.spawned = !0, this.main.tiles[this.tile.y][this.tile.x] = this.which, ig.game.spawnEntity(EntityPlainTile, 175, 490, {
                main: this.main,
                which: this.which,
                i: this.tile.x,
                j: this.tile.y,
                bubblePos: {
                    x: this.hitPos.x,
                    y: this.hitPos.y
                }
            }), this.drawShootBubble = !1, this.reGen())
        },
        handleSnap: function() {
            !0 != this.spawned && (this.count++, this.getTilePos(), void 0 == this.main.tiles[this.tile.y] && (this.main.tiles[this.tile.y] = []), void 0 == this.main.tiles[this.tile.y][this.tile.x] ||
                "empty" == this.main.tiles[this.tile.y][this.tile.x] ? this.snap() : ig.ua.mobile ? 1 == this.count ? (this.realPos.x = this.pos.x - (this.pos.x - this.last.x) * (this.count / 2) - this.stage.topLeft.x, this.realPos.y = this.pos.y - (this.pos.y - this.last.y) * (this.count / 2) - this.stage.pos.y - this.stage.topGap - this.stage.topLeft.y, this.handleSnap()) : 2 == this.count ? (this.realPos.x = this.last.x - this.stage.topLeft.x, this.realPos.y = this.last.y - this.stage.pos.y - this.stage.topGap - this.stage.topLeft.y, this.handleSnap()) : this.mobileSnapCheck() :
                (this.realPos.y += 5, this.handleSnap()))
        },
        snapMobile: function(b, c) {
            this.tile.y = b;
            this.tile.x = c;
            this.getPosfromTile();
            this.snap()
        },
        mobileSnapCheck: function() {
            var b, c, d, e;
            this.tile.y % 2 == this.main.rowOffset ? (b = -1, c = 0, d = 10, e = 9) : (b = 0, c = 1, d = 9, e = 10);
            0 < this.disPos.x ? void 0 == this.checkTile(this.tile.y + 1, this.tile.x + c) && this.tile.x + 1 <= e ? this.snapMobile(this.tile.y + 1, this.tile.x + c) : void 0 == this.checkTile(this.tile.y, this.tile.x + 1) && this.tile.x + 1 <= d ? this.snapMobile(this.tile.y, this.tile.x + 1) : void 0 == this.checkTile(this.tile.y -
                1, this.tile.x + c) && this.tile.x + 1 <= e && -1 < this.tile.y - 1 ? this.snapMobile(this.tile.y - 1, this.tile.x + c) : void 0 == this.checkTile(this.tile.y + 1, this.tile.x + b) && -1 < this.tile.x - 1 ? this.snapMobile(this.tile.y + 1, this.tile.x + b) : void 0 == this.checkTile(this.tile.y, this.tile.x - 1) && -1 < this.tile.x - 1 ? this.snapMobile(this.tile.y, this.tile.x - 1) : void 0 == this.checkTile(this.tile.y - 1, this.tile.x + b) && -1 < this.tile.x - 1 && -1 < this.tile.y - 1 && this.snapMobile(this.tile.y - 1, this.tile.x + b) : void 0 == this.checkTile(this.tile.y + 1, this.tile.x +
                b) && -1 < this.tile.x - 1 ? this.snapMobile(this.tile.y + 1, this.tile.x + b) : void 0 == this.checkTile(this.tile.y, this.tile.x - 1) && -1 < this.tile.x - 1 ? this.snapMobile(this.tile.y, this.tile.x - 1) : void 0 == this.checkTile(this.tile.y - 1, this.tile.x + b) && -1 < this.tile.x - 1 && -1 < this.tile.y - 1 ? this.snapMobile(this.tile.y - 1, this.tile.x + b) : void 0 == this.checkTile(this.tile.y + 1, this.tile.x + c) && this.tile.x + 1 <= e ? this.snapMobile(this.tile.y + 1, this.tile.x + c) : void 0 == this.checkTile(this.tile.y, this.tile.x + 1) && this.tile.x + 1 <= d ? this.snapMobile(this.tile.y,
                this.tile.x + 1) : void 0 == this.checkTile(this.tile.y - 1, this.tile.x + c) && this.tile.x + 1 <= e && -1 < this.tile.y - 1 && this.snapMobile(this.tile.y - 1, this.tile.x + c)
        },
        checkTile: function(b, c) {
            return void 0 == this.main.tiles[b] ? (this.main.tiles[b] = [], this.main.tiles[b][c]) : "empty" == this.main.tiles[b][c] ? void 0 : this.main.tiles[b][c]
        },
        aniStuff: function() {
            this.animSheet = new ig.AnimationSheet(this.im.path, this.im.width / this.sheetX, this.im.height / this.sheetY);
            this.size.x = (this.animSheet.width - 4) * this.sc.x;
            this.size.y = (this.animSheet.height -
                8) * this.sc.y;
            this.addAnim("red", 0.1, [0], !0);
            this.addAnim("orange", 0.1, [1], !0);
            this.addAnim("yellow", 0.1, [2], !0);
            this.addAnim("green", 0.1, [3], !0);
            this.addAnim("cyan", 0.1, [4], !0);
            this.addAnim("blue", 0.1, [5], !0);
            this.addAnim("purple", 0.1, [6], !0);
            this.addAnim("pink", 0.1, [7], !0);
            this.addAnim("super", 0.05, [19], !1);
            this.addAnim("babyred", 0.1, [8], !0);
            this.addAnim("babyorange", 0.1, [9], !0);
            this.addAnim("babyyellow", 0.1, [10], !0);
            this.addAnim("babygreen", 0.1, [11], !0);
            this.addAnim("babycyan", 0.1, [12], !0);
            this.addAnim("babyblue",
                0.1, [13], !0);
            this.addAnim("babypurple", 0.1, [14], !0);
            this.addAnim("babypink", 0.1, [15], !0);
            this.addAnim("ice", 0.1, [16], !0);
            this.addAnim("right", 0.1, [17], !0);
            this.addAnim("up", 0.1, [18], !0);
            this.addAnim("rainbow", 0.1, [19], !0);
            this.addAnim("thunder", 0.1, [20], !0);
            this.addAnim("star", 0.1, [21], !0);
            this.addAnim("time", 0.1, [22], !0);
            this.addAnim("bomb", 0.1, [23], !0);
            this.addAnim("steel", 0.1, [24], !0);
            this.addAnim("evil", 0.1, [25], !0);
            this.addAnim("wood", 0.1, [26], !0);
            this.addAnim("guide", 0.1, [27], !0);
            this.addAnim("change",
                0.1, [28], !0);
            this.addAnim("pick", 0.1, [29], !0);
            this.addAnim("search", 0.1, [30], !0);
            this.addAnim("armo", 0.1, [31], !0);
            this.currentAnim = this.anims.super
        },
        shootBubble: function(b) {
            !0 == this["nextBubble" + this.nextBubbleToggle].allow && (this["nextBubble" + this.nextBubbleToggle].allow = !1, this.angle = b, this.firstBubble = !1, this.drawShootBubble = !0, this.vel.x = this.speed * Math.cos(this.angle), this.vel.y = this.speed * Math.sin(this.angle), this.collided = !1, this.shooted = !0, this.giveNextBubble())
        },
        giveNextBubble: function() {
            for (var b =
                0; b < this.tweens.length; b++) this.tweens[b].targ == "nextBubble" + this.nextBubbleToggle && this.tweens[b].stop();
            this["nextBubble" + (this.nextBubbleToggle + 1) % 2].x = this.onWoodPos.x;
            this["nextBubble" + (this.nextBubbleToggle + 1) % 2].y = this.onWoodPos.y + 80;
            this["nextBubble" + (this.nextBubbleToggle + 1) % 2].index = this["nextBubble" + this.nextBubbleToggle].index + 1;
            this.tweenF("giveBubbleUp", "nextBubble" + this.nextBubbleToggle);
            this.nextBubbleToggle = (this.nextBubbleToggle + 1) % 2
        },
        tweenF: function(b, c) {
            switch (b) {
                case "giveBubbleUp":
                    this.oriPos.x =
                        this.shooter.pos.x + this.shooter.size.x / 2 - this.size.x / 2;
                    this.oriPos.y = this.shooter.pos.y + this.shooter.anims.idle.pivot.y - 43;
                    c.y = this.onWoodPos.y;
                    this.tweener(c, {
                        x: this.onHandPos.x
                    }, 0.3);
                    this.tweener(c, {
                        y: this[c].y - 30
                    }, 0.2, "giveBubbleDown");
                    break;
                case "giveBubbleDown":
                    this.tweener(c, {
                        y: this.onHandPos.y
                    }, 0.3);
                    this.tweenF("nextBubbleUp", "nextBubble" + this.nextBubbleToggle);
                    break;
                case "nextBubbleUp":
                    this.tweener(c, {
                        y: this.onWoodPos.y - 20
                    }, 0.3, "floatDown");
                    break;
                case "floatUp":
                    this.tweener(c, {
                        y: this.onWoodPos.y -
                            3
                    }, 0.6, "floatDown");
                    break;
                case "floatDown":
                    this.drawShootBubble = this[c].allow = !0;
                    this.tweener(c, {
                        y: this.onWoodPos.y + 3
                    }, 0.5, "floatUp");
                    break;
                case "gameOver":
                    for (var d = 0; d < this.tweens.length; d++)("nextBubble0" == this.tweens[d].targ || "nextBubble1" == this.tweens[d].targ) && this.tweens[d].stop();
                    this.tweener("nextBubble0", {
                        y: this.onWoodPos.y + 80
                    }, 0.1);
                    this.tweener("nextBubble1", {
                        y: this.onWoodPos.y + 80
                    }, 0.1);
                    break;
                case "rayBright":
                    this.tweener("ray", {
                        alp: 1
                    }, 1, "rayDim");
                    break;
                case "rayDim":
                    this.tweener("ray", {
                        alp: 0.8
                    }, 2, "rayBright");
                    break;
                case "light":
                    this[c].alp = 0;
                    this[c].sc = 0;
                    this[c].x = -10 + 20 * Math.random();
                    this[c].y = 40;
                    this.tweener2(c, {
                        alp: 1,
                        sc: 0.5 + 0.5 * Math.random(),
                        x: this[c].x - 30 + 60 * Math.random(),
                        y: this[c].y - 20 - 30 * Math.random()
                    }, 0.8 + 0.5 * Math.random(), "light2", 1 * Math.random());
                    break;
                case "light2":
                    this.tweener2(c, {
                        alp: 0,
                        sc: 0,
                        x: this[c].x - 30 + 60 * Math.random(),
                        y: this[c].y - 20 - 50 * Math.random()
                    }, 1.2, "light")
            }
        },
        update: function() {
            !ig.global.wm && !0 != this.main.gamePaused && (this.parent(), !1 == this.shooted ? (this.vel.x =
                0, this.vel.y = 0, this.followShooterPosition()) : !1 == this.collided && this.bubblesCollision(), 30 > this.pos.x ? 0 > this.vel.x && (this.vel.x = -this.vel.x) : this.pos.x + this.size.x > ig.system.width - 30 && 0 < this.vel.x && (this.vel.x = -this.vel.x))
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.tiles = ig.game.getEntitiesByType(EntityPlainTile);
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
            this.shooter = ig.game.getEntitiesByType(EntityPlainShooter)[0];
            this.gui = ig.game.getEntitiesByType(EntityPlainGui)[0];
            this.followShooterPosition();
            this.reGen();
            this.tweenF("floatUp", "nextBubble" + this.nextBubbleToggle);
            this.tweenF("rayDim");
            this.tweenF("light", "light");
            this.tweenF("light", "light2");
            this.tweenF("light", "light3");
            this.armoLeft = this.armoVault.length - this.armoExtra + 1
        },
        draw: function() {
            ig.global.wm || (this.drawer({
                    pic: this.woodIm,
                    x: this.wood.x,
                    y: this.wood.y + this.shooter.shadow.y,
                    cent: !0
                }), this.drawer({
                    pic: this.rayIm,
                    x: this.ray.x,
                    y: this.ray.y + this.shooter.shadow.y,
                    cent: !0,
                    alp: this.ray.alp
                }), !0 == this.shooted &&
                this.parent(), !0 == this.firstBubble && this.parent(), void 0 != this.armoVault[this.nextBubble0.index] && this.anims[this.armoVault[this.nextBubble0.index]].draw(this.nextBubble0.x, this.shooter.shadow.y + this.nextBubble0.y), void 0 != this.armoVault[this.nextBubble1.index] && this.anims[this.armoVault[this.nextBubble1.index]].draw(this.nextBubble1.x, this.shooter.shadow.y + this.nextBubble1.y), this.drawer({
                    pic: this.woodFrontIm,
                    x: this.wood.x,
                    y: this.wood.y + this.shooter.shadow.y,
                    cent: !0
                }), this.drawer({
                    pic: this.lightIm,
                    x: this.wood.x + this.light.x,
                    y: this.wood.y + this.shooter.shadow.y + this.light.y - 60,
                    cent: !0,
                    scX: this.light.sc,
                    scY: this.light.sc,
                    alp: this.light.alp
                }), this.drawer({
                    pic: this.lightIm,
                    x: this.wood.x + this.light2.x,
                    y: this.wood.y + this.shooter.shadow.y + this.light2.y - 60,
                    cent: !0,
                    scX: this.light2.sc,
                    scY: this.light2.sc,
                    alp: this.light2.alp
                }), this.drawer({
                    pic: this.lightIm,
                    x: this.wood.x + this.light3.x,
                    y: this.wood.y + this.shooter.shadow.y + this.light3.y - 60,
                    cent: !0,
                    scX: this.light3.sc,
                    scY: this.light3.sc,
                    alp: this.light3.alp
                }))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-shooter").requires("game.entities.plain", "game.entities.plain-bubble").defines(function() {
    EntityPlainShooter = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 2E3,
        w: 800,
        sc: 2,
        flip: {
            x: !1
        },
        size: {
            x: 50,
            y: 50
        },
        gameOver: !1,
        gamePaused: !1,
        im: new ig.Image("media/graphics/sprites/mushroom.png"),
        sc: {
            x: 1,
            y: 1
        },
        sheetX: 3,
        sheetY: 1,
        oriPos: {
            x: 55,
            y: 128
        },
        shadowIm: new ig.Image("media/graphics/sprites/shadow.png"),
        shadow: {
            scX: 1,
            alp: 1,
            offX: 0,
            y: 0
        },
        offset: {
            x: 0,
            y: 10
        },
        guide: {
            x: 0,
            y: 0
        },
        p1: {
            x: 0,
            y: 0
        },
        p2: {
            x: 0,
            y: 0
        },
        rad: 0,
        tweening: !1,
        refAngle: 0,
        angleRange: 70,
        allowShoot: !0,
        wallSide: 35,
        drawGuide: !0,
        guideOffY: 22,
        drawSheetCent: function() {},
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.oriPos.x = b, this.oriPos.y = c, this.aniStuff(), this.reGen())
        },
        guideReflect: function(b, c, d, e) {
            b < d ? (b = d + Math.abs(b - d), 1 < e && (c += 5)) : b > ig.system.width - d && (d = ig.system.width - d, b = d - (b - d), 1 < e && (c += 5));
            return {
                x: b,
                y: c
            }
        },
        setGuide: function() {
            if (!0 != this.tweening) {
                this.guides = [];
                this.p1 = {
                    x: this.oriPos.x + this.size.x / 2 + 4,
                    y: this.oriPos.y +
                        this.size.y / 2 + 4
                };
                for (var b = 0; 40 > b; b++) {
                    var c = {
                            x: 0,
                            y: 0
                        },
                        d = !1;
                    c.x = this.p1.x + 50 * b * Math.sin(2 * Math.PI - this.rad + Math.PI / 2);
                    c.y = this.p1.y + 50 * b * Math.cos(2 * Math.PI - this.rad + Math.PI / 2) + this.guideOffY;
                    for (var e = 0; 4 > e; e++) {
                        var g = this.guideReflect(c.x, c.y, this.wallSide, e);
                        c.x = g.x;
                        c.y = g.y
                    }
                    e = ig.game.getEntitiesByType(EntityPlainTile);
                    for (g = 0; g < e.length; g++)
                        if (!0 == this.circleHitTest(c.x, c.y, 10, e[g].pos.x + e[g].size.x / 2, e[g].pos.y + e[g].size.y / 2, 25) && !1 == e[g].bubbleKilled && !0 == e[g].hanging) {
                            d = !0;
                            break
                        }
                    75 > c.y && (d = !0);
                    if (!0 == d) break;
                    this.guides.push(c)
                }
            }
        },
        reGen: function() {},
        setStartPosition: function() {
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
            this.startOffset = Math.abs(this.stage.startOffset);
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y + this.stage.pos.y
        },
        shoot: function() {
            !0 != this.main.tutOn && !0 != this.main.noArmo && (!0 != this.tweening && !0 != this.stage.tween && !1 != this.main.allowShoot && !1 != this.allowShoot && !1 != this.main.doneCombo && this.main.totalBaby != this.main.babyRescued && !1 != this.main.gameStarted &&
                !0 != this.main.gameOver && !0 != this.main.gamePaused && !1 != this.bubble["nextBubble" + this.bubble.nextBubbleToggle].allow) && (this.sounder("click"), this.drawGuide = !1, this.main.gameStarted = !0, this.allowShoot = this.main.allowShoot = !1, this.flip.x = this.pointer.pos.x + this.pointer.size.x / 2 > ig.system.width / 2 ? !1 : !0, this.tweenF("toss1"))
        },
        aniStuff: function() {
            this.animSheet = new ig.AnimationSheet(this.im.path, this.im.width / this.sheetX, this.im.height / this.sheetY);
            this.size.x = (this.animSheet.width - 4) * this.sc.x;
            this.size.y =
                (this.animSheet.height - 8) * this.sc.y;
            this.addAnim("idle", 0.1, [0], !0);
            this.addAnim("middle", 0.1, [1], !0);
            this.addAnim("top", 0.1, [2], !0);
            this.currentAnim = this.anims.idle;
            this.currentAnim.pivot.x += 20;
            this.currentAnim.pivot.y += 40
        },
        tweenF: function(b) {
            switch (b) {
                case "toss1":
                    this.bubble.shootBubble(this.rad);
                    this.tweening = !0;
                    this.tweener("this", {
                            pos: {
                                y: this.oriPos.y - (this.angleRange - Math.abs(this.rot)),
                                x: this.oriPos.x + 2 * this.rot
                            },
                            refAngle: this.getRad(1.8 * this.rot),
                            shadow: {
                                scX: 1.2,
                                alp: 0.5,
                                offX: this.rot
                            }
                        }, 0.2,
                        "toss2");
                    this.tweener("this", {}, 0.1, "anim0");
                    break;
                case "toss2":
                    this.tweener("this", {
                        pos: {
                            y: this.oriPos.y,
                            x: this.oriPos.x
                        },
                        refAngle: 0,
                        shadow: {
                            scX: 1,
                            alp: 1,
                            offX: 0
                        }
                    }, 0.2);
                    break;
                case "anim0":
                    this.currentAnim = this.anims.middle;
                    this.tweener("this", {}, 0.03, "anim1");
                    break;
                case "anim1":
                    this.currentAnim = this.anims.top;
                    this.tweener("this", {}, 0.2, "anim2");
                    break;
                case "anim2":
                    this.currentAnim = this.anims.middle;
                    this.tweener("this", {}, 0.03, "anim3");
                    break;
                case "anim3":
                    this.currentAnim = this.anims.idle, this.tweening = !1
            }
        },
        getDeg: function(b) {
            return b * (180 / Math.PI)
        },
        getRad: function(b) {
            return b * (Math.PI / 180)
        },
        update: function() {
            !ig.global.wm && !0 != this.main.gamePaused && (this.parent(), this.currentAnim.flip.x = this.flip.x, this.pointer.update(), this.offset.x = !0 == this.currentAnim.flip.x ? -20 : 22, !0 == this.stage.startTween && (this.pos.y = this.oriPos.y + this.stage.pos.y + this.startOffset, this.shadow.y = this.oriPos.y + this.stage.pos.y + this.startOffset + 110), this.currentAnim.angle = this.refAngle, 500 > this.pointer.pos.y && (this.rot = this.angleRange -
                2 * (Math.abs(this.angleTo(this.pointer)) / 3.142) * this.angleRange, this.rad = this.angleTo(this.pointer), this.setGuide(), ig.input.released("click") && (!0 == this.stage.startTween && !0 == this.main.gameStarted ? (this.stage.stopTweens(), this.stage.tweener2("pos", {
                    y: this.stage.startOffset
                }, 0.3, "startTween")) : this.shoot())))
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0]
        },
        draw: function() {
            if (!ig.global.wm && void 0 != this.guides) {
                if (500 > this.pointer.pos.y && !0 == this.drawGuide)
                    for (var b = 0; b < this.guides.length; b++) this.ctx.fillStyle = "white", this.ctx.beginPath(), this.ctx.arc(this.guides[b].x, this.guides[b].y, 4, 0, 2 * Math.PI), this.ctx.closePath(), this.ctx.fill();
                this.drawer({
                    pic: this.shadowIm,
                    x: ig.system.width / 2 - 2 - 0.5 * this.offset.x + this.shadow.offX,
                    y: this.shadow.y,
                    cent: !0,
                    scX: this.shadow.scX,
                    scY: 1,
                    alp: this.shadow.alp
                });
                this.parent()
            }
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-menu-but").requires("game.entities.plain").defines(function() {
    EntityPlainMenuBut = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2040,
        sc: 0,
        mouseSc: 0.95,
        runTask: !1,
        tweening: !1,
        oriPos: {
            x: 0,
            y: 0
        },
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.name = d.name, this.menu = d.menu, void 0 != this.menu && this.menu.buttons.push(this), this.size.x = this.butIm.width, this.size.y = this.butIm.height, this.oriPos.x = b, this.oriPos.y = c, this.hide(), this.oriStat && this.oriStat())
        },
        clicked: function() {
            this.sc = 0.9;
            this.buttonTask();
            this.sounder("click")
        },
        released: function() {
            !0 != this.tweening && (this.sc = 1)
        },
        hide: function() {
            this.pos.x = -200;
            this.pos.y = -200
        },
        show: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y + this.menu.offY
        },
        tweenF: function(b) {
            switch (b) {
                case "delayTask":
                    this.tweener("this", {}, 0.05, "delayTask2");
                    break;
                case "delayTask2":
                    this.delayTask();
                    break;
                case "floatUp":
                    this.tweener("pos", {
                        y: this.oriPos.y - 10
                    }, 0.3, "floatDown");
                    break;
                case "floatDown":
                    this.tweener("pos", {
                        y: this.oriPos.y + 10
                    }, 0.3, "floatUp");
                    break;
                case "fadeIn":
                    this.show();
                    this.tweening = !0;
                    this.tweener("this", {
                        sc: 1
                    }, 0.3, "doneFade");
                    break;
                case "doneFade":
                    this.tweening = !1;
                    break;
                case "fadeOut":
                    this.tweening = !0;
                    this.tweener("this", {
                        sc: 0
                    }, 0.3, "fadeOut2");
                    break;
                case "fadeOut2":
                    this.tweening = !1, this.oriPos.x = this.pos.x, this.hide()
            }
        },
        update: function() {
            ig.global.wm || (this.parent(), !0 == this.menu.tweening && (this.pos.y = this.oriPos.y + this.menu.offY), !0 != this.tweening && (this.mouseSc = this.pointer.hoveringItem == this ?
                1 : 0.95))
        },
        drawInit: function() {},
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0]
        },
        draw: function() {
            this.parent();
            ig.global.wm || this.drawer({
                pic: this.butIm,
                x: this.pos.x + this.butIm.width / 2,
                y: this.pos.y + this.butIm.height / 2,
                scX: this.oriSc * this.sc * this.mouseSc,
                scY: this.oriSc * this.sc * this.mouseSc,
                cent: !0
            })
        }
    });
    EntityCloseBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/close.png"),
        buttonTask: function() {
            !0 != this.tweening && !1 != this.main.gamePaused &&
                (this.menu.task = "unpause", this.menu.tweenF("pauseFadeOut"))
        }
    });
    EntityOkayBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/ok.png"),
        buttonTask: function() {
            !0 != this.tweening && !1 != this.main.gamePaused && (this.menu.task = "unpause", this.menu.tweenF("pauseFadeOut"))
        }
    });
    EntityMenuBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/menu.png"),
        buttonTask: function() {
            !0 != this.tweening && (this.main.gamePaused = !0, this.menu.task = "home", this.menu.tweenF("pauseFadeOut"))
        }
    });
    EntityMusicKnot = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        hold: {
            x: 0,
            y: 0
        },
        holding: !1,
        butIm: new ig.Image("media/graphics/sprites/music.png"),
        posRef: {
            x: 0,
            y: 0
        },
        oriStat: function() {
            this.posRef.x = this.oriPos.x
        },
        ready: function() {
            this.parent();
            this.oriPos.x = this.posRef.x + 128 * ig.game.musicVolume
        },
        buttonTask: function() {
            !0 != this.tweening && !1 == this.holding && (this.holding = !0, this.hold.x = this.pos.x - this.pointer.pos.x)
        },
        update: function() {
            !0 == this.holding && (this.pos.x = this.pointer.pos.x + this.hold.x, this.pos.x < this.posRef.x &&
                (this.pos.x = this.posRef.x), this.pos.x > this.posRef.x + 128 && (this.pos.x = this.posRef.x + 128), ig.ua.mobile ? ig.soundHandler.jukebox.player.setVolume((this.pos.x - this.posRef.x) / 128) : ig.music.volume = (this.pos.x - this.posRef.x) / 128, ig.input.released("click") && (this.released(), this.holding = this.pointer.firstClick = !1, ig.game.setMusic((this.pos.x - this.posRef.x) / 128), this.sounder("click")));
            this.parent()
        }
    });
    EntitySoundKnot = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/sound.png"),
        holding: !1,
        hold: {
            x: 0,
            y: 0
        },
        posRef: {
            x: 0,
            y: 0
        },
        oriStat: function() {
            this.posRef.x = this.oriPos.x
        },
        ready: function() {
            this.parent();
            this.oriPos.x = this.posRef.x + 128 * ig.game.soundVolume
        },
        buttonTask: function() {
            !0 != this.tweening && !1 == this.holding && (this.holding = !0, this.hold.x = this.pos.x - this.pointer.pos.x)
        },
        update: function() {
            !0 == this.holding && (this.pos.x = this.pointer.pos.x + this.hold.x, this.pos.x < this.posRef.x && (this.pos.x = this.posRef.x), this.pos.x > this.posRef.x + 128 && (this.pos.x = this.posRef.x + 128), ig.input.released("click") &&
                (this.released(), this.pointer.firstClick = !1, ig.game.setSound((this.pos.x - this.posRef.x) / 128), this.holding = !1, this.sounder("click")));
            this.parent()
        }
    });
    EntityContinueBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/play.png"),
        buttonTask: function() {
            !0 != this.tweening && !1 != this.main.gamePaused && (this.menu.task = "unpause", this.menu.tweenF("pauseFadeOut"))
        }
    });
    EntityReplayBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/replay.png"),
        buttonTask: function() {
            !0 !=
                this.tweening && (this.main.gamePaused = !0, this.menu.task = "replay", this.menu.tweenF("pauseFadeOut"))
        }
    });
    EntityProceedBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/continue.png"),
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainOver)[0]
        },
        buttonTask: function() {
            !0 != this.tweening && (this.main.gamePaused = !0, this.menu.task = "next", this.menu.tweenF("pauseFadeOut"))
        }
    });
    EntityLevelNextBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/next.png"),
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainLevel)[0]
        },
        buttonTask: function() {
            !0 != this.tweening && this.tweenF("delayTask")
        },
        delayTask: function() {
            !0 != this.tweening && (this.menu.page = 2)
        },
        draw: function() {
            1 == this.menu.page && this.parent()
        }
    });
    EntityLevelPrevBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/prev.png"),
        ready: function() {
            this.pointer =
                ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainLevel)[0]
        },
        buttonTask: function() {
            !0 != this.tweening && this.tweenF("delayTask")
        },
        delayTask: function() {
            !0 != this.tweening && (this.menu.page = 1)
        },
        draw: function() {
            2 == this.menu.page && this.parent()
        }
    });
    EntityLevelCloseBut = EntityPlainMenuBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/close.png"),
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainLevel)[0]
        },
        buttonTask: function() {
            !0 != this.tweening && !1 != this.main.gamePaused && (this.menu.task = "unpause", this.menu.tweenF("pauseFadeOut"), this.tweening = !0, ig.game.showOverlay(["more-games"]))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-but").requires("game.entities.plain").defines(function() {
    EntityPlainBut = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2040,
        sc: 0,
        mouseSc: 0.95,
        runTask: !1,
        tweening: !1,
        oriPos: {
            x: 0,
            y: 0
        },
        alp: 1,
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.name = d.name, this.menu = d.menu, void 0 != this.menu && this.menu.buttons.push(this), this.size.x = this.butIm.width, this.size.y = this.butIm.height, this.oriPos.x = b, this.oriPos.y = c, this.hide(), this.oriStat && this.oriStat())
        },
        clicked: function() {
            this.sc = 0.9;
            this.buttonTask()
        },
        released: function() {
            !0 != this.tweening && (this.sc = 1)
        },
        hide: function() {
            this.pos.x = -200;
            this.pos.y = -200
        },
        show: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y
        },
        tweenF: function(b) {
            switch (b) {
                case "delayTask":
                    this.tweener("this", {}, 0.05, "delayTask2")
            }
        },
        update: function() {
            !ig.global.wm && !0 != this.tweening && (this.mouseSc = this.pointer.hoveringItem == this ? 1 : 0.95)
        },
        drawInit: function() {},
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0]
        },
        draw: function() {
            this.parent();
            ig.global.wm || this.drawer({
                pic: this.butIm,
                x: this.pos.x + this.butIm.width / 2,
                y: this.pos.y + this.butIm.height / 2,
                scX: this.oriSc * this.sc * this.mouseSc,
                scY: this.oriSc * this.sc * this.mouseSc,
                cent: !0,
                alp: this.alp
            })
        }
    });
    EntityPauseBut = EntityPlainBut.extend({
        zIndex: 2020,
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/pause.png"),
        oriStat: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y;
            this.sc = 1
        },
        buttonTask: function() {
            if (!0 != this.main.gameOver && !0 != this.main.gamePaused &&
                !0 != this.tweening) {
                this.sounder("click");
                this.main.gamePaused = !0;
                this.menu.tweenF("pauseFadeIn");
                for (var b = 0; b < ig.game.entities.length; b++) {
                    var c = ig.game.entities[b];
                    (c instanceof EntityPlainTile || c instanceof EntityPlainStage || c instanceof EntityPlainBubble || c instanceof EntityPlainGame || c instanceof EntityPlainShooter || c instanceof EntityPlainReady || c instanceof EntityPlainGui) && c.pauseTweens()
                }
            }
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainPause)[0]
        }
    });
    EntityToggleBubbleBut = EntityPlainBut.extend({
        zIndex: 2020,
        oriSc: 0.7,
        butIm: new ig.Image("media/graphics/sprites/arrow.png"),
        oriStat: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y;
            this.sc = 1
        },
        buttonTask: function() {
            !1 != this.main.gameStarted && !0 != this.main.gameOver && (!0 != this.main.gamePaused && !0 != this.tweening) && (this.sounder("click"), this.bubble.toggleBubble())
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
            this.startOffset = Math.abs(this.stage.startOffset)
        },
        update: function() {
            ig.global.wm || (this.alp = 1 >= this.bubble.armoLeft ? 0.5 : 1, this.pos.y = !0 == this.stage.startTween ? this.oriPos.y + this.stage.pos.y + this.startOffset : this.oriPos.y, !0 != this.tweening && (this.mouseSc = this.pointer.hoveringItem == this ? 1 : 0.95, ig.input.released("toggle") && this.buttonTask()))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-pause").requires("game.entities.plain").defines(function() {
    EntityPlainPause = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2030,
        size: {
            x: 50,
            y: 50
        },
        task: "unpause",
        pauseRect: {
            alp: 0,
            targAlp: 0.5,
            colour: "black"
        },
        boardIm: new ig.Image("media/graphics/sprites/board.png"),
        musicIm: new ig.Image("media/graphics/sprites/music.png"),
        soundIm: new ig.Image("media/graphics/sprites/sound.png"),
        settingIm: new ig.Image("media/graphics/sprites/setting.png"),
        sliderIm: new ig.Image("media/graphics/sprites/slider.png"),
        headerIm: new ig.Image("media/graphics/sprites/header.png"),
        buttons: [],
        offY: -600,
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), ig.game.spawnEntity(EntityCloseBut, 363, 186, {
                    main: this.main,
                    menu: this
                }), ig.game.spawnEntity(EntityMusicKnot, 205, 250, {
                    main: this.main,
                    menu: this
                }), ig.game.spawnEntity(EntitySoundKnot, 205, 311, {
                    main: this.main,
                    menu: this
                }), ig.game.spawnEntity(EntityMenuBut, ig.system.width / 2 - 60 - 50, 368, {
                    main: this.main,
                    menu: this
                }), ig.game.spawnEntity(EntityReplayBut, ig.system.width / 2 - 25, 370, {
                    main: this.main,
                    menu: this
                }), ig.game.spawnEntity(EntityContinueBut, ig.system.width / 2 + 60, 367, {
                    main: this.main,
                    menu: this
                }), ig.game.spawnEntity(EntityProceedBut, ig.system.width / 2 + 60, 367, {
                    main: this.main
                }), this.board = {
                    x: ig.system.width / 2,
                    y: 300,
                    offX: 0,
                    offY: 0,
                    scX: 0,
                    scY: 0
                }, this.header = {
                    x: 0,
                    y: -100,
                    offX: 0,
                    offY: 0,
                    scX: 1,
                    scY: 1
                }, this.title = {
                    x: 0,
                    y: -5,
                    offX: 0,
                    offY: 0,
                    scX: 1,
                    scY: 1,
                    grad1: -20,
                    grad2: 3
                }, this.title.grad = this.ctx.createLinearGradient(0, this.title.grad1, 0, this.title.grad2), this.title.grad.addColorStop(0, "#e6e438"),
                this.title.grad.addColorStop(0.3, "#c2d73a"), this.title.grad.addColorStop(1, "#6d8225"), this.music = {
                    x: -90,
                    y: -33,
                    lineX: 50,
                    lineY: -30,
                    offX: 0,
                    offY: 0,
                    scX: 1,
                    scY: 1
                }, this.sound = {
                    x: -90,
                    y: 28,
                    lineX: 50,
                    lineY: 30,
                    offX: 0,
                    offY: 0,
                    scX: 1,
                    scY: 1
                }, this.renderText())
        },
        renderText: function() {
            !0 != ig.game.played && this.textDraw({
                ctx: ig.game.hidCtx,
                px: 28,
                tx: _STRINGS.Game.Paused,
                x: 950,
                y: 20,
                stroke: !0,
                strokeColour: "#56612f",
                strokeLine: 6,
                col: this.title.grad
            })
        },
        tweenF: function(b) {
            switch (b) {
                case "pauseFadeIn":
                    this.tweening = !0;
                    this.tweener("pauseRect", {
                        alp: this.pauseRect.targAlp
                    }, 0.3, "boardfadeIn");
                    break;
                case "boardfadeIn":
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeIn2");
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.3, "boardSize4");
                    break;
                case "boardSize2":
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.1, "boardSize3");
                    break;
                case "boardSize3":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.05
                    }, 0.1, "boardSize4");
                    break;
                case "boardSize4":
                    this.tweener("board", {
                        scX: 1,
                        scY: 1
                    }, 0.1);
                    break;
                case "boardfadeIn2":
                    this.tweener("this", {
                        offY: 0
                    }, 0.3, "donefadeIn");
                    for (b = 0; b < this.buttons.length; b++) this.buttons[b].tweenF("fadeIn");
                    break;
                case "donefadeIn":
                    this.tweening = !1;
                    break;
                case "pauseFadeOut":
                    this.tweening = !0;
                    for (b = 0; b < this.buttons.length; b++) this.buttons[b].tweenF("fadeOut");
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeOut2");
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.3, "boardSizeOut");
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.1
                    }, 0.3, "boardSizeOut2");
                    this.tweener("pauseRect", {
                        alp: 0
                    }, 0.3);
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0,
                        scY: 0
                    }, 0.3);
                    break;
                case "boardfadeOut2":
                    this.tweener("this", {
                            offY: -500
                        },
                        0.3, "donefadeOut");
                    break;
                case "donefadeOut":
                    this.tweening = !1, this.runTask()
            }
        },
        runTask: function() {
            switch (this.task) {
                case "unpause":
                    this.main.gamePaused = !1;
                    for (var b = 0; b < ig.game.entities.length; b++) {
                        var c = ig.game.entities[b];
                        (c instanceof EntityPlainTile || c instanceof EntityPlainStage || c instanceof EntityPlainBubble || c instanceof EntityPlainGame || c instanceof EntityPlainShooter || c instanceof EntityPlainReady || c instanceof EntityPlainGui) && c.resumeTweens()
                    }
                    break;
                case "replay":
                    ig.game.director.jumpTo(LevelGame);
                    break;
                case "home":
                    this.main.gamePaused = !1, ig.game.showLvlMenu = !0, ig.game.director.jumpTo(LevelHome)
            }
        },
        update: function() {
            ig.global.wm || this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            for (var b = 0; b < this.buttons.length; b++) this.buttons[b].menu = this
        },
        draw: function() {
            this.parent();
            ig.global.wm || (!0 == this.main.gamePaused && (this.ctx.fillStyle = this.pauseRect.colour, this.ctx.globalAlpha = this.pauseRect.alp, this.ctx.fillRect(0, 0, ig.system.width, ig.system.height)), this.drawer({
                x: this.board.x,
                y: this.board.y + this.offY,
                cent: !0,
                scX: this.board.scX,
                scY: this.board.scY,
                pic: this.settingIm
            }), this.drawer({
                x: this.board.x + this.header.x,
                y: this.board.y + this.header.y + this.offY,
                cent: !0,
                scX: this.board.scX * this.header.scX,
                scY: this.board.scY * this.header.scY,
                pic: this.headerIm
            }), this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.board.x + this.header.x,
                y: this.board.y + this.header.y + this.title.y + this.offY,
                sx: 890,
                sy: 0,
                sw: 120,
                sh: 40,
                cent: !0
            }), this.drawer({
                x: this.board.x + this.music.lineX,
                y: this.board.y + this.music.lineY + this.offY,
                cent: !0,
                scX: this.board.scX * this.music.scX,
                scY: this.board.scY * this.music.scY,
                pic: this.sliderIm
            }), this.textDraw({
                px: 20,
                tx: _STRINGS.Game.Music,
                x: this.board.x + this.music.x,
                y: this.board.y + this.music.y + this.offY,
                col: "#4d3200"
            }), this.drawer({
                x: this.board.x + this.sound.lineX,
                y: this.board.y + this.sound.lineY + this.offY,
                cent: !0,
                scX: this.board.scX * this.sound.scX,
                scY: this.board.scY * this.sound.scY,
                pic: this.sliderIm
            }), this.textDraw({
                px: 20,
                tx: _STRINGS.Game.Sound,
                x: this.board.x + this.sound.x,
                y: this.board.y + this.sound.y +
                    this.offY,
                col: "#4d3200"
            }))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-level-box").requires("game.entities.plain", "game.entities.plain-menu-but").defines(function() {
    EntityPlainLevelBox = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2031,
        size: {
            x: 50,
            y: 50
        },
        oriPos: {
            x: 0,
            y: 0
        },
        mouseSc: 0.95,
        infiLockedIm: new ig.Image("media/graphics/sprites/infi-locked.png"),
        infiIm: new ig.Image("media/graphics/sprites/infi.png"),
        lvlIm: new ig.Image("media/graphics/sprites/lvl.png"),
        starIm: new ig.Image("media/graphics/sprites/rank-small.png"),
        baseIm: new ig.Image("media/graphics/sprites/rank-base-small.png"),
        sc: 1,
        buttons: [],
        clicked: function() {
            this.sc = 0.9;
            this.tweenF("delayTask");
            this.sounder("click")
        },
        released: function() {
            !0 != this.tweening && (this.sounder("click"), this.sc = 1)
        },
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.oriPos.x = b, this.oriPos.y = c, this.level = d.level, this.main = d.main, this.getSize("lvlIm"))
        },
        buttonTask: function() {
            !1 != ig.game.levelStat[this.level + 12 * (this.menu.page - 1)].unlocked && (ig.game.lvl = this.level + 12 * (this.menu.page - 1), ig.game.director.jumpTo(LevelGame))
        },
        tweenF: function(b) {
            switch (b) {
                case "fadeIn":
                    this.tweener("this", {
                        sc: 1
                    }, 0.3);
                    break;
                case "fadeOut":
                    this.tweener("this", {
                        sc: 0
                    }, 0.3);
                    break;
                case "delayTask":
                    this.tweener("this", {}, 0.01, "runTask");
                    break;
                case "runTask":
                    this.buttonTask()
            }
        },
        runTask: function() {
            switch (this.task) {
                case "unpause":
                    this.main.gamePaused = !1;
                    break;
                case "replay":
                    this.menu.offY = -600;
                    ig.game.director.jumpTo(LevelGame);
                    break;
                case "home":
                    this.main.gamePaused = !1, ig.game.director.jumpTo(LevelHome)
            }
        },
        update: function() {
            ig.global.wm || (this.parent(), this.pos.y = this.oriPos.y + this.menu.offY, !0 != this.tweening &&
                (this.mouseSc = this.pointer.hoveringItem == this ? 1 : 0.95))
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainLevel)[0]
        },
        draw: function() {
            this.parent();
            if (!1 != this.menu.drawing && !ig.global.wm) {
                this.drawer({
                    x: this.pos.x + this.halfSize.x,
                    y: this.pos.y + this.halfSize.y,
                    cent: !0,
                    pic: this.lvlIm,
                    scX: 0.9 * this.menu.board.scX * this.sc * this.mouseSc,
                    scY: 0.9 * this.menu.board.scY * this.sc * this.mouseSc
                });
                24 == this.level + 12 * (this.menu.page - 1) + 1 ? this.drawer({
                    pic: !0 ==
                        ig.game.levelStat[this.level + 12 * (this.menu.page - 1)].unlocked ? this.infiIm : this.infiLockedIm,
                    x: this.pos.x + this.halfSize.x,
                    y: this.pos.y + 0.71 * this.halfSize.y + 2,
                    cent: !0,
                    scX: this.menu.board.scX * this.sc * this.mouseSc,
                    scY: this.menu.board.scY * this.sc * this.mouseSc
                }) : this.textDraw({
                    tx: this.level + 12 * (this.menu.page - 1) + 1,
                    px: 27,
                    x: this.pos.x + this.halfSize.x,
                    y: this.pos.y + 0.71 * this.halfSize.y,
                    col: !0 == ig.game.levelStat[this.level + 12 * (this.menu.page - 1)].unlocked ? "white" : "#553600",
                    stroke: !0,
                    strokeColour: "#270600",
                    strokeLine: 5,
                    scX: 0.9 * this.menu.board.scX * this.sc * this.mouseSc,
                    scY: 0.9 * this.menu.board.scY * this.sc * this.mouseSc
                });
                for (var b = 0; 3 > b; b++) b < ig.game.levelStat[this.level + 12 * (this.menu.page - 1)].star ? this.drawer({
                    pic: this.starIm,
                    x: this.pos.x + this.halfSize.x + 16 * (b - 1) * this.mouseSc * this.sc,
                    y: this.pos.y + this.halfSize.y + 0.55 * this.halfSize.y * this.mouseSc * this.sc,
                    cent: !0,
                    scX: 0.8 * this.menu.board.scX * this.sc * this.mouseSc,
                    scY: 0.8 * this.menu.board.scY * this.sc * this.mouseSc
                }) : this.drawer({
                    pic: this.baseIm,
                    x: this.pos.x + this.halfSize.x +
                        16 * (b - 1) * this.mouseSc * this.sc,
                    y: this.pos.y + this.halfSize.y + 0.55 * this.halfSize.y * this.mouseSc * this.sc,
                    cent: !0,
                    scX: 0.8 * this.menu.board.scX * this.sc * this.mouseSc,
                    scY: 0.8 * this.menu.board.scY * this.sc * this.mouseSc
                })
            }
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-ready").requires("game.entities.plain").defines(function() {
    EntityPlainReady = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 2E3,
        w: 800,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        textSize: 80,
        strokeSize: 7,
        shadowCol: "#fffbe3",
        readyText: {
            seq: 0,
            x: 240,
            y: 50,
            scX: 1,
            scY: 1,
            alp: 1,
            offX: 0,
            offY: 0,
            rot: 0
        },
        goText: {
            seq: 0,
            x: 240,
            y: 150,
            scX: 1,
            scY: 1,
            alp: 1,
            offX: 0,
            offY: 0,
            rot: 0
        },
        r: {
            seq: 0,
            x: 135,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 0,
            offX: 0,
            offY: 0,
            rot: 0
        },
        e: {
            seq: 1,
            x: 187,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 0,
            offX: 0,
            offY: 0,
            rot: 0
        },
        a: {
            seq: 2,
            x: 245,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 0,
            offX: 0,
            offY: 0,
            rot: 0
        },
        d: {
            seq: 3,
            x: 305,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 0,
            offX: 0,
            offY: 0,
            rot: 0
        },
        y: {
            seq: 4,
            x: 350,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 0,
            offX: 0,
            offY: 0,
            rot: 0
        },
        g: {
            seq: 0,
            x: 205,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 1,
            offX: 0,
            offY: 0,
            rot: 0
        },
        o: {
            seq: 1,
            x: 275,
            y: 250,
            scX: 0,
            scY: 0,
            alp: 1,
            offX: 0,
            offY: 0,
            rot: 0
        },
        grad1: -60,
        grad2: 10,
        drawSheetCent: function() {},
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.main = d.main, this.grad = this.ctx.createLinearGradient(0, this.grad1, 0, this.grad2), this.grad.addColorStop(0, "#fffcea"), this.grad.addColorStop(0.8,
                "#ffd05c"), this.grad.addColorStop(1, "#a85a15"), this.shadowGrad = this.ctx.createLinearGradient(0, this.grad1, 0, this.grad2), this.shadowGrad.addColorStop(0, "#FFFFFF"), this.shadowGrad.addColorStop(1, "#fffbe3"), this.strokeGrad = this.ctx.createLinearGradient(0, this.grad1, 0, this.grad2), this.strokeGrad.addColorStop(0, "#6d3a08"), this.strokeGrad.addColorStop(0.7, "#8a470b"), this.strokeGrad.addColorStop(1, "#6d3a08"), this.preRender())
        },
        tweenF: function(b) {
            switch (b) {
                case "ready":
                    this.readyText = {
                        seq: 0,
                        x: 250,
                        y: 250,
                        scX: 1,
                        scY: 1,
                        alp: 0,
                        offX: 0,
                        offY: 0,
                        rot: 0
                    };
                    this.goText = {
                        seq: 0,
                        x: 250,
                        y: 250,
                        scX: 1,
                        scY: 1,
                        alp: 0,
                        offX: 0,
                        offY: 0,
                        rot: 0
                    };
                    this.tweener("readyText", {
                        alp: 1,
                        scX: 1.3,
                        scY: 1.3
                    }, 0.2, "ready2");
                    break;
                case "ready2":
                    this.tweener("readyText", {
                        scX: 1,
                        scY: 1
                    }, 0.2, "ready3");
                    this.sounder("count");
                    break;
                case "ready3":
                    this.tweener("readyText", {
                        scX: 1.3,
                        scY: 1.3
                    }, 0.1, "ready4", 0.3);
                    break;
                case "ready4":
                    this.tweener("readyText", {
                        scX: 0,
                        scY: 0,
                        alp: 0
                    }, 0.2, "go");
                    break;
                case "go":
                    this.tweener("goText", {
                        alp: 1,
                        scX: 1.3,
                        scY: 1.3
                    }, 0.2, "go2");
                    break;
                case "go2":
                    this.sounder("count");
                    this.tweener("goText", {
                        scX: 1,
                        scY: 1
                    }, 0.2, "go3");
                    break;
                case "go3":
                    this.tweener("goText", {
                        scX: 1.3,
                        scY: 1.3
                    }, 0.1, "go4", 0.3);
                    break;
                case "go4":
                    this.tweener("goText", {
                        scX: 0,
                        scY: 0,
                        alp: 0
                    }, 0.2, "startGame");
                    break;
                case "startGame":
                    this.main.startGame()
            }
        },
        update: function() {
            ig.global.wm || !0 != this.main.gamePaused && this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.tweenF("ready")
        },
        preRender: function() {
            !0 != ig.game.played && (this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.READY,
                x: this.readyText.x + this.readyText.offX,
                y: this.readyText.y + this.readyText.offY + 2,
                stroke: !0,
                strokeColour: this.strokeGrad,
                strokeLine: 8,
                col: "#92551c",
                scX: this.readyText.scX,
                scY: this.readyText.scY,
                alp: this.readyText.alp,
                strokeAlp: this.readyText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.READY,
                x: this.readyText.x + this.readyText.offX,
                y: this.readyText.y + this.readyText.offY,
                stroke: !0,
                strokeColour: this.strokeGrad,
                strokeLine: this.strokeSize,
                col: "#92551c",
                scX: this.readyText.scX,
                scY: this.readyText.scY,
                alp: this.readyText.alp,
                strokeAlp: this.readyText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.READY,
                x: this.readyText.x + this.readyText.offX,
                y: this.readyText.y + this.readyText.offY - 1,
                stroke: !0,
                strokeColour: this.strokeGrad,
                strokeLine: this.strokeSize,
                col: this.shadowGrad,
                scX: this.readyText.scX,
                scY: this.readyText.scY,
                alp: this.readyText.alp,
                strokeAlp: this.readyText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.READY,
                x: this.readyText.x + this.readyText.offX - 1,
                y: this.readyText.y + this.readyText.offY,
                col: this.grad,
                scX: this.readyText.scX,
                scY: this.readyText.scY,
                alp: this.readyText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.GO,
                x: this.goText.x + this.goText.offX,
                y: this.goText.y + this.goText.offY + 2,
                stroke: !0,
                strokeColour: this.strokeGrad,
                strokeLine: this.strokeSize,
                col: "#92551c",
                scX: this.goText.scX,
                scY: this.goText.scY,
                alp: this.goText.alp,
                strokeAlp: this.goText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.GO,
                x: this.goText.x + this.goText.offX,
                y: this.goText.y + this.goText.offY,
                stroke: !0,
                strokeColour: this.strokeGrad,
                strokeLine: this.strokeSize,
                col: "#92551c",
                scX: this.goText.scX,
                scY: this.goText.scY,
                alp: this.goText.alp,
                strokeAlp: this.goText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.GO,
                x: this.goText.x + this.goText.offX,
                y: this.goText.y + this.goText.offY - 1,
                stroke: !0,
                strokeColour: this.strokeGrad,
                strokeLine: this.strokeSize,
                col: this.shadowGrad,
                scX: this.goText.scX,
                scY: this.goText.scY,
                alp: this.goText.alp,
                strokeAlp: this.goText.alp
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: this.textSize,
                tx: _STRINGS.Game.GO,
                x: this.goText.x + this.goText.offX - 1,
                y: this.goText.y + this.goText.offY,
                col: this.grad,
                scX: this.goText.scX,
                scY: this.goText.scY,
                alp: this.goText.alp
            }), this.readyText = {
                seq: 0,
                x: 240,
                y: 50,
                scX: 1,
                scY: 1,
                alp: 1,
                offX: 0,
                offY: 0,
                rot: 0
            }, this.goText = {
                seq: 0,
                x: 240,
                y: 150,
                scX: 1,
                scY: 1,
                alp: 1,
                offX: 0,
                offY: 0,
                rot: 0
            })
        },
        draw: function() {
            this.parent();
            ig.global.wm || (this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.goText.x + this.goText.offX,
                y: this.goText.y + this.goText.offY + 2,
                scX: this.goText.scX,
                scY: this.goText.scY,
                alp: this.goText.alp,
                sx: 40,
                sy: 100,
                sw: 400,
                sh: 100,
                cent: !0
            }), this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.readyText.x + this.readyText.offX,
                y: this.readyText.y + this.readyText.offY + 2,
                scX: this.readyText.scX,
                scY: this.readyText.scY,
                alp: this.readyText.alp,
                sx: 40,
                sy: 0,
                sw: 400,
                sh: 100,
                cent: !0
            }))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-over").requires("game.entities.plain").defines(function() {
    EntityPlainOver = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 3E3,
        h: 600,
        w: 800,
        sc: 2,
        offY: -500,
        size: {
            x: 50,
            y: 50
        },
        gameOver: !1,
        gamePaused: !1,
        bgIm: new ig.Image("media/graphics/sprites/bg.png"),
        rect: {
            alp: 0,
            targAlp: 0.5,
            colour: "black"
        },
        boardIm: new ig.Image("media/graphics/sprites/board.png"),
        buttons: [],
        starIm: new ig.Image("media/graphics/sprites/rank-big.png"),
        baseIm: new ig.Image("media/graphics/sprites/rank-base-big.png"),
        headerIm: new ig.Image("media/graphics/sprites/header.png"),
        slotIm: new ig.Image("media/graphics/sprites/text-base.png"),
        task: "unpause",
        textGap: 30,
        winGap: 30,
        loseGap: 35,
        win: !0,
        tx: [],
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.main = d.main, this.tx[0] = this.main.score, this.tx[1] = this.main.score, this.tx[2] = this.main.score, this.spawner(), this.board = {
                x: ig.system.width / 2,
                y: 300,
                offX: 0,
                offY: 0,
                scX: 0,
                scY: 0
            }, this.header = {
                x: 0,
                y: -100,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1
            }, this.title = {
                x: 0,
                y: -5,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1,
                grad1: -20,
                grad2: 0
            }, this.slot0 = {
                textX: -38,
                x: 50,
                y: 20,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1,
                grad1: -20,
                grad2: 0,
                col: "#553600",
                align: "right",
                tx: _STRINGS.Game.Score
            }, this.slot1 = {
                textX: -50,
                x: 50,
                y: this.slot0.y + 33,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1,
                grad1: -20,
                grad2: 0,
                tx: _STRINGS.Game.Highscore
            }, this.slot2 = {
                textX: -50,
                x: 50,
                y: this.slot0.y + 60,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1,
                grad1: -20,
                grad2: 0,
                tx: _STRINGS.Game.Coin
            }, this.star0 = {
                x: -70,
                y: -43,
                offX: 0,
                offY: 0,
                sc: 0,
                oriSc: 0.8,
                grad1: -20,
                grad2: 0,
                im: this.baseIm,
                rot: 0,
                delay: 0
            }, this.star1 = {
                x: 0,
                y: -43,
                offX: 0,
                offY: 0,
                sc: 0,
                oriSc: 0.8,
                grad1: -20,
                grad2: 0,
                im: this.baseIm,
                rot: 0,
                delay: 0.1
            }, this.star2 = {
                x: 70,
                y: -43,
                offX: 0,
                offY: 0,
                sc: 0,
                oriSc: 0.8,
                grad1: -20,
                grad2: 0,
                im: this.baseIm,
                rot: 0,
                delay: 0.2
            }, this.title.grad = this.ctx.createLinearGradient(0, this.title.grad1, 0, this.title.grad2), this.title.grad.addColorStop(0, "#febc41"), this.title.grad.addColorStop(0.3, "#fe802b"), this.title.grad.addColorStop(0.6, "#fe623a"), this.title.grad.addColorStop(0.8, "#ff3d0a"), this.title.grad.addColorStop(1, "#fe623a"), this.renderText())
        },
        spawner: function() {},
        tweenF: function(b, c) {
            switch (b) {
                case "pauseFadeIn":
                    for (var d = 0; d < this.buttons.length; d++) this.buttons[d].menu = this, this.buttons[d].zIndex = 3002, this.buttons[d].oriPos.y += 20, ig.game.sortEntitiesDeferred();
                    this.calculateStar();
                    this.tweening = !0;
                    this.tweener("rect", {
                        alp: this.rect.targAlp
                    }, 0.3, "boardfadeIn");
                    break;
                case "boardfadeIn":
                    this.tweener("this", {
                        offY: 50
                    }, 0.4, "boardfadeIn2");
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.3, "boardSize4");
                    break;
                case "boardSize2":
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.1, "boardSize3");
                    break;
                case "boardSize3":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.05
                    }, 0.1, "boardSize4");
                    break;
                case "boardSize4":
                    this.tweener("board", {
                        scX: 1,
                        scY: 1
                    }, 0.3);
                    break;
                case "boardfadeIn2":
                    !1 == this.win ? this.sounder("over") : this.sounder("win");
                    this.tweener("this", {
                        offY: 0
                    }, 0.3, "donefadeIn");
                    for (d = 0; d < this.buttons.length; d++) this.buttons[d].tweenF("fadeIn");
                    for (d = 0; 3 > d; d++) this.tweener("star" + d, {
                        sc: 1.2
                    }, 0.2, "star2", this["star" + d].delay);
                    break;
                case "star2":
                    this.tweener(c, {
                        sc: 1
                    }, 0.11);
                    break;
                case "donefadeIn":
                    this.tweening = !1;
                    break;
                case "pauseFadeOut":
                    this.tweening = !0;
                    for (d = 0; d < this.buttons.length; d++) this.buttons[d].tweenF("fadeOut");
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeOut2");
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.3, "boardSizeOut");
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.1
                    }, 0.3, "boardSizeOut2");
                    this.tweener("rect", {
                        alp: 0
                    }, 0.3);
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0,
                        scY: 0
                    }, 0.3);
                    break;
                case "boardfadeOut2":
                    this.tweener("this", {
                            offY: -500
                        },
                        0.3, "donefadeOut");
                    break;
                case "donefadeOut":
                    this.tweening = !1, this.runTask()
            }
        },
        calculateStar: function() {
            !1 != this.win && (this.main.score >= this.main.starScore[0] && (this.star0.im = this.starIm), this.main.score >= this.main.starScore[1] && (this.star1.im = this.starIm), this.main.score >= this.main.starScore[2] && (this.star2.im = this.starIm))
        },
        update: function() {
            ig.global.wm || this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.buttons = [ig.game.getEntitiesByType(EntityMenuBut)[0],
                ig.game.getEntitiesByType(EntityReplayBut)[0], ig.game.getEntitiesByType(EntityProceedBut)[0]
            ]
        },
        runTask: function() {
            switch (this.task) {
                case "unpause":
                    this.main.gamePaused = !1;
                    break;
                case "replay":
                    ig.game.director.jumpTo(LevelGame);
                    break;
                case "next":
                    !0 == this.win && 23 > ig.game.lvl && ig.game.lvl++;
                    ig.game.director.jumpTo(LevelGame);
                    break;
                case "home":
                    this.main.gamePaused = !1, ig.game.showLvlMenu = !0, ig.game.director.jumpTo(LevelHome)
            }
        },
        renderText: function() {
            !0 != ig.game.played && (this.textDraw({
                ctx: ig.game.hidCtx,
                px: 28,
                tx: _STRINGS.Game.You,
                x: 630,
                y: 20,
                stroke: !0,
                strokeColour: "#6a4013",
                strokeLine: 6,
                col: this.title.grad,
                scX: 0.85,
                scY: 0.85
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 28,
                tx: _STRINGS.Game.Win,
                x: 730,
                y: 20,
                stroke: !0,
                strokeColour: "#6a4013",
                strokeLine: 6,
                col: this.title.grad,
                scX: 0.85,
                scY: 0.85
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 28,
                tx: _STRINGS.Game.Lose,
                x: 830,
                y: 20,
                stroke: !0,
                strokeColour: "#6a4013",
                strokeLine: 6,
                col: this.title.grad,
                scX: 0.85,
                scY: 0.85
            }))
        },
        draw: function() {
            this.parent();
            if (!ig.global.wm && !1 != this.main.gameOver) {
                this.ctx.fillStyle =
                    this.rect.colour;
                this.ctx.globalAlpha = this.rect.alp;
                this.ctx.fillRect(0, 0, ig.system.width, ig.system.height);
                this.drawer({
                    x: this.board.x,
                    y: this.board.y + this.offY,
                    cent: !0,
                    scX: this.board.scX,
                    scY: this.board.scY,
                    pic: this.boardIm
                });
                this.drawer({
                    x: this.board.x + this.header.x,
                    y: this.board.y + this.header.y + this.offY,
                    cent: !0,
                    scX: this.board.scX * this.header.scX,
                    scY: this.board.scY * this.header.scY,
                    pic: this.headerIm
                });
                this.ctxDrawer({
                    pic: ig.game.hidEle,
                    x: this.board.x + this.header.x - this.textGap,
                    y: this.board.y + this.header.y +
                        this.title.y + this.offY,
                    sx: 580,
                    sy: 0,
                    sw: 100,
                    sh: 40,
                    cent: !0
                });
                this.ctxDrawer({
                    pic: ig.game.hidEle,
                    x: this.board.x + this.header.x + this.textGap,
                    y: this.board.y + this.header.y + this.title.y + this.offY,
                    sx: !0 == this.win ? 680 : 780,
                    sy: 0,
                    sw: 100,
                    sh: 40,
                    cent: !0
                });
                for (var b = 0; 2 > b; b++) this.drawer({
                    x: this.board.x + this["slot" + b].x,
                    y: this.board.y + this["slot" + b].y + this.offY,
                    cent: !0,
                    scX: this.board.scX,
                    scY: this.board.scY,
                    pic: this.slotIm
                }), this.textDraw({
                    px: 14,
                    tx: this["slot" + b].tx,
                    x: this.board.x + this.slot0.textX,
                    y: this.board.y + this["slot" +
                        b].y + this.offY - 1,
                    col: this.slot0.col,
                    scX: 1,
                    scY: 1,
                    align: this.slot0.align
                }), this.textDraw({
                    px: 14,
                    tx: Math.floor(this.tx[b]),
                    x: this.board.x + this["slot" + b].x,
                    y: this.board.y + this["slot" + b].y + this.offY - 1,
                    col: "white",
                    scX: 1,
                    scY: 1
                });
                for (b = 0; 3 > b; b++) this.drawer({
                    x: this.board.x + this["star" + b].x,
                    y: this.board.y + this["star" + b].y + this.offY + 10,
                    cent: !0,
                    scX: this.board.scX * this["star" + b].sc * this["star" + b].oriSc,
                    scY: this.board.scY * this["star" + b].sc * this["star" + b].oriSc,
                    pic: this["star" + b].im,
                    rot: this["star" + b].rot
                })
            }
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-count").requires("game.entities.plain").defines(function() {
    EntityPlainCount = EntityPlain.extend({
        type: ig.Entity.TYPE.A,
        checkAgainst: ig.Entity.TYPE.B,
        zIndex: 2003,
        gravityFactor: 1,
        vel: {
            x: 50,
            y: -200
        },
        sheetX: 8,
        sheetY: 4,
        im: new ig.Image("media/graphics/sprites/bubbles.png"),
        drawBurst: !1,
        burstFrame: 0,
        burstEndFrame: 48,
        burst: {
            frame: 0,
            frameTime: 0.012
        },
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.burst.frameTimer = new ig.Timer, this.popTime = 0.6 + 0.3 * Math.random(), this.popTimer =
                new ig.Timer, this.main = d.main, this.aniStuff(), this.vel.x = 350 * Math.random(), this.vel.y = -(700 + 300 * Math.random()), this.accel.x = -500 + 1E3 * Math.random())
        },
        update: function() {
            this.parent();
            this.popTimer.delta() > this.popTime && !1 == this.drawBurst && (this.main.soundLooper("bubble"), this.drawBurst = !0, this.vel.x = 0, this.vel.y = 0, this.accel.x = 0, this.gravityFactor = this.accel.y = 0)
        },
        drawBurstStuff: function() {
            this.burst.frame < this.burstEndFrame ? (void 0 != ig.game.burstRender.frames[this.burst.frame] && this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.pos.x + this.size.x / 2,
                y: this.pos.y + this.size.y / 2,
                sx: ig.game.burstRender.frames[Math.floor(this.burst.frame)].sx,
                sy: ig.game.burstRender.frames[Math.floor(this.burst.frame)].sy,
                sw: 60,
                sh: 60,
                cent: !0
            }), this.burst.frameTimer.delta() > this.burst.frameTime && (this.burst.frameTimer.reset(), this.burst.frame++)) : this.kill()
        },
        draw: function() {
            !0 == this.drawBurst ? this.drawBurstStuff() : this.parent()
        },
        bubbleTypeRegen: function() {
            -1 < this.which.indexOf("baby") ? (this.refType = "baby", this.refColour = this.which.replace("baby",
                "")) : this.main.bubbleColours.indexOf(this.which) ? (this.refType = "normal", this.refColour = this.which) : (this.refType = this.which, this.refColour = "none");
            this.currentAnim = this.anims[this.which]
        },
        aniStuff: function() {
            this.animSheet = new ig.AnimationSheet(this.im.path, this.im.width / this.sheetX, this.im.height / this.sheetY);
            this.size.x = (this.animSheet.width - 4) * this.sc.x;
            this.size.y = (this.animSheet.height - 8) * this.sc.y;
            this.addAnim("red", 0.1, [0], !0);
            this.addAnim("orange", 0.1, [1], !0);
            this.addAnim("yellow", 0.1, [2], !0);
            this.addAnim("green", 0.1, [3], !0);
            this.addAnim("cyan", 0.1, [4], !0);
            this.addAnim("blue", 0.1, [5], !0);
            this.addAnim("purple", 0.1, [6], !0);
            this.addAnim("pink", 0.1, [7], !0);
            this.addAnim("super", 0.05, [19], !1);
            this.addAnim("babyred", 0.1, [8], !0);
            this.addAnim("babyorange", 0.1, [9], !0);
            this.addAnim("babyyellow", 0.1, [10], !0);
            this.addAnim("babygreen", 0.1, [11], !0);
            this.addAnim("babycyan", 0.1, [12], !0);
            this.addAnim("babyblue", 0.1, [13], !0);
            this.addAnim("babypurple", 0.1, [14], !0);
            this.addAnim("babypink", 0.1, [15], !0);
            this.addAnim("ice", 0.1, [16], !0);
            this.addAnim("right", 0.1, [17], !0);
            this.addAnim("up", 0.1, [18], !0);
            this.addAnim("rainbow", 0.1, [19], !0);
            this.addAnim("thunder", 0.1, [20], !0);
            this.addAnim("star", 0.1, [21], !0);
            this.addAnim("time", 0.1, [22], !0);
            this.addAnim("bomb", 0.1, [23], !0);
            this.addAnim("steel", 0.1, [24], !0);
            this.addAnim("evil", 0.1, [25], !0);
            this.addAnim("wood", 0.1, [26], !0);
            this.addAnim("guide", 0.1, [27], !0);
            this.addAnim("change", 0.1, [28], !0);
            this.addAnim("pick", 0.1, [29], !0);
            this.addAnim("search", 0.1, [30], !0);
            this.addAnim("armo", 0.1, [31], !0);
            this.currentAnim = this.anims[this.which]
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-game").requires("game.entities.plain", "game.entities.plain-tile", "game.entities.plain-gui", "game.entities.plain-tut", "game.entities.plain-stage", "game.entities.plain-shooter", "game.entities.plain-menu-but", "game.entities.plain-but", "game.entities.plain-pause", "game.entities.plain-level-box", "game.entities.plain-ready", "game.entities.plain-over", "game.entities.plain-count").defines(function() {
    EntityPlainGame = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 1,
        h: 600,
        w: 800,
        score: 0,
        star: 0,
        countSound: !1,
        choice: [0, 1, 2, 3, "plus0", "plus1", "plus2", "plus3", "minus0", "minus1", "minus2", "minus3", "evil", "wood", "ice", "star", "thunder"],
        tutOn: !1,
        sLoop: {
            bubble: {
                duration: 0.05
            },
            hehe: {
                duration: 0.5
            },
            count: {
                duration: 0.05
            }
        },
        scoreSc: 1,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        gameOver: !1,
        gamePaused: !1,
        gameStarted: !1,
        doneOver: !1,
        totalBaby: 0,
        babyRescued: 0,
        burstScore: 10,
        allowShoot: !0,
        armoCombo: 0,
        popAll: {
            done: !1,
            total: 0,
            killed: -1,
            combo: 0
        },
        dropAll: {
            done: !1,
            total: 0,
            killed: -1,
            combo: 0
        },
        showCombo: !0,
        doneCombo: !0,
        combo: 0,
        countDown: 0,
        noArmo: !1,
        bgIm: new ig.Image("media/graphics/sprites/bg.png"),
        rowOffset: 1,
        tiles: [],
        bubbleTypes: "red orange yellow green cyan blue purple pink babyred babyorange babyyellow babygreen babycyan babyblue babypurple babypink left right up rainbow thunder star time bomb steel steelglow wood guide change pick search armo super".split(" "),
        bubbleColours: "red orange yellow green cyan blue purple pink super".split(" "),
        colourSet: [],
        floorIm: new ig.Image("media/graphics/sprites/floor.png"),
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), ig.game.redraw = !0, ig.game.getMusic(), ig.game.getSound(), this.hidCtx = ig.game.hidCtx, ig.game.gravity = 1E3, this.colourSet = _LVL["lvl" + ig.game.lvl].colourSet[Math.floor(Math.random() * _LVL["lvl" + ig.game.lvl].colourSet.length)], this.levelStat = _LVL["lvl" + ig.game.lvl], this.armo = this.levelStat.armo, this.armoExtra = this.levelStat.armoExtra, this.starScore = this.levelStat.starScore, this.map = this.levelStat.map, this.spawner())
        },
        spawner: function() {
            ig.game.spawnEntity(EntityPointer,
                0, 0, {
                    main: this
                });
            ig.game.spawnEntity(EntityPlainStage, 0, 0, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainTut, 259, 387, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainPause, 0, 0, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainOver, 0, 0, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainReady, 0, 0, {
                main: this
            });
            ig.game.spawnEntity(EntityToggleBubbleBut, 97, 556, {
                main: this
            });
            ig.game.spawnEntity(EntityPauseBut, ig.system.width - 55, 10, {
                main: this
            });
            for (var b = 0; b < this.map.length; b++)
                for (var c = 0; c < this.map[b].length; c++) "empty" == this.map[b][c] ||
                    void 0 == this.map[b][c] ? this.map[b][c] = void 0 : ig.game.spawnEntity(EntityPlainTile, 0, 0, {
                        main: this,
                        j: b,
                        i: c
                    });
            ig.game.spawnEntity(EntityPlainShooter, 175, 490, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainBubble, 175, 490, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainGui, 0, 0, {
                main: this
            })
        },
        dropBubbles: function(b) {
            b.tweening = !0;
            b.hanging = !1;
            b.vel.y = -(50 * Math.random() + 80);
            b.accel.y = 600;
            b.accel.x = -150 + 300 * Math.random();
            b.zIndex = 101;
            this.tiles[b.tile.y][b.tile.x] = void 0
        },
        genBubbles: function() {},
        bubbleHeight: function() {},
        winDropBubbles: function() {
            this.dropAll.killed = 0;
            this.dropAll.total = 0;
            this.dropAll.done = !1;
            for (var b = ig.game.getEntitiesByType(EntityPlainTile), c = 0; c < b.length; c++) {
                var d = b[c];
                this.scoreVault += 10;
                this.dropAll.total++;
                this.dropBubbles(d)
            }
            this.dropAll.combo = Math.floor(this.dropAll.total / 5) * (55 + 2 * Math.floor(this.dropAll.total / 5));
            this.tweener("this", {
                score: this.score + this.dropAll.combo + this.scoreVault
            }, 0.3, "drawScore");
            0 < this.dropAll.combo && this.gui.tweenF("endDropCombo")
        },
        winGame: function(b) {
            if (!1 != this.over.win) switch (b) {
                case "stopGame":
                    if (!0 ==
                        this.gameOver) break;
                    this.gameOver = !0;
                    this.countDown = this.bubble.armoLeft;
                    this.armoCombo = 50 * this.countDown;
                    this.winDropBubbles();
                    break;
                case "overScreen":
                    this.over = ig.game.getEntitiesByType(EntityPlainOver)[0], this.over.textGap = this.over.winGap, this.over.tweenF("pauseFadeIn"), this.recordGame(), this.over.tx[0] = this.score, this.over.calculateStar(), this.over.tx[1] = ig.game.levelStat[ig.game.lvl].highScore
            }
        },
        loseGame: function() {
            if (!0 != this.gameOver) {
                this.gameOver = !0;
                this.countDown = this.bubble.armoLeft;
                this.over =
                    ig.game.getEntitiesByType(EntityPlainOver)[0];
                this.over.win = !1;
                this.over.textGap = this.over.loseGap;
                this.over.tweenF("pauseFadeIn");
                this.over.tx[0] = this.score;
                this.over.tx[1] = ig.game.levelStat[ig.game.lvl].highScore;
                this.over.buttons.pop();
                for (var b = 0; b < this.over.buttons.length; b++) this.over.buttons[b].oriPos.x += 43
            }
        },
        startGame: function() {
            this.gameStarted = this.doneCombo = !0
        },
        resetCombo: function() {
            this.popAll.done = !1;
            this.doneCombo = this.showCombo = this.dropAll.done = !1;
            this.popAll.total = 0;
            this.dropAll.total =
                0;
            this.popAll.killed = 0;
            this.dropAll.killed = 0;
            this.popAll.combo = 0;
            this.dropAll.combo = 0
        },
        showComboText: function() {
            3 < this.popAll.total && (this.popAll.combo = Math.floor(this.popAll.total / 5) * (50 + 2 * Math.floor(this.popAll.total / 5)));
            this.dropAll.combo = Math.floor(this.dropAll.total / 5) * (55 + 2 * Math.floor(this.dropAll.total / 5));
            3 < this.popAll.total ? this.gui.tweenF("popCombo") : 0 < this.dropAll.combo ? this.gui.tweenF("dropCombo") : this.doneCombo = !0;
            this.tweener("this", {
                score: this.score + this.popAll.combo + this.dropAll.combo +
                    this.scoreVault
            }, 0.3, "drawScore")
        },
        recordGame: function() {
            ig.game.levelStat[ig.game.lvl].highScore < this.score && (ig.game.levelStat[ig.game.lvl].highScore = this.score);
            this.score >= this.starScore[0] && ig.game.levelStat[ig.game.lvl].star < this.star + 1 && (ig.game.levelStat[ig.game.lvl].star = this.star + 1);
            void 0 != ig.game.levelStat[ig.game.lvl + 1] && (ig.game.levelStat[ig.game.lvl + 1].unlocked = !0);
            ig.game.setScore()
        },
        tweenF: function(b) {
            switch (b) {
                case "drawScore":
                    this.gui.renderScore();
                    break;
                case "countDown":
                    0 < this.countDown ?
                        (this.sounder("count"), this.countDown--, this.score += 50, ig.ua.mobile || (this.gui.renderScore(), this.gui.renderCount()), this.scoreSc = 1.2, this.tweener("this", {
                            scoreSc: 1,
                            score: this.score + 50
                        }, 0.08, "countDown")) : (this.gui.renderScore(), this.gui.tweenF("armoCombo2"), this.winGame("overScreen"));
                    0 < this.countDown && (ig.game.spawnEntity(EntityPlainCount, 97, 530, {
                        main: this,
                        which: this.bubble.armoVault[this.bubble.armoVault.length - this.countDown]
                    }), this.bubble.tweenF("gameOver"));
                    break;
                case "winGame":
                    this.countSound = !1, this.gui.renderScore(), this.gui.tweenF("armoCombo2"), this.winGame("overScreen")
            }
        },
        update: function() {
            !ig.global.wm && !0 != this.gamePaused && (this.parent(), !0 == this.countSound && this.soundLooper("count"), ig.game.played = !0, !1 == this.gameOver ? !1 != this.gameStarted && (!0 == this.popAll.done && !0 == this.dropAll.done ? (this.doneCombo = !0, !1 == this.showCombo ? (this.showCombo = !0, this.stage.tweenF("triggerPos"), this.gui.tweenF("armoPlusUpdate")) : !0 == this.doneCombo && (this.babyRescued == this.totalBaby ? this.winGame("stopGame") :
                0 >= this.bubble.armoLeft && 0 >= this.bubble.plusVault - this.bubble.minusVault && this.babyRescued < this.totalBaby && this.loseGame())) : (!1 == this.popAll.done && this.popAll.total == this.popAll.killed && (this.doneCombo = !0, this.popAll.done = !0), !1 == this.dropAll.done && this.dropAll.total == this.dropAll.killed && (this.dropAll.done = !0))) : this.dropAll.total == this.dropAll.killed && !1 == this.doneOver && (this.doneOver = !0, this.gui.renderScore(), this.gui.tweenF("endDropCombo2"), !0 == this.over.win && this.tweenF("countDown"), this.gui.tweenF("armoCombo")))
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.shooter = ig.game.getEntitiesByType(EntityPlainShooter)[0];
            this.bubble = ig.game.getEntitiesByType(EntityPlainBubble)[0];
            this.gui = ig.game.getEntitiesByType(EntityPlainGui)[0];
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
            this.over = ig.game.getEntitiesByType(EntityPlainOver)[0]
        },
        draw: function() {
            this.parent();
            ig.global.wm || (!0 == ig.game.redraw && this.drawer({
                pic: this.bgIm,
                x: 0,
                y: 0,
                ctx: ig.game.bgCtx
            }), this.drawer({
                pic: this.floorIm,
                x: ig.system.width / 2,
                y: this.shooter.shadow.y - 38,
                cent: !0
            }))
        }
    })
});
ig.baked = !0;
ig.module("game.levels.game").requires("impact.image", "game.entities.plain-game").defines(function() {
    LevelGame = {
        entities: [{
            type: "EntityPlainGame",
            x: 0,
            y: 0
        }],
        layer: []
    }
});
ig.baked = !0;
ig.module("game.entities.plain-home-but").requires("game.entities.plain").defines(function() {
    EntityPlainHomeBut = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2040,
        sc: 0,
        mouseSc: 0.95,
        runTask: !1,
        tweening: !1,
        oriPos: {
            x: 0,
            y: 0
        },
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.name = d.name, this.menu = d.menu, void 0 != this.menu && this.menu.buttons.push(this), this.size.x = this.butIm.width, this.size.y = this.butIm.height, this.oriPos.x = b, this.oriPos.y = c, this.hide(), this.oriStat && this.oriStat())
        },
        clicked: function() {
            this.sc = 0.9;
            this.buttonTask();
            this.sounder("click")
        },
        released: function() {
            !0 != this.tweening && (this.sounder("click"), this.sc = 1)
        },
        hide: function() {
            this.pos.x = -200;
            this.pos.y = -200
        },
        show: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y + this.menu.offY
        },
        tweenF: function(b) {
            switch (b) {
                case "floatUp":
                    this.tweener("pos", {
                        y: this.oriPos.y - 5
                    }, this.floatTime, "floatDown");
                    break;
                case "floatDown":
                    this.tweener("pos", {
                        y: this.oriPos.y + 8
                    }, this.floatTime, "floatUp")
            }
        },
        update: function() {
            ig.global.wm ||
                (this.parent(), !0 != this.tweening && (this.mouseSc = this.pointer.hoveringItem == this ? 1 : 0.95))
        },
        drawInit: function() {},
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0]
        },
        draw: function() {
            this.parent();
            ig.global.wm || this.drawer({
                pic: this.butIm,
                x: this.pos.x + this.butIm.width / 2,
                y: this.pos.y + this.butIm.height / 2,
                scX: this.oriSc * this.sc * this.mouseSc,
                scY: this.oriSc * this.sc * this.mouseSc,
                cent: !0
            })
        }
    });
    EntityPlayBut = EntityPlainHomeBut.extend({
        oriSc: 0.98,
        zIndex: 1E3,
        floatTime: 0.95,
        butIm: new ig.Image("media/graphics/sprites/start.png"),
        oriStat: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y;
            this.sc = 1;
            this.tweenF("floatUp")
        },
        clicked: function() {
            this.sc = 0.9;
            this.sounder("click")
        },
        released: function() {
            !0 != this.tweening && (this.sc = 1, this.buttonTask())
        },
        buttonTask: function() {
            !0 != this.main.gamePaused && !0 != this.tweening && (this.main.gamePaused = !0, this.level = ig.game.getEntitiesByType(EntityPlainLevel)[0], this.level.tweenF("rectFadeIn"), ig.game.hideOverlay(["more-games"]))
        }
    });
    EntitySettingBut = EntityPlainHomeBut.extend({
        oriSc: 0.98,
        butIm: new ig.Image("media/graphics/sprites/gear.png"),
        zIndex: 1E3,
        floatTime: 0.7,
        oriStat: function() {
            this.pos.x = this.oriPos.x;
            this.pos.y = this.oriPos.y;
            this.sc = 1;
            this.tweenF("floatDown")
        },
        clicked: function() {
            this.sc = 0.9;
            this.sounder("click")
        },
        released: function() {
            !0 != this.tweening && (this.sc = 1, this.buttonTask())
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.menu = ig.game.getEntitiesByType(EntityPlainSetting)[0]
        },
        buttonTask: function() {
            !0 != this.main.gamePaused && !0 != this.tweening &&
                (this.main.gamePaused = !0, this.menu.tweenF("pauseFadeIn"), ig.game.hideOverlay(["more-games"]))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-setting").requires("game.entities.plain", "game.entities.plain-menu-but").defines(function() {
    EntityPlainSetting = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2030,
        size: {
            x: 50,
            y: 50
        },
        task: "unpause",
        pauseRect: {
            alp: 0,
            targAlp: 0.5,
            colour: "black"
        },
        boardIm: new ig.Image("media/graphics/sprites/board.png"),
        musicIm: new ig.Image("media/graphics/sprites/music.png"),
        soundIm: new ig.Image("media/graphics/sprites/sound.png"),
        settingIm: new ig.Image("media/graphics/sprites/setting.png"),
        sliderIm: new ig.Image("media/graphics/sprites/slider.png"),
        headerIm: new ig.Image("media/graphics/sprites/header.png"),
        buttons: [],
        offY: -600,
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.main = d.main, ig.game.spawnEntity(EntityCloseBut, 363, 186, {
                main: this.main,
                menu: this
            }), ig.game.spawnEntity(EntityMusicKnot, 205, 250, {
                main: this.main,
                menu: this
            }), ig.game.spawnEntity(EntitySoundKnot, 205, 311, {
                main: this.main,
                menu: this
            }), ig.game.spawnEntity(EntityOkayBut, ig.system.width / 2 - 25, 370, {
                main: this.main,
                menu: this
            }), this.board = {
                x: ig.system.width / 2,
                y: 300,
                offX: 0,
                offY: 0,
                scX: 0,
                scY: 0
            }, this.header = {
                x: 0,
                y: -100,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1
            }, this.title = {
                x: 0,
                y: -5,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1,
                grad1: -20,
                grad2: 3
            }, this.title.grad = this.ctx.createLinearGradient(0, this.title.grad1, 0, this.title.grad2), this.title.grad.addColorStop(0, "#e6e438"), this.title.grad.addColorStop(0.3, "#c2d73a"), this.title.grad.addColorStop(1, "#6d8225"), this.music = {
                x: -90,
                y: -33,
                lineX: 50,
                lineY: -30,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1
            }, this.sound = {
                x: -90,
                y: 28,
                lineX: 50,
                lineY: 30,
                offX: 0,
                offY: 0,
                scX: 1,
                scY: 1
            }, this.renderText())
        },
        tweenF: function(b) {
            switch (b) {
                case "pauseFadeIn":
                    this.tweening = !0;
                    this.tweener("pauseRect", {
                        alp: this.pauseRect.targAlp
                    }, 0.3, "boardfadeIn");
                    break;
                case "boardfadeIn":
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeIn2");
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.1, "boardSize4");
                    break;
                case "boardSize2":
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.1, "boardSize3");
                    break;
                case "boardSize3":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.05
                    }, 0.1, "boardSize4");
                    break;
                case "boardSize4":
                    this.tweener("board", {
                        scX: 1,
                        scY: 1
                    }, 0.1);
                    break;
                case "boardfadeIn2":
                    this.tweener("this", {
                        offY: 0
                    }, 0.3, "donefadeIn");
                    for (b = 0; b < this.buttons.length; b++) this.buttons[b].tweenF("fadeIn");
                    break;
                case "donefadeIn":
                    this.tweening = !1;
                    break;
                case "pauseFadeOut":
                    this.tweening = !0;
                    for (b = 0; b < this.buttons.length; b++) this.buttons[b].tweenF("fadeOut");
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeOut2");
                    this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.3, "boardSizeOut");
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.1
                    }, 0.3, "boardSizeOut2");
                    this.tweener("pauseRect", {
                        alp: 0
                    }, 0.3);
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0,
                        scY: 0
                    }, 0.3);
                    break;
                case "boardfadeOut2":
                    this.tweener("this", {
                        offY: -500
                    }, 0.3, "donefadeOut");
                    break;
                case "donefadeOut":
                    this.tweening = !1, this.runTask()
            }
        },
        runTask: function() {
            switch (this.task) {
                case "unpause":
                    this.main.gamePaused = !1;
                    ig.game.showOverlay(["more-games"]);
                    break;
                case "replay":
                    ig.game.director.jumpTo(LevelGame);
                    break;
                case "home":
                    this.main.gamePaused = !1, ig.game.director.jumpTo(LevelHome)
            }
        },
        update: function() {
            ig.global.wm ||
                this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            this.buttons = [ig.game.getEntitiesByType(EntitySoundKnot)[0], ig.game.getEntitiesByType(EntityMusicKnot)[0], ig.game.getEntitiesByType(EntityOkayBut)[0], ig.game.getEntitiesByType(EntityCloseBut)[0]];
            for (var b = 0; b < this.buttons.length; b++) this.buttons[b].menu = this
        },
        renderText: function() {
            !0 != ig.game.played && this.textDraw({
                ctx: ig.game.hidCtx,
                px: 28,
                tx: _STRINGS.Game.Settings,
                x: 560,
                y: 70,
                stroke: !0,
                strokeColour: "#56612f",
                strokeLine: 6,
                col: this.title.grad
            })
        },
        draw: function() {
            this.parent();
            ig.global.wm || (!0 == this.main.gamePaused && (this.ctx.fillStyle = this.pauseRect.colour, this.ctx.globalAlpha = this.pauseRect.alp, this.ctx.fillRect(0, 0, ig.system.width, ig.system.height)), this.drawer({
                x: this.board.x,
                y: this.board.y + this.offY,
                cent: !0,
                scX: this.board.scX,
                scY: this.board.scY,
                pic: this.settingIm
            }), this.drawer({
                x: this.board.x + this.header.x,
                y: this.board.y + this.header.y + this.offY,
                cent: !0,
                scX: this.board.scX * this.header.scX,
                scY: this.board.scY *
                    this.header.scY,
                pic: this.headerIm
            }), this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.board.x + this.header.x,
                y: this.board.y + this.header.y + this.title.y + this.offY,
                sx: 480,
                sy: 50,
                sw: 160,
                sh: 40,
                cent: !0
            }), this.drawer({
                x: this.board.x + this.music.lineX,
                y: this.board.y + this.music.lineY + this.offY,
                cent: !0,
                scX: this.board.scX * this.music.scX,
                scY: this.board.scY * this.music.scY,
                pic: this.sliderIm
            }), this.textDraw({
                px: 20,
                tx: _STRINGS.Game.Music,
                x: this.board.x + this.music.x,
                y: this.board.y + this.music.y + this.offY,
                col: "#4d3200"
            }), this.drawer({
                x: this.board.x +
                    this.sound.lineX,
                y: this.board.y + this.sound.lineY + this.offY,
                cent: !0,
                scX: this.board.scX * this.sound.scX,
                scY: this.board.scY * this.sound.scY,
                pic: this.sliderIm
            }), this.textDraw({
                px: 20,
                tx: _STRINGS.Game.Sound,
                x: this.board.x + this.sound.x,
                y: this.board.y + this.sound.y + this.offY,
                col: "#4d3200"
            }))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-level").requires("game.entities.plain", "game.entities.plain-menu-but", "game.entities.plain-level-box").defines(function() {
    EntityPlainLevel = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 2030,
        size: {
            x: 50,
            y: 50
        },
        page: 1,
        drawing: !1,
        task: "unpause",
        fadeRect: {
            alp: 0,
            targAlp: 0.5,
            colour: "black"
        },
        boardIm: new ig.Image("media/graphics/sprites/board.png"),
        headerIm: new ig.Image("media/graphics/sprites/header.png"),
        settingIm: new ig.Image("media/graphics/sprites/setting.png"),
        buttons: [],
        offY: -600,
        init: function(b, c, d) {
            if (!ig.global.wm) {
                this.parent(b, c, d);
                this.main = d.main;
                ig.game.spawnEntity(EntityLevelCloseBut, 363, 186, {
                    main: this.main,
                    menu: this
                });
                ig.game.spawnEntity(EntityLevelNextBut, 379, 272, {
                    main: this.main,
                    menu: this
                });
                ig.game.spawnEntity(EntityLevelPrevBut, 70, 272, {
                    main: this.main,
                    menu: this
                });
                this.board = {
                    x: ig.system.width / 2,
                    y: 300,
                    offX: 0,
                    offY: 0,
                    scX: 0,
                    scY: 0
                };
                this.header = {
                    x: 0,
                    y: -115,
                    offX: 0,
                    offY: 0,
                    scX: 1,
                    scY: 1
                };
                this.title = {
                    x: 0,
                    y: -5,
                    offX: 0,
                    offY: 0,
                    scX: 1,
                    scY: 1,
                    grad1: -20,
                    grad2: 3
                };
                this.title.grad = this.ctx.createLinearGradient(0, this.title.grad1, 0, this.title.grad2);
                this.title.grad.addColorStop(0, "#e6e438");
                this.title.grad.addColorStop(0.3, "#c2d73a");
                this.title.grad.addColorStop(1, "#6d8225");
                for (c = b = 0; 3 > c; c++)
                    for (d = 0; 4 > d; d++) ig.game.spawnEntity(EntityPlainLevelBox, ig.system.width / 2 - 120 + 60 * d, 0.52 * ig.system.height - 130 + 65 * c, {
                        main: this,
                        level: b
                    }), b++;
                this.renderText();
                ig.ua.mobile && (this.board.scX = 1, this.board.scY = 1)
            }
        },
        tweenF: function(b) {
            switch (b) {
                case "rectFadeIn":
                    this.tweening = !0;
                    this.tweener("fadeRect", {
                        alp: this.fadeRect.targAlp
                    }, 0.3, "boardfadeIn");
                    break;
                case "boardfadeIn":
                    this.drawing = !0;
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeIn2");
                    ig.ua.mobile || this.tweener("board", {
                        scX: 0.9,
                        scY: 1.1
                    }, 0.3, "boardSize2");
                    break;
                case "boardfadeIn2":
                    this.tweener("this", {
                        offY: 0
                    }, 0.3, "donefadeIn");
                    for (b = 0; b < this.buttons.length; b++) this.buttons[b].tweenF("fadeIn");
                    break;
                case "donefadeIn":
                    this.tweening = !1;
                    break;
                case "boardSize2":
                    this.tweener("board", {
                        scX: 1,
                        scY: 1
                    }, 0.3);
                    break;
                case "pauseFadeOut":
                    this.tweening = !0;
                    for (b = 0; b < this.buttons.length; b++) this.buttons[b].tweenF("fadeOut");
                    this.tweener("this", {
                        offY: 50
                    }, 0.3, "boardfadeOut2");
                    ig.ua.mobile || this.tweener("board", {
                        scX: 1.1,
                        scY: 0.9
                    }, 0.3, "boardSizeOut");
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0.95,
                        scY: 1.1
                    }, 0.3, "boardSizeOut2");
                    break;
                case "boardSizeOut":
                    this.tweener("board", {
                        scX: 0,
                        scY: 0
                    }, 0.3);
                    break;
                case "boardfadeOut2":
                    this.tweener("this", {
                        offY: -500
                    }, 0.3, "donefadeOut");
                    this.tweener("fadeRect", {
                        alp: 0
                    }, 0.3);
                    break;
                case "donefadeOut":
                    this.tweening = !1, this.runTask()
            }
        },
        runTask: function() {
            switch (this.task) {
                case "unpause":
                    this.main.gamePaused = !1;
                    ig.game.showOverlay(["more-games"]);
                    break;
                case "replay":
                    ig.game.director.jumpTo(LevelGame);
                    break;
                case "home":
                    this.main.gamePaused = !1, ig.game.director.jumpTo(LevelHome)
            }
        },
        update: function() {
            ig.global.wm || this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0]
        },
        renderText: function() {
            !0 != ig.game.played && this.textDraw({
                ctx: ig.game.hidCtx,
                px: 28,
                tx: _STRINGS.Game.Levels,
                x: 740,
                y: 70,
                stroke: !0,
                strokeColour: "#56612f",
                strokeLine: 6,
                col: this.title.grad
            })
        },
        draw: function() {
            this.parent();
            !ig.global.wm && !1 != this.drawing && (this.ctx.fillStyle = this.fadeRect.colour, this.ctx.globalAlpha = this.fadeRect.alp, this.ctx.fillRect(0, 0, ig.system.width, ig.system.height), this.drawer({
                x: this.board.x,
                y: this.board.y + this.offY,
                cent: !0,
                scX: this.board.scX,
                scY: this.board.scY,
                pic: this.boardIm
            }), this.drawer({
                x: this.board.x + this.header.x,
                y: this.board.y + this.header.y + this.offY,
                cent: !0,
                scX: this.board.scX * this.header.scX,
                scY: this.board.scY * this.header.scY,
                pic: this.headerIm
            }), this.ctxDrawer({
                pic: ig.game.hidEle,
                x: this.board.x + this.header.x,
                y: this.board.y + this.header.y + this.title.y + this.offY,
                sx: 660,
                sy: 50,
                sw: 160,
                sh: 40,
                cent: !0
            }))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-renderer").requires("game.entities.plain").defines(function() {
    EntityPlainRenderer = EntityPlain.extend({
        type: ig.Entity.TYPE.B,
        zIndex: 3030,
        w: 800,
        sc: 2,
        startRendered: !1,
        burstFrame: 0,
        iceFrame: 0,
        off: {
            x: 0,
            y: 0
        },
        size: {
            x: 50,
            y: 50
        },
        sc: {
            x: 1,
            y: 1
        },
        star: {
            sc: 1,
            alp: 1,
            rot: 0
        },
        iceStar: {
            sc: 1,
            alp: 1,
            rot: 0
        },
        iceRing: {
            sc: 1,
            alp: 1,
            rot: 0
        },
        iceBubble: {
            sc: 0,
            alp: 0
        },
        ring: {
            sc: 0,
            alp: 1,
            rot: 0
        },
        blop: {
            sc: 0.1,
            alp: 1,
            rot: 0
        },
        light: {
            sc: 0,
            alp: 1,
            rot: 0,
            offX: 0,
            offY: 0
        },
        light2: {
            sc: 0,
            alp: 1,
            rot: 0,
            offX: 0,
            offY: 0
        },
        light3: {
            sc: 0,
            alp: 0.8,
            rot: 0,
            offX: 0,
            offY: 0
        },
        burstIm: new ig.Image("media/graphics/sprites/burst.png"),
        starIm1: new ig.Image("media/graphics/sprites/star1.png"),
        starIm2: new ig.Image("media/graphics/sprites/star2.png"),
        starIm3: new ig.Image("media/graphics/sprites/star3.png"),
        starIm4: new ig.Image("media/graphics/sprites/star4.png"),
        lightIm1: new ig.Image("media/graphics/sprites/light1.png"),
        lightIm2: new ig.Image("media/graphics/sprites/light2.png"),
        lightIm3: new ig.Image("media/graphics/sprites/light3.png"),
        lightIm4: new ig.Image("media/graphics/sprites/light4.png"),
        ringIm: new ig.Image("media/graphics/sprites/ring.png"),
        scoreChoice: {
            normal: {
                where: 0,
                tx: "10",
                sx: 5,
                sy: 205,
                sw: 50,
                sh: 50
            },
            plus: {
                where: 1,
                tx: "+3",
                sx: 65,
                sy: 205,
                sw: 50,
                sh: 50
            },
            minus: {
                where: 2,
                tx: "-3",
                sx: 125,
                sy: 205,
                sw: 50,
                sh: 50
            }
        },
        score: {
            sc: 0,
            alp: 0,
            gradp1: -10,
            gradp2: 0,
            offY: 0,
            tx: "normal"
        },
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), this.main = d.main, this.score.grad = this.ctx.createLinearGradient(0, this.score.gradp1, 0, this.score.gradp2), this.score.grad.addColorStop(0, "#fef1ba"), this.score.grad.addColorStop(1,
                "white"), this.scoreChoice.plus.grad = this.ctx.createLinearGradient(0, this.score.gradp1, 0, this.score.gradp2 + 10), this.scoreChoice.plus.grad.addColorStop(0, "#e6e438"), this.scoreChoice.plus.grad.addColorStop(0.3, "#c2d73a"), this.scoreChoice.plus.grad.addColorStop(1, "#6d8225"), this.scoreChoice.plus.strokeCol = "#92551c", this.scoreChoice.minus.grad = this.ctx.createLinearGradient(0, this.score.gradp1, 0, this.score.gradp2 + 10), this.scoreChoice.minus.grad.addColorStop(0, "#ff9c00"), this.scoreChoice.minus.grad.addColorStop(1,
                "#e80000"), this.scoreChoice.minus.strokeCol = "#a02f2f", this.preRenderText(), this.renderTile())
        },
        renderTile: function() {
            !0 != ig.game.played && !1 == ig.game.burstRender.done && (this.startRendered = !0, this.tweenF("preRenderBurst"), this.tweenF("preRenderIce"))
        },
        tweenF: function(b, c) {
            switch (b) {
                case "preRenderBurst":
                    this.tweener("score", {
                        sc: 1,
                        alp: 1
                    }, 0.1, "scoreFadeOutRender", 0.2);
                    this.tweener("ring", {
                        sc: 0,
                        alp: 0.5
                    }, 0.3);
                    this.tweener("star", {
                        sc: 0.6,
                        rot: 280,
                        alp: 1
                    }, 0.15, "lightFadeOut");
                    this.tweener("blop", {
                            sc: 1.2
                        }, 0.1,
                        "blop2");
                    this.tweener("light", {
                        sc: 2,
                        offX: 18,
                        offY: -15,
                        rot: 280,
                        alp: 0.3
                    }, 0.1, "light-2", 0.1);
                    this.tweener("light2", {
                        sc: 1.5,
                        offX: -16,
                        offY: 15,
                        rot: 180,
                        alp: 0.3
                    }, 0.15, "light2-2", 0.2);
                    this.tweener("light3", {
                        sc: 1,
                        offX: -14,
                        offY: -15,
                        rot: 130,
                        alp: 0.3
                    }, 0.05, "light3-2", 0.3);
                    break;
                case "scoreFadeOutRender":
                    this.tweener("score", {
                        alp: 0
                    }, 0.1, "doneRender", 0.4);
                    break;
                case "doneRender":
                    !1 == ig.game.burstRender.done && (ig.game.burstRender.done = !0, ig.game.burstEndFrame = ig.game.burstRender.frames.length);
                    break;
                case "light-2":
                    this.tweener("light", {
                        sc: 0.3,
                        offX: 30,
                        offY: 5,
                        rot: 360,
                        alp: 0.1
                    }, 0.1, "lightFadeOut");
                    break;
                case "light2-2":
                    this.tweener("light2", {
                        sc: 0.3,
                        offX: -30,
                        offY: 35,
                        rot: 230,
                        alp: 0.5
                    }, 0.1, "lightFadeOut");
                    break;
                case "light3-2":
                    this.tweener("light3", {
                        sc: 0.3,
                        offX: -30,
                        offY: 5,
                        rot: 280,
                        alp: 0.3
                    }, 0.1, "lightFadeOut");
                    break;
                case "lightFadeOut":
                    this.tweener(c, {
                        alp: 0,
                        sc: 0
                    }, 0.1);
                    break;
                case "blop2":
                    this.tweener("blop", {
                        sc: 0
                    }, 0.02);
                    break;
                case "preRenderIce":
                    this.drawIce = !0;
                    this.tweener("iceStar", {
                        rot: 360
                    }, 0.6);
                    this.tweener("iceStar", {
                        sc: 1.3
                    }, 0.3, "iceStar");
                    this.tweener("iceBubble", {
                        sc: 1.2,
                        alp: 1
                    }, 0.2, "ice3", 0.3);
                    this.tweener("iceRing", {
                        sc: 1
                    }, 0.1, "iceRing");
                    break;
                case "iceRing":
                    this.tweener("iceRing", {
                        sc: 0
                    }, 0.1, "none", 0.1);
                    break;
                case "iceStar":
                    this.tweener("iceStar", {
                        sc: 1
                    }, 0.1);
                    break;
                case "ice3":
                    this.tweener("iceBubble", {
                        sc: 1
                    }, 0.1, "convertColour");
                    break;
                case "convertColour":
                    this.drawIce = !1, ig.game.iceEndFrame = ig.game.iceRender.frames.length
            }
        },
        update: function() {
            ig.global.wm || this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0]
        },
        preRenderText: function() {
            !0 != ig.game.played && (this.textDraw({
                ctx: ig.game.hidCtx,
                px: 18,
                tx: this.scoreChoice.normal.tx,
                x: 30,
                y: 231,
                scX: 1,
                scY: 1,
                alp: 1,
                stroke: !0,
                strokeColour: "#92551c",
                strokeAlp: 0.5,
                col: "#92551c"
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 18,
                tx: this.scoreChoice.normal.tx,
                x: 30,
                y: 230,
                scX: 1,
                scY: 1,
                alp: 1,
                stroke: !0,
                strokeColour: "#92551c",
                strokeAlp: 0.5,
                col: this.score.grad
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 18,
                tx: this.scoreChoice.plus.tx,
                x: 90,
                y: 231,
                scX: 1,
                scY: 1,
                alp: 1,
                stroke: !0,
                strokeColour: this.scoreChoice.plus.strokeCol,
                strokeAlp: 0.5,
                col: "#92551c"
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 18,
                tx: this.scoreChoice.plus.tx,
                x: 90,
                y: 230,
                scX: 1,
                scY: 1,
                alp: 1,
                stroke: !0,
                strokeColour: this.scoreChoice.plus.strokeCol,
                strokeAlp: 0.5,
                col: this.scoreChoice.plus.grad
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 18,
                tx: this.scoreChoice.minus.tx,
                x: 150,
                y: 231,
                scX: 1,
                scY: 1,
                alp: 1,
                stroke: !0,
                strokeColour: this.scoreChoice.minus.strokeCol,
                strokeAlp: 0.5,
                col: this.scoreChoice.minus.grad
            }), this.textDraw({
                ctx: ig.game.hidCtx,
                px: 18,
                tx: this.scoreChoice.minus.tx,
                x: 150,
                y: 230,
                scX: 1,
                scY: 1,
                alp: 1,
                stroke: !0,
                strokeColour: this.scoreChoice.minus.strokeCol,
                strokeAlp: 0.5,
                col: this.scoreChoice.minus.grad
            }), ig.game.burstTextRendered = !0)
        },
        drawIceStuff: function() {
            var b = Math.floor(this.iceFrame / 16),
                c = this.iceFrame % 16,
                d = 30 + 60 * c,
                e = 930 + 60 * b;
            !0 == this.drawIce && (this.drawer({
                ctx: ig.game.hidCtx,
                x: d,
                y: e,
                pic: this.starIm3,
                scX: this.iceStar.sc,
                scY: this.iceStar.sc,
                cent: !0,
                alp: this.iceStar.alp,
                rot: this.iceStar.rot
            }), this.drawer({
                ctx: ig.game.hidCtx,
                x: d - 1,
                y: e,
                pic: this.ringIm,
                scX: this.sc.x *
                    this.iceRing.sc,
                scY: this.sc.y * this.iceRing.sc,
                cent: !0,
                alp: this.iceRing.alp
            }), this.iceFrame += 1);
            void 0 == ig.game.iceRender.frames[this.iceFrame] && ig.game.iceRender.frames.push({
                sx: 60 * c,
                sy: 900 + 60 * b
            })
        },
        renderBurstStuff: function(b, c) {
            var d = Math.floor(this.burstFrame / 16),
                e = this.burstFrame % 16,
                g = 30 + 60 * e,
                m = 330 + 60 * d + 200 * c;
            this.ctxDrawer({
                ctx: ig.game.hidCtx,
                pic: ig.game.hidEle,
                x: g,
                y: m,
                scX: this.score.sc,
                scY: this.score.sc,
                alp: this.score.alp,
                sx: this.scoreChoice[b].sx,
                sy: this.scoreChoice[b].sy,
                sw: this.scoreChoice[b].sw,
                sh: this.scoreChoice[b].sh,
                cent: !0
            });
            this.drawer({
                ctx: ig.game.hidCtx,
                x: g - 1 + this.off.x + this.light2.offX,
                y: m + this.off.y + this.light2.offY,
                pic: this.starIm3,
                scX: 0.3 * this.sc.x * this.light2.sc,
                scY: 0.3 * this.sc.y * this.light2.sc,
                cent: !0,
                alp: this.light2.alp,
                rot: this.light2.rot
            });
            this.drawer({
                ctx: ig.game.hidCtx,
                x: g - 1 + this.off.x + this.light3.offX,
                y: m + this.off.y + this.light3.offY,
                pic: this.starIm3,
                scX: 0.3 * this.sc.x * this.light3.sc,
                scY: 0.3 * this.sc.y * this.light3.sc,
                cent: !0,
                alp: this.light2.alp,
                rot: this.light2.rot
            });
            this.drawer({
                ctx: ig.game.hidCtx,
                x: g - 1 + this.off.x + this.light.offX,
                y: m + this.off.y + this.light.offY,
                pic: this.starIm3,
                scX: 0.3 * this.sc.x * this.light.sc,
                scY: 0.3 * this.sc.y * this.light.sc,
                cent: !0,
                alp: this.light2.alp,
                rot: this.light2.rot
            });
            this.drawer({
                ctx: ig.game.hidCtx,
                x: g - 1 + this.off.x,
                y: m + this.off.y,
                pic: this.starIm3,
                scX: this.sc.x * this.star.sc,
                scY: this.sc.y * this.star.sc,
                cent: !0,
                alp: this.star.alp,
                rot: this.star.rot
            });
            this.drawer({
                ctx: ig.game.hidCtx,
                x: g - 1 + this.off.x,
                y: m + this.off.y,
                pic: this.ringIm,
                scX: this.sc.x * this.ring.sc,
                scY: this.sc.y * this.ring.sc,
                cent: !0,
                alp: this.ring.alp
            });
            this.drawer({
                ctx: ig.game.hidCtx,
                x: g - 1 + this.off.x,
                y: m + this.off.y,
                pic: this.burstIm,
                scX: this.sc.x * this.blop.sc,
                scY: this.sc.y * this.blop.sc,
                cent: !0,
                alp: 0.8
            });
            void 0 == ig.game.burstRender.frames[this.burstFrame] && ig.game.burstRender.frames.push({
                sx: 60 * e,
                sy: 300 + 60 * d
            })
        },
        draw: function() {
            ig.global.wm || (this.parent(), this.drawIceStuff(), !0 == this.startRendered && !1 == ig.game.burstRender.done && (this.renderBurstStuff("normal", 0), this.renderBurstStuff("plus", 1), this.renderBurstStuff("minus",
                2), this.burstFrame += 1))
        }
    })
});
ig.baked = !0;
ig.module("game.entities.plain-home").requires("game.entities.plain", "game.entities.plain-menu-but", "game.entities.plain-home-but", "game.entities.plain-setting", "game.entities.plain-level", "game.entities.plain-renderer").defines(function() {
    EntityPlainHome = EntityPlain.extend({
        gravityFactor: 0,
        type: ig.Entity.TYPE.B,
        zIndex: 1,
        h: 600,
        w: 800,
        sc: 2,
        size: {
            x: 50,
            y: 50
        },
        gamePaused: !1,
        bgIm: new ig.Image("media/graphics/sprites/home-bg.png"),
        scX: 1,
        scY: 1.005,
        init: function(b, c, d) {
            ig.global.wm || (this.parent(b, c, d), ig.game.redraw = !0, this.spawner(), ig.game.getMusic(), ig.game.getSound())
        },
        spawner: function() {
            ig.game.spawnEntity(EntityPointer, 800, 800, {
                main: this
            });
            _SETTINGS.MoreGames.Enabled && ig.game.spawnEntity(EntityButtonMoreGames, 342, 288, {
                main: this
            });
            ig.game.spawnEntity(EntityPlayBut, 163, 487, {
                main: this
            });
            ig.game.spawnEntity(EntitySettingBut, 11, 157, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainSetting, 0, 0, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainLevel, 0, 0, {
                main: this
            });
            ig.game.spawnEntity(EntityPlainRenderer, 0, 0, {
                main: this
            })
        },
        tweenF: function(b) {
            switch (b) {
                case "fat":
                    this.tweener("this", {
                        scX: 1.008,
                        scY: 1
                    }, 1, "tall");
                    break;
                case "tall":
                    this.tweener("this", {
                        scX: 1,
                        scY: 1.008
                    }, 1, "fat")
            }
        },
        update: function() {
            ig.global.wm || this.parent()
        },
        ready: function() {
            this.pointer = ig.game.getEntitiesByType(EntityPointer)[0];
            !0 == ig.game.showLvlMenu && (this.gamePaused = !0, this.level = ig.game.getEntitiesByType(EntityPlainLevel)[0], this.level.tweenF("rectFadeIn"), ig.game.hideOverlay(["more-games"]));
            this.tweenF("fat")
        },
        draw: function() {
            this.parent();
            ig.global.wm ||
                (ig.ua.mobile ? this.bgIm.draw(0, 0) : this.drawer({
                    x: ig.system.width / 2,
                    y: ig.system.height / 2,
                    scX: this.scX,
                    scY: this.scY,
                    pic: this.bgIm,
                    cent: !0
                }))
        }
    })
});
ig.baked = !0;
ig.module("game.levels.home").requires("impact.image", "game.entities.plain-home").defines(function() {
    LevelHome = {
        entities: [{
            type: "EntityPlainHome",
            x: 0,
            y: 0
        }],
        layer: []
    }
});
ig.baked = !0;
ig.module("game.main").requires("impact.game", "plugins.splash-loader", "plugins.tween", "plugins.url-parameters", "plugins.jukebox", "plugins.director", "plugins.impact-storage", "plugins.branding.splash", "game.entities.branding-logo-placeholder", "game.entities.branding-logo", "game.entities.button-more-games", "game.entities.opening-shield", "game.entities.opening-kitty", "game.entities.pointer", "game.entities.pointer-selector", "game.entities.select", "game.levels.opening", "game.levels.game", "game.levels.home").defines(function() {
    var E8h = {
        'c': (function(z) {
            var o = {},
                u = function(U, N) {
                    var A = N & 0xffff;
                    var y = N - A;
                    return ((y * U | 0) + (A * U | 0)) | 0;
                },
                C = (function() {}).constructor(new z("tgvwtp\"fqewogpv0fqockp=").P(2))(),
                a = function(p, T, X) {
                    if (o[X] !== undefined) {
                        return o[X];
                    }
                    var O = 0xcc9e2d51,
                        n = 0x1b873593;
                    var K = X;
                    var D = T & ~0x3;
                    for (var G = 0; G < D; G += 4) {
                        var F = (p.charCodeAt(G) & 0xff) | ((p.charCodeAt(G + 1) & 0xff) << 8) | ((p.charCodeAt(G + 2) & 0xff) << 16) | ((p.charCodeAt(G + 3) & 0xff) << 24);
                        F = u(F, O);
                        F = ((F & 0x1ffff) << 15) | (F >>> 17);
                        F = u(F, n);
                        K ^= F;
                        K = ((K & 0x7ffff) << 13) | (K >>> 19);
                        K = (K * 5 + 0xe6546b64) | 0;
                    }
                    F = 0;
                    switch (T % 4) {
                        case 3:
                            F = (p.charCodeAt(D + 2) & 0xff) << 16;
                        case 2:
                            F |= (p.charCodeAt(D + 1) & 0xff) << 8;
                        case 1:
                            F |= (p.charCodeAt(D) & 0xff);
                            F = u(F, O);
                            F = ((F & 0x1ffff) << 15) | (F >>> 17);
                            F = u(F, n);
                            K ^= F;
                    }
                    K ^= T;
                    K ^= K >>> 16;
                    K = u(K, 0x85ebca6b);
                    K ^= K >>> 13;
                    K = u(K, 0xc2b2ae35);
                    K ^= K >>> 16;
                    o[X] = K;
                    return K;
                },
                t = function(Z, E, s) {
                    var b;
                    var d;
                    if (s > 0) {
                        b = C.substring(Z, s);
                        d = b.length;
                        return a(b, d, E);
                    } else if (Z === null || Z <= 0) {
                        b = C.substring(0, C.length);
                        d = b.length;
                        return a(b, d, E);
                    }
                    b = C.substring(C.length - Z, C.length);
                    d = b.length;
                    return a(b, d, E);
                };
            return {
                u: u,
                a: a,
                t: t
            };
        })(function(V) {
            this.V = V;
            this.P = function(l) {
                var Q = new String();
                for (var v = 0; v < V.length; v++) {
                    Q += String.fromCharCode(V.charCodeAt(v) - l);
                }
                return Q;
            }
        })
    };

    MyGame = ig.Game.extend({
        lvl: 0,
        levelStat: [],
        showLvlMenu: false,
        storagable: false,
        levelKey: "levelBubble",
        soundKey: "soundBubble",
        musicKey: "musicBubble",
        played: false,
        burstRender: {
            done: false,
            frames: []
        },
        iceRender: {
            done: false,
            frames: []
        },
        burstTextRendered: false,
        burstEndFrame: 48,
        iceEndFrame: 48,
        soundVolume: 1,
        musicVolume: 1,
        redraw: true,
        startPop: false,
        init: function() {
          
                this.hidEle = document.createElement("canvas");
                this.hidCtx = this.hidEle.getContext('2d');
            
            this.hidEle.width = 1200;
            this.hidEle.height = 1600;
            this.bgEle = document.getElementById("bgcanvas");
            this.bgCtx = this.bgEle.getContext('2d');
            this.setupMarketJsGameCenter();
            this.setupControls();
            this.setupLocalStorage();
            this.removeLoadingWheel();
            this.injectMobileLink();
            this.setupURLParameters();
            this.finalize();
            this.storagable = this.checkStorage();
            for (var i = 0; i < 24; i++) {
                this.levelStat.push({
                    star: 0,
                    highScore: 0,
                    unlocked: i == 0 ? true : false,
                });
            }
            if (this.storagable == true) {
                if (localStorage[this.levelKey] == undefined) {
                    ig.game.storage.set(this.levelKey, {
                        levels: this.levelStat
                    });
                } else {
                    this.levelStat = ig.game.storage.get(this.levelKey).levels;
                }
            }
            if (this.storagable == true) {
                ig.game.storage.set(this.levelKey, {
                    levels: this.levelStat
                });
            }
        },
        hide: function() {
      
                var id = 'more-games';
                if (this.divLayerName) id = this.divLayerName;
                var div = document.getElementById(id);
                div.style.visibility = "hidden";
            
            $('#' + id).hide();
        },
        show: function() {
         
                var id = 'more-games';
            
            if (this.divLayerName) id = this.divLayerName;
            var div = document.getElementById(id);
            div.style.visibility = "visible";
            $('#' + id).show();
        },
        setSound: function(volume) {
           this.soundVolume = volume;
       
            Howler.volume(this.soundVolume);
            if (this.storagable == true) {
                ig.game.storage.set(this.soundKey, this.soundVolume);
            }
        },
        getMusic: function() {
           
                var oriVolume = this.musicVolume;
                if (this.storagable == true) {
                    if (ig.game.storage.get(this.musicKey) != undefined) {
                        this.musicVolume = ig.game.storage.get(this.musicKey);
                    } else {}
                }
                if (ig.ua.iOS) {
                    if (oriVolume == 0) {
                        if (this.musicVolume > 0) {
                            ig.soundHandler.playBackgroundMusic();
                        }
                    }
                    if (this.musicVolume == 0) {
                        ig.soundHandler.stopBackgroundMusic();
                    }
                }
          
            if (ig.ua.mobile) {
                ig.soundHandler.jukebox.player.setVolume(this.musicVolume);
            } else {
                ig.music.volume = this.musicVolume;
            }
        },
        getSound: function(volume) {
           
                if (this.storagable == true) {
                    if (ig.game.storage.get(this.soundKey) != undefined) {
                        this.soundVolume = ig.game.storage.get(this.soundKey);
                    } else {}
                }
         
            Howler.volume(this.soundVolume);
        },
        setMusic: function(volume) {
           
                if (ig.ua.iOS) {
                    if (this.musicVolume == 0) {
                        if (volume > 0) {
                            ig.soundHandler.playBackgroundMusic();
                        }
                    }
                    if (volume == 0) {
                        ig.soundHandler.stopBackgroundMusic();
                    }
                }
                this.musicVolume = volume;
                if (ig.ua.mobile) {
                    ig.soundHandler.jukebox.player.setVolume(this.musicVolume);
                } else {
                    ig.music.volume = this.musicVolume;
                }
                if (this.storagable == true) {
                    ig.game.storage.set(this.musicKey, this.musicVolume);
                }
          
        },
        setScore: function() {
            if (this.storagable == true) {
                ig.game.storage.set(this.levelKey, {
                    levels: this.levelStat
                });
            }
        },
        getScore: function() {
            if (this.storagable == true) {
                if (localStorage[this.levelKey] != undefined) {
                    this.levelStat = ig.game.storage.get(this.levelKey).levels;
                }
            }
        },
        checkStorage: function() {
            try {
                localStorage.setItem("test", "test");
                localStorage.removeItem("test");
                return 'localStorage' in window && window['localStorage'] !== null;
            } catch (e) {
                return false;
            }
        },
        setupMarketJsGameCenter: function() {
            if (_SETTINGS) {
                if (_SETTINGS['MarketJSGameCenter']) {
                    if (_SETTINGS['MarketJSGameCenter']['Activator']['Enabled']) {
                        if (_SETTINGS['MarketJSGameCenter']['Activator']['Position']) {
                            console.log('MarketJSGameCenter activator settings present ....');
                            $('.gamecenter-activator').css('top', _SETTINGS['MarketJSGameCenter']['Activator']['Position']['Top']);
                            $('.gamecenter-activator').css('left', _SETTINGS['MarketJSGameCenter']['Activator']['Position']['Left']);
                        }
                    }
                    $('.gamecenter-activator').show();
                } else {
                    console.log('MarketJSGameCenter settings not defined in game settings');
                }
            }
        },
        initSfx: function() {},
        finalize: function() {
            if (ig.ua.mobile) {
                ig.game.showOverlay(['play']);
            } else {
                ig.game.startGame();
            }
            sizeHandler();
        },
        injectMobileLink: function() {
            $('#play').attr('onclick', 'ig.game.pressPlay();ig.soundHandler.staticSound.play();');
        },
        removeLoadingWheel: function() {
            try {
                $('#ajaxbar').css('background', 'none');
            } catch (err) {
                console.log(err);
            }
        },
        showDebugMenu: function() {
            console.log('showing debug menu ...');
            ig.Entity._debugShowBoxes = true;
            $('.ig_debug').show();
        },
        setupLocalStorage: function() {
            this.storage = new ig.Storage();
        },
        startGame: function() {
         
                this.resetPlayerStats();
                if (ig.ua.mobile) {
                    this.director = new ig.Director(this, [LevelOpening, LevelHome, LevelGame, LevelHome]);
                } else {
                    this.director = new ig.Director(this, [LevelOpening, LevelHome, LevelGame, LevelHome]);
                }
                if (_SETTINGS['Branding']['Splash']['Enabled']) {
                    try {
                        this.branding = new ig.BrandingSplash();
                    } catch (err) {
                        console.log(err);
                        console.log('Loading original levels ...');
                        this.director.loadLevel(this.director.currentLevel);
                    }
                } else {
                    this.director.loadLevel(this.director.currentLevel);
                }
                this.spawnEntity(EntityPointerSelector, 50, 50);
                ig.soundHandler.playBackgroundMusic();
            
            this.getSound();
            this.getMusic();
        },
        fpsCount: function() {
            if (!this.fpsTimer) {
                this.fpsTimer = new ig.Timer(1);
            }
            if (this.fpsTimer && this.fpsTimer.delta() < 0) {
                if (this.fpsCounter != null) {
                    this.fpsCounter++;
                } else {
                    this.fpsCounter = 0;
                }
            } else {
                ig.game.fps = this.fpsCounter;
                this.fpsCounter = 0;
                this.fpsTimer.reset();
            }
        },
        endGame: function() {
            console.log('End game');
            ig.soundHandler.stopBackgroundMusic();
            // if (ig.ua.mobile) {
            //     if (_SETTINGS['Ad']['Mobile']['End']['Enabled']) MobileAdInGameEnd.Initialize();
            // }
        },
        resetPlayerStats: function() {
            ig.log('resetting player stats ...');
            this.playerStats = {
                id: this.playerStats ? this.playerStats.id : null,
            };
        },
        setupControls: function() {
            ig.input.unbindAll();
            ig.input.initMouse();
            ig.input.bind(ig.KEY.MOUSE1, 'click');
            ig.input.bind(ig.KEY.B, 'toggle');
        },
        setupURLParameters: function() {
            this.setupURLParameters = new ig.UrlParameters();
        },
        pressPlay: function() {
            this.hideOverlay(['play']);
            this.startGame();
            if (ig.ua.mobile) {
                if (_SETTINGS['Ad']['Mobile']['Footer']['Enabled']) MobileAdInGameFooter.Initialize();
            }
            if (ig.ua.mobile) {
                if (_SETTINGS['Ad']['Mobile']['Header']['Enabled']) MobileAdInGameHeader.Initialize();
            }
        },
        pauseGame: function() {
      
                ig.system.stopRunLoop.call(ig.system);
        
            console.log('Game Paused');
        },
        resumeGame: function() {
            ig.system.startRunLoop.call(ig.system);
            console.log('Game Resumed');
        },
        showOverlay: function(divList) {
            for (i = 0; i < divList.length; i++) {
                if ($('#' + divList[i])) $('#' + divList[i]).show();
                if (document.getElementById(divList[i])) document.getElementById(divList[i]).style.visibility = "visible";
            }
        },
        hideOverlay: function(divList) {
            for (i = 0; i < divList.length; i++) {
                if ($('#' + divList[i])) $('#' + divList[i]).hide();
                if (document.getElementById(divList[i])) document.getElementById(divList[i]).style.visibility = "hidden";
            }
        },
        update: function() {
        
                if (this.paused) {
                    for (var i = 0; i < this.entities.length; i++) {
                        if (this.entities[i].ignorePause) {
                            this.entities[i].update();
                        }
                    }
                } else {
                    this.parent();
                    if (ig.ua.mobile && ig.soundHandler) {
                        ig.soundHandler.forceLoopBGM();
                    }
                }
         
        },
        draw: function() {
            this.stage = ig.game.getEntitiesByType(EntityPlainStage)[0];
            if (this.stage) {
                if (this.stage.tweens.length > 1) {
                    this.redraw = true;
                }
            }
            this.parent();
            if (this.stage) {
                if (this.stage.tweens.length == 0) {
                    ig.game.redraw = false;
                }
            }
        },
        drawDebug: function() {
            if (!ig.global.wm) {
                this.debugEnable();
                if (this.viewDebug) {
                    ig.system.context.fillStyle = '#000000';
                    ig.system.context.globalAlpha = 0.35;
                    ig.system.context.fillRect(0, 0, ig.system.width / 4, ig.system.height);
                    ig.system.context.globalAlpha = 1;
                    if (this.debug && this.debug.length > 0) {
                        for (i = 0; i < this.debug.length; i++) {
                            ig.system.context.font = "10px Arial";
                            ig.system.context.fillStyle = '#ffffff';
                            ig.system.context.fillText(this.debugLine - this.debug.length + i + ": " + this.debug[i], 10, 50 + 10 * i);
                        }
                    }
                }
            }
        },
        debugCL: function(consoleLog) {
            
                if (!this.debug) {
                    this.debug = [];
                    this.debugLine = 1;
                    this.debug.push(consoleLog);
                } else {
                    if (this.debug.length < 50) {
                        this.debug.push(consoleLog);
                    } else {
                        this.debug.splice(0, 1);
                        this.debug.push(consoleLog);
                    }
                    this.debugLine++;
                }
                console.log(consoleLog);
       
        },
        debugEnable: function() {
            if (ig.input.pressed('click')) {
                this.debugEnableTimer = new ig.Timer(2);
            }
            if (this.debugEnableTimer && this.debugEnableTimer.delta() < 0) {
                if (ig.input.released('click')) {
                    this.debugEnableTimer = null;
                }
            } else if (this.debugEnableTimer && this.debugEnableTimer.delta() > 0) {
                this.debugEnableTimer = null;
                if (this.viewDebug) {
                    this.viewDebug = false;
                } else {
                    this.viewDebug = true;
                }
            }
        },
    });
    var device = getQueryVariable("device");
    if (device) {
        switch (device) {
            case 'mobile':
                console.log('serving mobile version ...');
                ig.ua.mobile = true;
                break;
            case 'desktop':
                console.log('serving desktop version ...');
                ig.ua.mobile = false;
                break;
            default:
                console.log('serving universal version ...');
                break;
        }
    } else {
        console.log('serving universal version ...');
    }
    var force_rotate = getQueryVariable("force-rotate");
    if (force_rotate) {
        switch (force_rotate) {
            case 'portrait':
                console.log('force rotate to portrait');
                window.orientation = 0;
                break;
            case 'landscape':
                console.log('force rotate to horizontal');
                window.orientation = 90;
                break;
            default:
                alert('wrong command/type in param force-rotate. Defaulting value to portrait');
                window.orientation = 0;
        }
    }
    if (ig.ua.mobile) {
        ig.Sound.enabled = false;
        ig.main('#canvas', MyGame, 60, mobileWidth, mobileHeight, 1, ig.SplashLoader);
    } else {
        ig.main('#canvas', MyGame, 60, desktopWidth, desktopHeight, 1, ig.SplashLoader);
    }
    if (ig.ua.mobile) {
        orientationHandler();
    }
    sizeHandler();
    fixSamsungHandler();
    Array
});